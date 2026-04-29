package org.taomee.net.tmf
{
   import flash.utils.Dictionary;
   
   public class TMF
   {
      
      private static var _map:Dictionary = new Dictionary();
      
      public function TMF()
      {
         super();
      }
      
      public static function registerClass(id:uint, classDef:Class) : void
      {
         if(Boolean(classDef))
         {
            _map[id] = classDef;
         }
      }
      
      public static function removeClass(id:uint) : void
      {
         if(id in _map)
         {
            delete _map[id];
         }
      }
      
      public static function getClass(id:uint) : Class
      {
         if(id in _map)
         {
            return _map[id];
         }
         return TmfByteArray;
      }
   }
}

