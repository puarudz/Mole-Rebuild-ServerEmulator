package com.logic.socket.home
{
   import com.common.msgHead.MsgHead;
   import com.core.car.carInfo.CarInfo;
   import com.event.EventTaomee;
   import com.event.car.CarInfoEvent;
   import com.logic.socket.dragon.DragonBagSocket;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HomeCarSocket
   {
      
      public function HomeCarSocket()
      {
         super();
      }
      
      public static function UPCar(carid:uint) : void
      {
         if(DragonBagSocket.checkHasDragon())
         {
            return;
         }
         MsgHead.Command = 1700;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(carid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_UPCar() : void
      {
         var UserID:uint = GV.onlineSocket.readUnsignedInt();
         var carobj:CarInfo = onecarinfo(UserID);
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("getCarInfo",carobj));
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1700,carobj));
      }
      
      public static function DOWNCar() : void
      {
         MsgHead.Command = 1701;
         GF.writeHead();
      }
      
      public static function res_DOWNCar() : void
      {
         var CarObj:Object = new Object();
         CarObj.UserID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1701,CarObj));
      }
      
      public static function CarList(uid:uint) : void
      {
         MsgHead.Command = 1702;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_CarList() : void
      {
         var Car:Object = new Object();
         var UserID:uint = GV.onlineSocket.readUnsignedInt();
         var Count:uint = GV.onlineSocket.readUnsignedInt();
         Car.Count = Count;
         Car.arr = new Array();
         for(var i:uint = 0; i < Count; i++)
         {
            Car.arr.push(onecarinfo(UserID));
         }
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1702,Car));
      }
      
      public static function ShowThisCar(carid:uint) : void
      {
         MsgHead.Command = 1703;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(carid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ShowThisCar() : void
      {
         var obj:Object = new Object();
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1703,obj));
      }
      
      public static function ShowCarInfo(uid:uint) : void
      {
         MsgHead.Command = 1704;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(uid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_ShowCarInfo() : void
      {
         var carobj:CarInfo = null;
         var UserID:uint = GV.onlineSocket.readUnsignedInt();
         var haveshowcar:uint = GV.onlineSocket.readUnsignedInt();
         if(haveshowcar == 1)
         {
            carobj = onecarinfo(UserID);
            GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1704,carobj));
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new CarInfoEvent("read_" + 1704,"noshowcar"));
         }
      }
      
      public static function onecarinfo(id:uint) : CarInfo
      {
         var CarObj:Object = new Object();
         CarObj.UserID = id;
         CarObj.CarID = GV.onlineSocket.readUnsignedInt();
         CarObj.ItemID = GV.onlineSocket.readUnsignedInt();
         CarObj.Oil = GV.onlineSocket.readUnsignedInt();
         CarObj.Engine = GV.onlineSocket.readUnsignedInt();
         CarObj.TotalOil = GV.onlineSocket.readUnsignedInt();
         CarObj.Color = GV.onlineSocket.readUnsignedInt();
         CarObj.LastOil = GV.onlineSocket.readUnsignedInt();
         CarObj.SlotCount = GV.onlineSocket.readUnsignedInt();
         CarObj.Slot1 = GV.onlineSocket.readUnsignedInt();
         CarObj.Slot2 = GV.onlineSocket.readUnsignedInt();
         CarObj.Slot3 = GV.onlineSocket.readUnsignedInt();
         CarObj.Slot4 = GV.onlineSocket.readUnsignedInt();
         CarObj.Item1 = GV.onlineSocket.readUnsignedInt();
         CarObj.Item2 = GV.onlineSocket.readUnsignedInt();
         return new CarInfo(CarObj);
      }
      
      public static function addoil(carid:uint) : void
      {
         MsgHead.Command = 1705;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(carid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_addoil() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = {};
         obj.Xiaomee = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1705,obj));
      }
      
      public static function buycar(itemid:uint = 1300001) : void
      {
         MsgHead.Command = 1706;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_buycar() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1706));
      }
      
      public static function RentACar() : void
      {
         if(DragonBagSocket.checkHasDragon())
         {
            return;
         }
         MsgHead.Command = 1709;
         var tempByteArray:ByteArray = new ByteArray();
         GF.writeHead(tempByteArray);
      }
      
      public static function res_RentACar() : void
      {
         var UserID:uint = GV.onlineSocket.readUnsignedInt();
         var carobj:CarInfo = onecarinfo(UserID);
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("getCarInfo",carobj));
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1709,carobj));
      }
      
      public static function loadingOrDischarging(L_D:int = 0, itemid:int = 190472) : void
      {
         if(DragonBagSocket.checkHasDragon())
         {
            return;
         }
         MsgHead.Command = 1710;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(L_D);
         tempByteArray.writeUnsignedInt(itemid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_loadingOrDischarging() : void
      {
         var UserID:uint = GV.onlineSocket.readUnsignedInt();
         var carobj:CarInfo = onecarinfo(UserID);
         GV.onlineSocket.dispatchEvent(new CarInfoEvent("getCarInfo",carobj));
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1710,carobj));
      }
   }
}

