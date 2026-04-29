package com.logic.socket.petSocket.learnPet
{
   import com.event.EventTaomee;
   import com.module.npc.lamu.LamuInfo;
   import flash.display.Sprite;
   
   public class AllLearnListRes extends Sprite
   {
      
      public static var PET_ALL_CLASS:String = "allpet_class";
      
      public function AllLearnListRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var i:uint = 0;
         var o:Object = null;
         var obj:Object = new Object();
         obj.Num = GV.onlineSocket.readUnsignedByte();
         obj.Arr = new Array();
         if(obj.Num == 0)
         {
            obj.Arr[0] = "no";
         }
         else
         {
            for(i = 0; i < obj.Num; i++)
            {
               o = new Object();
               o.PetID = GV.onlineSocket.readUnsignedInt();
               o.Nick = GV.onlineSocket.readUTFBytes(16);
               o.Color = GV.onlineSocket.readUnsignedInt();
               o.Level = GV.onlineSocket.readUnsignedByte();
               o.Time = GV.onlineSocket.readUnsignedShort();
               try
               {
                  o.Skill_Type = GV.onlineSocket.readUnsignedInt();
                  o.Skill_Value = GV.onlineSocket.readUnsignedInt();
                  o.Cloth = GV.onlineSocket.readUnsignedInt();
               }
               catch(err:Error)
               {
               }
               o.PetName = o.Nick;
               o.lamuinfo = new LamuInfo(o);
               o.lamuinfo.upData2(o);
               obj.Arr.push(o);
            }
         }
         GV.onlineClass.dispatchEvent(new EventTaomee(PET_ALL_CLASS,{"obj":obj}));
      }
   }
}

