package com.common.newAlert
{
   import com.common.newAlert.event.AlertEvent;
   import com.taomee.component.Component;
   import com.taomee.component.MButton;
   import com.taomee.component.MFrame;
   import com.taomee.component.MLoadPane;
   import com.taomee.component.MPanel;
   import com.taomee.component.MTextField;
   import com.taomee.component.event.ContainerEvent;
   import com.taomee.component.layout.CenterLayout;
   import com.taomee.component.layout.FlowLayout;
   import com.taomee.component.layout.SoftBoxLayout;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   [Event(name="alertClosed",type="com.common.newAlert.event.AlertEvent")]
   public class BuyBox extends MFrame implements IAlert
   {
      
      private var MIN_WIDTH:int = 260;
      
      private var MIN_HEIGHT:int = 220;
      
      protected var contentPanel:MPanel;
      
      protected var btnPanel:MPanel;
      
      protected var txt:MTextField;
      
      protected var loadPane:MLoadPane;
      
      private var applyFun:Function;
      
      private var cancelFun:Function;
      
      public function BuyBox(str:String, icon:*, applyFun:Function = null, cancelFun:Function = null, owner:DisplayObjectContainer = null, isShowClose:Boolean = true)
      {
         super(owner,false);
         this.applyFun = applyFun;
         this.cancelFun = cancelFun;
         this.initBox(str,icon);
         this.cacheAsBitmap = true;
      }
      
      public function getOwner() : DisplayObject
      {
         return this;
      }
      
      public function close() : void
      {
         this.btnPanel.removeEventListener(ContainerEvent.COMP_ADDED,this.compChangedHandler);
         this.btnPanel.removeEventListener(ContainerEvent.COMP_REMOVED,this.compChangedHandler);
         this.contentPanel.removeEventListener(ContainerEvent.COMP_ADDED,this.contentAddComp);
         this.contentPanel.removeEventListener(ContainerEvent.COMP_REMOVED,this.contentRemoveComp);
         this.destroy();
         this.contentPanel = null;
         this.btnPanel = null;
         this.txt = null;
         this.loadPane = null;
         this.applyFun = null;
         this.cancelFun = null;
      }
      
      public function getMainPanel() : MPanel
      {
         return this.contentPanel;
      }
      
      public function getButtonPanel() : MPanel
      {
         return this.btnPanel;
      }
      
      public function getTextField() : MTextField
      {
         return this.txt;
      }
      
      public function getLoadPane() : MLoadPane
      {
         return this.loadPane;
      }
      
      public function setApplyFun(fun:Function) : void
      {
         this.applyFun = fun;
      }
      
      public function setCancelFun(fun:Function) : void
      {
         this.cancelFun = fun;
      }
      
      public function setMiniWidthEnabled(b:Boolean) : void
      {
         if(b)
         {
            this.MIN_WIDTH = 260;
         }
         else
         {
            this.MIN_WIDTH = 0;
         }
      }
      
      public function setMiniHeightEnabled(b:Boolean) : void
      {
         if(b)
         {
            this.MIN_WIDTH = 220;
         }
         else
         {
            this.MIN_WIDTH = 0;
         }
      }
      
      private function initBox(str:String, icon:*) : void
      {
         this.txt = new MTextField(str);
         this.txt.setEnabled(false);
         var applyBtn:MButton = new MButton(MButton.FLAG_ok);
         var cancelBtn:MButton = new MButton(MButton.FLAG_cancel,MButton.BLUE);
         applyBtn.addEventListener(MouseEvent.CLICK,this.applyHandler);
         cancelBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         applyBtn.buttonMode = cancelBtn.buttonMode = true;
         applyBtn.setHeight(35);
         cancelBtn.setHeight(35);
         this.btnPanel = new MPanel(new FlowLayout(FlowLayout.CENTER,30));
         this.btnPanel.setPreferredHeight(applyBtn.getHeight() + 10);
         this.btnPanel.appendAll(applyBtn,cancelBtn);
         this.loadPane = new MLoadPane(icon,MLoadPane.ADJUST_HEIGHT);
         this.loadPane.setPreferredHeight(80);
         this.contentPanel = new MPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS,0,0));
         setLayout(new CenterLayout());
         append(this.contentPanel);
         this.updateUI();
         show();
         this.btnPanel.addEventListener(ContainerEvent.COMP_ADDED,this.compChangedHandler);
         this.btnPanel.addEventListener(ContainerEvent.COMP_REMOVED,this.compChangedHandler);
         this.contentPanel.addEventListener(ContainerEvent.COMP_ADDED,this.contentAddComp);
         this.contentPanel.addEventListener(ContainerEvent.COMP_REMOVED,this.contentRemoveComp);
         this.contentPanel.cacheAsBitmap = true;
      }
      
      private function compChangedHandler(event:ContainerEvent) : void
      {
         if(this.btnPanel.numChildren > 2)
         {
            FlowLayout(this.btnPanel.getLayout()).setHgap(5);
         }
         else
         {
            FlowLayout(this.btnPanel.getLayout()).setHgap(30);
         }
         this.updateUI();
      }
      
      private function contentAddComp(event:ContainerEvent) : void
      {
         var gap:int = SoftBoxLayout(this.contentPanel.getLayout()).getGap();
         this.contentPanel.setHeight(this.contentPanel.getContainSprite().height);
         setHeight(Math.max(this.contentPanel.getHeight() + 50,this.MIN_HEIGHT));
      }
      
      private function contentRemoveComp(event:ContainerEvent) : void
      {
         var gap:int = SoftBoxLayout(this.contentPanel.getLayout()).getGap() + 4;
         this.contentPanel.setHeight(this.contentPanel.getContainSprite().height);
         setHeight(Math.max(this.contentPanel.getHeight() + 50,this.MIN_HEIGHT));
      }
      
      public function updateUI() : void
      {
         var comp:Component = null;
         var w:Number = 0;
         var layout:FlowLayout = this.btnPanel.getLayout() as FlowLayout;
         for(var i:int = 0; i < this.btnPanel.numChildren; i++)
         {
            comp = this.btnPanel.getChildAt(i) as Component;
            w += comp.getWidth();
         }
         w += layout.getHgap() * this.btnPanel.numChildren + 20;
         if(this.txt.getPreferredWidth() == -1)
         {
            this.txt.setWidth(Math.max(w,this.txt.getTextField().textWidth + 6,this.MIN_WIDTH));
         }
         else
         {
            this.txt.setWidth(Math.max(w,this.txt.getPreferredWidth() + 6,this.MIN_WIDTH));
         }
         this.txt.setWordWrap(true);
         this.txt.setPreferredHeight(this.txt.getTextField().textHeight + 10);
         if(this.txt.getPreferredWidth() == -1)
         {
            this.contentPanel.setWidth(this.txt.getWidth());
         }
         else
         {
            this.contentPanel.setWidth(this.txt.getWidth());
         }
         this.contentPanel.appendAll(this.txt,this.loadPane,this.btnPanel);
         var h:Number = 0;
         for(var j:int = 0; j < this.contentPanel.numChildren; j++)
         {
            comp = this.contentPanel.getChildAt(j) as Component;
            h += comp.getPreferredHeight();
         }
         h += SoftBoxLayout(this.contentPanel.getLayout()).getGap() * this.contentPanel.numChildren;
         this.contentPanel.setHeight(h + 5);
         setWidth(Math.max(this.contentPanel.getWidth() + 50,this.MIN_WIDTH));
         setHeight(Math.max(this.contentPanel.getHeight() + 50,this.MIN_HEIGHT));
      }
      
      private function applyHandler(event:MouseEvent) : void
      {
         if(this.applyFun != null)
         {
            this.applyFun();
         }
         else
         {
            this.closeHandler(null);
         }
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         if(this.cancelFun != null)
         {
            this.cancelFun();
         }
         dispatchEvent(new AlertEvent(AlertEvent.ALERT_CLOSED));
         this.close();
      }
   }
}

