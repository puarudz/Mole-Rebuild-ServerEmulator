package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.specialGoods.HighBookLoader;
   import com.mole.app.map.MapBase;
   import flash.events.MouseEvent;
   
   public class FortTopMapView extends MapBase
   {
      
      private var isGetBook:Boolean = false;
      
      private var cardbook:Object;
      
      public function FortTopMapView()
      {
         super();
         this.checkGoods();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,_mapLevel.controlLevel["takeBtn"],MouseEvent.CLICK,this.takeBtnClickHandler);
         BC.addEvent(this,_mapLevel.controlLevel["takeBtn"],MouseEvent.MOUSE_OVER,this.takeBtnOverHandler);
         BC.addEvent(this,_mapLevel.controlLevel["takeBtn"],MouseEvent.MOUSE_OUT,this.takeBtnOutHandler);
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn"],MouseEvent.CLICK,this.openbook);
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn"],MouseEvent.MOUSE_OVER,this.booktip);
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn"],MouseEvent.MOUSE_OUT,this.hidebooktip);
      }
      
      private function hidebooktip(event:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function booktip(event:MouseEvent) : void
      {
         GF.showTip("摩爾騎士寶典");
      }
      
      private function openbook(event:MouseEvent) : void
      {
         var explain:String = null;
         var url:String = null;
         if(this.isGetBook)
         {
            if(!this.cardbook)
            {
               this.cardbook = new HighBookLoader({
                  "swf":"module/external/HighCards.swf",
                  "tip":"正在打開摩爾騎士寶典.."
               });
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_high_card"));
            }
            return;
         }
         explain = "你還沒有騎士卡牌冊,快找瑞琪領取吧";
         url = "module/gameUI/icon/002.swf";
         Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
      }
      
      private function takeBtnClickHandler(event:MouseEvent) : void
      {
         var explain:String = null;
         var url:String = null;
         _mapLevel.depthLevel["buttonMC"].gotoAndStop(3);
         if(!this.isGetBook)
         {
            explain = "你還沒有騎士卡牌冊,快找法蘭克領取吧";
            url = "module/gameUI/icon/002.swf";
            Alert.showAlert(MainManager.getGameLevel(),url,explain,Alert.CHANG_ALERT,"ok",true,false,"EMP_BUY");
            return;
         }
         var loadGame:LoadGame = new LoadGame("module/external/TakeCard.swf","正在打開抽取卡牌",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function takeBtnOverHandler(event:MouseEvent) : void
      {
         _mapLevel.depthLevel["buttonMC"].gotoAndStop(2);
         _mapLevel.controlLevel["light1"].gotoAndStop(2);
         _mapLevel.controlLevel["light2"].gotoAndStop(2);
      }
      
      private function takeBtnOutHandler(event:MouseEvent) : void
      {
         _mapLevel.depthLevel["buttonMC"].gotoAndStop(1);
         _mapLevel.controlLevel["light1"].gotoAndStop(1);
         _mapLevel.controlLevel["light2"].gotoAndStop(1);
      }
      
      private function checkGoods() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         checkItem.checkItemHandler(160191);
      }
      
      private function chekItemHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         if(evt.EventObj.num == 1)
         {
            this.isGetBook = true;
         }
      }
   }
}

