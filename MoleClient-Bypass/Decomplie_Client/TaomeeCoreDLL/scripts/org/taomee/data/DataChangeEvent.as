package org.taomee.data
{
   import flash.events.Event;
   
   public class DataChangeEvent extends Event
   {
      
      public static const DATA_CHANGE:String = "dataChange";
      
      public static const PRE_DATA_CHANGE:String = "preDataChange";
      
      protected var _startIndex:uint;
      
      protected var _endIndex:uint;
      
      protected var _changeType:String;
      
      protected var _items:Array;
      
      public function DataChangeEvent(eventType:String, changeType:String, items:Array, startIndex:int = -1, endIndex:int = -1)
      {
         super(eventType);
         this._changeType = changeType;
         this._startIndex = startIndex;
         this._items = items;
         this._endIndex = endIndex == -1 ? this._startIndex : uint(endIndex);
      }
      
      public function get changeType() : String
      {
         return this._changeType;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function get startIndex() : uint
      {
         return this._startIndex;
      }
      
      public function get endIndex() : uint
      {
         return this._endIndex;
      }
      
      override public function toString() : String
      {
         return formatToString("DataChangeEvent","type","changeType","startIndex","endIndex","bubbles","cancelable");
      }
      
      override public function clone() : Event
      {
         return new DataChangeEvent(type,this._changeType,this._items,this._startIndex,this._endIndex);
      }
   }
}

