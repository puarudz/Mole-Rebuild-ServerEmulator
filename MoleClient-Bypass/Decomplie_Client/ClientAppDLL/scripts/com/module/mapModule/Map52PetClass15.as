package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.JobLogic.PetJobLogic;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map52PetClass15 extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      public function Map52PetClass15()
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         super();
      }
      
      public function beginInfo() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         BC.addEvent(this,this.target_mc.pic2_btn,MouseEvent.CLICK,this.petClassInfo);
         BC.addEvent(this,this.target_mc.gold_btn,MouseEvent.CLICK,this.checkGold);
      }
      
      private function petClassInfo(eve:MouseEvent) : void
      {
         var pet_arr:Array = null;
         var hasEnglish:Boolean = false;
         var i:uint = 0;
         var myalter:* = undefined;
         var url:String = "";
         var msg:String = "";
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            if(GV.MyInfo_PetObj.Level >= 101)
            {
               url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
               msg = "    哈哈！你的超級拉姆英語水準很高的，就不需要再考試啦！平時可以多和它練習說英語哦！";
               this.showNextAlt(url,msg);
               return;
            }
            pet_arr = GV.MyInfo_PetObj.Job;
            if(pet_arr[0] == null)
            {
               url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
               msg = "    這裡是英語考試項目！你好像沒有讓拉姆學習英語課。快去學院教導處給它報名選課吧。通過考試，拉姆就可以說英語了哦！";
               this.showNextAlt(url,msg);
               return;
            }
            hasEnglish = false;
            for(i = 0; i < pet_arr.length; i++)
            {
               if(pet_arr[i].ClassID == 15)
               {
                  hasEnglish = true;
                  if(pet_arr[i].Days == pet_arr[i].AllDays)
                  {
                     if(pet_arr[i].Status == 3)
                     {
                        url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
                        msg = "    親愛的小拉姆，你已經通過了英語課的考核哦！以後記得要多多練習英語，可以常去英語角逛逛哦！";
                        this.showNextAlt(url,msg);
                     }
                     else
                     {
                        msg = "    現在就開始英語考試嗎？";
                        myalter = Alert.showAlert(MainManager.getAppLevel(),"",msg,Alert.SELECT_ALERT);
                        myalter.addEventListener(Alert.CLICK_ + "1",this.addGameFun,false,0,true);
                     }
                  }
                  else
                  {
                     url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
                     msg = "    這裡是英語考試項目！你好像沒有讓拉姆學習英語課。快去學院教導處給它報名選課吧。通過考試，拉姆就可以說英語了哦！";
                     this.showNextAlt(url,msg);
                  }
               }
            }
            if(!hasEnglish)
            {
               url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
               msg = "    這裡是英語考試項目！你好像沒有讓拉姆學習英語課。快去學院教導處給它報名選課吧。通過考試，拉姆就可以說英語了哦！";
               this.showNextAlt(url,msg);
            }
         }
         else
         {
            url = "resource/allJob/AlertPic/kv/petclass15_3.swf";
            msg = "    嘿!這裡是小拉姆的英語考試點哦！咦？你好像沒有把它來帶哦？";
            this.showNextAlt(url,msg);
         }
      }
      
      private function addGameFun(evt:Event = null) : void
      {
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            return;
         }
         GameframeLogic.stopMousicHandler();
         var url:String = "module/game/englishCourse.swf";
         var msg:String = "正在加載英語考試";
         BC.addEvent(this,GV.onlineSocket,"contact_close",this.overAddGame);
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function overAddGame(eve:EventTaomee) : void
      {
         var arr:Array = null;
         var temp:* = undefined;
         GameframeLogic.playMousicHandler();
         GV.map_ManagerChange.refreshMap();
         BC.removeEvent(this,GV.onlineSocket,"contact_close",this.overAddGame);
         if(Boolean(eve.EventObj.bln))
         {
            BC.addEvent(this,GV.PetJobLogics,PetJobLogic.OVERONERESULT,this.showPassGameTip);
            arr = [{
               "petID":GV.MyInfo_PetObj.SpriteID,
               "classID":15
            }];
            GV.PetJobLogics.SetOverOneClass(arr);
         }
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
      }
      
      private function showPassGameTip(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.PetJobLogics,PetJobLogic.OVERONERESULT,this.showPassGameTip);
         var pet_arr:Array = GV.MyInfo_PetObj.Job;
         for(var i:int = 0; i < pet_arr.length; i++)
         {
            if(pet_arr[i].ClassID == 15)
            {
               pet_arr[i].Status = 3;
            }
         }
         GV.MyInfo_PetObj.Job = pet_arr;
         var url:String = "resource/allJob/AlertPic/kv/petclass15_2.swf";
         var msg:String = "    你的拉姆已經圓滿完成了英語課的學習哦！快去領獎台領取英語勳章吧！";
         this.showNextAlt(url,msg);
      }
      
      private function checkGold(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getGoldHandler);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MyInfo_PetObj.SpriteID,1210017,1210018,2);
      }
      
      private function getGoldHandler(evt:EventTaomee = null) : void
      {
         var pet_arr:Array = null;
         var i:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getGoldHandler);
         var obj:Object = evt.EventObj;
         var url:String = "";
         var msg:String = "";
         if(obj.Count > 0)
         {
            url = "resource/allJob/AlertPic/kv/petclass15_2.swf";
            msg = "    親愛的小拉姆，你已經擁有了英語勳章和EBOOK啦哦！";
            this.showNextAlt(url,msg);
            return;
         }
         var englishOver:Boolean = false;
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            if(GV.MyInfo_PetObj.Level >= 101)
            {
               BC.addEvent(this,GV.onlineSocket,petClothRes.GET_HONOR_BACK,this.buyGoldSucc);
               petClothReq.getHonor();
               return;
            }
            pet_arr = GV.MyInfo_PetObj.Job;
            if(pet_arr[0] != null)
            {
               for(i = 0; i < pet_arr.length; i++)
               {
                  if(pet_arr[i].ClassID == 15)
                  {
                     if(pet_arr[i].Status == 3)
                     {
                        englishOver = true;
                     }
                  }
               }
            }
         }
         if(englishOver)
         {
            BC.addEvent(this,GV.onlineSocket,petClothRes.GET_HONOR_BACK,this.buyGoldSucc);
            petClothReq.getHonor();
         }
         else
         {
            url = "resource/allJob/AlertPic/kv/petclass15_3.swf";
            msg = "    要帶著學習完英語課，並且順利通過考核的拉姆或者超級拉姆才能領取英語勳章哦！";
            this.showNextAlt(url,msg);
         }
      }
      
      private function buyGoldSucc(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.buyGoldSucc);
         var msg:String = "  一個英語勳章、一件ebook裝扮已經放入你的拉姆背包中啦！";
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function showNextAlt(url:String, msg:String) : void
      {
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
      }
      
      public function removeAll(eve:* = null) : void
      {
         BC.removeEvent(this);
      }
   }
}

