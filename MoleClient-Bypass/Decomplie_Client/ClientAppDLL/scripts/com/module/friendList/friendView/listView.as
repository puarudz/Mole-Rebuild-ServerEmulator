package com.module.friendList.friendView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.socket.addFrends.AddFrendsReq;
   import com.logic.socket.addFrends.AddFrendsRes;
   import com.logic.socket.lockHome.lockHomeReq;
   import com.logic.socket.lockHome.lockHomeRes;
   import com.view.userPanelView.userPanelView;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   
   public class listView extends MovieClip
   {
      
      public var owner:listView;
      
      public var Man:Class;
      
      private var RootMC:MovieClip;
      
      private var BtnMC:MovieClip;
      
      private var whichList:int = 5;
      
      private var addFriendPanel:*;
      
      private var addID:uint;
      
      private var lockhomereq:lockHomeReq;
      
      private var _deleteView:DeleteFriendView;
      
      public function listView(mc:MovieClip, man:Class)
      {
         super();
         this.init(mc,man);
      }
      
      private static function addFriendReqSucc(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(AddFrendsRes.ADD_FREND,addFriendReqSucc);
         Alert.showAlert(GV.MC_AppLever,"發送請求成功，你需要等待對方通過!","",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      private static function removeaddFriendReq() : void
      {
         GV.onlineSocket.removeEventListener(AddFrendsRes.ADD_FREND,addFriendReqSucc);
      }
      
      private static function addFriend(evt:*) : void
      {
         if(evt.EventObj.Type == 604)
         {
            if(evt.EventObj.ICON == 1)
            {
               if(!MainManager.getGlobalObject().data.FriendsList)
               {
                  MainManager.getGlobalObject().data.FriendsList = new Array();
               }
               if(userPanelView.checkUser(evt.EventObj.UserID))
               {
                  MainManager.getGlobalObject().data.ServerFriendsList.push({
                     "friend":evt.EventObj.UserID,
                     "time":0
                  });
                  MainManager.getGlobalObject().data.FriendsList.push({
                     "Vip":-1,
                     "Color":0,
                     "UserID":evt.EventObj.UserID,
                     "time":-1,
                     "type":evt.EventObj.Type,
                     "map":evt.EventObj.Map,
                     "Nick":evt.EventObj.Nike,
                     "icon":evt.EventObj.ICON,
                     "schema":evt.EventObj.Schema,
                     "infoMsgLen":evt.EventObj.InfoMsgLen,
                     "infoMsg":evt.EventObj.InfoMsg
                  });
                  try
                  {
                     MainManager.getGlobalObject().flush();
                  }
                  catch(e:*)
                  {
                  }
                  GV.onlineSocket.dispatchEvent(new EventTaomee(userPanelView.ADDFRIEND_SUCCESS));
               }
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee(userPanelView.ADDFRIEND_FAIL));
            }
         }
      }
      
      public function init(mc:MovieClip, man:Class) : void
      {
         this.owner = this;
         this.Man = man;
         this.RootMC = mc;
         this.BtnMC = this.RootMC.btnMC;
         this.showOpenClose();
         this.lockhomereq = new lockHomeReq();
         GV.onlineSocket.addEventListener(lockHomeRes.USER_LOCKHOME,this.lockAddResult);
         this.RootMC.fui0.openAdd_btn.visible = Boolean(LocalUserInfo.getVip() & 0x10);
         this.RootMC.drag_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
         this.RootMC.drag_mc.addEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
         this.RootMC.drag_mc.addEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
         this.RootMC.close_btn.addEventListener(MouseEvent.CLICK,this.closeMC);
         this.RootMC.fui0.add_btn.addEventListener(MouseEvent.CLICK,this.showAddPanel);
         this.RootMC.fui0.openAdd_btn.addEventListener(MouseEvent.CLICK,this.showAddTip);
         this.RootMC.fui0.closeAdd_btn.addEventListener(MouseEvent.CLICK,this.showCloseTip);
         this.RootMC.fui0.delete_btn.addEventListener(MouseEvent.CLICK,this.DeleteFriends);
         this.BtnMC.btn0.addEventListener(MouseEvent.CLICK,this.showFriend);
         this.BtnMC.btn1.addEventListener(MouseEvent.CLICK,this.showOnline);
         this.BtnMC.btn2.addEventListener(MouseEvent.CLICK,this.showBlack);
         this.BtnMC.btn3.addEventListener(MouseEvent.CLICK,this.showGroup);
         this.BtnMC.btn4.addEventListener(MouseEvent.CLICK,this.showRecent);
         GV.onlineSocket.addEventListener("removeMapEvent",this.eventCloseMC);
         GV.onlineSocket.addEventListener("post_card_close",this.closeMC);
         this.showFriend(1);
      }
      
      private function DeleteFriends(e:MouseEvent) : void
      {
         this.whichList = -1;
         FView.uninit();
         var _temp_3:* = this;
         var _temp_2:* = §§findproperty(DeleteFriendView);
         var _temp_1:* = this.RootMC.delete_mc;
         with({})
         {
            _temp_3._deleteView = new DeleteFriendView(_temp_1,function h():void
            {
               _deleteView = null;
               reset(0);
            });
         }
         
         public function showOpenClose() : void
         {
            if(Boolean(LocalUserInfo.getVip() & 0x10))
            {
               this.RootMC.fui0.openAdd_btn.visible = true;
               this.RootMC.fui0.closeAdd_btn.visible = false;
            }
            else
            {
               this.RootMC.fui0.openAdd_btn.visible = false;
               this.RootMC.fui0.closeAdd_btn.visible = true;
            }
         }
         
         public function showAddTip(e:Event) : void
         {
            var url:String = "resource/allJob/icon/canAddMe.swf";
            var msg:String = "    是否允許其他小摩爾加你為好友？";
            var alert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            alert.addEventListener(Alert.CLICK_ + "1",this.alertAddHandler);
         }
         
         public function showCloseTip(e:Event) : void
         {
            var url:String = "resource/allJob/icon/cantAddMe.swf";
            var msg:String = "    是否拒絕其他小摩爾加你為好友？";
            var alert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            alert.addEventListener(Alert.CLICK_ + "1",this.alertCloseHandler);
         }
         
         public function alertAddHandler(e:Event) : void
         {
            this.lockhomereq.lock(0,5);
         }
         
         public function alertCloseHandler(e:Event) : void
         {
            this.lockhomereq.lock(1,5);
         }
         
         private function lockAddResult(e:EventTaomee) : void
         {
            LocalUserInfo.setVip(e.EventObj.Vip);
            this.showOpenClose();
         }
         
         public function showAddPanel(e:Event) : void
         {
            var tempMC:* = undefined;
            if(!GV.MC_AppLever.getChildByName("AddFriendPanel"))
            {
               tempMC = UIManager.getClass("add_friend_panel");
               this.addFriendPanel = new tempMC();
               this.addFriendPanel.yes_btn.addEventListener(MouseEvent.CLICK,this.doaddFriend);
               this.addFriendPanel.no_btn.addEventListener(MouseEvent.CLICK,this.closeAddPanel);
               this.addFriendPanel.name = "AddFriendPanel";
               this.addFriendPanel.x = (GV.stageWidth - this.addFriendPanel.width) / 2;
               this.addFriendPanel.y = (GV.stageHeight - this.addFriendPanel.height) / 2;
               GV.MC_AppLever.addChild(this.addFriendPanel);
            }
         }
         
         public function doaddFriend(e:Event) : void
         {
            var addFrendsReq:AddFrendsReq = null;
            if(MainManager.getGlobalObject().data.ServerFriendsList.length >= LocalUserInfo.friendsLimitNum())
            {
               Alert.showAlert(GV.MC_AppLever,"你的好友已經到達上限!","",Alert.CHANG_ALERT,"iknow",true,false,"D");
            }
            else if(!userPanelView.checkUser(Number(this.addFriendPanel.num_txt.text)))
            {
               Alert.showAlert(GV.MC_AppLever,this.addFriendPanel.num_txt.text + "已經是你的好友了!","",Alert.CHANG_ALERT,"iknow",true,false,"D");
            }
            else if(Number(this.addFriendPanel.num_txt.text) >= 10000 && Number(this.addFriendPanel.num_txt.text) != GV.MyInfo_userID)
            {
               if(Number(this.addFriendPanel.num_txt.text) >= 2000000000)
               {
                  Alert.angryAlart("用戶米米號不存在！");
                  return;
               }
               addFrendsReq = new AddFrendsReq();
               GV.onlineSocket.addEventListener(AddFrendsRes.ADD_FREND,addFriendReqSucc);
               addFrendsReq.addFrends(Number(this.addFriendPanel.num_txt.text));
               this.closeAddPanel();
            }
         }
         
         public function closeAddPanel(e:Event = null) : void
         {
            this.addFriendPanel.yes_btn.removeEventListener(MouseEvent.CLICK,addFriend);
            this.addFriendPanel.no_btn.removeEventListener(MouseEvent.CLICK,this.closeAddPanel);
            GV.MC_AppLever.removeChild(this.addFriendPanel);
            this.addFriendPanel = null;
         }
         
         public function showFriend(e:*) : void
         {
            this.reset(0);
         }
         
         public function showOnline(e:Event) : void
         {
            this.reset(1);
         }
         
         public function showBlack(e:Event) : void
         {
            this.reset(2);
         }
         
         public function showGroup(e:Event) : void
         {
            this.reset(3);
         }
         
         public function showRecent(e:Event) : void
         {
            this.reset(4);
         }
         
         public function reset(which:uint) : void
         {
            if(this.whichList != which)
            {
               if(Boolean(this._deleteView))
               {
                  this._deleteView.Close();
                  this._deleteView = null;
               }
               if(this.whichList == 0)
               {
                  FView.uninit();
               }
               else if(this.whichList == 1)
               {
                  OView.uninit();
               }
               else if(this.whichList == 2)
               {
                  BView.uninit();
               }
               else if(this.whichList == 3)
               {
                  GView.uninit();
               }
               else if(this.whichList == 4)
               {
                  RView.uninit();
               }
               this.whichList = which;
               this.setView();
               if(this.whichList == 0)
               {
                  FView.init(this.RootMC.fui0,this.Man);
               }
               else if(this.whichList == 1)
               {
                  FView.closed = true;
                  OView.init(this.RootMC.fui1,this.Man);
               }
               else if(this.whichList == 2)
               {
                  FView.closed = true;
                  BView.init(this.RootMC.fui2,this.Man);
               }
               else if(this.whichList == 3)
               {
                  FView.closed = true;
                  GView.init(this.RootMC.fui3,this.Man);
               }
               else if(this.whichList == 4)
               {
                  FView.closed = true;
                  RView.init(this.RootMC.fui4,this.Man);
               }
            }
         }
         
         public function setView() : void
         {
            this.RootMC.fui0.visible = false;
            this.RootMC.fui1.visible = false;
            this.RootMC.fui2.visible = false;
            this.RootMC.fui3.visible = false;
            this.RootMC.fui4.visible = false;
            this.BtnMC.mc0.gotoAndStop(2);
            this.BtnMC.mc1.gotoAndStop(2);
            this.BtnMC.mc2.gotoAndStop(2);
            this.BtnMC.mc3.gotoAndStop(2);
            this.BtnMC.mc4.gotoAndStop(2);
            this.BtnMC["mc" + this.whichList].gotoAndStop(1);
            this.RootMC["fui" + this.whichList].visible = true;
         }
         
         public function drag_start(evt:MouseEvent) : void
         {
            this.RootMC.startDrag();
         }
         
         public function drag_stop(evt:MouseEvent) : void
         {
            this.RootMC.stopDrag();
         }
         
         public function drag_move(evt:MouseEvent) : void
         {
            evt.updateAfterEvent();
         }
         
         public function closeMC(evt:*) : void
         {
            this.RootMC.parent.removeChild(this.RootMC);
            this.eventCloseMC(1);
         }
         
         public function eventCloseMC(evt:*) : void
         {
            GV.onlineSocket.removeEventListener("post_card_close",this.closeMC);
            GV.onlineSocket.dispatchEvent(new EventTaomee("friendEvent"));
            GV.onlineSocket.removeEventListener(lockHomeRes.USER_LOCKHOME,this.lockAddResult);
            this.RootMC.fui0.add_btn.removeEventListener(MouseEvent.CLICK,this.showAddPanel);
            this.RootMC.fui0.openAdd_btn.removeEventListener(MouseEvent.CLICK,this.showAddTip);
            this.RootMC.fui0.closeAdd_btn.removeEventListener(MouseEvent.CLICK,this.showCloseTip);
            this.RootMC.fui0.delete_btn.removeEventListener(MouseEvent.CLICK,this.DeleteFriends);
            this.BtnMC.btn0.removeEventListener(MouseEvent.CLICK,this.showFriend);
            this.BtnMC.btn1.removeEventListener(MouseEvent.CLICK,this.showOnline);
            this.BtnMC.btn2.removeEventListener(MouseEvent.CLICK,this.showBlack);
            this.BtnMC.btn3.removeEventListener(MouseEvent.CLICK,this.showRecent);
            this.RootMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closeMC);
            this.RootMC.drag_mc.removeEventListener(MouseEvent.MOUSE_DOWN,this.drag_start);
            this.RootMC.drag_mc.removeEventListener(MouseEvent.MOUSE_UP,this.drag_stop);
            this.RootMC.drag_mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.drag_move);
            try
            {
               this.closeAddPanel();
            }
            catch(e:*)
            {
            }
            try
            {
               FView.un();
            }
            catch(e:*)
            {
            }
            try
            {
               OView.un();
            }
            catch(e:*)
            {
            }
            try
            {
               BView.un();
            }
            catch(e:*)
            {
            }
            try
            {
               RView.un();
            }
            catch(e:*)
            {
            }
            this.RootMC["logic"] = null;
            GV.onlineSocket.removeEventListener("removeMapEvent",this.eventCloseMC);
         }
      }
   }
   
   