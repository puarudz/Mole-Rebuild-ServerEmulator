package com.logic.socket.classSystem
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class DoctorQGSocket
   {
      
      public function DoctorQGSocket()
      {
         super();
      }
      
      public static function doctor_startQG(classID:uint) : void
      {
         MsgHead.Command = 5400;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doctor_startQG() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.result = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5400,obj));
      }
      
      public static function doctor_subjectQG() : void
      {
         MsgHead.Command = 5401;
         GF.writeHead();
      }
      
      public static function res_doctor_subjectQG() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var subjectArr:Array = [];
         var count:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            obj = {};
            obj.content = output.readUTFBytes(192);
            obj.Option1 = output.readUTFBytes(64);
            obj.Option2 = output.readUTFBytes(64);
            obj.Option3 = output.readUTFBytes(64);
            obj.Option4 = output.readUTFBytes(64);
            subjectArr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5401,subjectArr));
      }
      
      public static function doctor_optSubjectQG(usedArr:Array = null) : void
      {
         MsgHead.Command = 5402;
         var tempByteArray:ByteArray = new ByteArray();
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(usedArr[i]);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doctor_optSubjectQG() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         var totalTrueArr:Array = [];
         infoObj.count = output.readUnsignedInt();
         infoObj.Score = output.readUnsignedInt();
         infoObj.totalScore = output.readUnsignedInt();
         infoObj.Itmid = output.readUnsignedInt();
         for(var i:int = 0; i < 10; i++)
         {
            obj = new Object();
            obj.content = output.readUTFBytes(256);
            obj.Result = output.readUnsignedInt();
            totalTrueArr.push(obj);
         }
         infoObj.arr = totalTrueArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5402,infoObj));
      }
      
      public static function doctor_seeStartQG(classID:uint) : void
      {
         MsgHead.Command = 5403;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_doctor_seeStartQG() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         infoObj.classID = output.readUnsignedInt();
         infoObj.Score = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5403,infoObj));
      }
      
      public static function acceptAward() : void
      {
         MsgHead.Command = 5404;
         GF.writeHead();
      }
      
      public static function res_acceptAward() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         infoObj.count = output.readUnsignedInt();
         infoObj.arr = new Array();
         for(var i:uint = 0; i < infoObj.count; i++)
         {
            infoObj.arr.push(output.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5404,infoObj));
      }
      
      public static function classmateAcceptAward() : void
      {
         MsgHead.Command = 5405;
         GF.writeHead();
      }
      
      public static function res_classmateAcceptAward() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         infoObj.count = output.readUnsignedInt();
         infoObj.arr = new Array();
         for(var i:uint = 0; i < infoObj.count; i++)
         {
            infoObj.arr.push(output.readUnsignedInt());
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5405,infoObj));
      }
      
      public static function classABCScore() : void
      {
         MsgHead.Command = 1535;
         GF.writeHead();
      }
      
      public static function res_classABCScore() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var infoObj:Object = {};
         infoObj.Score = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1535,infoObj));
      }
   }
}

