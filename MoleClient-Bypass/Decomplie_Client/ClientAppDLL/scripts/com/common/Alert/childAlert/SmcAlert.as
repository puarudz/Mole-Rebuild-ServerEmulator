package com.common.Alert.childAlert
{
   import com.common.util.MovieClipUtil;
   import com.core.manager.IndexManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class SmcAlert extends EventDispatcher
   {
      
      private var myAlert:*;
      
      private var displayObj:*;
      
      private var _title:String;
      
      private var _content:String;
      
      private var _style:uint;
      
      private var buttonArr:Array;
      
      private var _closeB:Boolean;
      
      public function SmcAlert(obj:*, title:String = "提示", content:String = "...", style:uint = 0, bottomArray:String = "確定", closeB:Boolean = true)
      {
         super();
         this.displayObj = obj;
         this._title = title;
         this._content = content;
         this._style = style;
         this.buttonArr = bottomArray.split("，");
         this._closeB = closeB;
         this.showAlert();
      }
      
      private function showAlert() : void
      {
         if(!this.displayObj.getChildByName("myAlert_SMC"))
         {
            this.myAlert = IndexManager.getInstance().getMovieClip("Alter_SMC");
            this.myAlert.name = "myAlert_SMC";
            this.displayObj.addChild(this.myAlert);
            this.myAlert.x = (GV.stageWidth - this.myAlert.width) / 2;
            this.myAlert.y = (GV.stageHeight - this.myAlert.height) / 2;
            BC.addEvent(this,this.myAlert.smcClose,MouseEvent.CLICK,this.smcCloseHandler);
            if(this._closeB)
            {
               this.myAlert.content_txt.text = this._content;
               this.myAlert.title.visible = false;
               this.myAlert.smc_bz.visible = true;
            }
            else
            {
               this.myAlert.smc_bz.visible = false;
               this.myAlert.title.visible = true;
               this.myAlert.system_txt.text = this._content;
            }
            this.setButtonHeight();
            this.dragAndDepthManage();
         }
      }
      
      private function smcCloseHandler(event:MouseEvent) : void
      {
         BC.removeEvent(this);
         this.displayObj.removeChild(this.myAlert);
         this.myAlert.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragAlert);
         this.myAlert.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.stopdragAlert);
         this.myAlert.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.movedragAlert);
         this.myAlert.removeEventListener(MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         this.myAlert = null;
      }
      
      private function setButtonHeight() : void
      {
         var bt:* = undefined;
         var i:int = 0;
         var BT:MovieClip = null;
         if(this.buttonArr.length == 1)
         {
            bt = IndexManager.getInstance().getMovieClip("SMC_BUTTON");
            bt.num = 0;
            bt.buttonName = this.buttonArr[0];
            bt.name = "bt";
            MovieClipUtil.gotoAndStop(bt,this.buttonArr[0]);
            this.myAlert.addChild(bt);
            bt.x = this.myAlert.drag_mc.width / 2 - bt.width / 2;
            bt.y = this.myAlert.drag_mc.height / 2 + 2.5 * bt.height;
            BC.addEvent(this,bt,MouseEvent.CLICK,this.dispatchFunc);
         }
         else if(this.buttonArr.length == 2)
         {
            for(i = 0; i < this.buttonArr.length; i++)
            {
               BT = IndexManager.getInstance().getMovieClip("SMC_BUTTON");
               BT.num = i + 1;
               if(MovieClipUtil.isFrameLabel(BT,this.buttonArr[i]))
               {
                  BT.gotoAndStop(this.buttonArr[i]);
               }
               else
               {
                  BT.stop();
               }
               BT.name = "BT" + i;
               this.myAlert.addChild(BT);
               if(i == 0)
               {
                  BT.x = this.myAlert.drag_mc.width / 2 - 120;
               }
               else if(i == 1)
               {
                  BT.x = this.myAlert.drag_mc.width / 2 + 50;
               }
               BT.y = this.myAlert.drag_mc.height / 2 + 2.5 * 32;
               BC.addEvent(this,BT,MouseEvent.CLICK,this.dispatchFunc);
            }
         }
      }
      
      private function dispatchFunc(event:MouseEvent) : void
      {
         BC.removeEvent(this);
         dispatchEvent(new Event("CLICK" + event.currentTarget.num));
         GC.clearAllChildren(this.myAlert);
         this.displayObj.removeChild(this.myAlert);
      }
      
      private function dragAndDepthManage() : void
      {
         BC.addEvent(this,this.myAlert.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert,false,0,true);
         BC.addEvent(this,this.myAlert.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert,false,0,true);
         BC.addEvent(this,this.myAlert.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert,false,0,true);
         BC.addEvent(this,this.myAlert,MouseEvent.MOUSE_DOWN,this.sendDepthToTop,false,0,true);
      }
      
      public function dragAlert(event:MouseEvent = null) : void
      {
         GF.setDrag(this.myAlert);
      }
      
      public function movedragAlert(event:MouseEvent = null) : void
      {
         event.updateAfterEvent();
      }
      
      public function stopdragAlert(event:MouseEvent = null) : void
      {
         GF.stopDrag(this.myAlert);
      }
      
      public function sendDepthToTop(event:MouseEvent = null) : void
      {
         var topPosition:uint = event.currentTarget.parent.numChildren - 1;
         event.currentTarget.parent.setChildIndex(event.currentTarget,topPosition);
      }
   }
}

