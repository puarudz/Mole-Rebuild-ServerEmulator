package com.logic.FindPathLogic
{
   import com.common.Tween.TweenLite;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.view.PeopleView.PeopleManageView;
   import fl.motion.easing.Linear;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public final class MigrationPath extends EventDispatcher
   {
      
      public static var gridSize:uint;
      
      private var _speed:uint;
      
      private var currentNum:uint;
      
      private var DirNum:int;
      
      private var t:TweenLite;
      
      private var path:Array;
      
      private var checkOnGoOver:Timer;
      
      private var setDepthTimer:Timer;
      
      private var _tar_mc:DisplayObjectContainer;
      
      private var startX:int;
      
      private var startY:int;
      
      private var endX:int;
      
      private var endY:int;
      
      private var _isMoveing:Boolean = false;
      
      public function MigrationPath(tar_mc:DisplayObjectContainer, val_2:uint = 100)
      {
         super();
         this._speed = val_2;
         gridSize = MapModelLogic.GridSize;
         this._tar_mc = tar_mc;
      }
      
      public static function getDirection(obj1:Object, obj2:Object) : uint
      {
         var myAngle:Number = Math.atan2(obj1.Y - obj2.Y,obj1.X - obj2.X) / Math.PI * 180 + 180;
         var angle:Number = myAngle + 22.5 + 270;
         return int(angle % 360 / 45);
      }
      
      public function set speed(val:uint) : void
      {
         if(this._speed != val)
         {
            this._speed = val;
            this.changSpeed();
         }
      }
      
      public function get speed() : uint
      {
         return this._speed;
      }
      
      public function MoveTo(sx:int, sy:int, ex:int, ey:int) : void
      {
         if(!this._tar_mc)
         {
            return;
         }
         var pathArray:Array = GV.FindPath.getPath(sx,sy,ex,ey);
         this.gotoHere(pathArray,this._speed);
      }
      
      public function gotoHere(pathArray:Array, delayNum:uint) : void
      {
         if(!this._tar_mc)
         {
            return;
         }
         if(pathArray == null)
         {
            this._isMoveing = false;
            dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_NOPATH));
         }
         else if(pathArray.length > 0)
         {
            GC.clearGInterval(this.setDepthTimer);
            this.setDepthTimer = GC.setGInterval(this.setDepth,300);
            this.path = pathArray;
            this.startX = this.path[0].X * gridSize;
            this.startY = this.path[0].Y * gridSize;
            this.endX = this.path[this.path.length - 1].X * gridSize;
            this.endY = this.path[this.path.length - 1].Y * gridSize;
            this.currentNum = 0;
            this.DirNum = -1;
            this._isMoveing = true;
            dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_START));
            this.nextFun();
         }
      }
      
      private function nextFun() : void
      {
         var obj1:Object = null;
         var obj2:Object = null;
         GC.clearGTimeout(this.checkOnGoOver);
         if(this._speed == 0)
         {
            this.setDepth();
            GC.clearGInterval(this.setDepthTimer);
            this._isMoveing = false;
            dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_OVER));
         }
         else if(Boolean(this.path) && this.currentNum + 1 < this.path.length)
         {
            if(this.currentNum == 0)
            {
               if(this.currentNum + 1 == this.path.length - 1)
               {
                  obj1 = {
                     "X":this.startX,
                     "Y":this.startY
                  };
                  obj2 = {
                     "X":this.endX,
                     "Y":this.endY
                  };
               }
               else
               {
                  obj1 = {
                     "X":this.startX,
                     "Y":this.startY
                  };
                  obj2 = {
                     "X":this.path[this.currentNum + 1].X * gridSize,
                     "Y":this.path[this.currentNum + 1].Y * gridSize
                  };
               }
            }
            else if(this.currentNum == this.path.length - 2)
            {
               obj1 = {
                  "X":this.path[this.currentNum].X * gridSize,
                  "Y":this.path[this.currentNum].Y * gridSize
               };
               obj2 = {
                  "X":this.endX,
                  "Y":this.endY
               };
            }
            else
            {
               obj1 = {
                  "X":this.path[this.currentNum].X * gridSize,
                  "Y":this.path[this.currentNum].Y * gridSize
               };
               obj2 = {
                  "X":this.path[this.currentNum + 1].X * gridSize,
                  "Y":this.path[this.currentNum + 1].Y * gridSize
               };
            }
            this.doMove(obj1,obj2);
            ++this.currentNum;
         }
         else
         {
            this.setDepth();
            GC.clearGInterval(this.setDepthTimer);
            dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_OVER));
         }
      }
      
      private function doMove(a:Object, b:Object) : void
      {
         var td:int = int(getDirection(a,b));
         if(this.DirNum != td)
         {
            this.DirNum = td;
            dispatchEvent(new EventTaomee(PeopleManageView.ON_CHANGE_DIRECTION,td));
         }
         var t1:Number = this.getMoveTimer(a,b);
         var tt:Number = int(t1 * 10) / 10;
         this.t = null;
         if(tt == 0)
         {
            this.nextFun();
         }
         else
         {
            this.t = TweenLite.to(this._tar_mc,tt,{
               "x":b.X,
               "y":b.Y,
               "ease":Linear.easeNone,
               "onComplete":this.nextFun
            });
            GC.clearGTimeout(this.checkOnGoOver);
         }
      }
      
      public function setDepth(E:* = null) : void
      {
         if(!this._tar_mc)
         {
            return;
         }
         dispatchEvent(new EventTaomee(PeopleManageView.ON_SET_DEPTH));
         dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_ENTERFRAME));
      }
      
      private function getMoveTimer(a:Object, b:Object) : Number
      {
         var cc:Number = Point.distance(new Point(a.X,a.Y),new Point(b.X,b.Y));
         var c1:Number = cc / this._speed;
         return c1 < 0.1 ? 0.1 : c1;
      }
      
      public function stopToHere() : void
      {
         GC.clearGTimeout(this.checkOnGoOver);
         GC.clearGInterval(this.setDepthTimer);
         if(Boolean(this.t))
         {
            TweenLite.removeTween(this.t);
            this.path = null;
            this.t = null;
            this._isMoveing = false;
            dispatchEvent(new EventTaomee(PeopleManageView.ON_GO_BREAK));
         }
      }
      
      private function changSpeed() : void
      {
         if(!this.path)
         {
            return;
         }
         var path2:Array = this.path.slice(this.currentNum);
         path2.unshift({
            "X":int(this._tar_mc.x / gridSize),
            "Y":int(this._tar_mc.y / gridSize)
         });
         this.gotoHere(path2,this._speed);
      }
      
      public function get isMoveing() : Boolean
      {
         return this._isMoveing;
      }
   }
}

