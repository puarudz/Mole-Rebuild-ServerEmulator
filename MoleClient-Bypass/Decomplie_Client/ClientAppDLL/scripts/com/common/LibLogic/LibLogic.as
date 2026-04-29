package com.common.LibLogic
{
   import com.common.data.UILibrary;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.getDefinitionByName;
   
   public class LibLogic
   {
      
      private var _mapUI_Lib:UILibrary;
      
      private var _mapLoader:Loader;
      
      public function LibLogic(lb:*)
      {
         super();
         if(lb is Loader)
         {
            this._mapLoader = lb;
            this._mapUI_Lib = new UILibrary(this._mapLoader.contentLoaderInfo.applicationDomain);
         }
      }
      
      public static function getLibClass(loader:Loader, className:String) : Class
      {
         return loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
      }
      
      public static function getLibClassInstacen(loader:Loader, className:String) : *
      {
         var lc:* = getLibClass(loader,className);
         return new lc();
      }
      
      public static function addLibEvent_getIcon(loader:Loader, listenerName:String, itemID:int) : void
      {
         var loadIconsFun:Function = null;
         var delEventsFun:Function = null;
         loadIconsFun = function(E:*):void
         {
            var mc:Sprite = E.EventObj as Sprite;
            var GoodsInfo:* = getDefinitionByName("com.common.data.goodsInfo.GoodsInfo");
            var l:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(E:IOErrorEvent):void
            {
               trace("addLibEvent_getIcon:找不到" + itemID + ".\n" + E);
            });
            l.load(VL.getURLRequest(GoodsInfo.GetFullURLByItemId(itemID)));
            mc.addChild(l);
            loader.removeEventListener(Event.REMOVED_FROM_STAGE,delEventsFun);
            loader.removeEventListener(listenerName,loadIconsFun);
         };
         delEventsFun = function(E:Event):void
         {
            loader.removeEventListener(Event.REMOVED_FROM_STAGE,delEventsFun);
            loader.contentLoaderInfo.sharedEvents.removeEventListener(listenerName,loadIconsFun);
         };
         loader.addEventListener(Event.REMOVED_FROM_STAGE,delEventsFun);
         loader.contentLoaderInfo.sharedEvents.addEventListener(listenerName,loadIconsFun);
      }
      
      public function getClass(className:String) : Class
      {
         return this._mapUI_Lib.getClass(className);
      }
      
      public function getMovieClip(className:String) : Sprite
      {
         return this._mapUI_Lib.getSprite(className);
      }
      
      public function getRoot() : *
      {
         return this._mapLoader.content.root;
      }
   }
}

