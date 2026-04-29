package com.module.lahmClassRoom
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.I_NPC;
   
   public class lahmClassRoomEvent
   {
      
      private static var instance:lahmClassRoomEvent;
      
      private static var canotNew:Boolean = true;
      
      private var npcMc:I_NPC;
      
      public function lahmClassRoomEvent()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomEvent不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomEvent
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomEvent();
            canotNew = true;
         }
         return instance;
      }
      
      public function checkEvent(obj:Object) : void
      {
         var loadGame:LoadGame = null;
         BC.addEvent(this,GV.onlineSocket,"readyTest",this.onReadyTest);
         if(obj.eventid == 1)
         {
            loadGame = new LoadGame("module/external/ReadyTest1.swf","正在加載考試面板",MainManager.getGameLevel());
            loadGame = null;
         }
         else if(obj.eventid == 2)
         {
            loadGame = new LoadGame("module/external/ReadyTest2.swf","正在加載考試面板",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            loadGame = new LoadGame("module/external/ReadyTest3.swf","正在加載考試面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      private function onReadyTest(evt:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         BC.removeEvent(this,GV.onlineSocket,"readyTest",this.onReadyTest);
         if(evt.EventObj.flag == 0)
         {
            lahmClassRoomUI.getInstance().initMsgPanel();
         }
         else if(evt.EventObj.flag == 1)
         {
            loadGame = new LoadGame("module/external/SelectCoutseMain.swf","正在加載選課面板",MainManager.getGameLevel());
            loadGame = null;
         }
      }
      
      public function queryClassState() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_1296",this.onQueryClassState);
         lahmClassRoomSocket.queryClassState();
      }
      
      private function onQueryClassState(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1296",this.onQueryClassState);
         lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().classRoomFlag = evt.EventObj.classFlag;
         if(evt.EventObj.classFlag == 5)
         {
            lahmClassRoomStudent.getInstance().clearLahmMovie();
            lahmClassRoomStudent.getInstance().clearLahmName();
            lahmClassRoomStudentChat.getInstance().clearChatTimer();
            lahmClassRoomState.getInstance().clearTestTimer();
            lahmClassRoomState.getInstance().clearCourseTimer();
            new lahmClassRoomTool().clearBeenAllStudentData();
            this.showPuti();
         }
         else
         {
            lahmClassRoomUI.getInstance().initMsgPanel();
            lahmClassRoomUI.getInstance().initFunBtn();
            lahmClassRoomStudent.getInstance().setupUnClassLahmMovie();
         }
      }
      
      public function showPuti() : void
      {
      }
      
      public function openGraduationList() : void
      {
         this.npcMc.clearClass();
         var loadGame:LoadGame = new LoadGame("module/external/openGraduationListMain.swf","正在加載畢業冊面板",MainManager.getGameLevel());
         loadGame = null;
      }
   }
}

