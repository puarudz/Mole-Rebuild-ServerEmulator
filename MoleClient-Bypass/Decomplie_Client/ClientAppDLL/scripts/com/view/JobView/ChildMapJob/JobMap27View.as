package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.checkItem;
   import com.module.activityModule.deleteItemModule;
   import com.module.activityModule.refurbishPeopleModule;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class JobMap27View
   {
      
      private var timer_num:uint = 0;
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var nowforest_arr:Array;
      
      private var Forest_num:Array = [0,0];
      
      private var getOne:Array = [0,0];
      
      private var forestIP:int = 0;
      
      private var forest_arr:Array = [12134,12135,12136,12137,12138];
      
      private var getForest_arr:Array = [[{
         "id":16005,
         "name":"紅色"
      },{
         "id":16009,
         "name":"黃色"
      },{
         "id":16003,
         "name":"藍色"
      },{
         "id":16001,
         "name":"綠色"
      },{
         "id":16010,
         "name":"黑色"
      }],[{
         "id":17005,
         "name":"蘑菇"
      },{
         "id":17006,
         "name":"西瓜"
      },{
         "id":17007,
         "name":"石像"
      }],[{
         "id":180008,
         "name":"漿果果汁"
      }],[{
         "id":190023,
         "name":"食用漿果"
      }]];
      
      public function JobMap27View()
      {
         super();
      }
      
      public function info() : void
      {
         var myAlert:* = undefined;
         var a:uint = 0;
         var num_id:* = undefined;
         var result:Boolean = false;
         BC.addEvent(GV.MC_mapFrame,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.Forest_num = [0,0];
         this.nowforest_arr = new Array();
         var url:String = "";
         for(var info:String = ""; a < 5; )
         {
            num_id = this.forest_arr[a];
            result = checkCloth.doAction(num_id);
            if(result)
            {
               this.Forest_num = [a,num_id];
               url = "resource/allJob/icon/iconBox.swf";
               info = "    把你手上的漿果放入鐵皮箱，就能看出它有什麼神奇的變化。你想知道結果嗎？";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMC");
               myAlert.addEventListener(Alert.CLICK_ + "1",this.BeginBuyOne);
               myAlert.addEventListener(Alert.CLICK_ + "2",this.showForestBtn);
               return;
            }
            a++;
         }
         this.forestIP = 0;
         this.chartBagForest();
      }
      
      private function showForestBtn(event:Event) : void
      {
         this.target_mc.forest_btn.visible = true;
         this.depth_mc.forest_mc.gotoAndPlay(51);
      }
      
      private function chartBagForest() : void
      {
         var num:int = int(this.forest_arr[this.forestIP]);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.InBageForest);
         checkItem.checkItemHandler(num);
      }
      
      private function BeginBuyOne(event:Event) : void
      {
         var result:Boolean = checkCloth.doAction(this.Forest_num[1]);
         if(result)
         {
            GV.onlineSocket.addEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.deleteForestFun);
            deleteItemModule.doAction(this.Forest_num[1]);
            return;
         }
         this.forestIP = 0;
         this.chartBagForest();
         trace("身上佩戴被繳獲的物品id:",this.Forest_num[1],"//",this.Forest_num[0]);
      }
      
      private function deleteForestFun(event:EventTaomee) : void
      {
         var award_pet:Boolean = false;
         var award_us:Boolean = false;
         var award_using:uint = 0;
         GV.onlineSocket.removeEventListener(deleteItemModule.DELETE_ITEM_SUCESS,this.deleteForestFun);
         GV.onlineSocket.addEventListener("giveMoneyEvent",this.onBuySuccess);
         this.getOne = [0,0,"no"];
         var award:Boolean = Boolean(GV.JobLogics.chartRandom(10));
         if(award)
         {
            this.getOne[0] = 1;
            this.getOne[1] = this.getForest_arr[0][this.Forest_num[0]].id;
            this.getOne[2] = this.getForest_arr[0][this.Forest_num[0]].name;
         }
         else
         {
            award_pet = Boolean(GV.JobLogics.chartRandom(10));
            if(award_pet)
            {
               this.getOne[0] = 3;
               this.getOne[1] = this.getForest_arr[2][0].id;
               this.getOne[2] = this.getForest_arr[2][0].name;
            }
            else
            {
               award_us = Boolean(GV.JobLogics.chartRandom(20));
               if(award_us)
               {
                  award_using = uint(Math.random() * 3);
                  this.getOne[0] = 2;
                  this.getOne[1] = this.getForest_arr[1][award_using].id;
                  this.getOne[2] = this.getForest_arr[1][award_using].name;
               }
               else
               {
                  this.getOne[0] = 4;
                  this.getOne[1] = this.getForest_arr[3][0].id;
                  this.getOne[2] = this.getForest_arr[3][0].name;
               }
            }
         }
         var buy_arr:Array = [{
            "kind":this.getOne[1],
            "num":1
         }];
         randomItemDrawLogic.moneyAction(buy_arr,0);
      }
      
      private function onBuySuccess(evt:*) : void
      {
         GV.onlineSocket.removeEventListener("giveMoneyEvent",this.onBuySuccess);
         GV.onlineSocket.addEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.showSuccessAlert);
         refurbishPeopleModule.doAction(this.Forest_num[1]);
      }
      
      private function showSuccessAlert(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(refurbishPeopleModule.REFURBISH_PEOPLE_SUC,this.showSuccessAlert);
         GF.revertPeople(GV.MyInfo_userID);
         this.timer_num = setTimeout(this.showSuccessUI,1000);
      }
      
      private function showSuccessUI() : void
      {
         var myAlert:* = undefined;
         var IsTip:Boolean = false;
         try
         {
            clearTimeout(this.timer_num);
         }
         catch(e:*)
         {
         }
         var url:String = "";
         var info:String = "";
         var goodsName:* = this.getOne[2];
         switch(uint(this.getOne[0]))
         {
            case 1:
               url = "resource/effect/icon/" + String(this.getOne[1]) + ".swf";
               info = "    這個漿果做藥水正合適。" + goodsName + "藥水已經放進你的百寶箱裡了。";
               break;
            case 2:
               url = "resource/effect/icon/" + String(this.getOne[1]) + ".swf";
               IsTip = Boolean(GV.JobLogics.chartRandom(50));
               if(IsTip)
               {
                  info = "    你的漿果還沒成熟，不過它還是變成了一個" + goodsName + "果實道具。它已經放到你的投擲欄裡了。";
               }
               else
               {
                  info = "    你的漿果小了點，但它居然變成了一個" + goodsName + "果實道具。它已經放到你的投擲欄裡了。";
               }
               break;
            case 3:
               url = "resource/pet/icon/180008.swf";
               info = "    拉姆很喜歡這個漿果，一瓶" + goodsName + "已經放入拉姆的背包中了。";
               break;
            case 4:
               url = "resource/allJob/icon/" + String(this.getOne[1]) + ".swf";
               info = "    拉姆很喜歡這個漿果，一個食用漿果已經放入你的百寶箱裡了！";
         }
         myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         myAlert.addEventListener(Alert.CLICK_ + "1",this.showForestBtn);
      }
      
      private function InBageForest(event:EventTaomee) : void
      {
         var myAlert:* = undefined;
         var b:int = 0;
         var url:String = "";
         var info:String = "";
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.InBageForest);
         var num:* = event.EventObj.count;
         this.nowforest_arr.push(num);
         ++this.forestIP;
         if(this.forestIP < 5)
         {
            this.chartBagForest();
         }
         if(this.forestIP == 5)
         {
            while(b < 5)
            {
               if(this.nowforest_arr[b] != 0)
               {
                  url = "resource/allJob/icon/selfBox.swf";
                  info = "    想知道漿果有什麼神奇，先點擊百寶箱裡的漿果把它拿在手上，再點擊我試試。";
                  myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
                  myAlert.addEventListener(Alert.CLICK_ + "1",this.showForestBtn);
                  return;
               }
               if(b == 4)
               {
                  url = "resource/allJob/icon/fiveGoods.swf";
                  info = "五色漿果你一個也沒有拿到，快去漿果森林找找吧！";
                  myAlert = Alert.showAlert(MainManager.getAppLevel(),url,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMC");
                  myAlert.addEventListener(Alert.CLICK_ + "1",this.showForestBtn);
               }
               b++;
            }
         }
      }
      
      private function removeEventHandler(event:*) : void
      {
         try
         {
            clearTimeout(this.timer_num);
         }
         catch(e:*)
         {
         }
         BC.removeEvent(GV.MC_mapFrame);
      }
   }
}

