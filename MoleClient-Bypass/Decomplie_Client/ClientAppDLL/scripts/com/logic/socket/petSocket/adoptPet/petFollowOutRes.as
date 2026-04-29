package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petFollowOutRes extends EventDispatcher
   {
      
      public static var GET_PETFOLLOW_OUT_SUCC:String = "GET_PETFOLLOW_OUT_SUCC";
      
      public function petFollowOutRes()
      {
         super();
      }
      
      public function parseBA() : void
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
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PETFOLLOW_OUT_SUCC,obj));
      }
   }
}

