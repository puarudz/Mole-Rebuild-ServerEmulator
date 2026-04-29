package com.common.data
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.media.Sound;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class UILibrary
   {
      
      private static var _bmdPacket:Dictionary = new Dictionary(true);
      
      private var _appDomain:ApplicationDomain;
      
      public function UILibrary(appDomain:ApplicationDomain)
      {
         super();
         this._appDomain = appDomain;
      }
      
      public function getMovieClip(name:String) : MovieClip
      {
         var r:DisplayObject = this.getDisplayObject(name);
         return r == null ? null : r as MovieClip;
      }
      
      public function getSprite(name:String) : Sprite
      {
         var r:DisplayObject = this.getDisplayObject(name);
         return r == null ? null : r as Sprite;
      }
      
      public function getBitmap(name:String) : Bitmap
      {
         var bit:DisplayObject = this.getDisplayObject(name);
         return bit as Bitmap;
      }
      
      public function getSimpleButton(name:String) : SimpleButton
      {
         var r:DisplayObject = this.getDisplayObject(name);
         return r == null ? null : r as SimpleButton;
      }
      
      public function getSound(name:String) : Sound
      {
         var classReference:Class = this.getClass(name);
         if(Boolean(classReference))
         {
            return new classReference() as Sound;
         }
         return null;
      }
      
      public function getBitmapData(name:String, isCache:Boolean = false) : BitmapData
      {
         var classReference:Class;
         var bmd:BitmapData = null;
         if(Boolean(_bmdPacket[name]))
         {
            return _bmdPacket[name];
         }
         classReference = this.getClass(name);
         if(Boolean(classReference))
         {
            try
            {
               bmd = new classReference(0,0) as BitmapData;
            }
            catch(e:Error)
            {
               trace("UILibrary getBitmapDataFromLoader error:" + e.toString());
            }
            if(isCache)
            {
               if(Boolean(bmd))
               {
                  _bmdPacket[name] = bmd;
               }
            }
            return bmd;
         }
         return null;
      }
      
      public function getClass(name:String) : Class
      {
         if(this._appDomain.hasDefinition(name))
         {
            return this._appDomain.getDefinition(name) as Class;
         }
         trace("UILibrary getClassFromLoader not hasDefinition:" + name);
         return null;
      }
      
      public function getDisplayObject(name:String) : DisplayObject
      {
         var classReference:Class = this.getClass(name);
         if(classReference == null)
         {
            return null;
         }
         try
         {
            return new classReference() as DisplayObject;
         }
         catch(e:Error)
         {
            trace("UILibrary getDisplayObjectFromLoader error:" + e.toString());
            return null;
         }
      }
      
      public function getClassByObject(obj:DisplayObject) : Class
      {
         var mcs:Class = null;
         try
         {
            mcs = this.getClass(getQualifiedClassName(obj)) as Class;
         }
         catch(e:Error)
         {
            trace("getClass " + obj.toString() + "error" + e.message);
            return null;
         }
         return mcs;
      }
      
      public function get appDomain() : ApplicationDomain
      {
         return this._appDomain;
      }
      
      public function set appDomain(value:ApplicationDomain) : void
      {
         this._appDomain = value;
      }
   }
}

