package com.logic.socket.getSceneUserInfo
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.socket.dragon.DragonBagSocket;
   import com.logic.socket.farm.farmSocket;
   import com.logic.socket.home.HomeCarSocket;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class GetSceneUserRes extends EventDispatcher
   {
      
      public static var GET_SCENE_INFO:String = "get_scene_info";
      
      public function GetSceneUserRes()
      {
         super();
      }
      
      public function getSceneUser() : void
      {
         var userID:int = 0;
         var ItemCountObj:Object = null;
         var getSceneObj:Object = new Object();
         var userLoginArr:Array = new Array();
         getSceneObj.UserID = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Nick = GV.onlineSocket.readUTFBytes(16);
         getSceneObj.ParentID = GV.onlineSocket.readUnsignedInt();
         getSceneObj.childCount = GV.onlineSocket.readUnsignedInt();
         getSceneObj.newChildCount = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Color = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Vip = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Birthday = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Exp = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Strong = GV.onlineSocket.readUnsignedInt();
         getSceneObj.IQ = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Charm = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Game_king = GV.onlineSocket.readUnsignedInt();
         getSceneObj.YXQ = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Engineer = GV.onlineSocket.readUnsignedInt();
         getSceneObj.DanceLevel = GV.onlineSocket.readUnsignedInt();
         getSceneObj.planter = GV.onlineSocket.readUnsignedInt();
         getSceneObj.farmer = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Dining_flag = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Dining_level = GV.onlineSocket.readUnsignedInt();
         getSceneObj.SLstar = GV.onlineSocket.readUnsignedInt();
         getSceneObj.MonthNum = GV.onlineSocket.readUnsignedInt();
         getSceneObj.VipValue = GV.onlineSocket.readUnsignedInt();
         getSceneObj.VipEndTime = GV.onlineSocket.readUnsignedInt();
         getSceneObj.autoPayVip = GV.onlineSocket.readUnsignedInt();
         if(getSceneObj.SLstar > 8)
         {
            getSceneObj.SLstar = 8;
         }
         getSceneObj.MapID = GV.onlineSocket.readUnsignedInt();
         getSceneObj.MapType = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Status = GV.onlineSocket.readUnsignedByte();
         getSceneObj.Action = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Direction = GV.onlineSocket.readUnsignedByte();
         getSceneObj.PosX = GV.onlineSocket.readUnsignedInt();
         getSceneObj.PosY = GV.onlineSocket.readUnsignedInt();
         getSceneObj.Grid = GV.onlineSocket.readUnsignedInt();
         var actArr:ByteArray = new ByteArray();
         GV.onlineSocket.readBytes(actArr,0,32);
         getSceneObj.Activity = actArr;
         var obj:Object = new Object();
         obj.userID = getSceneObj.UserID;
         obj.id = GV.onlineSocket.readUnsignedInt();
         obj.nickname = GV.onlineSocket.readUTFBytes(16);
         obj.growth = GV.onlineSocket.readUnsignedInt();
         getSceneObj.dragonInfo = DragonBagSocket.getDragonInfo(obj);
         getSceneObj.digTreasureLvl = GV.onlineSocket.readUnsignedInt();
         getSceneObj.hasCar = GV.onlineSocket.readUnsignedInt();
         getSceneObj.carInfo = {};
         var carObj:Object = {};
         if(Boolean(getSceneObj.hasCar))
         {
            userID = int(GV.onlineSocket.readUnsignedInt());
            carObj = HomeCarSocket.onecarinfo(userID);
         }
         getSceneObj.carObj = carObj;
         getSceneObj.hasAnimal = GV.onlineSocket.readUnsignedInt();
         getSceneObj.animalObj = {};
         var animalObj:Object = {};
         if(Boolean(getSceneObj.hasAnimal))
         {
            GV.onlineSocket.readUnsignedInt();
            animalObj = farmSocket.readAnimal();
         }
         getSceneObj.animalObj = animalObj;
         var animalId:int = int(getSceneObj.animalObj.ID);
         if(GoodsInfo.getType(animalId) == 30 || GoodsInfo.getType(animalId) == 41)
         {
            getSceneObj.hasAnimal = false;
            getSceneObj.animalObj = {};
            getSceneObj.hasAngel = true;
            getSceneObj.angelId = animalId;
         }
         else if(GoodsInfo.getType(animalId) == 36)
         {
            getSceneObj.hasAnimal = false;
            getSceneObj.hasPig = true;
            getSceneObj.pigObj = getSceneObj.animalObj;
            getSceneObj.pigObj.itemId = animalId;
            getSceneObj.animalObj = {};
         }
         else
         {
            getSceneObj.hasAngel = false;
            getSceneObj.angelId = 0;
         }
         if(Boolean(animalObj.Outgo & 8))
         {
            getSceneObj.hasAnimal = false;
            getSceneObj.animalObj = {};
         }
         getSceneObj.roleType = GV.onlineSocket.readUnsignedInt();
         getSceneObj.ItemCount = GV.onlineSocket.readUnsignedByte();
         for(var i:int = 0; i < getSceneObj.ItemCount; i++)
         {
            ItemCountObj = new Object();
            ItemCountObj.id = GV.onlineSocket.readUnsignedInt();
            ItemCountObj = GF.getPropData(ItemCountObj.id);
            ItemCountObj.itemCount = 1;
            userLoginArr.push(ItemCountObj);
         }
         getSceneObj.itemArr = userLoginArr;
         getSceneObj.superGuide = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_SCENE_INFO,getSceneObj));
      }
   }
}

