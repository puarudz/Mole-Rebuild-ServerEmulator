package com.logic.socket.callSuperLamu
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.utils.ByteArray;
   
   public class CallSuperLamu
   {
      
      public function CallSuperLamu()
      {
         super();
      }
      
      public static function send_callSuperLamu() : void
      {
         MsgHead.Command = 251;
         GF.writeHead();
      }
      
      public static function res_callSuperLamu() : void
      {
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.Nick = GV.onlineSocket.readUTFBytes(16);
         obj.PetName = obj.Nick;
         obj.Color = GV.onlineSocket.readUnsignedInt();
         obj.Status = GV.onlineSocket.readUnsignedInt();
         obj.Hungry = GV.onlineSocket.readUnsignedByte();
         obj.Thirsty = GV.onlineSocket.readUnsignedByte();
         obj.Dirty = GV.onlineSocket.readUnsignedByte();
         obj.Spirit = GV.onlineSocket.readUnsignedByte();
         obj.Level = GV.onlineSocket.readUnsignedByte();
         obj.Skill = GV.onlineSocket.readUnsignedInt();
         obj.skill_Fire = GV.onlineSocket.readUnsignedInt();
         obj.skill_Water = GV.onlineSocket.readUnsignedInt();
         obj.skill_Wood = GV.onlineSocket.readUnsignedInt();
         obj.Skill_Type = GV.onlineSocket.readUnsignedInt();
         obj.Skill_Value = GV.onlineSocket.readUnsignedInt();
         obj.item1 = GV.onlineSocket.readUnsignedByte();
         obj.item2 = GV.onlineSocket.readUnsignedByte();
         obj.item3 = GV.onlineSocket.readUnsignedByte();
         obj.Cloth = GV.onlineSocket.readUnsignedInt();
         obj.Honor = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 251,obj));
      }
      
      public static function consumeMoleMoney(moneyNum:int) : void
      {
         MsgHead.Command = 1386;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(moneyNum);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_consumeMoleMoney() : void
      {
         var obj:Object = new Object();
         obj.nowMoney = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1386,obj));
      }
      
      public static function exchangeSlGift(itemID:uint) : void
      {
         MsgHead.Command = 1522;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_exchangeSlGift() : void
      {
         var itemID:uint = 0;
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt();
         obj.itemArr = new Array();
         for(var i:uint = 0; i < obj.count; i++)
         {
            itemID = GV.onlineSocket.readUnsignedInt();
            obj.itemArr.push(itemID);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1522,obj));
      }
      
      public static function res_UpdateVipInfo() : void
      {
         var obj:Object = new Object();
         obj.vip_value = GV.onlineSocket.readUnsignedInt();
         obj.vip_level = GV.onlineSocket.readUnsignedInt();
         LocalUserInfo.setSLvalue(obj.vip_value);
         LocalUserInfo.setSLstar(obj.vip_level);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 10304,obj));
      }
   }
}

