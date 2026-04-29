package com.common.popUpMenu
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class PopUpMenuItem extends Sprite
   {
      
      private var _clickFun:Function;
      
      public function PopUpMenuItem(name:String, clickHandler:Function)
      {
         super();
         this._clickFun = clickHandler;
         this.buttonMode = true;
         var text:TextField = new TextField();
         text.autoSize = TextFieldAutoSize.LEFT;
         text.text = name;
         text.selectable = false;
         text.mouseEnabled = false;
         this.addChild(text);
         BC.addEvent(this,this,MouseEvent.CLICK,this.ClickHandler);
         BC.addEvent(this,this,MouseEvent.MOUSE_OVER,this.MouseOverHandler);
         BC.addEvent(this,this,MouseEvent.MOUSE_OUT,this.DrawBg);
         BC.addEvent(this,this,Event.ADDED_TO_STAGE,this.DrawBg);
      }
      
      private function DrawBg(e:Event) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,this.parent.width,this.height);
         this.graphics.endFill();
      }
      
      private function MouseOverHandler(e:MouseEvent) : void
      {
         this.graphics.clear();
         this.graphics.beginFill(16711680,0.5);
         this.graphics.drawRect(0,0,this.parent.width,this.height);
         this.graphics.endFill();
      }
      
      private function ClickHandler(e:MouseEvent) : void
      {
         if(this._clickFun != null)
         {
            this._clickFun();
         }
      }
   }
}

