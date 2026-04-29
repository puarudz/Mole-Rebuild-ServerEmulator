package com.module.dragon
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.interfaces.IDragonAction;
   import com.logic.FindPathLogic.MoveCondition;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.MapManageLogic.MapDepthManageLogic;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.view.PeopleView.ChildPeople.BoyAvatar;
   import com.view.PeopleView.PeopleManageView;
   import com.view.player.ClothConstant;
   import com.view.player.DragonPlayer;
   import com.view.player.MultiEquipPlayer;
   import com.view.player.PlayerActionConstant;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Tick;
   
   public class Dragon extends EventDispatcher implements IDragonAction
   {
      
      private static const TELEPORT_DRAGON_ARR:Array = [1350004,1350037,1350043,1350044,1350009,1350120];
      
      private static const JUMP_DRAGON_ARR:Array = [1350124];
      
      private static var JUMP_FRAME_INFO:HashMap = new HashMap();
      
      private static const JUMP_DISTANCE:Number = 150;
      
      JUMP_FRAME_INFO.add(1350124,{
         "squat":10,
         "squatFrame":5,
         "jumpFrame":14
      });
      
      private var moveEngine:PeopleManageView;
      
      private var targetMC:MovieClip;
      
      private var info:DragonInfo;
      
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
      
      private var _dragonPlayer:DragonPlayer;
      
      private var _inMomentMove:Boolean;
      
      private var nickTxtPosOff:Point;
      
      private var lastPos:Point;
      
      public function Dragon()
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
      
      public function driveDragon(_moveMC:MovieClip, _targetMC:MovieClip) : void
      {
         this.moveEngine = _moveMC as PeopleManageView;
         this.moveEngine.hasDragon = true;
         this.moveEngine.hasDragonType4 = false;
         if(Boolean(this.dragonInfo))
         {
            if(this.dragonInfo.Type == 4)
            {
               this.moveEngine.hasDragonType4 = true;
            }
         }
         this.targetMC = _targetMC;
         this.nickTxtPosOff = new Point();
         if(this.info.Growth >= this.info.GrowthMax)
         {
            this.targetMC.nickName_txt.y = this.info.DragonHeight2 + 12;
            this.nickTxtPosOff.y = this.info.DragonHeight2;
            this.targetMC.pet_mc.y = this.info.DragonHeight2 + 10;
            if(Boolean(this.moveEngine.avatarClass))
            {
               this.moveEngine.avatarClass.speed = this.info.Speed2;
            }
         }
         else
         {
            this.targetMC.nickName_txt.y = this.info.DragonHeight1 + 12;
            this.nickTxtPosOff.y = this.info.DragonHeight1;
            this.targetMC.pet_mc.y = this.info.DragonHeight1 + 10;
            if(Boolean(this.moveEngine.avatarClass))
            {
               this.moveEngine.avatarClass.speed = this.info.Speed1;
            }
         }
         this._dragonPlayer = new DragonPlayer(this.targetMC);
         this._dragonPlayer.addEventListener(Event.COMPLETE,this.onDragonLoaded);
         this._dragonPlayer.dragonInfo = this.info;
      }
      
      private function onDragonLoaded(evt:Event) : void
      {
         this._dragonPlayer.removeEventListener(Event.COMPLETE,this.onDragonLoaded);
         if(this.info.Growth >= this.info.GrowthMax)
         {
            this.targetMC.y = -this.info.DragonHeight2;
         }
         else
         {
            this.targetMC.y = -this.info.DragonHeight1;
         }
         this.moveEngine.sitDown();
         if(Boolean(this.moveEngine.avatarClass.multiEquipPlayer))
         {
            MultiEquipPlayer(this.moveEngine.avatarClass.multiEquipPlayer).updatePlayerPos(ClothConstant.NICK_DECORATION,this.nickTxtPosOff,false);
         }
         this.addEngineEvent();
      }
      
      public function get dragonBody() : Sprite
      {
         return this._dragonPlayer.dragonAPlayer as Sprite;
      }
      
      private function addEngineEvent() : void
      {
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_CHANGE_DIRECTION,this.changeAnimalDir);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_START,this.checkCanFlyFun);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_GO_OVER,this.stopMoveFun);
         BC.addEvent(this,this.moveEngine,PeopleManageView.ON_SET_DEPTH,this.addSnowLongMark);
      }
      
      private function changeAnimalDir(E:EventTaomee) : void
      {
         this.currentDirectionNum = E.currentTarget.avatarClass.DirectionNum;
         this._dragonPlayer.doAction(PlayerActionConstant.ACTION_RUN,this.currentDirectionNum);
      }
      
      private function stopMoveFun(E:*) : void
      {
         this.moveEngine.changeLayer(MapModelLogic.FLOOR_LAYER);
         this.stopMove(E);
         this._inMomentMove = false;
      }
      
      private function checkCanFlyFun(E:*) : void
      {
         var index:int;
         var path:Array = null;
         var len:int = 0;
         var a:Point = null;
         var b:Point = null;
         var cl:BoyAvatar = null;
         var pa:Array = null;
         var t:Timer = null;
         var avatar:BoyAvatar = null;
         if(LocalUserInfo.getMapID() == 166)
         {
            return;
         }
         if(this.info.ItemID == 1350002 && this.info.Growth >= this.info.GrowthMax && Boolean(this.moveEngine.avatarClass))
         {
            path = this.moveEngine.avatarClass.path;
            if(path.length > 2 && MoveCondition.hasRoad(this.moveEngine.endX,this.moveEngine.endY))
            {
               this.moveEngine.avatarClass.path = [path[path.length - 1]];
               this.moveEngine.avatarClass.currentNum = 0;
               this.moveEngine.avatarClass.changSpeed();
               this.moveEngine.changeLayer(MapModelLogic.AIR_LAYER);
            }
         }
         if(Boolean(this.moveEngine.hitBtn))
         {
            this.moveEngine.hitBtn.offsetPoint = new Point(0,this.targetMC.y);
         }
         index = TELEPORT_DRAGON_ARR.indexOf(this.info.ItemID);
         if(index != -1)
         {
            if(this.info.Growth < this.info.GrowthMax)
            {
               return;
            }
            this._inMomentMove = true;
            len = Point.distance(new Point(this.moveEngine.startX,this.moveEngine.startY),new Point(this.moveEngine.endX,this.moveEngine.endY));
            a = new Point(this.moveEngine.startX,this.moveEngine.startY);
            b = new Point(this.moveEngine.endX,this.moveEngine.endY);
            cl = this.moveEngine.avatarClass as BoyAvatar;
            if(Boolean(cl))
            {
               this.moveEngine.stopAction(cl.currentDirection);
               cl.myTween_X.stop();
               cl.myTween_Y.stop();
               this._dragonPlayer.doAction(PlayerActionConstant.ACTION_RUN,cl.DirectionNum);
            }
            pa = [Point.interpolate(a,b,0.9),Point.interpolate(a,b,0.8),Point.interpolate(a,b,0.6),Point.interpolate(a,b,0.3)];
            if(!cl)
            {
               cl = this.moveEngine.avatarClass as BoyAvatar;
            }
            if(Boolean(cl))
            {
               this.moveEngine.visible = false;
               this.moveEngine.stopAction(cl.currentDirection);
               cl.myTween_X.stop();
               cl.myTween_Y.stop();
            }
            t = GC.setGInterval(function():void
            {
               var mc:* = undefined;
               var s:* = undefined;
               var top:* = undefined;
               if(Boolean(moveEngine) && Boolean(moveEngine.parent))
               {
                  if(t.currentCount >= 5)
                  {
                     moveEngine.x = moveEngine.endX;
                     moveEngine.y = moveEngine.endY;
                     moveEngine.isFlying = false;
                     moveEngine.visible = true;
                     if(Boolean(cl))
                     {
                        GC.setGTimeout(cl.goOver,500);
                     }
                  }
                  else
                  {
                     mc = copyBmp(moveEngine,pa[t.currentCount - 1].x,pa[t.currentCount - 1].y);
                     mc.alpha = t.currentCount / 5;
                     mc.mouseEnabled = false;
                     mc.mouseChildren = false;
                     s = new ColorMatrixFilter();
                     s.matrix = [1,0,0,0,-100,0,1,0,0,-100,0,0,1,0,-100,0,0,0,1,0];
                     mc.filters = [s];
                     mc.addEventListener(Event.ENTER_FRAME,function(e:Event):void
                     {
                        mc.alpha -= 0.05;
                        if(mc.alpha <= 0)
                        {
                           GC.clearAll(mc);
                        }
                     });
                     top = moveEngine.parent.parent["top_mc"] as MovieClip;
                     if(!top)
                     {
                        top = new MovieClip();
                        moveEngine.parent.parent["top_mc"] = top;
                        moveEngine.parent.parent.addChild(top);
                     }
                     top.addChild(mc);
                  }
               }
            },"20:5");
         }
         index = JUMP_DRAGON_ARR.indexOf(this.info.ItemID);
         if(index != -1)
         {
            avatar = this.moveEngine.avatarClass as BoyAvatar;
            if(Boolean(avatar))
            {
               this.moveEngine.stopAction(avatar.currentDirection);
               avatar.myTween_X.stop();
               avatar.myTween_Y.stop();
               this._dragonPlayer.doAction(PlayerActionConstant.ACTION_RUN,this.getDirection(new Point(this.moveEngine.x,this.moveEngine.y),new Point(this.moveEngine.endX,this.moveEngine.endY)));
            }
            this.jumpDragonEffect();
         }
      }
      
      public function getDirection(obj1:Point, obj2:Point) : uint
      {
         var myAngle:Number = Math.atan2(obj1.y - obj2.y,obj1.x - obj2.x) / Math.PI * 180 + 180;
         var angle:Number = myAngle + 22.5 + 270;
         return int(angle % 360 / 45);
      }
      
      private function jumpDragonEffect() : void
      {
         if(Boolean(this.lastPos))
         {
            this.targetMC.x = this.lastPos.x;
            this.targetMC.y = this.lastPos.y;
            this.lastPos = null;
         }
         TweenLite.killTweensOf(this.targetMC);
         TweenMax.killAll();
         Tick.instance.removeTimeout(this.jumpDragonEffect);
         Tick.instance.removeTimeout(this.jumpOver);
         Tick.instance.removeTimeout(this.jumpFrameHandler);
         this.lastPos = new Point(this.targetMC.x,this.targetMC.y);
         TweenLite.to(this.targetMC,JUMP_FRAME_INFO.getValue(this.info.ItemID).squatFrame * 30 / 1000,{"y":this.targetMC.y + JUMP_FRAME_INFO.getValue(this.info.ItemID).squat});
         Tick.instance.addTimeout(JUMP_FRAME_INFO.getValue(this.info.ItemID).squatFrame * 33,this.jumpFrameHandler);
      }
      
      private function jumpFrameHandler() : void
      {
         var pos:Point = null;
         var a:Point = new Point(this.moveEngine.x,this.moveEngine.y);
         var b:Point = new Point(this.moveEngine.endX,this.moveEngine.endY);
         this.targetMC.y -= JUMP_FRAME_INFO.getValue(this.info.ItemID).squat;
         this.lastPos = null;
         var len:int = Point.distance(a,new Point(this.moveEngine.endX,this.moveEngine.endY));
         var bezier:Point = new Point();
         if(len > 80)
         {
            pos = Point.interpolate(b,a,80 / len);
            bezier = Point.interpolate(a,pos,0.5);
            TweenMax.to(this.moveEngine,JUMP_FRAME_INFO.getValue(this.info.ItemID).jumpFrame / 30,{
               "x":pos.x,
               "y":pos.y,
               "bezier":[{
                  "x":bezier.x,
                  "y":bezier.y - 80
               }]
            });
            Tick.instance.addTimeout(JUMP_FRAME_INFO.getValue(this.info.ItemID).jumpFrame * 33,this.jumpDragonEffect);
         }
         else
         {
            bezier = Point.interpolate(a,b,0.5);
            TweenMax.to(this.moveEngine,JUMP_FRAME_INFO.getValue(this.info.ItemID).jumpFrame / 30,{
               "x":b.x,
               "y":b.y,
               "bezier":[{
                  "x":bezier.x,
                  "y":bezier.y - 80
               }]
            });
            Tick.instance.addTimeout(JUMP_FRAME_INFO.getValue(this.info.ItemID).jumpFrame * 33,this.jumpOver);
         }
         MapDepthManageLogic.setPeopleDepth(this.moveEngine);
      }
      
      private function jumpOver() : void
      {
         TweenLite.killTweensOf(this.targetMC);
         TweenMax.killAll();
         Tick.instance.removeTimeout(this.jumpDragonEffect);
         Tick.instance.removeTimeout(this.jumpOver);
         this.moveEngine.x = this.moveEngine.endX;
         this.moveEngine.y = this.moveEngine.endY;
         this.moveEngine.isFlying = false;
         this.moveEngine.visible = true;
         var avatar:BoyAvatar = this.moveEngine.avatarClass as BoyAvatar;
         if(Boolean(avatar))
         {
            avatar.goOver();
         }
      }
      
      private function addSnowLongMark(evt:Event) : void
      {
         var tempFootMark:MovieClip = null;
         var tempMarkDirction:uint = 0;
         var mc:MovieClip = null;
         if(this.info.ItemID == 1350045)
         {
            tempFootMark = UIManager.getMovieClip("SnowLong");
            tempMarkDirction = 0;
            tempMarkDirction = this.moveEngine.avatarClass.DirectionNum;
            tempFootMark.gotoAndStop(tempMarkDirction + 1);
            tempFootMark.x = this.moveEngine.x;
            tempFootMark.y = this.moveEngine.y;
            mc = GV.MC_mapFrame;
            if(Boolean(mc))
            {
               mc.addChildAt(tempFootMark,mc.getChildIndex(mc["depth_mc"]) - 1);
            }
         }
      }
      
      private function copyBmp(mc:DisplayObjectContainer, x:Number, y:Number) : Sprite
      {
         var matrix:Matrix = new Matrix();
         var rect:Rectangle = mc.getRect(mc);
         matrix.tx = -rect.x;
         matrix.ty = -rect.y;
         matrix.scale(mc.scaleX,mc.scaleY);
         var w:int = Math.floor(rect.width * mc.scaleX) + 1;
         var h:int = Math.floor(rect.height * mc.scaleY) + 1;
         var bmd:BitmapData = new BitmapData(w,h,true,0);
         bmd.draw(mc,matrix,null,null,new Rectangle(0,0,w,h),true);
         var FairyBMP:Bitmap = new Bitmap(bmd);
         var sd:Sprite = new Sprite();
         sd.addChild(FairyBMP);
         sd.x = x + rect.x;
         sd.y = y + rect.y;
         return sd;
      }
      
      private function momentMoveHandler(evt:Event) : void
      {
         this._dragonPlayer.dragonAPlayer.removeFrameCompleteEvent(this.momentMoveHandler);
         this._dragonPlayer.dragonBPlayer.removeFrameCompleteEvent(this.momentMoveHandler);
         this.moveEngine.x = this.moveEngine.endX;
         this.moveEngine.y = this.moveEngine.endY;
         this.moveEngine.isFlying = false;
         this.moveEngine.visible = true;
         if(Boolean(this.moveEngine.avatarClass))
         {
            this.moveEngine.avatarClass.goOver();
         }
      }
      
      private function showAction(tempDirection:String) : void
      {
         if(this.hasSkid)
         {
            return;
         }
         this._dragonPlayer.doAction(PlayerActionConstant.ACTION_RUN,this.dirObj[tempDirection]);
      }
      
      public function stopAction(dir:String = "") : void
      {
         this.moveEngine.stopAction(dir);
      }
      
      private function stopAction2() : void
      {
         this._dragonPlayer.doAction(PlayerActionConstant.ACTION_STAND,this.currentDirectionNum);
      }
      
      private function stopMove(E:Event) : void
      {
         this.hasRevolve = false;
         this.stopAction2();
      }
      
      public function set dragonInfo(_dragonInfo:DragonInfo) : void
      {
         this.info = _dragonInfo;
         this.defaultSpeed = GoodsInfo.getInfoById(this.info.DragonID).speed * 100;
         this._speed = this.defaultSpeed;
      }
      
      public function get dragonInfo() : DragonInfo
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
      
      public function destroy() : void
      {
         this._dragonPlayer.destroy();
         this._dragonPlayer = null;
         GC.clearGInterval(this.actTimer);
         BC.removeEvent(this);
         this.moveEngine = null;
         this.targetMC = null;
         this.info = null;
         this.skidAreaArray = [];
         this.speedAreaArray = [];
         this.hasSkid = false;
         this.hasRevolve = false;
      }
   }
}

