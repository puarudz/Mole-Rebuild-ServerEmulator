package com.module.pet
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   
   public class petDiveGameLogic
   {
      
      private var petObj:Object;
      
      private var mcloader:MCLoader;
      
      public function petDiveGameLogic()
      {
         super();
      }
      
      private function loadGame() : void
      {
         this.mcloader = new MCLoader("module/game/ShutGas.swf",MainManager.getGameLevel(),1,"潛水遊戲準備中");
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
      
      public function init() : void
      {
         var url:String = null;
         var len:uint = 0;
         var i:uint = 0;
         var msg:String = "    這些是潛水考試項目！你好像沒有讓拉姆學習潛水課。快去學院教導處給它報名選課吧。通過考試，拉姆就可以帶著你去神秘湖底了。";
         if(this.havePetFollow())
         {
            if(this.petObj.Petlevel > 100)
            {
               url = "resource/allJob/AlertPic/kv3.swf";
               msg = "    你可不知道，超級拉姆的潛水泡泡吹的可好啦！它就不用考試了！快讓它帶你去摩羅地海吧！";
               Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
            }
            else if(this.petObj.Petlevel > 1)
            {
               len = uint(GV.MyInfo_PetObj.Job.length);
               if(len > 0)
               {
                  for(i = 0; i < len; i++)
                  {
                     if(GV.MyInfo_PetObj.Job[i] is String)
                     {
                        url = "resource/allJob/AlertPic/kv3.swf";
                        Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
                     }
                     else if(GV.MyInfo_PetObj.Job[i].ClassID == 12)
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
                              msg = "    通過考試，拉姆就可以帶著你去摩羅地海了。！";
                              Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
                           }
                           return;
                        }
                     }
                  }
                  url = "resource/allJob/AlertPic/kv3.swf";
                  Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
               }
               else
               {
                  url = "resource/allJob/AlertPic/kv3.swf";
                  Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
               }
            }
            else
            {
               url = "resource/allJob/AlertPic/kv2.swf";
               Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
            }
         }
         else
         {
            url = "resource/allJob/AlertPic/kv1.swf";
            msg = "　　不是你要來考潛水吧？我這裡隻給拉姆作潛水考試。你好像沒把它帶來噢！";
            Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,true,"SMCUI");
         }
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

