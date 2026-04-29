package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.MapManageLogic.MapModelLogic;
   import com.logic.NPCJobLogic.NPCJobLogic;
   import com.logic.socket.NPCJob.GetNPCJobDataSocket;
   import com.module.activityModule.Presented;
   import com.module.deal.Deal;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.NPCEvent;
   import com.module.query.QueryImpl;
   import com.module.sendBirthdayCard.ChargeGiveThing;
   import com.mole.app.map.MapBase;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class BrotherView extends MapBase
   {
      
      private var itemBool:Boolean = false;
      
      private var davieBool:Boolean = false;
      
      private var gotoBool:Boolean = false;
      
      public function BrotherView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.initNPC();
         controlLevel.flower_mc.visible = false;
         BC.addEvent(this,controlLevel.itemBtn,MouseEvent.CLICK,this.itemEvent);
         BC.addEvent(this,controlLevel.work_btn,MouseEvent.CLICK,this.showTipsHandler);
         BC.addEvent(this,controlLevel.pic_btn_test,MouseEvent.CLICK,this.DvTipsHandler);
         BC.addEvent(this,controlLevel.btn_c_,MouseEvent.CLICK,this.clickC_Handler);
         BC.addEvent(this,controlLevel.book_btn,MouseEvent.CLICK,this.book_btnHandler);
         this.taskDavid();
         BC.addEvent(this,GV.onlineSocket,"GET_JOB_DATA",this.get_jobHandler);
         GetNPCJobDataSocket.getJobData(9);
      }
      
      private function get_jobHandler(E:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"GET_JOB_DATA",this.get_jobHandler);
         var jobid:int = int(E.EventObj.jobID);
         if(E.EventObj.flag == 0)
         {
            QueryImpl.getInstance().QueryItem([190581],this.initMasonFlower);
         }
      }
      
      private function initMasonFlower(arr:Array) : void
      {
         if(!arr[0].count)
         {
            controlLevel.flower_mc.visible = true;
            BC.addEvent(this,controlLevel.flower_mc,MouseEvent.CLICK,this.getFlower);
         }
      }
      
      private function getFlower(E:MouseEvent) : void
      {
         Deal.BuyItem(190581,1,function(E:*):void
         {
            Alert.getIconByID_Alart(190581,"    恭喜你！你得到了" + GoodsInfo.getItemNameByID(190581) + ",已經放到百寶箱了!");
            controlLevel.flower_mc.gotoAndStop(2);
         });
      }
      
      private function book_btnHandler(event:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/besmearBook/betaBook.swf","正在打開梅森日記",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function clickC_Handler(evt:MouseEvent) : void
      {
         if(depthLevel.c_mc_.currentFrame == 1)
         {
            depthLevel.c_mc_.gotoAndStop(2);
         }
         else
         {
            depthLevel.c_mc_.gotoAndStop(1);
         }
         if(controlLevel.lamder_mc.currentFrame == 1)
         {
            controlLevel.lamder_mc.gotoAndPlay(2);
            setTimeout(this.newMap,1000);
         }
      }
      
      private function newMap() : void
      {
         moveLevel.mc.parent.removeChild(moveLevel.mc);
         MapModelLogic.owner.makeMapArray(true);
      }
      
      private function taskDavid() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
         BC.addEvent(this,GV.onlineSocket,NPCJobLogic.GET_JOB,this.getTaskInfoBack);
         NPCJobLogic.getNpcJobLogic().getJobData(5);
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         if(this.gotoBool)
         {
            return;
         }
         this.gotoBool = true;
         controlLevel.yiz_btn.gotoAndPlay(2);
         if(this.davieBool)
         {
            controlLevel.yiz_btn.btn190466.visible = true;
         }
      }
      
      private function getTaskInfoBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NPCJobLogic.GET_JOB,this.getTaskInfoBack);
         this.setDavidTaskFun();
      }
      
      private function setDavidTaskFun() : void
      {
         var obj:Object = NPCJobLogic.npcJobList[5];
         if(obj.jobStatus == 1)
         {
            this.davieBool = true;
            BC.addEvent(this,controlLevel.yiz_btn.btn190466,MouseEvent.CLICK,this.btn190466Handler);
         }
      }
      
      private function btn190466Handler(evt:MouseEvent) : void
      {
         controlLevel.yiz_btn.btn190466.visible = false;
         var chargeGiveThing:ChargeGiveThing = new ChargeGiveThing();
         chargeGiveThing.itemID = 190466;
         chargeGiveThing.itemCount = 1;
         chargeGiveThing.msg = "    大衛的發明錘已經放入你的百寶箱中。";
         chargeGiveThing.url = "resource/allJob/icon/190466.swf";
         chargeGiveThing.panle = 0;
         chargeGiveThing.getThing();
      }
      
      private function initNPC() : void
      {
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_ENTER,this.setNPCInfo);
      }
      
      private function setNPCInfo(E:NPCEvent) : void
      {
         var msgArr:Array = null;
         if(Math.random() < 0.4)
         {
            return;
         }
         if(E.npc.npcInfo.en_name == "mason")
         {
            msgArr = ["嘿夥計，歡迎來我家，隨便坐別客氣","家裡有點亂，真不好意思，隨便看看沒關系。","早睡早起身體好！","來新客人啦！想喝點什麼？別拘束哦。","今天我當家，打掃完房間真是滿足。"];
         }
         else if(E.npc.npcInfo.en_name == "david")
         {
            msgArr = ["隨便坐坐，我就不特別招呼你啦。","恩。。。你來啦？好。","梅森！有新客人來啦。人呢？","家裡亂的我都有點不好意思了。"];
         }
         setTimeout(function():void
         {
            E.npc.say(msgArr[int(msgArr.length * Math.random())]);
         },int(Math.random() * 5000) + 500);
      }
      
      private function DvTipsHandler(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("TEST_DV_MC");
      }
      
      private function showTipsHandler(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("WORK_MC");
      }
      
      private function itemEvent(evt:MouseEvent) : void
      {
         if(this.itemBool)
         {
            return;
         }
         controlLevel.itemBtn.gotoAndPlay(2);
         Presented.getInstance().FreeReceive(64);
         this.itemBool = true;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

