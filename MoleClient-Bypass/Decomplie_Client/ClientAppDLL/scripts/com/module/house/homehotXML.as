package com.module.house
{
   import com.core.info.VersionInfo;
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.system.*;
   
   public class homehotXML extends MovieClip
   {
      
      public static var AllChang_arr:Array = new Array();
      
      public static var ALLDATE:String = "homehotxml_alldate";
      
      public static var IfOver:Boolean = false;
      
      private var xml:XML;
      
      public function homehotXML()
      {
         super();
      }
      
      public function info() : void
      {
         var random_num:int = int(Math.random() * 1000000);
         var houseWeb:String = VersionInfo.getHouseWeb();
         var tempversion:XMLLoader = new XMLLoader("http://123.150.163.115/toplist/toplist.xml?&" + random_num);
         tempversion.addEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempversion.addEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
         tempversion.doLoad();
      }
      
      public function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         var k:uint;
         var myObjss:Object;
         var tmparr:Array = null;
         var tmpxml:XMLList = null;
         var lg:uint = 0;
         var i:uint = 0;
         var id:* = undefined;
         var name:* = undefined;
         var num:* = undefined;
         var inobj:Object = null;
         this.xml = evt.getXML();
         this.xml.ignoreWhitespace = true;
         for(k = 0; k < 3; k++)
         {
            tmparr = new Array();
            tmpxml = this.xml.Hots.(@type == k);
            lg = uint(tmpxml.children().length());
            for(i = 0; i < lg; i++)
            {
               id = tmpxml.Hot[i].@UID;
               name = tmpxml.Hot[i].@Nick;
               num = tmpxml.Hot[i].@Val;
               inobj = {
                  "id":id,
                  "name":name,
                  "num":num
               };
               tmparr.push(inobj);
            }
            AllChang_arr.push(tmparr);
         }
         myObjss = {"AllChang_arr":AllChang_arr};
         IfOver = true;
         dispatchEvent(new EventTaomee(ALLDATE,myObjss));
      }
      
      public function XMLFailHandler(evt:XMLLoadEvent) : void
      {
      }
   }
}

