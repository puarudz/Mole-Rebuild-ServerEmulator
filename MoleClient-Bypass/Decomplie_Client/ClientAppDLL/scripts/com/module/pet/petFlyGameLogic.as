package com.module.pet
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   
   public class petFlyGameLogic
   {
      
      private var petObj:Object;
      
      private var mcloader:MCLoader;
      
      public function petFlyGameLogic()
      {
         super();
      }
      
      public function init() : void
      {
         var url:String = null;
         var msg:String = null;
         var len:uint = 0;
         var i:uint = 0;
         if(this.havePetFollow())
         {
            if(this.petObj.Petlevel > 100)
            {
               url = "resource/allJob/AlertPic/kv3.swf";
               msg = "     通過我的觀察，超級拉姆的葉子很強壯，飛行能力不是一般的強。讓它帶你去摩登碼頭，我放心。 超級拉姆飛行考試，免試！";
               Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
            }
            else if(this.petObj.Petlevel >= 4)
            {
               len = uint(GV.MyInfo_PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     if(GV.MyInfo_PetObj.Job[i] is String)
                     {
                        url = "resource/allJob/AlertPic/kv3.swf";
                        msg = "    你好像還沒有資格參加飛行考試，要先去學院教導處報名學習飛行課！";
                        Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
                     }
                     else if(GV.MyInfo_PetObj.Job[i].ClassID == 11)
                     {
                        if(GV.MyInfo_PetObj.Job[i].Days == GV.MyInfo_PetObj.Job[i].AllDays)
                        {
                           if(GV.MyInfo_PetObj.Job[i].Status != 3)
                           {
                              trace("5進入遊戲");
                              this.loadGame();
                           }
                           else
                           {
                              trace("4已經通過考試");
                              url = "resource/allJob/AlertPic/kv4.swf";
                              msg = "    你的拉姆不是已經通過飛行考試了嗎！？";
                              Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
                           }
                           return;
                        }
                     }
                  }
                  url = "resource/allJob/AlertPic/kv3.swf";
                  msg = "    你好像還沒有資格參加飛行考試，要先去學院教導處報名學習飛行課！";
                  Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
               }
               else
               {
                  url = "resource/allJob/AlertPic/kv3.swf";
                  msg = "    你好像還沒有資格參加飛行考試，要先去學院教導處報名學習飛行課！";
                  Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
               }
            }
            else
            {
               url = "resource/allJob/AlertPic/kv2.swf";
               msg = "    你的拉姆還不能飛。再給點時間，好好照顧它！你的拉姆很快就可以去學飛行了！";
               Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
            }
         }
         else
         {
            url = "resource/allJob/AlertPic/kv1.swf";
            msg = "　　我怎麼沒看到拉姆在你的身邊？光顧著自己出來玩了！我這裡是給它做飛行考試的！";
            Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
         }
      }
      
      private function loadGame() : void
      {
         this.mcloader = new MCLoader("module/external/PetFlyGame.swf",MainManager.getGameLevel(),1,"飛行遊戲準備中");
         this.mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSucc);
         this.mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
         this.mcloader.doLoad();
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         trace("加載出錯");
      }
      
      private function loadSucc(event:MCLoadEvent) : void
      {
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObject = event.getContent();
         MainManager.getGameLevel().addChild(c);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.clear();
      }
      
      public function havePetFollow() : Boolean
      {
         this.petObj = GF.getPeopleObj(GV.MyInfo_userID);
         if(this.petObj != null && Boolean(this.petObj.PetID))
         {
            return true;
         }
         return false;
      }
   }
}

