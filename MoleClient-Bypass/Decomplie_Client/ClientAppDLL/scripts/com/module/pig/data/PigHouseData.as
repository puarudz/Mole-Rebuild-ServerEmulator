package com.module.pig.data
{
   import com.common.data.HashMap;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.pig.PigSocket;
   import com.module.pig.PigEvent;
   import com.module.pig.PigHouseEntrance;
   import flash.events.Event;
   
   public class PigHouseData
   {
      
      private static var _instance:PigHouseData;
      
      public static var Curr_Friend_Page:int = 1;
      
      public static const EXP_ItemId:int = 14;
      
      private static const MaxCountByLevel:Array = new Array();
      
      MaxCountByLevel[1] = 6;
      MaxCountByLevel[2] = 6;
      MaxCountByLevel[3] = 7;
      MaxCountByLevel[4] = 7;
      MaxCountByLevel[5] = 8;
      MaxCountByLevel[6] = 8;
      MaxCountByLevel[7] = 9;
      MaxCountByLevel[8] = 9;
      MaxCountByLevel[9] = 9;
      MaxCountByLevel[10] = 12;
      MaxCountByLevel[11] = 12;
      MaxCountByLevel[12] = 12;
      MaxCountByLevel[13] = 13;
      MaxCountByLevel[14] = 13;
      MaxCountByLevel[15] = 13;
      MaxCountByLevel[16] = 14;
      MaxCountByLevel[17] = 14;
      MaxCountByLevel[18] = 14;
      MaxCountByLevel[19] = 14;
      MaxCountByLevel[20] = 16;
      MaxCountByLevel[21] = 16;
      MaxCountByLevel[22] = 16;
      MaxCountByLevel[23] = 16;
      MaxCountByLevel[24] = 16;
      MaxCountByLevel[25] = 17;
      MaxCountByLevel[26] = 17;
      MaxCountByLevel[27] = 17;
      MaxCountByLevel[28] = 17;
      MaxCountByLevel[29] = 17;
      MaxCountByLevel[30] = 20;
      MaxCountByLevel[31] = 20;
      MaxCountByLevel[32] = 20;
      MaxCountByLevel[33] = 20;
      MaxCountByLevel[34] = 20;
      MaxCountByLevel[35] = 22;
      MaxCountByLevel[36] = 22;
      MaxCountByLevel[37] = 22;
      MaxCountByLevel[38] = 24;
      MaxCountByLevel[39] = 24;
      MaxCountByLevel[40] = 24;
      MaxCountByLevel[41] = 24;
      MaxCountByLevel[42] = 24;
      MaxCountByLevel[43] = 24;
      MaxCountByLevel[44] = 24;
      MaxCountByLevel[45] = 24;
      MaxCountByLevel[46] = 24;
      MaxCountByLevel[47] = 24;
      MaxCountByLevel[48] = 24;
      MaxCountByLevel[49] = 24;
      MaxCountByLevel[50] = 24;
      
      private var _data:HashMap;
      
      public function PigHouseData()
      {
         super();
         this._data = new HashMap();
         BC.addEvent(this,PigEvent.instance,PigEvent.Make_Goods_Over,this.PigEventHandler);
         BC.addEvent(this,PigEvent.instance,PigEvent.Sell_Pig_Over,this.PigEventHandler);
         BC.addEvent(this,PigEvent.instance,PigEvent.Breed_Pig_Over,this.PigEventHandler);
      }
      
      public static function get instance() : PigHouseData
      {
         if(_instance == null)
         {
            _instance = new PigHouseData();
         }
         return _instance;
      }
      
      private function UpdateLvlHandler(e:EventTaomee) : void
      {
         this.GetPigHouseData();
      }
      
      public function GetPigHouseData(e:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + PigSocket.GetPigHouseInfoCmd,this.GetPigHouseDataHandler);
         PigSocket.GetPigHouseInfo(PigHouseEntrance.instance.userId);
      }
      
      private function PigEventHandler(e:EventTaomee) : void
      {
         if(Boolean(e.EventObj.gold))
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + e.EventObj.gold);
         }
         this.GetPigHouseData();
      }
      
      private function GetPigHouseDataHandler(e:EventTaomee) : void
      {
         var data:HashMap = e.EventObj as HashMap;
         this._data = data;
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Get_PigHouse_Data_OK));
      }
      
      public function get isFristIn() : Boolean
      {
         return Boolean(this._data.getValue("state"));
      }
      
      public function get pigs() : Array
      {
         return this.pigsHashMap.values;
      }
      
      public function get pigsHashMap() : HashMap
      {
         return this._data.getValue("pigs");
      }
      
      public function get level() : int
      {
         return this._data.getValue("level");
      }
      
      public function get bgId() : int
      {
         return this._data.getValue("bgId");
      }
      
      public function get exp() : int
      {
         return this._data.getValue("exp");
      }
      
      public function set exp(value:int) : void
      {
         this._data.add("exp",value);
         PigEvent.instance.dispatchEvent(new Event(PigEvent.Update_Exp));
      }
      
      public function get nextExp() : int
      {
         return this._data.getValue("nextExp");
      }
      
      public function get honor() : int
      {
         return this._data.getValue("honor");
      }
      
      public function get batheTime() : int
      {
         return this._data.getValue("batheTime");
      }
      
      public function get beautyHouseLvl() : int
      {
         return this._data.getValue("beautyHouseLvl");
      }
      
      public function get machineHouseLvl() : int
      {
         return this._data.getValue("machineHouseLvl");
      }
      
      public function get workHouseLvl() : int
      {
         return this._data.getValue("workHouseLvl");
      }
      
      public function get workHouseCnt() : int
      {
         return this._data.getValue("workHouseCnt");
      }
      
      public function get team() : int
      {
         return this._data.getValue("team");
      }
      
      public function get teamMsg() : String
      {
         return this._data.getValue("teamMsg");
      }
      
      public function set teamMsg(value:String) : void
      {
         this._data.add("teamMsg",value);
      }
      
      public function get feedCnt() : int
      {
         return this._data.getValue("feedCnt");
      }
      
      public function get maxPigCount() : int
      {
         return this.GetMaxCount(this.level);
      }
      
      public function GetMaxCount(level:int) : int
      {
         return MaxCountByLevel[level];
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         this._data = null;
         _instance = null;
      }
   }
}

