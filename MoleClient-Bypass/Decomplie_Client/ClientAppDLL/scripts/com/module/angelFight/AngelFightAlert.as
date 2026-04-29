package com.module.angelFight
{
   import com.common.Tween.TweenLite;
   import com.core.MainManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class AngelFightAlert
   {
      
      private static const Type_Right:int = 1;
      
      private static const Type_wrong:int = 2;
      
      public static const SureBtnType_Sure:int = 1;
      
      public static const SureBtnType_Go:int = 2;
      
      public static const CancelBtnType_Cancel:int = 1;
      
      public static const CancelBtnType_IKnow:int = 2;
      
      public function AngelFightAlert()
      {
         super();
      }
      
      public static function RightAlert(msg:String, isHtml:Boolean = true) : void
      {
         Alert(msg,isHtml,Type_Right);
      }
      
      public static function WrongAlert(msg:String, isHtml:Boolean = true) : void
      {
         Alert(msg,isHtml,Type_wrong);
      }
      
      private static function Alert(msg:String, isHtml:Boolean, type:int) : void
      {
         var alertMC:MovieClip = null;
         var text:TextField = null;
         var Max_Width:Number = NaN;
         var Max_Height:Number = NaN;
         var timer:Timer = null;
         var timerOverFun:Function = null;
         alertMC = AngelFightMain.instance.GetMovieClip("alert_mc");
         if(Boolean(alertMC))
         {
            alertMC.mouseChildren = false;
            alertMC.mouseEnabled = false;
            alertMC.type_mc.gotoAndStop(type);
            text = alertMC.msg_txt;
            text.wordWrap = false;
            text.autoSize = TextFieldAutoSize.LEFT;
            if(isHtml)
            {
               text.htmlText = msg;
            }
            else
            {
               text.text = msg;
            }
            alertMC.bg_mc.height = text.textHeight + alertMC.bg_mc.height - alertMC.bg_mc.scale9Grid.height;
            alertMC.bg_mc.width = text.textWidth + alertMC.bg_mc.width - alertMC.bg_mc.scale9Grid.width;
            Max_Width = 960;
            Max_Height = 560;
            alertMC.x = Max_Width / 2 - alertMC.bg_mc.width / 2;
            alertMC.y = Max_Height / 2 + 70;
            MainManager.getAlertLevel().addChild(alertMC);
            alertMC.alpha = 0.5;
            TweenLite.to(alertMC,0.5,{
               "y":Max_Height / 2,
               "alpha":1
            });
            timer = new Timer(2.5 * 1000,1);
            timerOverFun = function h(e:TimerEvent):void
            {
               timer.stop();
               BC.removeEvent(timer);
               var _temp_6:* = TweenLite;
               var _temp_5:* = alertMC;
               var _temp_4:* = 0.5;
               var _temp_3:* = "alpha";
               var _temp_2:* = 0;
               var _temp_1:* = "onComplete";
               with({})
               {
                  _temp_6.to(_temp_5,_temp_4,{
                     _temp_3:_temp_2,
                     _temp_1:function Clear():void
                     {
                        alertMC.visible = false;
                        GC.clearAll(alertMC);
                     }
                  });
               };
               BC.addEvent(timer,timer,TimerEvent.TIMER_COMPLETE,timerOverFun);
               timer.start();
            }
         }
         
         public static function ConfirmAlert(msg:String, sureFun:Function = null, sureBtnType:int = 1, cancelBtnType:int = 1) : void
         {
            var alertMC:MovieClip = null;
            var text:TextField = null;
            var Max_Width:Number = NaN;
            var Max_Height:Number = NaN;
            alertMC = AngelFightMain.instance.GetMovieClip("confirmAlert_mc");
            if(Boolean(alertMC))
            {
               MainManager.getAlertLevel().addChild(alertMC);
               text = alertMC.desc_txt;
               text.wordWrap = true;
               text.autoSize = TextFieldAutoSize.LEFT;
               text.htmlText = msg;
               alertMC.sure_btn.y = alertMC.cancel_btn.y = text.y + text.textHeight + 10;
               alertMC.bg_mc.height = alertMC.sure_btn.y + alertMC.sure_btn.height + 10;
               MovieClip(alertMC.sure_btn).gotoAndStop(sureBtnType);
               MovieClip(alertMC.cancel_btn).gotoAndStop(cancelBtnType);
               Max_Width = 960;
               Max_Height = 560;
               alertMC.x = Max_Width / 2 - alertMC.bg_mc.width / 2;
               var _temp_5:* = BC;
               var _temp_4:* = alertMC;
               var _temp_3:* = alertMC.sure_btn;
               var _temp_2:* = MouseEvent.CLICK;
               with({})
               {
                  
                  var _temp_9:* = BC;
                  var _temp_8:* = alertMC;
                  var _temp_7:* = alertMC.cancel_btn;
                  var _temp_6:* = MouseEvent.CLICK;
                  with({})
                  {
                     
                     _temp_9.addEvent(_temp_8,_temp_7,_temp_6,function sureOk(e:MouseEvent):void
                     {
                        BC.removeEvent(alertMC);
                        GC.clearAll(alertMC);
                     });
                  }
               }
            }
         }
         
         