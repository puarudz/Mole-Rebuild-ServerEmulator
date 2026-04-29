package com.view.mapView
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.npc.I_NPC;
   import com.module.npc.npcInstance.GhostNPC;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseAlbumJob;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class ElderRoomView extends MapBase
   {
      
      private var watchTime:Timer = new Timer(10);
      
      private var currentTime:Date;
      
      private var aTextBool:Boolean = false;
      
      private var bTextBool:Boolean = false;
      
      private var joinObj:Object;
      
      private var t:I_NPC;
      
      private var intTotal:int = 0;
      
      public function ElderRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.Watches();
         this.fetFlowerEvent();
         this.momoBirthday();
      }
      
      private function fetFlowerEvent() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            controlLevel["flower_btn" + i].btn.buttonMode = true;
            controlLevel["flower_btn" + i].btn.addEventListener(MouseEvent.CLICK,this.clickBtnHandler);
         }
         for(var j:int = 5; j < 8; j++)
         {
            controlLevel["flower_btn" + j].addEventListener(MouseEvent.CLICK,this.clickflowerHandler);
         }
      }
      
      private function clickflowerHandler(evt:MouseEvent) : void
      {
         var num:int = int(String(evt.currentTarget.name.substr(-1)));
         if(depthLevel["flower_mc" + num].currentFrame == 1)
         {
            depthLevel["flower_mc" + num].gotoAndPlay(2);
         }
         else if(depthLevel["flower_mc" + num].currentFrame != 1 && depthLevel["flower_mc" + num].currentFrame != depthLevel["flower_mc" + num].totalFrames)
         {
            depthLevel["flower_mc" + num].nextFrame();
         }
      }
      
      private function clickBtnHandler(evt:MouseEvent) : void
      {
         if(evt.currentTarget.currentFrame == 1)
         {
            evt.currentTarget.gotoAndPlay(2);
         }
         else if(evt.currentTarget.currentFrame != 1 && evt.currentTarget.currentFrame != evt.currentTarget.totalFrames)
         {
            evt.currentTarget.nextFrame();
         }
      }
      
      private function momoBirthday() : void
      {
         if(TaskManager.getTaskState(89) == 1)
         {
            BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),BaseAlbumJob.PHOTO_6,2);
         }
         this.showCorpse(141,359);
         BC.addEvent(this,controlLevel.btn1,MouseEvent.CLICK,this.btn1Handler);
         BC.addEvent(this,controlLevel.btn2,MouseEvent.CLICK,this.btn2Handler);
         BC.addEvent(this,controlLevel.btn3,MouseEvent.CLICK,this.btn3Handler);
      }
      
      private function showCorpse(hx:int, hy:int) : void
      {
         this.t = new GhostNPC("chevalier");
         var chevalier:DisplayObjectContainer = this.t as DisplayObjectContainer;
         chevalier.name = "chevalier";
         GV.MC_Depth.addChild(chevalier);
         this.t.x = hx;
         this.t.y = hy;
         this.t.setMovingRange(GV.MC_mapFrame["depth_mc"].range_mc);
         this.t.autoMove = true;
         this.t.Speed = 80;
         var task1001:Task = TaskManager.getTask(1001);
         if(Boolean(task1001) && Boolean(task1001.state == TaskStateType.OPEN) && task1001.buffer.step == 1)
         {
            chevalier.visible = false;
         }
      }
      
      private function btn1Handler(evt:MouseEvent) : void
      {
         this.t.autoMove = false;
         this.t.MoveTo(298,320);
         this.t.say("這是麼麼公主的祖父的畫像！偉大的老摩爾王。");
         setTimeout(this.sayOvenEvent,6000);
      }
      
      private function btn2Handler(evt:MouseEvent) : void
      {
         this.t.autoMove = false;
         this.t.MoveTo(489,320);
         this.t.say("這是麼麼公主的父親 —— 摩爾王八世的畫像。他在麼麼公主出生不久就過世了。");
         setTimeout(this.sayOvenEvent,6000);
      }
      
      private function btn3Handler(evt:MouseEvent) : void
      {
         this.t.autoMove = false;
         this.t.MoveTo(354,320);
         this.t.say("唉，皇冠竟然和黑龍一起被封印到了地下城中，這都是我的失職呀。");
         setTimeout(this.sayOvenEvent,6000);
      }
      
      private function sayOvenEvent() : void
      {
         this.t.MoveTo(141,359);
         this.t.autoMove = true;
      }
      
      private function getItemCountLogic(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         if(evt.EventObj.obj.Count == 0)
         {
            controlLevel.chevalier0.visible = true;
            controlLevel.chevalier1.visible = true;
            controlLevel.say_btn.visible = true;
            BC.addEvent(this,controlLevel.say_btn,MouseEvent.CLICK,this.chevalier0Handler);
         }
      }
      
      private function chevalier0Handler(evt:MouseEvent) : void
      {
         ++this.intTotal;
         if(this.intTotal == 1)
         {
            controlLevel.chevalier0.gotoAndPlay(2);
         }
         else if(this.intTotal == 2)
         {
            controlLevel.chevalier1.gotoAndPlay(2);
         }
         else if(this.intTotal == 3)
         {
            controlLevel.chevalier0.gotoAndPlay("flag2");
         }
         else if(this.intTotal == 4)
         {
            controlLevel.chevalier1.gotoAndPlay("flag2");
         }
      }
      
      private function Watches() : void
      {
         controlLevel.watche.hour_mc.visible = true;
         controlLevel.watche.minut_mc.visible = true;
         this.watchTime.addEventListener(TimerEvent.TIMER,this.onTick);
         this.watchTime.start();
      }
      
      private function onTick(evt:TimerEvent) : void
      {
         this.currentTime = new Date();
         var minutes:uint = this.currentTime.getMinutes();
         var hours:uint = this.currentTime.getHours();
         controlLevel.watche.minut_mc.rotation = minutes * 6;
         controlLevel.watche.hour_mc.rotation = hours % 12 * 30;
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.watchTime))
         {
            this.watchTime.removeEventListener(TimerEvent.TIMER,this.onTick);
            this.watchTime.stop();
         }
         super.destroy();
      }
   }
}

