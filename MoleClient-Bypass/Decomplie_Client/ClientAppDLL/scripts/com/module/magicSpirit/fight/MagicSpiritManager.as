package com.module.magicSpirit.fight
{
   import com.module.magicSpirit.data.MagicSpiritUserInfo;
   import flash.events.EventDispatcher;
   
   public class MagicSpiritManager extends EventDispatcher
   {
      
      private static var _inst:MagicSpiritManager;
      
      private var _userInfo:MagicSpiritUserInfo;
      
      public function MagicSpiritManager()
      {
         super();
      }
      
      public static function getInstance() : MagicSpiritManager
      {
         if(_inst == null)
         {
            _inst = new MagicSpiritManager();
         }
         return _inst;
      }
      
      public function get userInfo() : MagicSpiritUserInfo
      {
         return this._userInfo;
      }
   }
}

