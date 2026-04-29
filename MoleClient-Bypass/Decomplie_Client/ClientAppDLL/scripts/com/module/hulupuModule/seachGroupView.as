package com.module.hulupuModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.requestAddToGroup;
   import com.module.friendList.friendView.GView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class seachGroupView extends EventDispatcher
   {
      
      private static var owner:seachGroupView;
      
      public var groupID:uint;
      
      public var groupName:String;
      
      public var targetMC:MovieClip;
      
      private var seachGroup_txt:TextField;
      
      private var reqMsg_txt:TextField;
      
      public function seachGroupView()
      {
         super();
         this.groupID = 0;
         this.groupName = "";
         this.targetMC = UIManager.getMovieClip("seachGroup_panel");
         this.targetMC.x = 960 / 2 - this.targetMC.width / 2;
         this.targetMC.y = 560 / 2 - this.targetMC.height / 2;
         this.seachGroup_txt = this.targetMC.seachGroup_txt;
         this.reqMsg_txt = this.targetMC.reqMsg_txt;
         this.seachGroup_txt.restrict = "0-9";
         BC.addEvent(this,this.targetMC.close_btn,MouseEvent.CLICK,this.closePan);
         BC.addEvent(this,this.targetMC.no_btn,MouseEvent.CLICK,this.closePan);
         BC.addEvent(this,this.targetMC.yes_btn,MouseEvent.CLICK,this.continueFun);
         BC.addEvent(this,this.targetMC,Event.REMOVED_FROM_STAGE,this.clearClass);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert);
         BC.addEvent(this,this.targetMC,MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + CommandID.GROUP_REQUESTADDTOGROUP,this.clearClass);
      }
      
      public static function getInstance() : seachGroupView
      {
         if(!owner)
         {
            owner = new seachGroupView();
         }
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
      
      private function continueFun(E:MouseEvent) : void
      {
         var msg:String = null;
         if(this.seachGroup_txt.text.length >= 5)
         {
            if(Boolean(GView.groupInfoObj[this.seachGroup_txt.text]) && GView.groupInfoObj[this.seachGroup_txt.text].Ownerid == GV.MyInfo_userID)
            {
               msg = "這個群是自己的,你已經在群中啦!";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            }
            else
            {
               this.targetMC.yes_btn.enabled = false;
               this.targetMC.yes_btn.mouseEnabled = false;
               BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_REQUESTADDTOGROUP,this.addGroup);
               new requestAddToGroup().doAction(uint(this.seachGroup_txt.text),this.reqMsg_txt.text);
            }
         }
         else
         {
            msg = "你輸入的群號碼不正確哦!";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
      
      private function addGroup(E:EventTaomee) : void
      {
         Alert.showAlert(GV.MC_AppLever,"發送請求成功，你需要等待對方通過!","",Alert.CHANG_ALERT,"iknow",true,false,"E");
         this.clearClass();
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
         this.seachGroup_txt = null;
         this.reqMsg_txt = null;
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

