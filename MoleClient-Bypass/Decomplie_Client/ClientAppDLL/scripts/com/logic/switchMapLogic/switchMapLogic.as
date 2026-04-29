package com.logic.switchMapLogic
{
   import com.common.Alert.Alert;
   import com.core.MainEntry;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomReq;
   import com.logic.socket.enterMapOrRoom.EnterMapOrRoomRes;
   import com.logic.socket.leaveMapOrRoom.LeaveMapReq;
   import com.logic.socket.leaveMapOrRoom.LeaveMapRes;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   import com.view.MapManageView.MapManageView;
   import com.view.toolView.toolView;
   import flash.ui.Mouse;
   import org.taomee.manager.TaomeeManager;
   
   public class switchMapLogic
   {
      
      public function switchMapLogic()
      {
         super();
      }
      
      public static function switchMapLogicHandler(mapID:Number, isReset:Boolean = false, mapType:int = 0) : void
      {
         var newInfo:Object = MapsConfig.MapsInfo[mapID];
         if(Boolean(newInfo) && newInfo.hasOwnProperty("isDel"))
         {
            if(newInfo.isDel == true)
            {
               MapManageView.inst.refreshMap();
               return;
            }
         }
         if(mapID == 344)
         {
            Alert.smileAlart("活動已結束，期待明年暑假吧！");
            return;
         }
         if(mapID == 363)
         {
            Alert.smileAlart("活動已經結束了！");
            return;
         }
         var task636State:uint = TaskManager.getTaskState(636);
         if(isReset)
         {
            if(EnterMapOrRoomReq.OldMapID > 1000)
            {
               EnterMapOrRoomReq.OldMapID = 0;
            }
            EnterMapOrRoomReq.OldMapType = 0;
            GV.Room_DefaultRoomID = 0;
         }
         if(GV.isSwitchMap)
         {
            return;
         }
         if(EnterMapOrRoomReq.OldMapID == mapID && EnterMapOrRoomReq.OldMapType == mapType)
         {
            Alert.smileAlart("    你已經在這裡了，仔細看看週圍有哪些事情吧");
            return;
         }
         var oldMapId:Number = LocalUserInfo.getMapID();
         if(oldMapId > 0)
         {
            if(Boolean(MapsConfig.MapsInfo[oldMapId]) && Boolean(MapsConfig.MapsInfo[oldMapId].isLamuWorld))
            {
               toolView.setToolBtns(1,1,1,1,1,1,1,1,1);
            }
         }
         LocalUserInfo.setMapID(mapID);
         LocalUserInfo.setMapType(mapType);
         if(Boolean(MainEntry.instance.gameBg))
         {
            TaomeeManager.stage.addChildAt(MainEntry.instance.gameBg,0);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("removeMapEvent"));
         GV.isSitDown = false;
         GV.isChangeMap = true;
         MoveTo.CanMove = false;
         MoveTo.CanMove2 = false;
         GV.isGameShowTip = false;
         if(Boolean(GV.MC_mapFrame))
         {
            GV.MC_mapFrame.visible = false;
         }
         MoveTo.removeMouseEventToStage();
         sendMapUserID();
      }
      
      private static function sendMapUserID() : void
      {
         GV.onlineSocket.addEventListener(LeaveMapRes.LEAVE_ROOM_MYSELF,getReSult);
         LeaveMapReq.leaveMap();
      }
      
      private static function getReSult(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(LeaveMapRes.LEAVE_ROOM_MYSELF,getReSult);
         GV.onlineSocket.addEventListener(EnterMapOrRoomRes.ENTER_MAP_ROOM,getNewMapReSult);
         EnterMapOrRoomReq.OldGrid = 0;
         EnterMapOrRoomReq.newGrid = LocalUserInfo.getMyInfo_Grid();
         EnterMapOrRoomReq.enterMapRoom();
      }
      
      private static function getNewMapReSult(evt:*) : void
      {
         GV.onlineSocket.removeEventListener(EnterMapOrRoomRes.ENTER_MAP_ROOM,getNewMapReSult);
         Mouse.show();
         MoveTo.CanMove = true;
         MoveTo.CanMove2 = true;
         GV.peopleTouchArray = null;
         loginNewMap();
      }
      
      private static function loginNewMap() : void
      {
         GV.map_ManagerChange.changeMap(MapManager.curMapID,MapManager.curMapType);
         MoveTo.CanMove = true;
      }
      
      public static function GoHomeMap(userID:int) : void
      {
         MapManager.enterMap(userID,1);
      }
   }
}

