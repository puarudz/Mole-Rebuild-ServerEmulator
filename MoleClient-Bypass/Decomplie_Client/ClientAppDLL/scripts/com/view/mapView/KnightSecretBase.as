package com.view.mapView
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.smc.collectItem.CollectItemRes;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.activityModule.checkItem;
   import com.module.bookItem.chevalierClothBookView;
   import com.mole.app.map.MapBase;
   import com.view.JobView.ChildMapJob.JobMap64View;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class KnightSecretBase extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var button_mc:MovieClip;
      
      private var clothBook:MovieClip;
      
      private var newBook:MovieClip;
      
      private var childMC:*;
      
      private var loginGame:*;
      
      private var job_timer:Timer;
      
      private var jobMap64:JobMap64View;
      
      public function KnightSecretBase()
      {
         super();
      }
      
      private function itemSucHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         if(evt.EventObj.num == 0)
         {
            this.target_mc.goodMC.visible = false;
         }
         this.jobMap64.checkItemF();
      }
      
      private function initJobMap64() : void
      {
         this.jobMap64 = new JobMap64View();
         BC.addEvent(this,GV.onlineSocket,"check_item_ok",this.itemSucHandlerB);
         BC.addEvent(this,GV.onlineSocket,"show_game_btn",this.gameBtnEvent);
      }
      
      private function itemSucHandlerB(eve:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"check_item_ok",this.itemSucHandlerB);
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.initJobMap64();
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.itemSucHandler);
         checkItem.checkItemHandler(12364);
         FortInsideMapView.isGetBook = true;
         BC.addEvent(this,this.target_mc.newBook,MouseEvent.CLICK,this.newBookHandler);
         BC.addEvent(this,this.target_mc.goodMC,MouseEvent.CLICK,this.goodMCHandler);
         BC.addEvent(this,GV.onlineSocket,"petAction_suc",this.selectGame);
         this.jobMap64.init();
      }
      
      private function selectGame(evt:EventTaomee = null) : void
      {
         var num:int = int(evt.EventObj.type);
         this.loginGame = GF.loginGame(5,num,27);
         this.loginGame.addEventForCard();
         this.loginGame.beforehandLoadGame();
      }
      
      private function gameBtnEvent(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"show_game_btn",this.gameBtnEvent);
         for(var i:int = 9; i <= 13; i++)
         {
            this.button_mc["gameBtn_" + i].visible = true;
         }
         for(var j:int = 1; j <= 5; j++)
         {
            this.depth_mc["mc_" + j].gotoAndPlay(2);
         }
      }
      
      private function goodMCHandler(evt:*) : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.getItemEvent);
         checkItem.checkItemHandler(12366);
      }
      
      private function getItemEvent(evt:EventTaomee) : void
      {
         var msg:String = null;
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.getItemEvent);
         if(evt.EventObj.num == 1)
         {
            msg = "你已經擁有了見習騎士套裝，不能再領取啦！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            return;
         }
         BC.addEvent(this,GV.onlineSocket,CollectItemRes.GET_ITEMCOUNT,this.changeListEvent);
         TaskOverProtocol.send(151);
      }
      
      private function changeListEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CollectItemRes.GET_ITEMCOUNT,this.changeListEvent);
         var msg:String = "騎士套裝已放入你的百寶箱中！";
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function newBookHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("newBook"))
         {
            this.newBook = new MovieClip();
            this.newBook.name = "newBook";
            MainManager.getAppLevel().addChild(this.newBook);
            tempMC = new MCLoader("module/external/BooksUI/chevalierClothBook.swf",this.newBook,Loading.TITLE_AND_PERCENT,"正在打開騎士榮耀");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.newBookOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function newBookOverHandler(evt:MCLoadEvent) : void
      {
         GV.onlineSocket.addEventListener("monthlyCloseEvent",this.removeMC);
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         var bookViews:chevalierClothBookView = new chevalierClothBookView(this.childMC.content.root);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.newBookOverHandler);
         mcloader.clear();
      }
      
      public function removeMC(event:Event) : void
      {
         GV.onlineSocket.removeEventListener("monthlyCloseEvent",this.removeMC);
         GC.clearAll(this.newBook);
         this.newBook = null;
      }
      
      override public function destroy() : void
      {
         var mcs:* = undefined;
         if(Boolean(this.newBook))
         {
            this.removeMC(null);
         }
         if(Boolean(this.job_timer))
         {
            GC.clearGTimeout(this.job_timer);
         }
         BC.removeEvent(this);
         if(Boolean(MainManager.getAppLevel().getChildByName("job_152_mc")))
         {
            mcs = MainManager.getAppLevel().getChildByName("job_152_mc");
            MainManager.getAppLevel().removeChild(mcs);
            mcs = null;
         }
         this.target_mc = null;
         this.depth_mc = null;
         this.jobMap64 = null;
         super.destroy();
      }
   }
}

