package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.farm.farmSocket;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.module.npc.dialog.TalkEvent;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.gameking.GameKingManager;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ActionType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LivestockMapView extends BasicMapView
   {
      
      public var loadBookEvent:*;
      
      private var sgm_mc:MovieClip;
      
      private var myalter:*;
      
      private var panel:*;
      
      private var npc5:MoleNPC;
      
      public function LivestockMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.initConvertButton();
         this.initBuyCat();
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.checkTask572);
      }
      
      private function onEnterSeat(e:*) : void
      {
         GameKingManager.instance.enterGameById(55);
      }
      
      override public function init() : void
      {
         var npcOptionInfo:NPCDialogOptionInfo = null;
         super.init();
         var sayList:Array = new Array();
         npcOptionInfo = new NPCDialogOptionInfo("出售農漁牧產品",ActionType.SYSTEM_ACT,"yoyo_sale1");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("購買普通漁網",ActionType.SYSTEM_ACT,"yoyo_sale2");
         sayList.push(npcOptionInfo);
         npcOptionInfo = new NPCDialogOptionInfo("沒什麼事",ActionType.NONE);
         sayList.push(npcOptionInfo);
         var npcDialogInfo:NPCDialogInfo = new NPCDialogInfo(10050,"正常","見到你真是太高興了，我有點不好意思直接說出口，可是我真的非常非常高興見到你！",sayList);
         this.npc5 = NPC.getNPCInstance(1);
         this.npc5.dialogInfo = npcDialogInfo;
         this.masonSayFun();
      }
      
      private function initBuyCat() : void
      {
         BC.addEvent(this,TalkEvent,"clutinousRiceDumpling_showBuyCarPan",function(e:Event):void
         {
            _mapLevel.controlLevel["cat_mc"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         });
      }
      
      private function initConvertButton() : void
      {
         BC.addEvent(this,_mapLevel.buttonLevel["duck_npc_btn"],MouseEvent.MOUSE_OVER,this.duckOverHandler);
         BC.addEvent(this,_mapLevel.buttonLevel["duck_npc_btn"],MouseEvent.MOUSE_OUT,this.duckOutHandler);
         BC.addEvent(this,_mapLevel.buttonLevel["pig_npc_btn"],MouseEvent.MOUSE_OVER,this.pigOverHandler);
         BC.addEvent(this,_mapLevel.buttonLevel["pig_npc_btn"],MouseEvent.MOUSE_OUT,this.pigOutHandler);
         BC.addEvent(this,_mapLevel.buttonLevel["duck_npc_btn"],MouseEvent.CLICK,this.npcClickHandler);
         BC.addEvent(this,_mapLevel.buttonLevel["pig_npc_btn"],MouseEvent.CLICK,this.npcClickHandler);
         _mapLevel.controlLevel["farmItemBook_btn"].visible = false;
         BC.addEvent(this,_mapLevel.controlLevel["farmItemBook_newBtn"],MouseEvent.CLICK,this.openFarmItemBook);
      }
      
      private function reclaimEvent(e:*) : void
      {
         var path:String = "module/external/SunshineTrade.swf";
         var laodGame:LoadGame = new LoadGame(path,"正在加載交易面板......",MainManager.getAppLevel());
         laodGame = null;
      }
      
      private function openFarmItemBook(e:MouseEvent) : void
      {
         ModuleManager.openPanel("PastureShopsPanel");
      }
      
      private function masonSayFun() : void
      {
         SystemEventManager.addEventListener("yoyo_sale1",this.sale1Fun);
         SystemEventManager.addEventListener("yoyo_sale2",this.sale2Fun);
      }
      
      private function sale1Fun(eve:*) : void
      {
         this.dosell();
      }
      
      private function sale2Fun(eve:Event) : void
      {
         this.dobuy();
      }
      
      private function openBuyNetPanel(e:Event) : void
      {
         var ui:Class = null;
         if(!GV.MC_AppLever.getChildByName("buypanel_yoyo"))
         {
            ui = GV.Lib_Map.getClass("buynetUI");
            this.panel = new ui();
            this.panel.name = "buypanel_yoyo";
            GV.MC_AppLever.addChild(this.panel);
            this.panel.x = 480;
            this.panel.y = 280;
            BC.addEvent(this,this.panel.close_btn,MouseEvent.CLICK,this.closebuypanel);
            BC.addEvent(this,this.panel.sell_btn,MouseEvent.CLICK,this.dosell);
            BC.addEvent(this,this.panel.buy_btn,MouseEvent.CLICK,this.dobuy);
         }
         else
         {
            this.panel.y = 280;
         }
      }
      
      private function closebuypanel(e:MouseEvent = null) : void
      {
         try
         {
            this.panel.y = 2800;
         }
         catch(err:Error)
         {
         }
      }
      
      private function dosell(e:MouseEvent = null) : void
      {
         this.reclaimEvent(e);
      }
      
      private function dobuy(e:MouseEvent = null) : void
      {
         this.closebuypanel();
         var msg:String = "    是不是家裡的魚太多了都來不及釣了呀？用我的漁網就方便多了，一次最多可以撈5條魚呢，使用壽命20次，100摩爾豆一把。你要購買嗎？";
         var url:String = "resource/allJob/AlertPic/yoyo512.swf";
         var myAlert:* = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI","424,336");
         myAlert.addEventListener(Alert.CLICK_ + "1",this.BuyNet,false,0,true);
      }
      
      private function BuyNet(e:Event) : void
      {
         farmSocket.buynet();
         BC.addEvent(this,GV.onlineSocket,"read_" + 1900,this.buynetsucc);
      }
      
      private function buynetsucc(evt:EventTaomee) : void
      {
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 100);
         var msg:String = "    漁網已經送到你的牧場。點擊它就開始撈魚，保護小魚，撈的時候要輕點哦。有需要再來找我吧";
         var url:String = "resource/allJob/AlertPic/yoyo512.swf";
         var myAlert:* = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI","424,336");
      }
      
      private function npcClickHandler(eve:MouseEvent = null) : void
      {
         var btn:* = eve.target as SimpleButton;
         switch(btn.name)
         {
            case "duck_npc_btn":
               this.showConvertAlert(190223,"    用小鴨兌換券來兌換小鴨動物寶寶吧，一張只能兌換一隻哦，確定要兌換嗎？");
               break;
            case "pig_npc_btn":
               this.showConvertAlert(190229,"    用紅豬兌換券來兌換紅豬動物寶寶吧，一張只能兌換一隻哦，確定要兌換嗎？");
         }
      }
      
      private function showConvertAlert(id:uint, _msg:String) : void
      {
         var _url:String = "resource/allJob/icon/" + String(id) + ".swf";
         this.myalter = Alert.showAlert(MainManager.getAppLevel(),_url,_msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         if(id == 190223)
         {
            this.myalter.addEventListener(Alert.CLICK_ + "1",this.getDuckItemEvent,false,0,true);
         }
         else
         {
            this.myalter.addEventListener(Alert.CLICK_ + "1",this.getPigItemEvent,false,0,true);
         }
      }
      
      private function getDuckItemEvent(eve:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.duckItemSucHandler);
         checkItem.checkItemHandler(190223);
      }
      
      private function getPigItemEvent(eve:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.pigItemSucHandler);
         checkItem.checkItemHandler(190229);
      }
      
      private function duckItemSucHandler(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.duckItemSucHandler);
         if(evt.EventObj.num >= 1)
         {
            BC.addEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
            GV.itemID = 4;
            CSReq.Info(521);
         }
         else
         {
            msg = "    這裡可以用小鴨兌換券來兌換小鴨動物寶寶哦，你身上還沒有兌換券哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function pigItemSucHandler(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.pigItemSucHandler);
         if(evt.EventObj.num >= 1)
         {
            BC.addEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
            GV.itemID = 4;
            CSReq.Info(520);
         }
         else
         {
            msg = "    這裡可以用紅豬兌換券來兌換紅豬動物寶寶哦，你身上還沒有兌換券哦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function getItemOkHandler(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getItemOkHandler);
         var obj:Object = eve.EventObj;
         if(obj.Cnt == 0)
         {
            return;
         }
         var msg:String = String(obj.ItemID);
         switch(obj.Arr[0].ItemID)
         {
            case 1270001:
               msg = "恭喜你獲得一隻紅豬動物寶寶，趕快去自己的摩爾牧場倉庫裡看看吧！";
               break;
            case 1270002:
               msg = "恭喜你獲得一隻小鴨子動物寶寶，趕快去自己的摩爾牧場倉庫裡看看吧！";
         }
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function checkTask572(e:Event) : void
      {
      }
      
      private function duckOverHandler(eve:MouseEvent) : void
      {
         _mapLevel.depthLevel["duck_npc"].gotoAndStop(2);
      }
      
      private function duckOutHandler(eve:MouseEvent) : void
      {
         _mapLevel.depthLevel["duck_npc"].gotoAndStop(1);
      }
      
      private function pigOverHandler(eve:MouseEvent) : void
      {
         _mapLevel.depthLevel["pig_npc"].gotoAndStop(2);
      }
      
      private function pigOutHandler(eve:MouseEvent) : void
      {
         _mapLevel.depthLevel["pig_npc"].gotoAndStop(1);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("yoyo_sale1",this.sale1Fun);
         SystemEventManager.removeEventListener("yoyo_sale2",this.sale2Fun);
         DisplayUtil.removeForParent(this.sgm_mc);
         SystemEventManager.removeEventListener("beginGame",this.onEnterSeat);
         super.destroy();
      }
   }
}

