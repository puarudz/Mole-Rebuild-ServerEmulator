package com.view.mapView
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.clothBuyModule.effectBuyModule;
   import com.module.coin.SutraBookModule;
   import com.module.loadExtentPanel.SpringPanel;
   import com.module.strangeMachineModule.StrangeMachineAI;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class propertyView extends MapBase
   {
      
      public var colorArray:Array = new Array("綠色藥水","橙色藥水","藍色藥水","紫色藥水","紅色藥水","土色藥水","粉色藥水","灰色藥水");
      
      public var goodArray:Array = [160148,161161];
      
      private var BookMC:MovieClip;
      
      private var upholsterBook:MovieClip;
      
      public function propertyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var obj1:Object = {
            "btn":controlLevel.gameBtn.btn,
            "mc":controlLevel.gameBtn,
            "id":"swf150002",
            "fre":2,
            "hide":true
         };
         throwHitTest.HitTestMC(obj1);
         buttonLevel.tomato_btn.buttonMode = true;
         buttonLevel.banger_btn.buttonMode = true;
         buttonLevel.tomato_btn.id = 150002;
         buttonLevel.tomato_btn.Price = 15;
         buttonLevel.tomato_btn.clientName = "番茄";
         buttonLevel.banger_btn.id = 150003;
         buttonLevel.banger_btn.Price = 30;
         buttonLevel.banger_btn.clientName = "炮竹";
         buttonLevel.tomato_btn.addEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         buttonLevel.banger_btn.addEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         for(var j:int = 1; j <= this.colorArray.length; j++)
         {
            controlLevel.coloc_mc["mc_" + j].buttonMode = true;
            controlLevel.coloc_mc["mc_" + j].id = 16000 + j;
            controlLevel.coloc_mc["mc_" + j].Price = 500;
            controlLevel.coloc_mc["mc_" + j].clientName = this.colorArray[j - 1];
            controlLevel.coloc_mc["mc_" + j].addEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         }
         controlLevel.room_btn.buttonMode = true;
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OVER,this.windowHandlerOver);
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.windowHandlerOut);
         buttonLevel.effect_btn.buttonMode = true;
         buttonLevel.effect_btn.addEventListener(MouseEvent.MOUSE_OVER,this.effectOver);
         buttonLevel.effect_btn.addEventListener(MouseEvent.MOUSE_OUT,this.effectOut);
         buttonLevel.effect_btn.addEventListener(MouseEvent.CLICK,this.effectClick);
         buttonLevel.cloth_btn.buttonMode = true;
         buttonLevel.cloth_btn.addEventListener(MouseEvent.CLICK,this.clothBuyHandler);
         controlLevel.upholsterBook_2.visible = false;
         controlLevel.upholsterBook.addEventListener(MouseEvent.CLICK,this.openBookAction);
         BC.addEvent(this,buttonLevel.book1_btn,MouseEvent.CLICK,this.openHouseEvent2);
         BC.addEvent(this,buttonLevel.book2_btn,MouseEvent.CLICK,this.openHouseEvent2);
         controlLevel.tipBtn.addEventListener(MouseEvent.CLICK,this.newTipsHandler);
         this.initGoodHandler();
         new StrangeMachineAI(controlLevel["guaiguaiji"]);
         BC.addEvent(this,controlLevel.openNewBook,MouseEvent.CLICK,this.openNewBook);
      }
      
      private function openNewBook(e:MouseEvent) : void
      {
         ModuleManager.openPanel("HomeBookShopPanel");
      }
      
      private function openHouseEvent2(evt:MouseEvent) : void
      {
         controlLevel.upholsterBook_2.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function newTipsHandler(evt:MouseEvent) : void
      {
         SpringPanel.getInstance().dapPanel(MainManager.getAppLevel(),"newTips");
      }
      
      private function openBookAction(evt:MouseEvent) : void
      {
         ModuleManager.openPanel("HouseShopsPanel");
      }
      
      private function clothBuyHandler(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.itemArray = [12082,12083,12084];
         itemObj.price = 2300;
         itemObj.info = "潛水服";
         clothBuyModule.buyAction(itemObj,true,true);
      }
      
      private function tomatoBuyHandler(evt:MouseEvent = null) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = evt.currentTarget.id;
         itemObj.price = evt.currentTarget.Price;
         itemObj.info = evt.currentTarget.clientName;
         clothBuyModule.buyAction(itemObj,false);
      }
      
      private function windowHandlerOver(evt:MouseEvent) : void
      {
         controlLevel.window_mc.gotoAndStop(2);
      }
      
      private function windowHandlerOut(evt:MouseEvent) : void
      {
         controlLevel.window_mc.gotoAndStop(1);
      }
      
      private function effectOver(evt:MouseEvent) : void
      {
         for(var i:int = 1; i <= 6; i++)
         {
            controlLevel.effect_mc["ball_" + i].gotoAndPlay(2);
         }
      }
      
      private function effectOut(evt:MouseEvent) : void
      {
         for(var i:int = 1; i <= 6; i++)
         {
            controlLevel.effect_mc["ball_" + i].gotoAndStop(1);
         }
      }
      
      private function effectClick(evt:MouseEvent) : void
      {
         effectBuyModule.getInstance().effectClick();
      }
      
      private function initGoodHandler() : void
      {
         for(var i:int = 1; i <= 2; i++)
         {
            controlLevel["goods_" + i].addEventListener(MouseEvent.CLICK,this.goodBuyHandler);
         }
      }
      
      private function removeGood() : void
      {
         for(var i:int = 1; i <= 2; i++)
         {
            controlLevel["goods_" + i].removeEventListener(MouseEvent.CLICK,this.goodBuyHandler);
         }
      }
      
      private function goodBuyHandler(evt:MouseEvent) : void
      {
         var tempName:String = evt.target.name;
         var num:int = int(tempName.substr(6));
         if(num == 7)
         {
            GV.itemID = 3;
         }
         var tempNum:uint = uint(this.goodArray[num - 1]);
         var itemObj:Object = new Object();
         itemObj.id = tempNum;
         itemObj.price = GF.getPropData(tempNum).price;
         itemObj.info = GF.getPropData(tempNum).name;
         clothBuyModule.buyAction(itemObj);
      }
      
      private function openHouseEvent(evt:MouseEvent) : void
      {
         var url:String = "module/external/CoinBookUI/sutraHomeBook.swf";
         var str:String = "正在加載摩爾裝潢特別版......";
         var mcName:String = "houseBookMC";
         SutraBookModule.getInstance().initView(url,str,mcName);
      }
      
      override public function destroy() : void
      {
         this.removeGood();
         throwHitTest.removeHitTest();
         buttonLevel.tomato_btn.removeEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         buttonLevel.cloth_btn.removeEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         for(var j:int = 1; j <= this.colorArray.length; j++)
         {
            controlLevel.coloc_mc["mc_" + j].id = null;
            controlLevel.coloc_mc["mc_" + j].Price = null;
            controlLevel.coloc_mc["mc_" + j].clientName = null;
            controlLevel.coloc_mc["mc_" + j].removeEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         }
         buttonLevel.cloth_btn.removeEventListener(MouseEvent.CLICK,this.tomatoBuyHandler);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.windowHandlerOver);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.windowHandlerOut);
         super.destroy();
      }
   }
}

