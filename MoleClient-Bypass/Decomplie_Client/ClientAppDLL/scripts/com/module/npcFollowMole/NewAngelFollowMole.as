package com.module.npcFollowMole
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.module.newAngel.NewAngelManager;
   import com.module.newAngel.info.AngelInfo;
   import com.mole.app.manager.OnlineManager;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.NewAngelModel;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.PlayerActionConstant;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.net.SocketEvent;
   
   public class NewAngelFollowMole
   {
      
      public static var _angelId:int;
      
      private var _id:int;
      
      private var _angelUi:NewAngelModel;
      
      private var _mole:PeopleManageView;
      
      private var _moveEngine:MigrationPath;
      
      private var _moveTimer:Timer;
      
      private var _actionMovie:MovieClip;
      
      private var _dirMC:MovieClip;
      
      private var _clickBtn:TailButtonView;
      
      private var _goHomeBtnLoader:Loader;
      
      private var _cleared:Boolean;
      
      private var dirNum:int;
      
      public function NewAngelFollowMole(angelID:int, angleIndex:int, mole:PeopleManageView)
      {
         super();
         _angelId = angelID;
         this._id = angleIndex;
         this._mole = mole;
         this.LoadAngel();
      }
      
      public function get angelId() : int
      {
         return _angelId;
      }
      
      private function ChangAngelDepth(e:EventTaomee) : void
      {
         var f:Function = e.EventObj as Function;
         if(Boolean(this._angelUi))
         {
            f([this._angelUi]);
         }
      }
      
      private function LoadAngel() : void
      {
         this._cleared = false;
         this.AngelLoadOk();
      }
      
      private function getDirAnimalMC(e:EventTaomee) : void
      {
         this._dirMC = e.EventObj as MovieClip;
      }
      
      private function AngelLoadOk() : void
      {
         var angelInfo:AngelInfo = null;
         if(!this._cleared)
         {
            angelInfo = new AngelInfo();
            angelInfo.angelStaticId = _angelId;
            this._angelUi = new NewAngelModel(angelInfo);
            this._moveEngine = new MigrationPath(this._angelUi);
            GV.MC_Depth.addChild(this._angelUi);
            this._angelUi.x = this._mole.x + 10;
            this._angelUi.y = this._mole.y;
            BC.addEvent(this,GV.onlineSocket,MapDepthManageLogic.ADD_ARRAY,this.ChangAngelDepth);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAngelDir);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_BREAK,this.stopMove);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_NOPATH,this.stopMove);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_OVER,this.stopMove);
            BC.addEvent(this,this._mole,PeopleManageView.ON_GO_START,this.onGoStart);
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Clear);
            this._clickBtn = new TailButtonView("mole_hitBtn");
            this._clickBtn.fineTail3Target(this._angelUi);
            this._clickBtn.buttonMode = true;
            MapButtonView.getTarget().addChild(this._clickBtn);
            BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
         }
      }
      
      private function onTargetMcClick(e:MouseEvent) : void
      {
         NewAngelManager.instance.queryFolloerAngel(this._mole.id,this._id);
      }
      
      private function HomtBtnClickHandler(e:MouseEvent) : void
      {
         this.UnFollow();
      }
      
      public function UnFollow() : void
      {
         GV.onlineSocket.addCmdListener(CommandID.NEW_ANGEL_FOLLOW,this.OnAngelUnFollowOk);
         OnlineManager.send(CommandID.NEW_ANGEL_FOLLOW,this._id,0);
      }
      
      private function OnAngelUnFollowOk(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.NEW_ANGEL_FOLLOW,this.OnAngelUnFollowOk);
         var state:int = int((e.data as ByteArray).readUnsignedInt());
         PeopleManageView(GV.MAN_PEOPLE).AngelUnFollow();
         this.Clear();
      }
      
      private function OnMouseClickStageHandler(e:MouseEvent) : void
      {
         BC.removeEvent(this,MapButtonView.getTarget().stage,MouseEvent.CLICK,this.OnMouseClickStageHandler);
         if(Boolean(this._goHomeBtnLoader) && Boolean(this._goHomeBtnLoader.parent))
         {
            this._goHomeBtnLoader.parent.removeChild(this._goHomeBtnLoader);
            this._goHomeBtnLoader.visible = false;
         }
      }
      
      private function changeAngelDir(e:EventTaomee) : void
      {
         this.dirNum = int(e.EventObj);
         if(!this._angelUi)
         {
            return;
         }
         if(Boolean(this._angelUi))
         {
            this._angelUi.doAction(PlayerActionConstant.ACTION_RUN,this.dirNum);
         }
      }
      
      private function onGoStart(e:Event) : void
      {
         if(!this._moveEngine)
         {
            return;
         }
         var _temp_2:* = this;
         var _temp_1:* = GC;
         with({})
         {
            _temp_2._moveTimer = _temp_1.setGTimeout(function move():void
            {
               var xOffset:* = undefined;
               var moleDirection:* = undefined;
               if(Boolean(_mole) && Boolean(_mole.avatarClass))
               {
                  moleDirection = _mole.avatarClass.DirectionNum;
                  if(moleDirection >= 5 && moleDirection <= 7)
                  {
                     xOffset = -60;
                  }
                  else
                  {
                     xOffset = 65;
                  }
                  if(Boolean(_actionMovie))
                  {
                     _actionMovie.gotoAndStop(2);
                     _actionMovie.play();
                  }
                  _moveEngine.MoveTo(_angelUi.x,_angelUi.y,_mole.endX + xOffset,_mole.endY);
               }
            },500);
         }
         
         private function stopMove(e:Event) : void
         {
            if(Boolean(this._moveEngine))
            {
               this._moveEngine.stopToHere();
            }
            if(Boolean(this._actionMovie))
            {
               this._actionMovie.gotoAndStop(1);
            }
            GC.clearGTimeout(this._moveTimer);
            this._angelUi.doAction(PlayerActionConstant.ACTION_STAND,this.dirNum);
         }
         
         public function Clear(e:Event = null) : void
         {
            try
            {
               this._cleared = true;
               this.stopMove(null);
               BC.removeEvent(this);
               this._angelUi.visible = false;
               GC.clearAll(this._angelUi);
            }
            catch(e:Error)
            {
            }
         }
      }
   }
   
   