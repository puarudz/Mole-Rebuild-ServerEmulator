package com.module.house
{
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import com.global.links.Links;
   import flash.events.EventDispatcher;
   
   public class petXML
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var PETXML:XML;
      
      public static var foodArr:Array;
      
      public static var serverArr:Array = new Array();
      
      public static var localArr:Array = new Array();
      
      public static var sortArr:Array = new Array();
      
      public function petXML()
      {
         super();
      }
      
      public static function loadPetXML() : void
      {
         var URL:String = null;
         var tempClass:XMLLoader = null;
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         try
         {
            URL = "resource/xml/petfood.xml";
            URL = Links.getUrl(URL);
            tempClass = new XMLLoader(URL);
            tempClass.addEventListener(XMLLoadEvent.ON_SUCCESS,XMLOverHandler);
            tempClass.addEventListener(XMLLoadEvent.ERROR,XMLFailHandler);
            tempClass.doLoad();
         }
         catch(e:Error)
         {
         }
      }
      
      public static function getArr(arr:Array) : void
      {
         serverArr = new Array();
         localArr = new Array();
         sortArr = new Array();
         serverArr = arr;
         for(var i:uint = 0; i < arr.length; i++)
         {
         }
         getInfo();
      }
      
      public static function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         foodArr = new Array();
         PETXML = evt.getXML();
         dispatchEvent(new EventTaomee("dispatchPetXMLLoaded"));
      }
      
      public static function getInfo() : void
      {
         var len:uint = uint(PETXML.children().length());
         for(var i:uint = 0; i < len; i++)
         {
            foodArr[i] = new Object();
            foodArr[i].ID = PETXML.Item[i]["ID"];
            foodArr[i].Name = PETXML.Item[i]["Name"];
            foodArr[i].Type = PETXML.Item[i]["Type"];
            foodArr[i].Grade = PETXML.Item[i]["Grade"];
            foodArr[i].Price = PETXML.Item[i]["Price"];
            foodArr[i].Hungry = PETXML.Item[i]["Hungry"];
            foodArr[i].Thirsty = PETXML.Item[i]["Thirsty"];
            foodArr[i].Dirty = PETXML.Item[i]["Sanitary"];
            foodArr[i].Spirit = PETXML.Item[i]["Spirit"];
            foodArr[i].Attr = PETXML.Item[i]["Attr"];
            foodArr[i].Eat = PETXML.Item[i]["Eat"];
            foodArr[i].Tool = PETXML.Item[i]["Tool"];
            foodArr[i].ColorType = PETXML.Item[i]["ColorType"];
         }
      }
      
      public static function getGoodsObj(id:Number) : Object
      {
         var obj:Object = null;
         var len:uint = uint(PETXML.children().length());
         for(var j:uint = 0; j < len; j++)
         {
            if(id == Number(PETXML.Item[j]["ID"]))
            {
               obj = new Object();
               obj = new Object();
               obj.ID = PETXML.Item[j]["ID"];
               obj.Name = PETXML.Item[j]["Name"];
               obj.Type = PETXML.Item[j]["Type"];
               obj.Grade = PETXML.Item[j]["Grade"];
               obj.Price = PETXML.Item[j]["Price"];
               obj.Hungry = PETXML.Item[j]["Hungry"];
               obj.Thirsty = PETXML.Item[j]["Thirsty"];
               obj.Dirty = PETXML.Item[j]["Sanitary"];
               obj.Spirit = PETXML.Item[j]["Spirit"];
               obj.Attr = PETXML.Item[j]["Attr"];
               obj.Eat = PETXML.Item[j]["Eat"];
               obj.Tool = PETXML.Item[j]["Tool"];
               obj.ColorType = PETXML.Item[j]["ColorType"];
               return obj;
            }
         }
         throw new Error("id錯了 resource/xml/petfood.xml");
      }
      
      public static function getGoodsAttr(id:Number) : Number
      {
         var len:uint = uint(PETXML.children().length());
         for(var j:uint = 0; j < len; j++)
         {
            if(id == Number(PETXML.Item[j]["ID"]))
            {
               return Number(PETXML.Item[j]["Attr"]);
            }
         }
         throw new Error("Type錯了");
      }
      
      public static function getGoodsType(id:Number) : Number
      {
         var len:uint = uint(PETXML.children().length());
         for(var j:uint = 0; j < len; j++)
         {
            if(id == Number(PETXML.Item[j]["ID"]))
            {
               return Number(PETXML.Item[j]["Type"]);
            }
         }
         throw new Error("Type錯了");
      }
      
      public static function getGoodsLayer(id:Number) : Number
      {
         var len:uint = uint(PETXML.children().length());
         for(var j:uint = 0; j < len; j++)
         {
            if(id == Number(PETXML.Item[j]["ID"]))
            {
               return Number(PETXML.Item[j]["Layer"]);
            }
         }
         return 0;
      }
      
      public static function sortGoods() : void
      {
         var kindlen:uint = 0;
         var k:uint = 0;
         var len:uint = localArr.length;
         sortArr = null;
         sortArr = [[],[],[],[],[]];
         var sortarrlen:uint = sortArr.length;
         for(var j:uint = 0; j < len; j++)
         {
            sortArr[Number(localArr[j].Type)].push(localArr[j]);
         }
         for(var h:uint = 1; h < sortarrlen; h++)
         {
            kindlen = uint(sortArr[h].length);
            for(k = 0; k < kindlen; k++)
            {
               sortArr[0].push(sortArr[h][k]);
            }
         }
         dispatchEvent(new EventTaomee("dispatchLocalArr",{"arr":sortArr}));
      }
      
      public static function XMLFailHandler(e:XMLLoadEvent) : void
      {
      }
   }
}

