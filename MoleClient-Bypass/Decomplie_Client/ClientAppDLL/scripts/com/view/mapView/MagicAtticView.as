package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.*;
   import com.module.activityModule.checkItem;
   import com.module.deal.Deal;
   import com.module.deal.SwapItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map81PetMagicClass;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MagicAtticView extends MapBase
   {
      
      private var slmmSige:int;
      
      public function MagicAtticView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,_mapLevel.controlLevel["petBookBtn"],MouseEvent.CLICK,this.petBookEvent);
         BC.addEvent(this,_mapLevel.controlLevel["getBookBtn"],MouseEvent.CLICK,this.getBookEvent2);
         var Map81PetMagicClassa:Map81PetMagicClass = new Map81PetMagicClass();
         Map81PetMagicClassa.setBtnMC(_mapLevel.controlLevel["class_101"]);
         Map81PetMagicClassa.setBtnMC(_mapLevel.controlLevel["class_102"]);
         Map81PetMagicClassa.setBtnMC(_mapLevel.controlLevel["class_103"]);
         Map81PetMagicClassa.setBtnMC(_mapLevel.controlLevel["class_104"]);
         Map81PetMagicClassa = null;
         this.initMagicProphet();
         BC.addEvent(this,_mapLevel.controlLevel["guo"],MouseEvent.CLICK,this.clickguo);
         BC.addEvent(this,_mapLevel.buttonLevel["ziyoutang"],MouseEvent.CLICK,this.clickziyoutang);
         BC.addEvent(this,_mapLevel.controlLevel["magicMirrorBtn"],MouseEvent.CLICK,this.onMagicMirrorBtn);
         SystemEventManager.addEventListener("sayOver",this.sayOverHandle);
      }
      
      private function sayOverHandle(e:SystemEvent) : void
      {
         Alert.angryAlart(" 拉姆魔法課暫時關閉!");
      }
      
      private function onMagicMirrorBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            _mapLevel.depthLevel["magicMirror"].nextFrame();
            ++this.slmmSige;
            if(this.slmmSige == 3)
            {
               _mapLevel.controlLevel["magicMirrorBtn"].removeEventListener(MouseEvent.CLICK,this.onMagicMirrorBtn);
               trace("播放穿越動畫！！！！");
               GV.onlineSocket.addEventListener("movie_over",this.onMovieOver);
               loadGame = new LoadGame("resource/movie/gotoLamuPart.swf","正在打開面板",MainManager.getAppLevel());
               loadGame = null;
            }
         }
         else
         {
            GF.showAlert(GV.MC_AppLever,"    讓你的超級拉姆帶你一起進入神奇的魔法空間吧！","",100,"iknow",true,false,"E");
         }
      }
      
      private function onMovieOver(evt:Event) : void
      {
         GF.switchMap(95,true);
      }
      
      private function clickguo(evt:MouseEvent) : void
      {
         if(GV.MyInfo_PetObj.Level > 100)
         {
            checkItem.checkItemHandler(190413);
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveResult190413);
         }
         else if(GV.MyInfo_PetObj.Level < 100)
         {
            checkItem.checkItemHandler(190410);
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveResult190410);
         }
         else
         {
            Alert.smileAlart("帶著你的小拉姆一起來熬制魔法湯吧。");
         }
      }
      
      private function haveResult190413(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveResult190413);
         if(evt.EventObj.count == 1)
         {
            _mapLevel.depthLevel["guo"].gotoAndStop(2);
            _mapLevel.buttonLevel["ziyoutang"].gotoAndStop(2);
         }
         else
         {
            checkItem.checkItemHandler(190410);
            GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveResult190410);
         }
      }
      
      private function haveResult190410(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveResult190410);
         if(evt.EventObj.count == 1)
         {
            _mapLevel.depthLevel["guo"].gotoAndStop(3);
            _mapLevel.buttonLevel["ziyoutang"].gotoAndStop(3);
         }
         else
         {
            Alert.smileAlart("　　湯鍋能熬出自由湯，解救琥珀石中的小動物哦，趕快到尼爾拉塔那裡找材料吧！");
         }
      }
      
      private function clickziyoutang(evt:MouseEvent) : void
      {
         if(evt.currentTarget.currentFrame == 2)
         {
            Deal.SwapItem([new SwapItem(190413,1)],[new SwapItem(190414,1)],function(e:*):*
            {
               Alert.getIconByID_Alart(190414,"　　醋果自由湯已放入你的百寶箱中，趕快去尼爾拉塔點擊琥珀石，解救綿羊寶寶吧！");
            });
         }
         else if(evt.currentTarget.currentFrame == 3)
         {
            Deal.SwapItem([new SwapItem(190410,1)],[new SwapItem(190411,1)],function(e:*):*
            {
               Alert.getIconByID_Alart(190411,"　　桑果自由湯已放入你的百寶箱中，趕快去尼爾拉塔點擊琥珀石，解救蠶寶寶吧！");
            });
         }
         _mapLevel.buttonLevel["ziyoutang"].gotoAndStop(1);
         _mapLevel.depthLevel["guo"].gotoAndStop(1);
      }
      
      private function getBookEvent2(evt:MouseEvent) : void
      {
         Deal.BuyItem(12904,1,function(E:*):*
         {
            Alert.getIconByID_Alart(12904,"　　哇，恭喜你找到拉姆魔法書，去百寶箱裡看看吧！");
         },function(E:*):*
         {
            Alert.smileAlart("       你已經有了這個寶貝啦！");
         });
      }
      
      private function petBookEvent(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/besmearBook/MagicBook.swf","正在打開魔法課堂手冊...",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function initMagicProphet() : void
      {
         _mapLevel.controlLevel["magicBall"].addEventListener(MouseEvent.CLICK,this.onMagicBall);
      }
      
      private function onMagicBall(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         var msg:String = null;
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            loadGame = new LoadGame("module/external/MagicProphetMain.swf","正在打開面板",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            msg = "    帶著你的小拉姆，來領取拉姆魔法帽吧！快樂要一起分享哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("sayOver",this.sayOverHandle);
         super.destroy();
      }
   }
}

