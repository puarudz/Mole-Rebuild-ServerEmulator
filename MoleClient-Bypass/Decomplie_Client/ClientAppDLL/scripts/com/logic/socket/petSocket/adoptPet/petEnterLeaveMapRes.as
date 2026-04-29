package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petEnterLeaveMapRes extends EventDispatcher
   {
      
      public static var GET_ENTER_LEAVE_SUCC:String = "GET_ENTER_LEAVE_SUCC";
      
      public function petEnterLeaveMapRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = new Object();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.UserName = GV.onlineSocket.readUTFBytes(16);
         obj.Action = GV.onlineSocket.readUnsignedInt();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.Birthday = GV.onlineSocket.readUnsignedInt();
         obj.Value = GV.onlineSocket.readUnsignedInt();
         obj.Nick = GV.onlineSocket.readUTFBytes(16);
         obj.Color = GV.onlineSocket.readUnsignedInt();
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
         obj.PetName = obj.Nick;
         obj.PET = obj.UserID + "_" + obj.SpriteID;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_ENTER_LEAVE_SUCC,obj));
      }
   }
}

