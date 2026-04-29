package com.module.coin
{
   import com.core.info.LocalUserInfo;
   import com.mole.debug.DebugManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   public class JDxmlInfo
   {
      
      public static var sellItemList:Array;
      
      private static var callBack:Function;
      
      private static const XML_PATH:String = "resource/xml/JDGoodsXmlData.xml";
      
      public function JDxmlInfo()
      {
         super();
      }
      
      public static function addxml(call:Function) : void
      {
         var urlloader:URLLoader = null;
         callBack = call;
         if(sellItemList == null)
         {
            urlloader = new URLLoader();
            urlloader.addEventListener(Event.COMPLETE,XmlCompleteHandler);
            urlloader.addEventListener(IOErrorEvent.IO_ERROR,XmlErrorHandler);
            urlloader.load(VL.getURLRequest(XML_PATH));
         }
         else
         {
            callBack.apply();
         }
      }
      
      private static function XmlCompleteHandler(e:Event) : void
      {
         var xml:XML = null;
         var xmlList:XMLList = null;
         var i:uint = 0;
         var tempObj:Object = null;
         var disOff:uint = 0;
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,XmlErrorHandler);
         try
         {
            sellItemList = new Array();
            xml = new XML(e.target.data);
            xmlList = xml.children();
            for(i = 0; i < xmlList.length(); i++)
            {
               tempObj = new Object();
               tempObj.ID = String(xmlList[i].@ID);
               tempObj.Name = String(xmlList[i].@Name);
               tempObj.commodityID = String(xmlList[i].@commodityID);
               tempObj.Price = uint(xmlList[i].@Price);
               tempObj.mustVip = uint(xmlList[i].@must_vip);
               disOff = uint(xmlList[i].@vip_discount);
               tempObj.disOff = disOff;
               if(tempObj.mustVip == 0 && LocalUserInfo.isVIP())
               {
                  tempObj.Price = uint(xmlList[i].@Price) * (disOff / 100);
               }
               sellItemList.push(tempObj);
            }
         }
         catch(err:Error)
         {
            DebugManager.traceMsg("配置文件格式不對");
            return;
         }
         callBack.apply();
      }
      
      private static function XmlErrorHandler(e:IOErrorEvent) : void
      {
         URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE,XmlCompleteHandler);
         URLLoader(e.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,XmlErrorHandler);
      }
      
      public static function getOneInfo(itemId:uint) : Object
      {
         var Obj:Object = new Object();
         for(var i:uint = 0; i < sellItemList.length; i++)
         {
            if(sellItemList[i].ID == itemId)
            {
               Obj = sellItemList[i];
               break;
            }
         }
         return Obj;
      }
   }
}

