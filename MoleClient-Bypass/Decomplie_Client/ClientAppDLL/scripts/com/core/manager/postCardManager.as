package com.core.manager
{
   public class postCardManager
   {
      
      public static var cardsList_arr:Array;
      
      public static var OnlyCardsList_arr:Array;
      
      public function postCardManager()
      {
         super();
      }
      
      public static function info(xml:XML) : void
      {
         var item:* = undefined;
         var Obj:Object = null;
         cardsList_arr = new Array();
         OnlyCardsList_arr = new Array();
         xml.ignoreWhitespace = true;
         for each(item in xml.children())
         {
            Obj = new Object();
            Obj.ID = item.@ID;
            Obj.Type = item.@Type;
            Obj.Contype = item.@Contype;
            Obj.Names = item.@Name;
            Obj.Price = item.@Price;
            Obj.Grade = item.@Grade;
            Obj.GradeInfo = item.@GradeInfo;
            Obj.giftType = item.@GiftType;
            Obj.isNeedGoods = item.@isNeedGoods;
            Obj.goodsID = item.@goodsID;
            Obj.goodsCount = item.@goodsCount;
            Obj.exchangeType = item.@exchangeType;
            OnlyCardsList_arr.push(uint(Obj.ID));
            cardsList_arr.push(Obj);
         }
      }
      
      public static function getOneInfo(ID:uint) : Object
      {
         var obj:Object = null;
         var ip:uint = uint(OnlyCardsList_arr.indexOf(ID));
         return cardsList_arr[ip];
      }
   }
}

