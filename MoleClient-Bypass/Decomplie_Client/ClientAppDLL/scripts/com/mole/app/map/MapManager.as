package com.mole.app.map
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.mapEvent.MapEvent;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.task.TaskManager;
   import com.mole.debug.DebugManager;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   
   public class MapManager
   {
      
      public function MapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,onChangeMap);
      }
      
      private static function onChangeMap(e:Event) : void
      {
         DisplayUtil.removeAllChild(LevelManager.mapLevel);
      }
      
      public static function enterMap(mapID:uint, mapType:int = 0, isJump:Boolean = true, isTaskJump:Boolean = true) : Boolean
      {
         var tmpMapID:uint = 0;
         var tmpMapType:uint = 0;
         var p:PeopleManageView = null;
         if(mapID == 344)
         {
            Alert.smileAlart("活動已結束，期待明年暑假吧！");
            return false;
         }
         GV.onlineSocket.dispatchEvent(new ModuleEvent(ModuleEvent.LOAD_COMPLETE,"map_" + String(mapID) + "_" + String(mapType)));
         switch(mapType)
         {
            case 0:
               tmpMapID = mapID;
               tmpMapType = uint(mapType);
               break;
            case 1:
               tmpMapID = analysisMapID(mapID) + GV.TwentyBillion;
               tmpMapType = 0;
               break;
            case 2:
               tmpMapID = analysisMapID(mapID);
               tmpMapType = 0;
               break;
            case 3:
               tmpMapID = analysisMapID(mapID);
               tmpMapType = mapID;
               break;
            default:
               if(DebugManager.DEBUG)
               {
                  Alert.smileAlart("    跳轉地圖類型錯誤：Type=" + mapType);
               }
               return false;
         }
         if(tmpMapID == LocalUserInfo.getMapID() && tmpMapType == LocalUserInfo.getMapType())
         {
            if(isTaskJump == false)
            {
               Alert.smileAlart("    你已經在這裡了，仔細看看週圍有哪些事情吧！");
            }
            else
            {
               MapManageView.inst.addEventListener(Event.INIT,function(evt:Event):void
               {
                  MapManageView.inst.removeEventListener(Event.INIT,arguments.callee);
                  TaskManager.checkEnterMap(MapManager.curMapID);
               });
            }
            return false;
         }
         p = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(mapID < 10000 && mapType == 0) && Boolean(MapsConfig.MapsInfo[mapID]["isNewUserMap"]) && (p.hasAnimal || p.hasCar))
         {
            if(Boolean(p.hasAnimal) && Boolean(p.Animal_Info) && XMLInfo.joinBlackForestAnimal.indexOf(p.Animal_Info.ID) == -1)
            {
               Alert.smileAlart("    拉姆世界很危險，你要把動物送回家，才能進入拉姆世界哦！");
               return false;
            }
            if(p.hasCar)
            {
               Alert.smileAlart("    拉姆世界很危險，你要把車開回家，才能進入拉姆世界哦！");
               return false;
            }
         }
         switchMapLogic.switchMapLogicHandler(tmpMapID,isJump,tmpMapType);
         return true;
      }
      
      private static function analysisMapID(userID:uint) : uint
      {
         if(userID < 50000)
         {
            return LocalUserInfo.getUserID();
         }
         return userID;
      }
      
      public static function get curMapID() : uint
      {
         return LocalUserInfo.getMapID();
      }
      
      public static function set curMapID(value:uint) : void
      {
         LocalUserInfo.setMapID(value);
      }
      
      public static function get curMapType() : uint
      {
         return LocalUserInfo.getMapType();
      }
      
      public static function set curMapType(value:uint) : void
      {
         LocalUserInfo.setMapType(value);
      }
      
      public static function clearMap() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("removeMapEvent"));
         GF.clearPeoples();
         MapManageView.inst.removeMap();
      }
      
      public static function refreshMap() : void
      {
         GV.map_ManagerChange.refreshMap();
      }
   }
}

