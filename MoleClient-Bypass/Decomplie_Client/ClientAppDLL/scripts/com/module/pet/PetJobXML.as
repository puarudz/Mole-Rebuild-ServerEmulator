package com.module.pet
{
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class PetJobXML extends EventDispatcher
   {
      
      public static var CLASS_arr:Array;
      
      public static var ALLDATE:String = "allPET_Jobdate";
      
      private var xml:XML;
      
      public function PetJobXML(target:IEventDispatcher = null)
      {
         super();
         CLASS_arr = [];
         var urls:String = "resource/xml/ListPetClass.xml";
         var tempversion:XMLLoader = new XMLLoader(urls);
         tempversion.addEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempversion.addEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
         tempversion.doLoad();
      }
      
      public function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         var CLASSID:* = undefined;
         var Type:* = undefined;
         var Name:* = undefined;
         var Price:* = undefined;
         var AllDays:* = undefined;
         var TestFlag:String = null;
         var Flag:uint = 0;
         var FlagDays:uint = 0;
         var LeaveDays:uint = 0;
         var obj:Object = null;
         this.xml = evt.getXML();
         this.xml.ignoreWhitespace = true;
         var lg:int = this.xml.child("item").length();
         for(var i:int = 0; i < lg; i++)
         {
            CLASSID = this.xml.item[i].@ID;
            Type = this.xml.item[i].@Type;
            Name = this.xml.item[i].@Name;
            Price = this.xml.item[i].@Price;
            AllDays = this.xml.item[i].@AllDays;
            if(CLASSID == 0 || CLASSID == 1)
            {
               TestFlag = "yes";
            }
            else
            {
               TestFlag = "no";
            }
            Flag = 0;
            FlagDays = 0;
            LeaveDays = AllDays;
            obj = {
               "CLASSID":CLASSID,
               "Type":Type,
               "Name":Name,
               "Price":Price,
               "AllDays":AllDays,
               "Flag":Flag,
               "FlagDays":FlagDays,
               "LeaveDays":LeaveDays,
               "TestFlag":TestFlag
            };
            CLASS_arr[CLASSID] = obj;
         }
         var myObj:Object = {"CLASS_arr":CLASS_arr};
         dispatchEvent(new EventTaomee(ALLDATE,myObj));
         var tempversion:XMLLoader = evt.currentTarget as XMLLoader;
         tempversion.removeEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempversion.removeEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
      }
      
      public function XMLFailHandler(evt:*) : void
      {
      }
   }
}

