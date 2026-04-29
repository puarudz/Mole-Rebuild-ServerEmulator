package com.module.car
{
   import com.core.car.carInfo.CarInfo;
   import com.event.car.CarInfoEvent;
   import com.view.PeopleView.PeopleManageView;
   
   public class CarManage
   {
      
      private static var instance:CarManage;
      
      public function CarManage()
      {
         super();
         instance = this;
      }
      
      public static function getInstance() : CarManage
      {
         return Boolean(instance) ? instance : new CarManage();
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"getCarInfo",this.driveCar);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1701,this.downCar);
      }
      
      public function driveCar(E:CarInfoEvent) : void
      {
         var carInfo:CarInfo = E.getData;
         var people:PeopleManageView = GF.getPeopleByID(carInfo.UserID) as PeopleManageView;
         if(Boolean(people))
         {
            people.addCar(carInfo);
         }
      }
      
      public function downCar(E:CarInfoEvent) : void
      {
         var UserID:int = int(E.EventObj.UserID);
         var people:PeopleManageView = GF.getPeopleByID(UserID) as PeopleManageView;
         if(Boolean(people))
         {
            people.delCar();
         }
      }
   }
}

