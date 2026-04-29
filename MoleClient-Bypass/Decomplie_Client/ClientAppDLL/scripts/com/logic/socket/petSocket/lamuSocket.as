package com.logic.socket.petSocket
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class lamuSocket
   {
      
      public function lamuSocket()
      {
         super();
      }
      
      public static function useSkill(petid:int, skilltype:int) : void
      {
         MsgHead.Command = 1212;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(petid);
         tempByteArray.writeUnsignedInt(skilltype);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_useSkill() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.userID = output.readUnsignedInt();
         obj.petID = output.readUnsignedInt();
         obj.action = output.readUnsignedInt();
         if(obj.userID == GV.MyInfo_userID)
         {
            obj.Hungry = GV.onlineSocket.readUnsignedByte();
            obj.Thirsty = GV.onlineSocket.readUnsignedByte();
            obj.Dirty = GV.onlineSocket.readUnsignedByte();
            obj.Spirit = GV.onlineSocket.readUnsignedByte();
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1212,obj));
      }
      
      public static function revertSkill(petid:int, skilltype:int) : void
      {
         MsgHead.Command = 1214;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(petid);
         tempByteArray.writeUnsignedInt(skilltype);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_revertSkill() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.userID = output.readUnsignedInt();
         obj.petID = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1214,obj));
      }
      
      public static function getSkillItem(petid:int, skilltype:int, itemid:int) : void
      {
         MsgHead.Command = 1209;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(petid);
         tempByteArray.writeUnsignedInt(skilltype);
         tempByteArray.writeUnsignedInt(itemid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getSkillItem() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.ItemID = output.readUnsignedInt();
         var Skill_Value:uint = output.readUnsignedInt();
         obj.Skill_Value = Skill_Value;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1209,Skill_Value));
      }
      
      public static function AccelerationPullulation(itemid:int) : void
      {
         MsgHead.Command = 1126;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_AccelerationPullulation() : void
      {
         var obj:Object = new Object();
         var output:IDataInput = GV.onlineSocket;
         obj.petLevel = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1126,obj));
      }
      
      public static function setPetStep5Skill(PetID:uint, SkillType:uint, SkillLevel:uint) : void
      {
         SkillLevel = SkillLevel > 1 ? uint(SkillLevel - 1) : SkillLevel;
         MsgHead.Command = 1127;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(PetID);
         byteArray.writeUnsignedInt(SkillType);
         byteArray.writeUnsignedInt(SkillLevel);
         GF.writeHead(byteArray);
      }
      
      public static function res_setPetStep5Skill() : void
      {
         var obj:Object = new Object();
         obj.skillType = GV.onlineSocket.readUnsignedInt();
         obj.skillLevel = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1127,obj));
      }
      
      public static function setPetSkillBox(PetID:uint, item1:uint, item2:uint, item3:uint) : void
      {
         MsgHead.Command = 1218;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(PetID);
         byteArray.writeByte(item1);
         byteArray.writeByte(item2);
         byteArray.writeByte(item3);
         GF.writeHead(byteArray);
      }
      
      public static function res_setPetSkillBox() : void
      {
         var obj:Object = new Object();
         obj.item1 = GV.onlineSocket.readUnsignedByte();
         obj.item2 = GV.onlineSocket.readUnsignedByte();
         obj.item3 = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1127,obj));
      }
      
      public static function setLamuLeave(petID:uint) : void
      {
         MsgHead.Command = 1257;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(petID);
         GF.writeHead(byteArray);
      }
      
      public static function res_setLamuLeave() : void
      {
         var obj:Object = new Object();
         obj.petID = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1257,obj));
      }
   }
}

