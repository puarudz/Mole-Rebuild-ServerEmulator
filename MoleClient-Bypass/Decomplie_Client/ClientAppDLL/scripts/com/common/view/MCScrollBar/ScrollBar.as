package com.common.view.MCScrollBar
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class ScrollBar extends MovieClip
   {
      
      public var scroll_mc:*;
      
      public var target_mc:*;
      
      public var mask_width:Number;
      
      public var mask_height:Number;
      
      private var oldY:Number;
      
      private var dragTimer:Timer;
      
      private var btnTimer:Timer;
      
      private var moveDistance:int;
      
      private var isAction:Boolean;
      
      public function ScrollBar(scrollBarMC:*, targetMC:*, target_width:Number, target_height:Number)
      {
         super();
         this.scroll_mc = scrollBarMC;
         this.target_mc = targetMC;
         this.mask_width = target_width;
         this.mask_height = target_height;
         this.dragTimer = new Timer(50,0);
         this.dragTimer.addEventListener(TimerEvent.TIMER,this.changPosition,false,0,true);
         this.btnTimer = new Timer(50,0);
         this.btnTimer.addEventListener(TimerEvent.TIMER,this.moveDragMC);
         this.scroll_mc.up_btn.useHandCursor = false;
         this.scroll_mc.down_btn.useHandCursor = false;
         this.scroll_mc.line_mc.mouseEnabled = false;
         this.scroll_mc.drag_mc.addEventListener(MouseEvent.MOUSE_OVER,this.overDragHandler,false,0,true);
         this.scroll_mc.drag_mc.addEventListener(MouseEvent.MOUSE_OUT,this.outDragHandler,false,0,true);
         this.scroll_mc.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.downDragHandler,false,0,true);
         this.scroll_mc.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.moveDragHandler,false,0,true);
         if(this.scroll_mc.stage != null)
         {
            this.scroll_mc.stage.addEventListener(MouseEvent.MOUSE_UP,this.upDragHandler,false,0,true);
         }
         this.scroll_mc.drag_mc.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelHandler);
         this.target_mc.addEventListener(MouseEvent.MOUSE_WHEEL,this.wheelHandler);
         this.scroll_mc.up_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.downUpBtnHandler,false,0,true);
         this.scroll_mc.up_btn.addEventListener(MouseEvent.MOUSE_UP,this.upUpBtnHandler,false,0,true);
         this.scroll_mc.down_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.downDownBtnHandler,false,0,true);
         this.scroll_mc.down_btn.addEventListener(MouseEvent.MOUSE_UP,this.upDownBtnHandler,false,0,true);
         this.initSetBar();
      }
      
      private function initSetBar() : void
      {
         this.oldY = this.target_mc.y;
         var tempSprite:Shape = new Shape();
         tempSprite.graphics.beginFill(16763904);
         tempSprite.graphics.drawRect(0,0,this.mask_width,this.mask_height);
         tempSprite.x = this.target_mc.x;
         tempSprite.y = this.target_mc.y;
         this.target_mc.parent.addChild(tempSprite);
         this.target_mc.mask = tempSprite;
         this.reSet();
      }
      
      public function reSet() : void
      {
         this.scroll_mc.bg_mc.height = this.mask_height;
         this.scroll_mc.down_btn.y = this.mask_height;
         this.scroll_mc.drag_mc.y = this.scroll_mc.down_btn.height;
         this.scroll_mc.drag_mc.height = this.mask_height / this.target_mc.height * (this.mask_height - 2 * this.scroll_mc.down_btn.height);
         this.moveDistance = this.mask_height - 2 * this.scroll_mc.down_btn.height - this.scroll_mc.drag_mc.height;
         this.scroll_mc.line_mc.y = this.scroll_mc.drag_mc.y + (this.scroll_mc.drag_mc.height - this.scroll_mc.line_mc.height) / 2;
         if(this.mask_height >= this.target_mc.height)
         {
            this.useScrollBar_false();
         }
         else
         {
            this.userScrollBar_true();
            this.selectY();
         }
      }
      
      private function selectY() : void
      {
         this.scroll_mc.drag_mc.y = this.scroll_mc.down_btn.height + this.moveDistance;
         this.changPosition();
      }
      
      private function useScrollBar_false() : void
      {
         this.scroll_mc.drag_mc.visible = false;
         this.scroll_mc.line_mc.visible = false;
         this.scroll_mc.up_btn.mouseEnabled = false;
         this.scroll_mc.down_btn.mouseEnabled = false;
      }
      
      private function userScrollBar_true() : void
      {
         this.scroll_mc.drag_mc.visible = true;
         this.scroll_mc.line_mc.visible = true;
         this.scroll_mc.up_btn.mouseEnabled = true;
         this.scroll_mc.down_btn.mouseEnabled = true;
      }
      
      private function changPosition(evt:TimerEvent = null) : void
      {
         this.scroll_mc.line_mc.y = this.scroll_mc.drag_mc.y + (this.scroll_mc.drag_mc.height - this.scroll_mc.line_mc.height) / 2;
         this.target_mc.y = this.oldY - (this.scroll_mc.drag_mc.y - this.scroll_mc.down_btn.height) / this.moveDistance * (this.target_mc.height - this.mask_height);
      }
      
      public function moveDragMC(evt:TimerEvent = null) : void
      {
         var dir:int = this.isAction ? -2 : 2;
         if(this.scroll_mc.drag_mc.y + 2 * dir < this.scroll_mc.down_btn.height)
         {
            this.scroll_mc.drag_mc.y = this.scroll_mc.down_btn.height;
         }
         else if(this.scroll_mc.drag_mc.y + 2 * dir > this.moveDistance + this.scroll_mc.down_btn.height)
         {
            this.scroll_mc.drag_mc.y = this.moveDistance + this.scroll_mc.down_btn.height;
         }
         else
         {
            this.scroll_mc.drag_mc.y += 2 * dir;
         }
         this.changPosition();
      }
      
      public function outDragHandler(evt:MouseEvent) : void
      {
         evt.target.gotoAndStop(1);
      }
      
      public function moveDragHandler(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      public function overDragHandler(evt:MouseEvent) : void
      {
         evt.target.gotoAndStop(2);
      }
      
      public function downDragHandler(evt:MouseEvent) : void
      {
         evt.target.startDrag(false,new Rectangle(4.7,this.scroll_mc.down_btn.height,0,this.moveDistance));
         this.dragTimer.start();
      }
      
      public function upDragHandler(evt:MouseEvent) : void
      {
         this.scroll_mc.drag_mc.stopDrag();
         this.dragTimer.stop();
      }
      
      public function downUpBtnHandler(evt:MouseEvent) : void
      {
         this.isAction = true;
         this.btnTimer.start();
      }
      
      public function upUpBtnHandler(evt:MouseEvent) : void
      {
         this.btnTimer.stop();
      }
      
      public function downDownBtnHandler(evt:MouseEvent) : void
      {
         this.isAction = false;
         this.btnTimer.start();
      }
      
      public function upDownBtnHandler(evt:MouseEvent) : void
      {
         this.btnTimer.stop();
      }
      
      public function wheelHandler(evt:MouseEvent) : void
      {
         if(evt.delta == 6)
         {
            this.isAction = true;
            this.moveDragMC();
         }
         else
         {
            this.isAction = false;
            this.moveDragMC();
         }
      }
      
      private function removeHandler(evt:Event) : void
      {
         this.removeFun();
      }
      
      public function removeFun() : void
      {
         this.dragTimer.stop();
         this.dragTimer.removeEventListener(TimerEvent.TIMER,this.changPosition);
         this.btnTimer.stop();
         this.btnTimer.removeEventListener(TimerEvent.TIMER,this.moveDragMC);
         if(this.scroll_mc.stage != null)
         {
            this.scroll_mc.stage.removeEventListener(MouseEvent.MOUSE_UP,this.upDragHandler);
         }
         else
         {
            GV.MC_AppLever.stage.removeEventListener(MouseEvent.MOUSE_UP,this.upDragHandler);
         }
         this.scroll_mc.drag_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.overDragHandler);
         this.scroll_mc.drag_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.outDragHandler);
         this.scroll_mc.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.downDragHandler);
         this.scroll_mc.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveDragHandler);
         this.scroll_mc.drag_mc.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelHandler);
         this.target_mc.removeEventListener(MouseEvent.MOUSE_WHEEL,this.wheelHandler);
         this.scroll_mc.up_btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.downUpBtnHandler);
         this.scroll_mc.up_btn.removeEventListener(MouseEvent.MOUSE_UP,this.upUpBtnHandler);
         this.scroll_mc.down_btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.downDownBtnHandler);
         this.scroll_mc.down_btn.removeEventListener(MouseEvent.MOUSE_UP,this.upDownBtnHandler);
      }
   }
}

