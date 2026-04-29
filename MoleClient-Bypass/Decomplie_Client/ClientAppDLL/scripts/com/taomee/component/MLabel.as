package com.taomee.component
{
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class MLabel extends Component
   {
      
      public static const H_CENTER:int = 0;
      
      public static const H_LEFT:int = 1;
      
      public static const H_RIGHT:int = 2;
      
      public static const V_CENTER:int = 0;
      
      public static const V_TOP:int = 1;
      
      public static const V_BOTTOM:int = 2;
      
      private var H_AlineType:int;
      
      private var V_AlineType:int;
      
      private var icon:DisplayObject;
      
      private var textField:TextField;
      
      private var tf:TextFormat;
      
      public function MLabel(text:String = "", H_AlineType:int = 0, V_AlineType:int = 0, icon:DisplayObject = null)
      {
         super();
         this.icon = icon;
         this.H_AlineType = H_AlineType;
         this.V_AlineType = V_AlineType;
         this.tf = new TextFormat();
         this.tf.font = "Tahoma";
         this.tf.size = MComponentManager.FONT_SIZE;
         this.textField = new TextField();
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.type = TextFieldType.DYNAMIC;
         this.setTextFormat(this.tf);
         this.setSelectable(false);
         containSprite.addChild(this.textField);
         this.setText(text);
         this.initSize();
      }
      
      override public function updateView() : void
      {
         super.updateView();
         this.setTextFormat(this.tf);
         this.horizontalAlignment(this.H_AlineType);
         this.verticalTextPosition(this.V_AlineType);
      }
      
      override public function destroy() : void
      {
         containSprite.removeChild(this.textField);
         this.textField = null;
         this.tf = null;
         if(Boolean(this.icon))
         {
            this.icon.parent.removeChild(this.icon);
         }
         this.icon = null;
         super.destroy();
      }
      
      public function setColor(i:uint) : void
      {
         this.tf = new TextFormat();
         this.tf.font = "Tahoma";
         this.tf.size = MComponentManager.FONT_SIZE;
         this.tf.color = i;
         this.textField.setTextFormat(this.tf);
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
      
      public function setSelectable(b:Boolean) : void
      {
         this.textField.selectable = b;
         containSprite.mouseEnabled = b;
         containSprite.mouseChildren = b;
      }
      
      public function setTextFormat(tf:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
      {
         this.tf = tf;
         this.textField.setTextFormat(tf,beginIndex,endIndex);
      }
      
      private function horizontalAlignment(H_AlineType:int) : void
      {
         switch(H_AlineType)
         {
            case MLabel.H_LEFT:
               this.textField.x = 0;
               break;
            case MLabel.H_RIGHT:
               this.textField.x = this.width - (this.textField.textWidth + 4);
               break;
            case MLabel.H_CENTER:
            default:
               this.textField.x = (this.width - (this.textField.textWidth + 4)) / 2;
         }
      }
      
      private function verticalTextPosition(V_AlineType:int) : void
      {
         switch(V_AlineType)
         {
            case MLabel.V_TOP:
               this.textField.y = 0;
               break;
            case MLabel.V_BOTTOM:
               this.textField.y = this.height - (this.textField.textHeight + 4);
               break;
            case MLabel.V_CENTER:
            default:
               this.textField.y = (this.height - (this.textField.textHeight + 4)) / 2;
         }
      }
      
      private function initSize() : void
      {
         var w:Number = this.textField.textWidth + 4;
         var h:Number = this.textField.textHeight;
         setSizeWH(w,h);
      }
   }
}

