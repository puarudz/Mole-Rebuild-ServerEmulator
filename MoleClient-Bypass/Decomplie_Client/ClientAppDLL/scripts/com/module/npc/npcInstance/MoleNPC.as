package com.module.npc.npcInstance
{
   import com.common.Tween.TweenLite;
   import com.common.dialogBox.DialogBox;
   import com.common.dialogBox.IDialogBox;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.info.ServerUpTime;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.mapEvent.MapEvent;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.module.npc.NPCInfo;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.task.TaskManager;
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
   
   public dynamic class MoleNPC extends MovieClip implements I_NPC
   {
      
      public static var ON_INSIDE_RANGE:String = "on_inside_range";
      
      public static var ON_OUTSIDE_RANGE:String = "on_outside_range";
      
      protected var boneLoaderInfo:LoaderInfo;
      
      protected var DirAnimalMC:MovieClip;
      
      protected var ActionMC:MovieClip;
      
      protected var canMovingRangeMC:DisplayObjectContainer;
      
      protected var inSidePoint:Point;
      
      protected var inSideMC:DisplayObjectContainer;
      
      protected var moveEngine:MigrationPath;
      
      protected var data:AnimalInfo;
      
      protected var _autoMove:Boolean = false;
      
      protected var _speed:uint = 30;
      
      protected var inSideRangeLimit:uint;
      
      public var startX:int;
      
      public var startY:int;
      
      public var standgings:int;
      
      public var _AttitudeLevel:int;
      
      public var times:Number;
      
      public var inSideRange:Boolean = false;
      
      public var outSideRange:Boolean = true;
      
      public var isDoAction:Boolean = false;
      
      private var _npcInfo:NPCInfo;
      
      protected var _defaultSpeed:uint;
      
      public var layer:String = "FloorLayer";
      
      private var timeMove:Timer;
      
      private var _floatSpeed:Number;
      
      private var dirArray:Array;
      
      private var actObj:Object;
      
      protected var _floatMoveTime:uint;
      
      protected var _baseMoveTime:uint;
      
      protected var _acedia:uint;
      
      protected var dirNum:uint;
      
      protected var harvestTimer:Timer;
      
      protected var myDialogBox:IDialogBox;
      
      public var jobItemArr:Array;
      
      protected var tailBitton:TailButtonView;
      
      protected var showButtonBool:Boolean = true;
      
      private var _dialogInfo:NPCDialogInfo;
      
      public function MoleNPC(NPC_ID:uint, checkNpcJob:Boolean = true)
      {
         var path:String;
         var tempLoader:Loader;
         var thisObj:MoleNPC = null;
         this.dirArray = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
         super();
         this.mouseChildren = this.mouseEnabled = false;
         this._npcInfo = NPC.getNPCInfo(NPC_ID);
         path = this._npcInfo.en_name;
         this.name = this._npcInfo.en_name;
         this.visible = false;
         this.moveEngine = new MigrationPath(this);
         this.moveEngine.speed = Boolean(this._npcInfo.movespeed) ? this._npcInfo.movespeed : 50;
         tempLoader = new Loader();
         thisObj = this;
         try
         {
            LoaderList.getInstance().addItem(tempLoader,VL.getURLRequest(Links.getUrl("resource/NPC/" + path + ".swf")),LoaderList.HIGH,true);
         }
         catch(E:*)
         {
         }
         this.boneLoaderInfo = tempLoader.contentLoaderInfo;
         BC.addEvent(this,tempLoader.contentLoaderInfo,IOErrorEvent.IO_ERROR,function(E:IOErrorEvent):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
         });
         BC.addEvent(this,tempLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
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
      
      public static function showNPCInstance(NPC_ID:uint, btn:* = null) : *
      {
         return new MoleNPC(NPC_ID);
      }
      
      public function loadBone(boneURL:String) : void
      {
      }
      
      public function loadNPC(NPC_ID:uint) : void
      {
      }
      
      private function npcTalkEvent(evt:MouseEvent) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Point.distance(new Point(x,y),new Point(p.x,p.y)) < 60)
         {
            this.openDialog();
         }
         else if(!(int(x) == int(p.x) && int(y) == int(p.y)))
         {
            p.moveTo(x,y + 35);
            if(!p.isMoving)
            {
               p.moveTo(x,y);
            }
            BC.addEvent(this,p,PeopleManageView.ON_GO_OVER,this.on_go_over);
         }
         this.showAction("routine");
         this.moveEngine.stopToHere();
      }
      
      public function on_go_over(E:Event = null) : void
      {
         var p:PeopleManageView = null;
         BC.removeEvent(this,p,PeopleManageView.ON_GO_OVER,this.on_go_over);
         p = GV.MAN_PEOPLE as PeopleManageView;
         if(Point.distance(new Point(x,y),new Point(p.x,p.y)) < 60)
         {
            setTimeout(function():void
            {
               p.DelRotation();
               p.stopAction("up");
            },1000);
            BC.addEvent(this,p,PeopleManageView.ON_GO_START,this.openRotation);
            this.openDialog();
         }
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
      
      public function get dialogInfo() : NPCDialogInfo
      {
         return this._dialogInfo;
      }
      
      public function set dialogInfo(value:NPCDialogInfo) : void
      {
         this._dialogInfo = value;
      }
      
      public function openDialog() : void
      {
         var optionList:Array = null;
         var tmpDialogInfo:NPCDialogInfo = null;
         if(Boolean(this._dialogInfo))
         {
            optionList = this._dialogInfo.optionList;
            optionList = TaskManager.clickNpc(this._dialogInfo.id).concat(optionList);
            tmpDialogInfo = new NPCDialogInfo(this._dialogInfo.id,this._dialogInfo.face,this._dialogInfo.msg,optionList,this._dialogInfo.isHideClose);
            NPCDialogManager.say(tmpDialogInfo);
         }
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
         var tempMC:MovieClip = null;
         GV.MC_Depth.addChild(this as DisplayObjectContainer);
         var mc:MovieClip = this.boneLoaderInfo.content as MovieClip;
         tempMC = mc.getChildAt(0) as MovieClip;
         tempMC.x = 0;
         tempMC.y = 0;
         tempMC.gotoAndStop(1);
         addChild(mc);
         var p:Point = this.addToFloor();
         x = p.x;
         y = p.y;
         this.showButton();
         this.autoMove = true;
         this.visible = true;
         NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_LOADED,this));
         if(!this.DirAnimalMC)
         {
            return;
         }
         MovieClipUtil.gotoAndStop(this.DirAnimalMC,this.dirArray[this.dirNum]);
      }
      
      private function contentAction(E:*) : void
      {
         var obj:Object = E.EventObj;
         dispatchEvent(new EventTaomee(obj.type,obj.data));
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
            GC.clearGTimeout(this.timeMove);
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
         BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"getAnimalMC",this.getDirAnimalMC);
         BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"moleBone",this.checkChangeStep);
         BC.addEvent(this,this.boneLoaderInfo.sharedEvents,"action",this.contentAction);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_SET_DEPTH,this.setDepth);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAnimalDir);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_BREAK,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_NOPATH,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_OVER,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_START,this.onGoStart);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_ENTERFRAME,this.onGoStart);
         BC.addEvent(this,GV.onlineSocket,MapDepthManageLogic.ADD_ARRAY,this.changAnimalDepth);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.clearClass);
      }
      
      private function checkChangeStep(E:*) : void
      {
         this.ActionMC = E.EventObj as MovieClip;
         if(this.moveEngine.isMoveing || this.isDoAction)
         {
            this.ActionMC.gotoAndPlay(2);
         }
         else
         {
            this.ActionMC.gotoAndStop(1);
         }
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
         if(Boolean(this.ActionMC))
         {
            this.ActionMC.gotoAndStop(1);
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
      
      protected function changeAnimalDir(E:EventTaomee) : void
      {
         this.dirNum = int(E.EventObj);
         if(!this.DirAnimalMC)
         {
            return;
         }
         this.isDoAction = false;
         MovieClipUtil.gotoAndStop(this.DirAnimalMC,this.dirArray[this.dirNum]);
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
      
      public function getDirAnimalMC(E:Event) : void
      {
         var label:FrameLabel = null;
         if(Boolean(E) && E.hasOwnProperty("EventObj"))
         {
            this.DirAnimalMC = E["EventObj"] as MovieClip;
         }
         else
         {
            this.DirAnimalMC = MovieClip(E.target);
         }
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
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            this.showButton();
         }
         else
         {
            this.hideButton();
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
         this.destroy();
      }
      
      public function destroy() : void
      {
         NPCEvent.dispatchEvent(new NPCEvent(NPCEvent.ON_NPC_LEAVE,this));
         this.autoMove = false;
         GC.clearGTimeout(this.timeMove);
         if(Boolean(this.myDialogBox))
         {
            this.myDialogBox.removeDialogBox();
         }
         GC.clearAll(this);
         DisplayUtil.removeForParent(this.DirAnimalMC);
         BC.removeEvent(this);
      }
   }
}

