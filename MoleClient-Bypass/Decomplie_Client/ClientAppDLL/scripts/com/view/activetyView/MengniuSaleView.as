package com.view.activetyView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.ServerUpTime;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.animalDeal.AnimalDealSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.messageTips.MT;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MengniuSaleView
   {
      
      public static var owner:*;
      
      public static var hasGetBool:Boolean = false;
      
      private var animalID:uint;
      
      private var num:int;
      
      private var mnLoader:MCLoader;
      
      public function MengniuSaleView()
      {
         super();
      }
      
      public static function getInstance() : MengniuSaleView
      {
         if(!owner)
         {
            owner = new MengniuSaleView();
         }
         return owner;
      }
      
      public function checkBuyInfo() : void
      {
         var d:Date = ServerUpTime.getInstance().date;
         if(d.month == 3 && d.date == 9 && d.hours >= 19)
         {
            if(!hasGetBool)
            {
               BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
               BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBugBack);
               finishSomethingReq.sendReq(501);
            }
            else
            {
               Alert.smileAlart(MT.getMsg(20009));
            }
         }
         else
         {
            Alert.smileAlart(MT.getMsg(20010));
         }
      }
      
      private function checkBugBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBugBack);
         var getBugNum:int = int(e.EventObj.Done);
         if(getBugNum == 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1959,this.checkAnimalNumBack);
            AnimalDealSocket.askAnimalCount(1);
         }
         else
         {
            hasGetBool = true;
            this.checkBuyInfo();
         }
      }
      
      private function checkAnimalNumBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1959,this.checkAnimalNumBack);
         this.num = evt.EventObj.animalCount;
         if(this.num <= 0)
         {
            Alert.smileAlart(MT.getMsg(20005));
         }
         else if(!this.mnLoader)
         {
            this.mnLoader = new MCLoader("module/external/saleMengniu/menniu.swf",new MovieClip(),Loading.MAIN_LOAD,"正在加載...",false);
            BC.addEvent(this,this.mnLoader,MCLoadEvent.ON_SUCCESS,this.loadOverRootMC);
            BC.addEvent(this,this.mnLoader,MCLoadEvent.ERROR,this.loadFailRootMC);
            this.mnLoader.doLoad();
         }
      }
      
      private function loadOverRootMC(event:MCLoadEvent) : void
      {
         MainManager.getAppLevel().addChild(this.mnLoader.getLoader());
         BC.removeEvent(this,this.mnLoader);
         BC.addEvent(this,this.mnLoader.getLoader().contentLoaderInfo.sharedEvents,"close",this.closeFun);
         BC.addEvent(this,this.mnLoader.getLoader().contentLoaderInfo.sharedEvents,"getShowNumBar",this.showBarnumFun);
         BC.addEvent(this,this.mnLoader.getLoader().contentLoaderInfo.sharedEvents,"anserError",this.anserErrorFun);
         BC.addEvent(this,this.mnLoader.getLoader().contentLoaderInfo.sharedEvents,"ok",this.buyAnimalFun);
         BC.addEvent(this,this.mnLoader.getLoader().contentLoaderInfo.sharedEvents,"no",this.notGetAnimalFun);
      }
      
      private function loadFailRootMC(event:MCLoadEvent) : void
      {
         BC.removeEvent(this,this.mnLoader);
         this.mnLoader = null;
      }
      
      private function showBarnumFun(E:EventTaomee) : void
      {
         var mc:MovieClip = E.EventObj as MovieClip;
         mc.showNum(mc.myarr,this.num);
      }
      
      private function closeFun(E:Event = null) : void
      {
         if(Boolean(this.mnLoader))
         {
            BC.removeEvent(this,this.mnLoader.getLoader().contentLoaderInfo);
            GC.clearAll(this.mnLoader.getLoader());
         }
         this.mnLoader = null;
      }
      
      private function anserErrorFun(evt:Event) : void
      {
         Alert.angryAlart(MT.getMsg(20006));
      }
      
      private function notGetAnimalFun(evt:Event) : void
      {
         Alert.angryAlart(MT.getMsg(20007));
      }
      
      private function buyAnimalFun(evt:Event = null) : void
      {
         GV.itemID = -1;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1925,this.buyAnimalBack);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-100102",this.buyAnimalBackErrorFun);
         AnimalDealSocket.buyAnimalCount(1);
      }
      
      private function buyAnimalBackErrorFun(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1925,this.buyAnimalBack);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-100102",this.buyAnimalBackErrorFun);
         Alert.smileAlart(MT.getMsg(20009));
         hasGetBool = true;
         GV.itemID = 0;
      }
      
      private function buyAnimalBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1925,this.buyAnimalBack);
         var obj:Object = evt.EventObj;
         this.animalID = obj.animalID;
         Alert.getIconByID_Alart(this.animalID,MT.getMsg(20008),null,"ok",108);
         hasGetBool = true;
         GV.itemID = 0;
      }
      
      private function removeEventHandler(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this);
         this.mnLoader = null;
      }
   }
}

