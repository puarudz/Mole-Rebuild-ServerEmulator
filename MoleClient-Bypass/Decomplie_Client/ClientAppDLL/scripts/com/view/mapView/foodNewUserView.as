package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.deal.Deal;
   import com.module.npc.I_NPC;
   import com.module.npc.NPCEvent;
   import com.mole.app.map.MapBase;
   import com.view.toolView.toolView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class foodNewUserView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var test_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var tempBool:Boolean;
      
      public var npc:I_NPC;
      
      public var hasCloth:Boolean = false;
      
      public function foodNewUserView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.test_mc = GV.MC_mapFrame["test_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.tempBool = true;
         toolView.setToolBtns(0,0,0,0,0,0,0,0,0,0);
         this.top_mc.map_btn.visible = false;
         this.top_mc.light.gotoAndStop(1);
         this.top_mc.light.mouseChildren = false;
         this.top_mc.light.mouseEnabled = false;
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            taskMC.visible = false;
         }
         this.newPlayerInit();
      }
      
      private function newPlayerInit() : void
      {
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),12052,0);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.haveddkResult);
      }
      
      private function haveddkResult(evt:EventTaomee) : void
      {
         var obj:Object = new Object();
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.haveddkResult);
         if(evt.EventObj.obj.Count > 0)
         {
            this.hasCloth = true;
            obj.flag = 8;
            this.target_mc.nicBtn.mouseEnabled = false;
            this.target_mc.nicBtn.visible = false;
            this.top_mc.map_btn.visible = true;
            this.top_mc.map_btn.addEventListener(MouseEvent.CLICK,this.openMapHandler);
            this.top_mc.map.closeBtn.addEventListener(MouseEvent.CLICK,this.hideMapHandler);
            this.top_mc.map.map3_btn.addEventListener(MouseEvent.CLICK,this.switchMapHandler);
            this.top_mc.light.gotoAndPlay(1);
            this.top_mc.light.x = 32;
            this.top_mc.light.y = 478;
         }
         else
         {
            this.hasCloth = false;
            obj.flag = 7;
            this.top_mc.light.gotoAndPlay(1);
            this.top_mc.light.x = 326;
            this.top_mc.light.y = 189;
            this.target_mc.nicBtn.addEventListener(MouseEvent.CLICK,this.nickHandler);
         }
         JobExpandLogic.getJobExpand().setOneJob(300,obj);
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.setNpc);
      }
      
      private function setNpc(e:NPCEvent) : void
      {
         BC.removeEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.setNpc);
         if(e.npc.npcInfo.id == 1002)
         {
            this.npc = e.npc;
            this.npc.x = 260;
            this.npc.y = 240;
            this.npc.MoveTo(250,200);
         }
      }
      
      private function openMapHandler(e:MouseEvent) : void
      {
         this.top_mc.map.y = 0;
         this.top_mc.light.play();
         this.top_mc.light.x = 538;
         this.top_mc.light.y = 211;
      }
      
      private function hideMapHandler(e:MouseEvent) : void
      {
         this.top_mc.map.y = -600;
         this.top_mc.light.play();
         this.top_mc.light.x = 32;
         this.top_mc.light.y = 478;
      }
      
      private function switchMapHandler(e:MouseEvent) : void
      {
         GF.switchMap(140,true);
      }
      
      private function nickHandler(e:MouseEvent) : void
      {
         this.target_mc.nicBtn.removeEventListener(MouseEvent.CLICK,this.nickHandler);
         this.top_mc.panel.y = 80;
         this.top_mc.panel.btn.addEventListener(MouseEvent.CLICK,this.nickClickHandler);
         this.target_mc.nicBtn.mouseEnabled = false;
         this.target_mc.nicBtn.visible = false;
         this.top_mc.light.play();
         this.top_mc.light.x = 485;
         this.top_mc.light.y = 346;
      }
      
      private function nickClickHandler(e:Event) : void
      {
         this.top_mc.panel.y = -600;
         this.top_mc.light.gotoAndStop(1);
         this.top_mc.light.y = -200;
         Deal.BuyItem(12052,1,this.getClothSuccess,this.getClothSuccess);
         var obj:Object = new Object();
         obj.flag = 8;
         JobExpandLogic.getJobExpand().setOneJob(300,obj);
         JobExpandLogic.getJobExpand().addEventListener(JobExpandLogic.ONEJOBINFO,this.getBack);
      }
      
      private function getClothSuccess(e:*) : void
      {
         this.hasCloth = true;
         Alert.getIconByID_Alart(12052,"\t\t恭喜你獲得了侍者服,已經放入到你的百寶箱中了!");
         this.top_mc.light.play();
         this.top_mc.light.x = 32;
         this.top_mc.light.y = 478;
      }
      
      private function getBack(e:EventTaomee) : void
      {
         JobExpandLogic.getJobExpand().removeEventListener(JobExpandLogic.ONEJOBINFO,this.getBack);
         this.top_mc.map_btn.visible = true;
         this.top_mc.map_btn.addEventListener(MouseEvent.CLICK,this.openMapHandler);
         this.top_mc.map.closeBtn.addEventListener(MouseEvent.CLICK,this.hideMapHandler);
         this.top_mc.map.map3_btn.addEventListener(MouseEvent.CLICK,this.switchMapHandler);
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         this.top_mc = null;
         this.npc = null;
         super.destroy();
      }
   }
}

