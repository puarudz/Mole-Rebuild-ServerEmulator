package com.module.npcFollowMole
{
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class AngelFollowMole
   {
      
      public static var _angelId:int;
      
      private static const ANGEL_PATH:String = "resource/angelPark/items/swf/";
      
      private static const DIR_ARRAY:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      private var _angelUi:MovieClip;
      
      private var _mole:PeopleManageView;
      
      private var _moveEngine:MigrationPath;
      
      private var _moveTimer:Timer;
      
      private var _contentLoader:LoaderInfo;
      
      private var _actionMovie:MovieClip;
      
      private var _dirMC:MovieClip;
      
      private var _clickBtn:TailButtonView;
      
      private var _goHomeBtnLoader:Loader;
      
      private var _cleared:Boolean;
      
      public function AngelFollowMole(id:int, mole:PeopleManageView)
      {
         super();
         _angelId = id;
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
         var path:String = ANGEL_PATH + _angelId + ".swf";
         trace("gordon ++ " + path);
         var loader:Loader = new Loader();
         this._contentLoader = loader.contentLoaderInfo;
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.AngelLoadOk);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.AngelLoadError);
         loader.load(VL.getURLRequest(path));
      }
      
      private function getDirAnimalMC(e:EventTaomee) : void
      {
         this._dirMC = e.EventObj as MovieClip;
      }
      
      private function AngelLoadError(e:IOErrorEvent) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE,this.AngelLoadOk);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.AngelLoadError);
         throw new Error("天使素材加載錯誤:" + _angelId);
      }
      
      private function AngelLoadOk(e:Event) : void
      {
         var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE,this.AngelLoadOk);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.AngelLoadError);
         if(!this._cleared)
         {
            this._angelUi = loaderInfo.content as MovieClip;
            this._angelUi = this._angelUi.getChildAt(0) as MovieClip;
            this._moveEngine = new MigrationPath(this._angelUi);
            GV.MC_Depth.addChild(this._angelUi);
            this._angelUi.x = this._mole.x + 10;
            this._angelUi.y = this._mole.y;
            BC.addEvent(this,this._angelUi,"moleBone",this.checkChangeStep);
            BC.addEvent(this,this._angelUi,"getAnimalMC",this.getDirAnimalMC);
            BC.addEvent(this,GV.onlineSocket,MapDepthManageLogic.ADD_ARRAY,this.ChangAngelDepth);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAngelDir);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_BREAK,this.stopMove);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_NOPATH,this.stopMove);
            BC.addEvent(this,this._moveEngine,PeopleManageView.ON_GO_OVER,this.stopMove);
            BC.addEvent(this,this._mole,PeopleManageView.ON_GO_START,this.onGoStart);
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.Clear);
            if(this._mole.id == LocalUserInfo.getUserID())
            {
               this._clickBtn = new TailButtonView("mole_hitBtn");
               this._clickBtn.fineTail3Target(this._angelUi);
               this._clickBtn.buttonMode = true;
               MapButtonView.getTarget().addChild(this._clickBtn);
               BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
            }
         }
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
         tip.tipTailDisPlayObject(this._goHomeBtnLoader,"回家");
         BC.addEvent(this,this._goHomeBtnLoader,MouseEvent.CLICK,this.HomtBtnClickHandler);
         BC.addEvent(this,MapButtonView.getTarget().stage,MouseEvent.CLICK,this.OnMouseClickStageHandler,true);
      }
      
      private function HomtBtnClickHandler(e:MouseEvent) : void
      {
         this.UnFollow();
      }
      
      public function UnFollow() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.FollowCmd,this.OnAngelUnFollowOk);
         AngelParkSocket.Follow(_angelId,0);
      }
      
      private function OnAngelUnFollowOk(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.FollowCmd,this.OnAngelUnFollowOk);
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
      
      private function checkChangeStep(e:EventTaomee) : void
      {
         this._actionMovie = e.EventObj as MovieClip;
         if(Boolean(this._moveEngine) && this._moveEngine.isMoveing)
         {
            this._actionMovie.gotoAndPlay(2);
         }
         else
         {
            this._actionMovie.gotoAndStop(1);
         }
      }
      
      private function changeAngelDir(e:EventTaomee) : void
      {
         var dirNum:int = int(e.EventObj);
         if(!this._angelUi)
         {
            return;
         }
         if(Boolean(this._angelUi))
         {
            this._angelUi.gotoAndStop(DIR_ARRAY[dirNum]);
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
                     xOffset = -30;
                  }
                  else
                  {
                     xOffset = 35;
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
   
   