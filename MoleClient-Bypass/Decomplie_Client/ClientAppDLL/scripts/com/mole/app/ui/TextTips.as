package com.mole.app.ui
{
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TextTips extends TipsBase
   {
      
      public function TextTips(container:DisplayObject, msg:String, autoDel:Boolean, wordWrap:Boolean, txtWidth:Number)
      {
         super(container,autoDel);
         this.createTip(msg,wordWrap,txtWidth);
      }
      
      private function createTip(msg:String, wordWrap:Boolean, txtWidth:Number) : void
      {
         var txt:TextField = new TextField();
         txt.border = true;
         txt.background = true;
         txt.autoSize = TextFieldAutoSize.CENTER;
         txt.text = msg;
         if(wordWrap)
         {
            txt.multiline = true;
            txt.wordWrap = true;
            txt.width = txtWidth;
         }
         else
         {
            txt.wordWrap = false;
            txt.width = txt.textWidth;
         }
         txt.height = txt.textHeight;
         txt.x = txt.y = 0;
         _tipCon.addChild(txt);
      }
   }
}

