package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.petSocket.askingPet.PetAskReq;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import com.view.toolView.toolView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class petmapNewUserView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var effect_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      public var npc:I_NPC;
      
      public var hasLamu:Boolean = false;
      
      public function petmapNewUserView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         if(TaskManager.getTask(569).state == 1)
         {
            return;
         }
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkResult);
         JobExpandLogic.getJobExpand().getOneJob(300);
         toolView.setToolBtns(0,0,0,0,0,0,0,0,0,0);
         this.top_mc.light.mouseChildren = false;
         this.top_mc.light.mouseEnabled = false;
         MainManager.getRootMC().addChild(this.top_mc.light);
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            taskMC.visible = false;
         }
      }
      
      private function checkResult(e:EventTaomee) : void
      {
         var obj:Object = null;
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.checkResult);
         if(e.EventObj.obj.flag <= 11)
         {
            obj = new Object();
            obj.flag = 11;
            JobExpandLogic.getJobExpand().setOneJob(300,obj);
            this.target_mc.lamuNPC_btn.addEventListener(MouseEvent.CLICK,this.lamuHandler);
            this.top_mc.light.x = 376;
            this.top_mc.light.y = 253;
         }
         else
         {
            this.hasLamu = true;
            this.target_mc.lamuNPC_btn.visible = false;
            toolView.setToolBtns(0,0,0,0,0,0,1,0,0,0);
            this.top_mc.light.x = 720;
            this.top_mc.light.y = 505;
         }
         this.npc = NPC.getNPCInstance(1002,true);
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.setNpc);
      }
      
      private function lamuHandler(e:MouseEvent) : void
      {
         this.top_mc.panel.y = 80;
         this.top_mc.panel.btn.addEventListener(MouseEvent.CLICK,this.getLamuHandler);
         this.target_mc.lamuNPC_btn.mouseEnabled = false;
         this.target_mc.lamuNPC_btn.visible = false;
         this.top_mc.light.play();
         this.top_mc.light.x = 485;
         this.top_mc.light.y = 346;
      }
      
      private function getLamuHandler(e:MouseEvent) : void
      {
         this.top_mc.panel.y = -600;
         this.top_mc.panel.btn.removeEventListener(MouseEvent.CLICK,this.getLamuHandler);
         this.target_mc.lamuNPC_btn.mouseEnabled = false;
         this.target_mc.lamuNPC_btn.visible = false;
         PetAskReq.askOnePet();
         var url:String = "resource/pet/icon/170003.swf";
         var msg:String = "    粉紅色拉姆種子已經放入你的小屋，記得稍後回家看看哦！";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         toolView.setToolBtns(0,0,0,0,0,0,1,0,0,0);
         var obj:Object = new Object();
         obj.flag = 12;
         JobExpandLogic.getJobExpand().setOneJob(300,obj);
         this.top_mc.light.x = 720;
         this.top_mc.light.y = 505;
      }
      
      private function setNpc(e:NPCEvent) : void
      {
         BC.removeEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.setNpc);
         if(this.hasLamu)
         {
         }
         if(e.npc.npcInfo.id == 1002)
         {
            this.npc = e.npc;
            this.npc.x = 460;
            this.npc.y = 300;
            this.npc.autoMove = false;
         }
      }
      
      override public function destroy() : void
      {
         if(TaskManager.getTask(569).state != 1)
         {
            MainManager.getRootMC().removeChild(this.top_mc.light);
         }
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.effect_mc = null;
         this.top_mc = null;
         super.destroy();
      }
   }
}

