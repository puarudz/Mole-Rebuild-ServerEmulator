package com.module.pig
{
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.event.EventTaomee;
   import com.logic.socket.pig.PigSocket;
   import com.mole.app.ui.LoadingPanel;
   import flash.display.MovieClip;
   
   public class MachineNewHand
   {
      
      private static var _instance:MachineNewHand;
      
      public static var Step:int = 1;
      
      private var _gettingData:Boolean = false;
      
      public function MachineNewHand()
      {
         super();
      }
      
      public static function get inst() : MachineNewHand
      {
         if(_instance == null)
         {
            _instance = new MachineNewHand();
         }
         return _instance;
      }
      
      public function openNewHandPanel() : void
      {
         if(!this._gettingData)
         {
            this._gettingData = true;
            BC.addEvent(this,GV.onlineSocket,PigSocket.GET_NEW_STEP,this.getStepOver,false,0,true);
            PigSocket.getNewStep();
         }
      }
      
      private function getStepOver(e:EventTaomee) : void
      {
         this._gettingData = false;
         BC.removeEvent(this,GV.onlineSocket,PigSocket.GET_NEW_STEP,this.getStepOver);
         Step = e.EventObj.step;
         var resID:int = int(DownLoadManager.add("module/pig/machineNewHand.swf",ResType.DISPLAY_OBJECT));
         LoadingPanel.addRes(resID);
         DownLoadManager.addEvent(resID,this.loadNewHandOver);
      }
      
      private function loadNewHandOver(e:DownLoadEvent) : void
      {
         MainManager.getAppLevel().addChild((e.data as MovieClip).getChildAt(0));
      }
   }
}

