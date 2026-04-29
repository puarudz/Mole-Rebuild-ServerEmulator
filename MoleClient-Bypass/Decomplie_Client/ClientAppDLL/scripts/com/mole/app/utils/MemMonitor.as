package com.mole.app.utils
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.setInterval;
   
   public class MemMonitor extends Sprite
   {
      
      private var pStage:DisplayObjectContainer;
      
      private var memText:TextField;
      
      private var c:Number;
      
      private var t:Number;
      
      private var o:Number;
      
      private var frameRate:String;
      
      public function MemMonitor(_stage:DisplayObjectContainer)
      {
         super();
         this.pStage = _stage;
         graphics.beginFill(0,1);
         graphics.drawRect(0,0,120,40);
         graphics.endFill();
         this.memText = new TextField();
         this.memText.width = 120;
         this.memText.height = 40;
         this.memText.selectable = false;
         this.memText.textColor = 16777215;
         this.memText.mouseEnabled = false;
         this.x = 0;
         addChild(this.memText);
      }
      
      public function start() : void
      {
         this.c = 0;
         this.t = 0;
         this.pStage.addChild(this);
         this.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.startDragHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,this.stopDragHandler);
         setInterval(this.tick,1000);
      }
      
      private function enterFrameHandler(e:Event) : void
      {
         ++this.c;
         this.pStage.setChildIndex(this,this.pStage.numChildren - 1);
      }
      
      private function tick() : void
      {
         this.frameRate = (this.c - this.t).toString();
         this.t = this.c;
         this.memText.text = "Memory: " + (System.totalMemory / 1024 / 1024).toFixed(3) + "MB" + "\n" + "fps:" + this.frameRate + "\tframe:" + this.c;
      }
      
      private function startDragHandler(evt:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function stopDragHandler(evt:MouseEvent) : void
      {
         this.stopDrag();
      }
   }
}

