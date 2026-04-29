package com.core.info
{
   import com.global.staticData.MapsConfig;
   
   public class MapInfo
   {
      
      public static var MAPTYPE_HOME:String = "home";
      
      public static var MAPTYPE_FARM:String = "farm";
      
      public static var MAPTYPE_DINING:String = "dining";
      
      public static var MAPTYPE_HOUSE:String = "house";
      
      public static var MAPTYPE_CLASS:String = "class";
      
      public static const MAP_TYPE_ANGEL:String = "angel";
      
      public var id:int = 0;
      
      public var name:String = "";
      
      public var type:int;
      
      public var note:String;
      
      public var className:String;
      
      public var firstMap:int;
      
      public var canFly:int;
      
      public var isHSL:int;
      
      public var isDXSL:int;
      
      public var isMLSL:int;
      
      public var digTreasureId:int = -1;
      
      public var isNewUserMap:int;
      
      public var isAngel:int;
      
      public var isLamuWorld:int;
      
      public var isFightWorld:int;
      
      public var seabed:int;
      
      public var isHideTopUI:int;
      
      public var hideMount:Boolean;
      
      public var isNewMap:Boolean;
      
      public var isOldHSL:int = 0;
      
      public var isDel:Boolean;
      
      public function MapInfo(_id:int, _name:String = "", _type:int = 0)
      {
         var info:Object;
         var str:String = null;
         super();
         this.id = _id;
         this.type = _type;
         info = MapsConfig.MapsInfo[_id];
         for(str in info)
         {
            try
            {
               this[str] = info[str];
            }
            catch(E:Error)
            {
               throw MapInfo + "缺少關鍵字:" + str;
            }
         }
         if(Boolean(info))
         {
            this.name = info.note;
         }
         else if(this.id > 2000000000)
         {
            this.name = "home";
         }
         else if(this.type == 2)
         {
            this.name = "farm";
         }
         else if(this.type == 31)
         {
            this.name = "dining";
         }
         else if(this.type == 32)
         {
            this.name = MAPTYPE_CLASS;
         }
         else if(this.type == 300)
         {
            this.name = MAP_TYPE_ANGEL;
         }
         else
         {
            this.name = "house";
         }
      }
      
      public static function currentMapInfo() : MapInfo
      {
         var mapid:int = LocalUserInfo.getMapID();
         var lct:int = LocalUserInfo.getMapType();
         return new MapInfo(mapid,"",lct);
      }
      
      public static function getMapInfo(mapID:int, mapType:int = 0) : MapInfo
      {
         return new MapInfo(mapID,"",mapType);
      }
   }
}

