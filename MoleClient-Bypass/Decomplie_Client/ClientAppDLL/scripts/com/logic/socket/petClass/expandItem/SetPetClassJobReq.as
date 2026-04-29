package com.logic.socket.petClass.expandItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   
   public class SetPetClassJobReq extends BaseOnlineSocketRequest
   {
      
      public function SetPetClassJobReq()
      {
         super();
      }
      
      public static function SetInfo(petID:uint, classID:uint, jobArr:Array) : void
      {
         MsgHead.PkgLen = 17 + 12;
         initAction(CommandID.PET_CLASSJOB_SET);
         if(classID == 101)
         {
            setClassJob(petID,classID,jobArr);
         }
         if(classID == 102)
         {
            setClassJob(petID,classID,jobArr);
         }
         if(classID == 103)
         {
            setClassJob(petID,classID,jobArr);
         }
         if(classID == 104)
         {
            setClassJob(petID,classID,jobArr);
         }
      }
      
      private static function setClassJob(petID:uint, classID:uint, jobArr:Array) : void
      {
         var jobStatus:uint = getNewStatus(jobArr);
         GV.onlineSocket.writeUnsignedInt(petID);
         GV.onlineSocket.writeUnsignedInt(classID);
         GV.onlineSocket.writeUnsignedInt(jobStatus);
         flush();
      }
      
      private static function setOne(pows:uint) : uint
      {
         var ap:uint = 0;
         return uint(Math.pow(2,pows));
      }
      
      private static function getNewStatus(arr:Array) : uint
      {
         var app:uint = 0;
         var res:uint = 0;
         for(var i:uint = 0; i < arr.length; i++)
         {
            if(arr[i] == 1)
            {
               app = setOne(i + 1);
               res += app;
            }
         }
         return res;
      }
   }
}

