package com.logic.socket.petSocket.learnPet
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class BeginLearnRes extends Sprite
   {
      
      public static var SETPETCLASS:String = "setpet_class_success";
      
      public function BeginLearnRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var ID:uint = GV.onlineSocket.readUnsignedInt();
         var obj:Object = {"ID":ID};
         trace(ID,"@@@yyyy");
         GV.onlineClass.dispatchEvent(new EventTaomee(SETPETCLASS,obj));
      }
   }
}

