package com.logic.socket.smc.expandItem
{
   import com.common.msgHead.MsgHead;
   import com.core.socketlogic.BaseOnlineSocketRequest;
   import com.global.staticData.CommandID;
   import com.logic.socket.getServerTimer.*;
   import flash.utils.ByteArray;
   
   public class SetLoopJobReq extends BaseOnlineSocketRequest
   {
      
      public function SetLoopJobReq()
      {
         super();
      }
      
      public static function SetInfo(jobID:uint, Obj:Object) : void
      {
         MsgHead.PkgLen = 17 + 4 + 50;
         initAction(CommandID.LOOP_SMCJOB_SET);
         if(jobID == 9)
         {
            setJob9(jobID,Obj);
            return;
         }
         if(jobID == 62 || jobID == 63 || jobID == 64 || jobID == 66 || jobID == 175 || jobID == 255)
         {
            setJob62(jobID,Obj);
            return;
         }
         if(jobID == 77 || jobID == 109 || jobID == 112 || jobID == 117 || jobID == 118 || jobID == 236 || jobID == 241 || jobID == 264)
         {
            setJob77(jobID,Obj);
            return;
         }
         if(jobID == 243 || jobID == 248)
         {
            setJob77(jobID,Obj);
            return;
         }
         if(jobID == 181 || jobID == 259 || jobID == 261)
         {
            setJob92(jobID,Obj);
            return;
         }
         if(jobID == 81 || jobID == 110 || jobID == 180 || jobID == 271 || jobID == 183)
         {
            setJob81(jobID,Obj);
            return;
         }
         if(jobID == 90)
         {
            setJob90(jobID,Obj);
            return;
         }
         if(jobID == 91)
         {
            setJob91(jobID,Obj);
            return;
         }
         if(jobID == 92 || jobID == 108 || jobID == 114 || jobID == 238 || jobID == 249)
         {
            setJob92(jobID,Obj);
            return;
         }
         if(jobID == 93)
         {
            setJob93(jobID,Obj);
            return;
         }
         if(jobID == 94 || jobID == 95 || jobID == 96 || jobID == 97 || jobID == 103 || jobID == 104 || jobID == 300 || jobID == 105 || jobID == 106 || jobID == 107 || jobID == 113 || jobID == 119 || jobID == 123 || jobID == 121 || jobID == 124 || jobID == 125 || jobID == 132 || jobID == 133 || jobID == 231 || jobID == 232 || jobID == 233 || jobID == 178 || jobID == 239 || jobID == 240 || jobID == 179 || jobID == 242 || jobID == 244 || jobID == 245 || jobID == 400 || jobID == 254 || jobID == 401)
         {
            setJob94(jobID,Obj);
            return;
         }
         if(jobID == 234 || jobID == 235 || jobID == 246 || jobID == 247 || jobID == 250 || jobID == 251 || jobID == 252 || jobID == 253 || jobID == 268 || jobID == 267 || jobID == 269 || jobID == 276)
         {
            setJob94(jobID,Obj);
            return;
         }
         if(jobID == 403 || jobID == 404 || jobID == 405 || jobID == 406 || jobID == 408 || jobID == 409 || jobID == 411)
         {
            setJob94(jobID,Obj);
            return;
         }
         if(jobID == 301 || jobID == 237)
         {
            setJob301(jobID,Obj);
            return;
         }
         if(jobID == 1006)
         {
            setJob1006(jobID,Obj);
            return;
         }
         if(jobID == 120)
         {
            setJob120(jobID,Obj);
            return;
         }
         SetGeneralJobInfo(jobID,Obj);
      }
      
      private static function setJob62(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.Flag);
         GV.onlineSocket.writeUnsignedInt(Obj.Count);
         var lg:uint = 50 - 8;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
      
      private static function setJob260(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.Flag);
         GV.onlineSocket.writeUnsignedInt(Obj.Count);
         var lg:uint = 50 - 20;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
      
      private static function setJob9(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.Flag);
         var str:String = String(Obj.times);
         var time_a:uint = uint(str.slice(0,str.length - 6));
         var time_b:uint = uint(str.slice(str.length - 6));
         GV.onlineSocket.writeUnsignedInt(Obj.mapID);
         GV.onlineSocket.writeUnsignedInt(time_a);
         GV.onlineSocket.writeUnsignedInt(time_b);
         var lg:uint = 50 - 16;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
      
      private static function setJob77(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         var lg:uint = 50 - 12;
         var myArr:ByteArray = new ByteArray();
         for(var i:uint = 0; i < lg; i++)
         {
            myArr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(myArr);
         flush();
      }
      
      private static function setJob81(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         GV.onlineSocket.writeUnsignedInt(Obj.flag4);
         var lg:uint = 50 - 16;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob90(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.lingFlag);
         GV.onlineSocket.writeUnsignedInt(Obj.lingFlag2);
         GV.onlineSocket.writeUnsignedInt(Obj.treeFlag);
         GV.onlineSocket.writeUnsignedInt(Obj.gunFlag);
         var lg:uint = 50 - 16;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob91(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.isGet);
         GV.onlineSocket.writeUnsignedInt(Obj.redFlag1);
         GV.onlineSocket.writeUnsignedInt(Obj.redFlag2);
         GV.onlineSocket.writeUnsignedInt(Obj.redFlag3);
         GV.onlineSocket.writeUnsignedInt(Obj.orangeFlag);
         GV.onlineSocket.writeUnsignedInt(Obj.pinkFlag);
         GV.onlineSocket.writeUnsignedInt(Obj.carFlag);
         var lg:uint = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob92(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         GV.onlineSocket.writeUnsignedInt(Obj.flag4);
         GV.onlineSocket.writeUnsignedInt(Obj.flag5);
         GV.onlineSocket.writeUnsignedInt(Obj.flag6);
         var lg:uint = 50 - 24;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob93(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.isSearch);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         GV.onlineSocket.writeUnsignedInt(Obj.flag4);
         GV.onlineSocket.writeUnsignedInt(Obj.isOver);
         GV.onlineSocket.writeUnsignedInt(Obj.isNoJob);
         var lg:uint = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob94(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag);
         var lg:uint = 50 - 4;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob301(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         GV.onlineSocket.writeUnsignedInt(Obj.flag4);
         GV.onlineSocket.writeUnsignedInt(Obj.flag5);
         GV.onlineSocket.writeUnsignedInt(Obj.flag6);
         GV.onlineSocket.writeUnsignedInt(Obj.flag7);
         GV.onlineSocket.writeUnsignedInt(Obj.flag8);
         GV.onlineSocket.writeUnsignedInt(Obj.flag9);
         var lg:uint = 50 - 36;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob120(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.flag1);
         GV.onlineSocket.writeUnsignedInt(Obj.flag2);
         GV.onlineSocket.writeUnsignedInt(Obj.flag3);
         GV.onlineSocket.writeUnsignedInt(Obj.flag4);
         GV.onlineSocket.writeUnsignedInt(Obj.flag5);
         GV.onlineSocket.writeUnsignedInt(Obj.flag6);
         GV.onlineSocket.writeUnsignedInt(Obj.flag7);
         var lg:uint = 50 - 28;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function setJob1006(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         GV.onlineSocket.writeUnsignedInt(Obj.jobFlag);
         var lg:uint = 50 - 4;
         var arr:ByteArray = new ByteArray();
         for(var i:int = 0; i < lg; i++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
      
      private static function SetGeneralJobInfo(jobID:uint, Obj:Object) : void
      {
         GV.onlineSocket.writeUnsignedInt(jobID);
         var jobInfo:Array = Obj.jobInfo;
         var maxCount:int = int(jobInfo.length);
         for(var i:int = 0; i < maxCount; i++)
         {
            GV.onlineSocket.writeUnsignedInt(jobInfo[i]);
         }
         var lg:Number = 50 - 4 * maxCount;
         var arr:ByteArray = new ByteArray();
         for(var j:int = 0; j < lg; j++)
         {
            arr.writeByte(0);
         }
         GV.onlineSocket.writeBytes(arr);
         flush();
      }
   }
}

