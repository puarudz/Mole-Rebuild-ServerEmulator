package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.CSItems.exchange;
   import com.module.query.QueryImpl;
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Kakuspace extends MapBase
   {
      
      public function Kakuspace()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,_mapLevel.controlLevel["kakucarBtn"],MouseEvent.CLICK,this.cardClick);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.goonHandler);
      }
      
      private function cardClick(e:MouseEvent) : void
      {
         var msg:String = "    您要玩卡酷T系列車嗎？每次需要花費2個爆豆種子或者10個超級點點豆哦！";
         var myalter:* = GF.showAlert(MainManager.getGameLevel(),msg,"",100,"sure,cancel",true,false,"E");
         myalter.addEventListener(Alert.CLICK_ + "1",this.againSureEvent);
      }
      
      private function againSureEvent(e:Event) : void
      {
         QueryImpl.getInstance().QueryItem([1230068,16012],this.querySuccessFun2);
      }
      
      private function loadGame() : void
      {
         var tempMC:Sprite = null;
         var mcloader:MCLoader = null;
         if(MainManager.getTopLevel().getChildByName("kakuGame") == null)
         {
            tempMC = new Sprite();
            tempMC.name = "kakuGame";
            MainManager.getTopLevel().addChild(tempMC);
            mcloader = new MCLoader("module/external/KakuCar.swf",tempMC,Loading.TITLE_AND_PERCENT,"正在打開...");
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.cardComplete);
            mcloader.doLoad();
         }
      }
      
      private function querySuccessFun2(arr:Array) : void
      {
         var i:int = 0;
         var bool:Boolean = true;
         try
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i].itemID == "1230068")
               {
                  if(arr[i].count >= 2)
                  {
                     this.loadGame();
                     bool = false;
                     return;
                  }
               }
               else if(arr[i].itemID == "16012")
               {
                  if(arr[i].count >= 10)
                  {
                     bool = false;
                     exchange.exchange_goods(227);
                     _mapLevel.controlLevel["cardLucky_btn"].mouseEnabled = false;
                     return;
                  }
               }
            }
         }
         catch(e:Error)
         {
         }
         if(bool)
         {
            Alert.SLAlart("    親愛的小摩爾，你現在身上的爆豆種子和超級點點豆都不夠哦！立刻充能超級拉姆就能獲得超級點點豆啦！");
         }
      }
      
      private function goonHandler(e:EventTaomee) : void
      {
         _mapLevel.controlLevel["kakucarBtn"].mouseEnabled = true;
         this.loadGame();
      }
      
      private function cardComplete(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.cardComplete);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         var a:int = 0;
         if(evt.EventObj.type == 2)
         {
            a = int(Math.random() * 10);
            if(a < 5)
            {
               GV.Room_DefaultRoomID = 0;
               LocalUserInfo.setMapID(0);
               GF.switchMap(173,true);
            }
            else
            {
               GV.Room_DefaultRoomID = 0;
               LocalUserInfo.setMapID(0);
               GF.switchMap(172,true);
            }
         }
      }
   }
}

