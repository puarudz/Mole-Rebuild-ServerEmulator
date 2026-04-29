package com.module.ListSMC
{
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import com.global.staticData.XMLInfo;
   import flash.display.MovieClip;
   
   public class conSMC extends MovieClip
   {
      
      public static var oneList_arr:Array = new Array();
      
      public static var twoList_arr:Array = new Array();
      
      public static var threeList_arr:Array = new Array();
      
      public static var fourList_arr:Array = new Array();
      
      public static var fiveList_arr:Array = new Array();
      
      public static var sixList_arr:Array = new Array();
      
      public static var sevenList_arr:Array = new Array();
      
      public static var eightList_arr:Array = new Array();
      
      public static var nineList_arr:Array = new Array();
      
      public static var tenList_arr:Array = new Array();
      
      public static var eleven_arr:Array = new Array();
      
      private static var _otherList:Array = new Array();
      
      private static var _npcJobList:Array = new Array();
      
      public static var ALLDATE:String = "alldate";
      
      public static var ALLDELEDATE:String = "allremovedate";
      
      private var xml:XML;
      
      private var chang_arr:Array;
      
      private var changID:uint = 0;
      
      public function conSMC()
      {
         super();
      }
      
      public static function get npcJobList_arr() : Array
      {
         return _npcJobList;
      }
      
      public static function get otherList_arr() : Array
      {
         return _otherList;
      }
      
      public function init() : void
      {
         this.XMLOverHandler(XMLInfo.jobListXML);
         this.npcJobXmlOverHandler(XMLInfo.npcJobListXML);
      }
      
      public function XMLOverHandler(evt:XML) : void
      {
         var item:* = undefined;
         var item1:* = undefined;
         var item2:* = undefined;
         var item4:* = undefined;
         var item5:* = undefined;
         var Obj_h:Object = null;
         var item6:* = undefined;
         var item7:* = undefined;
         var item8:* = undefined;
         var item9:* = undefined;
         var item10:* = undefined;
         var item3:* = undefined;
         var Obj_a:Object = null;
         var Obj_b:Object = null;
         var Obj_c:Object = null;
         var Obj_e:Object = null;
         var Obj_f:Object = null;
         var Obj_d:Object = null;
         this.chang_arr = [];
         oneList_arr = new Array();
         twoList_arr = new Array();
         threeList_arr = new Array();
         fourList_arr = new Array();
         fiveList_arr = new Array();
         sixList_arr = new Array();
         sevenList_arr = new Array();
         eightList_arr = new Array();
         nineList_arr = new Array();
         tenList_arr = new Array();
         eleven_arr = new Array();
         this.xml = evt;
         this.xml.ignoreWhitespace = true;
         for each(item in this.xml.oneList.item)
         {
            Obj_a = this.setInfo(item);
            oneList_arr.push(Obj_a);
         }
         for each(item1 in this.xml.twoList.item)
         {
            Obj_b = this.setInfo(item1);
            twoList_arr.push(Obj_b);
         }
         for each(item2 in this.xml.threeList.item)
         {
            Obj_c = this.setInfo(item2);
            threeList_arr.push(Obj_c);
         }
         for each(item4 in this.xml.fourList.item)
         {
            Obj_e = this.setInfo(item4);
            fourList_arr.push(Obj_e);
         }
         for each(item5 in this.xml.fiveList.item)
         {
            Obj_f = this.setInfo(item5);
            fiveList_arr.push(Obj_f);
         }
         for each(item6 in this.xml.sixList.item)
         {
            Obj_h = this.setInfo(item6);
            sixList_arr.push(Obj_h);
         }
         for each(item7 in this.xml.sevenList.item)
         {
            Obj_h = this.setInfo(item7);
            sevenList_arr.push(Obj_h);
         }
         for each(item7 in this.xml.eightList.item)
         {
            Obj_h = this.setInfo(item7);
            eightList_arr.push(Obj_h);
         }
         for each(item8 in this.xml.nineList.item)
         {
            Obj_h = this.setInfo(item8);
            nineList_arr.push(Obj_h);
         }
         for each(item9 in this.xml.tenList.item)
         {
            Obj_h = this.setInfo(item9);
            tenList_arr.push(Obj_h);
         }
         for each(item10 in this.xml.elevenList.item)
         {
            Obj_h = this.setInfo(item10);
            eleven_arr.push(Obj_h);
         }
         for each(item3 in this.xml.otherList.item)
         {
            Obj_d = this.setInfo(item3);
            _otherList.push(Obj_d);
         }
         dispatchEvent(new EventTaomee(ALLDATE));
      }
      
      private function setInfo(item:*) : Object
      {
         var Obj_a:Object = {};
         Obj_a.TaskID = item.@TaskID;
         Obj_a.TaskStatus = item.@TaskStatus;
         Obj_a.names = item.@names;
         Obj_a.msg = item.@msg;
         Obj_a.info = item.@info;
         Obj_a.pic = item.@pic;
         Obj_a.goods = item.@goods;
         Obj_a.goodsName = item.@goodsName;
         Obj_a.goodsTip = item.@goodsTip;
         Obj_a.getGoods = item.@getGoods;
         Obj_a.changID = item.@changID;
         if(Obj_a.changID != "no")
         {
            this.chang_arr.push(Obj_a.TaskID);
            Obj_a.TaskID = Obj_a.changID;
            Obj_a.TaskStatus = 0;
         }
         return Obj_a;
      }
      
      private function npcJobXmlOverHandler(evt:XML) : void
      {
         var item:* = undefined;
         var obj:Object = null;
         this.xml = evt;
         this.xml.ignoreWhitespace = true;
         for each(item in this.xml.item)
         {
            obj = this.setNPCJob(item);
            _npcJobList[parseInt(obj.TaskID)] = obj;
         }
      }
      
      private function setNPCJob(item:*) : Object
      {
         var Obj_a:Object = {};
         Obj_a.TaskID = item.@TaskID;
         Obj_a.names = item.@names;
         Obj_a.isVip = item.@isVip;
         Obj_a.goods = item.@goods;
         Obj_a.goodsTip = item.@goodsTip;
         Obj_a.getGoods = item.@getGoods;
         return Obj_a;
      }
      
      public function XMLFailHandler(evt:XMLLoadEvent) : void
      {
         evt.target.removeEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
      }
   }
}

