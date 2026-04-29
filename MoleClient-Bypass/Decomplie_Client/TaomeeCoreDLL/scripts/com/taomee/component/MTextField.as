package com.taomee.component
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class MTextField extends Component
   {
      
      public static const CENTER:String = "center";
      
      public static const JUSTIFY:String = "justify";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private var bgClass:Class = MTextField_bgClass;
      
      private var txtBG:Sprite;
      
      private var tf:TextFormat;
      
      private var textField:TextField;
      
      private var colums:int;
      
      private var isShowBG:Boolean;
      
      public function MTextField(text:String = "", isShowBG:Boolean = false, columns:int = 0)
      {
         super();
         this.colums = columns;
         this.isShowBG = isShowBG;
         this.textField = new TextField();
         this.textField.cacheAsBitmap = true;
         this.textField.multiline = false;
         this.textField.type = TextFieldType.INPUT;
         this.textField.text = text;
         this.tf = new TextFormat();
         this.tf.font = "Tahoma";
         this.tf.size = MComponentManager.FONT_SIZE;
         this.setTextFormat(this.tf);
         containSprite.addChild(this.textField);
         this.txtBG = new this.bgClass() as Sprite;
         this.updateView();
      }
      
      override public function setEnabled(b:Boolean) : void
      {
         super.setEnabled(b);
         if(b)
         {
            this.textField.type = TextFieldType.INPUT;
         }
         else
         {
            this.textField.type = TextFieldType.DYNAMIC;
         }
      }
      
      public function setIsShowBG(b:Boolean) : void
      {
         this.isShowBG = b;
         if(b)
         {
            containSprite.addChildAt(this.txtBG,0);
         }
         else if(Boolean(this.txtBG.parent))
         {
            this.txtBG.parent.removeChild(this.txtBG);
         }
      }
      
      public function getIsShowBG() : Boolean
      {
         return this.isShowBG;
      }
      
      public function getTextField() : TextField
      {
         return this.textField;
      }
      
      public function setAlign(str:String) : void
      {
         this.tf.align = str;
         this.setTextFormat(this.tf);
      }
      
      public function setText(str:String) : void
      {
         this.textField.text = str;
         this.updateView();
      }
      
      public function getText() : String
      {
         return this.textField.text;
      }
      
      public function setHtmlText(str:String) : void
      {
         this.textField.htmlText = str;
         this.updateView();
      }
      
      public function setMultiline(b:Boolean) : void
      {
         this.textField.multiline = b;
      }
      
      public function setEditable(b:Boolean) : void
      {
         if(b)
         {
            this.textField.type = TextFieldType.INPUT;
         }
         else
         {
            this.textField.type = TextFieldType.DYNAMIC;
         }
      }
      
      public function setPasswordMode(b:Boolean) : void
      {
         this.textField.displayAsPassword = b;
      }
      
      public function setWordWrap(b:Boolean) : void
      {
         this.textField.wordWrap = true;
         this.updateView();
      }
      
      public function setTextFormat(tf:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
      {
         this.tf = tf;
         this.textField.setTextFormat(tf,beginIndex,endIndex);
      }
      
      override public function setWidth(i:int) : void
      {
         this.textField.x = 0;
         if(this.isShowBG)
         {
            this.textField.width = i - 8;
            this.textField.x = this.textField.y = 4;
            this.txtBG.width = i;
            containSprite.addChildAt(this.txtBG,0);
         }
         else
         {
            this.textField.width = i;
            if(Boolean(this.txtBG.parent))
            {
               this.txtBG.parent.removeChild(this.txtBG);
            }
         }
         super.setWidth(i);
      }
      
      override public function setHeight(i:int) : void
      {
         var h:int = 0;
         this.textField.height = i;
         if(this.isShowBG)
         {
            this.txtBG.height = i;
            containSprite.addChildAt(this.txtBG,0);
         }
         else if(Boolean(this.txtBG.parent))
         {
            this.txtBG.parent.removeChild(this.txtBG);
         }
         super.setHeight(i);
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.txtBG.parent))
         {
            this.txtBG.parent.removeChild(this.txtBG);
         }
         this.textField.parent.removeChild(this.textField);
         this.txtBG = null;
         this.textField = null;
         super.destroy();
      }
      
      override public function updateView() : void
      {
         this.setTextFormat(this.tf);
         if(this.colums > 0)
         {
            this.setWidth(Math.ceil(this.colums * MComponentManager.FONT_SIZE + MComponentManager.FONT_SIZE * 0.4));
            this.setHeight(Math.ceil(this.textField.textHeight / this.textField.numLines) + MComponentManager.FONT_SIZE * 0.4);
         }
         super.updateView();
      }
   }
}

