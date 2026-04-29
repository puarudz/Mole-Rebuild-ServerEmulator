package com.mole.app.ui
{
   import com.core.MainManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public dynamic class BagTip extends Sprite
   {
      
      private static var tipTimer:Timer;
      
      private static var owner:BagTip;
      
      private static var tailTimer:Timer;
      
      public static var tip_Class:Class;
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = dispatchObj.dispatchEvent;
      
      public static var addEventListener:Function = dispatchObj.addEventListener;
      
      public static var removeEventListener:Function = dispatchObj.removeEventListener;
      
      public var message:*;
      
      public var data:*;
      
      public var delay:uint = 3000;
      
      private var baseMC:*;
      
      public var BG:MovieClip;
      
      public var msgjt_mc:MovieClip;
      
      public var showMSG_txt:TextField;
      
      public var name_txtY:Number = 6;
      
      public var addBGY:Number = 30;
      
      public function BagTip(_message:* = null, _data:* = null, _delay:uint = 3000)
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         hideTip();
         if(Boolean(_message))
         {
            this.message = _message;
         }
         if(Boolean(_data))
         {
            this.data = _data;
         }
         if(Boolean(_delay))
         {
            this.delay = _delay;
         }
         this.baseMC = new tip_Class();
         addChild(this.baseMC);
         this.BG = this.baseMC["BG"];
         this.msgjt_mc = this.baseMC["msgjt_mc"];
         this.showMSG_txt = this.baseMC["showMSG_txt"];
         owner = this;
         this.init();
      }
      
      public static function addTips(_root:DisplayObjectContainer, tip:BagTip, isHtml:Boolean = true, textWidth:uint = 0, delay:uint = 3000) : void
      {
         var data:Object = {};
         data.isHtml = isHtml;
         data.textWidth = textWidth;
         tip.delay = delay;
         tip.data = data;
         var tip_mc:BagTip = tip;
         MainManager.getRootMC().parent.addChild(tip_mc);
      }
      
      public static function tipTailDisPlayObject(mc:*, tip:BagTip, tailMouse:Boolean = true, isHtml:Boolean = true, textWidth:uint = 0, delay:uint = 300000) : void
      {
         var data:Object = null;
         var root:* = undefined;
         var onMoveTip:Function = null;
         var onShowTip:Function = null;
         var onHideTip:Function = null;
         var checkAddEventFun:Function = null;
         var addEventFun:Function = null;
         if(tip == null)
         {
            throw "提示語為空!";
         }
         data = {};
         data.isHtml = isHtml;
         data.tailMouse = tailMouse;
         data.tailMC = mc;
         data.textWidth = textWidth;
         root = MainManager.getRootMC().parent;
         onMoveTip = function(E:MouseEvent):void
         {
            if(!owner)
            {
               return;
            }
            moveTipfun(owner);
            E.updateAfterEvent();
         };
         onShowTip = function(E:MouseEvent = null):void
         {
            var tip_mc:BagTip = null;
            tip.data = data;
            tip.delay = delay;
            tip_mc = tip;
            root["addChild"](tip_mc);
            moveTipfun(tip_mc);
            if(tailMouse)
            {
               GC.clearGInterval(tailTimer);
               tailTimer = GC.setGInterval(function():void
               {
                  if(Boolean(mc.stage) && Boolean(mc.hitTestPoint(mc.stage.mouseX,mc.stage.mouseY,true)))
                  {
                     moveTipfun(owner);
                  }
                  else
                  {
                     hideTip();
                  }
               },20);
               if(!owner)
               {
                  onMoveTip = function(E:MouseEvent):void
                  {
                     moveTipfun(tip_mc);
                     E.updateAfterEvent();
                  };
               }
               BC.addEvent(BagTip,mc,MouseEvent.MOUSE_MOVE,onMoveTip);
            }
         };
         BC.addEvent(BagTip,mc,MouseEvent.MOUSE_OVER,onShowTip);
         onHideTip = function(E:MouseEvent):void
         {
            BC.removeEvent(BagTip,mc,MouseEvent.MOUSE_MOVE,onMoveTip);
            hideTip();
         };
         BC.addEvent(BagTip,mc,MouseEvent.MOUSE_OUT,onHideTip);
         checkAddEventFun = function(E:Event):void
         {
            BC.removeEvent(BagTip,mc);
            mc.addEventListener(Event.ADDED_TO_STAGE,addEventFun,true);
         };
         BC.addEvent(BagTip,mc,Event.REMOVED_FROM_STAGE,checkAddEventFun);
         addEventFun = function(E:Event):void
         {
            BC.addEvent(BagTip,mc,Event.REMOVED_FROM_STAGE,checkAddEventFun);
            BC.addEvent(BagTip,mc,MouseEvent.MOUSE_OUT,onHideTip);
            BC.addEvent(BagTip,mc,MouseEvent.MOUSE_OVER,onShowTip);
            if(!owner)
            {
               onShowTip();
            }
            if(tailMouse)
            {
               BC.addEvent(BagTip,mc,MouseEvent.MOUSE_MOVE,onMoveTip);
            }
         };
      }
      
      private static function moveTipfun(mc:DisplayObjectContainer) : void
      {
         mc.x = mc.stage.mouseX;
         mc.y = mc.stage.mouseY - 15;
         var rec:Rectangle = mc.getRect(mc.root);
         mc.x = rec.left < 0 ? rec.left * -1 : (rec.right > 960 ? mc.x - (rec.right - 960) : mc.x);
         mc.y = rec.top < 0 ? mc.stage.mouseY + rec.height + 15 : mc.stage.mouseY - 15;
      }
      
      public static function delTipTailDisPlayObject(mc:DisplayObjectContainer) : void
      {
         GC.clearGInterval(tailTimer);
         BC.removeEvent(BagTip,mc);
      }
      
      public static function hideTip() : void
      {
         dispatchEvent(new Event("hide_over"));
         GC.clearGInterval(tailTimer);
         try
         {
            tipTimer.stop();
         }
         catch(E:*)
         {
         }
         if(!owner)
         {
            return;
         }
         BC.removeEvent(owner);
         GC.clearAll(owner);
         owner.message = null;
         owner.data = null;
         owner.baseMC = null;
         owner.BG = null;
         owner.msgjt_mc = null;
         owner.showMSG_txt = null;
         tipTimer = null;
         owner = null;
      }
      
      private function init() : void
      {
         if(tipTimer != null && tipTimer.running)
         {
            tipTimer.reset();
            tipTimer.start();
         }
         else
         {
            tipTimer = new Timer(this.delay,1);
            tipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.comPleteHandler);
            tipTimer.start();
         }
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      private function addedToStage(E:*) : void
      {
         this.showTip();
      }
      
      private function comPleteHandler(E:*) : void
      {
         hideTip();
      }
      
      public function txtName(val:String) : void
      {
         var txt:TextField = this.baseMC["name_txt"];
         txt.text = val;
      }
      
      public function txtNameFormat(tf:TextFormat) : void
      {
         var txt:TextField = this.baseMC["name_txt"];
         txt.setTextFormat(tf);
      }
      
      public function showTip() : void
      {
         var myPoint:Point = null;
         visible = true;
         if(Boolean(this.data) && Boolean(this.data.isHtml))
         {
            this.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
            this.showMSG_txt.htmlText = this.message;
         }
         else
         {
            this.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
            this.showMSG_txt.htmlText = this.message;
         }
         if(Boolean(this.data) && Boolean(this.data.textWidth))
         {
            this.showMSG_txt.width = this.data.textWidth;
         }
         this.showMSG_txt.wordWrap = false;
         this.showMSG_txt.setTextFormat(new TextFormat(null,14));
         this.BG.width = Math.max(this.showMSG_txt.textWidth,this.baseMC["name_txt"].textWidth) + 24;
         this.BG.height = this.showMSG_txt.textHeight + this.addBGY;
         this.msgjt_mc.gotoAndStop(1);
         if(this.showMSG_txt.textWidth < 50)
         {
            this.msgjt_mc.gotoAndStop(2);
            this.BG.height = this.showMSG_txt.textHeight + this.addBGY + 2;
         }
         this.BG.x = this.BG.width / 2;
         this.BG.y = this.BG.height / 2;
         this.showMSG_txt.x = 10;
         this.showMSG_txt.y = 23;
         this.baseMC["name_txt"].x = 10;
         this.baseMC["name_txt"].y = this.name_txtY;
         if(Boolean(this.data) && Boolean(this.data.x) && Boolean(this.data.y))
         {
            if(Boolean(this.data as MovieClip))
            {
               myPoint = new Point(this.data.x,this.data.y);
               myPoint = this.data.parent.localToGlobal(myPoint);
               x = myPoint.x;
               y = myPoint.y;
            }
            else if(this.data.x != null && this.data.y != null)
            {
               x = this.data.x;
               y = this.data.y;
            }
            else
            {
               x = stage.mouseX;
               y = stage.mouseY - 15;
            }
         }
         else
         {
            x = stage.mouseX;
            y = stage.mouseY - 15;
         }
         if(Boolean(this.data) && Boolean(this.data.tailMC))
         {
            myPoint = new Point(this.data.tailMC.x,this.data.tailMC.y);
            myPoint = this.data.tailMC.parent.localToGlobal(myPoint);
            x = myPoint.x;
            y = myPoint.y;
         }
      }
   }
}

