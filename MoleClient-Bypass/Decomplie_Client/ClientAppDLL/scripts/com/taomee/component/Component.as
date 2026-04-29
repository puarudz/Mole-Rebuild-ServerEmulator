package com.taomee.component
{
   import com.taomee.component.bgFill.IBgFillStyle;
   import com.taomee.component.border.IBorder;
   import com.taomee.component.geom.IntDimension;
   import flash.events.Event;
   
   public class Component extends MSprite
   {
      
      protected var preferredWidth:int = -1;
      
      protected var preferredHeight:int = -1;
      
      private var bgFillStyle:IBgFillStyle;
      
      private var border:IBorder;
      
      public function Component()
      {
         super(true);
         this.visible = false;
         this.addStageListener();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.bgFillStyle))
         {
            this.bgFillStyle.clear();
         }
         this.bgFillStyle = null;
         super.destroy();
      }
      
      public function updateView() : void
      {
         var margin:int = 0;
         if(!this.stage)
         {
            return;
         }
         if(Boolean(this.bgFillStyle))
         {
            this.bgFillStyle.reDraw();
         }
         if(Boolean(this.border))
         {
            this.border.drawBorder(bgMC.graphics,this);
            margin = this.border.getBorderMargin();
            maskMC.width = bgMaskMC.width - margin * 2;
            maskMC.height = bgMaskMC.height - margin * 2;
            maskMC.x = maskMC.y = margin;
         }
      }
      
      public function setEnabled(b:Boolean) : void
      {
         this.mouseChildren = b;
         this.mouseEnabled = b;
         if(b)
         {
            this.alpha = 1;
         }
         else
         {
            this.alpha = 0.5;
         }
      }
      
      public function setBorder(border:IBorder) : void
      {
         if(Boolean(this.border))
         {
            this.border.clear();
         }
         this.border = border;
         this.updateView();
      }
      
      public function getBorder() : IBorder
      {
         return this.border;
      }
      
      public function addStageListener() : void
      {
         this.addEventListener(Event.ADDED_TO_STAGE,this.addedToStageEvent);
      }
      
      public function removeStageListener() : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageEvent);
      }
      
      protected function addedToStageEvent(event:Event) : void
      {
         this.updateView();
         this.visible = true;
      }
      
      public function countPreferredSize() : IntDimension
      {
         var w:int = 0;
         var h:int = 0;
         if(this.preferredWidth == -1)
         {
            w = containSprite.width;
         }
         else
         {
            w = this.getPreferredWidth();
         }
         if(this.preferredHeight == -1)
         {
            h = containSprite.height;
         }
         else
         {
            h = this.getPreferredHeight();
         }
         return new IntDimension(w,h);
      }
      
      public function setBgFillStyle(bgFillStyle:IBgFillStyle) : void
      {
         if(Boolean(this.bgFillStyle))
         {
            this.bgFillStyle.clear();
         }
         if(bgFillStyle == null)
         {
            this.bgFillStyle = null;
         }
         else
         {
            this.bgFillStyle = bgFillStyle;
            this.bgFillStyle.draw(bgMC);
         }
      }
      
      public function setPreferredWidth(i:int) : void
      {
         if(i < 0)
         {
            this.preferredWidth = 0;
         }
         else
         {
            this.preferredWidth = i;
         }
      }
      
      public function setPreferredHeight(i:int) : void
      {
         if(i < 0)
         {
            this.preferredHeight = 0;
         }
         else
         {
            this.preferredHeight = i;
         }
      }
      
      public function setPreferredSize(w:int, h:int) : void
      {
         if(w == this.preferredWidth && h == this.preferredHeight)
         {
            return;
         }
         this.setPreferredWidth(w);
         this.setPreferredHeight(h);
      }
      
      public function setWidth(i:int) : void
      {
         if(i == width)
         {
            return;
         }
         width = i;
         this.updateView();
      }
      
      public function setHeight(i:int) : void
      {
         if(i == height)
         {
            return;
         }
         height = i;
         this.updateView();
      }
      
      public function setSizeWH(w:int, h:int) : void
      {
         if(w == width && h == height)
         {
            return;
         }
         this.setWidth(w);
         this.setHeight(h);
      }
      
      public function getPreferredWidth() : int
      {
         return this.preferredWidth;
      }
      
      public function getPreferredHeight() : int
      {
         return this.preferredHeight;
      }
      
      public function getWidth() : int
      {
         return width;
      }
      
      public function getHeight() : int
      {
         return height;
      }
   }
}

