package com.taomee.component
{
   import com.taomee.component.bgFill.IBgFillStyle;
   import com.taomee.component.event.MEvent;
   import com.taomee.component.layout.ILayoutManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Event(name="frameClosed",type="com.taomee.component.event.MEvent")]
   public class MFrame extends Container
   {
      
      private static var TOP_MARGIN:int = 22;
      
      private static var LEFT_MARGIN:int = 22;
      
      private static var BOTTOM_MARGIN:int = 22;
      
      private static var RIGHT_MARGIN:int = 22;
      
      private var isShowClose:Boolean;
      
      private var bgClass:Class = MFrame_bgClass;
      
      private var closeBtnClass:Class = MFrame_closeBtnClass;
      
      private var panel:MPanel;
      
      private var owner:DisplayObjectContainer;
      
      private var frameBG:Sprite;
      
      private var closeBtn:SimpleButton;
      
      public function MFrame(owner:DisplayObjectContainer = null, isShowClose:Boolean = true)
      {
         super();
         this.owner = owner;
         this.isShowClose = isShowClose;
         this.panel = new MPanel();
         this.panel.x = LEFT_MARGIN;
         this.panel.y = TOP_MARGIN;
         this.panel.setMouseEnabled(false);
         this.frameBG = new this.bgClass() as Sprite;
         this.frameBG.width = this.width;
         this.frameBG.height = this.height;
         this.frameBG.cacheAsBitmap = true;
         this.closeBtn = new this.closeBtnClass() as SimpleButton;
         this.closeBtn.tabEnabled = false;
         this.closeBtn.cacheAsBitmap = true;
         addChild(this.frameBG);
         addChild(this.panel);
         if(this.isShowClose)
         {
            addChild(this.closeBtn);
         }
         this.setCloseBtnPosition();
         this.frameBG.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.frameBG.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
      }
      
      public function show() : void
      {
         if(Boolean(this.owner))
         {
            this.owner.addChild(this);
         }
         else
         {
            MComponentManager.getCompRoot().addChild(this);
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function append(comp:Component, constraints:Object = null) : void
      {
         this.panel.append(comp,constraints);
      }
      
      override public function appendAt(comp:Component, index:int) : void
      {
         this.panel.appendAt(comp,index);
      }
      
      override public function appendAll(... comps) : void
      {
         var i:Component = null;
         for each(i in comps)
         {
            this.panel.append(i);
         }
      }
      
      override public function setLayout(layout:ILayoutManager) : void
      {
         this.panel.setLayout(layout);
      }
      
      override public function getLayout() : ILayoutManager
      {
         return this.panel.getLayout();
      }
      
      public function getContentPanel() : Container
      {
         return this.panel;
      }
      
      override public function destroy() : void
      {
         removeChild(this.frameBG);
         this.frameBG.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.frameBG.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.frameBG = null;
         removeChild(this.panel);
         this.panel.destroy();
         this.panel = null;
         this.owner = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.isShowClose)
         {
            removeChild(this.closeBtn);
         }
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.closeBtn = null;
         super.destroy();
      }
      
      override public function setBgFillStyle(bgFillStyle:IBgFillStyle) : void
      {
         this.panel.setBgFillStyle(bgFillStyle);
      }
      
      override public function setWidth(i:int) : void
      {
         super.setWidth(i);
         this.frameBG.width = this.width;
         this.panel.setWidth(this.width - LEFT_MARGIN - RIGHT_MARGIN - 3);
         this.setCloseBtnPosition();
      }
      
      override public function setHeight(i:int) : void
      {
         super.setHeight(i);
         this.frameBG.height = this.height;
         this.panel.setHeight(this.height - TOP_MARGIN - BOTTOM_MARGIN - 4);
         this.setCloseBtnPosition();
      }
      
      override public function setSizeWH(w:int, h:int) : void
      {
         this.setWidth(w);
         this.setHeight(h);
         this.updateView();
      }
      
      override public function updateView() : void
      {
         this.panel.updateView();
         super.updateView();
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         this.hide();
         dispatchEvent(new MEvent(MEvent.FRAME_CLOSED));
      }
      
      private function setCloseBtnPosition() : void
      {
         this.closeBtn.x = this.width - this.closeBtn.width - 2;
         this.closeBtn.y = -1;
      }
   }
}

