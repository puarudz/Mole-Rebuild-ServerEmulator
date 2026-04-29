package com.common.util
{
   import flash.utils.getDefinitionByName;
   
   public class ClassUtil
   {
      
      public function ClassUtil()
      {
         super();
      }
      
      public static function getClass(pathAndName:String) : Class
      {
         return getDefinitionByName(pathAndName) as Class;
      }
   }
}

