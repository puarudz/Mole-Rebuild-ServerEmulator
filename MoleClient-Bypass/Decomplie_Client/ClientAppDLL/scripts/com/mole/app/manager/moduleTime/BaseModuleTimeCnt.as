package com.mole.app.manager.moduleTime
{
   import com.common.data.HashMap;
   import com.global.staticData.XMLInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BaseModuleTimeCnt extends EventDispatcher
   {
      
      private var _infoHash:HashMap;
      
      public function BaseModuleTimeCnt()
      {
         var xmlinfo:XML = null;
         var info:ModuleTimeInfo = null;
         super();
         this._infoHash = new HashMap();
         var xml:XML = XML(new XMLInfo.moduleTimeClass());
         var infoXMLList:XMLList = xml.children();
         for each(xmlinfo in infoXMLList)
         {
            info = new ModuleTimeInfo(xmlinfo);
            this._infoHash.add(info.name,info);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function hasModueName(moduleName:String) : Boolean
      {
         return this._infoHash.containsKey(moduleName);
      }
      
      public function getModuleInfo(moduleName:String) : ModuleTimeInfo
      {
         return this._infoHash.getValue(moduleName);
      }
   }
}

