package com.module.checkBirthday
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.module.sendBirthdayCard.ChargeBuyItem;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CheckBooking
   {
      
      private var chargeBuyItem:ChargeBuyItem;
      
      public function CheckBooking()
      {
         super();
         new CheckBirthday().checkBirth(this,"checkBirth");
      }
      
      public function checkBirth(isBirthDay:uint) : void
      {
         var prizeStr:String;
         var mc:DisplayObject = null;
         this.chargeBuyItem = new ChargeBuyItem();
         prizeStr = "";
         if(isBirthDay == 2)
         {
            prizeStr = "親愛的" + LocalUserInfo.getNickName() + ":\n    你還沒有在生日飛艇中登記你的生日哦，你只要登記了生日，到時候就可以過來領取你的生日禮物啦!";
            mc = GV.MC_mapFrame["control_mc"].bookBtn;
            Alert.imagesBigAlert(prizeStr,"resource/npcCandyUI/momo_1.swf",function(e:*):void
            {
               mc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            },"regedit,notgo");
         }
         else if(isBirthDay == 1)
         {
            this.chargeBuyItem.panle = 1;
            this.chargeBuyItem.itemCount = 1;
            this.chargeBuyItem.itemID = 161011;
            this.chargeBuyItem.url = "resource/ivrUI/birthday1.swf";
            this.chargeBuyItem.msg = "親愛的" + LocalUserInfo.getNickName() + ":" + "\n" + "   祝你生日快樂呀！希望你每天都有好心情，" + "做一隻快樂的小摩爾！麼麼公主代表摩爾莊園送你一份生日禮物，" + "已放入你的小屋中，快回去打開看看吧！別忘記邀請你的朋友一起來生日飛艇慶祝生日哦！";
            GV.onlineSocket.addEventListener(ChargeBuyItem.ASK_ITEM,this.askHandler);
            this.chargeBuyItem.checkHaveItem();
         }
         else
         {
            prizeStr = "   你的生日還沒有到呢！\n別著急哦！生日的時候再來打開禮物，你會收到麼麼公主的禮物哦！";
            GF.showAlert(MainManager.getAppLevel(),prizeStr,"",100,"iknow",true,false,"D");
         }
      }
      
      private function askHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener(ChargeBuyItem.ASK_ITEM,this.askHandler);
         this.chargeBuyItem.url = "resource/ivrUI/birthday2.swf";
         this.chargeBuyItem.msg = "親愛的" + LocalUserInfo.getNickName() + ":" + "\n" + "   你的禮物已經領取過了，就放在你的小屋裡哦^-^" + "每個小摩爾一年只能領取一次生日禮物哦!";
      }
   }
}

