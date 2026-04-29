package com.taomee.component
{
   import flash.display.Sprite;
   
   public class MCheckBox extends MToggleButton implements IToggleButton
   {
      
      protected var label:MLabel;
      
      private var labelEmptyCls:Class = MCheckBox_labelEmptyCls;
      
      private var labelSelectedCls:Class = MCheckBox_labelSelectedCls;
      
      protected var emptyBox:Sprite;
      
      protected var selectedBox:Sprite;
      
      public function MCheckBox(text:String, icon:* = null)
      {
         super(text,icon);
      }
      
      override public function setSelected(b:Boolean) : void
      {
         selected = b;
         if(selected)
         {
            addChild(this.selectedBox);
            if(Boolean(this.emptyBox.parent))
            {
               this.emptyBox.parent.removeChild(this.emptyBox);
            }
         }
         else
         {
            addChild(this.emptyBox);
            if(Boolean(this.selectedBox.parent))
            {
               this.selectedBox.parent.removeChild(this.selectedBox);
            }
         }
      }
      
      override public function isSelected() : Boolean
      {
         return selected;
      }
      
      override public function release() : void
      {
         selected = !selected;
         if(selected)
         {
            addChild(this.selectedBox);
            if(Boolean(this.emptyBox.parent))
            {
               this.emptyBox.parent.removeChild(this.emptyBox);
            }
         }
         else
         {
            addChild(this.emptyBox);
            if(Boolean(this.selectedBox.parent))
            {
               this.selectedBox.parent.removeChild(this.selectedBox);
            }
         }
         super.release();
      }
      
      override public function destroy() : void
      {
         this.emptyBox = null;
         this.selectedBox = null;
         this.label.destroy();
         this.label = null;
         super.destroy();
      }
      
      override public function setEnabled(b:Boolean) : void
      {
         super.setEnabled(b);
         if(b)
         {
            this.label.setColor(0);
         }
         else
         {
            this.label.setColor(6710886);
         }
      }
      
      override protected function setUI(text:String, icon:* = null) : void
      {
         containSprite.mouseChildren = false;
         containSprite.mouseEnabled = false;
         this.emptyBox = new this.labelEmptyCls() as Sprite;
         this.selectedBox = new this.labelSelectedCls() as Sprite;
         containSprite.addChild(this.emptyBox);
         this.label = new MLabel(text);
         this.label.setEnabled(false);
         this.label.x = this.emptyBox.width + 2;
         containSprite.addChild(this.label);
         this.emptyBox.y = this.selectedBox.y = (containSprite.height - this.emptyBox.height) / 2;
         this.label.y = (containSprite.height - this.label.height) / 2;
         setSizeWH(containSprite.width,containSprite.height);
      }
   }
}

