package com.taomee.component
{
   public class MToggleButton extends AbstractButton implements IToggleButton
   {
      
      protected var selected:Boolean = false;
      
      public function MToggleButton(text:String, icon:* = null)
      {
         super();
         this.setUI(text,icon);
      }
      
      public function isSelected() : Boolean
      {
         return this.selected;
      }
      
      public function setSelected(b:Boolean) : void
      {
      }
      
      override public function mouseOut() : void
      {
         super.mouseOut();
      }
      
      override public function mouseOver() : void
      {
         super.mouseOver();
      }
      
      override public function press() : void
      {
         super.press();
      }
      
      override public function release() : void
      {
         super.release();
      }
      
      protected function setUI(text:String, icon:* = null) : void
      {
      }
   }
}

