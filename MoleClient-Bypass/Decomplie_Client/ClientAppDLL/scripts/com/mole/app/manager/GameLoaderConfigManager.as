package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.global.staticData.XMLInfo;
   import com.mole.app.info.GameLoaderConfigInfo;
   
   public class GameLoaderConfigManager
   {
      
      private static var _config:HashMap;
      
      public function GameLoaderConfigManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var info:GameLoaderConfigInfo = null;
         var infoXml:XML = null;
         _config = new HashMap();
         var configXml:XML = XML(new XMLInfo.GameConfigCls());
         for each(infoXml in configXml.children())
         {
            info = new GameLoaderConfigInfo(infoXml);
            _config.add(info.id,info);
         }
      }
      
      public static function getInfo(gameID:uint) : GameLoaderConfigInfo
      {
         return _config.getValue(gameID);
      }
   }
}

