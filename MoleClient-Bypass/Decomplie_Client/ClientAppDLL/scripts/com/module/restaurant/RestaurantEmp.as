package com.module.restaurant
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import flash.display.MovieClip;
   
   public class RestaurantEmp
   {
      
      private static var instance:RestaurantEmp;
      
      private static var canotNew:Boolean = true;
      
      private var empArr:Array;
      
      private var restaurantBeen:RestaurantBeen;
      
      private var addLamu:addLamuByRestaurant;
      
      public function RestaurantEmp()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantEmp不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantEmp
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantEmp();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         this.restaurantBeen = RestaurantBeen.getInstance();
         this.addLamu = addLamuByRestaurant.getInstance();
         this.empArr = this.restaurantBeen.getRestaurantInfo().housePeopleInfo.peopArr;
         for(var empRound:int = 0; empRound < this.empArr.length; empRound++)
         {
            this.empArr[empRound].TimerBeginCount = int(new Date().getTime() / 1000);
            this.addLamu.addLamuMc(this.empArr[empRound],0);
         }
      }
      
      public function removeEmpUser(evt:EventTaomee) : void
      {
         var lmif:LamuInfo = null;
         var tableMc:MovieClip = null;
         var exitGuest:MovieClip = null;
         var lm:I_LamuNPC = null;
         var obj:Object = evt.EventObj;
         for(var round:int = 0; round < this.empArr.length; round++)
         {
            if(obj.Userid == this.empArr[round].Userid && obj.Petid == this.empArr[round].Petid)
            {
               lmif = this.empArr[round].lamu.lamuInfo;
               tableMc = RestaurantGuest.getInstance().findFoodTable(lmif);
               if(this.empArr[round].lamu != null)
               {
                  addLamuByRestaurant.getInstance().clearLamu(this.empArr[round].lamu);
                  GC.clearGInterval(this.empArr[round].setGCT);
               }
               if(LocalUserInfo.getUserID() == this.empArr[round].Userid)
               {
                  GV.MyInfo_Pet = 0;
               }
               if(tableMc != null)
               {
                  lm = tableMc.tableObj.emp.lamu as I_LamuNPC;
                  LamuInfo(lm["lamuInfo"]).PetCloth = 1200043;
                  lm["refurbish"]();
                  RestaurantEmp.getInstance().clearTableEmp(tableMc);
                  exitGuest = tableMc.tableObj.lamu;
                  tableMc.tableObj = null;
               }
               else
               {
                  exitGuest = this.empArr[round].lamu;
               }
               RestaurantView.getInstance().checkHouseFavor(0,exitGuest);
               this.empArr.splice(round,1);
               break;
            }
         }
      }
      
      public function addEmpUser(evt:EventTaomee) : void
      {
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - evt.EventObj.PetEmpMoney);
         var obj:Object = evt.EventObj;
         obj.TimerBeginCount = int(new Date().getTime() / 1000);
         this.empArr.push(obj);
         this.addLamu.addLamuMc(obj,0);
         if(LocalUserInfo.getUserID() == obj.Userid)
         {
            GV.MAN_PEOPLE.delPet();
            GV.MAN_PEOPLE.delTarget();
            GV.MAN_PEOPLE.Petlevel = 0;
         }
      }
      
      public function checkEmpTimer() : void
      {
         var num:int = 0;
         var count:int = 0;
         for(var empRound:int = 0; empRound < this.empArr.length; empRound++)
         {
            num = int(new Date().getTime() / 1000) - this.empArr[empRound].TimerBeginCount;
            count = this.empArr[empRound].PetEndTime + num;
            if(count >= this.empArr[empRound].PetTimelimit)
            {
               this.sendRemoveEmp(this.empArr[empRound]);
               break;
            }
            trace("繼續幹活");
         }
      }
      
      private function sendRemoveEmp(empObj:Object) : void
      {
         if(this.restaurantBeen.isMyRestaurant())
         {
            Alert.smileAlart("你的僱員" + empObj.PetName + "已經到期了！");
         }
         oneBigStreetSocket.removeEmpUser(empObj.Userid,empObj.Petid);
      }
      
      public function clearTableEmp(tableMc:MovieClip) : void
      {
         tableMc.tableObj.emp.lamu.autoMove = true;
         tableMc.tableObj.emp.EmpState = 1;
         var empArr:Array = this.restaurantBeen.getRestaurantInfo().housePeopleInfo.peopArr;
         for(var empRound:int = 0; empRound < empArr.length; empRound++)
         {
            if(tableMc.tableObj.emp.Userid == empArr[empRound].Userid && tableMc.tableObj.emp.Petid == empArr[empRound].Petid)
            {
               if(empArr[empRound].PetEndTime >= empArr[empRound].PetTimelimit)
               {
                  if(this.restaurantBeen.isMyRestaurant())
                  {
                     Alert.smileAlart("你的僱員" + empArr[empRound].PetName + "已經到期了！");
                     oneBigStreetSocket.removeEmpUser(empArr[empRound].Userid,empArr[empRound].Petid);
                  }
                  else
                  {
                     addLamuByRestaurant.getInstance().clearLamu(empArr[empRound].lamu);
                     GC.clearGInterval(empArr[empRound].setGCT);
                     empArr.splice(empRound,1);
                  }
               }
            }
         }
         tableMc.tableObj.emp = null;
      }
      
      public function changeEmpState() : void
      {
         var empArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
         for(var empRound:int = 0; empRound < empArr.length; empRound++)
         {
            empArr[empRound].EmpState = 1;
         }
      }
      
      public function removeEmp() : void
      {
         var restaurantBeen:RestaurantBeen = RestaurantBeen.getInstance();
         var empList:Array = restaurantBeen.getRestaurantInfo().housePeopleInfo.peopArr;
         for(var r:int = 0; r < empList.length; r++)
         {
            if(empList[r].lamu != null)
            {
               addLamuByRestaurant.getInstance().clearLamu(empList[r].lamu);
            }
         }
      }
   }
}

