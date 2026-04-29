package com.mole.app.info
{
   public class SwapInfo
   {
      
      private var _seq:uint;
      
      private var _typeID:uint;
      
      private var _needID:uint;
      
      private var _needCount:uint;
      
      private var _resID:uint;
      
      private var _dataType:uint;
      
      private var _dec:String;
      
      private var _goodsID:uint;
      
      private var _goodsPrize:uint;
      
      private var _socketID:uint = 0;
      
      public function SwapInfo(infoXml:XML)
      {
         super();
         this.initXml(infoXml);
      }
      
      public function initXml(infoXml:XML) : void
      {
         this._seq = uint(infoXml.@Seq);
         this._typeID = uint(infoXml.@TypeID);
         this._needID = uint(infoXml.@NeedID);
         this._needCount = uint(infoXml.@NeedCount);
         this._resID = uint(infoXml.@ResID);
         this._dataType = uint(infoXml.@DataType);
         this._dec = infoXml.@Dec.toString();
         this._goodsID = uint(infoXml.@GoodsID);
         this._goodsPrize = uint(infoXml.@GoodsPrize);
         this._socketID = uint(infoXml.@SocketID);
      }
      
      public function get socketID() : uint
      {
         return this._socketID;
      }
      
      public function get dataType() : uint
      {
         return this._dataType;
      }
      
      public function get typeID() : uint
      {
         return this._typeID;
      }
      
      public function get needID() : uint
      {
         return this._needID;
      }
      
      public function get needCount() : uint
      {
         return this._needCount;
      }
      
      public function get resID() : uint
      {
         return this._resID;
      }
      
      public function get dec() : String
      {
         return this._dec;
      }
      
      public function get seq() : uint
      {
         return this._seq;
      }
      
      public function get goodsID() : uint
      {
         return this._goodsID;
      }
      
      public function get goodsPrize() : uint
      {
         return this._goodsPrize;
      }
   }
}

