package com.core.stringPop
{
   public class Pop
   {
      
      public function Pop()
      {
         super();
      }
      
      public static function prevIndex(__xml_str:String, first_str:String, index:int = 0) : int
      {
         var cont:int = 0;
         var first_Num:int = -1;
         var cont_Num:int = 1;
         while(first_Num < 0)
         {
            cont = index - cont_Num;
            if(cont == -1)
            {
               first_Num = -1;
               break;
            }
            first_Num = __xml_str.indexOf(first_str,index - cont_Num);
            if(first_Num >= index)
            {
               first_Num = -1;
            }
            cont_Num++;
         }
         return first_Num;
      }
      
      public static function replaceStrng(__xml_str:String, first_str:String, secondly_str:String) : String
      {
         return __xml_str.split(first_str).join(secondly_str);
      }
      
      public static function filterReplaceStrng(__xml_str:String, first_str:String, secondly_str:String) : String
      {
         var first_Num:int = 0;
         var Total_Num:int = 0;
         var index:int = 0;
         var asc1:String = "";
         var asc2:String = "";
         while(first_Num >= 0)
         {
            first_Num = __xml_str.indexOf(first_str,index);
            if(first_Num <= -1)
            {
               break;
            }
            asc1 = __xml_str.charAt(first_Num - 1);
            asc2 = __xml_str.charAt(first_Num + first_str.length);
            if(isSign(asc1) && isSign(asc2))
            {
               __xml_str = __xml_str.substring(0,first_Num) + secondly_str + __xml_str.substring(first_Num + first_str.length);
               index = first_Num + secondly_str.length;
            }
            else
            {
               index = first_Num + first_str.length;
            }
            Total_Num++;
         }
         return __xml_str;
      }
      
      private static function isSign(__xml_str:String) : Boolean
      {
         var asc:int = __xml_str.charCodeAt(0);
         if(Boolean(asc > 31 && asc < 48) || Boolean(asc > 57 && asc < 65) || Boolean(asc > 90 && asc < 95) || Boolean(asc > 122 && asc < 127))
         {
            return true;
         }
         return false;
      }
      
      public static function popTotal(__xml_str:String, first_str:String, index:int = 0) : int
      {
         var first_Num:int = 0;
         var Total_Num:int = 0;
         while(first_Num >= 0)
         {
            first_Num = __xml_str.indexOf(first_str,index);
            index = first_Num + first_str.length;
            Total_Num++;
         }
         return Total_Num - 1;
      }
      
      public static function popString(__xml_str:String, first_str:String, secondly_str:String, index:int = 0, oo:Boolean = true) : String
      {
         var first_Num:int = 0;
         var secondly_Num:int = 0;
         if(oo)
         {
            first_Num = __xml_str.indexOf(first_str,index);
            secondly_Num = __xml_str.indexOf(secondly_str,first_Num);
            if(first_Num > -1 && secondly_Num > -1)
            {
               __xml_str = __xml_str.slice(first_Num,secondly_Num + secondly_str.length);
            }
            else
            {
               __xml_str = undefined;
            }
         }
         else
         {
            first_Num = __xml_str.indexOf(first_str,index);
            secondly_Num = __xml_str.indexOf(secondly_str,first_Num);
            if(first_Num > -1 && secondly_Num > -1)
            {
               __xml_str = __xml_str.slice(first_Num + first_str.length,secondly_Num);
            }
            else
            {
               __xml_str = undefined;
            }
         }
         return __xml_str;
      }
      
      public static function popArray(__xml_str:String, first_str:String, secondly_str:String, oo:Boolean = true, pn:Boolean = true) : Array
      {
         var first_Num:int = 0;
         var secondly_Num:int = 0;
         var Total:int = 0;
         var this_Array:Array = new Array();
         var index:int = 0;
         var last_Num:int = __xml_str.lastIndexOf(first_str);
         var first_Max:int = Number(first_str.length);
         var secondly_Max:int = Number(secondly_str.length);
         var i:int = 0;
         if(oo)
         {
            if(pn)
            {
               index = __xml_str.indexOf(secondly_str,index);
               if(index > -1)
               {
                  Total = popTotal(__xml_str,secondly_str);
                  trace(!Total ? "找不到 " + secondly_str + " 關鍵字" : null);
                  for(i = 0; i < Total; i++)
                  {
                     secondly_Num = __xml_str.indexOf(secondly_str,index);
                     index = secondly_Num + secondly_Max;
                     first_Num = prevIndex(__xml_str,first_str,index);
                     if(first_Num > -1 && secondly_Num > -1)
                     {
                        this_Array.push(__xml_str.substring(first_Num,secondly_Num + secondly_Max));
                     }
                  }
               }
               return this_Array;
            }
            Total = popTotal(__xml_str,first_str);
            if(Total > 0)
            {
               trace(!Total ? "找不到 " + first_str + " 關鍵字" : null);
               for(i = 0; i < Total; i++)
               {
                  first_Num = __xml_str.indexOf(first_str,index);
                  secondly_Num = __xml_str.indexOf(secondly_str,first_Num);
                  index = secondly_Num;
                  if(first_Num > -1 && secondly_Num > -1)
                  {
                     this_Array.push(__xml_str.substring(first_Num,secondly_Num + secondly_Max));
                  }
               }
            }
            else
            {
               trace("找不到 " + first_str + " 關鍵字");
            }
            return this_Array;
         }
         if(pn)
         {
            index = __xml_str.indexOf(secondly_str,index);
            if(index > -1)
            {
               Total = popTotal(__xml_str,secondly_str);
               trace(!Total ? "找不到 " + secondly_str + " 關鍵字" : null);
               for(i = 0; i < Total; i++)
               {
                  secondly_Num = __xml_str.indexOf(secondly_str,index);
                  index = secondly_Num + secondly_Max;
                  first_Num = prevIndex(__xml_str,first_str,index);
                  if(first_Num > -1 && secondly_Num > -1)
                  {
                     this_Array.push(__xml_str.substring(first_Num + first_Max,secondly_Num));
                  }
               }
            }
            return this_Array;
         }
         Total = popTotal(__xml_str,first_str);
         if(Total > 0)
         {
            for(i = 0; i < Total; i++)
            {
               first_Num = __xml_str.indexOf(first_str,index);
               secondly_Num = __xml_str.indexOf(secondly_str,first_Num);
               index = secondly_Num;
               if(first_Num > -1 && secondly_Num > -1)
               {
                  this_Array.push(__xml_str.substring(first_Num + first_Max,secondly_Num));
               }
            }
         }
         else
         {
            trace("找不到 " + first_str + " 關鍵字");
         }
         return this_Array;
      }
   }
}

