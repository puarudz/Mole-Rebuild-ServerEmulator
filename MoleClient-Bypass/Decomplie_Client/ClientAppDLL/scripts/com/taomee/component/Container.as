package com.taomee.component
{
   import com.taomee.component.event.ContainerEvent;
   import com.taomee.component.event.MEvent;
   import com.taomee.component.layout.FlowLayout;
   import com.taomee.component.layout.ILayoutManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   [Event(name="compRemoved",type="com.taomee.component.event.ContainerEvent")]
   [Event(name="compAdded",type="com.taomee.component.event.ContainerEvent")]
   public class Container extends Component
   {
      
      protected var layoutManager:ILayoutManager;
      
      private var compArray:Array;
      
      public function Container()
      {
         super();
         this.compArray = [];
         this.layoutManager = new FlowLayout();
         this.layoutManager.setContainer(this);
         this.addLayoutHandler();
      }
      
      public function append(comp:Component, constraints:Object = null) : void
      {
         this.layoutManager.addLayoutComponent(comp,constraints);
         this.compArray.push(comp);
         containSprite.addChild(comp);
         this.layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,comp));
      }
      
      public function appendAt(comp:Component, index:int) : void
      {
         var mc:Component = null;
         containSprite.addChildAt(comp,index);
         this.compArray = [];
         var num:int = containSprite.numChildren;
         for(var j:int = 0; j < num; j++)
         {
            mc = containSprite.getChildAt(j) as Component;
            if(Boolean(mc))
            {
               this.compArray.push(mc);
            }
         }
         this.layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,comp));
      }
      
      public function appendAll(... comps) : void
      {
         var i:Component = null;
         var num:int = 0;
         var j:int = 0;
         var mc:DisplayObject = null;
         for each(i in comps)
         {
            this.layoutManager.addLayoutComponent(i);
            containSprite.addChild(i);
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,i));
         }
         this.compArray = [];
         num = containSprite.numChildren;
         for(j = 0; j < num; j++)
         {
            mc = containSprite.getChildAt(j);
            if(mc is Component)
            {
               this.compArray.push(mc);
            }
         }
         this.layoutManager.doLayout();
      }
      
      public function remove(comp:Component) : void
      {
         var num:int = this.compArray.indexOf(comp);
         if(num != -1)
         {
            this.layoutManager.removeLayoutComponent(comp);
            comp.destroy();
            this.compArray.splice(num,1);
            this.layoutManager.doLayout();
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,comp));
         }
      }
      
      public function removeAll() : void
      {
         var i:Component = null;
         for each(i in this.compArray)
         {
            this.layoutManager.removeLayoutComponent(i);
            i.destroy();
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,i));
         }
         this.compArray = [];
      }
      
      override public function destroy() : void
      {
         this.removeAll();
         this.compArray = null;
         this.layoutManager.removeEventListener(MEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.layoutManager.clear();
         this.layoutManager = null;
         super.destroy();
      }
      
      override public function updateView() : void
      {
         var i:Component = null;
         for each(i in this.compArray)
         {
            i.updateView();
         }
         super.updateView();
         this.initLayout();
      }
      
      public function getCompArray() : Array
      {
         return this.compArray;
      }
      
      protected function addLayoutHandler() : void
      {
         this.layoutManager.addEventListener(MEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.initLayout();
      }
      
      protected function initLayout() : void
      {
         var i:Component = null;
         this.layoutManager.setContainer(this);
         if(this.compArray.length > 0)
         {
            for each(i in this.compArray)
            {
               i.updateView();
               this.layoutManager.addLayoutComponent(i);
            }
            this.layoutManager.doLayout();
         }
      }
      
      private function layoutChanged(event:MEvent) : void
      {
         this.initLayout();
      }
      
      public function getContainSprite() : Sprite
      {
         return containSprite;
      }
      
      public function setLayout(layout:ILayoutManager) : void
      {
         this.layoutManager = layout;
         this.layoutManager.addEventListener(MEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.updateView();
      }
      
      public function getLayout() : ILayoutManager
      {
         return this.layoutManager;
      }
   }
}

