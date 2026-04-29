package com.module.digTreasure.data
{
   import com.core.loading.Loading;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.system.ApplicationDomain;
   
   public class DigTreasureConfig extends EventDispatcher
   {
      
      private static var _instance:DigTreasureConfig;
      
      public static const TYPE_MINE:int = 1;
      
      public static const TYPE_BOSS:int = 2;
      
      public static const TYPE_EVENT:int = 3;
      
      public static const TYPE_TRIGGER:int = 4;
      
      private static const Config_URL:String = "resource/xml/digTreasure/DigTreasureElement.xml";
      
      private static const Exchange_Treasure_URL:String = "resource/xml/locusXML/DigExchange.xml";
      
      private static const UI_URL:String = "module/digTreasure/DigTreasure.swf";
      
      public static const InitOverEvent:String = "InitOverEvent";
      
      private var _app:ApplicationDomain;
      
      private var _itemConfig:XML;
      
      private var _exchangeConfig:XML;
      
      private var _checkExchangeItems:XMLList;
      
      public var treasuresInfo:XML;
      
      private var _posConfigs:XMLList;
      
      public function DigTreasureConfig()
      {
         super();
      }
      
      public static function get instance() : DigTreasureConfig
      {
         if(_instance == null)
         {
            _instance = new DigTreasureConfig();
         }
         return _instance;
      }
      
      public function get checkExchangeItems() : XMLList
      {
         return this._checkExchangeItems;
      }
      
      public function Init() : void
      {
         var loader:MCLoader = null;
         if(Boolean(this._app) && Boolean(this._itemConfig) && Boolean(this._exchangeConfig))
         {
            this.dispatchEvent(new Event(InitOverEvent));
         }
         else
         {
            loader = new MCLoader(UI_URL,new MovieClip(),Loading.MAIN_LOAD,"正在加載挖寶工具...");
            BC.addOnceEvent(this,loader,MCLoadEvent.ON_SUCCESS,this.LoadUIOverHandler);
            LoaderList.getInstance().addItem(loader,null,LoaderList.HIGHEST_AND_CLOSE_OTHERS,true);
         }
      }
      
      private function LoadUIOverHandler(e:MCLoadEvent) : void
      {
         var loader:MCLoader = e.currentTarget as MCLoader;
         this._app = loader.getLoader().contentLoaderInfo.applicationDomain;
         loader.clear();
         loader = null;
         var configloader:URLLoader = new URLLoader();
         configloader.load(VL.getURLRequest(Config_URL));
         BC.addOnceEvent(this,configloader,Event.COMPLETE,this.LoadConfigOverHandler);
      }
      
      private function LoadConfigOverHandler(e:Event) : void
      {
         this._itemConfig = new XML(e.target.data);
         var exchangeloader:URLLoader = new URLLoader();
         exchangeloader.load(VL.getURLRequest(Exchange_Treasure_URL));
         BC.addOnceEvent(this,exchangeloader,Event.COMPLETE,this.LoadExchangeOverHandler);
      }
      
      private function LoadExchangeOverHandler(e:Event) : void
      {
         this._exchangeConfig = new XML(e.target.data);
         try
         {
            this._checkExchangeItems = this._exchangeConfig.descendants("item").(@check == 1);
         }
         catch(e:Error)
         {
            _checkExchangeItems = _exchangeConfig.descendants("item");
         }
         this.dispatchEvent(new Event(InitOverEvent));
      }
      
      public function GetItemConfig(type:int, id:int) : XML
      {
         var itemsXml:XML = null;
         var item:XML = null;
         var enumType:String = "";
         switch(type)
         {
            case TYPE_MINE:
               enumType = "MineEnum";
               break;
            case TYPE_BOSS:
               enumType = "BossEnum";
               break;
            case TYPE_TRIGGER:
               enumType = "TriggerEnum";
               break;
            case TYPE_EVENT:
               enumType = "EventEnum";
               break;
            default:
               throw new Error("未定義的挖寶類型" + type);
         }
         try
         {
            itemsXml = this._itemConfig.child(enumType)[0];
            item = itemsXml.children().(@ID == id)[0];
            item.toString();
         }
         catch(e:Error)
         {
            throw new Error("沒有定義挖寶點id" + id);
         }
         return item;
      }
      
      public function GetMovieClip(name:String) : MovieClip
      {
         var cls:Class = null;
         if(Boolean(this._app))
         {
            cls = this._app.getDefinition(name) as Class;
            if(Boolean(cls))
            {
               return new cls() as MovieClip;
            }
         }
         return null;
      }
      
      public function GetClass(name:String) : Class
      {
         var cls:Class = null;
         if(Boolean(this._app))
         {
            cls = this._app.getDefinition(name) as Class;
            if(Boolean(cls))
            {
               return cls;
            }
         }
         return null;
      }
      
      public function set posConfig(value:XMLList) : void
      {
         this._posConfigs = value;
      }
      
      public function GetPosConfig(tableId:int, posId:int) : XML
      {
         var posXml:XML = null;
         var table:XML = null;
         try
         {
            table = this._posConfigs.(@ID == tableId)[0];
            posXml = table.children().(@ID == posId)[0];
            posXml.toString();
         }
         catch(e:Error)
         {
            throw new Error("隨機位置解析出錯" + tableId + ":" + posId);
         }
         return posXml;
      }
   }
}

