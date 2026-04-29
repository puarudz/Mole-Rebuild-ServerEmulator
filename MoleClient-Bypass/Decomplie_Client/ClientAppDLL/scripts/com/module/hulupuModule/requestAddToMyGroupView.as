package com.module.hulupuModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class requestAddToMyGroupView extends EventDispatcher
   {
      
      private static var owner:requestAddToMyGroupView;
      
      public var UserID:uint;
      
      public var targetMC:MovieClip;
      
      public function requestAddToMyGroupView(_UserID:uint, UserName:String, requestMsg:String, frames:uint)
      {
         super();
         this.UserID = _UserID;
         this.targetMC = UIManager.getMovieClip("requestGroup_panel");
         this.targetMC.x = 960 / 2 - this.targetMC.width / 2;
         this.targetMC.y = 560 / 2 - this.targetMC.height / 2;
         this.targetMC.tip_mc.gotoAndStop(frames);
         var ManMC:MovieClip = UIManager.getMovieClip("Man");
         ManMC.x = 172;
         ManMC.y = 90;
         ManMC.userName.text = UserName + "(" + this.UserID + ")";
         ManMC.userName.mouseEnabled = false;
         ManMC.del_btn.visible = false;
         ManMC.chat_btn.visible = false;
         ManMC.prev_mc.visible = false;
         ManMC.prev_pet.visible = false;
         ManMC.head_btn.visible = false;
         ManMC.buttonMode = true;
         ManMC.addChild(UIManager.getMovieClip("defaultManHead_mc"));
         BC.addEvent(this,ManMC,MouseEvent.MOUSE_DOWN,this.showInfoFun);
         this.targetMC.addChild(ManMC);
         this.targetMC.reqMsg_txt.text = requestMsg == null ? " " : requestMsg;
         BC.addEvent(this,this.targetMC.yes_btn,MouseEvent.CLICK,this.okFun);
         BC.addEvent(this,this.targetMC.no_btn,MouseEvent.CLICK,this.noFun);
         BC.addEvent(this,this.targetMC.close_btn,MouseEvent.CLICK,this.closePan);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert);
         BC.addEvent(this,this.targetMC,MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         MainManager.getAppLevel().addChild(this.targetMC);
      }
      
      public static function getInstance(UserID:uint, UserName:String, requestMsg:String, frames:uint) : requestAddToMyGroupView
      {
         if(Boolean(owner))
         {
            owner.clearClass();
         }
         owner = new requestAddToMyGroupView(UserID,UserName,requestMsg,frames);
         return owner;
      }
      
      public static function inStage() : Boolean
      {
         if(Boolean(owner.targetMC) && Boolean(owner.targetMC.parent))
         {
            return true;
         }
         return false;
      }
      
      private function okFun(E:MouseEvent) : void
      {
         dispatchEvent(new Event(Alert.CLICK_ + "1"));
         this.clearClass();
      }
      
      private function noFun(E:MouseEvent) : void
      {
         dispatchEvent(new Event(Alert.CLICK_ + "2"));
         this.clearClass();
      }
      
      private function showInfoFun(E:MouseEvent) : void
      {
         userPanelView.showUserPanel(this.UserID);
      }
      
      private function closePan(E:MouseEvent) : void
      {
         this.clearClass();
      }
      
      private function clearClass(E:* = null) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.targetMC) && Boolean(this.targetMC.parent))
         {
            this.targetMC.parent.removeChild(this.targetMC);
         }
         this.targetMC = null;
         owner = null;
      }
      
      private function dragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.startDrag();
      }
      
      private function movedragAlert(event:MouseEvent) : void
      {
         event.updateAfterEvent();
      }
      
      private function stopdragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.parent.stopDrag();
      }
      
      public function sendDepthToTop(event:MouseEvent) : void
      {
         var topPosition:uint = event.currentTarget.parent.numChildren - 1;
         event.currentTarget.parent.setChildIndex(event.currentTarget,topPosition);
      }
   }
}

