package com.logic.socket.lamuPkSys
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class AnimalSkillSocket
   {
      
      public static const Get_Animal_Skill_Commond:int = 1469;
      
      public static const Use_Skill_Commond:int = 1470;
      
      public static const Other_Use_Skill_Commond:int = 1407;
      
      public static const Get_Map_Egg_Commond:int = 1408;
      
      public static const Get_Egg_Commond:int = 1409;
      
      public function AnimalSkillSocket()
      {
         super();
      }
      
      public static function GetAnimalSkillInfo(animalNO:int) : void
      {
         MsgHead.Command = Get_Animal_Skill_Commond;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(animalNO);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetAnimalSkillInfo() : void
      {
         var skillInfo:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var arr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            skillInfo = new Object();
            skillInfo.skillId = output.readUnsignedInt();
            skillInfo.coldTime = output.readUnsignedInt();
            skillInfo.usedCount = output.readUnsignedInt();
            skillInfo.type = output.readUnsignedInt();
            arr.push(skillInfo);
         }
         obj.arr = arr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + Get_Animal_Skill_Commond,obj));
      }
      
      public static function UseSkill(animalNO:int, skillId:int) : void
      {
         MsgHead.Command = Use_Skill_Commond;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(animalNO);
         tempByteArray.writeUnsignedInt(skillId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UseSkill() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.NO = output.readUnsignedInt();
         obj.skillId = output.readUnsignedInt();
         obj.coldTime = output.readUnsignedInt();
         obj.usedCount = output.readUnsignedInt();
         obj.type = output.readUnsignedInt();
         var count:int = int(output.readUnsignedInt());
         var itemArr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.itemId = output.readUnsignedInt();
            item.count = output.readUnsignedInt();
            itemArr.push(item);
         }
         obj.itemArr = itemArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + Use_Skill_Commond,obj));
      }
      
      public static function res_OtherUseSkill() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.userId = output.readUnsignedInt();
         obj.skillId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + Other_Use_Skill_Commond,obj));
      }
      
      public static function GetMapEgg(mapId:int) : void
      {
         MsgHead.Command = Get_Map_Egg_Commond;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(mapId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetMapEgg() : void
      {
         var item:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var count:int = int(output.readUnsignedInt());
         var eggArr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            item = new Object();
            item.posid = output.readUnsignedInt();
            item.x = output.readUnsignedInt();
            item.y = output.readUnsignedInt();
            item.itemid = output.readUnsignedInt();
            eggArr.push(item);
         }
         obj.eggArr = eggArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + Get_Map_Egg_Commond,obj));
      }
      
      public static function GetEgg(mapId:int, posId:uint) : void
      {
         MsgHead.Command = Get_Egg_Commond;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(mapId);
         tempByteArray.writeUnsignedInt(posId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_GetEgg() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemid = output.readUnsignedInt();
         obj.posid = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + Get_Egg_Commond,obj));
      }
   }
}

