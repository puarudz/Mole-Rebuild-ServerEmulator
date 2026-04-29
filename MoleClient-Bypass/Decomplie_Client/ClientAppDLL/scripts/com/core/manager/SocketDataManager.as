package com.core.manager
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class SocketDataManager
   {
      
      private static var _inst:SocketDataManager;
      
      private static const ID_NODE:String = "ID";
      
      private static const ClASS_NODE:String = "class";
      
      private static const ACTION_NODE:String = "action";
      
      private static const STATIC_NODE:String = "static";
      
      private static const DB_NODE:String = "db";
      
      private static const NODE_NODE:String = "note";
      
      private static const FG_NODE:String = "fg";
      
      private var xmlData:XMLList;
      
      private var _dataDict:Dictionary;
      
      public function SocketDataManager(_xml:XMLList)
      {
         super();
         _inst = this;
         this.xmlData = _xml;
         this._dataDict = new Dictionary(true);
         this.parseXML();
      }
      
      public static function get inst() : SocketDataManager
      {
         return _inst;
      }
      
      private function parseXML() : void
      {
         var id:String = null;
         var path:String = null;
         var act:String = null;
         var isStatic:String = null;
         var hasDB:String = null;
         var hasFG:Boolean = false;
         var note:String = null;
         var i:XML = null;
         for each(i in this.xmlData.elements())
         {
            id = i.attribute(ID_NODE).toString();
            path = i.attribute(ClASS_NODE).toString();
            act = i.attribute(ACTION_NODE).toString();
            isStatic = i.attribute(STATIC_NODE).toString();
            hasDB = i.attribute(DB_NODE).toString();
            hasFG = Boolean(i.attribute(FG_NODE).toString());
            note = i.attribute(NODE_NODE).toString();
            this._dataDict["CMD_" + id] = {
               "path":path,
               "action":act,
               "isStatic":isStatic,
               "note":note,
               "db":hasDB,
               "fg":hasFG
            };
         }
      }
      
      public function action(KEY:int) : void
      {
         var instance:* = undefined;
         var cls:* = this.getClass(KEY.toString());
         var act:String = this._dataDict["CMD_" + KEY.toString()]["action"];
         var single:int = int(this._dataDict["CMD_" + KEY.toString()]["isStatic"]);
         if(single == 1)
         {
            cls[act]();
         }
         else
         {
            instance = new cls();
            instance[act]();
            instance = null;
         }
      }
      
      public function send(cmdID:int, act:String, sendParams:Array = null) : void
      {
         var instance:* = undefined;
         var cls:* = this.getClass(cmdID.toString());
         var single:int = int(this._dataDict["CMD_" + cmdID.toString()]["isStatic"]);
         if(single == 1)
         {
            cls[act].apply(null,sendParams);
         }
         else
         {
            instance = new cls();
            instance[act].apply(null,sendParams);
            instance = null;
         }
      }
      
      private function getClass(KEY:String) : *
      {
         var path:String = null;
         if(this._dataDict["CMD_" + KEY] == null)
         {
            throw new Error("SocketData中沒有找到對應的值");
         }
         if(this._dataDict["CMD_" + KEY] != null && this._dataDict["CMD_" + KEY].action == "")
         {
            throw new Error("SocketData中沒有找到對應的值");
         }
         if(KEY == "10001")
         {
            path = this._dataDict["CMD_" + KEY]["path"];
         }
         else
         {
            path = "com.logic.socket." + this._dataDict["CMD_" + KEY]["path"];
         }
         return getDefinitionByName(path) as Class;
      }
      
      public function get infoList() : Dictionary
      {
         return this._dataDict;
      }
      
      public function get dataDict() : Dictionary
      {
         return this._dataDict;
      }
      
      public function getInfo(cmdID:uint) : Object
      {
         return this._dataDict["CMD_" + cmdID];
      }
   }
}

