package com.logic.socket.angelPark.valueObj
{
   import com.common.data.goodsInfo.GoodsInfo;
   
   public class GrowingAngelVO
   {
      
      private var _growth:int;
      
      private var _id:int;
      
      private var _index:int;
      
      private var _posId:int;
      
      private var _state:int;
      
      private var _needTimeGrowUp:int;
      
      private var _variateId:int;
      
      private var _variateRate:int;
      
      public var madeChanging:Boolean = false;
      
      public function GrowingAngelVO()
      {
         super();
      }
      
      public function get needTimeGrowUp() : int
      {
         return this._needTimeGrowUp;
      }
      
      public function get isGorwUp() : Boolean
      {
         return this._needTimeGrowUp > 0 ? false : true;
      }
      
      public function get needTimeGrowUpToString() : String
      {
         var hour:int = this._needTimeGrowUp / 60;
         var minute:int = this._needTimeGrowUp % 60;
         if(hour > 0)
         {
            return hour + "小時" + minute + "分鐘";
         }
         return minute + "分鐘";
      }
      
      public function set needTimeGrowUp(value:int) : void
      {
         this._needTimeGrowUp = value;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         this._index = value;
      }
      
      public function get variateRate() : int
      {
         return this._variateRate;
      }
      
      public function set variateRate(value:int) : void
      {
         this._variateRate = value;
      }
      
      public function get growth() : int
      {
         return this._growth;
      }
      
      public function set growth(value:int) : void
      {
         this._growth = value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get posId() : int
      {
         return this._posId;
      }
      
      public function set posId(value:int) : void
      {
         this._posId = value;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(value:int) : void
      {
         this._state = value;
      }
      
      public function get variateId() : int
      {
         return this._variateId;
      }
      
      public function set variateId(value:int) : void
      {
         this._variateId = value;
      }
      
      public function get growLevel() : int
      {
         var growthList:Array = String(GoodsInfo.getInfoById(this._id).LevelNum).split(",");
         for(var i:int = 0; i < growthList.length; i++)
         {
            if(this.growth <= growthList[i])
            {
               return i + 1;
            }
         }
         return growthList.length;
      }
   }
}

