package com.module.restaurant
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class RestaurantGuest
   {
      
      private static var instance:RestaurantGuest;
      
      private static var canotNew:Boolean = true;
      
      private var serverFriendsList:Array;
      
      private var friendsList:Array;
      
      private var friendGusetList:Array;
      
      private var sysGusetList:Array;
      
      private var restaurantBeen:RestaurantBeen;
      
      private var guestArr:Array;
      
      private var lamuskill:Array = new Array(1,2,4);
      
      private var lamulevel:Array = new Array(2,3,4,5,101);
      
      private var lamuColor:Array = new Array(1,2,3,4,5,6,7,8);
      
      private var myalter:Object;
      
      private var guestWaitTimer:int = 14;
      
      private var guestEatFoodTimer:int = 16;
      
      private var guestPosTimer:int = 15;
      
      public function RestaurantGuest()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantGuest不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantGuest
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantGuest();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         if(this.isJoin())
         {
            this.initFun();
         }
         RestaurantView.getInstance().businessing();
      }
      
      private function initFun() : void
      {
         this.restaurantBeen = RestaurantBeen.getInstance();
         this.guestArr = this.restaurantBeen.getRestaurantInfo().houseGuest;
         this.checkFriend();
         this.checkSysGuset();
         if(this.restaurantBeen.isMyRestaurant())
         {
            if(this.friendGusetList.length > 0)
            {
               this.guestArr.unshift(this.friendGusetList[0]);
            }
            else
            {
               this.guestArr.unshift(this.sysGusetList[0]);
            }
         }
         else
         {
            this.guestArr.unshift(this.sysGusetList[0]);
         }
         addLamuByRestaurant.getInstance().addLamuMc(this.guestArr[0],1);
      }
      
      private function checkFriend() : void
      {
         var i:int = 0;
         var j:uint = 0;
         var obj:Object = null;
         var rskill:int = 0;
         var so:Object = MainManager.getGlobalObject();
         this.serverFriendsList = so.data.ServerFriendsList;
         this.friendsList = so.data.FriendsList;
         this.friendGusetList = new Array();
         try
         {
            for(i = 0; i < this.friendsList.length; i++)
            {
               for(j = 0; j < this.serverFriendsList.length; j++)
               {
                  if(this.friendsList[i].UserID != null)
                  {
                     if(this.serverFriendsList[j].friend != null)
                     {
                        if(this.friendsList[i].UserID == this.serverFriendsList[j].friend)
                        {
                           obj = new Object();
                           obj.Petid = 1;
                           obj.PetName = this.friendsList[i].Nick + "的拉姆";
                           obj.Userid = this.serverFriendsList[j].friend;
                           obj.PetColor = this.lamuColor[int(Math.random() * this.lamuColor.length)];
                           obj.isSysLame = true;
                           obj.PetLevel = this.lamulevel[int(Math.random() * this.lamulevel.length)];
                           obj.Petskill = 0;
                           if(int(Math.random() * 100) < 50)
                           {
                              if(obj.PetLevel == 5)
                              {
                                 rskill = Math.random() * this.lamuskill.length;
                                 if(rskill == 0)
                                 {
                                    obj.Petskill = 1;
                                 }
                                 else if(rskill == 1)
                                 {
                                    obj.Petskill = 2;
                                 }
                                 else if(rskill == 2)
                                 {
                                    obj.Petskill = 4;
                                 }
                                 else
                                 {
                                    obj.Petskill = 4;
                                 }
                              }
                              else if(obj.PetLevel == 101)
                              {
                                 if(Math.random() * 100 < 50)
                                 {
                                    obj.Petskill = 7;
                                 }
                              }
                           }
                           this.friendGusetList.push(obj);
                        }
                     }
                  }
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function checkSysGuset() : void
      {
         this.sysGusetList = XMLInfo.RestaurantGuestObj;
      }
      
      public function randomGuest() : void
      {
         if(this.friendGusetList != null && this.guestArr.length < this.friendGusetList.length)
         {
            this.randomGuestByFriend();
         }
         else
         {
            this.randomGuestBySystem();
         }
      }
      
      private function randomGuestByFriend() : void
      {
         var randomNum:int = Math.random() * this.friendGusetList.length;
         if(this.checkGuestList(this.friendGusetList[randomNum]))
         {
            this.randomGuestByFriend();
         }
         else
         {
            this.guestArr.unshift(this.friendGusetList[randomNum]);
            addLamuByRestaurant.getInstance().addLamuMc(this.guestArr[0],1);
         }
      }
      
      private function randomGuestBySystem() : void
      {
         if(!Boolean(sysGusetList))
         {
            return;
         }
         var randomNum:int = Math.random() * this.sysGusetList.length;
         if(this.checkGuestList(this.sysGusetList[randomNum]))
         {
            this.randomGuestBySystem();
         }
         else
         {
            this.guestArr.unshift(this.sysGusetList[randomNum]);
            addLamuByRestaurant.getInstance().addLamuMc(this.guestArr[0],1);
         }
      }
      
      private function checkGuestList(guestObj:Object) : Boolean
      {
         var ret:Boolean = false;
         for(var i:int = 0; i < this.guestArr.length; i++)
         {
            if(this.guestArr[i].Userid == guestObj.Userid && this.guestArr[i].Petid == guestObj.Petid)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      public function selectNnTable(lamu:MovieClip) : void
      {
         var tableNum:int = this.checkNnTable();
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var guestList:Array = this.restaurantBeen.getRestaurantInfo().houseGuest;
         if(tableNum == 0)
         {
            this.unTableAddTimer();
         }
         else
         {
            this.addLamuToTable(tableNum,lamu);
            lamu = null;
         }
      }
      
      private function addLamuToTable(tableNum:int, lamu:MovieClip) : void
      {
         var toX:int = 0;
         var toY:int = 0;
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var guestList:Array = this.restaurantBeen.getRestaurantInfo().houseGuest;
         for(var r:int = 0; r < guestList.length; r++)
         {
            if(guestList[r].lamu.lamuInfo.masterID == lamu.lamuInfo.masterID && guestList[r].lamu.lamuInfo.PetID == lamu.lamuInfo.PetID)
            {
               if(guestList[r].waitTimer != null)
               {
                  trace("***************************************************");
                  trace("刪除倒計時： " + lamu.lamuInfo.PetID + "  等到過程中刪除客人倒計時");
                  GC.clearGInterval(guestList[r].waitTimer);
                  guestList[r].waitTimer = null;
               }
               toX = int(this.restaurantBeen.getRestaurantMC().buttonLevel["tablePoint" + tableNum].x);
               toY = int(this.restaurantBeen.getRestaurantMC().buttonLevel["tablePoint" + tableNum].y);
               depth_mc["table" + tableNum].tableObj = new Object();
               depth_mc["table" + tableNum].tableObj.lamu = new Object();
               depth_mc["table" + tableNum].tableObj.lamu = guestList[r].lamu;
               guestList[r].byTable = tableNum;
               BC.addEvent(this,depth_mc["table" + tableNum].tableObj.lamu,PeopleManageView.ON_GO_OVER,this.onGoOver);
               depth_mc["table" + tableNum].tableObj.lamu.MoveTo(toX,toY);
               break;
            }
         }
      }
      
      private function unTableAddTimer() : void
      {
         var guestList:Array = this.restaurantBeen.getRestaurantInfo().houseGuest;
         for(var r:int = 0; r < guestList.length; r++)
         {
            if(guestList[r].byTable == 0 && guestList[r].waitTimer == null)
            {
               trace("***************************************************");
               trace("添加倒計時： " + guestList[r].lamu.lamuInfo.PetID);
               guestList[r].waitTimerCount = this.guestWaitTimer;
               GC.clearGInterval(guestList[r].waitTimer);
               guestList[r].waitTimer = GC.setGTimeout(this.onTimer,1000,guestList[r]);
            }
         }
      }
      
      private function onTimer(guestObj:Object) : void
      {
         var guestList:Array = this.restaurantBeen.getRestaurantInfo().houseGuest;
         var tableNum:int = this.checkNnTable();
         if(tableNum != 0)
         {
            this.addLamuToTable(tableNum,guestObj.lamu);
         }
         else
         {
            guestObj.lamu.say("/hk");
            if(guestObj.waitTimerCount == 0)
            {
               guestObj.waitTimer = null;
               this.onTimerComplete(guestObj);
            }
            else if(guestObj.byTable == 0)
            {
               guestObj.waitTimerCount -= 1;
               guestObj.waitTimer = GC.setGTimeout(this.onTimer,1000,guestObj);
            }
         }
      }
      
      private function onTimerComplete(guestObj:Object) : void
      {
         var guestList:Array = this.restaurantBeen.getRestaurantInfo().houseGuest;
         var lamu:MovieClip = guestObj.lamu;
         for(var r:int = 0; r < guestList.length; r++)
         {
            if(guestList[r].lamu.lamuInfo.masterID == lamu.lamuInfo.masterID && guestList[r].lamu.lamuInfo.PetID == lamu.lamuInfo.PetID)
            {
               trace("***************************************************");
               trace("刪除倒計時： " + lamu.lamuInfo.PetID + "客人等待超時");
               GC.clearGInterval(guestObj.waitTimer);
               RestaurantView.getInstance().checkHouseFavor(0,guestList[r].lamu);
               break;
            }
         }
      }
      
      private function checkNnTable() : int
      {
         var round:int = 0;
         var ret:int = 0;
         var tableNum:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseTable);
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         if(depth_mc != null)
         {
            for(round = 1; round <= tableNum; round++)
            {
               if(depth_mc["table" + (100 + round)].tableObj == null)
               {
                  ret = 100 + round;
                  break;
               }
            }
         }
         return ret;
      }
      
      private function onGoOver(evt:Event) : void
      {
         BC.removeEvent(this,evt.currentTarget,PeopleManageView.ON_GO_OVER,this.onGoOver);
         var tableNum:int = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseTable);
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         for(var round:int = 1; round <= tableNum; round++)
         {
            if(depth_mc["table" + (100 + round)].tableObj != null)
            {
               if(depth_mc["table" + (100 + round)].tableObj.lamu.lamuInfo.PetID == evt.currentTarget.lamuInfo.PetID && depth_mc["table" + (100 + round)].tableObj.lamu.lamuInfo.masterID == evt.currentTarget.lamuInfo.masterID)
               {
                  this.restaurantBeen.getRestaurantMC().buttonLevel["tablePoint" + (100 + round)].gotoChangeMap();
                  break;
               }
            }
         }
      }
      
      public function clearGuest(lamu:MovieClip) : void
      {
         var guestList:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseGuest;
         for(var i:int = 0; i < guestList.length; i++)
         {
            if(guestList[i].lamu.lamuInfo.masterID == lamu.lamuInfo.masterID && guestList[i].lamu.lamuInfo.PetID == lamu.lamuInfo.PetID)
            {
               guestList.splice(i,1);
               trace("***************************************************");
               trace(" 客人個數：" + guestList.length);
               trace("***************************************************");
            }
         }
      }
      
      public function eatFood(type:int, directionS:String) : void
      {
         var depth_mc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         if(depth_mc["table" + type].tableObj == null)
         {
            trace();
         }
         else
         {
            this.systemLamuEatFood(type,directionS);
         }
      }
      
      private function systemLamuEatFood(type:int, directionS:String) : void
      {
         var eatFoodLamu:* = undefined;
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         if(depth_mc["table" + type].tableObj.isAction == null || depth_mc["table" + type].tableObj.isAction == false)
         {
            eatFoodLamu = depth_mc["table" + type].tableObj.lamu.boneManaage;
            setTimeout(eatFoodLamu.showAction,500,directionS);
            depth_mc["table" + type].tableObj.isAction = true;
            if(this.checkHaveFood(depth_mc["table" + type]) && this.checkHaveEmp(depth_mc["table" + type],type))
            {
               this.empGetFood(depth_mc["table" + type],type);
            }
            else
            {
               depth_mc["table" + type].tableObj.waitTimerCount = this.guestPosTimer;
               GC.clearGInterval(depth_mc["table" + type].tableObj.waitTimer);
               depth_mc["table" + type].tableObj.waitTimer = GC.setGTimeout(this.onEatFoodTimer,1000,type);
            }
         }
      }
      
      private function onEatFoodTimer(type:int) : void
      {
         var exitGuest:MovieClip = null;
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         if(this.checkHaveFood(depth_mc["table" + type]) && this.checkHaveEmp(depth_mc["table" + type],type))
         {
            GC.clearGInterval(depth_mc["table" + type].tableObj.waitTimer);
            depth_mc["table" + type].tableObj.waitTimer = null;
            this.empGetFood(depth_mc["table" + type],type);
         }
         else if(depth_mc["table" + type].tableObj.waitTimerCount == 0)
         {
            GC.clearGInterval(depth_mc["table" + type].tableObj.waitTimer);
            depth_mc["table" + type].tableObj.waitTimer = null;
            exitGuest = depth_mc["table" + type].tableObj.lamu;
            RestaurantView.getInstance().checkHouseFavor(0,exitGuest);
            depth_mc["table" + type].tableObj = null;
         }
         else
         {
            exitGuest = depth_mc["table" + type].tableObj.lamu;
            exitGuest.say("/hk");
            depth_mc["table" + type].tableObj.waitTimerCount -= 1;
            GC.clearGInterval(depth_mc["table" + type].tableObj.waitTimer);
            depth_mc["table" + type].tableObj.waitTimer = GC.setGTimeout(this.onEatFoodTimer,1000,type);
         }
      }
      
      private function empGetFood(tableMc:MovieClip, type:int) : void
      {
         var lm:I_LamuNPC = null;
         var exitGuest:MovieClip = null;
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         var movePoint:int = int(tableMc.tableObj.food.foodLocation);
         var moveFoodLocation:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel["movePoint" + movePoint];
         var moveFoodEmp:MovieClip = tableMc.tableObj.emp.lamu;
         if(moveFoodLocation == null)
         {
            trace("端的過程中沒菜");
            lm = tableMc.tableObj.emp.lamu as I_LamuNPC;
            LamuInfo(lm["lamuInfo"]).PetCloth = 1200043;
            lm["refurbish"]();
            RestaurantEmp.getInstance().clearTableEmp(tableMc);
            exitGuest = tableMc.tableObj.lamu;
            tableMc.tableObj = null;
            RestaurantView.getInstance().checkHouseFavor(0,exitGuest);
         }
         else
         {
            moveFoodEmp.autoMove = false;
            BC.addEvent(this,moveFoodEmp,PeopleManageView.ON_GO_OVER,this.onGoGetFoodOver);
            setTimeout(moveFoodEmp.MoveTo,200,moveFoodLocation.x,moveFoodLocation.y);
         }
      }
      
      private function onGoGetFoodOver(evt:Event) : void
      {
         var lm:I_LamuNPC = null;
         var exitGuest:MovieClip = null;
         BC.removeEvent(this,evt.currentTarget,PeopleManageView.ON_GO_OVER,this.onGoGetFoodOver);
         var tableMc:MovieClip = this.findFoodTable(evt.currentTarget.lamuInfo);
         var movePoint:int = int(tableMc.tableObj.emp.EmpState);
         var moveFoodLocation:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel["point" + movePoint];
         var guestObj:Object = tableMc.tableObj.lamu.lamuInfo;
         if(this.restaurantBeen.isMyRestaurant())
         {
            if(this.checkHaveFoodAgain(tableMc))
            {
               this.changeFoodCount(tableMc.tableObj.food);
               BC.addEvent(this,GV.onlineSocket,"read_1018",this.onGetFoodOver);
               oneBigStreetSocket.checkFoodNum(guestObj.masterID,guestObj.PetID,tableMc.tableObj.food.itemId,tableMc.tableObj.food.foodIndex,movePoint);
            }
            else
            {
               lm = tableMc.tableObj.emp.lamu as I_LamuNPC;
               LamuInfo(lm["lamuInfo"]).PetCloth = 1200043;
               lm["refurbish"]();
               RestaurantEmp.getInstance().clearTableEmp(tableMc);
               exitGuest = tableMc.tableObj.lamu;
               tableMc.tableObj = null;
               RestaurantView.getInstance().checkHouseFavor(0,exitGuest);
            }
         }
         else
         {
            this.addFoodToEmp(tableMc);
         }
      }
      
      private function checkHaveFoodAgain(tableMc:MovieClip) : Boolean
      {
         var ret:Boolean = false;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         for(var foodRound:int = 0; foodRound < foodArr.length; foodRound++)
         {
            if(foodArr[foodRound].foodLocation > 50 && foodArr[foodRound].foodCount > 0)
            {
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      private function onGetFoodOver(evt:EventTaomee) : void
      {
         var tableMc:MovieClip = null;
         var f:int = 0;
         if(this.restaurantBeen.isMyRestaurant())
         {
            LocalUserInfo.setYXQ(evt.EventObj.userMoney);
         }
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         for(var ff:int = 0; ff < foodArr.length; ff++)
         {
            if(foodArr[ff].foodIndex == evt.EventObj.Indexid)
            {
               foodArr[ff].foodCount = evt.EventObj.foodCount;
               break;
            }
         }
         if(evt.EventObj.flag == 1)
         {
            for(f = 0; f < foodArr.length; f++)
            {
               if(foodArr[f].foodIndex == evt.EventObj.Indexid)
               {
                  foodArr.splice(f,1);
                  break;
               }
            }
            tableMc = depth_mc["table" + evt.EventObj.location];
            this.addFoodToEmp(tableMc);
         }
         else
         {
            tableMc = depth_mc["table" + evt.EventObj.location];
            this.addFoodToEmp(tableMc);
         }
      }
      
      private function addFoodToEmp(tableMc:MovieClip) : void
      {
         var path:String = RestaurantFood.getInstance().foodMakePath;
         RestaurantView.getInstance().loadMcAndObj(path + tableMc.tableObj.food.itemId + ".swf",new Object(),1,tableMc);
         var movePoint:int = int(tableMc.tableObj.emp.EmpState);
         var moveFoodLocation:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel["point" + movePoint];
         RestaurantRandomSay.getInstance().say(3,tableMc.tableObj.emp.lamu);
         var lm:I_LamuNPC = tableMc.tableObj.emp.lamu as I_LamuNPC;
         LamuInfo(lm["lamuInfo"]).PetCloth = 1200042;
         lm["refurbish"]();
         lm.autoMove = false;
         BC.addEvent(this,lm,PeopleManageView.ON_GO_OVER,this.onFoodOver);
         lm.MoveTo(moveFoodLocation.x,moveFoodLocation.y);
      }
      
      private function onFoodOver(evt:Event) : void
      {
         var foodMc:MovieClip = null;
         var lm:I_LamuNPC = null;
         BC.removeEvent(this,evt.currentTarget,PeopleManageView.ON_GO_OVER,this.onFoodOver);
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var tableMc:MovieClip = this.findFoodTable(evt.currentTarget.lamuInfo);
         if(tableMc != null && tableMc.tableObj != null)
         {
            foodMc = tableMc.tableObj.emp.lamu.getChildByName("mc");
            if(foodMc != null)
            {
               foodMc.visible = true;
               foodMc.x = 0;
               foodMc.y = 0;
               tableMc.foodMc.addChild(foodMc);
            }
            lm = tableMc.tableObj.emp.lamu as I_LamuNPC;
            LamuInfo(lm["lamuInfo"]).PetCloth = 1200043;
            lm["refurbish"]();
            RestaurantEmp.getInstance().clearTableEmp(tableMc);
            this.addEatLamu(tableMc);
            this.tableGuestEatTimer(tableMc);
         }
      }
      
      private function tableGuestEatTimer(tableMc:MovieClip) : void
      {
         var delay:int = this.guestEatFoodTimer * 1000;
         GC.clearGInterval(tableMc.tableObj.lamu.eatTimer);
         tableMc.tableObj.lamu.eatTimer = GC.setGTimeout(this.onEatTimerHandler,delay,tableMc);
      }
      
      private function addEatLamu(tableMc:MovieClip) : void
      {
         var fxS:String = null;
         var eatlamulinkName:String = null;
         var eatlamuC:Class = null;
         var eatlamuMc:MovieClip = null;
         var tableNum:int = int(String(tableMc.name).slice(5));
         try
         {
            fxS = I_LamuNPC(tableMc.tableObj.lamu).boneManaage.currentDirection;
            eatlamulinkName = this.getEatlamulinkName(tableMc.tableObj.lamu);
            eatlamuC = GV.Lib_Map.getClass(eatlamulinkName) as Class;
            eatlamuMc = new eatlamuC();
            tableMc.tableObj.lamu.alpha = 0;
            eatlamuMc.gotoAndStop(fxS);
            eatlamuMc.name = "eatlamuMc" + tableMc.name;
            eatlamuMc.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["tablePoint" + tableNum].x;
            eatlamuMc.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel["tablePoint" + tableNum].y;
            eatlamuMc.PetColor = tableMc.tableObj.lamu.lamuInfo.PetColor;
            BC.addEvent(this,eatlamuMc,"eatLamuColor",this.onEatLamuColor);
            RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(eatlamuMc as DisplayObjectContainer);
            tableMc.tableObj.lamu.eatlamuMcName = eatlamuMc.name;
         }
         catch(e:Error)
         {
         }
      }
      
      private function onEatLamuColor(evt:*) : void
      {
         BC.removeEvent(this,evt.currentTarget,"eatLamuColor",this.onEatLamuColor);
         GF.setPetColor(evt.EventObj,evt.currentTarget.PetColor);
      }
      
      private function getEatlamulinkName(lamu:Object) : String
      {
         var ret:String = "";
         if(lamu.lamuInfo.skill_learnType == 0)
         {
            ret = "eatLamu" + lamu.lamuInfo.Petlevel;
         }
         else if(lamu.lamuInfo.skill_learnType > 0)
         {
            ret = "eatLamu" + lamu.lamuInfo.Petlevel + "_" + lamu.lamuInfo.skill_learnType;
         }
         return ret;
      }
      
      private function onEatTimerHandler(tableMc:MovieClip) : void
      {
         GC.clearGInterval(tableMc.tableObj.lamu.eatTimer);
         var depth_mc:MovieClip = this.restaurantBeen.getRestaurantMC().depth_mc;
         var buttonLevel:MovieClip = this.restaurantBeen.getRestaurantMC().buttonLevel;
         var exitGuest:MovieClip = tableMc.tableObj.lamu;
         tableMc.tableObj = null;
         if(tableMc.foodMc.getChildByName("mc") != null)
         {
            tableMc.foodMc.removeChild(tableMc.foodMc.getChildByName("mc"));
         }
         RestaurantView.getInstance().checkHouseFavor(1,exitGuest);
      }
      
      public function clearEatTimer() : void
      {
         var tableCount:int = int(RestaurantBeen.getInstance().getRestaurantInfo().houseInfo.houseTable);
         var depth_mc:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().depth_mc;
         for(var round:int = 1; round <= tableCount; round++)
         {
            if(depth_mc["table" + int(100 + round)].tableObj != null && depth_mc["table" + int(100 + round)].tableObj.lamu != null && depth_mc["table" + int(100 + round)].tableObj.lamu.eatTimer != null)
            {
               GC.clearGInterval(depth_mc["table" + int(100 + round)].tableObj.lamu.eatTimer);
            }
         }
      }
      
      private function changeFoodCount(foodObj:Object) : void
      {
         var foodArr:Array = null;
         var foodTableNum:int = 0;
         var depth_mc:MovieClip = null;
         var foodArrR:int = 0;
         var foodMc:MovieClip = null;
         foodObj.foodCount -= 1;
         if(foodObj.foodCount <= 0)
         {
            foodArr = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
            foodTableNum = int(this.restaurantBeen.getRestaurantInfo().houseInfo.houseFoodTable);
            depth_mc = this.restaurantBeen.getRestaurantMC().depth_mc;
            for(foodArrR = 0; foodArrR < foodArr.length; foodArrR++)
            {
               if(foodArr[foodArrR].foodCount == 0)
               {
                  foodMc = depth_mc["foodTable" + foodArr[foodArrR].foodLocation].getChildByName("mc");
                  depth_mc["foodTable" + foodArr[foodArrR].foodLocation].removeChild(foodMc);
                  depth_mc["foodTable" + foodArr[foodArrR].foodLocation].foodMakeObj = null;
                  RestaurantFood.getInstance().removeTaiBtn(this.restaurantBeen.getRestaurantMC().buttonLevel["taiBtn" + foodArr[foodArrR].foodLocation]);
                  foodArr.splice(foodArrR,1);
               }
            }
         }
      }
      
      private function checkHaveFood(tableMc:MovieClip) : Boolean
      {
         var randomnum:int = 0;
         var ret:Boolean = false;
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         var haveFoodArr:Array = this.randomFoodArr();
         if(haveFoodArr.length > 0)
         {
            randomnum = Math.random() * haveFoodArr.length;
            tableMc.tableObj.food = haveFoodArr[randomnum];
            ret = true;
         }
         return ret;
      }
      
      private function randomFoodArr() : Array
      {
         var ret:Array = new Array();
         var foodArr:Array = this.restaurantBeen.getRestaurantInfo().houseFoodInfo.foodArr;
         for(var foodRound:int = 0; foodRound < foodArr.length; foodRound++)
         {
            if(foodArr[foodRound].foodLocation > 50 && foodArr[foodRound].foodLocation < 101 && foodArr[foodRound].foodCount > 0)
            {
               ret.push(foodArr[foodRound]);
            }
         }
         return ret;
      }
      
      private function checkHaveEmp(tableMc:MovieClip, type:int) : Boolean
      {
         var ret:Boolean = false;
         var empArr:Array = this.restaurantBeen.getRestaurantInfo().housePeopleInfo.peopArr;
         for(var empRound:int = 0; empRound < empArr.length; empRound++)
         {
            if(empArr[empRound].EmpState == 1)
            {
               tableMc.tableObj.emp = empArr[empRound];
               empArr[empRound].EmpState = type;
               ret = true;
               break;
            }
         }
         return ret;
      }
      
      public function findFoodTable(obj:Object) : MovieClip
      {
         var empobj:Object = null;
         var ret:MovieClip = null;
         var empArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
         for(var round:int = 0; round < empArr.length; round++)
         {
            empobj = new Object();
            if(empArr[round].lamu != null)
            {
               empobj = empArr[round].lamu.lamuInfo;
               if(obj.masterID == empobj.masterID && obj.PetID == empobj.PetID)
               {
                  ret = RestaurantBeen.getInstance().getRestaurantMC().depth_mc["table" + empArr[round].EmpState];
               }
            }
         }
         return ret;
      }
      
      public function clearGuestTimer() : void
      {
         if(this.isJoin())
         {
            this.clearGT();
         }
      }
      
      private function clearGT() : void
      {
         var guestList:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseGuest;
         for(var r:int = 0; r < guestList.length; r++)
         {
            if(guestList[r].waitTimer != null)
            {
               GC.clearGInterval(guestList[r].waitTimer);
            }
         }
      }
      
      public function removeGuest() : void
      {
         var restaurantBeen:RestaurantBeen = RestaurantBeen.getInstance();
         var guestList:Array = restaurantBeen.getRestaurantInfo().houseGuest;
         for(var r:int = 0; r < guestList.length; r++)
         {
            if(guestList[r].lamu != null)
            {
               addLamuByRestaurant.getInstance().clearLamu(guestList[r].lamu);
            }
         }
      }
      
      public function isJoin() : Boolean
      {
         var num:int = 0;
         var ret:Boolean = false;
         var d:Date = ServerUpTime.getInstance().date;
         var day:int = d.getDay();
         var hours:int = d.getHours();
         if(hours >= 0 && hours < 6)
         {
            ret = false;
         }
         else if(day == 0 || day == 6 || day == 5)
         {
            ret = true;
         }
         else if(hours >= 12 && hours < 14 || hours >= 18 && hours < 21)
         {
            ret = true;
         }
         ret = true;
         if(!ret)
         {
            if(hours < 6)
            {
               num = new Date(d.fullYear,d.month,d.date,6).valueOf() - d.valueOf();
            }
            else if(hours < 12)
            {
               num = new Date(d.fullYear,d.month,d.date,12).valueOf() - d.valueOf();
            }
            else
            {
               if(hours >= 18)
               {
                  return ret;
               }
               num = new Date(d.fullYear,d.month,d.date,18).valueOf() - d.valueOf();
            }
            setTimeout(this.init,num + 1000);
         }
         return ret;
      }
      
      public function checkDate(d:Date) : int
      {
         return 0;
      }
      
      public function notJoin(evt:EventTaomee) : void
      {
         var tableMc:MovieClip = null;
         var lm:I_LamuNPC = null;
         var exitGuest:MovieClip = null;
         var guestList:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseGuest;
         var empArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
         var buttonLevel:MovieClip = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel;
         var d:Date = ServerUpTime.getInstance().date;
         var day:int = d.getDay();
         var hours:int = d.getHours();
         for(var rr:int = 0; rr < empArr.length; rr++)
         {
            tableMc = this.findFoodTable(empArr[rr].lamu.lamuInfo);
            if(tableMc != null && tableMc.tableObj != null && tableMc.tableObj.emp != null && tableMc.tableObj.emp.lamu != null)
            {
               lm = tableMc.tableObj.emp.lamu as I_LamuNPC;
               LamuInfo(lm["lamuInfo"]).PetCloth = 1200043;
               lm["refurbish"]();
               RestaurantEmp.getInstance().clearTableEmp(tableMc);
               exitGuest = tableMc.tableObj.lamu;
               tableMc.tableObj = null;
               RestaurantGuest.getInstance().clearGuest(exitGuest as MovieClip);
               exitGuest.autoMove = false;
               BC.addEvent(this,exitGuest,PeopleManageView.ON_GO_OVER,RestaurantView.getInstance().onExitHouse);
               exitGuest.MoveTo(buttonLevel.exitPonit.x,buttonLevel.exitPonit.y);
               this.clearGT();
            }
         }
      }
      
      public function destroy() : void
      {
         RestaurantGuest.instance = null;
      }
   }
}

