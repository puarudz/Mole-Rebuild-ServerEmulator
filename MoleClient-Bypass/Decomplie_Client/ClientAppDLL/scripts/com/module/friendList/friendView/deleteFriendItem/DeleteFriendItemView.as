package com.module.friendList.friendView.deleteFriendItem
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.logic.socket.delFrend.DelFrendReq;
   import com.logic.socket.delFrend.DelFrendRes;
   import com.view.userPanelView.userPanelView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   
   public class DeleteFriendItemView extends Sprite
   {
      
      public static const DeleteFriendSuccess:String = "DeleteFriendItemView_DeleteFriendSuccess";
      
      public static const UpdateSelectedState:String = "DeleteFriendItemView_UpdateSelectedState";
      
      private var _ui:MovieClip;
      
      private var _userId:int;
      
      public function DeleteFriendItemView(userId:int)
      {
         var i:uint = 0;
         super();
         this._userId = userId;
         var cls:Class = UIManager.getClass("deleteMan") as Class;
         this._ui = new cls();
         this.addChild(this._ui);
         var so:SharedObject = MainManager.getGlobalObject();
         var friendsList:Array = so.data.FriendsList;
         if(Boolean(friendsList))
         {
            for(i = 0; i < friendsList.length; i++)
            {
               if(friendsList[i].UserID == userId)
               {
                  this._ui.userName.text = friendsList[i].Nick;
               }
            }
         }
         BC.addEvent(this,this._ui.head_btn,MouseEvent.MOUSE_OVER,this.OnMouseOver);
         BC.addEvent(this,this._ui.head_btn,MouseEvent.MOUSE_OUT,this.OnMouseOut);
         BC.addEvent(this,this._ui.del_btn,MouseEvent.CLICK,this.Delete);
         BC.addEvent(this,this._ui.head_btn,MouseEvent.CLICK,this.OpenUserView);
         this._ui.checkBox_mc.buttonMode = true;
         BC.addEvent(this,this._ui.checkBox_mc,MouseEvent.CLICK,this.SetCheckBox);
      }
      
      public function get selected() : Boolean
      {
         return MovieClip(this._ui.checkBox_mc).currentFrame == 2;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(value)
         {
            MovieClip(this._ui.checkBox_mc).gotoAndStop(2);
         }
         else
         {
            MovieClip(this._ui.checkBox_mc).gotoAndStop(1);
         }
         this.dispatchEvent(new Event(UpdateSelectedState));
      }
      
      private function SetCheckBox(e:MouseEvent) : void
      {
         this.selected = !this.selected;
      }
      
      private function OpenUserView(e:MouseEvent) : void
      {
         userPanelView.showUserPanel(this._userId);
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      private function Delete(e:MouseEvent) : void
      {
         Alert.angryAlart("確認要刪除" + this._ui.userName.text + "(" + this._userId + ")" + "好友嗎?",this.ConfirmDelete,"sure,cancel");
      }
      
      private function ConfirmDelete(e:*) : void
      {
         BC.addEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FREND,this.DeleteSuccessHandler);
         BC.addEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FAIL,this.DeleteFailHandler);
         var delFrendReq:DelFrendReq = new DelFrendReq();
         delFrendReq.delfrend(this._userId);
      }
      
      private function DeleteSuccessHandler(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FREND,this.DeleteSuccessHandler);
         BC.removeEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FAIL,this.DeleteFailHandler);
         this.dispatchEvent(new Event(DeleteFriendSuccess));
      }
      
      private function DeleteFailHandler(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FREND,this.DeleteSuccessHandler);
         BC.removeEvent(this,GV.onlineSocket,DelFrendRes.DELETE_FAIL,this.DeleteFailHandler);
      }
      
      private function OnMouseOver(e:MouseEvent) : void
      {
         this._ui.bgMC.gotoAndStop(2);
      }
      
      private function OnMouseOut(e:MouseEvent) : void
      {
         this._ui.bgMC.gotoAndStop(1);
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
   }
}

