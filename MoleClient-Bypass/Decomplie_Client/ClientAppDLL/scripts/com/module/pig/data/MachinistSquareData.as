package com.module.pig.data
{
   import com.common.data.HashMap;
   import com.event.EventTaomee;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.MachinistSquareEntrance;
   import com.module.pig.PigEvent;
   import com.module.pig.view.pig.MachinistSquarePig;
   import flash.events.Event;
   
   public class MachinistSquareData
   {
      
      private static var _instance:MachinistSquareData;
      
      public static var Curr_Friend_Page:int = 1;
      
      public static var noEnergy:Boolean = false;
      
      private static const MaxCountByLevel:Array = new Array();
      
      MaxCountByLevel[1] = 5;
      MaxCountByLevel[2] = 10;
      MaxCountByLevel[3] = 15;
      
      private var _lockGoods:HashMap;
      
      private var _lockPigs:HashMap;
      
      private var _data:HashMap;
      
      public function MachinistSquareData()
      {
         super();
         this._data = new HashMap();
         this._lockGoods = new HashMap();
         this._lockPigs = new HashMap();
      }
      
      public static function get instance() : MachinistSquareData
      {
         if(_instance == null)
         {
            _instance = new MachinistSquareData();
         }
         return _instance;
      }
      
      public function GetMachinistSquareData(e:Event = null) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_8508",this.getExploreInfoOver);
         PigSocket.SelectCutePigExplorInfo();
      }
      
      private function getExploreInfoOver(event:EventTaomee) : void
      {
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Get_Pig_Info_Over));
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.SelectMachinistSquareInfoCmd,this.GetMachinistSquareDataHandler);
         PigSocket.SelectMachinistSquareInfo(MachinistSquareEntrance.instance.userId);
      }
      
      private function GetMachinistSquareDataHandler(event:EventTaomee) : void
      {
         var data:HashMap = event.EventObj as HashMap;
         this._data = data;
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Get_MachinistSquare_Data_OK));
      }
      
      public function get pigs() : Array
      {
         return this.pigsHashMap.values;
      }
      
      public function get pigsHashMap() : HashMap
      {
         return this._data.getValue("pigs");
      }
      
      public function get pigsCount() : int
      {
         return this._data.getValue("pigsCount");
      }
      
      public function get exp() : int
      {
         return this._data.getValue("exp");
      }
      
      public function get nextExp() : int
      {
         return this._data.getValue("nextExp");
      }
      
      public function get machineSquareLvl() : uint
      {
         return this._data.getValue("machine_lvl");
      }
      
      public function get warhouseLvl() : uint
      {
         return this._data.getValue("warhouse_lvl");
      }
      
      public function isCanAddPig(value:uint) : Boolean
      {
         return this.pigsCount + value <= this.GetMaxCount();
      }
      
      public function get lockGoods() : HashMap
      {
         return this._lockGoods;
      }
      
      public function get lockPigs() : HashMap
      {
         return this._lockPigs;
      }
      
      public function get pigHouseLevel() : uint
      {
         return uint(this._data.getValue("pigHouseLevel"));
      }
      
      public function SetLockPig(pig:MachinistSquarePig) : void
      {
         this._lockPigs.add(pig.pigData.id,pig);
      }
      
      public function UnLockPig(id:uint) : void
      {
         this._lockPigs.remove(id);
      }
      
      public function get isFristIn() : Boolean
      {
         return Boolean(this._data.getValue("state"));
      }
      
      public function GetMaxCount() : int
      {
         return MaxCountByLevel[this.machineSquareLvl];
      }
      
      public function GetMachineInfo(id:uint, type:uint = 1) : HashMap
      {
         var info:HashMap = null;
         var arr:Array = this._data.getValue("machines");
         var len:uint = arr.length;
         for(var i:uint = 0; i < len; i++)
         {
            info = arr[i];
            if(info.getValue("tool_type") == type)
            {
               if(info.getValue("tool_index") == id)
               {
                  return info;
               }
            }
         }
         return null;
      }
      
      public function GetRongluOrJichuangNum(type:uint = 1) : uint
      {
         var info:HashMap = null;
         var num:uint = 0;
         var arr:Array = this._data.getValue("machines");
         var len:uint = arr.length;
         for(var i:uint = 0; i < len; i++)
         {
            info = arr[i];
            if(info.getValue("tool_type") == type)
            {
               num++;
            }
         }
         return num;
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         this._data = null;
         _instance = null;
         noEnergy = false;
      }
   }
}

