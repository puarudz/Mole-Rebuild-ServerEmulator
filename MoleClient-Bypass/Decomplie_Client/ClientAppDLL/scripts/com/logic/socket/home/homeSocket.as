package com.logic.socket.home
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.module.npc.lamu.LamuInfo;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class homeSocket
   {
      
      public function homeSocket()
      {
         super();
      }
      
      public static function queryHaveSuperLamu(userId:uint) : void
      {
         MsgHead.Command = 240;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function queryPlantAndFarm(userId:uint) : void
      {
         MsgHead.Command = 1911;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userId);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryPlantAndFarm() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.plantLV = output.readUnsignedInt();
         obj.farmLV = output.readUnsignedInt();
         obj.plantLVNum = output.readUnsignedInt();
         obj.farmLVNum = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1911,obj));
      }
      
      public function res_queryHaveSuperLamu() : void
      {
         var i:int;
         var petObj:Object = null;
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         try
         {
            obj.count = GV.onlineSocket.readUnsignedInt();
         }
         catch(E:*)
         {
            return;
         }
         obj.arr = new Array();
         for(i = 0; i < obj.count; i++)
         {
            petObj = new Object();
            petObj.SpriteID = GV.onlineSocket.readUnsignedInt();
            petObj.Flag = GV.onlineSocket.readUnsignedInt();
            petObj.Birthday = GV.onlineSocket.readUnsignedInt();
            petObj.Value = GV.onlineSocket.readUnsignedInt();
            petObj.Nick = GV.onlineSocket.readUTFBytes(16);
            petObj.PetName = petObj.Nick;
            petObj.Color = GV.onlineSocket.readUnsignedInt();
            petObj.SickTime = GV.onlineSocket.readUnsignedInt();
            petObj.PosX = GV.onlineSocket.readUnsignedByte();
            petObj.PosY = GV.onlineSocket.readUnsignedByte();
            petObj.Hungry = GV.onlineSocket.readUnsignedByte();
            petObj.Thirsty = GV.onlineSocket.readUnsignedByte();
            petObj.Dirty = GV.onlineSocket.readUnsignedByte();
            petObj.Spirit = GV.onlineSocket.readUnsignedByte();
            petObj.Level = GV.onlineSocket.readUnsignedByte();
            petObj.Skill = GV.onlineSocket.readUnsignedInt();
            petObj.Sick_type = GV.onlineSocket.readUnsignedInt();
            petObj.skill_Fire = GV.onlineSocket.readUnsignedInt();
            petObj.skill_Water = GV.onlineSocket.readUnsignedInt();
            petObj.skill_Wood = GV.onlineSocket.readUnsignedInt();
            petObj.Skill_Type = GV.onlineSocket.readUnsignedInt();
            petObj.Skill_Value = GV.onlineSocket.readUnsignedInt();
            petObj.item1 = GV.onlineSocket.readUnsignedByte();
            petObj.item2 = GV.onlineSocket.readUnsignedByte();
            petObj.item3 = GV.onlineSocket.readUnsignedByte();
            petObj.Cloth = GV.onlineSocket.readUnsignedInt();
            petObj.Honor = GV.onlineSocket.readUnsignedInt();
            petObj.BlackSick = GF.SickType(petObj.Sick_type);
            if(Boolean(LocalUserInfo.lamuinfo) && petObj.SpriteID == LocalUserInfo.lamuinfo.PetID)
            {
               LocalUserInfo.lamuinfo.upData2(petObj);
            }
            petObj.lamuinfo = new LamuInfo(petObj);
            petObj.lamuinfo.upData2(petObj);
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 240,obj));
      }
   }
}

