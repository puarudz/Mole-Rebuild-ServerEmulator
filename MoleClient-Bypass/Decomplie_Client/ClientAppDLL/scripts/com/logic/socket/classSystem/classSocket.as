package com.logic.socket.classSystem
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class classSocket
   {
      
      public function classSocket()
      {
         super();
      }
      
      public static function class_create(Name:String, Slogan:String, Interest:uint, Logo_type:uint, Logo_word:String, Logo_color:uint, Join_flag:uint, Visit_flag:uint = 0) : void
      {
         MsgHead.Command = 5000;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Interest);
         tempByteArray.writeUnsignedInt(Logo_type);
         tempByteArray.writeBytes(supplyZero(Logo_word,4));
         tempByteArray.writeUnsignedInt(Logo_color);
         tempByteArray.writeUnsignedInt(Join_flag);
         tempByteArray.writeUnsignedInt(Visit_flag);
         tempByteArray.writeBytes(supplyZero(Name,16));
         tempByteArray.writeBytes(supplyZero(Slogan,60));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_create() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5000));
      }
      
      public static function class_amendClass(Join_flag:uint, Visit_flag:uint, ClassName:String, Slogan:String) : void
      {
         MsgHead.Command = 5001;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Join_flag);
         tempByteArray.writeUnsignedInt(Visit_flag);
         tempByteArray.writeBytes(supplyZero(ClassName,16));
         tempByteArray.writeBytes(supplyZero(Slogan,60));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_amendClass() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5001));
      }
      
      public static function class_enterMap(classID:uint) : void
      {
         MsgHead.Command = 5002;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_enterMap() : void
      {
         var id:uint = 0;
         var itemObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.Interest = output.readUnsignedInt();
         obj.Logo_type = output.readUnsignedInt();
         obj.Logo_word = output.readUTFBytes(4);
         obj.Logo_color = output.readUnsignedInt();
         obj.Join_flag = output.readUnsignedInt();
         obj.Visit_flag = output.readUnsignedInt();
         obj.Name = output.readUTFBytes(16);
         obj.Slogan = output.readUTFBytes(60);
         obj.Monitor = output.readUTFBytes(16);
         obj.Member_cnt = output.readUnsignedInt();
         obj.Item_cnt = output.readUnsignedInt();
         var memberArr:Array = new Array();
         for(var i:int = 0; i < obj.Member_cnt; i++)
         {
            id = output.readUnsignedInt();
            memberArr.push(id);
         }
         var itemArr:Array = new Array();
         for(var j:int = 0; j < obj.Item_cnt; j++)
         {
            itemObj = {};
            itemObj.ID = output.readUnsignedInt();
            itemObj.PosX = output.readShort();
            itemObj.PosY = output.readShort();
            itemObj.Direction = output.readByte();
            itemObj.Visible = output.readByte();
            itemObj.Layer = output.readByte();
            itemObj.Type = output.readByte();
            itemObj.Other = output.readUnsignedInt();
            itemArr.push(itemObj);
         }
         obj.itemArr = itemArr;
         obj.memberArr = memberArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5002,obj));
      }
      
      public static function class_requestAddToClass(ClassID:uint) : void
      {
         MsgHead.Command = 5003;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ClassID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_requestAddToClass() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var result:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5003,result));
      }
      
      public static function class_out(ClassID:uint) : void
      {
         MsgHead.Command = 5004;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ClassID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_out() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5004));
      }
      
      public static function class_application(ClassID:uint, Reason:String) : void
      {
         MsgHead.Command = 5005;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ClassID);
         tempByteArray.writeBytes(supplyZero(Reason,60));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_application() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5005));
      }
      
      public static function class_Auditing(userID:uint, Reason:uint) : void
      {
         MsgHead.Command = 5006;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         tempByteArray.writeUnsignedInt(Reason);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_Auditing() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5006));
      }
      
      public static function class_delMenber(userID:uint) : void
      {
         MsgHead.Command = 5007;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_delMenber() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5007));
      }
      
      public static function class_delClass() : void
      {
         MsgHead.Command = 5008;
         GF.writeHead();
      }
      
      public static function res_class_delClass() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5008));
      }
      
      public static function class_getBadgeInfo(ClassID:uint) : void
      {
         MsgHead.Command = 5009;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ClassID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_getBadgeInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.classID = output.readUnsignedInt();
         obj.Logo_type = output.readUnsignedInt();
         obj.Logo_word = output.readUTFBytes(4);
         obj.Logo_color = output.readUnsignedInt();
         obj.Join_flag = output.readUnsignedInt();
         obj.Visit_flag = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5009,obj));
      }
      
      public static function class_setMyShowBadge(ClassID:uint) : void
      {
         MsgHead.Command = 5010;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(ClassID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_setMyShowBadge() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5010));
      }
      
      public static function class_getBadgeID(userID:uint) : void
      {
         MsgHead.Command = 5011;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_getBadgeID() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var classID:uint = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5011,classID));
      }
      
      public static function class_depotItem() : void
      {
         MsgHead.Command = 5012;
         GF.writeHead();
      }
      
      public static function res_class_buyItem() : void
      {
         var itemObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Arr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:uint = 0; i < obj.Count; i++)
         {
            itemObj = new Object();
            itemObj.ID = output.readUnsignedInt();
            itemObj.Count = output.readUnsignedInt();
            obj.Arr.push(itemObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5012,obj));
      }
      
      public static function class_saveItems(usedArr:Array, nousedArr:Array) : void
      {
         MsgHead.Command = 5013;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(usedArr.length);
         for(var i:uint = 0; i < usedArr.length; i++)
         {
            tempByteArray.writeUnsignedInt(usedArr[i].ID);
            tempByteArray.writeShort(usedArr[i].PosX);
            tempByteArray.writeShort(usedArr[i].PosY);
            tempByteArray.writeByte(usedArr[i].Direction);
            tempByteArray.writeByte(usedArr[i].Visible);
            tempByteArray.writeByte(usedArr[i].Layer);
            tempByteArray.writeByte(usedArr[i].Type);
            tempByteArray.writeUnsignedInt(usedArr[i].Other);
         }
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_saveItems() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5013));
      }
      
      public static function class_getMyClassList() : void
      {
         MsgHead.Command = 5014;
         GF.writeHead();
      }
      
      public static function res_class_getMyClassList() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var classID:uint = output.readUnsignedInt();
         var count:uint = output.readUnsignedInt();
         var classList:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            classList.push(output.readUnsignedInt());
         }
         var obj:Object = {};
         obj.showClassID = classID;
         obj.classList = classList;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5014,obj));
      }
      
      public static function class_lock() : void
      {
         MsgHead.Command = 5015;
         GF.writeHead();
      }
      
      public static function res_class_lock() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5015));
      }
      
      public static function class_unlock() : void
      {
         MsgHead.Command = 5016;
         GF.writeHead();
      }
      
      public static function res_class_unlock() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5016));
      }
      
      public static function class_getClassInfo(classID:uint) : void
      {
         MsgHead.Command = 5017;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_getClassInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.classID = output.readUnsignedInt();
         obj.Logo_type = output.readUnsignedInt();
         obj.Logo_word = output.readUTFBytes(4);
         obj.Logo_color = output.readUnsignedInt();
         obj.Join_flag = output.readUnsignedInt();
         obj.Visit_flag = output.readUnsignedInt();
         obj.Name = output.readUTFBytes(16);
         obj.Slogan = output.readUTFBytes(60);
         obj.Monitor = output.readUTFBytes(16);
         obj.Member_cnt = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5017,obj));
      }
      
      public static function class_getMenberList(classID:uint) : void
      {
         MsgHead.Command = 5018;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(classID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_class_getMenberList() : void
      {
         var id:uint = 0;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.classID = output.readUnsignedInt();
         obj.Item_cnt = output.readUnsignedInt();
         var memberArr:Array = new Array();
         obj.Item_cnt = obj.Item_cnt > 101 ? 0 : obj.Item_cnt;
         for(var i:int = 0; i < obj.Item_cnt; i++)
         {
            id = output.readUnsignedInt();
            memberArr.push(id);
         }
         obj.memberArr = memberArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5018,obj));
      }
      
      public static function supplyZero(str:String, len:uint) : ByteArray
      {
         var t:ByteArray = new ByteArray();
         t.writeUTFBytes(str);
         while(t.length < len)
         {
            t.writeByte(0);
         }
         t.position = 0;
         return t;
      }
      
      public static function class_getFoundCompetition() : void
      {
         MsgHead.Command = 5019;
         GF.writeHead();
      }
      
      public static function res_class_getFoundCompetition() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var classArr:Array = [];
         var Class_cnt:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < Class_cnt; i++)
         {
            obj = {};
            obj.Classid = output.readUnsignedInt();
            obj.membercnt = output.readUnsignedInt();
            obj.interest = output.readUnsignedInt();
            obj.monitor = output.readUTFBytes(16);
            obj.apellation = output.readUTFBytes(16);
            classArr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5019,classArr));
      }
      
      public static function class_getHonor() : void
      {
         MsgHead.Command = 5020;
         GF.writeHead();
      }
      
      public static function res_class_getHonor() : void
      {
         var obj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var classArr:Array = [];
         var classId:int = int(output.readUnsignedInt());
         var class_cnt:int = int(output.readUnsignedInt());
         for(var i:int = 0; i < class_cnt; i++)
         {
            obj = {};
            obj.type = output.readUnsignedInt();
            obj.itemid = output.readUnsignedInt();
            classArr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 5020,{
            "arr":classArr,
            "id":classId
         }));
      }
   }
}

