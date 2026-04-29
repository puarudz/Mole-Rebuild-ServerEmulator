package com.common.scrollBar
{
   import assets.scrollBarMC;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ScrollBar extends EventDispatcher
   {
      
      private static var InstanceArray:Array = new Array();
      
      public static const ENABLE_VISIBLE:String = "visible";
      
      public static const ENABLE_ABATE:String = "abate";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const EVENT_ON_CHANGE:String = "Event_On_Change";
      
      public static const EVENT_ON_SIZE_CHANGE:String = "Event_On_Size_Change";
      
      public var bufferSize:Number;
      
      public var spaceSize:Number;
      
      public var currentSizeInt:int;
      
      private var autoClear:Boolean;
      
      private var scrollTimer:Timer;
      
      private var targetMC:*;
      
      private var scrollMC:*;
      
      private var bg_mc:MovieClip;
      
      private var line_mc:MovieClip;
      
      private var draw_btn:MovieClip;
      
      private var up_btn:SimpleButton;
      
      private var down_btn:SimpleButton;
      
      private var downBool:Boolean;
      
      private var moveTimer:Timer;
      
      private var mask:Shape;
      
      private var offsetNum:Number;
      
      private var width:Number;
      
      private var height:Number;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var targetX:Number;
      
      private var targetY:Number;
      
      private var posType:int;
      
      private var prop:Number;
      
      private var enableType:String;
      
      private var direction:String;
      
      public function ScrollBar(_scrollMC:MovieClip, _targetDisplayObject:*, _height:* = 200, _enableType:String = "visible", _direction:String = "vertical", _spaceSize:Number = 20, _bufferSize:Number = 0)
      {
         super();
         if(Boolean(_targetDisplayObject))
         {
            this.targetMC = _targetDisplayObject;
            if(!_scrollMC)
            {
               this.scrollMC = new scrollBarMC();
               this.autoClear = true;
            }
            else
            {
               this.scrollMC = _scrollMC;
               this.autoClear = false;
            }
            this.enableType = _enableType;
            this.direction = _direction;
            this.bufferSize = _bufferSize;
            this.spaceSize = _spaceSize;
            this.bg_mc = this.scrollMC.bg_mc;
            this.line_mc = this.scrollMC.line_mc;
            this.draw_btn = this.scrollMC.draw_btn;
            this.up_btn = this.scrollMC.up_btn;
            this.down_btn = this.scrollMC.down_btn;
            this.downBool = false;
            this.posType = 0;
            this.currentSizeInt = 0;
            if(this.targetMC is MovieClip || this.targetMC is Sprite)
            {
               this.init(_height);
            }
            return;
         }
         throw new Error("目標不能為空!!");
      }
      
      public function init(obj:*) : void
      {
         var s:String = null;
         var createMask:Shape = null;
         var tempObj:Object = {};
         if(!this.scrollMC.parent)
         {
            this.targetMC.parent.addChild(this.scrollMC);
         }
         var w:Number = 0;
         var h:Number = 0;
         if(typeof obj == "object")
         {
            this.height = Boolean(obj.length) ? Number(obj.length) : 120;
            this.width = Boolean(obj.size) ? Number(obj.size) : 24;
            this.scrollMC.x = Boolean(obj.x) ? obj.x : 0;
            this.scrollMC.y = Boolean(obj.y) ? obj.y : 0;
         }
         else if(typeof obj == "number")
         {
            this.width = 24;
            this.height = obj;
         }
         else
         {
            this.width = 24;
            this.height = 200;
         }
         w = this.width;
         h = this.height;
         this.originX = this.targetMC.x;
         this.originY = this.targetMC.y;
         this.bg_mc.width = w;
         this.draw_btn.width = w;
         this.draw_btn.x = 0;
         this.draw_btn.y = w;
         this.line_mc.width = w;
         this.line_mc.x = 0;
         this.up_btn.width = w;
         this.up_btn.x = 0;
         this.up_btn.y = 0;
         this.up_btn.height = w;
         this.down_btn.width = w;
         this.down_btn.x = 0;
         this.down_btn.height = w;
         this.line_mc.mouseEnabled = false;
         var mix:Number = this.down_btn.height + this.up_btn.height + 8;
         if(h < mix)
         {
            this.draw_btn.height = 4;
            this.down_btn.y = mix;
            this.bg_mc.height = mix;
         }
         else
         {
            this.draw_btn.height = (this.bg_mc.height - mix + 5) / this.targetMC.height * (this.bg_mc.height - mix + 5);
            this.down_btn.y = this.height;
            this.bg_mc.height = h;
         }
         for(s in InstanceArray)
         {
            tempObj = InstanceArray[s];
            if(!tempObj.targetMC.stage || !tempObj.mask.stage)
            {
               InstanceArray.splice(s,1);
            }
         }
         for(s in InstanceArray)
         {
            tempObj = InstanceArray[s];
            if(tempObj.targetMC == this.targetMC)
            {
               createMask = tempObj.mask;
               break;
            }
         }
         if(this.direction == "vertical")
         {
            if(!createMask)
            {
               this.mask = this.createRectangle(0,0,this.scrollMC.x - this.targetMC.x,h);
               this.mask.x = this.targetMC.x;
               this.mask.y = this.targetMC.y;
               this.targetMC.parent.addChild(this.mask);
               this.targetMC.mask = this.mask;
               tempObj.targetMC = this.targetMC;
               tempObj.mask = this.mask;
               tempObj.scrollMC = this.scrollMC;
               tempObj.direction = this.direction;
               InstanceArray.push(tempObj);
            }
            else
            {
               this.mask = createMask;
               this.mask.height = h;
            }
            this.mask.y = this.scrollMC.y;
         }
         else
         {
            this.scrollMC.rotation = -90;
            this.scrollMC.x = this.targetMC.x;
            if(!createMask)
            {
               this.mask = this.createRectangle(0,0,h,this.scrollMC.y - this.targetMC.y - this.width);
               this.mask.x = this.targetMC.x;
               this.mask.y = this.targetMC.y;
               this.targetMC.parent.addChild(this.mask);
               this.targetMC.mask = this.mask;
               tempObj.targetMC = this.targetMC;
               tempObj.mask = this.mask;
               tempObj.scrollMC = this.scrollMC;
               tempObj.direction = this.direction;
               InstanceArray.push(tempObj);
            }
            else
            {
               this.mask = createMask;
               this.mask.width = h;
            }
            this.mask.x = this.scrollMC.x;
         }
         BC.addEvent(this,this.up_btn,MouseEvent.MOUSE_DOWN,this.setup);
         BC.addEvent(this,this.down_btn,MouseEvent.MOUSE_DOWN,this.setdown);
         BC.addEvent(this,this.draw_btn,MouseEvent.MOUSE_DOWN,this.drawBtnDown);
         BC.addEvent(this,this.bg_mc,MouseEvent.MOUSE_DOWN,this.bgBtnDown);
         if(Boolean(this.targetMC.stage))
         {
            BC.addEvent(this,this.targetMC.stage,MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         BC.addEvent(this,this.targetMC,Event.REMOVED_FROM_STAGE,this.clearClass);
         this.moveTimer = new Timer(25,0);
         this.doChange();
      }
      
      public function sendToTop() : void
      {
         if(this.downBool)
         {
            this.posType = 0;
         }
         else
         {
            this.posType = 1;
         }
         this.doChange();
      }
      
      public function sendToBottom() : void
      {
         if(this.downBool)
         {
            this.posType = 0;
         }
         else
         {
            this.posType = 2;
         }
         this.doChange();
      }
      
      public function set visible(bool:Boolean) : void
      {
         this.scrollMC.visible = bool;
      }
      
      public function set alpha(val:Number) : void
      {
         this.scrollMC.alpha = val;
      }
      
      public function get visible() : Boolean
      {
         return this.targetMC.visible;
      }
      
      public function AddupBtn_proxy(hitDisplayObject:*) : void
      {
         BC.addEvent(this,hitDisplayObject,MouseEvent.MOUSE_DOWN,this.setup);
      }
      
      public function DelupBtn_proxy(hitDisplayObject:*) : void
      {
         BC.removeEvent(this,hitDisplayObject,MouseEvent.MOUSE_DOWN,this.setup);
      }
      
      public function AdddownBtn_proxy(hitDisplayObject:*) : void
      {
         BC.addEvent(this,hitDisplayObject,MouseEvent.MOUSE_DOWN,this.setdown);
      }
      
      public function DeldownBtn_proxy(hitDisplayObject:*) : void
      {
         BC.removeEvent(this,hitDisplayObject,MouseEvent.MOUSE_DOWN,this.setdown);
      }
      
      public function checkScrollTimeout(E:Event) : void
      {
         var length:int = this.scrollMC.globalToLocal(new Point(this.targetMC.stage.mouseX,this.targetMC.stage.mouseY)).y - this.draw_btn.y;
         var limit:int = this.spaceSize / 2;
         if(length < limit && length > -limit)
         {
            this.scrollTimeout();
         }
      }
      
      public function scrollTimeout(E:MouseEvent = null) : void
      {
         GC.clearGTimeout(this.scrollTimer);
         BC.removeEvent(this,this.targetMC.stage,MouseEvent.MOUSE_UP,this.scrollTimeout);
         BC.removeEvent(this,this,EVENT_ON_CHANGE,this.checkScrollTimeout);
      }
      
      public function gettargetMC() : *
      {
         return this.targetMC;
      }
      
      public function getScrollMC() : *
      {
         return this.scrollMC;
      }
      
      public function setup(E:*) : void
      {
         var size:Number;
         var currentPosSize:int;
         var addSize:Number;
         var delay:Number = NaN;
         var lenNum:Number = 0;
         if(E is MouseEvent)
         {
            if(E.currentTarget == this.bg_mc)
            {
               lenNum = this.spaceSize * 2;
            }
            else
            {
               lenNum = this.spaceSize;
            }
            delay = lenNum;
            BC.addEvent(this,this.targetMC.stage,MouseEvent.MOUSE_UP,this.scrollTimeout);
            BC.addEvent(this,this,EVENT_ON_CHANGE,this.checkScrollTimeout);
            GC.clearGTimeout(this.scrollTimer);
            this.scrollTimer = GC.setGTimeout(function():*
            {
               scrollTimer = GC.setGInterval(setup,80,delay);
            },400);
         }
         else if(Boolean(E) && E is Number)
         {
            lenNum = E;
         }
         else
         {
            lenNum = this.spaceSize;
         }
         size = Boolean(this.prop) ? this.spaceSize / this.prop : 0;
         currentPosSize = Math.round((this.draw_btn.y - this.width) / size);
         addSize = lenNum / this.spaceSize;
         lenNum = int(currentPosSize - addSize) * size + this.width;
         this.draw_btn.y = lenNum;
         this.checkDrawBtn();
         this.doChange();
      }
      
      public function setdown(E:*) : void
      {
         var size:Number;
         var currentPosSize:int;
         var addSize:Number;
         var delay:Number = NaN;
         var lenNum:Number = 0;
         if(E is MouseEvent)
         {
            if(E.currentTarget == this.bg_mc)
            {
               lenNum = this.spaceSize * 2;
            }
            else
            {
               lenNum = this.spaceSize;
            }
            delay = lenNum;
            BC.addEvent(this,this.targetMC.stage,MouseEvent.MOUSE_UP,this.scrollTimeout);
            BC.addEvent(this,this,EVENT_ON_CHANGE,this.checkScrollTimeout);
            GC.clearGTimeout(this.scrollTimer);
            this.scrollTimer = GC.setGTimeout(function():*
            {
               scrollTimer = GC.setGInterval(setdown,80,delay);
            },400);
         }
         else if(Boolean(E) && E is Number)
         {
            lenNum = E;
         }
         else
         {
            lenNum = this.spaceSize;
         }
         size = Boolean(this.prop) ? this.spaceSize / this.prop : 0;
         currentPosSize = Math.round((this.draw_btn.y - this.width) / size);
         addSize = lenNum / this.spaceSize;
         lenNum = int(currentPosSize + addSize) * size + this.width;
         this.draw_btn.y = lenNum;
         this.checkDrawBtn();
         this.doChange();
      }
      
      public function ScrollToItem(obj:Object) : void
      {
         var childNum:int = 0;
         var childs:Array = null;
         var target:* = undefined;
         var i:int = 0;
         var size:Number = NaN;
         var item:DisplayObject = null;
         var lenNum:Number = 0;
         if(Boolean(obj) && obj.hasOwnProperty("y"))
         {
            childNum = int(this.targetMC.numChildren);
            childs = new Array();
            for(i = 0; i < childNum; i++)
            {
               item = this.targetMC.getChildAt(i);
               childs.push(item);
               if(item == obj)
               {
                  target = item;
               }
            }
            childs.sortOn("y",Array.NUMERIC);
            size = Boolean(this.prop) ? this.spaceSize / this.prop : 0;
            this.draw_btn.y = childs.indexOf(target) * size + this.width;
            this.checkDrawBtn();
            this.doChange();
            return;
         }
      }
      
      public function doChange() : void
      {
         var mix:Number = NaN;
         var mix_height:Number = NaN;
         var mix_width:Number = NaN;
         var minPos:Number = NaN;
         var maxPos:Number = NaN;
         var spaceNum:Number = NaN;
         var oldSizeInt:int = this.currentSizeInt;
         if(this.direction == "vertical")
         {
            this.mask.y = this.scrollMC.y;
            this.mask.height = this.height;
            spaceNum = this.height - this.width * 2;
            mix_height = spaceNum / this.targetMC.height * spaceNum;
            this.draw_btn.height = mix_height > 8 ? mix_height : 8;
            if(this.targetMC.height <= this.height)
            {
               this.prop = 0;
               this.enableScroll(true);
            }
            else
            {
               this.prop = (this.targetMC.height - this.height) / (this.height - this.width * 2 - this.draw_btn.height);
               this.enableScroll(false);
            }
            this.draw_btn.height = this.draw_btn.height > spaceNum ? spaceNum : this.draw_btn.height;
            maxPos = this.height - this.width - this.draw_btn.height;
            minPos = this.width;
            if(this.posType == 1)
            {
               this.draw_btn.y = minPos;
            }
            else if(this.posType == 2)
            {
               this.draw_btn.y = maxPos;
            }
            else
            {
               if(this.draw_btn.y > maxPos)
               {
                  this.draw_btn.y = maxPos;
               }
               if(this.draw_btn.y < minPos)
               {
                  this.draw_btn.y == minPos;
               }
            }
            if(this.bufferSize > 0)
            {
               this.targetY = -(this.draw_btn.y - this.width) * this.prop + this.originY;
               if(!this.moveTimer.running)
               {
                  BC.addEvent(this,this.moveTimer,TimerEvent.TIMER,this.bufferTimerY);
                  this.moveTimer.start();
               }
            }
            else
            {
               this.targetMC.y = -(this.draw_btn.y - this.width) * this.prop + this.originY;
            }
            this.currentSizeInt = int(this.targetMC.y / this.spaceSize);
         }
         else
         {
            this.mask.x = this.scrollMC.x;
            this.mask.width = this.height;
            spaceNum = this.height - this.width * 2;
            mix_width = spaceNum / this.targetMC.width * spaceNum;
            this.draw_btn.height = mix_width > 8 ? mix_width : 8;
            if(this.targetMC.width <= this.height)
            {
               this.prop = 0;
               this.enableScroll(true);
            }
            else
            {
               this.prop = (this.targetMC.width - this.height) / (this.height - this.width * 2 - this.draw_btn.height);
               this.enableScroll(false);
            }
            this.draw_btn.height = this.draw_btn.height > spaceNum ? spaceNum : this.draw_btn.height;
            maxPos = this.height - this.width - this.draw_btn.height;
            minPos = this.width;
            if(this.posType == 1)
            {
               this.draw_btn.y = minPos;
            }
            else if(this.posType == 2)
            {
               this.draw_btn.y = maxPos;
            }
            else
            {
               if(this.draw_btn.y > maxPos)
               {
                  this.draw_btn.y = maxPos;
               }
               if(this.draw_btn.y < minPos)
               {
                  this.draw_btn.y == minPos;
               }
            }
            if(this.bufferSize > 0)
            {
               this.targetX = -(this.draw_btn.y - this.width) * this.prop + this.originX;
               if(!this.moveTimer.running)
               {
                  BC.addEvent(this,this.moveTimer,TimerEvent.TIMER,this.bufferTimerX);
                  this.moveTimer.start();
               }
            }
            else
            {
               this.targetMC.x = -(this.draw_btn.y - this.width) * this.prop + this.originX;
            }
            this.currentSizeInt = int(this.targetMC.x / this.spaceSize);
         }
         this.line_mc.y = int(this.draw_btn.y + this.draw_btn.height / 2);
         this.posType = 0;
         if(this.currentSizeInt != oldSizeInt)
         {
            dispatchEvent(new Event(EVENT_ON_SIZE_CHANGE));
         }
         dispatchEvent(new Event(EVENT_ON_CHANGE));
      }
      
      private function onMouseWheel(E:MouseEvent) : void
      {
         var delta:int = 0;
         var b1:Boolean = Boolean(this.targetMC.hitTestPoint(this.scrollMC.stage.mouseX,this.scrollMC.stage.mouseY,false));
         var b2:Boolean = Boolean(this.scrollMC.hitTestPoint(this.scrollMC.stage.mouseX,this.scrollMC.stage.mouseY,false));
         if(b1 || b2)
         {
            delta = E.delta;
            if(delta > 0)
            {
               this.setup(this.spaceSize);
            }
            else
            {
               this.setdown(this.spaceSize);
            }
         }
      }
      
      private function drawBtnDown(E:MouseEvent) : void
      {
         this.offsetNum = this.scrollMC.globalToLocal(new Point(E.stageX,E.stageY)).y - this.draw_btn.y;
         BC.addEvent(this,this.scrollMC.stage,MouseEvent.MOUSE_MOVE,this.drawBtnMove);
         BC.addEvent(this,this.scrollMC.stage,MouseEvent.MOUSE_UP,this.drawBtnUp);
         this.downBool = true;
         this.doChange();
      }
      
      private function drawBtnMove(E:MouseEvent) : void
      {
         this.draw_btn.y = this.scrollMC.globalToLocal(new Point(E.stageX,E.stageY)).y - this.offsetNum;
         this.checkDrawBtn();
         this.doChange();
      }
      
      private function drawBtnUp(E:MouseEvent) : void
      {
         BC.removeEvent(this,this.scrollMC.stage,MouseEvent.MOUSE_MOVE,this.drawBtnMove);
         BC.removeEvent(this,this.scrollMC.stage,MouseEvent.MOUSE_UP,this.drawBtnUp);
         this.downBool = false;
         this.doChange();
      }
      
      private function bgBtnDown(E:MouseEvent) : void
      {
         if(this.scrollMC.globalToLocal(new Point(E.stageX,E.stageY)).y < this.draw_btn.y)
         {
            this.setup(E);
         }
         else
         {
            this.setdown(E);
         }
      }
      
      private function checkDrawBtn() : void
      {
         var barDown:Number = this.height - this.width - this.draw_btn.height;
         this.draw_btn.y = this.draw_btn.y <= this.width ? this.width : (this.draw_btn.y >= barDown ? barDown : this.draw_btn.y);
      }
      
      private function createRectangle(x:Number, y:Number, _width:Number, _height:Number) : Shape
      {
         var RecShape:Shape = new Shape();
         RecShape.graphics.beginFill(255,0);
         RecShape.graphics.drawRect(x,y,_width,_height);
         RecShape.graphics.endFill();
         return RecShape;
      }
      
      private function enableScroll(bool:Boolean) : void
      {
         if(bool)
         {
            this.scrollMC.mouseChildren = false;
            this.draw_btn.visible = false;
            this.line_mc.visible = false;
            if(this.enableType == "visible")
            {
               this.scrollMC.visible = false;
            }
            else
            {
               this.up_btn.alpha = 0.5;
               this.down_btn.alpha = 0.5;
            }
            this.line_mc.y = this.draw_btn.y + this.width + this.width / 2;
         }
         else
         {
            this.scrollMC.mouseChildren = true;
            this.draw_btn.alpha = 1;
            this.draw_btn.visible = true;
            this.line_mc.visible = true;
            if(this.enableType == "visible")
            {
               this.scrollMC.visible = true;
            }
            else
            {
               this.up_btn.alpha = 1;
               this.down_btn.alpha = 1;
            }
         }
      }
      
      private function bufferTimerX(E:TimerEvent) : void
      {
         var long:Number = this.targetX - this.targetMC.x;
         this.targetMC.x += long / this.bufferSize;
         if(int(long * 3) == 0)
         {
            this.targetMC.x = this.targetX;
            this.moveTimer.stop();
            BC.removeEvent(this,this.moveTimer,TimerEvent.TIMER);
         }
      }
      
      private function bufferTimerY(E:TimerEvent) : void
      {
         var long:Number = this.targetY - this.targetMC.y;
         this.targetMC.y += long / this.bufferSize;
         if(int(long * 3) == 0)
         {
            this.targetMC.y = this.targetY;
            this.moveTimer.stop();
            BC.removeEvent(this,this.moveTimer,TimerEvent.TIMER);
         }
      }
      
      public function clearClass(E:* = null) : void
      {
         var tempObj:Object = null;
         var s:String = null;
         BC.removeEvent(this);
         GC.clearGTimeout(this.scrollTimer);
         for(s in InstanceArray)
         {
            tempObj = InstanceArray[s];
            if(tempObj.targetMC == this.targetMC && tempObj.scrollMC == this.scrollMC)
            {
               if(Boolean(tempObj.mask.parent))
               {
                  tempObj.mask.parent.removeChild(tempObj.mask);
               }
               InstanceArray.splice(s,1);
            }
         }
         if(Boolean(this.autoClear) && Boolean(this.scrollMC) && Boolean(this.scrollMC.parent))
         {
            this.scrollMC.parent.removeChild(this.scrollMC);
         }
         this.targetMC = null;
         this.scrollMC = null;
         this.bg_mc = null;
         this.line_mc = null;
         this.draw_btn = null;
         this.up_btn = null;
         this.down_btn = null;
         this.mask = null;
      }
   }
}

