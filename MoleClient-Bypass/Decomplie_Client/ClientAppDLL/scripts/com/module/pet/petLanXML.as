package com.module.pet
{
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import flash.events.EventDispatcher;
   
   public class petLanXML
   {
      
      public static var dispatchEvent:Function;
      
      public static var addEventListener:Function;
      
      public static var removeEventListener:Function;
      
      public static var PETXML:XML;
      
      public static var LanArr:Array;
      
      public function petLanXML()
      {
         super();
      }
      
      public static function loadPetLanXML() : void
      {
         var URL:String = null;
         var tempClass:XMLLoader = null;
         var ed:EventDispatcher = new EventDispatcher();
         dispatchEvent = ed.dispatchEvent;
         addEventListener = ed.addEventListener;
         removeEventListener = ed.removeEventListener;
         try
         {
            URL = "resource/xml/petTalk.xml";
            tempClass = new XMLLoader(URL);
            tempClass.addEventListener(XMLLoadEvent.ON_SUCCESS,XMLOverHandler);
            tempClass.addEventListener(XMLLoadEvent.ERROR,XMLFailHandler);
            tempClass.doLoad();
         }
         catch(e:Error)
         {
         }
      }
      
      public static function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         LanArr = new Array();
         LanArr[0] = new Array();
         LanArr[1] = new Array();
         LanArr[2] = new Array();
         LanArr[3] = new Array();
         LanArr[4] = new Array();
         LanArr[5] = new Array();
         LanArr[6] = new Array();
         LanArr[7] = new Array();
         LanArr[8] = new Array();
         LanArr[9] = new Array();
         LanArr[10] = new Array();
         LanArr[11] = new Array();
         LanArr[12] = new Array();
         LanArr[13] = new Array();
         LanArr[14] = new Array();
         LanArr[15] = new Array();
         LanArr[16] = new Array();
         LanArr[17] = new Array();
         LanArr[18] = new Array();
         PETXML = evt.getXML();
         getInfo();
         dispatchEvent(new EventTaomee("dispatchPetLanXMLLoaded"));
      }
      
      public static function getInfo() : void
      {
         var obj:Object = null;
         var len:uint = uint(PETXML.children().length());
         for(var i:uint = 0; i < len; i++)
         {
            obj = {
               "lang0":PETXML.Item[i]["lang0"],
               "lang1":PETXML.Item[i]["lang1"],
               "lang2":PETXML.Item[i]["lang2"],
               "lang3":PETXML.Item[i]["lang3"]
            };
            LanArr[uint(PETXML.Item[i]["lanlevel"])][uint(PETXML.Item[i]["attr"])] = obj;
         }
         LanArr[2] = LanArr[1];
         var a:uint = 0;
         for(a = 0; a < 7; a++)
         {
            obj = {
               "lang0":LanArr[0][a].lang0 + "_" + LanArr[14][a].lang0,
               "lang1":LanArr[0][a].lang1 + "_" + LanArr[14][a].lang1,
               "lang2":LanArr[0][a].lang2 + "_" + LanArr[14][a].lang2,
               "lang3":LanArr[0][a].lang3 + "_" + LanArr[14][a].lang3
            };
            LanArr[15][a] = obj;
         }
         for(a = 0; a < 7; a++)
         {
            obj = {
               "lang0":LanArr[1][a].lang0 + "_" + LanArr[14][a].lang0,
               "lang1":LanArr[1][a].lang1 + "_" + LanArr[14][a].lang1,
               "lang2":LanArr[1][a].lang2 + "_" + LanArr[14][a].lang2,
               "lang3":LanArr[1][a].lang3 + "_" + LanArr[14][a].lang3
            };
            LanArr[17][a] = obj;
         }
         trace(1);
      }
      
      public static function XMLFailHandler(e:*) : void
      {
      }
   }
}

