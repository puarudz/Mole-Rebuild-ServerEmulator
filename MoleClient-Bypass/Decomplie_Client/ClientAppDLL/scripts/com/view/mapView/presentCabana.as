package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.module.activityModule.checkItem;
   import com.module.activityModule.giftModule;
   import com.module.mapModule.Map76PMClass;
   import com.module.present.PresentManager;
   import com.module.present.presentBookView;
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class presentCabana extends MapBase
   {
      
      public var id:uint;
      
      public var presentArr:Array = [1220039,1220038,160267,160268,1220037,12713,12714,12715,12716,160339,160340,1220051,1220052,1220053,160377,160378,160379,160380,160381,1220072,1220082,160472,160473,13052,160519];
      
      public function presentCabana()
      {
         super();
      }
      
      override protected function initView() : void
      {
         for(var i:uint = 0; i < this.presentArr.length; i++)
         {
            try
            {
               if(Boolean(_mapLevel.controlLevel["btn" + i]))
               {
                  BC.addEvent(this,_mapLevel.controlLevel["btn" + i],MouseEvent.CLICK,this.present);
               }
            }
            catch(err:Error)
            {
            }
         }
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 160474],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 160475],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 160518],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 160517],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 160516],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 12099],MouseEvent.CLICK,this.bugItem);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 2],MouseEvent.MOUSE_OVER,this.pandaOver);
         BC.addEvent(this,_mapLevel.controlLevel["btn" + 2],MouseEvent.MOUSE_OUT,this.pandaOut);
         BC.addEvent(this,_mapLevel.controlLevel["giftBtn"],MouseEvent.CLICK,this.giftEvent);
         BC.addEvent(this,_mapLevel.controlLevel["book_btn"],MouseEvent.CLICK,this.loadbook);
         var Map76PMClass_a:Map76PMClass = new Map76PMClass();
         Map76PMClass_a.Info();
         Map76PMClass_a = null;
         BC.addEvent(this,_mapLevel.controlLevel["luckyMachine"],MouseEvent.CLICK,this.luckyClick);
      }
      
      private function luckyClick(e:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.haveLuckyTicket);
         checkItem.checkItemHandler(190460);
      }
      
      private function haveLuckyTicket(evt:EventTaomee) : void
      {
         var url:String = null;
         var mc:Sprite = null;
         var mcloader:MCLoader = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.haveLuckyTicket);
         if(evt.EventObj.num < 1)
         {
            GF.showAlert(MainManager.getGameLevel(),"　　嘿，給你的好友贈送禮物就可以獲得友誼券哦，有了友誼券再來啟動幸運抽獎機吧！","",100,"iknow",true,false,"E");
         }
         else
         {
            url = "module/external/LuckyMachine.swf";
            if(MainManager.getAppLevel().getChildByName("luckyMachine") == null)
            {
               mc = new Sprite();
               mc.name = "luckyMachine";
               MainManager.getAppLevel().addChild(mc);
               mcloader = new MCLoader(url,mc,1,"正在打開抽獎機...");
               mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.luckyMachineComplete);
               mcloader.addEventListener(MCLoadEvent.ERROR,this.loadErr);
               mcloader.doLoad();
            }
         }
      }
      
      private function luckyMachineComplete(event:MCLoadEvent) : void
      {
         event.currentTarget.removeEventListener(MCLoadEvent.ON_SUCCESS,this.luckyMachineComplete);
         event.currentTarget.removeEventListener(MCLoadEvent.ERROR,this.loadErr);
         var a:DisplayObjectContainer = event.getParent();
         var b:Loader = event.getLoader();
         var c:DisplayObjectContainer = event.getContent() as DisplayObjectContainer;
         a.addChild(c);
      }
      
      private function loadErr(event:MCLoadEvent) : void
      {
         event.currentTarget.removeEventListener(MCLoadEvent.ON_SUCCESS,this.luckyMachineComplete);
         event.currentTarget.removeEventListener(MCLoadEvent.ERROR,this.loadErr);
      }
      
      private function bugItem(evt:MouseEvent) : void
      {
         this.id = uint(evt.currentTarget.name.slice(3,9));
         if(this.id == 160446 || this.id == 160447 || this.id == 160448 || this.id == 160449 || this.id == 160474 || this.id == 160475)
         {
            GV.onlineSocket.addEventListener("read_" + 1354,this.getNum);
            PresentGoodsReq.sendPresentNum();
            return;
         }
         if(this.id == 12099 || this.id == 160518 || this.id == 160517 || this.id == 160516)
         {
            GF.showAlert(MainManager.getGameLevel(),"    只有去抽獎才能獲取這個物品哦！","",100,"iknow",true,false,"E");
            return;
         }
      }
      
      public function getNum(e:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var backAlert:* = undefined;
         GV.onlineSocket.removeEventListener("read_" + 1354,this.getNum);
         if(e.EventObj.num >= 3)
         {
            url = "resource/goods/icon/" + this.id + ".swf";
            msg = "    你要領取一個" + GoodsInfo.getItemNameByID(this.id) + "嗎？";
            backAlert = Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
            backAlert.addEventListener("CLICK" + 1,this.buyTheItem);
         }
         else
         {
            Alert.showAlert(MainManager.getGameLevel(),"你還需要贈送" + (3 - e.EventObj.num) + "次禮物給好友，才可以領取這樣物品哦！","",6,"D");
         }
      }
      
      public function buyTheItem(e:*) : void
      {
         GV.onlineSocket.addEventListener("read_" + 1353,this.getItemSucc);
         PresentGoodsReq.getMyPresent(this.id);
      }
      
      public function getItemSucc(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 1353,this.getItemSucc);
         var url:String = "resource/goods/icon/" + this.id + ".swf";
         var msg:String = "    一個" + GoodsInfo.getItemNameByID(this.id) + "已經放入你的小屋倉庫中。";
         Alert.showAlert(MainManager.getGameLevel(),url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
      }
      
      private function giftEvent(evt:MouseEvent) : void
      {
         var type:Number = NaN;
         var str:String = null;
         type = 10;
         str = "resource/giftItem/gift033.swf";
         var info:String = "你發現了七色花空氣結晶大禮包！";
         giftModule.succMsg = "物品已放入你的百寶箱中!!!";
         giftModule.giftData = "giftGuideData_1";
         giftModule.isPet = true;
         giftModule.giftHandler(type,str,info);
      }
      
      private function pandaOver(e:Event) : void
      {
         _mapLevel.depthLevel["panda1"].gotoAndStop(2);
         _mapLevel.depthLevel["panda2"].gotoAndStop(2);
      }
      
      private function pandaOut(e:Event) : void
      {
         _mapLevel.depthLevel["panda1"].gotoAndStop(1);
         _mapLevel.depthLevel["panda2"].gotoAndStop(1);
      }
      
      private function present(e:Event) : void
      {
         var presentid:uint = uint(this.presentArr[Number(e.target.name.slice(3))]);
         PresentManager.init(presentid);
      }
      
      private function loadbook(e:MouseEvent) : void
      {
         var bookView:MovieClip = null;
         var loadBookEvent:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("presentbookview"))
         {
            bookView = new MovieClip();
            bookView.name = "presentbookview";
            MainManager.getGameLevel().addChild(bookView);
            loadBookEvent = new MCLoader("module/homeBookView/presentBookView.swf",bookView,1,"加載禮物贈送書...");
            BC.addEvent(this,loadBookEvent,MCLoadEvent.ON_SUCCESS,this.loadItemBookHandler);
            loadBookEvent.doLoad();
         }
      }
      
      private function loadItemBookHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = null;
         var childMC:* = undefined;
         mainMC = evt.getParent();
         childMC = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = (MainManager.getStageWidth() - mainMC.width) / 2;
         mainMC.y = (MainManager.getStageHeight() - mainMC.height) / 2;
         new presentBookView(childMC.content.root);
         var mcloader:MCLoader = evt.target as MCLoader;
         BC.removeEvent(this,mcloader,MCLoadEvent.ON_SUCCESS,this.loadItemBookHandler);
         mcloader.clear();
      }
   }
}

