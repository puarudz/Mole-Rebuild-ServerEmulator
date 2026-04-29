package com.view.JobView.ChildMapJob
{
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.giveMeMoney.giveMeMoneyRes;
   import com.module.activityModule.checkItem;
   import com.mole.app.task.TaskManager;
   import com.view.JobView.ChildNPCModule.ChildNpc.ShieldNpc;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class JobMap64View
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var button_mc:MovieClip;
      
      private var buy_id:Array;
      
      private var buy_type:uint = 0;
      
      private var job_flag:uint = 0;
      
      private var buyItem:giveMeMoneyReq;
      
      private var Job_mc:MovieClip;
      
      private var job_timer:Timer;
      
      public function JobMap64View()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function checkItemF() : void
      {
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerB);
         checkItem.checkItemHandler(12638);
      }
      
      private function itemSucHandlerB(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerB);
         if(evt.EventObj.num != 0)
         {
            this.job_flag = 1;
         }
         BC.addEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerC);
         checkItem.checkItemHandler(12636);
      }
      
      private function itemSucHandlerC(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,checkItem.chekItem_suc,this.itemSucHandlerC);
         if(evt.EventObj.num != 0)
         {
            this.job_flag = 1;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("check_item_ok"));
      }
      
      public function init() : void
      {
         this.target_mc.job_box.alpha = 1;
         this.target_mc.job_body.alpha = 1;
         this.target_mc.job_box.visible = false;
         this.button_mc.job_box_btn.visible = false;
         var task152State:uint = TaskManager.getTaskState(152);
         if(task152State == 0)
         {
            this.getNPCJobObj();
            BC.addEvent(this,GV.onlineSocket,"petAction_suc_over",this.selectOverGame);
            return;
         }
         if(task152State == 1)
         {
            this.getNPCJobObj();
            GV.onlineSocket.dispatchEvent(new EventTaomee("show_game_btn"));
            BC.addEvent(this,GV.onlineSocket,"petAction_suc_over",this.selectOverGame);
            return;
         }
         if(this.job_flag == 0)
         {
            this.selectOverGame();
            return;
         }
         this.button_mc.npc_mc.visible = false;
         this.target_mc.job_body.visible = true;
         this.target_mc.job_box.visible = false;
         this.button_mc.job_box_btn.visible = false;
         GV.onlineSocket.dispatchEvent(new EventTaomee("show_game_btn"));
      }
      
      private function selectOverGame(eve:EventTaomee = null) : void
      {
         this.button_mc.npc_mc.visible = false;
         this.target_mc.job_body.gotoAndPlay(2);
         this.job_timer = GC.setGTimeout(this.showBoxFun,9000);
      }
      
      private function showBoxFun() : void
      {
         this.target_mc.job_body.visible = false;
         GC.clearGTimeout(this.job_timer);
         this.target_mc.job_box.visible = true;
         this.button_mc.job_box_btn.visible = true;
         this.target_mc.job_box.gotoAndStop(1);
         BC.addEvent(this,this.button_mc.job_box_btn,MouseEvent.CLICK,this.openBox);
      }
      
      private function openBox(eve:MouseEvent) : void
      {
         this.target_mc.job_box.gotoAndStop(2);
         this.AddUI();
      }
      
      private function AddUI() : void
      {
         var tempMC:MCLoader = null;
         if(Boolean(MainManager.getAppLevel().getChildByName("job_152_mc")))
         {
            return;
         }
         var mapMC:MovieClip = new MovieClip();
         mapMC.name = "job_152_mc";
         MainManager.getAppLevel().addChild(mapMC);
         tempMC = new MCLoader("module/external/JobUI/JobMap152.swf",mapMC,Loading.TITLE_AND_PERCENT,"加載遊戲");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler);
         tempMC.doLoad();
      }
      
      public function loadMapOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = 0;
         mainMC.y = 0;
         this.setAddMC(childMC.content.root);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadMapOverHandler);
         mcloader.clear();
      }
      
      private function setAddMC(MC:*) : void
      {
         this.Job_mc = MC;
         BC.addEvent(this,MC.MC.close_btn,MouseEvent.CLICK,this.closeBox);
         BC.addEvent(this,MC.MC.enter_btn,MouseEvent.CLICK,this.buyOne);
         BC.addEvent(this,MC.MC.btn_1,MouseEvent.CLICK,this.makebuyID);
         BC.addEvent(this,MC.MC.btn_2,MouseEvent.CLICK,this.makebuyID);
         BC.addEvent(this,MC.MC.btn_1,MouseEvent.MOUSE_OVER,this.armorMouseOverHandler);
         BC.addEvent(this,MC.MC.btn_2,MouseEvent.MOUSE_OVER,this.armorMouseOverHandler);
         BC.addEvent(this,MC.MC.btn_1,MouseEvent.MOUSE_OUT,this.armorMouseOutHandler);
         BC.addEvent(this,MC.MC.btn_2,MouseEvent.MOUSE_OUT,this.armorMouseOutHandler);
      }
      
      private function closeBox(eve:MouseEvent = null) : void
      {
         var mcs:* = undefined;
         BC.removeEvent(this,this.Job_mc.MC.close_btn,MouseEvent.CLICK,this.closeBox);
         BC.removeEvent(this,this.Job_mc.MC.enter_btn,MouseEvent.CLICK,this.buyOne);
         BC.removeEvent(this,this.Job_mc.MC.btn_1,MouseEvent.CLICK,this.makebuyID);
         BC.removeEvent(this,this.Job_mc.MC.btn_2,MouseEvent.CLICK,this.makebuyID);
         BC.removeEvent(this,this.Job_mc.MC.btn_1,MouseEvent.MOUSE_OVER,this.armorMouseOverHandler);
         BC.removeEvent(this,this.Job_mc.MC.btn_2,MouseEvent.MOUSE_OVER,this.armorMouseOverHandler);
         BC.removeEvent(this,this.Job_mc.MC.btn_1,MouseEvent.MOUSE_OUT,this.armorMouseOutHandler);
         BC.removeEvent(this,this.Job_mc.MC.btn_2,MouseEvent.MOUSE_OUT,this.armorMouseOutHandler);
         this.target_mc.job_box.gotoAndStop(1);
         if(Boolean(MainManager.getAppLevel().getChildByName("job_152_mc")))
         {
            mcs = MainManager.getAppLevel().getChildByName("job_152_mc");
            MainManager.getAppLevel().removeChild(mcs);
            mcs = null;
         }
      }
      
      private function buyOne(eve:MouseEvent) : void
      {
         this.closeBox();
         this.target_mc.job_box.gotoAndStop(1);
         if(this.buy_id == null)
         {
            return;
         }
         this.button_mc.job_box_btn.visible = false;
         BC.removeEvent(this,this.button_mc.job_box_btn,MouseEvent.CLICK,this.openBox);
         BC.addEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.getJokulAction);
         this.buyItem = new giveMeMoneyReq([],[{
            "kind":this.buy_id[0],
            "num":1
         },{
            "kind":this.buy_id[1],
            "num":1
         }]);
      }
      
      private function getJokulAction(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,giveMeMoneyRes.SERVER_GIVEMONEY,this.getJokulAction);
         var url:String = "resource/allJob/AlertPic/shield/152_0" + this.buy_type + ".swf";
         var msg:String = "恭喜！你獲得了勛章騎士套裝，現在你已經成為一名優秀的勛章騎士了";
         GF.showAlert(GV.MC_AppLever,url,msg,100,"iknow",true,false,"SMCUI");
      }
      
      private function armorMouseOverHandler(eve:MouseEvent) : void
      {
         var ss:String = eve.target.name;
         if(ss == "btn_1")
         {
            this.Job_mc.MC.armor_m.armor.gotoAndStop(2);
         }
         else
         {
            this.Job_mc.MC.armor_f.armor.gotoAndStop(2);
         }
      }
      
      private function armorMouseOutHandler(eve:MouseEvent) : void
      {
         var ss:String = eve.target.name;
         if(ss == "btn_1")
         {
            if(this.buy_type == 2)
            {
               return;
            }
            this.Job_mc.MC.armor_m.armor.gotoAndStop(1);
         }
         else
         {
            if(this.buy_type == 3)
            {
               return;
            }
            this.Job_mc.MC.armor_f.armor.gotoAndStop(1);
         }
      }
      
      private function makebuyID(eve:MouseEvent) : void
      {
         var ss:String = eve.target.name;
         if(ss == "btn_1")
         {
            this.Job_mc.MC.armor_m.armor.gotoAndStop(2);
            this.Job_mc.MC.armor_f.armor.gotoAndStop(1);
            this.buy_id = [12638,12639];
            this.buy_type = 2;
         }
         else
         {
            this.Job_mc.MC.armor_f.armor.gotoAndStop(2);
            this.Job_mc.MC.armor_m.armor.gotoAndStop(1);
            this.buy_id = [12636,12637];
            this.buy_type = 3;
         }
      }
      
      private function getNPCJobObj() : void
      {
         var npcs:ShieldNpc = new ShieldNpc();
         npcs.setTargetMC(this.button_mc.npc_mc);
      }
      
      private function removeEventHandler(evetn:EventTaomee) : void
      {
         BC.removeEvent(this);
      }
   }
}

