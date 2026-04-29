package com.mole.app.utils
{
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.Timer;
   
   public class ToolTip extends Sprite
   {
      
      private var _stage:Stage;
      
      private var _parentObject:DisplayObject;
      
      private var _tf:TextField;
      
      private var _cf:TextField;
      
      private var _tween:Tween;
      
      private var _titleFormat:TextFormat;
      
      private var _contentFormat:TextFormat;
      
      private var _titleOverride:Boolean = false;
      
      private var _contentOverride:Boolean = false;
      
      private var _defaultWidth:Number = 200;
      
      private var _buffer:Number = 10;
      
      private var _align:String = "center";
      
      private var _cornerRadius:Number = 12;
      
      private var _bgColors:Array = [16777215,10263708];
      
      private var _autoSize:Boolean = false;
      
      private var _hookEnabled:Boolean = false;
      
      private var _delay:Number = 0;
      
      private var _hookSize:Number = 10;
      
      private var _offSet:Number;
      
      private var _hookOffSet:Number;
      
      private var _timer:Timer;
      
      public function ToolTip()
      {
         super();
         this.mouseEnabled = false;
         this.buttonMode = false;
         this.mouseChildren = false;
         this._timer = new Timer(this._delay,1);
         this._timer.addEventListener("timer",this.timerHandler);
      }
      
      public function show(p:DisplayObject, title:String, content:String = null, stage:* = null) : void
      {
         var globalPoint:Point = null;
         if(Boolean(stage))
         {
            this._stage = stage;
         }
         else
         {
            this._stage = p.stage;
         }
         this._parentObject = p;
         this.addCopy(title,content);
         this.setOffset();
         this.drawBG();
         this.bgGlow();
         var parentCoords:Point = new Point(this._parentObject.mouseX,this._parentObject.mouseY);
         globalPoint = p.localToGlobal(parentCoords);
         this.x = globalPoint.x + this._offSet;
         this.y = globalPoint.y - this.height - 10;
         this.alpha = 0;
         this._stage.addChild(this);
         this._parentObject.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.follow(true);
         this._timer.start();
      }
      
      public function hide() : void
      {
         this.animate(false);
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         this.animate(true);
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         event.currentTarget.removeEventListener(event.type,arguments.callee);
         this.hide();
      }
      
      private function follow(value:Boolean) : void
      {
         if(value)
         {
            addEventListener(Event.ENTER_FRAME,this.eof);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.eof);
         }
      }
      
      private function eof(event:Event) : void
      {
         this.position();
      }
      
      private function position() : void
      {
         var yp:Number = NaN;
         var speed:Number = 3;
         var parentCoords:Point = new Point(this._parentObject.mouseX,this._parentObject.mouseY);
         var globalPoint:Point = this._parentObject.localToGlobal(parentCoords);
         var xp:Number = globalPoint.x + this._offSet;
         yp = globalPoint.y - this.height - 10;
         var overhangRight:Number = this._defaultWidth + xp;
         if(overhangRight > stage.stageWidth)
         {
            xp = stage.stageWidth - this._defaultWidth;
         }
         if(xp < 0)
         {
            xp = 0;
         }
         if(yp < 0)
         {
            yp = 0;
         }
         this.x += (xp - this.x) / speed;
         this.y += (yp - this.y) / speed;
      }
      
      private function addCopy(title:String, content:String) : void
      {
         var contentIsDevice:Boolean = false;
         var bounds:Rectangle = null;
         var cfWidth:Number = NaN;
         if(!this._titleOverride)
         {
            this.initTitleFormat();
         }
         var titleIsDevice:Boolean = this.isDeviceFont(this._titleFormat);
         this._tf = this.createField(titleIsDevice);
         this._tf.htmlText = title;
         this._tf.setTextFormat(this._titleFormat,0,title.length);
         if(this._autoSize)
         {
            this._defaultWidth = this._tf.textWidth + 4 + this._buffer * 2;
         }
         else
         {
            this._tf.width = this._defaultWidth - this._buffer * 2;
         }
         this._tf.x = this._tf.y = this._buffer;
         this.textGlow(this._tf);
         addChild(this._tf);
         if(content != null)
         {
            if(!this._contentOverride)
            {
               this.initContentFormat();
            }
            contentIsDevice = this.isDeviceFont(this._contentFormat);
            this._cf = this.createField(contentIsDevice);
            this._cf.htmlText = content;
            bounds = this.getBounds(this);
            this._cf.x = this._buffer;
            this._cf.y = bounds.height + 5;
            this.textGlow(this._cf);
            this._cf.setTextFormat(this._contentFormat);
            if(this._autoSize)
            {
               cfWidth = this._cf.textWidth + 4 + this._buffer * 2;
               this._defaultWidth = cfWidth > this._defaultWidth ? cfWidth : this._defaultWidth;
            }
            else
            {
               this._cf.width = this._defaultWidth - this._buffer * 2;
            }
            addChild(this._cf);
         }
      }
      
      private function createField(deviceFont:Boolean) : TextField
      {
         var tf:TextField = new TextField();
         tf.embedFonts = !deviceFont;
         tf.gridFitType = "pixel";
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.selectable = false;
         if(!this._autoSize)
         {
            tf.multiline = true;
            tf.wordWrap = true;
         }
         return tf;
      }
      
      private function drawBG() : void
      {
         var xp:Number = NaN;
         var yp:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var bounds:Rectangle = this.getBounds(this);
         var fillType:String = GradientType.LINEAR;
         var alphas:Array = [1,1];
         var ratios:Array = [0,255];
         var matr:Matrix = new Matrix();
         var radians:Number = 90 * Math.PI / 180;
         matr.createGradientBox(this._defaultWidth,bounds.height + this._buffer * 2,radians,0,0);
         var spreadMethod:String = SpreadMethod.PAD;
         this.graphics.beginGradientFill(fillType,this._bgColors,alphas,ratios,matr,spreadMethod);
         if(this._hookEnabled)
         {
            xp = 0;
            yp = 0;
            w = this._defaultWidth;
            h = bounds.height + this._buffer * 2;
            this.graphics.moveTo(xp + this._cornerRadius,yp);
            this.graphics.lineTo(xp + w - this._cornerRadius,yp);
            this.graphics.curveTo(xp + w,yp,xp + w,yp + this._cornerRadius);
            this.graphics.lineTo(xp + w,yp + h - this._cornerRadius);
            this.graphics.curveTo(xp + w,yp + h,xp + w - this._cornerRadius,yp + h);
            this.graphics.lineTo(xp + this._hookOffSet + this._hookSize,yp + h);
            this.graphics.lineTo(xp + this._hookOffSet,yp + h + this._hookSize);
            this.graphics.lineTo(xp + this._hookOffSet - this._hookSize,yp + h);
            this.graphics.lineTo(xp + this._cornerRadius,yp + h);
            this.graphics.curveTo(xp,yp + h,xp,yp + h - this._cornerRadius);
            this.graphics.lineTo(xp,yp + this._cornerRadius);
            this.graphics.curveTo(xp,yp,xp + this._cornerRadius,yp);
            this.graphics.endFill();
         }
         else
         {
            this.graphics.drawRoundRect(0,0,this._defaultWidth,bounds.height + this._buffer * 2,this._cornerRadius);
         }
      }
      
      private function animate(show:Boolean) : void
      {
         var end:int = show == true ? 1 : 0;
         this._tween = new Tween(this,"alpha",Strong.easeOut,this.alpha,end,0.5,true);
         if(!show)
         {
            this._tween.addEventListener(TweenEvent.MOTION_FINISH,this.onComplete);
            this._timer.reset();
         }
      }
      
      private function onComplete(event:TweenEvent) : void
      {
         event.currentTarget.removeEventListener(event.type,arguments.callee);
         this.cleanUp();
      }
      
      public function set tipWidth(value:Number) : void
      {
         this._defaultWidth = value;
      }
      
      public function set titleFormat(tf:TextFormat) : void
      {
         this._titleFormat = tf;
         if(this._titleFormat.font == null)
         {
            this._titleFormat.font = "_sans";
         }
         this._titleOverride = true;
      }
      
      public function set contentFormat(tf:TextFormat) : void
      {
         this._contentFormat = tf;
         if(this._contentFormat.font == null)
         {
            this._contentFormat.font = "_sans";
         }
         this._contentOverride = true;
      }
      
      public function set align(value:String) : void
      {
         var a:String = value.toLowerCase();
         var values:String = "right left center";
         if(values.indexOf(value) == -1)
         {
            throw new Error(this + " : Invalid Align Property, options are: \'right\', \'left\' & \'center\'");
         }
         this._align = a;
      }
      
      public function set delay(value:Number) : void
      {
         this._delay = value;
         this._timer.delay = value;
      }
      
      public function set hook(value:Boolean) : void
      {
         this._hookEnabled = value;
      }
      
      public function set hookSize(value:Number) : void
      {
         this._hookSize = value;
      }
      
      public function set cornerRadius(value:Number) : void
      {
         this._cornerRadius = value;
      }
      
      public function set colors(colArray:Array) : void
      {
         this._bgColors = colArray;
      }
      
      public function set autoSize(value:Boolean) : void
      {
         this._autoSize = value;
      }
      
      private function textGlow(field:TextField) : void
      {
         var color:Number = 0;
         var alpha:Number = 0.35;
         var blurX:Number = 2;
         var blurY:Number = 2;
         var strength:Number = 1;
         var inner:Boolean = false;
         var knockout:Boolean = false;
         var quality:Number = BitmapFilterQuality.HIGH;
         var filter:GlowFilter = new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
         var myFilters:Array = new Array();
         myFilters.push(filter);
         field.filters = myFilters;
      }
      
      private function bgGlow() : void
      {
         var color:Number = 0;
         var alpha:Number = 0.2;
         var blurX:Number = 5;
         var blurY:Number = 5;
         var strength:Number = 1;
         var inner:Boolean = false;
         var knockout:Boolean = false;
         var quality:Number = BitmapFilterQuality.HIGH;
         var filter:GlowFilter = new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
         var myFilters:Array = new Array();
         myFilters.push(filter);
         filters = myFilters;
      }
      
      private function initTitleFormat() : void
      {
         this._titleFormat = new TextFormat();
         this._titleFormat.font = "_sans";
         this._titleFormat.bold = true;
         this._titleFormat.size = 20;
         this._titleFormat.color = 3355443;
      }
      
      private function initContentFormat() : void
      {
         this._contentFormat = new TextFormat();
         this._contentFormat.font = "_sans";
         this._contentFormat.bold = false;
         this._contentFormat.size = 14;
         this._contentFormat.color = 3355443;
      }
      
      private function isDeviceFont(format:TextFormat) : Boolean
      {
         var font:String = format.font;
         var device:String = "_sans _serif _typewriter";
         return device.indexOf(font) > -1;
      }
      
      private function setOffset() : void
      {
         switch(this._align)
         {
            case "left":
               this._offSet = -this._defaultWidth + this._buffer * 3 + this._hookSize;
               this._hookOffSet = this._defaultWidth - this._buffer * 3 - this._hookSize;
               break;
            case "right":
               this._offSet = 0 - this._buffer * 3 - this._hookSize;
               this._hookOffSet = this._buffer * 3 + this._hookSize;
               break;
            case "center":
               this._offSet = -(this._defaultWidth / 2);
               this._hookOffSet = this._defaultWidth / 2;
               break;
            default:
               this._offSet = -(this._defaultWidth / 2);
               this._hookOffSet = this._defaultWidth / 2;
         }
      }
      
      private function cleanUp() : void
      {
         this._parentObject.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.follow(false);
         this._tf.filters = [];
         this.filters = [];
         removeChild(this._tf);
         this._tf = null;
         if(this._cf != null)
         {
            this._cf.filters = [];
            removeChild(this._cf);
         }
         this.graphics.clear();
         parent.removeChild(this);
      }
   }
}

