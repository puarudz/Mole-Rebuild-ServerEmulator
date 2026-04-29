package com.module.car
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.MovieClipUtil;
   import com.core.car.carInfo.CarInfo;
   import com.event.EventTaomee;
   import com.interfaces.ICarAction;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.car.carAssembly.CarAssembly;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   
   public class Car extends EventDispatcher implements ICarAction
   {
      
      private var moveEngine:PeopleManageView;
      
      private var targetMC:MovieClip;
      
      private var _carBody:MovieClip;
      
      private var info:CarInfo;
      
      private var assembly:CarAssembly;
      
      private var actTimer:Timer;
      
      private var defaultSpeed:int;
      
      private var _speed:int;
      
      private var hasSkid:Boolean = false;
      
      private var hasRevolve:Boolean = false;
      
      private var skidAreaArray:Array = new Array();
      
      private var speedAreaArray:Array = new Array();
      
      private var currentAction:String;
      
      public var currentDirectionNum:uint;
      
      public var dirObj:Object = {};
      
      public function Car()
      {
         super();
         this.dirObj["down"] = 0;
         this.dirObj["leftdown"] = 1;
         this.dirObj["left"] = 2;
         this.dirObj["leftup"] = 3;
         this.dirObj["up"] = 4;
         this.dirObj["rightup"] = 5;
         this.dirObj["right"] = 6;
         this.dirObj["rightdown"] = 7;
      }
      
      public function init() : void
      {
      }
      
      public function driveCar(_moveMC:MovieClip, _targetMC:MovieClip) : void
      {
         this.targetMC = _targetMC;
         this.moveEngine = _moveMC as PeopleManageView;
         this.moveEngine.hasCar = true;
         this.assembly = new CarAssembly();
         BC.addEvent(this,this.assembly,CarAssembly.ON_CAR_CHANGE,this.onCarLoaded);
         this.assembly.getCarView(this.targetMC,this.info);
         this.addEngineEvent();
      }
      
      private function onCarLoaded(E:Event) : void
      {
         var tempMC:MovieClip = null;
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAnimalDir);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_ACTION_DANCE,this.danceHandle);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_ACTION_WAVE,this.waveHandle);
         this.moveEngine.avatarMC.Visualize_mc.visible = false;
         this.moveEngine.avatarMC.pet_mc.visible = true;
         for(var i:uint = 0; i < this.targetMC.numChildren; i++)
         {
            tempMC = DisplayObjectContainer(this.targetMC.getChildAt(i)).getChildAt(0) as MovieClip;
            if(Boolean(tempMC))
            {
               this._carBody = tempMC;
               break;
            }
         }
      }
      
      public function get carBody() : MovieClip
      {
         return this._carBody;
      }
      
      private function addEngineEvent() : void
      {
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_BREAK,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_NOPATH,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_OVER,this.stopMove);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_ACTION_STOP_AFTER,this.stopMove);
      }
      
      private function danceHandle(E:Event) : void
      {
         this.showAction("dance_down");
      }
      
      private function waveHandle(E:Event) : void
      {
         this.showAction("wave_down");
      }
      
      private function changeAnimalDir(E:EventTaomee) : void
      {
         this.currentDirectionNum = this.dirObj[E.EventObj.dir];
         this.showAction(E.EventObj.dir);
      }
      
      private function showAction(tempDirection:String) : void
      {
         if(this.hasSkid)
         {
            return;
         }
         if(!this._carBody)
         {
            return;
         }
         BC.addEvent(this,this._carBody,Event.ADDED,this.playMovieClip);
         MovieClipUtil.gotoAndStop(this._carBody,tempDirection);
      }
      
      private function playMovieClip(E:Event) : void
      {
         var mycurrentFrame:int = 2;
         if(E.target.parent.parent.parent == this.targetMC)
         {
            BC.removeEvent(this,E.currentTarget,Event.ADDED,this.playMovieClip);
            mycurrentFrame = 3;
            if(this.moveEngine.isNewPeople)
            {
               if(this.moveEngine.avatarClass.currentDirection == "dance_down")
               {
                  mycurrentFrame = 15;
               }
            }
            E.target.gotoAndPlay(mycurrentFrame);
         }
      }
      
      public function stopAction(dir:String = "") : void
      {
         this.moveEngine.stopAction(dir);
      }
      
      private function stopAction2() : void
      {
         var tempDirection:String = null;
         tempDirection = this.moveEngine.avatarClass.currentDirection;
         if(!this._carBody)
         {
            return;
         }
         var frameLabel:String = this._carBody.currentLabel;
         MovieClipUtil.gotoAndStop(this._carBody,tempDirection);
      }
      
      private function stopMove(E:Event) : void
      {
         this.hasRevolve = false;
         this.stopAction2();
      }
      
      public function set carInfo(_carInfo:CarInfo) : void
      {
         this.info = _carInfo;
         this.defaultSpeed = GoodsInfo.getInfoById(this.info.ItemID).speed * 100;
         this._speed = this.defaultSpeed;
      }
      
      public function get carInfo() : CarInfo
      {
         return this.info;
      }
      
      public function set speed(speedNum:int) : void
      {
         this._speed = speedNum;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function moveTo(_x:int, _y:int) : void
      {
         this.moveEngine.moveTo(_x,_y);
      }
      
      public function say(msg:String) : void
      {
      }
      
      public function sitDown(dirNum:int = -1) : Boolean
      {
         return true;
      }
      
      public function scaleXY(size:Number) : void
      {
      }
      
      public function wave() : Boolean
      {
         return true;
      }
      
      public function dance() : Boolean
      {
         return true;
      }
      
      public function scaleBody(num:Number = 1.5) : void
      {
      }
      
      public function throwThing(obj:Object) : void
      {
      }
      
      public function revolve(delay:int = 1000) : void
      {
         this.hasRevolve = true;
         this.currentAction = "crash";
         this.showAction(this.currentAction);
         this.currentAction = "";
         if(delay > 0)
         {
            MoveTo.removeMouseEventToStage();
            MoveTo.CanMove = false;
            GC.clearGInterval(this.actTimer);
            this.actTimer = GC.setGTimeout(function():void
            {
               showAction("down");
               MoveTo.addMouseEventToStage();
               MoveTo.CanMove = true;
               hasRevolve = false;
            },delay);
         }
      }
      
      public function setSkidArea(areaDisplayObject:DisplayObjectContainer, speedNum:int = 100, angle:int = -1) : void
      {
         if(!areaDisplayObject)
         {
            throw "區域顯示對象不存在！";
         }
         for(var i:int = 0; i < this.skidAreaArray.length; i++)
         {
            if(this.skidAreaArray[i].area == areaDisplayObject)
            {
               return;
            }
         }
         this.skidAreaArray.push({
            "area":areaDisplayObject,
            "speed":speedNum,
            "angle":angle
         });
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_SET_DEPTH,this.checkHitSkid);
      }
      
      public function checkHitSkid(E:* = null) : void
      {
         var angle:int = 0;
         if(this.hasSkid)
         {
            return;
         }
         var hitIndex:int = this.isHitSkid();
         if(hitIndex >= 0)
         {
            MoveTo.removeMouseEventToStage();
            MoveTo.CanMove = false;
            if(this.skidAreaArray[hitIndex].angle >= 0)
            {
               angle = int(this.skidAreaArray[hitIndex].angle);
            }
            else
            {
               angle = this.getAngle({
                  "X":this.moveEngine.x,
                  "Y":this.moveEngine.y
               },{
                  "X":this.moveEngine.endX,
                  "Y":this.moveEngine.endY
               });
            }
            this.moveEngine.avatarClass.stopToHere();
            this.revolve(0);
            this.hasSkid = true;
            GC.clearGInterval(this.actTimer);
            this.actTimer = GC.setGInterval(this.Skid,41,angle);
            dispatchEvent(new Event(PeopleManageView.ON_ACTION_SKID));
         }
      }
      
      private function Skid(angle:int) : void
      {
         var speed:int = 0;
         var hitIndex:int = this.isHitSkid();
         if(hitIndex >= 0)
         {
            speed = this.skidAreaArray[hitIndex].speed / 24;
            this.moveEngine.x += Math.cos(angle * Math.PI / 180) * speed;
            this.moveEngine.y += Math.sin(angle * Math.PI / 180) * speed;
         }
         else
         {
            this.hasSkid = false;
            GC.clearGInterval(this.actTimer);
            if(this.moveEngine.id == GV.MyInfo_userID)
            {
               GV.onlineClass.walking(int(this.moveEngine.x),int(this.moveEngine.y),GV.MyInfo_userID);
            }
            MoveTo.addMouseEventToStage();
            MoveTo.CanMove = true;
            this.stopAction();
            dispatchEvent(new Event(PeopleManageView.ON_ACTION_SKID_OVER));
         }
      }
      
      private function getAngle(obj1:Object, obj2:Object) : int
      {
         return Math.atan2(obj1.Y - obj2.Y,obj1.X - obj2.X) / Math.PI * 180 + 180;
      }
      
      private function isHitSkid() : int
      {
         for(var i:int = 0; i < this.skidAreaArray.length; i++)
         {
            if(Boolean(this.skidAreaArray[i].area.hitTestPoint(this.moveEngine.x,this.moveEngine.y,true)))
            {
               return i;
            }
         }
         return -1;
      }
      
      public function setGhangeSpeedArea(areaDisplayObject:DisplayObjectContainer, speedNum:int = 100) : void
      {
         if(!areaDisplayObject)
         {
            throw "區域顯示對象不存在！";
         }
         for(var i:int = 0; i < this.speedAreaArray.length; i++)
         {
            if(this.speedAreaArray[i].area == areaDisplayObject)
            {
               return;
            }
         }
         this.speedAreaArray.push({
            "area":areaDisplayObject,
            "speed":speedNum
         });
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_SET_DEPTH,this.checkHitSpeedAreaFun);
      }
      
      private function checkHitSpeedAreaFun(E:*) : void
      {
         var hitIndex:int = this.isHitSpeedArea();
         if(hitIndex >= 0)
         {
            this.speed = this.speedAreaArray[hitIndex].speed;
            this.moveEngine.avatarClass.changSpeed();
         }
         else if(!this.hasSkid)
         {
            this.speed = this.defaultSpeed;
            this.moveEngine.avatarClass.changSpeed();
         }
      }
      
      private function isHitSpeedArea() : int
      {
         for(var i:int = 0; i < this.speedAreaArray.length; i++)
         {
            if(Boolean(this.speedAreaArray[i].area.hitTestPoint(this.moveEngine.x,this.moveEngine.y,true)))
            {
               return i;
            }
         }
         return -1;
      }
      
      public function specialAction(actionXML:XML) : void
      {
      }
      
      public function refreshCar() : void
      {
      }
      
      public function destroy() : void
      {
         GC.clearGInterval(this.actTimer);
         GC.clearAllChildren(this.targetMC);
         BC.removeEvent(this);
         this.moveEngine = null;
         this.targetMC = null;
         this.info = null;
         this.skidAreaArray = [];
         this.speedAreaArray = [];
         this.assembly = null;
         this.hasSkid = false;
         this.hasRevolve = false;
      }
   }
}

