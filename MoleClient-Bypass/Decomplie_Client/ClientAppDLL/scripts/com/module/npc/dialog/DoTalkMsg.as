package com.module.npc.dialog
{
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class DoTalkMsg extends EventDispatcher
   {
      
      private var _speed:uint = 10;
      
      private var _maxLines:uint = 3;
      
      private var txt:TextField;
      
      private var msg:String;
      
      private var _app:ApplicationDomain;
      
      private var textEffArr:Array = [];
      
      private var prevPageLen:int = 0;
      
      private var printMsgTimer:Timer;
      
      public function DoTalkMsg(_txt:TextField, speed:uint = 20, maxLines:uint = 3, app:ApplicationDomain = null)
      {
         super();
         this.txt = _txt;
         this._app = app;
         this._speed = speed;
         this._maxLines = maxLines;
         this.txt.mouseWheelEnabled = false;
      }
      
      public function pushMsg(_msg:String) : void
      {
         this.msg = _msg;
         if(this.msg == "")
         {
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_OVER));
         }
         else
         {
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_CONTINUE));
         }
      }
      
      public function print(_msg:String = "", showAll:Boolean = false) : void
      {
         this.clearFontTypeInstance(this.textEffArr.length);
         this.textEffArr = [];
         this._print(_msg,showAll);
      }
      
      private function _print(_msg:String = "", showAll:Boolean = false) : void
      {
         var l:Number = NaN;
         var h:int = 0;
         var i:int = 0;
         this.msg = _msg;
         if(showAll)
         {
            this.txt.htmlText = _msg;
            if(Boolean(this._app))
            {
               this.getFontTypeInstance();
               l = 0;
               h = Math.min(this.txt.numLines,this._maxLines);
               for(i = 0; i < h; i++)
               {
                  l += this.txt.getLineLength(i);
               }
               for(i = 0; i < l; i++)
               {
                  this.showFontTypeInstance(i);
               }
            }
         }
         else
         {
            if(Boolean(this._app))
            {
               this.getFontTypeInstance();
            }
            this.txt.htmlText = "";
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_START));
         }
         GC.clearGInterval(this.printMsgTimer);
         this.printMsgTimer = GC.setGInterval(this.playText,this._speed);
      }
      
      public function clearFontTypeInstance(len:int) : void
      {
         var i:int = 0;
         var mc:MovieClip = null;
         if(Boolean(this.textEffArr.length))
         {
            for(i = 0; i < len; i++)
            {
               if(i >= this.textEffArr.length)
               {
                  this.textEffArr = [];
                  return;
               }
               mc = this.textEffArr[i] as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(1);
                  GC.clearAll(mc);
               }
            }
            this.textEffArr = this.textEffArr.slice(len);
         }
      }
      
      public function showFontTypeInstance(index:int) : void
      {
         var rect:Rectangle = null;
         var mc:MovieClip = this.textEffArr[index] as MovieClip;
         if(Boolean(mc))
         {
            rect = this.txt.getCharBoundaries(index);
            mc.x = this.txt.x + rect.x;
            mc.y = this.txt.y + rect.y;
            mc.rect = rect;
            mc.showEff();
            if(Boolean(this.txt.parent))
            {
               this.txt.parent.addChild(mc);
            }
         }
      }
      
      public function getFontTypeInstance() : void
      {
         var endIndex:int = 0;
         var str_1:String = null;
         var info:Array = null;
         var str:String = null;
         var fontInfo:Array = null;
         var type:String = null;
         var color:int = 0;
         var cls:Class = null;
         var add_str:String = null;
         var i:int = 0;
         var mc:MovieClip = null;
         var startIndex:int = this.msg.indexOf("{$font");
         if(startIndex >= 0)
         {
            endIndex = this.msg.indexOf(":font}",startIndex);
            str_1 = this.msg.substring(startIndex,endIndex);
            info = str_1.split(":");
            str = info[1];
            fontInfo = info[0].split("_");
            type = fontInfo[1];
            color = parseInt(fontInfo[2],16);
            if(type == "face")
            {
               add_str = "";
               while(add_str.length < int(str))
               {
                  add_str += "";
               }
               this.msg = this.msg.split(str_1 + ":font}").join(add_str);
               str = "1";
            }
            else
            {
               this.msg = this.msg.split(str_1 + ":font}").join(str);
            }
            cls = this._app.getDefinition("font_" + type) as Class;
            if(Boolean(cls))
            {
               for(i = 0; i < str.length; i++)
               {
                  mc = new cls() as MovieClip;
                  mc.color = color;
                  mc.type = type;
                  mc.text = str.substr(i,1);
                  this.textEffArr[startIndex + i] = mc;
               }
            }
            this.getFontTypeInstance();
         }
      }
      
      public function next() : void
      {
         if(!this.msg.length)
         {
            return;
         }
         if(this.printMsgTimer.running)
         {
            this._print(this.msg,true);
         }
         else
         {
            this.clearFontTypeInstance(this.prevPageLen);
            this._print(this.msg);
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_CONTINUE));
         }
      }
      
      public function stop() : void
      {
         GC.clearGInterval(this.printMsgTimer);
         dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_BREAK));
      }
      
      public function destroy() : void
      {
         this.stop();
         this.clearFontTypeInstance(this.textEffArr.length);
         this.textEffArr = [];
      }
      
      private function playText() : void
      {
         var l:Number = NaN;
         var i:int = 0;
         if(this.msg == null)
         {
            this.msg = "";
            GC.clearGInterval(this.printMsgTimer);
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_OVER));
         }
         else if(this.txt.numLines > this._maxLines)
         {
            GC.clearGInterval(this.printMsgTimer);
            l = 0;
            for(i = 0; i < this._maxLines; i++)
            {
               l += this.txt.getLineLength(i);
            }
            this.txt.htmlText = this.msg.substring(0,l);
            this.msg = this.msg.substring(l);
            this.prevPageLen = l;
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_BREAK));
         }
         else if(this.txt.length == this.msg.length)
         {
            this.msg = "";
            GC.clearGInterval(this.printMsgTimer);
            dispatchEvent(new TalkEvent(TalkEvent.ON_PRINT_OVER));
         }
         else
         {
            this.txt.appendText(this.msg.substr(this.txt.length,1));
            this.showFontTypeInstance(this.txt.length - 1);
         }
      }
   }
}

