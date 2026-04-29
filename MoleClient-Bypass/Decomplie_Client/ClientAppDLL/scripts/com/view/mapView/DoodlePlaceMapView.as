package com.view.mapView
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.specialGoods.PaintWallLoader;
   import com.module.specialGoods.TuyaPainterLogic;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.view.monthlyView.besmearView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class DoodlePlaceMapView extends MapBase
   {
      
      public var TuyaPainter:*;
      
      public var Tuyawall:*;
      
      private var drawMC:MovieClip;
      
      private var besmear:besmearView;
      
      public function DoodlePlaceMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            _mapLevel.controlLevel["getBook_btn"].visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn_new"],MouseEvent.CLICK,this.addDrewBook);
         BC.addEvent(this,_mapLevel.controlLevel["bookBtn"],MouseEvent.CLICK,this.addDrewBook);
         BC.addEvent(this,_mapLevel.controlLevel["drawBtn"],MouseEvent.CLICK,this.drawHandler);
         BC.addEvent(this,_mapLevel.controlLevel["wallBtn"],MouseEvent.CLICK,this.wallHandler);
         BC.addEvent(this,_mapLevel.controlLevel["getBook_btn"],MouseEvent.CLICK,this.getBookHandler);
         BC.addEvent(this,_mapLevel.controlLevel["stone_mc"],MouseEvent.CLICK,this.newPainHandle);
      }
      
      private function newPainHandle(e:MouseEvent) : void
      {
         ModuleManager.openPanel("MolePainter4");
      }
      
      private function addDrewBook(event:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getTopLevel().getChildByName("drawbook_mc") && !GV.isChangeMap)
         {
            this.drawMC = new MovieClip();
            this.drawMC.name = "drawbook_mc";
            MainManager.getTopLevel().addChild(this.drawMC);
            tempMC = new MCLoader("resource/besmearBook/besmearBook.swf",this.drawMC,Loading.TITLE_AND_PERCENT,"正在打開樂塗塗");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            tempMC.doLoad();
         }
      }
      
      private function drewBookLoadOver(evt:MCLoadEvent) : void
      {
         var mcloader:MCLoader = null;
         var mainMC:DisplayObjectContainer = null;
         var childMC:* = undefined;
         if(!GV.isChangeMap)
         {
            mcloader = MCLoader(evt.target);
            mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.drewBookLoadOver);
            mainMC = evt.getParent();
            childMC = evt.getLoader();
            mainMC.addChild(childMC);
            this.besmear = new besmearView(childMC);
            childMC.content.root.close_btn.addEventListener(MouseEvent.CLICK,this.removebesmear);
            mcloader.clear();
         }
      }
      
      private function removebesmear(evt:MouseEvent = null) : void
      {
         if(evt != null)
         {
            evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.removebesmear);
         }
         this.besmear.removeBtnHandler();
         GC.stopAllMC(this.drawMC);
         GC.clearChildren(this.drawMC);
         this.drawMC.parent.removeChild(this.drawMC);
         this.drawMC = null;
      }
      
      private function drawHandler(evt:MouseEvent) : void
      {
         if(!this.TuyaPainter)
         {
            this.TuyaPainter = new TuyaPainterLogic();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_tuya_painter"));
         }
      }
      
      private function wallHandler(evt:MouseEvent) : void
      {
         if(!this.Tuyawall)
         {
            this.Tuyawall = new PaintWallLoader();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_tuya_wall"));
         }
      }
      
      private function getBookHandler(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 160192;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
         petItemModule.setPetEffectHandler();
      }
   }
}

