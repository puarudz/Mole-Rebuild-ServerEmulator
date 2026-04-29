package com.view.mapView
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class MirrorWorldView extends MapBase
   {
      
      public static var didlaTaskObj:Object;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var topMC:MovieClip;
      
      public var button_mc:MovieClip;
      
      private var bookMC:MovieClip;
      
      public function MirrorWorldView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.topMC = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         GameframeLogic.playMousicHandler();
         BC.addEvent(this,this.button_mc.SLClothBookBtn,MouseEvent.CLICK,this.onSLClothBookBtn);
         BC.addEvent(this,this.target_mc.newBook_btn,MouseEvent.CLICK,this.onSLClothBookBtn);
         this.checkDidilaTask();
         BC.addEvent(this,TalkEvent,"huabao_silkyGua",this.silkyGuaHandler);
      }
      
      private function silkyGuaHandler(evt:TalkEvent) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190669,2);
      }
      
      private function getItemCountLogic(evt:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         if(evt.EventObj.obj.Count != 0)
         {
            loadGame = new LoadGame("module/external/silkyGuaguale.swf","正在打開......",MainManager.getAppLevel());
            loadGame = null;
         }
         else
         {
            mapSay(4);
         }
      }
      
      private function onSLClothBookBtn(evt:MouseEvent) : void
      {
         this.showBookView();
      }
      
      private function showBookView() : void
      {
         ModuleManager.openPanel("SLClothBookPanel");
      }
      
      public function checkDidilaTask() : void
      {
         var task241State:uint = 0;
         if(LocalUserInfo.isVIP())
         {
            task241State = TaskManager.getTaskState(241);
            if(task241State == 1)
            {
               BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfo);
               JobExpandLogic.getJobExpand().getOneJob(241);
            }
         }
      }
      
      private function getJobInfo(evt:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getJobInfo);
         didlaTaskObj = evt.EventObj.obj;
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.topMC = null;
         this.button_mc = null;
         super.destroy();
      }
   }
}

