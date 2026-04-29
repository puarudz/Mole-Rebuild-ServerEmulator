package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.query.QueryImpl;
   import com.module.superPetModule.petItemModule;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   
   public class emplacementMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var button_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var lookMC:MovieClip;
      
      private var itemObj:Object;
      
      public function emplacementMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.btn_1.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.target_mc.btn_2.addEventListener(MouseEvent.CLICK,this.clickHandler);
         BC.addEvent(this,this.target_mc.paoDan_mc,MouseEvent.CLICK,this.getLiwuFun);
         BC.addEvent(this,this.target_mc.paoDan_mc,"liwuOver",this.liwuOverFun);
         BC.addEvent(this,this.target_mc.liwu_pan.getliwu_btn,MouseEvent.CLICK,this.onBtnClick);
         BC.addEvent(this,this.target_mc.liwu_mc,MouseEvent.CLICK,this.getLiwu2Fun);
         this.target_mc.liwu_pan.num_mc.max = 100;
         this.target_mc.liwu_pan.num_mc.min = 1;
         this.target_mc.liwu_pan.num_mc.value = 1;
         var bookBtn:SimpleButton = this.button_mc["openDiDiBookBtn"];
         BC.addEvent(this,bookBtn,MouseEvent.CLICK,this.openPointBook);
         BC.addEvent(this,controlLevel["diandian_btn"],MouseEvent.CLICK,this.openDianDianShop);
      }
      
      private function openDianDianShop(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("DianDianShopPanel","加載商城面板中，請耐心等待......");
      }
      
      private function openDididouPanle(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/dididouRotationPanle.swf","正在加載大禮包",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function openPointBook(event:*) : void
      {
         ModuleManager.openPanel("SuperGoGoPanel");
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!GV.MC_AppLever.getChildByName("lookMC"))
         {
            tempMC = GV.Lib_Map.getClass("maskMC") as Class;
            this.lookMC = new tempMC();
            this.lookMC.name = "lookMC";
            GV.MC_AppLever.addChild(this.lookMC);
            this.lookMC.buttonMode = true;
            this.lookMC.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
            this.lookMC.addEventListener(MouseEvent.CLICK,this.removeClick);
         }
      }
      
      private function moveHandler(evt:MouseEvent) : void
      {
         this.lookMC.mc.startDrag(true);
      }
      
      private function removeClick(evt:MouseEvent) : void
      {
         this.lookMC.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
         this.lookMC.removeEventListener(MouseEvent.CLICK,this.removeClick);
         GC.stopAllMC(this.lookMC);
         GC.clearChildren(this.lookMC);
         this.lookMC.parent.removeChild(this.lookMC);
         this.lookMC = null;
      }
      
      private function getLiwuFun(evt:MouseEvent) : void
      {
         QueryImpl.getInstance().QueryItem([16012],function(arr:Array):void
         {
            if(arr[0].itemID == 16012)
            {
               if(arr[0].count > 0)
               {
                  target_mc.liwu_pan.num_mc.max = arr[0].count > 100 ? 100 : arr[0].count;
                  target_mc.liwu_pan.num_mc.value = 1;
                  target_mc.liwu_pan.x = 0;
                  target_mc.liwu_pan.num_mc.checkChange();
               }
               else if(LocalUserInfo.isVIP())
               {
                  Alert.SLAlart("    親愛的小摩爾，你還沒有足夠的超級點點豆！充值超級拉姆，就能擁有更多點點豆哦！");
               }
               else
               {
                  Alert.SLAlart("    親愛的小摩爾，你還沒有足夠的超級點點豆！成為超級拉姆，就能擁有更多點點豆哦！");
               }
            }
         });
      }
      
      private function getLiwu2Fun(evt:MouseEvent) : void
      {
         var dddnum:int = int(this.target_mc.liwu_pan.num_mc.value);
         var type:int = 0;
         if(dddnum < 20)
         {
            type = 13;
         }
         else if(dddnum < 40)
         {
            type = 14;
         }
         else if(dddnum < 80)
         {
            type = 15;
         }
         else if(dddnum <= 100)
         {
            type = 16;
         }
         else
         {
            type = 13;
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + 1242,this.backItemHandler);
         superlamuPartySocket.treasurebowl(type,0,dddnum);
      }
      
      private function liwuOverFun(e:Event) : void
      {
         this.getLiwu2Fun(null);
      }
      
      private function onBtnClick(e:MouseEvent) : void
      {
         var msg:String = "    你確定要放入" + this.target_mc.liwu_pan.num_mc.value + "超級點點豆嗎？大炮會吃掉點點豆，發射1件禮物給你哦！";
         var joinObj:* = GF.showAlert(MainManager.getAppLevel(),msg,"",100,"sure,cancel",true,false,"E");
         BC.addEvent(this,joinObj,"CLICK" + 1,this.onBtnClick2);
         this.target_mc.liwu_pan.x = -1000;
      }
      
      private function onBtnClick2(e:Event) : void
      {
         this.target_mc.paoDan_mc.gotoAndPlay(2);
      }
      
      private function backItemHandler(evt:EventTaomee) : void
      {
         this.itemObj = evt.EventObj;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1242,this.backItemHandler);
         this.target_mc.liwu_mc.gotoAndStop(1);
         Alert.smileAlart("　　恭喜你獲得" + this.itemObj.count + "個" + GoodsInfo.getItemNameByID(this.itemObj.itemId) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(this.itemObj.itemId) + "中！");
      }
      
      private function activHandler() : void
      {
         var randomNum:int = 0;
         if(LocalUserInfo.isVIP())
         {
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel == 101)
            {
               randomNum = Math.floor(Math.random() * 10);
               if(randomNum < 5)
               {
                  this.target_mc.activ_mc.mc_1.visible = true;
               }
               else
               {
                  this.target_mc.activ_mc.mc_2.visible = true;
               }
               GV.onlineSocket.addEventListener("pick_item",this.removeItemMC);
               GV.onlineSocket.addEventListener("sameEvent",this.removeItemMC);
               petItemModule.setPetEffectHandler(null,2);
            }
         }
      }
      
      private function removeItemMC(evt:EventTaomee) : void
      {
         petItemModule.setPetEffectHandler();
         GV.onlineSocket.removeEventListener("pick_item",this.removeItemMC);
         GV.onlineSocket.removeEventListener("sameEvent",this.removeItemMC);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         throwHitTest.removeHitTest();
         this.target_mc.btn_1.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.target_mc.btn_2.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         GV.onlineSocket.removeEventListener("pick_item",this.removeItemMC);
         GV.onlineSocket.removeEventListener("sameEvent",this.removeItemMC);
         super.destroy();
      }
   }
}

