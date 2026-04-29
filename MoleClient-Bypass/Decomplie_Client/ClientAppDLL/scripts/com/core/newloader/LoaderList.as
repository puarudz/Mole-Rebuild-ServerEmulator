package com.core.newloader
{
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.utils.Proxy;
   
   public class LoaderList extends Proxy
   {
      
      private static var _inst:LoaderList;
      
      public static var HIGHEST_AND_CLOSE_OTHERS:uint = 1;
      
      public static var HIGH:uint = 2;
      
      public static var STANDARD:uint = 3;
      
      public static var LOW:uint = 4;
      
      public static var LOWEST:uint = 5;
      
      public static var Max_LoaderNum:uint = 10;
      
      public static var Status:uint = 0;
      
      public function LoaderList()
      {
         super();
      }
      
      public static function getInstance() : LoaderList
      {
         if(_inst == null)
         {
            _inst = new LoaderList();
         }
         return _inst;
      }
      
      public static function getPRI_Obj(_PRI_Num:int = 3, _beforeArrayBool:Boolean = false) : Object
      {
         return {
            "PRI_Num":_PRI_Num,
            "beforeArrayBool":_beforeArrayBool
         };
      }
      
      public function addItem(_loader:*, _urlReq:URLRequest, _pri:int = 3, beforeArrayBool:Boolean = false) : void
      {
         if(Boolean(_loader as Loader) && Boolean(_urlReq as URLRequest))
         {
            Loader(_loader).load(_urlReq);
         }
         else if(Boolean(_loader as MCLoader))
         {
            MCLoader(_loader).load(_urlReq);
         }
      }
   }
}

