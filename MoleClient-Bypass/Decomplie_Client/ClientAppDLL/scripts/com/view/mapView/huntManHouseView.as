package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.fiveChess.FiveChessStatusReq;
   import com.logic.socket.fiveChess.FiveChessStatusRes;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class huntManHouseView extends MapBase
   {
      
      public var PetID:uint;
      
      private var isHasSLCloth:Boolean = false;
      
      public function huntManHouseView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
         controlLevel.room_btn.addEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         GV.onlineSocket.addEventListener("petAction_suc",this.switchMapHandler);
         GV.onlineSocket.addEventListener(FiveChessStatusRes.SEACE_STATUS,this.changeMcAction);
         var tempFive:FiveChessStatusReq = new FiveChessStatusReq();
         tempFive.fiveChessStatus();
         BC.addEvent(this,controlLevel.openSMC_Btn,MouseEvent.CLICK,this.openSMCGameHandlr);
         SystemEventManager.addEventListener("OpenPigExchange",this.onOpenPigExchange);
         GV.onlineSocket.addEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.addEventListener("OVERNPCOldJob",this.overTaskTip);
         SystemEventManager.addEventListener("Open3650",this.Open3650);
         SystemEventManager.addEventListener("Open3652",this.Open3652);
         SystemEventManager.addEventListener("Open3653",this.Open3653);
      }
      
      private function Open3650(e:SystemEvent) : void
      {
         var arr:Array = TaskManager.getTask(365).taskInfo.goodsNum;
         if(arr[0] > 0)
         {
            this.mapSay(3651);
            return;
         }
         var loadGame:LoadGame = new LoadGame("module/external/WildAnimalQuiz.swf","正在加載生源面板",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function Open3652(e:SystemEvent) : void
      {
         var arr:Array = TaskManager.getTask(365).taskInfo.goodsNum;
         if(arr[2] > 0)
         {
            this.mapSay(3651);
            return;
         }
         this.openSMCGameHandlr();
      }
      
      private function Open3653(e:SystemEvent) : void
      {
         var arr:Array = TaskManager.getTask(365).taskInfo.goodsNum;
         if(arr[3] > 0)
         {
            this.mapSay(3651);
            return;
         }
         var appModule:AppModuleControl = ModuleManager.openModule("TamePigGame");
         appModule.addEventListener(ModuleEvent.DESTROY,this.onGameDestroy);
      }
      
      private function onGameDestroy(e:ModuleEvent) : void
      {
         var goodsNum_arr:Array = null;
         var appControl:AppModuleControl = e.currentTarget as AppModuleControl;
         appControl.removeEventListener(ModuleEvent.DESTROY,this.onGameDestroy);
         if(e.data != 0)
         {
            goodsNum_arr = TaskManager.getTask(365).taskInfo.goodsNum;
            if(goodsNum_arr == null)
            {
               goodsNum_arr = [0,0,0,0];
            }
            goodsNum_arr[3] = 1;
            TaskManager.getTask(365).taskInfo.goodsNum = goodsNum_arr;
         }
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var i:uint = 0;
         var id:uint = 365;
         var Tasks:Task = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         var arr:Array = Tasks.taskInfo.goodsNum;
         if(arr == null)
         {
            arr = [0,0,0,0];
            Tasks.taskInfo.goodsNum = arr;
         }
         if(State == 1)
         {
            if(arr.indexOf(0) == -1 && arr.length == 4)
            {
               Tasks.checkEnterMap(100000003);
               Tasks.over();
            }
            else if(arr[0] == 0 || arr[2] == 0 || arr[3] == 0)
            {
               this.mapSay(3650);
            }
            else if(arr.indexOf(0) != -1)
            {
               Tasks.checkEnterMap(100000002);
            }
         }
         else if(State == 0)
         {
            Tasks.checkEnterMap(100000001);
         }
         else if(State == 2)
         {
            Tasks.checkEnterMap(100000004);
         }
      }
      
      public function overTaskTip(evt:Event) : void
      {
         var url:String = GoodsInfo.getItemPathByID(12404) + 12404 + ".swf";
         var msg:String = "    恭喜你獲得獵人套裝，已經放入你的背包中！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      private function onOpenPigExchange(e:Event) : void
      {
         new LoadGame("module/external/PigExchange.swf","正在打開面板......",MainManager.getAppLevel());
      }
      
      private function openSMCGameHandlr(evt:MouseEvent = null) : void
      {
         var loadGame:LoadGame = null;
         var de:int = ServerUpTime.getInstance().getMoleHours;
         var task365State:uint = TaskManager.getTaskState(365);
         if(task365State != 0 || de == 13)
         {
            GV.onlineSocket.addEventListener("AddMoleWolrd",this.addMoleWordHanelr);
            loadGame = new LoadGame("module/external/MoleWorldLoader.swf","正在加載...",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            Alert.smileAlart("    你還不是SMC小獵人無法進行肥肥抓捕，13:00—14:00會對全員開放，記得要來哦！");
         }
      }
      
      private function roomOverHandler(evt:MouseEvent) : void
      {
         depthLevel.room_btn.gotoAndStop(2);
      }
      
      private function roomOutHandler(evt:MouseEvent) : void
      {
         depthLevel.room_btn.gotoAndStop(1);
      }
      
      private function changeMcAction(evt:EventTaomee) : void
      {
         var itemID:* = undefined;
         var frameNum:* = undefined;
         for(var i:int = 0; i < evt.EventObj.senceArr.length; i++)
         {
            itemID = evt.EventObj.senceArr[i].Itemid;
            frameNum = evt.EventObj.senceArr[i].started;
            depthLevel["chessboard_" + itemID].gotoAndStop(Number(frameNum) + 1);
         }
      }
      
      private function switchMapHandler(evt:Event) : void
      {
         var arr:Array = [26,32,9];
         var tempNum:int = Math.floor(Math.random() * 3);
         MapManager.enterMap(arr[tempNum]);
      }
      
      private function addMoleWordHanelr(e:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         GV.onlineSocket.removeEventListener("AddMoleWolrd",this.addMoleWordHanelr);
         if(e.EventObj == 4)
         {
            loadGame = new LoadGame("module/external/PigExchange.swf","正在加載...",MainManager.getAppLevel());
            loadGame = null;
         }
         else if(e.EventObj > 0)
         {
            GV.onlineSocket.addEventListener("MOLE_WORLD_OVER",this.moleWordHanelr);
         }
      }
      
      private function moleWordHanelr(evt:EventTaomee) : void
      {
         var goodsNum_arr:Array = null;
         GV.onlineSocket.removeEventListener("MOLE_WORLD_OVER",this.moleWordHanelr);
         GV["map_ManagerChange"].refreshMap();
         if(evt.EventObj.level > 0)
         {
            goodsNum_arr = TaskManager.getTask(365).taskInfo.goodsNum;
            if(goodsNum_arr == null)
            {
               goodsNum_arr = [0,0,0,0];
            }
            goodsNum_arr[2] = 1;
            TaskManager.getTask(365).taskInfo.goodsNum = goodsNum_arr;
         }
         if(evt.EventObj.pig > 0)
         {
            GV.onlineSocket.addEventListener(exchange.EXCHANGE_ITEM,this.exchangeBack);
            exchange.exchange_goods(721,evt.EventObj.pig);
         }
      }
      
      private function exchangeBack(evt:EventTaomee) : void
      {
         if(evt.EventObj.arr[0].itemID == 190890)
         {
            GV.onlineSocket.removeEventListener(exchange.EXCHANGE_ITEM,this.exchangeBack);
            Alert.getIconByID_Alart(evt.EventObj.arr[0].itemID,"恭喜你獲得" + evt.EventObj.arr[0].count + "個豬豬幣，去獵人M那兌換肥肥吧，每天只能獲得300個哦！");
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("Open3650",this.Open3650);
         SystemEventManager.removeEventListener("Open3652",this.Open3652);
         SystemEventManager.removeEventListener("Open3653",this.Open3653);
         SystemEventManager.removeEventListener("OpenPigExchange",this.onOpenPigExchange);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.roomOverHandler);
         controlLevel.room_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.roomOutHandler);
         GV.onlineSocket.removeEventListener(FiveChessStatusRes.SEACE_STATUS,this.changeMcAction);
         GV.onlineSocket.removeEventListener("petAction_suc",this.switchMapHandler);
         GV.onlineSocket.removeEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.removeEventListener("OVERNPCOldJob",this.overTaskTip);
         super.destroy();
      }
   }
}

