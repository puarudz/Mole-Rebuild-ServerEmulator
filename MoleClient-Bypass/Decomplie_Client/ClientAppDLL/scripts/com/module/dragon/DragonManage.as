package com.module.dragon
{
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.event.dragon.DragonInfoEvent;
   import com.view.PeopleView.PeopleManageView;
   
   public class DragonManage
   {
      
      private static var instance:DragonManage;
      
      public function DragonManage()
      {
         super();
         instance = this;
      }
      
      public static function getInstance() : DragonManage
      {
         return Boolean(instance) ? instance : new DragonManage();
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"getDragonInfo",this.driveDragin);
      }
      
      public function driveDragin(E:DragonInfoEvent) : void
      {
         var people:PeopleManageView = null;
         var dragonInfo:DragonInfo = E.getData;
         if(dragonInfo.State == 0)
         {
            this.downDragin(E);
            return;
         }
         if(dragonInfo.State == 1)
         {
            people = GF.getPeopleByID(dragonInfo.UserID) as PeopleManageView;
            if(Boolean(people))
            {
               people.addDragon(dragonInfo);
            }
         }
      }
      
      public function downDragin(E:DragonInfoEvent) : void
      {
         var dragonInfo:DragonInfo = E.getData;
         var UserID:int = int(E.EventObj.UserID);
         var people:PeopleManageView = GF.getPeopleByID(UserID) as PeopleManageView;
         if(Boolean(people) && Boolean(people.dragon_Info) && dragonInfo.ItemID == people.dragon_Info.ItemID)
         {
            people.delDragon();
         }
      }
   }
}

