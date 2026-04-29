package com.logic.socket.petSocket.adoptPet
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class petClothRes extends EventDispatcher
   {
      
      public static var PET_CLOTH_CHANGE_SUCC:String = "PET_CLOTH_CHANGE_SUCC";
      
      public static var PET_HONOR_CHANGE_SUCC:String = "PET_HONOR_CHANGE_SUCC";
      
      public static var PET_BUY_ITEM_SUCC:String = "PET_BUY_ITEM_SUCC";
      
      public static var PET_GET_ITEM_SUCC:String = "PET_GET_ITEM_SUCC";
      
      public static var GET_HONOR_BACK:String = "get_honor_back";
      
      public function petClothRes()
      {
         super();
      }
      
      public static function parse_cloth() : void
      {
         var petObj:Object = null;
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.PetID = GV.onlineSocket.readUnsignedInt();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:int = 0; i < obj.Count; i++)
         {
            petObj = new Object();
            petObj.ItemID = GV.onlineSocket.readUnsignedInt();
            petObj.Flag = GV.onlineSocket.readByte();
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_CLOTH_CHANGE_SUCC,obj));
         GV.onlineSocket.dispatchEvent(new EventTaomee("Pet_changeCloth_" + obj.UserID + "_" + obj.PetID,obj));
      }
      
      public static function parse_honor() : void
      {
         var petObj:Object = null;
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.PetID = GV.onlineSocket.readUnsignedInt();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:int = 0; i < obj.Count; i++)
         {
            petObj = new Object();
            petObj.ItemID = GV.onlineSocket.readUnsignedInt();
            petObj.Flag = GV.onlineSocket.readByte();
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_HONOR_CHANGE_SUCC,obj));
      }
      
      public static function buy_item() : void
      {
         var obj:Object = new Object();
         obj.moleMoney = GV.onlineSocket.readUnsignedInt();
         LocalUserInfo.setYXQ(obj.moleMoney);
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_BUY_ITEM_SUCC,obj));
      }
      
      public static function get_item() : void
      {
         var petObj:Object = null;
         var obj:Object = new Object();
         obj.UserID = GV.onlineSocket.readUnsignedInt();
         obj.PetID = GV.onlineSocket.readUnsignedInt();
         obj.Count = GV.onlineSocket.readUnsignedInt();
         obj.arr = new Array();
         for(var i:int = 0; i < obj.Count; i++)
         {
            petObj = new Object();
            petObj.ItemID = GV.onlineSocket.readUnsignedInt();
            petObj.Count = GV.onlineSocket.readUnsignedInt();
            obj.arr.push(petObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_GET_ITEM_SUCC,obj));
      }
      
      public static function getHonor() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_HONOR_BACK));
      }
      
      public static function res_getSLCloth() : void
      {
         var obj:Object = new Object();
         obj.clothID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1125,obj));
      }
   }
}

