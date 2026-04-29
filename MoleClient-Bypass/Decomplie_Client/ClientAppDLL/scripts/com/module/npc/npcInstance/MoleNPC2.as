package com.module.npc.npcInstance
{
   import com.common.Tween.TweenLite;
   import com.common.dialogBox.DialogBox;
   import com.common.dialogBox.IDialogBox;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.socket.eventSystem.NPCStandingsSocket;
   import com.module.npc.I_NPC;
   import com.module.npc.NPCInfo;
   import com.view.PeopleView.PeopleManageView;
   import fl.motion.easing.Bounce;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class MoleNPC2 extends MovieClip implements I_NPC
   {
      
      public static var ON_INSIDE_RANGE:String = "on_inside_range";
      
      public static var ON_OUTSIDE_RANGE:String = "on_outside_range";
      
      protected var targetMC:MovieClip;
      
      protected var boneLoaderInfo:LoaderInfo;
      
      protected var DirAnimalMC:MovieClip;
      
      protected var ActionMC:MovieClip;
      
      protected var canMovingRangeMC:DisplayObjectContainer;
      
      protected var inSidePoint:Point;
      
      protected var inSideMC:DisplayObjectContainer;
      
      protected var moveEngine:MigrationPath;
      
      protected var data:AnimalInfo;
      
      protected var _aouoMove:Boolean = false;
      
      protected var _speed:uint = 100;
      
      protected var inSideRangeLimit:uint;
      
      public var startX:int;
      
      public var startY:int;
      
      public var standgings:int;
      
      public var AttitudeLevel:int;
      
      public var times:Number;
      
      public var inSideRange:Boolean = false;
      
      public var outSideRange:Boolean = false;
      
      public var isDoAction:Boolean = false;
      
      protected var _defaultSpeed:uint;
      
      public var layer:String = "FloorLayer";
      
      private var timeMove:Timer;
      
      private var _floatSpeed:Number;
      
      private var dirArray:Array;
      
      protected var _floatMoveTime:uint;
      
      protected var _baseMoveTime:uint;
      
      protected var _acedia:uint;
      
      protected var dirNum:uint;
      
      protected var harvestTimer:Timer;
      
      protected var myDialogBox:IDialogBox;
      
      public function MoleNPC2(NPC_ID:uint)
      {
         var tempLoader:Loader;
         var path:String = null;
         var thisObj:MoleNPC2 = null;
         this.dirArray = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
         super();
         if(NPC_ID == 0)
         {
            path = "yoyo";
         }
         else if(NPC_ID == 1)
         {
            path = "mason";
         }
         this.moveEngine = new MigrationPath(this);
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
         this.addEvent();
         BC.addEvent(this,tempLoader.contentLoaderInfo,IOErrorEvent.IO_ERROR,function(E:IOErrorEvent):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
         });
         BC.addEvent(this,tempLoader.contentLoaderInfo,Event.INIT,function(E:Event):void
         {
            BC.removeEvent(thisObj,E.currentTarget);
            onLoaded(E.currentTarget as LoaderInfo);
         });
         BC.addEvent(this,GV.onlineSocket,"read_" + 1912,this.showNPC);
         NPCStandingsSocket.getNpcStandings(NPC_ID);
      }
      
      public function loadNPC(NPC_ID:uint) : void
      {
      }
      
      public function loadBone(boneURL:String) : void
      {
      }
      
      public function getDate() : Date
      {
         return new Date(this.times);
      }
      
      public function get npcInfo() : NPCInfo
      {
         return null;
      }
      
      private function showNPC(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1912,this.showNPC);
         var obj:Object = E.EventObj;
         this.standgings = obj.standgings;
         if(this.standgings <= -61)
         {
            this.AttitudeLevel = -3;
         }
         else if(this.standgings <= -21)
         {
            this.AttitudeLevel = -2;
         }
         else if(this.standgings <= -1)
         {
            this.AttitudeLevel = -1;
         }
         else if(this.standgings <= 10)
         {
            this.AttitudeLevel = 0;
         }
         else if(this.standgings <= 30)
         {
            this.AttitudeLevel = 1;
         }
         else if(this.standgings <= 70)
         {
            this.AttitudeLevel = 2;
         }
         else if(this.standgings <= 130)
         {
            this.AttitudeLevel = 3;
         }
         else
         {
            this.AttitudeLevel = 4;
         }
         this.times = obj.times * 1000;
         trace(this.getDate());
         this.checkCanInside();
      }
      
      private function checkCanInside() : void
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
         this.autoMove = false;
         this.showAction("Attitude_" + this.AttitudeLevel);
      }
      
      private function unCheckAttitude(E:Event) : void
      {
         this.autoMove = true;
      }
      
      public function onLoaded(_loaderInfo:LoaderInfo) : void
      {
         var mc:MovieClip = null;
         var tempMC:MovieClip = null;
         mc = this.boneLoaderInfo.content as MovieClip;
         tempMC = mc.getChildAt(0) as MovieClip;
         tempMC.x = 0;
         tempMC.y = 0;
         tempMC.gotoAndStop(1);
         addChild(mc);
         this.checkCanInside();
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
      
      public function init(_targetMC:MovieClip) : void
      {
         this.moveEngine = new MigrationPath(this);
         this.addEvent();
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
         return this._aouoMove;
      }
      
      public function set autoMove(b:Boolean) : void
      {
         this._aouoMove = b;
         if(this._aouoMove)
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
         var hx:int = 0;
         var hy:int = 0;
         var rect:Rectangle = null;
         if(this._aouoMove)
         {
            if(Math.random() > 0.4)
            {
               GC.clearGTimeout(this.timeMove);
               this.timeMove = GC.setGTimeout(this.checkAutoMove,1000);
               return;
            }
            rect = new Rectangle(0,0,960,560);
            if(Boolean(this.canMovingRangeMC) && Boolean(this.canMovingRangeMC.stage))
            {
               rect = this.canMovingRangeMC.getRect(MainManager.getRootMC());
               hx = int(rect.x + rect.width * Math.random());
               hy = int(rect.y + rect.height * Math.random());
               if(this.canMovingRangeMC.hitTestPoint(hx,hy,true) && MoveCondition.hasRoad(hx,hy))
               {
                  this.moveEngine.MoveTo(x,y,hx,hy);
               }
               else
               {
                  this.checkAutoMove();
               }
            }
            else
            {
               hx = int(rect.x + rect.width * Math.random());
               hy = int(rect.y + rect.height * Math.random());
               if(MoveCondition.hasRoad(hx,hy))
               {
                  this.moveEngine.MoveTo(x,y,hx,hy);
               }
               else
               {
                  this.checkAutoMove();
               }
            }
         }
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
         if(!this.targetMC)
         {
            return;
         }
         TweenLite.to(this.targetMC,1,{
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
         BC.addEvent(this,MapDepthManageLogic.owner,MapDepthManageLogic.ADD_ARRAY,this.changAnimalDepth);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
      }
      
      private function checkChangeStep(E:EventTaomee) : void
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
         if(this._aouoMove)
         {
            this.checkAutoMove();
            return;
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
         this.DirAnimalMC.gotoAndStop("empty");
         this.DirAnimalMC.gotoAndStop(this.dirArray[this.dirNum]);
      }
      
      public function showAction(act:String) : void
      {
         if(!this.DirAnimalMC)
         {
            return;
         }
         this.isDoAction = true;
         this.DirAnimalMC.gotoAndStop("empty");
         this.DirAnimalMC.gotoAndStop(act);
      }
      
      public function closeAutoMove_And_Stop() : void
      {
         this.autoMove = false;
         this.stopMove();
      }
      
      public function getDirAnimalMC(E:*) : void
      {
         this.DirAnimalMC = E.EventObj as MovieClip;
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
         this.targetMC.buttonMode = false;
         BC.removeEvent(this);
         BC.addEvent(this,this.targetMC,"getAnimalMC",this.getDirAnimalMC);
      }
      
      public function hideButton() : void
      {
      }
      
      public function showButton() : void
      {
      }
      
      public function clearClass(E:* = null) : void
      {
         GC.clearGTimeout(this.timeMove);
         if(Boolean(this.targetMC) && Boolean(this.targetMC.parent))
         {
            this.targetMC.parent.removeChild(this.targetMC);
         }
         if(Boolean(this.myDialogBox))
         {
            this.myDialogBox.removeDialogBox();
         }
         this.targetMC = null;
         this.DirAnimalMC = null;
         BC.removeEvent(this);
      }
   }
}

