package com.core.gameSimulator
{
   import com.global.links.Links;
   
   public class ConnectionData
   {
      
      public var gameID:uint;
      
      public var userID:uint;
      
      public var version:String;
      
      public var regversion:String;
      
      public var indexversion:String;
      
      public var uiversion:String;
      
      public var mapversion:String;
      
      public var moduleversion:String;
      
      public var dllArray:Array;
      
      public var SessionObj:Object;
      
      public function ConnectionData(_gameID:uint, _SessionObj:Object = null)
      {
         super();
         this.gameID = _gameID;
         this.userID = GV.MyInfo_userID;
         GV.dllArrayByte.position = 0;
         this.dllArray = GV.dllArrayByte.readObject();
         this.SessionObj = _SessionObj;
         this.version = Links.version;
         this.regversion = Links.regversion;
         this.indexversion = Links.indexversion;
         this.uiversion = Links.uiversion;
         this.mapversion = Links.mapversion;
         this.moduleversion = Links.moduleversion;
      }
      
      public static function getInstanceByData(data:*) : ConnectionData
      {
         var name:String = null;
         var t:ConnectionData = new ConnectionData(0);
         for(name in data)
         {
            t[name] = data[name];
         }
         return t;
      }
      
      public function toString() : void
      {
         throw "Test";
      }
   }
}

