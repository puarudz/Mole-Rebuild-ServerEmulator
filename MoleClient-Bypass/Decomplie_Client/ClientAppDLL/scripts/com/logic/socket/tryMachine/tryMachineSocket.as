package com.logic.socket.tryMachine
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class tryMachineSocket
   {
      
      public function tryMachineSocket()
      {
         super();
      }
      
      public static function tryMachine(thisUserNameArr:Array) : void
      {
         var id:String = null;
         var count:int = 0;
         var tempByteArray:ByteArray = null;
         var i:int = 0;
         var userString:String = thisUserNameArr.toString();
         var userNameArr:Array = userString.split(",");
         var tempObj:Object = {};
         for(var j:int = 0; j < userNameArr.length; j++)
         {
            tempObj[userNameArr[j]] = int(userNameArr[j]);
         }
         delete tempObj[GV.MyInfo_userID];
         var userIDArr:Array = new Array();
         for(id in tempObj)
         {
            userIDArr.push(tempObj[id]);
         }
         MsgHead.Command = 1533;
         count = int(userIDArr.length);
         tempByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(count);
         for(i = 0; i < count; i++)
         {
            tempByteArray.writeUnsignedInt(userIDArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_tryMachine() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.Tangguo_flag = output.readUnsignedInt();
         obj.Score_flag = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1533,obj));
      }
      
      public static function getScreenString() : void
      {
         MsgHead.Command = 1531;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getScreenString() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.Len = output.readUnsignedInt();
         obj.String = output.readUTFBytes(obj.Len);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1531,obj));
      }
      
      public static function getmofaAbc() : void
      {
         MsgHead.Command = 60013;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getmofaAbc() : void
      {
         var oo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var arr:Array = new Array();
         var obj:Object = {};
         for(var i:int = 0; i < 3; i++)
         {
            oo = new Object();
            oo.uId = output.readUnsignedInt();
            oo.uType = output.readUnsignedInt();
            arr[i] = oo;
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 60013,obj));
      }
      
      public static function res_MmofaAbcOverGetObj() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var arr:Array = [];
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            arr.push(output.readUnsignedInt());
         }
         obj.arr = arr;
         obj.treeState = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 60011,obj));
      }
      
      public static function mofaAbcEffects() : void
      {
         MsgHead.Command = 60014;
         GF.writeHead();
      }
      
      public static function res_MofaAbcEffects() : void
      {
         var oo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var arr:Array = new Array();
         var obj:Object = {};
         if(LocalUserInfo.getMapID() == 112)
         {
            arr.length = 3;
         }
         else if(LocalUserInfo.getMapID() == 5)
         {
            arr.length = 4;
         }
         for(var i:int = 0; i < arr.length; i++)
         {
            oo = new Object();
            oo.uId = output.readUnsignedInt();
            oo.uType = output.readUnsignedInt();
            arr[i] = oo;
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 60014,obj));
      }
      
      public static function ChristTree() : void
      {
         MsgHead.Command = 60015;
         GF.writeHead();
      }
      
      public static function res_ChristTree() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.Tree_stat = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 60015,obj));
      }
   }
}

