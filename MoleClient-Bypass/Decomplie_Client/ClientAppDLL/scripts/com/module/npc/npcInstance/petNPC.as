package com.module.npc.npcInstance
{
   import com.common.Tween.TweenLite;
   import com.common.dialogBox.DialogBox;
   import com.common.dialogBox.IDialogBox;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.UIManager;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.logic.socket.eventSystem.NPCStandingsSocket;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.module.npc.NPCInfo;
   import com.module.npc.dialog.INPCDialog;
   import com.module.npc.dialog.TalkEvent;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import com.view.PeopleView.PeopleManageView;
   import fl.motion.easing.Bounce;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public dynamic class petNPC extends MovieClip implements I_NPC
   {
      
      public static var ON_INSIDE_RANGE:String = "on_inside_range";
      
      public static var ON_OUTSIDE_RANGE:String = "on_outside_range";
      
      protected var boneLoader:Loader;
      
      protected var boneLoaderInfo:LoaderInfo;
      
      protected var LamuLevelMC:MovieClip;
      
      protected var DirAnimalMC:MovieClip;
      
      protected var ActionMC0:MovieClip;
      
      protected var ActionMC1:MovieClip;
      
      protected var ActionMC2:MovieClip;
      
      protected var canMovingRangeMC:DisplayObjectContainer;
      
      protected var inSidePoint:Point;
      
      protected var inSideMC:DisplayObjectContainer;
      
      protected var moveEngine:MigrationPath;
      
      protected var data:AnimalInfo;
      
      protected var _autoMove:Boolean = false;
      
      protected var _speed:uint = 100;
      
      protected var inSideRangeLimit:uint;
      
      public var startX:int;
      
      public var startY:int;
      
      public var standgings:int;
      
      public var _AttitudeLevel:int;
      
      public var times:Number;
      
      public var inSideRange:Boolean = false;
      
      public var outSideRange:Boolean = true;
      
      protected var _isDoAction:Boolean = false;
      
      protected var _isMoveing:Boolean = false;
      
      public var _npcInfo:NPCInfo;
      
      public var _npcDialog:INPCDialog;
      
      protected var _defaultSpeed:uint;
      
      public var layer:String = "FloorLayer";
      
      private var timeMove:Timer;
      
      private var _floatSpeed:Number;
      
      private var dirArray:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      private var actObj:Object;
      
      protected var _floatMoveTime:uint;
      
      protected var _baseMoveTime:uint;
      
      protected var _acedia:uint;
      
      protected var dirNum:uint;
      
      protected var harvestTimer:Timer;
      
      protected var myDialogBox:IDialogBox;
      
      protected var tailBitton:TailButtonView;
      
      protected var showButtonBool:Boolean = true;
      
      public function petNPC(NPC_ID:uint)
      {
         super();
         if(Boolean(NPC_ID))
         {
            this.loadNPC(NPC_ID);
         }
      }
      
      public static function showNPCInstance(NPC_ID:uint, btn:* = null) : I_NPC
      {
         var t:I_NPC = new petNPC(NPC_ID) as I_NPC;
         t.Speed = 50;
         return t;
      }
      
      public function loadNPC(NPC_ID:uint) : void
      {
         var thisObj:petNPC = null;
         this._npcInfo = NPC.getNPCInfo(NPC_ID);
         visible = false;
         this.moveEngine = new MigrationPath(this);
         this.boneLoader = new Loader();
         thisObj = this;
         this.loadBone2();
         this.boneLoaderInfo = this.boneLoader.contentLoaderInfo;
         BC.addEvent(this,this.boneLoader.contentLoaderInfo,IOErrorEvent.IO_ERROR,function(E:IOErrorEvent):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
         });
         BC.addEvent(this,this.boneLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
            onLoaded(E.currentTarget as LoaderInfo);
         });
         try
         {
            this.setMovingRange(MapModelLogic.mapFrame["depth_mc"][this._npcInfo.en_name + "_rect"]);
         }
         catch(E:TypeError)
         {
         }
         this.standgings = 0;
         this.times = ServerUpTime.getInstance().date.valueOf();
         this.addEvent();
         NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_ENTER,this));
      }
      
      public function loadBone2() : void
      {
         var path:String = this._npcInfo.en_name;
         try
         {
            LoaderList.getInstance().addItem(this.boneLoader,VL.getURLRequest("resource/NPC/" + path + ".swf"),LoaderList.HIGH,true);
         }
         catch(E:*)
         {
         }
         NPCStandingsSocket.getNpcStandings(this._npcInfo.id);
         NpcJobSocket.askAllNpcJob(this._npcInfo.id);
      }
      
      public function loadBone(boneURL:String) : void
      {
      }
      
      private function addAttitude(E:TalkEvent) : void
      {
         var thisObj:petNPC = null;
         var num:int = 0;
         thisObj = this;
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "read_" + 1914;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function addAttitudeSure(E:EventTaomee):void
            {
               var _loc2_:MovieClip = null;
               if(E.EventObj.npcID == npcInfo.id)
               {
                  BC.removeEvent(thisObj,GV.onlineSocket,"read_" + 1914);
                  BC.removeEvent(thisObj,GV.onlineSocket,"ERROR_CMD_" + 1914);
                  standgings = E.EventObj.standgings;
                  if(num == 0)
                  {
                     return;
                  }
                  if(num < 0)
                  {
                     _loc2_ = UIManager.getMovieClip("UI004_decline_mc");
                     addChild(_loc2_);
                  }
                  else
                  {
                     _loc2_ = UIManager.getMovieClip("UI004_ascend_mc");
                     addChild(_loc2_);
                  }
                  checkAttitudeLevel();
               }
            });
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + 1914,function(E:EventTaomee):void
            {
               BC.removeEvent(thisObj,GV.onlineSocket,"read_" + 1914);
               BC.removeEvent(thisObj,GV.onlineSocket,"ERROR_CMD_" + 1914);
            });
            NPCStandingsSocket.changeNpcStandings(this._npcInfo.id,num);
         }
         
         private function npcTalkEvent(evt:MouseEvent) : void
         {
            var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
            if(this.inSideRange)
            {
               this.openDialog();
            }
            else
            {
               BC.addEvent(this,this,ON_INSIDE_RANGE,this.onInSideAndOpenDialog);
               if(!(int(x) == int(p.x) && int(y) == int(p.y)))
               {
                  p.moveTo(x,y + 35);
                  if(!p.isMoving)
                  {
                     p.moveTo(x,y);
                  }
               }
            }
            this.showAction("routine");
            this.moveEngine.stopToHere();
         }
         
         public function onInSideAndOpenDialog(E:Event) : void
         {
            var p:PeopleManageView = null;
            BC.removeEvent(this,this,ON_INSIDE_RANGE,this.onInSideAndOpenDialog);
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(Boolean(p))
            {
               setTimeout(function():void
               {
                  p.DelRotation();
                  p.stopAction("up");
               },1000);
               BC.addEvent(this,p,PeopleManageView.ON_GO_START,this.openRotation);
            }
            this.openDialog();
         }
         
         public function openRotation(E:Event) : void
         {
            var p:PeopleManageView = null;
            BC.removeEvent(this,p,PeopleManageView.ON_GO_START,this.openRotation);
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(Boolean(p))
            {
               p.addRotation();
            }
         }
         
         public function openDialog() : void
         {
         }
         
         public function get npcDialog() : INPCDialog
         {
            return this._npcDialog as INPCDialog;
         }
         
         public function getDate() : Date
         {
            return ServerUpTime.getInstance().date;
         }
         
         public function get npcInfo() : NPCInfo
         {
            return this._npcInfo;
         }
         
         private function showNPC(E:EventTaomee) : void
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + 1912,this.showNPC);
            var obj:Object = E.EventObj;
            this.standgings = obj.standgings;
            this.times = obj.times * 1000;
            ServerUpTime.getInstance()["repairTimeFun"](new Date(this.times));
            this.checkCanInside();
         }
         
         private function checkAttitudeLevel() : void
         {
            if(this.standgings <= -61)
            {
               this._AttitudeLevel = -3;
            }
            else if(this.standgings <= -21)
            {
               this._AttitudeLevel = -2;
            }
            else if(this.standgings <= -1)
            {
               this._AttitudeLevel = -1;
            }
            else if(this.standgings <= 10)
            {
               this._AttitudeLevel = 0;
            }
            else if(this.standgings <= 30)
            {
               this._AttitudeLevel = 1;
            }
            else if(this.standgings <= 70)
            {
               this._AttitudeLevel = 2;
            }
            else if(this.standgings <= 130)
            {
               this._AttitudeLevel = 3;
            }
            else
            {
               this._AttitudeLevel = 4;
            }
            this._npcDialog.setAttitudeStatus(this._AttitudeLevel);
         }
         
         protected function checkCanInside() : void
         {
            if(Boolean(this.times) && Boolean(numChildren))
            {
               this.inSideRangeByMC(PeopleManageView(GV.MAN_PEOPLE),50);
               BC.addEvent(this,this,ON_INSIDE_RANGE,this.checkAttitude);
               BC.addEvent(this,this,ON_OUTSIDE_RANGE,this.unCheckAttitude);
            }
         }
         
         private function checkAttitude(E:Event) : void
         {
            this.doAttitudeLevelAction();
         }
         
         public function get AttitudeLevel() : int
         {
            return this._AttitudeLevel;
         }
         
         public function doAttitudeLevelAction() : void
         {
            this.showAction("Attitude_" + this._AttitudeLevel);
         }
         
         private function unCheckAttitude(E:Event) : void
         {
            if(this._AttitudeLevel < -1)
            {
               this.backToMe();
            }
            else
            {
               this.faceToMe();
            }
            this.autoMove = true;
         }
         
         public function set isDoAction(b:Boolean) : void
         {
            this._isDoAction = b;
         }
         
         public function get isDoAction() : Boolean
         {
            return this._isDoAction;
         }
         
         public function set isMoveing(b:Boolean) : void
         {
            this._isMoveing = b;
         }
         
         public function get isMoveing() : Boolean
         {
            return this._isMoveing;
         }
         
         public function backToMe() : void
         {
            var dir:int = int(MigrationPath.getDirection({
               "X":GV.MAN_PEOPLE.x,
               "Y":GV.MAN_PEOPLE.y
            },{
               "X":x,
               "Y":y
            }));
            this.showAction(this.dirArray[dir]);
            this.isDoAction = false;
         }
         
         public function faceToMe() : void
         {
            var dir:int = int(MigrationPath.getDirection({
               "X":x,
               "Y":y
            },{
               "X":GV.MAN_PEOPLE.x,
               "Y":GV.MAN_PEOPLE.y
            }));
            this.showAction(this.dirArray[dir]);
            this.isDoAction = false;
         }
         
         public function onLoaded(_loaderInfo:LoaderInfo) : void
         {
            GV.MC_Depth.addChild(this as DisplayObjectContainer);
            var mc:MovieClip = this.boneLoaderInfo.content as MovieClip;
            var tempMC:MovieClip = mc.getChildAt(0) as MovieClip;
            tempMC.x = 0;
            tempMC.y = 0;
            tempMC.gotoAndStop(1);
            addChild(mc);
            this.checkCanInside();
            var p:Point = this.addToFloor();
            x = p.x;
            y = p.y;
            this.showButton();
            this.autoMove = true;
            visible = true;
            NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_LOADED,this));
            if(!this.DirAnimalMC)
            {
               return;
            }
            this.DirAnimalMC.gotoAndStop("empty");
            this.DirAnimalMC.gotoAndStop(this.dirArray[this.dirNum]);
         }
         
         private function contentAction(E:*) : void
         {
            var obj:Object = E.EventObj;
            dispatchEvent(new EventTaomee(obj.type,obj.data));
         }
         
         public function upAnimalData(animalDataObj:AnimalInfo) : void
         {
         }
         
         public function getAnimalData() : AnimalInfo
         {
            return this.data;
         }
         
         public function FlashMoveToPoint(x:Number, y:Number) : void
         {
         }
         
         public function setMovingRange(mc:DisplayObjectContainer) : void
         {
            this.canMovingRangeMC = mc;
         }
         
         public function inSideRangeByPoint(p:Point, rangeLimit:uint) : void
         {
            this.inSideRangeLimit = rangeLimit;
            this.inSidePoint = p;
            this.inSideMC = null;
         }
         
         public function inSideRangeByMC(mc:DisplayObjectContainer, rangeLimit:uint) : void
         {
            this.inSideRangeLimit = rangeLimit;
            this.inSidePoint = null;
            this.inSideMC = mc;
         }
         
         public function get autoMove() : Boolean
         {
            return this._autoMove;
         }
         
         public function set autoMove(b:Boolean) : void
         {
            this._autoMove = b;
            if(this._autoMove)
            {
               this.checkAutoMove();
            }
            else
            {
               this.stopMove();
            }
         }
         
         public function MoveTo(ex:int, ey:int) : void
         {
            this.moveEngine.MoveTo(x,y,ex,ey);
         }
         
         public function checkAutoMove(E:* = null) : void
         {
            if(this._autoMove && this.outSideRange && !this.isDoAction)
            {
               if(Math.random() > 0.4)
               {
                  GC.clearGTimeout(this.timeMove);
                  this.timeMove = GC.setGTimeout(this.checkAutoMove,1000);
                  return;
               }
               this.addToFloor();
            }
         }
         
         public function addToFloor() : Point
         {
            var hx:int = 0;
            var hy:int = 0;
            var rect:Rectangle = new Rectangle(10,10,940,490);
            if(Boolean(this.canMovingRangeMC) && Boolean(this.canMovingRangeMC.stage))
            {
               rect = this.canMovingRangeMC.getRect(MainManager.getRootMC());
               hx = int(rect.x + rect.width * Math.random());
               hy = int(rect.y + rect.height * Math.random());
               if(this.canMovingRangeMC.hitTestPoint(hx,hy,true) && MoveCondition.hasRoad(hx,hy))
               {
                  if(this._autoMove)
                  {
                     this.moveEngine.MoveTo(x,y,hx,hy);
                  }
                  return new Point(hx,hy);
               }
               return this.addToFloor();
            }
            hx = int(rect.x + rect.width * Math.random());
            hy = int(rect.y + rect.height * Math.random());
            if(MoveCondition.hasRoad(hx,hy))
            {
               if(this._autoMove)
               {
                  this.moveEngine.MoveTo(x,y,hx,hy);
               }
               return new Point(hx,hy);
            }
            return this.addToFloor();
         }
         
         public function get Speed() : int
         {
            return this._speed;
         }
         
         public function set Speed(n:int) : void
         {
            this._speed = n;
            this.moveEngine.speed = this._speed;
         }
         
         public function get MoveEngine() : MigrationPath
         {
            return this.moveEngine;
         }
         
         public function scaleXY(size:Number) : void
         {
            TweenLite.to(this,1,{
               "scaleX":size,
               "scaleY":size,
               "ease":Bounce.easeInOut
            });
         }
         
         public function say(msg:String, delay:uint = 4000) : void
         {
            if(Boolean(this.myDialogBox))
            {
               this.myDialogBox.removeDialogBox();
            }
            this.myDialogBox = DialogBox.showDialogBox(msg,delay);
            this.myDialogBox.setPosXY(0,-48);
            addChild(this.myDialogBox as MovieClip);
         }
         
         public function addEvent() : void
         {
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"getLamuLevelMC",this.getLamuLevelMC);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"getLamuMC",this.getDirAnimalMC);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone0",this.checkChangeStep0);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone1",this.checkChangeStep1);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"petBone2",this.checkChangeStep2);
            BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"action",this.contentAction);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_SET_DEPTH,this.setDepth);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAnimalDir);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_BREAK,this.stopMove);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_NOPATH,this.stopMove);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_OVER,this.stopMove);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_START,this.onGoStart);
            BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_ENTERFRAME,this.onGoStart);
            BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,this.changAnimalDepth);
            if(Boolean(this._npcDialog))
            {
               BC.addEvent(this,this._npcDialog,TalkEvent.CHAT_ADD_ATTITUDE,this.addAttitude);
               BC.addEvent(this,this._npcDialog,TalkEvent.SHOW_FACE,this.showFaceAction);
            }
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
         }
         
         private function checkChangeStep0(E:*) : void
         {
            this.ActionMC0 = E.EventObj as MovieClip;
            if(this.moveEngine.isMoveing || this.isDoAction)
            {
               this.ActionMC0.gotoAndPlay(2);
            }
            else
            {
               this.ActionMC0.gotoAndStop(1);
            }
         }
         
         private function checkChangeStep1(E:*) : void
         {
            this.ActionMC1 = E.EventObj as MovieClip;
            if(this.moveEngine.isMoveing || this.isDoAction)
            {
               this.ActionMC1.gotoAndPlay(2);
            }
            else
            {
               this.ActionMC1.gotoAndStop(1);
            }
         }
         
         private function checkChangeStep2(E:*) : void
         {
            this.ActionMC2 = E.EventObj as MovieClip;
            if(this.moveEngine.isMoveing || this.isDoAction)
            {
               this.ActionMC2.gotoAndPlay(2);
            }
            else
            {
               this.ActionMC2.gotoAndStop(1);
            }
         }
         
         private function showFaceAction(E:TalkEvent) : void
         {
            stop();
            this.showAction(String(E.data));
         }
         
         private function changAnimalDepth(E:EventTaomee) : void
         {
            var f:Function = E.EventObj as Function;
            f([this]);
            this.checkInSideRange();
         }
         
         protected function setDepth(E:EventTaomee = null) : void
         {
            MapDepthManageLogic.setPeopleDepth(this);
            this.checkInSideRange();
            if(Boolean(E))
            {
               dispatchEvent(E);
            }
         }
         
         protected function onGoStart(E:EventTaomee = null) : void
         {
            this.isMoveing = true;
            if(Boolean(E))
            {
               dispatchEvent(E);
            }
         }
         
         protected function stopMove(E:* = null) : void
         {
            if(!this.DirAnimalMC)
            {
               return;
            }
            this.moveEngine.stopToHere();
            this.isMoveing = false;
            if(Boolean(this.ActionMC0))
            {
               this.ActionMC0.gotoAndStop(1);
            }
            if(Boolean(this.ActionMC1))
            {
               this.ActionMC1.gotoAndStop(1);
            }
            if(Boolean(this.ActionMC2))
            {
               this.ActionMC2.gotoAndStop(1);
            }
            this.checkInSideRange();
            if(this._autoMove)
            {
               this.checkAutoMove();
               return;
            }
            if(Boolean(E))
            {
               dispatchEvent(E);
            }
         }
         
         protected function changeAnimalDir(E:*) : void
         {
            this.dirNum = int(E.EventObj);
            if(!this.DirAnimalMC)
            {
               return;
            }
            this.isDoAction = false;
            this.DirAnimalMC.gotoAndStop("empty");
            this.DirAnimalMC.gotoAndStop(this.dirArray[this.dirNum]);
            if(Boolean(E))
            {
               dispatchEvent(E);
            }
         }
         
         public function showAction(act:String) : void
         {
            if(!this.DirAnimalMC)
            {
               return;
            }
            this.stopMove();
            this.isDoAction = true;
            if(Boolean(this.actObj[act]))
            {
               MovieClipUtil.gotoAndStop(this.DirAnimalMC,this.actObj[act]);
            }
            else
            {
               MovieClipUtil.gotoAndStop(this.DirAnimalMC,"routine");
            }
         }
         
         public function closeAutoMove_And_Stop() : void
         {
            this.autoMove = false;
            this.stopMove();
         }
         
         public function getLamuLevelMC(E:*) : void
         {
            this.LamuLevelMC = E.EventObj as MovieClip;
            this.LamuLevelMC.gotoAndStop("level5");
         }
         
         public function getDirAnimalMC(E:*) : void
         {
            var label:FrameLabel = null;
            this.DirAnimalMC = E.EventObj as MovieClip;
            this.actObj = {};
            var labels:Array = this.DirAnimalMC.currentLabels;
            for(var i:uint = 0; i < labels.length; i++)
            {
               label = labels[i];
               this.actObj[label.name] = label.frame;
            }
         }
         
         public function checkInSideRange() : void
         {
            if(Boolean(this.inSideMC) && Point.distance(new Point(x,y),new Point(this.inSideMC.x,this.inSideMC.y)) < this.inSideRangeLimit)
            {
               if(!this.inSideRange)
               {
                  this.inSideRange = true;
                  this.outSideRange = false;
                  dispatchEvent(new Event(ON_INSIDE_RANGE));
               }
            }
            else if(Boolean(this.inSidePoint) && Point.distance(new Point(x,y),new Point(this.inSidePoint.x,this.inSidePoint.y)) < this.inSideRangeLimit)
            {
               if(!this.inSideRange)
               {
                  this.inSideRange = true;
                  this.outSideRange = false;
                  dispatchEvent(new Event(ON_INSIDE_RANGE));
               }
            }
            else if(!this.outSideRange)
            {
               this.outSideRange = true;
               this.inSideRange = false;
               dispatchEvent(new Event(ON_OUTSIDE_RANGE));
            }
         }
         
         public function removeEvent() : void
         {
            BC.removeEvent(this);
         }
         
         public function hideButton() : void
         {
            this.showButtonBool = false;
            if(Boolean(this.tailBitton))
            {
               this.tailBitton.destroy();
               this.tailBitton = null;
            }
         }
         
         public function showButton() : void
         {
            if(!this.showButtonBool)
            {
               this.showButtonBool = true;
               return;
            }
            if(Boolean(this.tailBitton))
            {
               return;
            }
            this.tailBitton = new TailButtonView();
            this.tailBitton.fineTail2Target(this);
            this.tailBitton.buttonMode = true;
            this.tailBitton.x = x;
            this.tailBitton.y = y;
            MapButtonView.getTarget().addChild(this.tailBitton);
            BC.addEvent(this,this.tailBitton,MouseEvent.CLICK,this.npcTalkEvent);
         }
         
         public function clearClass(E:* = null) : void
         {
            BC.removeEvent(this);
            NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_LEAVE,this));
            this.autoMove = false;
            GC.clearGTimeout(this.timeMove);
            if(Boolean(this._npcDialog))
            {
               this._npcDialog["destroy"]();
            }
            if(Boolean(this.myDialogBox))
            {
               this.myDialogBox.removeDialogBox();
            }
            if(Boolean(this.boneLoader))
            {
               this.boneLoader.unload();
            }
            this.boneLoader = null;
            if(Boolean(this.moveEngine))
            {
               this.moveEngine.stopToHere();
            }
            if(Boolean(this.tailBitton))
            {
               this.tailBitton.destroy();
            }
            GC.clearAll(this.tailBitton);
            GC.clearAll(this);
            this.LamuLevelMC = null;
            this.DirAnimalMC = null;
            this.ActionMC0 = null;
            this.ActionMC1 = null;
            this.ActionMC2 = null;
            this.canMovingRangeMC = null;
            this.inSideMC = null;
         }
      }
   }
   
   