package com.logic.socket.cure
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class GetCureAllInfo extends Sprite
   {
      
      public static var BACK_ALL:String = "cure_back_all";
      
      public static var BACK_DOCTOR_ON:String = "cure_back_doc_on";
      
      public static var BACK_INVALID_ON:String = "cure_back_inv_on";
      
      public static var BACK_DOCTOR_OUT:String = "cure_back_doc_out";
      
      public static var BACK_INVALID_OUT:String = "cure_back_inv_out";
      
      public static var BACK_DOCTOR_ONE:String = "cure_back_doc_one";
      
      public static var BACK_DOCTOR_TWO:String = "cure_back_doc_two";
      
      public static var BACK_DOCTOR_WORK:String = "cure_back_doc_work";
      
      public static var BACK_EAT_MEDICINE:String = "BACK_EAT_MEDICINE";
      
      public function GetCureAllInfo()
      {
         super();
      }
      
      public static function BackEatMedicine() : void
      {
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.Action = GV.onlineSocket.readUnsignedInt();
         obj.Type = GV.onlineSocket.readUnsignedByte();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.SpriteID = GV.onlineSocket.readUnsignedInt();
         obj.Hungry = GV.onlineSocket.readUnsignedByte();
         obj.Thirsty = GV.onlineSocket.readUnsignedByte();
         obj.Dirty = GV.onlineSocket.readUnsignedByte();
         obj.Spirit = GV.onlineSocket.readUnsignedByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_EAT_MEDICINE,obj));
      }
      
      public function BackAllInfo() : void
      {
         var one_obj:Object = null;
         var back_obj:Object = new Object();
         back_obj.Count = GV.onlineSocket.readUnsignedInt();
         back_obj.Arr = new Array();
         for(var i:uint = 0; i < back_obj.Count; i++)
         {
            one_obj = new Object();
            one_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
            one_obj.Invalid_id = GV.onlineSocket.readUnsignedInt();
            back_obj.Arr.push(one_obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_ALL,{"obj":back_obj}));
      }
      
      public function BackDoctorOn() : void
      {
         var back_obj:Object = new Object();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_DOCTOR_ON,{"obj":back_obj}));
      }
      
      public function BackInvalidOn() : void
      {
         var back_obj:Object = new Object();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Invalid_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_INVALID_ON,{"obj":back_obj}));
      }
      
      public function BackDoctorOut() : void
      {
         var back_obj:Object = new Object();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_DOCTOR_OUT,{"obj":back_obj}));
      }
      
      public function BackInvalidOut() : void
      {
         var back_obj:Object = new Object();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Invalid_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_INVALID_OUT,{"obj":back_obj}));
      }
      
      public function BackDoctorOne() : void
      {
         var back_obj:Object = new Object();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_DOCTOR_ONE,{"obj":back_obj}));
      }
      
      public function BackDoctorTwo() : void
      {
         var back_obj:Object = new Object();
         back_obj.Money = GV.onlineSocket.readUnsignedInt();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_DOCTOR_TWO,{"obj":back_obj}));
      }
      
      public function BackDoctorWork() : void
      {
         var back_obj:Object = new Object();
         back_obj.Money = GV.onlineSocket.readUnsignedInt();
         back_obj.IP = GV.onlineSocket.readUnsignedInt();
         back_obj.Doctor_id = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_DOCTOR_WORK,{"obj":back_obj}));
      }
   }
}

