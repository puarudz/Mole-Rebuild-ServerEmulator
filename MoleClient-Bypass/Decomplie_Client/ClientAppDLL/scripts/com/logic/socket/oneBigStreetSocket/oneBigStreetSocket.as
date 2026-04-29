package com.logic.socket.oneBigStreetSocket
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class oneBigStreetSocket
   {
      
      private static var mUserID:int;
      
      private static var mtype:int;
      
      public function oneBigStreetSocket()
      {
         super();
      }
      
      public static function oneBigStreetHouse() : void
      {
         MsgHead.Command = 995;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(LocalUserInfo.getMapID());
         tempByteArray.writeUnsignedInt(LocalUserInfo.getMapType());
         tempByteArray.writeUnsignedInt(LocalUserInfo.getMyInfo_Grid());
         GF.writeHead(tempByteArray);
      }
      
      public static function res_oneBigStreetHouse() : void
      {
         var obj1:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         var houseArr:Array = new Array();
         obj.isStreetEnd = output.readUnsignedInt();
         for(var i:int = 0; i < 4; i++)
         {
            obj1 = new Object();
            obj1.houseType = output.readUnsignedInt();
            obj1.houseStyle = output.readUnsignedInt();
            obj1.houseUserId = output.readUnsignedInt();
            obj1.houseNumber = output.readUnsignedInt();
            obj1.houseDIYName = output.readUTFBytes(16);
            houseArr[i] = obj1;
         }
         obj.houseArr = houseArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 995,obj));
      }
      
      public static function creatHouse(houseName:String, houseType:int) : void
      {
         MsgHead.Command = 996;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeBytes(supplyZero(houseName,16));
         tempByteArray.writeUnsignedInt(houseType);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_creatHouse() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.houseNumber = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 996,obj));
      }
      
      public static function houseCertificate() : void
      {
         MsgHead.Command = 997;
         GF.writeHead();
      }
      
      public static function res_houseCertificate() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.money = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 997,obj));
      }
      
      public static function setHouseName(houseNumber:int, houseName:String) : void
      {
         MsgHead.Command = 998;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(houseNumber);
         tempByteArray.writeBytes(supplyZero(houseName,16));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setHouseName() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.name = output.readUTFBytes(16);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 998,obj));
      }
      
      public static function setHouseStyle(houseNumber:int, houseStyle:int) : void
      {
         MsgHead.Command = 1049;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(houseNumber);
         tempByteArray.writeUnsignedInt(houseStyle);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setHouseStyle() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.money = output.readUnsignedInt();
         obj.style = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1049,obj));
      }
      
      public static function queryGirdTotal() : void
      {
         MsgHead.Command = 1000;
         GF.writeHead();
      }
      
      public static function res_queryGirdTotal() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.firstGird = output.readUnsignedInt();
         obj.girdTotal = output.readUnsignedInt() - 1;
         obj.myGird = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1000,obj));
      }
      
      public static function setHouseInnerStyle(houseNumber:int, houseStyle:int) : void
      {
         MsgHead.Command = 1013;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(houseNumber);
         tempByteArray.writeUnsignedInt(houseStyle);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setHouseInnerStyle() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.InnerStyle = output.readUnsignedInt();
         obj.InnerStyleMoney = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1013,obj));
      }
      
      public static function restaurantInfo(userid:int, houseType:int) : void
      {
         MsgHead.Command = 1014;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         tempByteArray.writeUnsignedInt(houseType);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_restaurantInfo() : void
      {
         var objj:Object = null;
         var objjj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.houseInfo = new Object();
         obj.housePeopleInfo = new Object();
         obj.houseFoodInfo = new Object();
         obj.houseInfo.houseUserId = output.readUnsignedInt();
         obj.houseInfo.houseNumber = output.readUnsignedInt();
         obj.houseInfo.houseGrid = output.readUnsignedInt();
         obj.houseInfo.houseExp = output.readUnsignedInt();
         obj.houseInfo.houseMoney = output.readInt();
         obj.houseInfo.houseFavor = output.readUnsignedInt();
         obj.houseInfo.houseType = output.readUnsignedInt();
         obj.houseInfo.houseLevel = output.readUnsignedInt();
         obj.houseInfo.houseAllFood = output.readUnsignedInt();
         obj.houseInfo.houseInnerStyle = output.readUnsignedInt();
         obj.houseInfo.houseStyle = output.readUnsignedInt();
         obj.houseInfo.houseName = output.readUTFBytes(16);
         obj.houseInfo.peopMoney = output.readUnsignedInt();
         obj.houseInfo.foodStarCount = output.readUnsignedInt();
         obj.houseFoodInfo.allFoodCount = output.readUnsignedInt();
         obj.houseFoodInfo.foodArr = new Array();
         for(var foodArrRound:int = 0; foodArrRound < obj.houseFoodInfo.allFoodCount; foodArrRound++)
         {
            objj = new Object();
            objj.foodLocation = output.readUnsignedInt();
            objj.itemId = output.readUnsignedInt();
            objj.foodIndex = output.readUnsignedInt();
            objj.foodCount = output.readUnsignedInt();
            objj.foodState = output.readUnsignedInt();
            objj.foodMakeStartTimer = output.readUnsignedInt();
            obj.houseFoodInfo.foodArr.push(objj);
         }
         obj.housePeopleInfo.employeCount = output.readUnsignedInt();
         obj.housePeopleInfo.peopArr = new Array();
         for(var peopArrRound:int = 0; peopArrRound < obj.housePeopleInfo.employeCount; peopArrRound++)
         {
            objjj = new Object();
            objjj.Userid = output.readUnsignedInt();
            objjj.Petid = output.readUnsignedInt();
            objjj.PetName = output.readUTFBytes(16);
            objjj.PetColor = output.readUnsignedInt();
            objjj.PetLevel = output.readUnsignedInt();
            objjj.Petskill = output.readUnsignedInt();
            objjj.PetEmpLevel = output.readUnsignedInt();
            objjj.PetEmpMoney = output.readUnsignedInt();
            objjj.PetEndTime = output.readUnsignedInt();
            objjj.PetTimelimit = output.readUnsignedInt();
            objjj.EmpState = 1;
            obj.housePeopleInfo.peopArr.push(objjj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1014,obj));
      }
      
      public static function makeFood(itemID:int, Location:int) : void
      {
         MsgHead.Command = 1017;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(Location);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_makeFood() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.foodIndex = output.readUnsignedInt();
         obj.foodLocation = output.readUnsignedInt();
         obj.foodState = output.readUnsignedInt();
         obj.money = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1017,obj));
      }
      
      public static function setMakeFoodState(itemID:int, index:int) : void
      {
         MsgHead.Command = 1020;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(index);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_setMakeFoodState() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1020));
      }
      
      public static function moveMakeFoodLocation(itemID:int, index:int, location:int, toLocation:int) : void
      {
         MsgHead.Command = 1021;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(index);
         tempByteArray.writeUnsignedInt(location);
         tempByteArray.writeUnsignedInt(toLocation);
         trace("************************************************************");
         trace("1021發送菜端到保鮮櫃協議： 菜的id -- " + itemID + " 菜的序號index -- " + index + " 菜的位置 -- " + location + " 端菜到哪的位置 -- " + toLocation);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_moveMakeFoodLocation() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.foodIndex = output.readUnsignedInt();
         obj.foodLocation = output.readUnsignedInt();
         obj.foodToLocation = output.readUnsignedInt();
         obj.foodCount = output.readUnsignedInt();
         obj.exp = output.readUnsignedInt();
         obj.addFoodCount = output.readUnsignedInt();
         trace("************************************************************");
         trace("1021接收菜端到保鮮櫃協議： 菜的id -- " + obj.itemId + " 菜的序號index -- " + obj.foodIndex + " 做菜的位置 -- " + obj.foodLocation + " 端菜到哪的位置 -- " + obj.foodToLocation + " 菜的數量 -- " + obj.foodCount);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1021,obj));
         GF.sendSocket(CommandID.GOLDEN_BEAN_REWARD,0,3);
      }
      
      public static function clearFood(itemID:int, index:int, location:int) : void
      {
         MsgHead.Command = 1019;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(itemID);
         tempByteArray.writeUnsignedInt(index);
         tempByteArray.writeUnsignedInt(location);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_clearFood() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.foodIndex = output.readUnsignedInt();
         obj.foodLocation = output.readUnsignedInt();
         obj.money = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1019,obj));
      }
      
      public static function getEmpList(houseId:int, type:int) : void
      {
         MsgHead.Command = 1022;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(houseId);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getEmpList() : void
      {
         var objj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.empList = new Array();
         obj.EmpCount = output.readUnsignedInt();
         for(var i:int = 0; i < obj.EmpCount; i++)
         {
            objj = new Object();
            objj.Userid = output.readUnsignedInt();
            objj.Petid = output.readUnsignedInt();
            objj.PetName = output.readUTFBytes(16);
            objj.PetColor = output.readUnsignedInt();
            objj.PetLevel = output.readUnsignedInt();
            objj.Petskill = output.readUnsignedInt();
            objj.PetEmpLevel = output.readUnsignedInt();
            objj.PetEmpMoney = output.readUnsignedInt();
            objj.PetEndTime = output.readUnsignedInt();
            objj.PetTimelimit = output.readUnsignedInt();
            objj.EmpState = 0;
            obj.empList.push(objj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1022,obj));
      }
      
      public static function empUser(Userid:int, Petid:int, petcolor:int, petLevel:int, petName:String) : void
      {
         MsgHead.Command = 1015;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Userid);
         tempByteArray.writeUnsignedInt(Petid);
         tempByteArray.writeUnsignedInt(petcolor);
         tempByteArray.writeUnsignedInt(petLevel);
         tempByteArray.writeBytes(supplyZero(petName,16));
         GF.writeHead(tempByteArray);
      }
      
      public static function res_empUser() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Userid = output.readUnsignedInt();
         obj.Petid = output.readUnsignedInt();
         obj.PetName = output.readUTFBytes(16);
         obj.PetColor = output.readUnsignedInt();
         obj.PetLevel = output.readUnsignedInt();
         obj.Petskill = output.readUnsignedInt();
         obj.PetEmpLevel = output.readUnsignedInt();
         obj.PetEmpMoney = output.readUnsignedInt();
         obj.PetEndTime = output.readUnsignedInt();
         obj.PetTimelimit = output.readUnsignedInt();
         obj.EmpState = 1;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1015,obj));
      }
      
      public static function removeEmpUser(Userid:int, Petid:int) : void
      {
         MsgHead.Command = 1016;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Userid);
         tempByteArray.writeUnsignedInt(Petid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_removeEmpUser() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Userid = output.readUnsignedInt();
         obj.Petid = output.readUnsignedInt();
         obj.EmpState = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1016,obj));
      }
      
      public static function checkFoodNum(Userid:int, Petid:int, Itemid:int, Indexid:int, location:int) : void
      {
         MsgHead.Command = 1018;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Userid);
         tempByteArray.writeUnsignedInt(Petid);
         tempByteArray.writeUnsignedInt(Itemid);
         tempByteArray.writeUnsignedInt(Indexid);
         tempByteArray.writeUnsignedInt(location);
         trace("************************************************************");
         trace("1018發送端菜吃菜協議： 菜的id -- " + Itemid + " 菜的序號index -- " + Indexid + " 菜的位置 -- " + location + " 用戶的ID -- " + Userid + " 拉姆ID -- " + Petid);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_checkFoodNum() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Userid = output.readUnsignedInt();
         obj.Petid = output.readUnsignedInt();
         obj.Itemid = output.readUnsignedInt();
         obj.Indexid = output.readUnsignedInt();
         obj.location = output.readUnsignedInt();
         obj.userMoney = output.readUnsignedInt();
         obj.flag = output.readUnsignedInt();
         obj.foodCount = output.readUnsignedInt();
         trace("************************************************************");
         trace("1018接收端菜吃菜協議： 菜的id -- " + obj.Itemid + " 菜的序號index -- " + obj.Indexid + " 菜的位置 -- " + obj.location + " 用戶的ID -- " + obj.Userid + " 拉姆ID -- " + obj.Petid);
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1018,obj));
      }
      
      public static function lowerHouseFavor() : void
      {
         MsgHead.Command = 1025;
         GF.writeHead();
      }
      
      public static function res_lowerHouseFavor() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.Evaluate = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1025,obj));
      }
      
      public static function res_HouseInfoChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.houseLevel = output.readUnsignedInt();
         obj.houseExp = output.readUnsignedInt();
         obj.houseMoney = output.readInt();
         obj.houseInnerStyle = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1026,obj));
      }
      
      public static function queryHouseByUid(Userid:int, type:int) : void
      {
         MsgHead.Command = 1027;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(Userid);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryHouseByUid() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.uid = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         obj.flag = output.readUnsignedInt();
         obj.type = output.readUnsignedInt();
         if(obj.flag == 0)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1027,obj));
         }
         else
         {
            GF.showAlert(GV.MC_TopLever,"這個摩爾好像不歡迎你哦","",100,"iknow",true,false,"E");
         }
      }
      
      public static function whereMyLamu() : void
      {
         MsgHead.Command = 1028;
         GF.writeHead();
      }
      
      public static function res_whereMyLamu() : void
      {
         var objR:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.mylamuArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            objR = new Object();
            objR.Petid = output.readUnsignedInt();
            objR.Emuid = output.readUnsignedInt();
            obj.mylamuArr.push(objR);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1028,obj));
      }
      
      public static function unLockGoods(KindId:int, layer:int) : void
      {
         MsgHead.Command = 1024;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(KindId);
         tempByteArray.writeUnsignedInt(layer);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_unLockGoods() : void
      {
         var objR:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.goodsArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            objR = new Object();
            objR.Itemid = output.readUnsignedInt();
            objR.Enable = output.readUnsignedInt();
            obj.goodsArr.push(objR);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1024,obj));
      }
      
      public static function getHonorList() : void
      {
         MsgHead.Command = 1030;
         GF.writeHead();
      }
      
      public static function res_getHonorList() : void
      {
         var objR:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.honorArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            objR = new Object();
            objR.HonorID = output.readUnsignedInt();
            objR.Flag = output.readUnsignedInt();
            obj.honorArr.push(objR);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1030,obj));
      }
      
      public static function getUnOnlineInfo(userid:int, type:int) : void
      {
         MsgHead.Command = 1023;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(userid);
         tempByteArray.writeUnsignedInt(type);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getUnOnlineInfo() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.UserId = output.readUnsignedInt();
         obj.Type = output.readUnsignedInt();
         obj.Money = output.readUnsignedInt();
         obj.Favor = output.readUnsignedInt();
         obj.foodStarCount = output.readUnsignedInt();
         obj.eventCount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1023,obj));
      }
      
      public static function queryRestaurantEvent() : void
      {
         MsgHead.Command = 1031;
         GF.writeHead();
      }
      
      public static function res_queryRestaurantEvent() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.eventId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1031,obj));
      }
      
      public static function randomEventOver(solution:int) : void
      {
         MsgHead.Command = 1032;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(solution);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_randomEventOver() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.eventId = output.readUnsignedInt();
         obj.solution = output.readUnsignedInt();
         obj.money = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1032,obj));
      }
      
      public static function res_honorChange() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.honorId = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1029,obj));
      }
      
      public static function getFirendRestaurantRank(firendArr:Array) : void
      {
         MsgHead.Command = 1034;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(firendArr.length + 1);
         for(var i:int = 0; i < firendArr.length; i++)
         {
            if(firendArr[i].friend != 0)
            {
               tempByteArray.writeUnsignedInt(firendArr[i].friend);
            }
         }
         tempByteArray.writeUnsignedInt(LocalUserInfo.getUserID());
         GF.writeHead(tempByteArray);
      }
      
      public static function res_getFirendRestaurantRank() : void
      {
         var userObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.firendArr = new Array();
         obj.firendArr1 = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            userObj = new Object();
            userObj.UserID = output.readUnsignedInt();
            userObj.Exp = int(output.readUnsignedInt());
            userObj.Money = int(output.readInt());
            obj.firendArr.push(userObj);
            obj.firendArr1.push(userObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1034,obj));
      }
      
      public static function queryFoodCount(temp:int) : void
      {
         MsgHead.Command = 1040;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(temp);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_queryFoodCount() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1040,obj));
      }
      
      public static function delFoodByID(temp:int, count:int) : void
      {
         MsgHead.Command = 1035;
         var tempByteArray:ByteArray = new ByteArray();
         tempByteArray.writeUnsignedInt(temp);
         tempByteArray.writeUnsignedInt(count);
         GF.writeHead(tempByteArray);
      }
      
      public static function res_delFoodByID() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1035,obj));
      }
      
      public static function querySellFood() : void
      {
         MsgHead.Command = 1043;
         GF.writeHead();
      }
      
      public static function res_querySellFood() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         obj.money = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1043,obj));
      }
      
      public static function getSellFood() : void
      {
         MsgHead.Command = 1044;
         GF.writeHead();
      }
      
      public static function res_getSellFood() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.count = output.readUnsignedInt();
         obj.money = output.readUnsignedInt();
         obj.foodIndexId = output.readUnsignedInt();
         obj.foodLocation = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1044,obj));
      }
      
      public static function queryMakeFoodCount() : void
      {
         MsgHead.Command = 1046;
         GF.writeHead();
      }
      
      public static function res_queryMakeFoodCount() : void
      {
         var userObj:Object = null;
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.MakeFoodCountArr = new Array();
         obj.Count = output.readUnsignedInt();
         for(var i:int = 0; i < obj.Count; i++)
         {
            userObj = new Object();
            userObj.ItemId = output.readUnsignedInt();
            userObj.MakeCount = output.readUnsignedInt();
            userObj.MakeStarLV = output.readUnsignedInt();
            obj.MakeFoodCountArr.push(userObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1046,obj));
      }
      
      public static function res_msgFoodUplevel() : void
      {
         var output:IDataInput = GV.onlineSocket;
         var obj:Object = new Object();
         obj.itemId = output.readUnsignedInt();
         obj.level = output.readUnsignedInt();
         obj.addexp = output.readUnsignedInt();
         obj.addcount = output.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1047,obj));
      }
      
      public static function supplyZero(str:String, len:uint) : ByteArray
      {
         var t:ByteArray = new ByteArray();
         t.writeUTFBytes(str);
         while(t.length < len)
         {
            t.writeByte(0);
         }
         t.position = 0;
         return t;
      }
   }
}

