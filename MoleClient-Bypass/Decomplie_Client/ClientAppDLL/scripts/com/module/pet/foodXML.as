package com.module.pet
{
   import com.event.EventTaomee;
   import com.global.links.Links;
   import flash.events.EventDispatcher;
   
   public class foodXML
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var FOODXML:XML;
      
      public static var foodArr:Array;
      
      public function foodXML()
      {
         super();
      }
      
      public static function loadFoodXML() : void
      {
         var URL:String = null;
         var tempClass:* = undefined;
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         try
         {
            URL = "resource/xml/petfood.xml";
            URL = Links.getUrl(URL);
            tempClass = GV.GF.loadURL(URL);
            tempClass.addEventListener(GV.GF.XML_OVER,XMLOverHandler);
            tempClass.addEventListener(GV.GF.XML_FAIL,XMLFailHandler);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function XMLOverHandler(evt:EventTaomee) : void
      {
         foodArr = new Array();
         FOODXML = XML(evt.EventObj.data);
         getInfo();
         dispatchEvent(new EventTaomee("dispatchFoodXMLLoaded",{"arr":foodArr}));
      }
      
      public static function getInfo() : void
      {
         var len:uint = uint(FOODXML.children().length());
         for(var i:uint = 0; i < len; i++)
         {
            foodArr[i] = new Object();
            foodArr[i].ID = FOODXML.Item[i]["ID"];
            foodArr[i].Name = FOODXML.Item[i]["Name"];
            foodArr[i].Grade = FOODXML.Item[i]["Grade"];
            foodArr[i].Price = FOODXML.Item[i]["Price"];
            foodArr[i].Hungry = FOODXML.Item[i]["Hungry"];
            foodArr[i].Thirsty = FOODXML.Item[i]["Thirsty"];
            foodArr[i].Dirty = FOODXML.Item[i]["Dirty"];
            foodArr[i].Spirit = FOODXML.Item[i]["Spirit"];
            foodArr[i].Eat = FOODXML.Item[i]["Eat"];
            foodArr[i].Tool = FOODXML.Item[i]["Tool"];
         }
      }
      
      public static function XMLFailHandler(e:*) : void
      {
      }
   }
}

