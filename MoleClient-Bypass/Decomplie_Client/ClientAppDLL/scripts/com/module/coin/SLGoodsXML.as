package com.module.coin
{
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import flash.events.*;
   import flash.system.*;
   
   public class SLGoodsXML extends EventDispatcher
   {
      
      public static var All_Info:Array;
      
      public static var All_Item:Array;
      
      public static var All_CommodityID:Array;
      
      public static var Item_num:uint;
      
      public static var House_num:uint;
      
      public static var ALLDATE:String = "alldate";
      
      private var xml:XML;
      
      public function SLGoodsXML()
      {
         super();
      }
      
      public function Info() : void
      {
         All_Info = [];
         All_Item = [];
         All_CommodityID = [];
         this.XMLOverHandler(XMLInfo.SLGoodsXmlData);
      }
      
      public function XMLOverHandler(evt:XML) : void
      {
         var item:* = undefined;
         var Obj_1:Object = null;
         this.xml = evt;
         this.xml.ignoreWhitespace = true;
         for each(item in this.xml)
         {
            Obj_1 = this.setInfo(item,0);
            All_Info.push(Obj_1);
         }
         dispatchEvent(new EventTaomee(ALLDATE));
      }
      
      private function setInfo(item:*, type:uint) : Object
      {
         var item_xml:* = undefined;
         var Obj:Object = null;
         var Obj_a:Object = {};
         Obj_a.Page = item.@ID;
         Obj_a.Arr = [];
         for each(item_xml in item.Item)
         {
            Obj = {};
            Obj.count = 0;
            Obj.item_ID = item_xml.@ID;
            Obj.item_Name = item_xml.@Name;
            Obj.commodity_ID = item_xml.@commodityID;
            Obj.price = item_xml.@Price;
            Obj.price_Vip = Number(Obj.price) / 2;
            Obj_a.Arr.push(Obj);
            All_Item.push(Obj);
            All_CommodityID.push(Obj.commodity_ID);
            if(type == 0)
            {
               ++Item_num;
            }
            else
            {
               ++House_num;
            }
         }
         return Obj_a;
      }
   }
}

