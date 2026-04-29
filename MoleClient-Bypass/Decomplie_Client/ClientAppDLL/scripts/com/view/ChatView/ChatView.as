package com.view.ChatView
{
   import com.common.Tween.TweenLite;
   import com.common.scrollBar.UIScrollBar;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.module.friendList.friendView.BView;
   import com.mole.app.manager.CommandManager;
   import com.view.userPanelView.userPanelView;
   import fl.motion.easing.Back;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   
   public class ChatView extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      private var local_y:Number = 39;
      
      private var HistoryClass:HistoryView;
      
      private var scrollBar:UIScrollBar;
      
      private var pageHeight:Number = 145;
      
      private var maxWidth:Number = 189;
      
      public function ChatView(target:MovieClip)
      {
         super();
         this.target_mc = target;
         this.target_mc.chatAction_mc.y = 225;
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.SEND_CHATMSG,this.getSMGData);
         GV.onlineClass.addEventListener(ClientOnLineSerSocket.TALK_DIRTY,this.getBedTalkData);
         this.init();
      }
      
      private function init() : void
      {
         this.target_mc.chat_up.addEventListener(MouseEvent.CLICK,this.onUpChatPanel);
         this.target_mc.chatAction_mc.btn_bottom.addEventListener(MouseEvent.CLICK,this.onDownChatPanel);
         this.target_mc.enter_btn.addEventListener(MouseEvent.CLICK,this.CheckText);
         this.target_mc.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         GV.onlineSocket.addEventListener("singleGameSendMsg",this.singleGameMsg);
         this.HistoryClass = HistoryView.getHistoryInstance();
         this.scrollBar = new UIScrollBar(this.target_mc.chatAction_mc.scroll_mc);
         MovieClip(this.target_mc.chatAction_mc.chat_box).scrollRect = new Rectangle(0,0,206,145);
         this.scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onScrollHandler);
         this.scrollBar.pageSize = 145;
      }
      
      private function onScrollHandler(evt:MouseEvent) : void
      {
         MovieClip(this.target_mc.chatAction_mc.chat_box).scrollRect = new Rectangle(0,this.scrollBar.scrollPosition,206,145);
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
            this.showSMGData();
         }
      }
      
      private function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == 13)
         {
            this.CheckText();
         }
         if(event.keyCode == Keyboard.UP)
         {
            this.target_mc.msg_txt.text = this.HistoryClass.lastSay;
         }
         if(event.keyCode == Keyboard.DOWN)
         {
            this.target_mc.msg_txt.text = this.HistoryClass.prevSay;
         }
      }
      
      private function singleGameMsg(event:* = null) : void
      {
         this.sendSMGData(event.EventObj.msg);
      }
      
      private function CheckText(event:* = null) : void
      {
         if(this.target_mc.msg_txt.text != "")
         {
            this.sendSMGData(this.target_mc.msg_txt.text);
            this.target_mc.cc = "";
            this.target_mc.msg_txt.text = "";
         }
      }
      
      private function sendSMGData(txt:String = "") : void
      {
         if(txt.length > 0)
         {
            this.HistoryClass.addSay(txt);
         }
         this.HistoryClass.resetLastSay();
         if(txt.charAt(0) == "#")
         {
            CommandManager.execute(txt.substr(1));
         }
         else
         {
            if(this.HistoryClass.isSameMsg(txt))
            {
               return;
            }
            if(this.HistoryClass.isCMDMsg(txt))
            {
               return;
            }
            this.HistoryClass.checkMagicMsg(txt);
            GV.onlineClass.chating(0,txt);
            GV.onlineClass.dispatchEvent(new EventTaomee("MSG_send",txt));
         }
      }
      
      public function getSMGData(evt:*) : void
      {
         var poss:String = null;
         var tempStr:String = null;
         var tempNum:int = 0;
         var i:uint = 0;
         var obj:Object = null;
         if(this.checkBlackLiset(evt.EventObj.obj.ID))
         {
            return;
         }
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
                  if(tempNum == -1)
                  {
                     if(tempStr == "ud")
                     {
                        obj = {
                           "ID":evt.EventObj.obj.ID,
                           "lv":poss.substr(3)
                        };
                        GV.onlineClass.dispatchEvent(new EventTaomee("ud",obj));
                     }
                  }
                  else
                  {
                     this.HistoryClass.addItem({
                        "MSG":evt.EventObj.obj.MSG,
                        "USERNAME":evt.EventObj.obj.Nike,
                        "USERID":evt.EventObj.obj.ID
                     });
                  }
               }
            }
            else
            {
               this.HistoryClass.addItem({
                  "MSG":evt.EventObj.obj.MSG,
                  "USERNAME":evt.EventObj.obj.Nike,
                  "USERID":evt.EventObj.obj.ID
               });
            }
            this.showSMGData();
         }
      }
      
      public function showSMGData() : void
      {
         var item:MovieClip = null;
         var temp:* = undefined;
         var ix:int = 0;
         var spaceStr:String = null;
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
         var tempClass:* = UIManager.getClass("chat_item_shot");
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
               item.nick_txt.text = item.userName + ": ";
               item.nick_txt.width = item.nick_txt.textWidth + 4;
               ix = 0;
               spaceStr = "";
               item.msg_txt.width = 190;
               item.msg_txt.x = item.nick_txt.x;
               while(item.msg_txt.textWidth < item.nick_txt.textWidth)
               {
                  spaceStr += " ";
                  item.msg_txt.text = spaceStr;
               }
               item.msg_txt.text = spaceStr + item.msg;
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
         if(Boolean(item))
         {
            this.scrollBar.maxScrollPosition = item.y + item.height;
            if(this.scrollBar.maxScrollPosition > 145)
            {
               this.scrollBar.scrollPosition = this.scrollBar.maxScrollPosition - 145;
            }
         }
      }
      
      public function showFace() : void
      {
      }
      
      private function doAction(E:MouseEvent) : void
      {
         userPanelView.showUserPanel(E.target.userID);
      }
      
      private function showBG(E:MouseEvent) : void
      {
         E.target.bg_mc.alpha = 1;
      }
      
      private function hideBG(E:MouseEvent) : void
      {
         E.target.bg_mc.alpha = 0;
      }
      
      private function onUpChatPanel(evt:MouseEvent) : void
      {
         this.target_mc.chat_up.visible = false;
         TweenLite.to(this.target_mc.chatAction_mc,0.3,{
            "y":this.local_y,
            "ease":Back.easeOut
         });
      }
      
      private function onDownChatPanel(evt:MouseEvent) : void
      {
         TweenLite.to(this.target_mc.chatAction_mc,0.2,{
            "y":225,
            "ease":Back.easeIn,
            "onComplete":this.moveBottomOver
         });
      }
      
      private function moveBottomOver() : void
      {
         this.target_mc.chat_up.visible = true;
      }
      
      private function checkBlackLiset(userID:*) : Boolean
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
   }
}

