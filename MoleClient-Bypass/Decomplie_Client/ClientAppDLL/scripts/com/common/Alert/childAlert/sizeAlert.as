package com.common.Alert.childAlert
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class sizeAlert extends simpleAlert
   {
      
      public function sizeAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true, size:String = "298,228")
      {
         super(obj,title,content,style,bottomArray,closeB,size);
         showAlert();
         setAlertXY(TARGET);
      }
      
      public function changePanel_TextField_To_Right() : void
      {
         var t1:TextField = null;
         var format:TextFormat = new TextFormat();
         format.align = "left";
         var t:TextField = getContentTextField();
         t.width = (width - 48) / 2;
         t.x = int(width / 2 - 20);
         t.y = height / 3 - 5;
         t.wordWrap = true;
         t.defaultTextFormat = format;
         t.text = t.text;
         t1 = getTitleTextField();
         t1.width = (width - 48) / 2;
         t1.x = int(width / 2 - 20);
         t1.y = height / 3 - 45;
         t1.wordWrap = true;
         t1.defaultTextFormat = format;
         t1.text = t1.text;
      }
      
      public function changePanel_TextField_To_Bottom() : void
      {
         var format:TextFormat = new TextFormat();
         format.align = "left";
         var t:TextField = getContentTextField();
         t.width = width - 48;
         t.x = 26;
         t.y = height / 2 + 20 - 5;
         t.wordWrap = true;
         t.defaultTextFormat = format;
         t.text = t.text;
         var t1:TextField = getTitleTextField();
         t1.width = width - 48;
         t1.x = 28;
         t1.y = 115;
         t1.wordWrap = true;
         t1.defaultTextFormat = format;
         t1.text = t1.text;
      }
   }
}

