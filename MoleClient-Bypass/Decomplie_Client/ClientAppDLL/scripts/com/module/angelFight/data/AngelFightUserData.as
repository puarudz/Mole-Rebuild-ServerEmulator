package com.module.angelFight.data
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.AngelFight.AngelFightExtenalSocket;
   import com.module.angelFight.AngelFightEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class AngelFightUserData extends EventDispatcher
   {
      
      private static var _instance:AngelFightUserData;
      
      public static const Max_Attribute_Value:int = 100;
      
      private var _data:Object;
      
      private var _masterData:Object;
      
      private var _taskData:Object;
      
      private var _wishData:Object = new Object();
      
      public function AngelFightUserData()
      {
         super();
         this._data = new Object();
      }
      
      public static function get instance() : AngelFightUserData
      {
         if(_instance == null)
         {
            _instance = new AngelFightUserData();
         }
         return _instance;
      }
      
      public function GetDiscipleMasterInfo() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.GetDiscipleMasterInfoCmd,this.GetDiscipleMasterInfoHandler);
         AngelFightExtenalSocket.GetDiscipleMasterInfo(LocalUserInfo.getUserID());
      }
      
      public function GetTaskState() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.GetTaskStateCmd,this.GetTaskStateHandler);
         AngelFightExtenalSocket.GetTaskState();
      }
      
      public function GetUserInfo() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.GetUserInfoCmd,this.GetUserInfoHandler);
         AngelFightExtenalSocket.GetUserInfo(LocalUserInfo.getUserID());
      }
      
      public function GetWishState() : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + AngelFightExtenalSocket.GetWishStateCmd,this.GetWishStateHandler);
         AngelFightExtenalSocket.GetWishState();
      }
      
      public function get HP() : int
      {
         return this._data.HP;
      }
      
      public function get pvpCount() : int
      {
         return this._data.pvpCount;
      }
      
      public function get MP() : int
      {
         return this._data.MP;
      }
      
      public function get addPhysiqueValue() : int
      {
         return this._data.addPhysiqueValue;
      }
      
      public function get angels() : Array
      {
         return this._data.angels;
      }
      
      public function get canSendCash() : int
      {
         return this._masterData.canSendCash;
      }
      
      public function get clothId() : int
      {
         return this._data.clothId;
      }
      
      public function get collectValue() : int
      {
         return this._data.collectValue;
      }
      
      public function get disciples() : Array
      {
         return this._masterData.disciples;
      }
      
      public function get energy() : int
      {
         return this._data.energy;
      }
      
      public function get exp() : int
      {
         return this._data.exp;
      }
      
      public function get flexibility() : int
      {
         return this._data.flexibility;
      }
      
      public function get isCanAddAngel() : Boolean
      {
         var canAddMaxCount:int = 5;
         return this.angels.length < canAddMaxCount;
      }
      
      public function get level() : int
      {
         return this._data.level;
      }
      
      public function get masterDiscipleCount() : int
      {
         return this._masterData.masterDiscipleCount;
      }
      
      public function get masterOutDiscipleCount() : int
      {
         return this._masterData.masterOutCount;
      }
      
      public function get outDiscipleCount() : int
      {
         return this._masterData.outCount;
      }
      
      public function get masterId() : int
      {
         return this._masterData.masterId;
      }
      
      public function get masterLevel() : int
      {
         return this._masterData.masterLevel;
      }
      
      public function get masterMerit() : int
      {
         return this._masterData.masterMerit;
      }
      
      public function get addMasterLevel() : int
      {
         return this._masterData.level;
      }
      
      public function get masterInfo() : Object
      {
         return this._masterData;
      }
      
      public function get maxEnergy() : int
      {
         return this._data.maxEnergy;
      }
      
      public function get maxExp() : int
      {
         return this._data.maxExp;
      }
      
      public function get maxVigour() : int
      {
         return this._data.maxVigour;
      }
      
      public function get merit() : int
      {
         return this._masterData.merit;
      }
      
      public function get power() : int
      {
         return this._data.power;
      }
      
      public function get refreshCount() : int
      {
         return this._taskData.refreshCount;
      }
      
      public function get states() : Array
      {
         return this._data.states;
      }
      
      public function get strong() : int
      {
         return this._data.strong;
      }
      
      public function get tasks() : Array
      {
         return this._taskData.arr;
      }
      
      public function get vigour() : int
      {
         return this._data.vigour;
      }
      
      public function get wisdom() : int
      {
         return this._data.wisdom;
      }
      
      public function get wishId() : int
      {
         return this._wishData.id;
      }
      
      public function get wishNeedCount() : int
      {
         return this._wishData.needCount;
      }
      
      private function GetDiscipleMasterInfoHandler(e:EventTaomee) : void
      {
         this._masterData = e.EventObj;
         this.dispatchEvent(new Event(AngelFightEvent.Update_MasterInfo_Ok));
      }
      
      private function GetTaskStateHandler(e:EventTaomee) : void
      {
         this._taskData = e.EventObj;
         this.dispatchEvent(new Event(AngelFightEvent.Update_TaskState_Ok));
      }
      
      private function GetUserInfoHandler(e:EventTaomee) : void
      {
         this._data = e.EventObj;
         this.dispatchEvent(new Event(AngelFightEvent.Update_UserInfo_Ok));
      }
      
      private function GetWishStateHandler(e:EventTaomee) : void
      {
         this._wishData = e.EventObj;
         this.dispatchEvent(new Event(AngelFightEvent.Update_WishState_Ok));
      }
   }
}

