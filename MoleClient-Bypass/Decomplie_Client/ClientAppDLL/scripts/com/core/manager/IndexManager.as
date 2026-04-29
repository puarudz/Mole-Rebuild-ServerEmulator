package com.core.manager
{
   import com.common.data.UILibrary;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.system.ApplicationDomain;
   
   public class IndexManager
   {
      
      private static var instance:IndexManager;
      
      private var _appLibrary:UILibrary;
      
      public function IndexManager()
      {
         super();
      }
      
      public static function getInstance() : IndexManager
      {
         if(instance == null)
         {
            instance = new IndexManager();
         }
         return instance;
      }
      
      public function setIndexApp2(i:ApplicationDomain) : void
      {
         this._appLibrary = new UILibrary(i);
      }
      
      public function getMovieClip(str:String) : MovieClip
      {
         return this._appLibrary.getMovieClip(str);
      }
      
      public function getSimpleButton(str:String) : SimpleButton
      {
         return this._appLibrary.getSimpleButton(str);
      }
      
      public function getBitmap(str:String) : Bitmap
      {
         return this._appLibrary.getBitmap(str);
      }
      
      public function get appLibrary() : UILibrary
      {
         return this._appLibrary;
      }
   }
}

