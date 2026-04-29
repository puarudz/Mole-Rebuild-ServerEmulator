package com.view.mapView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.task.SummerActivityCtr;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.mapModule.Map85AddMakeCar;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import com.view.JobView.ChildNPCModule.ChildNpc.DriveNpcJob;
   import com.view.JobView.ChildNPCModule.ChildNpc.DriveNpcJob2;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TrafficView extends MapBase
   {
      
      private static const CLOUD_CRYSTALS:uint = 191078;
      
      public var target_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var jobview:DriveNpcJob;
      
      private var paperMC:MovieClip;
      
      public function TrafficView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.jobview = new DriveNpcJob();
         var jobview2:DriveNpcJob2 = new DriveNpcJob2();
         jobview2.setTargetMC(this.target_mc.npc2_btn);
         var Map85AddMakeCars:Map85AddMakeCar = new Map85AddMakeCar();
         Map85AddMakeCars = null;
         BC.addEvent(this,this.target_mc.book_btn,MouseEvent.CLICK,this.book_btnHandler);
         BC.addEvent(this,this.target_mc.bookMc_btn,MouseEvent.CLICK,this.book_btnHandler);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPaperCountBack);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190435,2,190437);
         SummerActivityCtr.inst.initTrans();
         GV.onlineSocket.addEventListener("NPCOldJob141",this.onNPCOldJob);
         SystemEventManager.addEventListener("windKnight",this.onWindKnight);
      }
      
      private function onWindKnight(evt:Event) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),CLOUD_CRYSTALS,2,CLOUD_CRYSTALS + 1);
      }
      
      private function getItemCountBk(evt:EventTaomee) : void
      {
         var itemObj:Object = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         var itemArr:Array = evt.EventObj.obj.arr;
         for each(itemObj in itemArr)
         {
            if(CLOUD_CRYSTALS == itemObj.ID)
            {
               if(itemObj.Count >= 1)
               {
                  mapSay(7);
                  ActivityTmpDataManager.getTransferItem(7);
                  return;
               }
            }
         }
         mapSay(8);
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var task141State:uint = TaskManager.getTaskState(141);
         if(task141State == 1)
         {
         }
      }
      
      private function getPaperCountBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPaperCountBack);
         var obj:Object = evt.EventObj.obj;
         if(obj.Count > 0)
         {
            this.botton_mc.paper_btn.visible = false;
         }
         else
         {
            this.botton_mc.paper_btn.alpha = 1;
            BC.addEvent(this,this.botton_mc.paper_btn,MouseEvent.CLICK,this.getPaperFun);
            BC.addEvent(this,GV.onlineSocket,"getPaperOK",this.hidePaper);
         }
      }
      
      private function getPaperFun(evt:MouseEvent = null) : void
      {
         this.paperMC = new MovieClip();
         this.paperMC.name = "selectPaperMC";
         MainManager.getAppLevel().addChild(this.paperMC);
         var temp:MCLoader = new MCLoader("module/external/SelectPaper.swf",this.paperMC,1,"正在打開圖紙面板");
         temp.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
         temp.doLoad();
      }
      
      private function loadSuccFun(evt:MCLoadEvent = null) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadSuccFun);
         mcloader.clear();
      }
      
      private function hidePaper(evt:Event = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"getPaperOK",this.hidePaper);
         BC.removeEvent(this,this.botton_mc.paper_btn,MouseEvent.CLICK,this.getPaperFun);
         this.botton_mc.paper_btn.visible = false;
      }
      
      private function book_btnHandler(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/besmearBook/driveBook.swf","正在打開駕駛員手冊",MainManager.getGameLevel());
         loadGame = null;
      }
      
      override public function destroy() : void
      {
         this.target_mc = null;
         this.botton_mc = null;
         GV.onlineSocket.removeEventListener("NPCOldJob141",this.onNPCOldJob);
         SystemEventManager.removeEventListener("windKnight",this.onWindKnight);
         super.destroy();
      }
   }
}

