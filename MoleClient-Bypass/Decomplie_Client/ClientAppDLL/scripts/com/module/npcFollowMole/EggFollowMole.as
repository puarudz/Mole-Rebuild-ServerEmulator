package com.module.npcFollowMole
{
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.active.MysEggActivity;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class EggFollowMole
   {
      
      public static var _angelId:int;
      
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
      
      private var cls:Class;
      
      private var tipsTimer:uint;
      
      private var msg:String;
      
      public function EggFollowMole(mole:PeopleManageView)
      {
         super();
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
         var cls:Class = null;
         if(!this._cleared)
         {
            cls = UIManager.getClass("body_egg");
            this._angelUi = new cls();
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
            this._clickBtn = new TailButtonView("mole_hitBtn");
            this._clickBtn.fineTail3Target(this._angelUi);
            this._clickBtn.buttonMode = true;
            MapButtonView.getTarget().addChild(this._clickBtn);
            BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
         }
      }
      
      private function onTargetMcClick(e:MouseEvent) : void
      {
         MysEggActivity.inst.handelClickEgg();
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
         
         public function say(msg:String) : void
         {
            var wordBox:MovieClip;
            var t:uint = 0;
            this.msg = msg;
            wordBox = this._angelUi.getChildByName("wordBox") as MovieClip;
            if(wordBox == null)
            {
               t = setTimeout(function():void
               {
                  var resID:* = DownLoadManager.add("module/external/exeModule/newAngelWordBox.swf",ResType.DISPLAY_OBJECT);
                  DownLoadManager.addEvent(resID,onLoadResOver);
               },3000);
            }
            else
            {
               this.showTips();
               this.tipsTimer = setTimeout(this.showTips,5 * 6 * 1000);
            }
         }
         
         private function onLoadResOver(e:DownLoadEvent) : void
         {
            var mc:MovieClip = e.data as MovieClip;
            this.cls = mc.loaderInfo.applicationDomain.getDefinition("New_Angel_Word_Box") as Class;
            this.addTips();
            if(Boolean(this.tipsTimer))
            {
               clearTimeout(this.tipsTimer);
            }
            this.showTips();
            this.tipsTimer = setTimeout(this.showTips,5 * 6 * 1000);
         }
         
         private function showTips(e:* = null) : void
         {
            var wordBox:MovieClip = this._angelUi.getChildByName("wordBox") as MovieClip;
            if(wordBox != null)
            {
               this.initBox(wordBox,this.msg);
            }
         }
         
         public function clearTips() : void
         {
            clearTimeout(this.tipsTimer);
            var wordBox:MovieClip = this._angelUi.getChildByName("wordBox") as MovieClip;
            if(wordBox != null)
            {
               wordBox.visible = false;
            }
         }
         
         private function initBox(wordBox:MovieClip, msg:String = "") : void
         {
            var t:Timer = null;
            wordBox.visible = true;
            wordBox.showMSG_txt.setTextFormat(new TextFormat(null,14));
            msg = msg.substr(0,20);
            wordBox.visible = true;
            wordBox.showMSG_txt.text = msg;
            wordBox.BG.width = wordBox.showMSG_txt.textWidth + 20;
            wordBox.BG.height = wordBox.showMSG_txt.textHeight + 20;
            wordBox.msgjt_mc.gotoAndStop(1);
            if(wordBox.showMSG_txt.textWidth < 50)
            {
               wordBox.msgjt_mc.gotoAndStop(2);
               wordBox.BG.height = wordBox.showMSG_txt.textHeight + 16;
            }
            t = GC.setGTimeout(function():void
            {
               wordBox.visible = false;
               GC.clearGTimeout(t);
            },15000);
            wordBox.msgjt_mc.x = wordBox.BG.width / 2 + wordBox.BG.width / 10;
            wordBox.msgjt_mc.y = wordBox.BG.height;
            wordBox.x = -wordBox.BG.width / 2;
            wordBox.y = -wordBox.height - 50;
         }
         
         private function addTips() : void
         {
            var wordBox:MovieClip = new this.cls();
            wordBox.name = "wordBox";
            wordBox.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
            wordBox.showMSG_txt.wordWrap = true;
            wordBox.visible = false;
            this._angelUi.addChild(wordBox);
         }
         
         private function removeOriClickEvent() : void
         {
            BC.removeEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
         }
         
         private function addOriClickEvent() : void
         {
            BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onTargetMcClick);
         }
         
         public function addClickEvent() : void
         {
            this.removeOriClickEvent();
            BC.addEvent(this,this._clickBtn,MouseEvent.CLICK,this.onInter6Click);
         }
         
         private function onInter6Click(e:MouseEvent) : void
         {
            this.addOriClickEvent();
            BC.removeEvent(this,this._clickBtn,MouseEvent.CLICK,this.onInter6Click);
            MysEggActivity.inst.playEggSnowMovie();
         }
         
         public function set visible(value:Boolean) : void
         {
            this._angelUi.visible = value;
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
   
   