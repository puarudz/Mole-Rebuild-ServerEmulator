package org.taomee.utils
{
   import flash.utils.getQualifiedClassName;
   
   public class ObjectUtil
   {
      
      public function ObjectUtil()
      {
         super();
      }
      
      public static function getClassName(obj:Object) : String
      {
         var name:String = getQualifiedClassName(obj);
         var index:int = name.indexOf("::");
         if(index != -1)
         {
            name = name.substr(index + 2);
         }
         return name;
      }
      
      public static function isSimple(value:Object) : Boolean
      {
         var type:String = typeof value;
         switch(type)
         {
            case "number":
            case "string":
            case "boolean":
               return true;
            case "object":
               return value is Date || value is Array;
            default:
               return false;
         }
      }
   }
}

