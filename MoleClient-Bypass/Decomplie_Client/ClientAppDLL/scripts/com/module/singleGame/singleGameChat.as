package com.module.singleGame
{
   import com.common.Tween.TweenLite;
   import com.common.view.MCScrollBar.ScrollBar;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.module.friendList.friendView.BView;
   import com.view.ChatView.HistoryView;
   import fl.motion.easing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   public class singleGameChat extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      private var local_x:Number = 6;
      
      private var local_y:Number = 238;
      
      private var scroll_Bar:ScrollBar;
      
      private var HistoryClass:HistoryView;
      
      public function singleGameChat(target:MovieClip)
      {
         super();
         this.target_mc = target;
         this.target_mc.enter_btn.addEventListener(MouseEvent.CLICK,this.sendMsg);
         this.target_mc.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         GV.onlineSocket.addEventListener("sendToSingleGame",this.showMsg);
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.getSMGData);
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.TALK_DIRTY,this.getBedTalkData);
         this.init();
      }
      
      public function showMsg(e:* = null) : void
      {
      }
      
      public function sendMsg(e:* = null) : void
      {
         if(this.target_mc.msg_txt.text.length > 0)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("singleGameSendMsg",{"msg":this.target_mc.msg_txt.text}));
            this.target_mc.msg_txt.text = "";
         }
      }
      
      private function init() : void
      {
         this.HistoryClass = HistoryView.getHistoryInstance();
         this.scroll_Bar = new ScrollBar(this.target_mc.chatAction_mc.scroll_mc,this.target_mc.chatAction_mc.chat_box,170,266);
         BView.blackViewInit(1);
         this.target_mc.chat_up.addEventListener(MouseEvent.CLICK,this.chatMCMove_TOP);
         this.target_mc.chatAction_mc.btn_bottom.addEventListener(MouseEvent.CLICK,this.chatMCMove_Bottom);
      }
      
      public function getBedTalkData(e:*) : void
      {
         var txt:String = null;
         if(e.EventObj.otherUserID == 0)
         {
            txt = "您發送的信息已經被屏蔽，請文明用語！";
            GF.showWordBoxMSG(txt,LocalUserInfo.getUserID());
            this.HistoryClass.addItem({
               "MSG":txt,
               "USERNAME":LocalUserInfo.getNickName()
            });
         }
      }
      
      private function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.sendMsg();
         }
      }
      
      public function isGroupUser(id:*) : Boolean
      {
         for(var i:uint = 0; i < singleGame.IDARR.length; i++)
         {
            if(singleGame.IDARR[i] == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getSMGData(evt:*) : void
      {
         var poss:String = null;
         var tempStr:String = null;
         var tempNum:int = 0;
         var i:uint = 0;
         if(this.isGroupUser(evt.EventObj.obj.ID))
         {
            if(this.checkBlackLiset(evt.EventObj.obj.ID))
            {
               return;
            }
            this.chatMCMove_TOP();
            if(evt.EventObj.obj.Friend == 0)
            {
               if(LocalUserInfo.getUserID() != evt.EventObj.obj.ID)
               {
                  GF.showWordBoxMSG(evt.EventObj.obj.MSG,evt.EventObj.obj.ID);
               }
               else
               {
                  GF.showWordBoxMSG(evt.EventObj.obj.MSG,LocalUserInfo.getUserID());
               }
               poss = evt.EventObj.obj.MSG;
               if(poss.substr(0,1) == "/")
               {
                  tempStr = poss.substr(1,2);
                  tempNum = -1;
                  for(i = 0; i < GV.expressionArray.length; i++)
                  {
                     if(GV.expressionArray[i] == tempStr)
                     {
                        tempNum = int(i);
                        break;
                     }
                  }
                  if(tempNum <= -1)
                  {
                     this.HistoryClass.addItem({
                        "MSG":evt.EventObj.obj.MSG,
                        "USERNAME":evt.EventObj.obj.Nike
                     });
                  }
               }
               else
               {
                  this.HistoryClass.addItem({
                     "MSG":evt.EventObj.obj.MSG,
                     "USERNAME":evt.EventObj.obj.Nike
                  });
               }
               this.showSMGData();
            }
         }
      }
      
      public function showSMGData() : void
      {
         var temp:* = undefined;
         var item:MovieClip = null;
         GC.stopAllMC(this.target_mc.chatAction_mc.chat_box);
         var num:uint = uint(this.target_mc.chatAction_mc.chat_box.numChildren);
         for(var j:int = num - 1; j >= 0; j--)
         {
            temp = this.target_mc.chatAction_mc.chat_box.getChildAt(j);
            temp.removeEventListener(MouseEvent.MOUSE_OVER,this.showBG);
            temp.removeEventListener(MouseEvent.MOUSE_OUT,this.hideBG);
            temp.removeEventListener(MouseEvent.MOUSE_DOWN,this.doAction);
            this.target_mc.chatAction_mc.chat_box.removeChild(temp);
         }
         var oldY:Number = 0;
         var tempClass:* = UIManager.getClass("chat_item_singlegame");
         var tempArray:Array = this.HistoryClass.getCommpnArray();
         for(var i:uint = 0; i < tempArray.length; i++)
         {
            item = new tempClass();
            item.msg = tempArray[i].MSG;
            item.userID = tempArray[i].USERID;
            item.userName = tempArray[i].USERNAME;
            item.msg_txt.wordWrap = true;
            item.msg_txt.autoSize = TextFieldAutoSize.LEFT;
            item.msg_txt.mouseWheelEnabled = false;
            item.mouseChildren = false;
            if(item.msg == "您發送的信息已經被屏蔽，請文明用語！")
            {
               item.msg_txt.htmlText = "<font color=\'#CC0000\'>" + item.msg + "</font>";
            }
            else
            {
               item.msg_txt.htmlText = "<font color=\'#FF6600\'>" + item.userName + "說:</font><font color=\'#339900\'>" + item.msg + "</font>";
            }
            item.bg_mc.height = item.msg_txt.numLines * 16 + 6;
            item.bg_mc.alpha = 0;
            item.addEventListener(MouseEvent.MOUSE_OVER,this.showBG);
            item.addEventListener(MouseEvent.MOUSE_OUT,this.hideBG);
            item.addEventListener(MouseEvent.MOUSE_DOWN,this.doAction);
            item.y = oldY;
            oldY = item.y + item.bg_mc.height - 4;
            this.target_mc.chatAction_mc.chat_box.addChild(item);
         }
         this.scroll_Bar.reSet();
      }
      
      public function removeListenHandler() : void
      {
         this.target_mc.enter_btn.removeEventListener(MouseEvent.CLICK,this.sendMsg);
         this.target_mc.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         GV.onlineSocket.removeEventListener("sendToSingleGame",this.showMsg);
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.getSMGData);
         GV.onlineClass.removeEventListener(ClientOnLineSerSocket.TALK_DIRTY,this.getBedTalkData);
         this.target_mc.chat_up.removeEventListener(MouseEvent.CLICK,this.chatMCMove_TOP);
         this.target_mc.chatAction_mc.btn_bottom.removeEventListener(MouseEvent.CLICK,this.chatMCMove_Bottom);
      }
      
      private function chatMCMove_TOP(evt:Event = null) : void
      {
         this.target_mc.chat_up.visible = false;
         TweenLite.to(this.target_mc.chatAction_mc,0.3,{
            "x":this.local_x,
            "y":this.local_y,
            "ease":Back.easeOut
         });
      }
      
      private function chatMCMove_Bottom(evt:MouseEvent) : void
      {
         TweenLite.to(this.target_mc.chatAction_mc,0.2,{
            "x":this.local_x,
            "y":590,
            "ease":Back.easeIn
         });
         this.target_mc.addEventListener(Event.ENTER_FRAME,this.showButton);
      }
      
      private function showButton(evt:*) : void
      {
         if(this.target_mc.chatAction_mc.y > 588)
         {
            this.target_mc.chat_up.visible = true;
            this.target_mc.removeEventListener(Event.ENTER_FRAME,this.showButton);
         }
      }
      
      public function showFace() : void
      {
      }
      
      private function doAction(E:MouseEvent) : void
      {
         this.target_mc.msg_txt.text = E.target.msg;
      }
      
      private function showBG(E:MouseEvent) : void
      {
         E.target.bg_mc.alpha = 1;
      }
      
      private function hideBG(E:MouseEvent) : void
      {
         E.target.bg_mc.alpha = 0;
      }
      
      private function checkBlackLiset(userID:Object) : Boolean
      {
         var i:int = 0;
         if(BView.blackList != null)
         {
            for(i = 0; i < BView.blackList.length; i++)
            {
               if(userID == BView.blackList[i].UserID)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function removeScrollBarHandler() : void
      {
         this.scroll_Bar.removeFun();
      }
   }
}

