package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.activityModule.checkItem;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.mole.manager.DialogManager;
   import flash.events.Event;
   
   public class TrainingForestView extends MapBase
   {
      
      private static const EARTH_SPIRIT_CRYSTALS:uint = 191079;
      
      public static var explain:String = "你沒有任何騎士卡牌無法開始對戰，馬上去石桌上領取騎士卡牌冊吧！";
      
      public static var url:String = "module/gameUI/icon/002.swf";
      
      public static var isGetBook:Boolean = false;
      
      public function TrainingForestView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.itemIDFun();
         BC.addEvent(this,GV.onlineSocket,"OPEN_QISHI_MC",this.openMcFun);
         this.checkGoods();
         SystemEventManager.addEventListener("turinPet_queryTrainResult",this.onOpenQuery);
         SystemEventManager.addEventListener("turinPet_openRuleUI",this.onOpenRuleUI);
         SystemEventManager.addEventListener("turingTaskOven",this.onTask153Over);
         SystemEventManager.addEventListener("hopeKnight",this.onHopeKnight);
         SystemEventManager.addEventListener("selectSay",this.hSelectSay);
         SystemEventManager.addEventListener("letterTaskOver",this.hLetterTaskOver);
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 229)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function hSelectSay(e:SystemEvent) : void
      {
         var num:int = 0;
         if(!ActivityTmpDataManager.curTaskId)
         {
            num = int(Math.random() * 100);
            ActivityTmpDataManager.currentMap = num > 50 ? 392 : 393;
            MapManager.enterMap(ActivityTmpDataManager.currentMap);
         }
         else if(ActivityTmpDataManager.curTaskId != 2)
         {
            MapManager.enterMap(ActivityTmpDataManager.currentMap);
         }
         else
         {
            mapSay(100);
         }
      }
      
      private function hLetterTaskOver(e:SystemEvent) : void
      {
         superlamuPartySocket.treasurebowl(229);
         ActivityTmpDataManager.curTaskId = 0;
      }
      
      private function onHopeKnight(evt:Event) : void
      {
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),EARTH_SPIRIT_CRYSTALS,2,EARTH_SPIRIT_CRYSTALS + 1);
      }
      
      private function getItemCountBk(evt:EventTaomee) : void
      {
         var itemObj:Object = null;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBk);
         var itemArr:Array = evt.EventObj.obj.arr;
         for each(itemObj in itemArr)
         {
            if(EARTH_SPIRIT_CRYSTALS == itemObj.ID)
            {
               if(itemObj.Count >= 1)
               {
                  mapSay(18);
                  ActivityTmpDataManager.getTransferItem(9);
                  return;
               }
            }
         }
         mapSay(19);
      }
      
      private function onOpenQuery(e:SystemEvent) : void
      {
         new LoadGame("module/external/queryTrainResultMain.swf","正在加載查詢訓練成績",MainManager.getGameLevel());
      }
      
      private function onOpenRuleUI(e:SystemEvent) : void
      {
         new LoadGame("module/external/ruleUI.swf","正在加載森林騎士訓練規則",MainManager.getGameLevel());
      }
      
      private function itemIDFun() : void
      {
         var strTeamName:String = null;
         var isOver:Boolean = Boolean(GV.JobLogics.chartbagFun(13476));
         var task153State:uint = TaskManager.getTaskState(153);
         if((Boolean(isOver) || Boolean(GV.JobLogics.chartbagClothFun([[13476]]))) && task153State != 2)
         {
            strTeamName = "我戰勝你啦";
         }
         else
         {
            strTeamName = "挑戰土林長老";
         }
         DialogManager.addMatch("turin",strTeamName);
         BC.addEvent(this,GV.onlineSocket,"read_" + 2008,this.itemIDHandler);
         NpcBallotSocket.NpcBallotReq();
         if((Boolean(isOver) || Boolean(GV.JobLogics.chartbagClothFun([[13476]]))) && task153State != 2)
         {
            mapSay(17);
         }
      }
      
      private function onTask153Over(e:Event) : void
      {
         var task153State:uint = TaskManager.getTaskState(153);
         if(task153State != 2)
         {
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
            TaskOverProtocol.send(153);
         }
      }
      
      private function showOverJob1Alert(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJob1Alert);
         LocalUserInfo.setExp(LocalUserInfo.getExp() + 1000);
         Alert.smileAlart("　　恭喜你正式成為森林騎士團的一員，獎勵你1000點摩爾經驗。");
      }
      
      private function itemIDHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 2008,this.itemIDHandler);
      }
      
      private function checkGoods() : void
      {
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         checkItem.checkItemHandler(160191);
      }
      
      private function chekItemHandler(evt:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         if(evt.EventObj.num == 1)
         {
            isGetBook = true;
         }
      }
      
      private function openMcFun(e:*) : void
      {
         new LoadGame("resource/movie/qishiMC.swf","正在加載預言動畫",MainManager.getAppLevel());
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("selectSay",this.hSelectSay);
         SystemEventManager.removeEventListener("letterTaskOver",this.hLetterTaskOver);
         SystemEventManager.removeEventListener("hopeKnight",this.onHopeKnight);
         SystemEventManager.removeEventListener("turinPet_queryTrainResult",this.onOpenQuery);
         SystemEventManager.removeEventListener("turinPet_openRuleUI",this.onOpenRuleUI);
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.chekItemHandler);
         super.destroy();
      }
   }
}

