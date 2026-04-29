package com.logic.socket.petSocket.learnPet
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   
   public class BeginLearnReq extends BaseOnlineSocketRequest
   {
      
      public function BeginLearnReq()
      {
         super();
      }
      
      public static function setClass(Arr:Array) : void
      {
         var Count:uint = Arr.length;
         MsgHead.Result = 0;
         MsgHead.PkgLen = 18 + uint(Count * 10);
         initAction(CommandID.PETLEARNSTART);
         GV.onlineSocket.writeByte(Count);
         var has:Boolean = false;
         for(var i:uint = 0; i < Count; i++)
         {
            trace(Arr[i].petID,"@@petID",i);
            trace(Arr[i].classID,"@@classID",i);
            trace(Arr[i].days,"@@days",i);
            GV.onlineSocket.writeUnsignedInt(Arr[i].petID);
            GV.onlineSocket.writeUnsignedInt(Arr[i].classID);
            GV.onlineSocket.writeShort(Arr[i].days);
            if(Arr[i].classID >= 1)
            {
               has = true;
            }
         }
         flush();
         if(has)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("newUser_petclass"));
         }
      }
   }
}

