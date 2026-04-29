package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class MoleParkThreeYearCtl
   {
      
      private static var _instance:MoleParkThreeYearCtl;
      
      public static var begin_url:String = "resource/angelsAndDemons/swf/MoleParkThreeYearPanel.swf";
      
      public static var exchange_url:String = "resource/angelsAndDemons/swf/MoleParkThreeYear.swf";
      
      public static var map_url:String = "resource/task/taskMap.swf";
      
      public static var day_url:String = "resource/angelsAndDemons/swf/DayReceiveClass.swf";
      
      private var e_type:int;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function MoleParkThreeYearCtl()
      {
         super();
      }
      
      public static function get instance() : MoleParkThreeYearCtl
      {
         if(!_instance)
         {
            _instance = new MoleParkThreeYearCtl();
         }
         return _instance;
      }
      
      public function loaderPanel() : void
      {
         this.onLoadPanel(begin_url);
      }
      
      public function loaderExchange() : void
      {
         this.onLoadPanel(exchange_url);
      }
      
      public function loaderMap() : void
      {
         this.onLoadPanel(map_url);
      }
      
      public function loaderDay() : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckTask);
         if(Boolean(LocalUserInfo.getVip()))
         {
            if(GF.getBitBool(LocalUserInfo.getVip(),1))
            {
               this.e_type = 318;
               finishSomethingReq.sendReq(31068);
            }
            else
            {
               this.e_type = 319;
               finishSomethingReq.sendReq(31069);
            }
         }
         else
         {
            this.e_type = 319;
            finishSomethingReq.sendReq(31069);
         }
      }
      
      private function onCheckTask(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckTask);
         if(e.EventObj.Type == 31068 || e.EventObj.Type == 31069)
         {
            if(e.EventObj.Done > 0)
            {
               Alert.smileAlart("    你今天已經領取過了，不要太貪心哦!");
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onExchangeFun);
               exchange.exchange_goods(this.e_type);
            }
         }
      }
      
      private function onExchangeFun(e:EventTaomee) : void
      {
         if(e.EventObj.type == this.e_type)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onExchangeFun);
            this.clearHandler();
            this.onLoadPanel(day_url);
         }
      }
      
      private function onLoadPanel(url:String) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler(e:* = null) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.childMC = null;
         this.gift_MC = null;
      }
   }
}

