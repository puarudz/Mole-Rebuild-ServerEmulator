package com.view.mapView.activity.PenguinFindMM
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.farm.farmSocket;
   import com.module.activityModule.Presented;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class PenguinFindFood
   {
      
      private static var instance:PenguinFindFood;
      
      private static var canotNew:Boolean = true;
      
      private var mainMC:MovieClip;
      
      private var p:PeopleManageView;
      
      private var animalLevel:int;
      
      private var foodNum:int;
      
      private var itemid:int;
      
      private var count:int;
      
      public function PenguinFindFood()
      {
         super();
         if(canotNew)
         {
            throw new Error("PenguinFindFood不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : PenguinFindFood
      {
         if(!instance)
         {
            canotNew = false;
            instance = new PenguinFindFood();
            canotNew = true;
         }
         return instance;
      }
      
      public function init(tempMc:MovieClip) : void
      {
         var animalId:int = 0;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.mainMC = tempMc;
         this.p = GF.getPeopleByID(LocalUserInfo.getUserID());
         if(this.p.hasAnimal)
         {
            animalId = int(this.p.animal.getAnimalData().ID);
            if(animalId == 1270038)
            {
               this.animalLevel = this.p.animal.Level;
               setTimeout(function():void
               {
                  p.animal.say("    看！新鮮的磷蝦，快讓我到神秘湖裡去吃個飽吧！");
               },3000);
               this.mainMC.xiaMc.visible = true;
               this.mainMC.xiaMc.buttonMode = true;
               this.mainMC.xiaMc.addEventListener(MouseEvent.CLICK,this.onXiaMcHandler);
            }
         }
      }
      
      private function onXiaMcHandler(evt:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener("1117_0",this.on1117_0Handler);
         Presented.getInstance().FreeReceiveBy1117(0);
      }
      
      private function on1117_0Handler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("1117_0",this.on1117_0Handler);
         farmSocket.outMap_feed(this.p.animal.getAnimalData().NO);
         this.foodNum = evt.EventObj.itmeCount;
         this.itemid = evt.EventObj.itemid;
         this.count = evt.EventObj.itmeCount;
         var f:int = this.animalLevel;
         if(f >= 3)
         {
            f = 3;
         }
         this.mainMC.chiyu.visible = true;
         this.p.animal.visible = false;
         if(this.foodNum == 0)
         {
            this.mainMC.chiyu.gotoAndStop(7);
            GV.onlineSocket.addEventListener("over",this.onOverHandler);
            this.mainMC.chiyu.gotoAndStop(f + f);
         }
         else
         {
            this.mainMC.chiyu.gotoAndStop(7);
            GV.onlineSocket.addEventListener("over",this.onOverHandler);
            this.mainMC.chiyu.gotoAndStop(f + f - 1);
         }
      }
      
      private function onOverHandler(evt:Event) : void
      {
         GV.onlineSocket.removeEventListener("over",this.onOverHandler);
         this.mainMC.chiyu.visible = false;
         this.p.animal.visible = true;
         if(this.foodNum != 0)
         {
            Alert.showAlert(MainManager.getGameLevel(),"    恭喜你獲得" + this.count + "只" + GoodsInfo.getItemNameByID(this.itemid) + ",已經放入你的牧場倉庫中了！","",6,"E");
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         this.mainMC.xiaMc.removeEventListener(MouseEvent.CLICK,this.onXiaMcHandler);
         GV.onlineSocket.removeEventListener("1117_0",this.on1117_0Handler);
         GV.onlineSocket.removeEventListener("over",this.onOverHandler);
         BC.removeEvent(this);
      }
   }
}

