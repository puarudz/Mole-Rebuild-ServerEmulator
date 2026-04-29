package com.taomee.component
{
   import com.taomee.component.event.MEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class MRadioButton extends MCheckBox implements IToggleButton
   {
      
      private var radioBtnEmptyCls:Class = MRadioButton_radioBtnEmptyCls;
      
      private var radioBtnSelectedCls:Class = MRadioButton_radioBtnSelectedCls;
      
      public function MRadioButton(text:String, icon:* = null)
      {
         super(text,icon);
      }
      
      override public function setSelected(b:Boolean) : void
      {
         selected = b;
         if(selected)
         {
            this.resetOther();
            addChild(selectedBox);
            if(Boolean(emptyBox.parent))
            {
               emptyBox.parent.removeChild(emptyBox);
            }
         }
         else
         {
            addChild(emptyBox);
            if(Boolean(selectedBox.parent))
            {
               selectedBox.parent.removeChild(selectedBox);
            }
         }
      }
      
      override public function release() : void
      {
         this.setSelected(true);
         dispatchEvent(new MEvent(MEvent.RELEASE));
      }
      
      override protected function setUI(text:String, icon:* = null) : void
      {
         containSprite.mouseChildren = false;
         containSprite.mouseEnabled = false;
         emptyBox = new this.radioBtnEmptyCls() as Sprite;
         selectedBox = new this.radioBtnSelectedCls() as Sprite;
         containSprite.addChild(emptyBox);
         label = new MLabel(text);
         label.setEnabled(false);
         label.x = emptyBox.width + 2;
         containSprite.addChild(label);
         emptyBox.y = selectedBox.y = (containSprite.height - emptyBox.height) / 2;
         label.y = (containSprite.height - label.height) / 2;
         setSizeWH(containSprite.width,containSprite.height);
      }
      
      private function resetOther() : void
      {
         var display:DisplayObject = null;
         var c:DisplayObjectContainer = this.parent as DisplayObjectContainer;
         var num:int = c.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            display = c.getChildAt(i);
            if(display is MRadioButton && display != this)
            {
               MRadioButton(display).setSelected(false);
            }
         }
      }
   }
}

