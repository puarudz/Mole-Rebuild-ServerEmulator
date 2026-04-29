package com.mole.app.ui
{
   import com.common.Tween.TweenLite;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   
   public class InfoBox extends Sprite
   {
      
      private static var _timer:Timer;
      
      public static const EDGE:uint = 50;
      
      public static const INTERVAL:uint = 5;
      
      public static const DIS:uint = 120;
      
      private static var _queue:Array = new Array();
      
      setup();
      
      private var _delay:Number;
      
      public function InfoBox(data:Object)
      {
         var info_txt:TextField = null;
         super();
         this.mouseChildren = this.mouseEnabled = false;
         this._delay = data.delay;
         var bg:Shape = new Shape();
         addChild(bg);
         info_txt = new TextField();
         info_txt.htmlText = data.msg;
         info_txt.antiAliasType = AntiAliasType.ADVANCED;
         info_txt.selectable = false;
         info_txt.autoSize = TextFormatAlign.LEFT;
         info_txt.defaultTextFormat = new TextFormat("宋体",14,16777215);
         info_txt.filters = [new GlowFilter(16750848,1,3,3,1.75)];
         info_txt.x = EDGE / 2;
         addChild(info_txt);
         bg.graphics.beginFill(0,0.3);
         bg.graphics.drawRoundRect(0,0,info_txt.width + EDGE,info_txt.textHeight + 5,10,10);
         bg.graphics.endFill();
         this.x = (GV.stageWidth - this.width) / 2;
         this.y = (GV.stageHeight - this.height) / 2;
         this.mouseChildren = this.mouseEnabled = false;
         MainManager.getTopLevel().addChild(this);
         TweenLite.to(this,this._delay,{
            "y":y - DIS,
            "alpha":0,
            "onComplete":this.onTweenComplete
         });
      }
      
      public static function setup() : void
      {
         _timer = new Timer(1000);
         _timer.addEventListener(TimerEvent.TIMER,onNext);
      }
      
      private static function onNext(e:TimerEvent) : void
      {
         if(_queue.length > 0)
         {
            new InfoBox(_queue.shift());
         }
         else
         {
            _timer.reset();
         }
      }
      
      public static function show(msg:String, delay:Number = 5) : void
      {
         _queue.push({
            "msg":msg,
            "delay":delay
         });
         if(_timer.running == false)
         {
            new InfoBox(_queue.shift());
            _timer.start();
         }
      }
      
      private function onTweenComplete() : void
      {
         DisplayUtil.removeForParent(this);
      }
   }
}

