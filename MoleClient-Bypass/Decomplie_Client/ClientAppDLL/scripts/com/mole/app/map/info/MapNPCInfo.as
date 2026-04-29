package com.mole.app.map.info
{
   import com.mole.app.info.MoleActionInfo;
   import com.mole.app.info.NPCInfo;
   import com.mole.app.manager.NPCInfoManager;
   
   public class MapNPCInfo
   {
      
      private var _npcInfo:NPCInfo;
      
      private var _actionInfo:MoleActionInfo;
      
      private var _levelName:String;
      
      public function MapNPCInfo()
      {
         super();
      }
      
      public function initXml(infoXml:XML) : void
      {
         this._npcInfo = new NPCInfo();
         this._npcInfo = NPCInfoManager.getNPCInfo(uint(infoXml.@ID));
         this._npcInfo.setLocationInMap(infoXml.@Px,infoXml.@Py);
         this._actionInfo = new MoleActionInfo();
         this._actionInfo.initXML(infoXml);
         this._levelName = String(infoXml.@Layer);
      }
      
      public function get npcInfo() : NPCInfo
      {
         return this._npcInfo;
      }
      
      public function get actionInfo() : MoleActionInfo
      {
         return this._actionInfo;
      }
      
      public function get levelName() : String
      {
         return this._levelName;
      }
   }
}

