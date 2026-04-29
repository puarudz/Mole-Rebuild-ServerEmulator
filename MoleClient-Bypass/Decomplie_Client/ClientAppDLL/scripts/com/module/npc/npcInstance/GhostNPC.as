package com.module.npc.npcInstance
{
   import com.common.Tween.TweenLite;
   import com.common.dialogBox.DialogBox;
   import com.common.dialogBox.IDialogBox;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.field.animalInfo.AnimalInfo;
   import com.core.newloader.LoaderList;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MigrationPath;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.MapManageLogic.MapDepthManageLogic;
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
   
   public class GhostNPC extends MovieClip implements I_NPC
   {
      
      public static var ON_INSIDE_RANGE:String = "on_inside_range";
      
      public static var ON_OUTSIDE_RANGE:String = "on_outside_range";
      
      public static var dirArray:Array = ["down","leftdown","left","leftup","up","rightup","right","rightdown"];
      
      protected var targetMC:MovieClip;
      
      protected var boneLoaderInfo:LoaderInfo;
      
      protected var DirAnimalMC:MovieClip;
      
      protected var canMovingRangeMC:DisplayObjectContainer;
      
      protected var inSidePoint:Point;
      
      protected var inSideMC:DisplayObjectContainer;
      
      public var moveEngine:MigrationPath;
      
      protected var data:AnimalInfo;
      
      protected var _aouoMove:Boolean = false;
      
      public var inSideRange:Boolean = false;
      
      public var outSideRange:Boolean = true;
      
      protected var _speed:uint = 100;
      
      protected var inSideRangeLimit:uint;
      
      public var startX:int;
      
      public var startY:int;
      
      protected var _defaultSpeed:uint;
      
      public var layer:String = "FloorLayer";
      
      private var _floatSpeed:Number;
      
      protected var _floatMoveTime:uint;
      
      protected var _baseMoveTime:uint;
      
      protected var _acedia:uint;
      
      protected var dirNum:uint;
      
      protected var harvestTimer:Timer;
      
      protected var myDialogBox:IDialogBox;
      
      public var isDynamic:Boolean = false;
      
      public function GhostNPC(path:String = "ghost")
      {
         var tempLoader:Loader;
         var thisObj:GhostNPC = null;
         super();
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
      }
      
      public function loadNPC(NPC_ID:uint) : void
      {
      }
      
      public function onLoaded(_loaderInfo:LoaderInfo) : void
      {
         var mc:MovieClip = this.boneLoaderInfo.content as MovieClip;
         var tempMC:MovieClip = mc.getChildAt(0) as MovieClip;
         tempMC.x = 0;
         tempMC.y = 0;
         tempMC.gotoAndStop(1);
         addChild(mc);
         GV.MC_Depth.addChild(this as DisplayObjectContainer);
         var p:Point = this.addToFloor();
         x = p.x;
         y = p.y;
         if(!this.DirAnimalMC)
         {
            return;
         }
         MovieClipUtil.gotoAndStop(this.DirAnimalMC,dirArray[this.dirNum]);
      }
      
      public function loadBone(boneURL:String) : void
      {
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
               return new Point(hx,hy);
            }
            return this.addToFloor();
         }
         hx = int(rect.x + rect.width * Math.random());
         hy = int(rect.y + rect.height * Math.random());
         if(MoveCondition.hasRoad(hx,hy))
         {
            return new Point(hx,hy);
         }
         return this.addToFloor();
      }
      
      public function get npcInfo() : NPCInfo
      {
         return null;
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
         this.checkAutoMove();
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
      
      public function showAction(act:String) : void
      {
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
         var mc:MovieClip = E.EventObj as MovieClip;
         if(this.moveEngine.isMoveing)
         {
            mc.gotoAndPlay(2);
         }
         else
         {
            mc.gotoAndStop(1);
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
      
      protected function stopMove(E:EventTaomee = null) : void
      {
         if(this._aouoMove)
         {
            this.checkAutoMove();
            return;
         }
         if(!this.DirAnimalMC)
         {
            return;
         }
         this.moveEngine.stopToHere();
         var cmc:MovieClip = this.DirAnimalMC.getChildAt(0) as MovieClip;
         if(!cmc && this.DirAnimalMC.numChildren > 1)
         {
            cmc = this.DirAnimalMC.getChildAt(1) as MovieClip;
         }
         if(Boolean(cmc))
         {
            cmc.gotoAndStop(1);
         }
         this.checkInSideRange();
      }
      
      protected function changeAnimalDir(E:EventTaomee) : void
      {
         this.dirNum = int(E.EventObj);
         if(!this.DirAnimalMC)
         {
            return;
         }
         MovieClipUtil.gotoAndStop(this.DirAnimalMC,dirArray[this.dirNum]);
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
            this.inSideRange = true;
            this.outSideRange = false;
            dispatchEvent(new Event(ON_INSIDE_RANGE));
         }
         else if(Boolean(this.inSidePoint) && Point.distance(new Point(x,y),new Point(this.inSidePoint.x,this.inSidePoint.y)) < this.inSideRangeLimit)
         {
            this.inSideRange = true;
            this.outSideRange = false;
            dispatchEvent(new Event(ON_INSIDE_RANGE));
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

