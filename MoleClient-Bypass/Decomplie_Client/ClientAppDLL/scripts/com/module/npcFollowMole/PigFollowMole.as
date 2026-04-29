package com.module.npcFollowMole
{
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.PigHouseEntrance;
   import com.module.pig.view.pig.PigMoveCtl;
   import com.module.pig.view.pig.PigView;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PigFollowMole
   {
      
      private var _mole:PeopleManageView;
      
      private var _clickBtn:TailButtonView;
      
      private var _goHomeBtnLoader:Loader;
      
      private var _ui:MovieClip;
      
      private var _pigMoveCtl:PigMoveCtl;
      
      private var _direct:String = PigView.Move_Dir_LeftDown;
      
      private var _pigId:int = 0;
      
      private var _data:Object;
      
      private var _itemID:int;
      
      public function PigFollowMole(data:Object, mole:PeopleManageView)
      {
         super();
         this._data = data;
         if(this._data.hasOwnProperty("pigId") == false)
         {
            this.ChangeDataDefine();
         }
         this._pigId = data.pigId;
         this._itemID = data.itemId;
         this._mole = mole;
         this.LoadPig();
      }
      
      public function get ShowId() : int
      {
         if(this._data.transformId > 0 && this._data.transformTime > 0)
         {
            return this._data.transformId;
         }
         if(Boolean(this._data.dress_1))
         {
            return this._data.dress_1;
         }
         return this._data.itemId;
      }
      
      private function ChangeDataDefine() : void
      {
         this._data.pigId = this._data.NO;
         this._data.itemId = this._data.ID;
         this._data.state = this._data.Flag;
         this._data.transformId = this._data.Value;
         this._data.transformTime = this._data.Eat_time;
         this._data.dress_1 = this._data.Drink_time;
         this._data.dress_2 = this._data.Output_count;
      }
      
      public function get pigId() : int
      {
         return this._pigId;
      }
      
      public function set pigId(value:int) : void
      {
         this._pigId = value;
      }
      
      private function LoadPig() : void
      {
         var uiUrl:String = "resource/pig/swf/" + this.ShowId + ".swf";
         var loader:Loader = new Loader();
         BC.addOnceEvent(this,loader.contentLoaderInfo,Event.COMPLETE,this.LoadOverHandler);
         loader.load(VL.getURLRequest(uiUrl));
      }
      
      private function handler(e:*) : void
      {
         var f:Function = e.EventObj as Function;
         f([this._ui]);
      }
      
      private function LoadOverHandler(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         this._ui = loaderInfo.content as MovieClip;
         this._ui = this._ui.getChildAt(0) as MovieClip;
         this._ui.scaleY = this._ui.scaleX = 0.9;
         if(this._data.state == 0)
         {
            this._ui.scaleY = this._ui.scaleX = 0.7;
         }
         else if(this._data.state == 2)
         {
            this._ui.scaleY = this._ui.scaleX = 1.1;
         }
         GV.MC_mapFrame["depth_mc"].addChild(this._ui);
         BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,this.handler);
         this._pigMoveCtl = new PigMoveCtl(this._ui);
         this._pigMoveCtl.speed = 60;
         this._pigMoveCtl.changeDirFuns.add(this.ChangeDir,true);
         this._pigMoveCtl.stopMoveFuns.add(this.MoveOver,true);
         this._ui.x = this._mole.x + 20;
         this._ui.y = this._mole.y + 10;
         BC.addEvent(this,this._mole,PeopleManageView.ON_GO_START,this.onGoStart);
         if(this._mole.id == LocalUserInfo.getUserID())
         {
            this._clickBtn = new TailButtonView("mole_hitBtn");
            this._clickBtn.fineTail3Target(this._ui);
            this._clickBtn.buttonMode = true;
            MapButtonView.getTarget().addChild(this._clickBtn);
            BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
         }
      }
      
      public function ChangeDir(moveCtl:PigMoveCtl) : void
      {
         var startP:Point = moveCtl.startP;
         var endP:Point = moveCtl.endP;
         if(endP.y > startP.y)
         {
            if(endP.x > startP.x)
            {
               this._direct = PigView.Move_Dir_RightDown;
               this.PlayAction(PigView.Move_Dir_RightDown);
            }
            else
            {
               this._direct = PigView.Move_Dir_LeftDown;
               this.PlayAction(PigView.Move_Dir_LeftDown);
            }
         }
         else if(endP.x > startP.x)
         {
            this._direct = PigView.Move_Dir_RightUp;
            this.PlayAction(PigView.Move_Dir_RightUp);
         }
         else
         {
            this._direct = PigView.Move_Dir_LeftUp;
            this.PlayAction(PigView.Move_Dir_LeftUp);
         }
      }
      
      private function MoveOver(moveCtl:PigMoveCtl) : void
      {
         this.PlayWaitAction();
      }
      
      public function PlayAction(action:String) : void
      {
         this._ui.gotoAndStop(action);
      }
      
      public function PlayWaitAction() : void
      {
         this.PlayAction("待机" + this._direct);
      }
      
      private function onTargetMcClick(e:MouseEvent) : void
      {
         if(this._goHomeBtnLoader == null)
         {
            this._goHomeBtnLoader = new Loader();
            this._goHomeBtnLoader.load(VL.getURLRequest("resource/alertIco/goHome.swf"));
         }
         this._goHomeBtnLoader.visible = true;
         MapButtonView.getTarget().addChild(this._goHomeBtnLoader);
         this._goHomeBtnLoader.x = MapButtonView.getTarget().mouseX + 10;
         this._goHomeBtnLoader.y = MapButtonView.getTarget().mouseY;
         tip.tipTailDisPlayObject(this._goHomeBtnLoader,"回肥肥館");
         BC.addEvent(this,this._goHomeBtnLoader,MouseEvent.CLICK,this.HomtBtnClickHandler);
         BC.addEvent(this,MapButtonView.getTarget().stage,MouseEvent.CLICK,this.OnMouseClickStageHandler,true);
      }
      
      private function HomtBtnClickHandler(e:MouseEvent) : void
      {
         this.UnFollow();
      }
      
      public function UnFollow() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.FollowMoleCmd,this.OnUnFollowOk);
         PigSocket.FollowMole(this._pigId,false);
      }
      
      private function OnUnFollowOk(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + PigSocket.FollowMoleCmd,this.OnUnFollowOk);
         PeopleManageView(GV.MAN_PEOPLE).PigUnFollow();
         this.Clear();
         if(PigHouseEntrance.instance.userId > 0)
         {
            PigSocket.GetPigHouseInfo(PigHouseEntrance.instance.userId);
         }
         else
         {
            PigSocket.GetPigHouseInfo(LocalUserInfo.getUserID());
         }
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
      
      private function onGoStart(e:Event) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      public function Clear(e:Event = null) : void
      {
         try
         {
            BC.removeEvent(this);
            this._pigMoveCtl.stopToHere();
            GC.clearAll(this._ui);
         }
         catch(e:Error)
         {
         }
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
   }
}

