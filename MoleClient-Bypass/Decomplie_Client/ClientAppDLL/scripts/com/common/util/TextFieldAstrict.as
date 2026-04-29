package com.common.util
{
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class TextFieldAstrict
   {
      
      public static var CHARSET_CN_GB:String = "cn-gb";
      
      public static var CHARSET_SHIFT_JIS:String = "shift-jis";
      
      public static var CHARSET_ISO_8859_1:String = "iso-8859-1";
      
      public static var CHARSET_UTF_8:String = "utf_8";
      
      public static var TYPE_BYTES:String = "type_Bytes";
      
      public static var TYPE_WORD:String = "type_Word";
      
      public var limitLenght:uint;
      
      private var oldString:String;
      
      private var charSet:String;
      
      private var astristType:String;
      
      private var myTextField:TextField;
      
      private var groupNameLimit:ByteAstrictArray;
      
      public function TextFieldAstrict(textInstance:TextField, _limitLenght:uint, _AstristType:String = "type_Bytes", _charSet:String = "cn-gb")
      {
         super();
         this.limitLenght = _limitLenght;
         this.myTextField = textInstance;
         this.astristType = _AstristType;
         this.charSet = _charSet;
         if(this.astristType == TYPE_BYTES)
         {
            this.groupNameLimit = new ByteAstrictArray(this.limitLenght);
            BC.addEvent(this,this.groupNameLimit,ByteAstrictArray.ON_OVERRUN,this.overRunTxt);
            BC.addEvent(this,this.myTextField,Event.CHANGE,this.onTextChange);
            BC.addEvent(this,this.myTextField,TextEvent.TEXT_INPUT,this.onTextInput);
         }
         else
         {
            BC.addEvent(this,this.myTextField,Event.CHANGE,this.onTextChange2);
            BC.addEvent(this,this.myTextField,TextEvent.TEXT_INPUT,this.onTextInput2);
         }
         this.oldString = "";
      }
      
      private function onTextChange(E:Event) : void
      {
         this.groupNameLimit.clear();
         if(this.charSet == CHARSET_UTF_8)
         {
            this.groupNameLimit.writeUTFBytes(this.myTextField.text);
         }
         else
         {
            this.groupNameLimit.writeMultiByte(this.myTextField.text,this.charSet);
         }
      }
      
      private function onTextInput(E:Event) : void
      {
         this.oldString = this.myTextField.text;
      }
      
      private function overRunTxt(E:Event) : void
      {
         this.myTextField.text = this.oldString;
      }
      
      private function onTextChange2(E:Event) : void
      {
         if(this.myTextField.text.length > this.limitLenght)
         {
            this.myTextField.text = this.oldString;
         }
      }
      
      private function onTextInput2(E:Event) : void
      {
         this.oldString = this.myTextField.text;
      }
   }
}

