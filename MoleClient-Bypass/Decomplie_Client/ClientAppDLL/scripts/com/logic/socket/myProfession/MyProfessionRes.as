package com.logic.socket.myProfession
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class MyProfessionRes extends EventDispatcher
   {
      
      public static var GET_MY_PROFESSION:String = "GET_MY_PROFESSION";
      
      public function MyProfessionRes()
      {
         super();
      }
      
      public static function GetMyProfession() : void
      {
         var obj:Object = new Object();
         obj.arr = new Array();
         for(var i:uint = 0; i < 200; i++)
         {
            if(i % 4 == 0)
            {
               obj.arr.push(GV.onlineSocket.readByte());
            }
            else
            {
               GV.onlineSocket.readByte();
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_MY_PROFESSION,obj));
      }
      
      public static function res_checkIsSLKnight() : void
      {
         var obj:Object = {};
         obj.userID = GV.onlineSocket.readUnsignedInt();
         obj.flag = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_MY_PROFESSION + 2,obj));
      }
   }
}

