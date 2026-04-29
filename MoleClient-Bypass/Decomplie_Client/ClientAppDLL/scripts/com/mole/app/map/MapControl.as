package com.mole.app.map
{
   import com.common.data.HashMap;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.MapInfo;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.manager.KFCStatisticsManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.map.info.MapTalkInfo;
   import com.mole.app.map.object.MapNPCObject;
   import com.mole.app.map.object.MapObjectBase;
   import com.mole.app.map.object.MapTriggerObject;
   import com.mole.app.type.ActionType;
   import com.mole.debug.DebugManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   
   public class MapControl extends EventDispatcher
   {
      
      public static const MAP_XML_COMPLETE:String = "map_xml_complete";
      
      public static const MAP_CONFIG_PATH:String = "resource/map/";
      
      private var _mapID:uint;
      
      private var _objList:Array;
      
      private var _talkMap:HashMap;
      
      private var _map:MapBase;
      
      private var _materialBase:MapMaterialBase;
      
      private var xmlIsLoaded:Boolean;
      
      public function MapControl(materialBase:MapMaterialBase, appDomain:ApplicationDomain)
      {
         var tempClass:Class = null;
         super();
         this._materialBase = materialBase;
         this._mapID = MapManager.curMapID;
         this._objList = new Array();
         this._talkMap = new HashMap();
         var currentMapInfo:MapInfo = MapInfo.currentMapInfo();
         var mapClassPath:String = "com.view.mapView.";
         if(this.mapID <= 1000)
         {
            if(Boolean(currentMapInfo))
            {
               PeopleManager.isHideMount = currentMapInfo.hideMount;
               if(ApplicationDomain.currentDomain.hasDefinition(mapClassPath + currentMapInfo.className))
               {
                  tempClass = ApplicationDomain.currentDomain.getDefinition(mapClassPath + currentMapInfo.className) as Class;
                  this._map = new tempClass() as MapBase;
                  if(Boolean(this._map))
                  {
                     this._map.setLibrary(appDomain);
                  }
               }
            }
            else
            {
               DebugManager.traceMsg("沒有相關地圖配置資訊,地圖ID為" + this.mapID,false);
            }
         }
         var resID:uint = DownLoadManager.add(MAP_CONFIG_PATH + "Map_" + (10000 + this._mapID) + ".xml",ResType.STRING,true);
         DownLoadManager.addEvent(resID,this.onLoadComplete,null,null,this.onLoadFail);
         KFCStatisticsManager.update();
      }
      
      public function get mapID() : uint
      {
         return this._mapID;
      }
      
      private function onLoadComplete(e:DownLoadEvent) : void
      {
         var npcXmlList:XMLList;
         var npcObj:MapNPCObject = null;
         var npcXml:XML = null;
         var mapObj:MapTriggerObject = null;
         var triggerXmlList:XMLList = null;
         var triggerXml:XML = null;
         var talkXMLList:XMLList = null;
         var talkInfo:MapTalkInfo = null;
         var talkXml:XML = null;
         var mapXml:XML = null;
         try
         {
            mapXml = XML(e.data);
         }
         catch(e:Error)
         {
            DebugManager.traceMsg("地圖配表解析錯誤，請檢查！\nMapID-->" + _mapID);
            return;
         }
         npcXmlList = mapXml.NpcList;
         for each(npcXml in npcXmlList.children())
         {
            npcObj = new MapNPCObject(npcXml);
            this._objList.push(npcObj);
         }
         triggerXmlList = mapXml.Triggers;
         for each(triggerXml in triggerXmlList.children())
         {
            mapObj = new MapTriggerObject(triggerXml);
            this._objList.push(mapObj);
         }
         talkXMLList = mapXml.Talks;
         for each(talkXml in talkXMLList.children())
         {
            talkInfo = new MapTalkInfo();
            talkInfo.initXml(talkXml);
            this._talkMap.add(talkInfo.id,talkInfo);
         }
         this.xmlIsLoaded = true;
         this.mapXmlLoaderComplete();
      }
      
      private function mapXmlLoaderComplete() : void
      {
         dispatchEvent(new Event(MapControl.MAP_XML_COMPLETE));
      }
      
      public function init() : void
      {
         if(Boolean(this._map))
         {
            this._map.init();
         }
         if(Boolean(this._materialBase))
         {
            this._materialBase.initPeople();
         }
      }
      
      public function getNpcDialogInfo(id:uint) : NPCDialogInfo
      {
         var talkInfo:MapTalkInfo = this._talkMap.getValue(id);
         return talkInfo.npcDialogInfo;
      }
      
      public function getNpcDialogInfoForMachine(id:uint) : NPCDialogInfo
      {
         var talkInfo:MapTalkInfo = this._talkMap.getValue(id);
         return talkInfo.npcDialogInfoForMachine;
      }
      
      private function onLoadFail(e:DownLoadEvent) : void
      {
         this.mapXmlLoaderComplete();
      }
      
      public function destroy() : void
      {
         var npcObj:MapObjectBase = null;
         for each(npcObj in this._objList)
         {
            npcObj.destroy();
         }
         this._objList = null;
         if(Boolean(this._materialBase))
         {
            this._materialBase.destroy();
            this._materialBase = null;
         }
         if(Boolean(this._map))
         {
            this._map.destroy();
            this._map = null;
         }
         this._talkMap.clear();
         this._talkMap = null;
      }
      
      public function get map() : MapBase
      {
         return this._map;
      }
      
      public function getMapNPCObjectByNPCID(npcID:uint) : MapNPCObject
      {
         var mapNPC:MapNPCObject = null;
         for(var i:int = 0; i < this._objList.length; i++)
         {
            if(this._objList[i] is MapNPCObject)
            {
               mapNPC = this._objList[i];
               if(npcID == mapNPC.mapNpcInfo.npcInfo.id)
               {
                  return mapNPC;
               }
            }
         }
         return null;
      }
      
      public function addNPCObject(npcXml:XML) : MapNPCObject
      {
         var talkInfo:MapTalkInfo = null;
         var npcObj:MapNPCObject = null;
         var xml:XML = <Npc ID="10000" Layer="depthLevel" Name="摩樂樂" Ex="0" Ey="0" Px="0" Py="0" Cmd="s" Param="0" AddTaskOption="1"/>;
         xml.@ID = npcXml.@ID;
         xml.@Layer = npcXml.@Layer;
         xml.@Name = npcXml.@Name;
         xml.@Ex = npcXml.@Ex;
         xml.@Ey = npcXml.@Ey;
         xml.@Px = npcXml.@Px;
         xml.@Py = npcXml.@Py;
         xml.@Cmd = ActionType.MAP_SAY;
         xml.@Param = 0;
         xml.@AddTaskOption = 1;
         var talkXml:XML = <Talk ID="1" NpcID="10022" Face="正常" Msg="我最擅長看護家園中的植物和牧場的動物了." Option="我知道了" Cmd="none" Param="0" AddTaskOption="1"/>;
         talkXml.@ID = 0;
         talkXml.@NpcID = npcXml.@ID;
         talkXml.@Face = "正常";
         talkXml.@Msg = npcXml.@Msg;
         talkXml.@Option = "";
         talkXml.@Cmd = ActionType.NONE;
         talkXml.@Param = 0;
         talkXml.@AddTaskOption = 1;
         talkInfo = new MapTalkInfo();
         talkInfo.initXml(talkXml);
         this._talkMap.add(talkInfo.id,talkInfo);
         npcObj = new MapNPCObject(xml);
         this._objList.push(npcObj);
         return npcObj;
      }
   }
}

