package com.module.pig
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.core.music.TopicMusicManager;
   import com.event.EventTaomee;
   import com.module.pig.data.MachinistSquareData;
   import com.module.pig.view.MachinistSquarePigsCtl;
   import com.module.pig.view.MachinistSquareStageView;
   import flash.events.Event;
   
   public class MachinistSquareEntrance
   {
      
      private static var _instance:MachinistSquareEntrance;
      
      private var _isEditing:Boolean = false;
      
      private var _userId:int = 0;
      
      public function MachinistSquareEntrance()
      {
         super();
      }
      
      public static function get instance() : MachinistSquareEntrance
      {
         if(_instance == null)
         {
            _instance = new MachinistSquareEntrance();
         }
         return _instance;
      }
      
      public function get isEditing() : Boolean
      {
         return this._isEditing;
      }
      
      public function set isEditing(value:Boolean) : void
      {
         this._isEditing = value;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function EnterHouse(userId:int) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"removeMapEvent",this.OnRemoveMap);
         this._userId = userId;
         if(this.isInitOk)
         {
            this.EnterUserHouse();
         }
         else
         {
            this.InitUI();
         }
      }
      
      private function OnRemoveMap(event:EventTaomee) : void
      {
         BC.removeEvent(this);
         MachinistSquarePigsCtl.instance.Clear();
         MachinistSquareStageView.instance.Clear();
         MachinistSquareData.instance.Clear();
         TopicMusicManager.instance.stopSound();
         MachineRandomGift.instance.destroy();
         MachinistSquareFurnaceCtl.instance.destroy();
         MachinistSquareJiChuangCtl.instance.destroy();
         LevelManager.mapLevel.mouseChildren = true;
         PigDragCtl.StopDrag();
         _instance = null;
      }
      
      private function InitUI(e:Event = null) : void
      {
         BC.addOnceEvent(this,PigEvent.instance,PigHouseUI.Init_OK_Event,this.InitUISuc);
         PigHouseUI.instance.Init();
      }
      
      private function InitUISuc(event:Event) : void
      {
         this.EnterUserHouse();
      }
      
      private function EnterUserHouse(e:Event = null) : void
      {
         BC.addOnceEvent(this,PigEvent.instance,PigEvent.Get_MachinistSquare_Data_OK,this.GetUserDataOk);
         MachinistSquareData.instance.GetMachinistSquareData();
      }
      
      private function GetUserDataOk(event:Event) : void
      {
         BC.addOnceEvent(this,PigEvent.instance,MachinistSquareStageView.Init_MachinistSquare_Map_Ok_Event,this.MachinistSquareStageInitHandler);
         MachinistSquareStageView.instance.Init();
      }
      
      private function MachinistSquareStageInitHandler(event:Event) : void
      {
         this._isEditing = false;
         PigExtenalCtl.InitMachinistSquareToolBar();
         MachinistSquarePigsCtl.instance.Init();
         MachineRandomGift.instance.Init();
         MachinistSquareFurnaceCtl.instance.Init();
         MachinistSquareJiChuangCtl.instance.Init();
         if(this.isMyHouse)
         {
            if(MachinistSquareData.instance.isFristIn)
            {
               PigExtenalCtl.InitFirstInMachine();
            }
            else
            {
               PigExtenalCtl.addNewHandBtn();
            }
         }
      }
      
      private function get isInitOk() : Boolean
      {
         return PigHouseUI.instance.isInitOK;
      }
      
      public function get isMyHouse() : Boolean
      {
         return this._userId == LocalUserInfo.getUserID();
      }
   }
}

