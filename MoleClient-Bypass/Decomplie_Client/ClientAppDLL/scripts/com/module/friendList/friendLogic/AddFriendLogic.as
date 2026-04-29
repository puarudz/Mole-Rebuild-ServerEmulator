package com.module.friendList.friendLogic
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.logic.socket.addFrends.AddFrendsReq;
   import flash.events.MouseEvent;
   
   public class AddFriendLogic
   {
      
      private var requset_mc:*;
      
      private var requestUser_mc:*;
      
      private var _userID:uint;
      
      private var _userNick:String;
      
      private var addFrendsReq:AddFrendsReq;
      
      public function AddFriendLogic()
      {
         super();
      }
      
      public function addFriend(userID:uint, userNick:String) : void
      {
         if(MainManager.getGlobalObject().data.ServerFriendsList.length >= LocalUserInfo.friendsLimitNum())
         {
            Alert.showAlert(MainManager.getAppLevel(),"你的好友已經到達上限!","",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
         else
         {
            this._userID = userID;
            this._userNick = userNick;
            if(!MainManager.getAppLevel().getChildByName("requset_mc"))
            {
               this.requset_mc = UIManager.getClass("requestUserPanel_MC");
               this.requestUser_mc = new this.requset_mc();
               this.requestUser_mc.name = "requset_mc";
               MainManager.getAppLevel().addChild(this.requestUser_mc);
               this.requestUser_mc.x = (MainManager.getStageWidth() - this.requestUser_mc.width) / 2;
               this.requestUser_mc.y = (MainManager.getStageHeight() - this.requestUser_mc.height) / 2;
            }
            this.requestUser_mc.addfriend_txt.wordWrap = true;
            this.requestUser_mc.addfriend_txt.text = "你要加" + userNick + "(" + userID + ")" + "為好友?";
            this.requestUser_mc.friend_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.friendDrag);
            this.requestUser_mc.friend_mc.addEventListener(MouseEvent.MOUSE_UP,this.friendStopDrag);
            this.requestUser_mc.confirmBtn.addEventListener(MouseEvent.CLICK,this.reqUsrConfir);
            this.requestUser_mc.cancelBtn.addEventListener(MouseEvent.CLICK,this.reqUsrCancel);
            GC.stopAllMC(this.requestUser_mc);
         }
      }
      
      private function reqUsrConfir(event:MouseEvent) : void
      {
         if(this._userID > GV.userIDLimit)
         {
            Alert.smileAlart("不能加遊客為好友。");
         }
         else
         {
            this.addFrendsReq = new AddFrendsReq();
            this.addFrendsReq.addFrends(this._userID);
            this.addFrendsReq = null;
         }
         MainManager.getAppLevel().removeChild(this.requestUser_mc);
      }
      
      private function reqUsrCancel(event:MouseEvent) : void
      {
         MainManager.getAppLevel().removeChild(this.requestUser_mc);
      }
      
      private function friendDrag(evt:MouseEvent) : void
      {
         GF.setDrag(this.requestUser_mc);
      }
      
      private function friendStopDrag(evt:MouseEvent) : void
      {
         GF.stopDrag(this.requestUser_mc);
      }
   }
}

