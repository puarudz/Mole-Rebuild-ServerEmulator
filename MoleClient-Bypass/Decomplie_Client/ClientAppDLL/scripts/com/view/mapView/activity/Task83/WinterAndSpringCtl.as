package com.view.mapView.activity.Task83
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.lamuSport.joinLamuSport;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   
   public class WinterAndSpringCtl
   {
      
      private static var _instance:WinterAndSpringCtl;
      
      public static const PATH:String = "module/external/";
      
      public var gameType:uint = 7;
      
      public var npc:uint;
      
      private var dateType:uint;
      
      private var type:uint;
      
      private var chessNum:uint;
      
      public function WinterAndSpringCtl()
      {
         super();
      }
      
      public static function getInstance() : WinterAndSpringCtl
      {
         if(_instance == null)
         {
            _instance = new WinterAndSpringCtl();
         }
         return _instance;
      }
      
      private function deleteSpecialByID(id:uint) : void
      {
         for(var i:int = 0; i < GV.SpecialArr.length; i++)
         {
            if(GV.SpecialArr[i] == id)
            {
               break;
            }
         }
         GV.SpecialArr.splice(i,1);
      }
      
      public function OpenExplainUI() : void
      {
         ModuleManager.openModule("WinterAndSpringExplainUI",null,PATH);
      }
      
      public function OpenChooseTeamUI() : void
      {
         BC.addEvent(this,GV.onlineSocket,joinLamuSport.GET_CONTION,this.onResSelectTeam);
         joinLamuSport.getContingent();
      }
      
      private function onResSelectTeam(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,joinLamuSport.GET_CONTION,this.onResSelectTeam);
         if(event.EventObj.itemid == 0)
         {
            ModuleManager.openModule("ChooseTeamUI",null,PATH);
         }
         else if(event.EventObj.itemid == 1)
         {
            ModuleManager.openModule("WinterPanel",null,PATH);
         }
         else if(event.EventObj.itemid == 2)
         {
            ModuleManager.openModule("SpringPanel",null,PATH);
         }
      }
      
      public function OpenSixChessGameExplain() : void
      {
         ModuleManager.openModule("SixChessGameExplain",null,PATH);
      }
      
      private function clearMap() : void
      {
         MapManager.clearMap();
         GameframeLogic.stopMousicHandler();
      }
      
      public function OnJoin3X3Game(npc:uint) : void
      {
         this.gameType = 3;
         this.npc = npc;
         this.clearMap();
         this.joinNpcGame();
      }
      
      public function OnJoin5X5Game(npc:uint) : void
      {
         this.gameType = 5;
         this.npc = npc;
         this.clearMap();
         this.joinNpcGame();
      }
      
      public function OnJoin7X7Game(npc:uint) : void
      {
         this.gameType = 7;
         this.npc = npc;
         this.clearMap();
         this.joinNpcGame();
      }
      
      private function joinNpcGame() : void
      {
         var loadGame:LoadGame = new LoadGame("module/game/SixChessGameToNpc.swf","正在加載...",MainManager.getAppLevel());
         loadGame = null;
      }
      
      public function OpenNpcChooseGame(npcID:uint) : void
      {
         ModuleManager.openModule("SixChessNpcChoosePanel",{"npcID":npcID},PATH);
      }
      
      public function CheckGiveAward(team:uint, num:uint) : void
      {
         this.chessNum = num;
         if(team == 1)
         {
            this.dateType = 313424;
            this.type = 1093;
         }
         else if(team == 2)
         {
            this.dateType = 313425;
            this.type = 1094;
         }
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         finishSomethingReq.sendReq(this.dateType);
      }
      
      private function dofinishSomething(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         if(event.EventObj.Type == this.dateType)
         {
            if(event.EventObj.Done < 100)
            {
               if(this.chessNum > 100 - event.EventObj.Done)
               {
                  this.chessNum = 100 - event.EventObj.Done;
               }
               exchange.exchange_goods(this.type,this.chessNum);
            }
         }
      }
   }
}

