package com.module.lamuPkSys.animalSkill
{
   import com.global.staticData.XMLInfo;
   import flash.geom.Point;
   
   public class EggRainConfigParser
   {
      
      private static var _eggRainConfig:XML = new XML(new XMLInfo._eggRainConfig());
      
      public function EggRainConfigParser()
      {
         super();
      }
      
      public static function GetEggPosition(mapId:int, eggposid:int) : Point
      {
         var eggInfo:XML = null;
         var mapInfo:XML = GetMapCfg(mapId);
         if(Boolean(mapInfo))
         {
            for each(eggInfo in mapInfo.children())
            {
               if(eggposid == eggInfo.@posid)
               {
                  return new Point(eggInfo.x,eggInfo.y);
               }
            }
         }
         return null;
      }
      
      public static function HasEggCfgInMap(mapId:int) : Boolean
      {
         var mapInfo:XML = GetMapCfg(mapId);
         if(mapInfo != null && mapInfo.children().length() > 0)
         {
            return true;
         }
         return false;
      }
      
      public static function GetMapCfg(mapId:int) : XML
      {
         var mapCfg:XML = null;
         var id:int = 0;
         for each(mapCfg in _eggRainConfig.children())
         {
            id = int(mapCfg.@mapid);
            if(mapId == id)
            {
               return mapCfg;
            }
         }
         return null;
      }
   }
}

