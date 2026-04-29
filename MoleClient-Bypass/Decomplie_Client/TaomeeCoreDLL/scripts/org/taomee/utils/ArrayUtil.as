package org.taomee.utils
{
   public class ArrayUtil
   {
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function containsValue(array:Array, value:Object) : Boolean
      {
         return array.indexOf(value) != -1;
      }
      
      public static function removeValue(array:Array, value:Object) : void
      {
         var i:int = array.indexOf(value);
         if(i != -1)
         {
            array.splice(i,1);
         }
      }
      
      public static function unique(array:Array) : Array
      {
         var uniqueArr:Array = null;
         uniqueArr = [];
         array.forEach(function(item:Object, index:int, array:Array):void
         {
            if(uniqueArr.indexOf(item) == -1)
            {
               uniqueArr.push(item);
            }
         });
         return uniqueArr;
      }
      
      public static function copy(array:Array) : Array
      {
         return array.slice();
      }
      
      public static function equals(array1:Array, array2:Array) : Boolean
      {
         var item:Object = null;
         if(array1.length == array2.length)
         {
            for each(item in array1)
            {
               if(array2.indexOf(item) == -1)
               {
                  return false;
               }
            }
            for each(item in array2)
            {
               if(array1.indexOf(item) == -1)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public static function embody(array1:Array, array2:Array) : Boolean
      {
         var item:Object = null;
         for each(item in array2)
         {
            if(array1.indexOf(item) == -1)
            {
               return false;
            }
         }
         return true;
      }
   }
}

