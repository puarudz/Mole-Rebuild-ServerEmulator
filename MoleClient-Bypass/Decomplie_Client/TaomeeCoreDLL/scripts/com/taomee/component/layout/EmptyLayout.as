package com.taomee.component.layout
{
   import com.taomee.component.Component;
   import com.taomee.component.Container;
   import com.taomee.component.event.MEvent;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   
   [Event(name="layoutSetChanged",type="com.taomee.component.event.MEvent")]
   public class EmptyLayout extends EventDispatcher implements ILayoutManager
   {
      
      private static const TYPE:String = "emptyLayout";
      
      protected var container:Container;
      
      protected var containerSprite:Sprite;
      
      protected var margin:int;
      
      public function EmptyLayout()
      {
         super();
      }
      
      public function setContainer(container:Container) : void
      {
         this.container = container;
         this.containerSprite = container.getContainSprite();
      }
      
      public function addLayoutComponent(comp:Component, constraints:Object = null) : void
      {
         this.containerSprite.addChild(comp);
      }
      
      public function removeLayoutComponent(comp:Component) : void
      {
         for(var i:int = 0; i < this.containerSprite.numChildren; i++)
         {
            if(this.containerSprite.getChildAt(i) == comp)
            {
               this.containerSprite.removeChildAt(i);
               break;
            }
         }
      }
      
      public function doLayout() : void
      {
         var comp:Component = null;
         this.getMargin();
         for(var i:int = 0; i < this.containerSprite.numChildren; i++)
         {
            comp = this.containerSprite.getChildAt(i) as Component;
            comp.x += this.margin;
            comp.y += this.margin;
         }
      }
      
      public function clear() : void
      {
         this.containerSprite = null;
      }
      
      public function getType() : String
      {
         return TYPE;
      }
      
      protected function getMargin() : int
      {
         if(Boolean(this.container.getBorder()))
         {
            this.margin = this.container.getBorder().getBorderMargin();
         }
         else
         {
            this.margin = 0;
         }
         return this.margin;
      }
      
      protected function broadcast() : void
      {
         dispatchEvent(new MEvent(MEvent.LAYOUT_SET_CHANGED));
      }
   }
}

