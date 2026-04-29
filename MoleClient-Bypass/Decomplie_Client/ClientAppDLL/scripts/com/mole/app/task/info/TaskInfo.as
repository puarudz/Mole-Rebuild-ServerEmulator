package com.mole.app.task.info
{
   import com.mole.config.info.Config;
   
   public class TaskInfo
   {
      
      private var _id:uint;
      
      private var _name:String;
      
      private var _parIDList:Array;
      
      private var _isVip:Boolean;
      
      private var _timeState:uint;
      
      private var _detail:String;
      
      private var _lockMsg:String;
      
      private var _awardIDList:Array;
      
      private var _awardDescList:Array;
      
      private var _openLevel:uint;
      
      private var _runningState:uint;
      
      private var _awardMsg:String;
      
      private var _awardBean:int;
      
      private var _goMapID:uint;
      
      private var _goMapType:uint;
      
      private var _off:Boolean;
      
      private var _goods:Array;
      
      private var _goodsMap:Array;
      
      private var _goodsTip:Array;
      
      private var _goodsNum:Array;
      
      private var _noAutoApply:Boolean;
      
      public function TaskInfo()
      {
         super();
      }
      
      public function get lockMsg() : String
      {
         return this._lockMsg;
      }
      
      public function initXML(taskXML:XML) : void
      {
         var parID:String = null;
         var mapList:Array = null;
         this._id = uint(taskXML.@ID);
         this._name = taskXML.@Name;
         this._parIDList = new Array();
         var tmpTaskList:Array = String(taskXML.@ParentID).split(",");
         for each(parID in tmpTaskList)
         {
            if(uint(parID) != 0)
            {
               this._parIDList.push(uint(parID));
            }
         }
         this._isVip = uint(taskXML.@Vip) == 1;
         this._off = uint(taskXML.@Off) == 1;
         this._timeState = uint(taskXML.@TimeState);
         this._detail = taskXML.@Detail;
         this._lockMsg = String(taskXML.@LockMsg);
         this._awardIDList = String(taskXML.@AwardIDList).split(Config.SEPARATOR);
         this._awardDescList = String(taskXML.@AwardDescList).split(Config.SEPARATOR);
         mapList = String(taskXML.@GoMap).split(Config.SEPARATOR);
         this._goMapID = mapList[0];
         this._goMapType = mapList[1];
         this._goods = String(taskXML.@Goods).split(";");
         this._goodsMap = String(taskXML.@GoodsMap).split(";");
         this._goodsTip = String(taskXML.@GoodsTip).split(";");
         this._noAutoApply = uint(taskXML.@NoAutoApply) == 1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get parTaskIDList() : Array
      {
         return this._parIDList;
      }
      
      public function get isVip() : Boolean
      {
         return this._isVip;
      }
      
      public function get timeState() : uint
      {
         return this._timeState;
      }
      
      public function get runningState() : uint
      {
         return this._runningState;
      }
      
      public function set runningState(value:uint) : void
      {
         this._runningState = value;
      }
      
      public function get openLevel() : uint
      {
         return this._openLevel;
      }
      
      public function get awardMsg() : String
      {
         return this._awardMsg;
      }
      
      public function set awardMsg(value:String) : void
      {
         this._awardMsg = value;
      }
      
      public function get awardBean() : int
      {
         return this._awardBean;
      }
      
      public function set awardBean(value:int) : void
      {
         this._awardBean = value;
      }
      
      public function get detail() : String
      {
         return this._detail;
      }
      
      public function get goMapID() : uint
      {
         return this._goMapID;
      }
      
      public function get goMapType() : uint
      {
         return this._goMapType;
      }
      
      public function get awardIDList() : Array
      {
         return this._awardIDList;
      }
      
      public function get awardDescList() : Array
      {
         return this._awardDescList;
      }
      
      public function get off() : Boolean
      {
         return this._off;
      }
      
      public function get goods() : Array
      {
         return this._goods;
      }
      
      public function get goodsMap() : Array
      {
         return this._goodsMap;
      }
      
      public function get goodsTip() : Array
      {
         return this._goodsTip;
      }
      
      public function set goodsNum(arr:Array) : void
      {
         this._goodsNum = arr;
      }
      
      public function get goodsNum() : Array
      {
         return this._goodsNum;
      }
      
      public function get noAutoApply() : Boolean
      {
         return this._noAutoApply;
      }
   }
}

