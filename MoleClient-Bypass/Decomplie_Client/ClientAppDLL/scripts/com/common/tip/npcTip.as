package com.common.tip
{
   import fl.transitions.Tween;
   import fl.transitions.easing.*;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class npcTip extends MovieClip
   {
      
      private static var target:MovieClip;
      
      private static var tipTimer:Timer;
      
      public static var alphaTween:Tween;
      
      public var message:*;
      
      public var data:*;
      
      public function npcTip()
      {
         super();
      }
      
      public static function showTip(mc:MovieClip, msg:String) : void
      {
         target = mc;
         var xx:int = int(target.x);
         var yy:int = int(target.y);
         target.visible = true;
         target.alpha = 100;
         target.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
         target.showMSG_txt.wordWrap = true;
         target.showMSG_txt.text = msg;
         target.BG.width = target.showMSG_txt.textWidth + 14;
         target.BG.height = target.showMSG_txt.textHeight + 12;
         target.BG.y = -(target.BG.height - 28.6);
         target.msgjt_mc.gotoAndStop(1);
         if(target.showMSG_txt.textWidth < 50)
         {
            target.msgjt_mc.gotoAndStop(2);
            target.BG.height = target.showMSG_txt.textHeight + 12;
         }
         target.showMSG_txt.x = 6;
         target.showMSG_txt.y = target.BG.y + 4;
         target.msgjt_mc.x = 26;
         target.msgjt_mc.y = 28.6;
         alphaTween = new Tween(target,"alpha",Strong.easeOut,0.5,1,0.2,true);
      }
      
      public static function hideTip(mc:MovieClip) : void
      {
         target = mc;
         target.visible = false;
         target.alpha = 0;
         target.showMSG_txt.text = "";
      }
   }
}

