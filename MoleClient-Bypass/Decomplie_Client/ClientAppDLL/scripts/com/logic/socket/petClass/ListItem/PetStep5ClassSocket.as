package com.logic.socket.petClass.ListItem
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   import com.module.npc.lamu.LamuInfo;
   import flash.utils.ByteArray;
   
   public class PetStep5ClassSocket
   {
      
      public function PetStep5ClassSocket()
      {
         super();
      }
      
      public static function setPetStep5Class(PetID:uint, TaskID:uint, Status:uint) : void
      {
         if(!PetID)
         {
            throw "拉姆ID不能為0";
         }
         MsgHead.Command = 1205;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(PetID);
         byteArray.writeUnsignedInt(TaskID);
         byteArray.writeUnsignedInt(Status);
         GF.writeHead(byteArray);
      }
      
      public static function res_setPetStep5Class() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1205));
      }
      
      public static function askPetStep5Class(PetID:uint, TaskID:uint) : void
      {
         if(!PetID)
         {
            throw "拉姆ID不能為0";
         }
         MsgHead.Command = 1204;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(PetID);
         byteArray.writeUnsignedInt(TaskID);
         GF.writeHead(byteArray);
      }
      
      public static function res_askPetStep5Class() : void
      {
         var obj:Object = new Object();
         obj.status = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1204,obj));
      }
      
      public static function askAllPetStep5Class(TaskID:uint) : void
      {
         MsgHead.Command = 1213;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(TaskID);
         GF.writeHead(byteArray);
      }
      
      public static function res_askAllPetStep5Class() : void
      {
         var petObj:Object = null;
         var obj:Object = new Object();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:uint = 0; i < obj.Count; i++)
         {
            petObj = new Object();
            petObj.PetID = GV.onlineSocket.readUnsignedInt();
            petObj.PetNick = GV.onlineSocket.readUTFBytes(16);
            petObj.PetColor = GV.onlineSocket.readUnsignedInt();
            petObj.PetLevel = GV.onlineSocket.readUnsignedByte();
            petObj.ClientData = GV.onlineSocket.readUTFBytes(50);
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1213,obj));
      }
      
      public static function setPillarHeight(PillarType:uint, Height:uint) : void
      {
         MsgHead.Command = 1208;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(PillarType);
         byteArray.writeUnsignedInt(Height);
         GF.writeHead(byteArray);
      }
      
      public static function res_setPillarHeight() : void
      {
         var obj:Object = new Object();
         obj.Height = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1208,obj));
      }
      
      public static function getPillarHeight() : void
      {
         MsgHead.Command = 1210;
         GF.writeHead();
      }
      
      public static function res_getPillarHeight() : void
      {
         var obj:Object = new Object();
         obj.height1 = GV.onlineSocket.readUnsignedInt();
         obj.height2 = GV.onlineSocket.readUnsignedInt();
         obj.height3 = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1210,obj));
      }
      
      public static function setPetSkillType(petID:uint, type:uint) : void
      {
         if(!petID)
         {
            throw "拉姆ID不能為0";
         }
         MsgHead.Command = 1217;
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUnsignedInt(petID);
         byteArray.writeUnsignedInt(type);
         GF.writeHead(byteArray);
      }
      
      public static function res_setPetSkillType() : void
      {
         var obj:Object = new Object();
         obj.skillType = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1217,obj));
         var lamuinfo:LamuInfo = LamuInfo(GV.MAN_PEOPLE.lamuinfo);
         if(Boolean(lamuinfo))
         {
            lamuinfo.skill_learnType = obj.skillType;
            lamuinfo.checkAndUpSkillType();
         }
      }
   }
}

