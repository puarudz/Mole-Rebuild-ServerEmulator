package com.logic.socket.petSocket.learnPet
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class OneLearnListRes extends Sprite
   {
      
      public static var ONEPETLEARNLIST:String = "onePet_classList";
      
      public function OneLearnListRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var Arr:Array = null;
         var i:uint = 0;
         var obja:Object = null;
         var Arrs:Array = null;
         var Allobj:Object = new Object();
         Allobj.PetID = GV.onlineSocket.readUnsignedInt();
         Allobj.Cnt = GV.onlineSocket.readUnsignedInt();
         if(Allobj.Cnt > 0)
         {
            Arr = new Array();
            for(i = 0; i < Allobj.Cnt; i++)
            {
               obja = new Object();
               obja.ClassID = GV.onlineSocket.readUnsignedInt();
               obja.Status = GV.onlineSocket.readUnsignedInt();
               obja.Days = GV.onlineSocket.readShort();
               Arr.push(obja);
            }
            Allobj.Arr = Arr;
         }
         else if(Allobj.Cnt == 0)
         {
            Arrs = ["no"];
            Allobj.Arr = Arrs;
         }
         var objs:Object = {"Allobj":Allobj};
         GV.onlineClass.dispatchEvent(new EventTaomee(ONEPETLEARNLIST,objs));
      }
   }
}

