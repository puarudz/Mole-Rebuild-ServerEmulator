package com.logic.socket.enterMapOrRoom
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.socket.dragon.DragonBagSocket;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.home.HomeCarSocket;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class EnterMapOrRoomRes extends EventDispatcher
   {
      
      public static var ENTER_MAP_ROOM:String = "enter_map_room";
      
      public function EnterMapOrRoomRes()
      {
         super();
      }
      
      public function enterMapRoomRes() : void
      {
         var userID:int = 0;
         var ItemCountObj:Object = null;
         var getStatusObj:Object = new Object();
         var userLoginArr:Array = new Array();
         getStatusObj.UserID = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getStatusObj.ParentID = GV.onlineSocket.readUnsignedInt();
         getStatusObj.childCount = GV.onlineSocket.readUnsignedInt();
         getStatusObj.newChildCount = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Color = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Vip = GV.onlineSocket.readUnsignedInt();
         getStatusObj.MapID = GV.onlineSocket.readUnsignedInt();
         getStatusObj.MapType = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Status = GV.onlineSocket.readUnsignedByte();
         getStatusObj.Action = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Direction = GV.onlineSocket.readUnsignedByte();
         getStatusObj.Pet_action = GV.onlineSocket.readUnsignedInt();
         getStatusObj.PosX = GV.onlineSocket.readUnsignedInt();
         getStatusObj.PosY = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Grid = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Action2 = GV.onlineSocket.readUnsignedInt();
         getStatusObj.PetID = GV.onlineSocket.readUnsignedInt();
         getStatusObj.PetName = GV.onlineSocket.readUTFBytes(16);
         getStatusObj.PetColor = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Petlevel = GV.onlineSocket.readUnsignedByte();
         getStatusObj.Reserved1 = GV.onlineSocket.readUnsignedInt();
         getStatusObj.PetSick = GF.SickType(GV.onlineSocket.readUnsignedInt());
         getStatusObj.skill_Fire = GV.onlineSocket.readUnsignedInt();
         getStatusObj.skill_Water = GV.onlineSocket.readUnsignedInt();
         getStatusObj.skill_Wood = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Skill_Type = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Skill_Value = GV.onlineSocket.readUnsignedInt();
         getStatusObj.item1 = GV.onlineSocket.readUnsignedByte();
         getStatusObj.item2 = GV.onlineSocket.readUnsignedByte();
         getStatusObj.item3 = GV.onlineSocket.readUnsignedByte();
         getStatusObj.Pet_cloth = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Pet_honor = GV.onlineSocket.readUnsignedInt();
         getStatusObj.Can_Fly = GV.onlineSocket.readUnsignedInt();
         if(getStatusObj.UserID == GV.MyInfo_userID && Boolean(getStatusObj.PetID))
         {
            GV.MyInfo_Pet = getStatusObj.SpriteID;
            GV.MyInfo_PetObj.SpriteID = getStatusObj.SpriteID;
            GV.MyInfo_PetObj.Level = getStatusObj.Petlevel;
            GV.MyInfo_PetObj.Color = getStatusObj.PetColor;
            GV.MyInfo_PetObj.Name = GV.MyInfo_PetName;
         }
         getStatusObj.Reserved2 = 0;
         var actArr:ByteArray = new ByteArray();
         GV.onlineSocket.readBytes(actArr,0,32);
         getStatusObj.Activity = actArr;
         var obj:Object = new Object();
         obj.userID = getStatusObj.UserID;
         obj.id = GV.onlineSocket.readUnsignedInt();
         obj.nickname = GV.onlineSocket.readUTFBytes(16);
         obj.growth = GV.onlineSocket.readUnsignedInt();
         getStatusObj.dragonInfo = DragonBagSocket.getDragonInfo(obj);
         getStatusObj.digTreasureLvl = GV.onlineSocket.readUnsignedInt();
         getStatusObj.hasCar = GV.onlineSocket.readUnsignedInt();
         getStatusObj.carInfo = {};
         var carObj:Object = {};
         if(Boolean(getStatusObj.hasCar))
         {
            userID = int(GV.onlineSocket.readUnsignedInt());
            carObj = HomeCarSocket.onecarinfo(userID);
         }
         getStatusObj.carObj = carObj;
         getStatusObj.hasAnimal = GV.onlineSocket.readUnsignedInt();
         getStatusObj.animalObj = {};
         var animalObj:Object = {};
         if(Boolean(getStatusObj.hasAnimal))
         {
            GV.onlineSocket.readUnsignedInt();
            animalObj = farmSocket.readAnimal();
         }
         getStatusObj.animalObj = animalObj;
         var animalId:int = int(getStatusObj.animalObj.ID);
         if(GoodsInfo.getType(animalId) == 30 || GoodsInfo.getType(animalId) == 41)
         {
            getStatusObj.hasAnimal = false;
            getStatusObj.angelIndex = getStatusObj.animalObj.NO;
            getStatusObj.animalObj = {};
            getStatusObj.hasAngel = true;
            getStatusObj.angelId = animalId;
         }
         else if(GoodsInfo.getType(animalId) == 36)
         {
            getStatusObj.hasAnimal = false;
            getStatusObj.hasPig = true;
            getStatusObj.pigObj = getStatusObj.animalObj;
            getStatusObj.pigObj.itemId = animalId;
            getStatusObj.animalObj = {};
         }
         else
         {
            getStatusObj.hasAngel = false;
            getStatusObj.angelId = 0;
         }
         if(Boolean(animalObj.Outgo & 8))
         {
            getStatusObj.hasAnimal = false;
            getStatusObj.animalObj = {};
         }
         getStatusObj.roleType = GV.onlineSocket.readUnsignedInt();
         getStatusObj.ItemCount = GV.onlineSocket.readUnsignedByte();
         for(var u:int = 0; u < getStatusObj.ItemCount; u++)
         {
            ItemCountObj = new Object();
            ItemCountObj.ItemID = GV.onlineSocket.readUnsignedInt();
            ItemCountObj = GF.getPropData(ItemCountObj.ItemID);
            userLoginArr.push(ItemCountObj);
         }
         getStatusObj.clothArry = userLoginArr;
         getStatusObj.superGuide = GV.onlineSocket.readUnsignedInt();
         if(getStatusObj.UserID == LocalUserInfo.getUserID())
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(ENTER_MAP_ROOM,getStatusObj));
         }
         else
         {
            GV.onlineClass.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.SEND_DATA,getStatusObj));
         }
      }
   }
}

