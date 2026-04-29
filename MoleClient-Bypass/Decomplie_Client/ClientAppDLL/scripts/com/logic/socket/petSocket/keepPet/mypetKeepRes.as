package com.logic.socket.petSocket.keepPet
{
   import com.event.EventTaomee;
   import com.module.npc.lamu.LamuInfo;
   import flash.events.EventDispatcher;
   
   public class mypetKeepRes extends EventDispatcher
   {
      
      public static var MY_PET_KEEP_SUCC:String = "MY_PET_KEEP_SUCC";
      
      public function mypetKeepRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var o:Object = null;
         var obj:Object = new Object();
         obj.Num = GV.onlineSocket.readUnsignedInt();
         obj.Arr = new Array();
         for(var i:uint = 0; i < obj.Num; i++)
         {
            o = new Object();
            o.PetID = GV.onlineSocket.readUnsignedInt();
            o.Nick = GV.onlineSocket.readUTFBytes(16);
            o.Color = GV.onlineSocket.readUnsignedInt();
            o.Level = GV.onlineSocket.readUnsignedByte();
            o.Time = GV.onlineSocket.readUnsignedInt();
            try
            {
               o.Skill_Type = GV.onlineSocket.readUnsignedInt();
               o.Skill_Value = GV.onlineSocket.readUnsignedInt();
               o.Cloth = GV.onlineSocket.readUnsignedInt();
            }
            catch(Err:Error)
            {
            }
            o.PetName = o.Nick;
            o.lamuinfo = new LamuInfo(o);
            o.lamuinfo.upData2(o);
            obj.Arr.push(o);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(MY_PET_KEEP_SUCC,obj));
      }
   }
}

