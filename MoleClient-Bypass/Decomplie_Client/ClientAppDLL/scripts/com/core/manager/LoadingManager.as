package com.core.manager
{
   import com.common.data.UILibrary;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   
   public class LoadingManager
   {
      
      private static var _loaderLibrary:UILibrary;
      
      public function LoadingManager()
      {
         super();
      }
      
      public static function setApp(loaderLibrary:ApplicationDomain) : void
      {
         _loaderLibrary = new UILibrary(loaderLibrary);
      }
      
      public static function getMovieClip(str:String) : MovieClip
      {
         return _loaderLibrary.getMovieClip(str);
      }
      
      public static function getSprite(name:String) : Sprite
      {
         return _loaderLibrary.getSprite(name);
      }
   }
}

