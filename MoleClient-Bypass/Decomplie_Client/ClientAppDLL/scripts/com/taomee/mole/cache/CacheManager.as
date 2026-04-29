package com.taomee.mole.cache
{
   import flash.system.ApplicationDomain;
   import org.taomee.loader.LoadType;
   
   public class CacheManager
   {
      
      private static var _phasor:PhasorCache;
      
      private static var _image:ImageCache;
      
      private static var _text:TextCache;
      
      private static var _sheet:SheetCache;
      
      public function CacheManager()
      {
         super();
      }
      
      private static function getPhasor() : PhasorCache
      {
         if(_phasor == null)
         {
            _phasor = new PhasorCache();
            _phasor.maxCount = 500;
         }
         return _phasor;
      }
      
      private static function getImage() : ImageCache
      {
         if(_image == null)
         {
            _image = new ImageCache();
            _image.maxCount = 500;
         }
         return _image;
      }
      
      private static function getText() : TextCache
      {
         if(_text == null)
         {
            _text = new TextCache();
            _text.maxCount = 500;
         }
         return _text;
      }
      
      public static function getPhasorContent(uid:String, name:String, complete:Function, error:Function = null, data:* = null, priority:int = 1, open:Function = null, progress:Function = null) : void
      {
         getPhasor().getContent(uid,LoadType.DOMAIN,name,complete,error,data,priority,open,progress);
      }
      
      public static function getImageContent(uid:String, name:String, complete:Function, error:Function = null, data:* = null, priority:int = 1, open:Function = null, progress:Function = null) : void
      {
         getImage().getContent(uid,LoadType.IMAGE,name,complete,error,data,priority,open,progress);
      }
      
      public static function getTextContent(uid:String, name:String, complete:Function, error:Function = null, data:* = null, priority:int = 1, open:Function = null, progress:Function = null) : void
      {
         getText().getContent(uid,LoadType.TEXT,name,complete,error,data,priority,open,progress);
      }
      
      public static function cancelText(uid:String, complete:Function) : void
      {
         if(_text != null)
         {
            _text.cancel(uid,complete);
         }
      }
      
      public static function cancelPhasor(uid:String, complete:Function) : void
      {
         if(_phasor != null)
         {
            _phasor.cancel(uid,complete);
         }
      }
      
      public static function cancelImage(uid:String, complete:Function) : void
      {
         if(_image != null)
         {
            _image.cancel(uid,complete);
         }
      }
      
      public static function clearPhasor() : void
      {
         if(_phasor != null)
         {
            _phasor.clear();
         }
      }
      
      private static function getSheet() : SheetCache
      {
         if(_sheet == null)
         {
            _sheet = new SheetCache();
            _sheet.maxCount = 500;
         }
         return _sheet;
      }
      
      public static function getSheetContent(uid:String, complete:Function, error:Function = null, data:* = null, priority:int = 2, open:Function = null, progress:Function = null) : void
      {
         getSheet().getContent(uid,LoadType.DOMAIN,"",complete,error,data,priority,open,progress);
      }
      
      public static function getSheetContentFromDomain(uid:String, domain:ApplicationDomain, complete:Function, error:Function = null, data:* = null) : void
      {
         getSheet().getContentFromDomain(uid,domain,complete,error,data);
      }
      
      public static function cancelSheet(uid:String, complete:Function) : void
      {
         if(_sheet != null)
         {
            _sheet.cancel(uid,complete);
         }
      }
      
      public static function clearSheet() : void
      {
         if(_sheet != null)
         {
            _sheet.clear();
         }
      }
      
      public static function disconnectSheet(uid:String) : void
      {
         if(_sheet != null)
         {
            _sheet.disconnect(uid);
         }
      }
   }
}

