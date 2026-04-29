package com.logic.socket.petSocket.adoptPet
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petMapNumRes extends EventDispatcher
   {
      
      public static var GET_PET_MAP_SUCC:String = "GET_PET_MAP_SUCC";
      
      public function petMapNumRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var i:int;
         var petObj:Object = null;
         var obj:Object = new Object();
         try
         {
            obj.count = GV.onlineSocket.readUnsignedInt();
         }
         catch(E:*)
         {
            return;
         }
         obj.arr = new Array();
         trace("拉到的寵物數量：",obj.count);
         for(i = 0; i < obj.count; i++)
         {
            petObj = new Object();
            petObj.SpriteID = GV.onlineSocket.readUnsignedInt();
            petObj.UserID = GV.onlineSocket.readUnsignedInt();
            petObj.UserName = GV.onlineSocket.readUTFBytes(16);
            petObj.Flag = GV.onlineSocket.readUnsignedInt();
            petObj.Birthday = GV.onlineSocket.readUnsignedInt();
            petObj.Value = GV.onlineSocket.readUnsignedInt();
            petObj.Nick = GV.onlineSocket.readUTFBytes(16);
            petObj.PetName = petObj.Nick;
            petObj.Color = GV.onlineSocket.readUnsignedInt();
            petObj.Hungry = GV.onlineSocket.readUnsignedByte();
            petObj.Thirsty = GV.onlineSocket.readUnsignedByte();
            petObj.Dirty = GV.onlineSocket.readUnsignedByte();
            petObj.Spirit = GV.onlineSocket.readUnsignedByte();
            petObj.Level = GV.onlineSocket.readUnsignedByte();
            petObj.Skill = GV.onlineSocket.readUnsignedInt();
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
            petObj.PET = petObj.UserID + "_" + petObj.SpriteID;
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_PET_MAP_SUCC,obj));
      }
   }
}

