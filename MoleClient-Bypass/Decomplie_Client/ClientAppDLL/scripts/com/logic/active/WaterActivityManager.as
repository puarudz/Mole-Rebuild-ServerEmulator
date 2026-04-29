package com.logic.active
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class WaterActivityManager extends EventDispatcher
   {
      
      public static const WATER_ACTIVITY_BROADCAST:String = "WATER_ACTIVITY_BROADCAST";
      
      public static const WATER_ACTIVITY_SEAT:String = "WATER_ACTIVITY_SEAT";
      
      public static const WATER_ACTIVITY_AWARD:String = "WATER_ACTIVITY_AWARD";
      
      public static const WATER_ACTIVITY_SEND_RESULT:String = "WATER_ACTIVITY_SEND_RESULT";
      
      public var useDataVec:Vector.<Object>;
      
      public var activityId:uint;
      
      private var isSendSeat:Boolean;
      
      public function WaterActivityManager()
      {
         super();
         this.useDataVec = new Vector.<Object>();
      }
      
      public function enterMap(activityId:uint) : void
      {
         this.activityId = activityId;
         GV.onlineSocket.addCmdListener(CommandID.CANNON_ACTY_BROADCAST,this.activityBroadcast);
         GF.sendSocket(CommandID.CANNON_ACTY_BROADCAST,activityId);
         GV.onlineSocket.addCmdListener(CommandID.CANNON_ACTY_AWARD,this.activityAward);
      }
      
      private function activityAward(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         dispatchEvent(new EventTaomee(WATER_ACTIVITY_AWARD,recData));
      }
      
      private function activityBroadcast(evt:SocketEvent) : void
      {
         dispatchEvent(new EventTaomee(WATER_ACTIVITY_BROADCAST,evt.data));
      }
      
      public function seat(seatId:uint, isLeave:Boolean = false) : void
      {
         if(this.activityId == 0)
         {
            trace("沒有場景活動id");
            return;
         }
         if(!this.isSendSeat)
         {
            this.isSendSeat = true;
            GV.onlineSocket.addCmdListener(CommandID.CANNON_ACTY_SEAT,this.seatBack);
            GF.sendSocket(CommandID.CANNON_ACTY_SEAT,this.activityId,1,seatId,isLeave ? 0 : 1);
         }
      }
      
      private function seatBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_SEAT,this.seatBack);
         this.isSendSeat = false;
         var recData:ByteArray = evt.data as ByteArray;
         var activityId:uint = recData.readUnsignedInt();
         var flag:uint = recData.readUnsignedInt();
         var state:uint = recData.readUnsignedInt();
         if(this.activityId == activityId)
         {
            dispatchEvent(new EventTaomee(WATER_ACTIVITY_SEAT,{
               "flag":flag,
               "state":state
            }));
         }
      }
      
      public function sendResult(stone:uint) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.CANNON_ACTY_SEND_RESULT,this.sendResultBack);
         GF.sendSocket(CommandID.CANNON_ACTY_SEND_RESULT,stone);
      }
      
      private function sendResultBack(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_SEND_RESULT,this.sendResultBack);
         dispatchEvent(new EventTaomee(WATER_ACTIVITY_SEND_RESULT,evt.data));
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_BROADCAST,this.activityBroadcast);
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_BROADCAST,this.seatBack);
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_SEND_RESULT,this.sendResultBack);
         GV.onlineSocket.removeCmdListener(CommandID.CANNON_ACTY_AWARD,this.activityAward);
         this.useDataVec = null;
      }
   }
}

