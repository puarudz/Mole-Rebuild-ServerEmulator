package com.logic.socket.angelPark.valueObj
{
   public class AngelParkWarehouseVO
   {
      
      private var _seedList:Array;
      
      private var _bgList:Array;
      
      private var _itemList:Array;
      
      public function AngelParkWarehouseVO()
      {
         super();
      }
      
      public function get seedList() : Array
      {
         return this._seedList;
      }
      
      public function set seedList(value:Array) : void
      {
         this._seedList = value;
      }
      
      public function get bgList() : Array
      {
         return this._bgList;
      }
      
      public function set bgList(value:Array) : void
      {
         this._bgList = value;
      }
      
      public function get itemList() : Array
      {
         return this._itemList;
      }
      
      public function set itemList(value:Array) : void
      {
         this._itemList = value;
      }
   }
}

