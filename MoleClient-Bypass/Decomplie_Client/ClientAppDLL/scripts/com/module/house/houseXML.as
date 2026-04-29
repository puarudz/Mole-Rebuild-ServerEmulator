package com.module.house
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import flash.events.EventDispatcher;
   
   public class houseXML
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var HOUSEXML:*;
      
      public static var AllHouseGoodsArr:*;
      
      public static var serverArr:Array = new Array();
      
      public static var localArr:Array = new Array();
      
      public static var sortArr:Array = new Array();
      
      public function houseXML()
      {
         super();
      }
      
      public static function getArr(arr:Array) : void
      {
         serverArr = new Array();
         localArr = new Array();
         sortArr = new Array();
         serverArr = arr;
         getInfo();
      }
      
      public static function getXMLFromData() : void
      {
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
      }
      
      public static function getInfo() : void
      {
         var tmpInfo:Object = null;
         var idx:uint = 0;
         for(var i:int = 0; i < serverArr.length; i++)
         {
            tmpInfo = GoodsInfo.getInfoById(serverArr[i].id);
            if(Boolean(tmpInfo))
            {
               tmpInfo.Count = serverArr[i].itemCount;
               localArr[idx] = tmpInfo;
               idx++;
            }
         }
         sortGoods();
      }
      
      public static function getGoodsObj(id:Number) : Object
      {
         var obj:Object = null;
         var len:int = int(HOUSEXML.children().length());
         for(var j:int = 0; j < len; j++)
         {
            if(id == Number(HOUSEXML.Item[j]["ID"]))
            {
               obj = new Object();
               obj = new Object();
               obj.ID = HOUSEXML.Item[j]["ID"];
               obj.Name = HOUSEXML.Item[j]["Name"];
               obj.Grade = HOUSEXML.Item[j]["Grade"];
               obj.Price = HOUSEXML.Item[j]["Price"];
               obj.Layer = HOUSEXML.Item[j]["Layer"];
               obj.Type = HOUSEXML.Item[j]["Type"];
               return obj;
            }
         }
         return "id錯了";
      }
      
      public static function getGoodsType(id:Number) : Number
      {
         var len:int = int(HOUSEXML.children().length());
         for(var j:int = 0; j < len; j++)
         {
            if(id == Number(HOUSEXML.Item[j]["ID"]))
            {
               return Number(HOUSEXML.Item[j]["Type"]);
            }
         }
         return -1;
      }
      
      public static function getGoodsLayer(id:Number) : Object
      {
         var len:int = int(HOUSEXML.children().length());
         for(var j:int = 0; j < len; j++)
         {
            if(id == Number(HOUSEXML.Item[j]["ID"]))
            {
               return Number(HOUSEXML.Item[j]["Layer"]);
            }
         }
         return "Layer錯了";
      }
      
      public static function sortGoods() : void
      {
         var itemInfo:Object = null;
         var kindlen:int = 0;
         var k:int = 0;
         var len:int = int(localArr.length);
         sortArr = null;
         sortArr = [[],[],[],[],[],[],[],[]];
         var sortarrlen:int = int(sortArr.length);
         for(var j:int = 0; j < len; j++)
         {
            itemInfo = localArr[j];
            if(Boolean(itemInfo.Type))
            {
               if(localArr[j].ID == 160144)
               {
                  sortArr[Number(itemInfo.Type)].unshift(itemInfo);
               }
               else
               {
                  sortArr[Number(itemInfo.Type)].push(itemInfo);
               }
            }
         }
         for(var h:int = 1; h < sortarrlen; h++)
         {
            kindlen = int(sortArr[h].length);
            for(k = 0; k < kindlen; k++)
            {
               if(sortArr[h][k].ID == 160144)
               {
                  sortArr[0].unshift(sortArr[h][k]);
               }
               else
               {
                  sortArr[0].push(sortArr[h][k]);
               }
            }
         }
         dispatchEvent(new EventTaomee("dispatchLocalArr",{"arr":sortArr}));
      }
      
      public static function XMLFailHandler(e:XMLLoadEvent) : void
      {
      }
   }
}

