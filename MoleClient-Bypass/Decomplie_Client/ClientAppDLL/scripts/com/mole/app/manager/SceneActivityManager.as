package com.mole.app.manager
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class SceneActivityManager extends EventDispatcher
   {
      
      public static const SCENE_ACTIVITY_BROADCAST:String = "SCENE_ACTIVITY_BROADCAST";
      
      public static const SCENE_ACTIVITY_SEAT:String = "SCENE_ACTIVITY_SEAT";
      
      public static const SCENE_ACTIVITY_AWARD:String = "SCENE_ACTIVITY_AWARD";
      
      public static const SCENE_ACTIVITY_SEND_RESULT:String = "SCENE_ACTIVITY_SEND_RESULT";
      
      public var useDataVec:Vector.<Object>;
      
      public var activityId:uint;
      
      private var isSendSeat:Boolean;
      
      public var sceneActivityBroadcast:uint = 8697;
      
      public var sceneActivitySeat:uint = 8698;
      
      public var sceneActivityAward:uint = 8699;
      
      public var sceneActivitySendResult:uint = 8711;
      
      public function SceneActivityManager()
      {
         super();
         this.useDataVec = new Vector.<Object>();
      }
      
      public function enterMap(activityId:uint) : void
      {
         this.activityId = activityId;
         GV.onlineSocket.addCmdListener(this.sceneActivityBroadcast,this.activityBroadcast);
         GF.sendSocket(this.sceneActivityBroadcast,activityId);
         GV.onlineSocket.addCmdListener(this.sceneActivityAward,this.activityAward);
      }
      
      private function activityBroadcast(evt:SocketEvent) : void
      {
         dispatchEvent(new EventTaomee(SCENE_ACTIVITY_BROADCAST,evt.data));
      }
      
      public function seat(seatId:uint, actArea:int = 1, isLeave:Boolean = false) : void
      {
         if(this.activityId == 0)
         {
            trace("沒有場景活動id");
            return;
         }
         if(!this.isSendSeat)
         {
            this.isSendSeat = true;
            GV.onlineSocket.addCmdListener(this.sceneActivitySeat,this.seatBack);
            GF.sendSocket(this.sceneActivitySeat,this.activityId,actArea,seatId,isLeave ? 0 : 1);
         }
      }
      
      private function seatBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(this.sceneActivitySeat,this.seatBack);
         this.isSendSeat = false;
         var recData:ByteArray = evt.data as ByteArray;
         var activityId:uint = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         var state:uint = recData.readUnsignedInt();
         if(this.activityId == activityId)
         {
            dispatchEvent(new EventTaomee(SCENE_ACTIVITY_SEAT,{
               "flag":flag,
               "state":state
            }));
         }
      }
      
      private function activityAward(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         dispatchEvent(new EventTaomee(SCENE_ACTIVITY_AWARD,recData));
      }
      
      public function sendResult(byteArr:ByteArray) : void
      {
         GV.onlineSocket.addCmdListener(this.sceneActivitySendResult,this.sendResultBack);
         GF.sendSocket(this.sceneActivitySendResult,byteArr);
      }
      
      private function sendResultBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(this.sceneActivitySendResult,this.sendResultBack);
         dispatchEvent(new EventTaomee(SCENE_ACTIVITY_SEND_RESULT,evt.data));
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(this.sceneActivityBroadcast,this.activityBroadcast);
         GV.onlineSocket.removeCmdListener(this.sceneActivitySeat,this.seatBack);
         GV.onlineSocket.removeCmdListener(this.sceneActivityAward,this.activityAward);
         GV.onlineSocket.removeCmdListener(this.sceneActivitySendResult,this.sendResultBack);
         this.useDataVec = null;
      }
   }
}

