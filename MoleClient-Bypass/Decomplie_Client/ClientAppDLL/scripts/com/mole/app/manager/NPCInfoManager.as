package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.mole.app.info.NPCInfo;
   
   public class NPCInfoManager
   {
      
      private static var _npcInfoMap:HashMap;
      
      public static const NPC_INFO_LIST_PATH:String = "resource/xml/NPCInfoList.xml";
      
      public function NPCInfoManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _npcInfoMap = new HashMap();
         var resID:uint = DownLoadManager.add(NPC_INFO_LIST_PATH,ResType.STRING,true);
         DownLoadManager.addEvent(resID,onLoadComplete);
      }
      
      private static function onLoadComplete(e:DownLoadEvent) : void
      {
         var npcInfo:NPCInfo = null;
         var infoXml:XML = null;
         var infoListXml:XML = XML(e.data);
         for each(infoXml in infoListXml.children())
         {
            npcInfo = new NPCInfo();
            npcInfo.setBasicInfo(infoXml);
            _npcInfoMap.add(npcInfo.id,npcInfo);
         }
      }
      
      public static function getNPCInfo(id:uint) : NPCInfo
      {
         return _npcInfoMap.getValue(id);
      }
   }
}

