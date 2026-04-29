package com.mole.app.ui
{
   import flash.events.FocusEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class InputText
   {
      
      private var _txt:TextField;
      
      private var _defTxt:String;
      
      public function InputText(txt:TextField, defTxt:String = "請輸入！")
      {
         super();
         this._txt = txt;
         this._defTxt = defTxt;
         this._txt.text = this._defTxt;
         var txtFormat:TextFormat = new TextFormat();
         txtFormat.color = 6710886;
         this._txt.setTextFormat(txtFormat);
         this._txt.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this._txt.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusIn(e:FocusEvent) : void
      {
         var txtFormat:TextFormat = null;
         if(this._txt.text == this._defTxt)
         {
            this._txt.text = "";
            txtFormat = new TextFormat();
            txtFormat.color = 0;
            this._txt.defaultTextFormat = txtFormat;
         }
      }
      
      private function onFocusOut(e:FocusEvent) : void
      {
         var txtFormat:TextFormat = null;
         if(this._txt.text == "")
         {
            this._txt.text = this._defTxt;
            txtFormat = new TextFormat();
            txtFormat.color = 6710886;
            this._txt.setTextFormat(txtFormat);
         }
      }
      
      public function get txt() : String
      {
         if(this._txt.text == this._defTxt)
         {
            return "";
         }
         return this._txt.text;
      }
      
      public function set txt(value:String) : void
      {
         this._txt.text = value;
      }
      
      public function destroy() : void
      {
         this._txt.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this._txt.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
   }
}

