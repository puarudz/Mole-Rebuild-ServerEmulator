package com.mole.app.info
{
   import flash.geom.Point;
   
   public class SearchSomethingInfo
   {
      
      public var activityId:uint;
      
      public var id:uint;
      
      public var mapId:uint;
      
      public var pos:Point;
      
      public var level:String;
      
      public var exchangeId:uint;
      
      public var dateType:uint;
      
      public var maxCount:uint;
      
      public var tips:String;
      
      public function SearchSomethingInfo(xml:XML, activityId:uint)
      {
         super();
         this.activityId = activityId;
         this.id = uint(xml.@id);
         this.mapId = uint(xml.@mapId);
         this.pos = new Point(String(xml.@pos).split(",")[0],String(xml.@pos).split(",")[1]);
         this.level = String(xml.@level);
         this.exchangeId = uint(xml.@exchangeId);
         this.dateType = uint(xml.@dateType);
         this.maxCount = uint(xml.@maxCount);
         this.tips = String(xml.@tips);
      }
   }
}

