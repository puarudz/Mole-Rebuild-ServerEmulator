package com.core.manager
{
   import com.common.data.UILibrary;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.media.Sound;
   import flash.system.ApplicationDomain;
   
   public class UIManager
   {
      
      private static var _uiLibrary:UILibrary = new UILibrary(new ApplicationDomain());
      
      public function UIManager()
      {
         super();
      }
      
      public static function setApp(i:ApplicationDomain) : void
      {
         _uiLibrary = new UILibrary(i);
      }
      
      public static function getApp() : ApplicationDomain
      {
         return _uiLibrary.appDomain;
      }
      
      public static function getClass(str:String) : Class
      {
         return _uiLibrary.getClass(str);
      }
      
      public static function getMovieClip(str:String) : MovieClip
      {
         return _uiLibrary.getMovieClip(str);
      }
      
      public static function getButton(str:String) : SimpleButton
      {
         return _uiLibrary.getSimpleButton(str);
      }
      
      public static function getBitmap(str:String) : Bitmap
      {
         return _uiLibrary.getBitmap(str);
      }
      
      public static function getSound(str:String) : Sound
      {
         return _uiLibrary.getSound(str);
      }
   }
}

