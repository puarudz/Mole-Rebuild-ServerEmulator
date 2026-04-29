package com.module.restaurant
{
   import com.core.objectPool.ObjectPool;
   import com.module.npc.lamu.I_LamuNPC;
   import com.module.npc.lamu.LamuInfo;
   import com.module.npc.npcInstance.LamuNPC;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class addLamuByRestaurant
   {
      
      private static var instance:addLamuByRestaurant;
      
      private static var canotNew:Boolean = true;
      
      private var guestTimerNum:int;
      
      private var guestTimer:Timer;
      
      public function addLamuByRestaurant()
      {
         super();
         if(canotNew)
         {
            throw new Error("addLamuByRestaurant不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : addLamuByRestaurant
      {
         if(!instance)
         {
            canotNew = false;
            instance = new addLamuByRestaurant();
            canotNew = true;
         }
         return instance;
      }
      
      public function addLamuMc(petObjcet:Object, type:int = 0) : void
      {
         var PetObj:Object;
         var lamuinfo:LamuInfo;
         var arr:Array;
         var lamu:I_LamuNPC = null;
         if(type == 1)
         {
            petObjcet.byTable = 0;
         }
         RestaurantEmp.getInstance().checkEmpTimer();
         PetObj = {};
         PetObj.Pet_action = 0;
         if(type == 1)
         {
            PetObj.Pet_cloth = 0;
         }
         else
         {
            PetObj.Pet_cloth = 1200043;
         }
         PetObj.PetColor = petObjcet.PetColor;
         PetObj.Pet_honor = 0;
         PetObj.PetID = petObjcet.Petid;
         PetObj.Petlevel = petObjcet.PetLevel;
         PetObj.PetName = petObjcet.PetName;
         PetObj.PetSick = 0;
         PetObj.Reserved1 = 0;
         PetObj.Reserved2 = 0;
         PetObj.skill_Fire = 0;
         if(petObjcet.PetLevel == 5 && petObjcet.Petskill == 0)
         {
            PetObj.Skill_Type = 1;
         }
         PetObj.Skill_Type = petObjcet.Petskill;
         PetObj.Skill_Value = 1000;
         PetObj.skill_Water = 0;
         PetObj.skill_Wood = 0;
         PetObj.Status = 0;
         PetObj.UserID = petObjcet.Userid;
         lamuinfo = new LamuInfo(PetObj);
         lamuinfo.upData(PetObj);
         lamu = ObjectPool.getObject(LamuNPC) as I_LamuNPC;
         lamu.setMasterID(lamuinfo.masterID,lamuinfo);
         lamu.loadNPC(999);
         lamu.boneManaage.lamuName = PetObj.PetName;
         lamu["scaleX"] = lamu["scaleY"] = 1.2;
         arr = new Array();
         if(type == 0)
         {
            lamu.autoMove = true;
            arr = RestaurantBeen.getInstance().getRestaurantInfo().housePeopleInfo.peopArr;
            lamu.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel.movePoint51.x;
            lamu.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel.movePoint51.y;
            petObjcet.setGCT = GC.setGInterval(function():void
            {
               lamu["addToFloor"]();
               lamu.Speed = 60;
            },1000);
         }
         else if(type == 1)
         {
            lamu.autoMove = false;
            arr = RestaurantBeen.getInstance().getRestaurantInfo().houseGuest;
            lamu.x = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel.exitPonit.x;
            lamu.y = RestaurantBeen.getInstance().getRestaurantMC().buttonLevel.exitPonit.y;
            setTimeout(function():void
            {
               lamu.Speed = 60;
               lamu["addToFloor"]();
               lamu = null;
               lamuinfo = null;
            },1000);
         }
         this.saveShowLamuByArr(arr,lamu as LamuNPC);
         RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(lamu as DisplayObjectContainer);
         if(type == 1)
         {
            setTimeout(RestaurantGuest.getInstance().selectNnTable,1000,lamu as MovieClip);
            setTimeout(this.guestTimerFun,1000);
         }
      }
      
      public function saveShowLamuByArr(tempArr:Array, lamu:LamuNPC) : void
      {
         for(var round:int = 0; round < tempArr.length; round++)
         {
            if(tempArr[round].Userid == lamu.lamuInfo.masterID && tempArr[round].Petid == lamu.lamuInfo.PetID)
            {
               tempArr[round].lamu = lamu;
               break;
            }
         }
      }
      
      public function guestTimerFun() : void
      {
         var houseFavorN:Number = Number(RestaurantBeen.getInstance().getRestaurantInfo().houseInfo.houseFavor);
         this.guestTimerNum = 60 / (17 * houseFavorN / 10 / 95 + 40 / 19);
         if(this.guestTimerNum < 2)
         {
            this.guestTimerNum = 2;
         }
         var delay:int = this.guestTimerNum * 1000;
         trace("****************還要" + delay + "毫秒來人。****************");
         GC.clearGInterval(this.guestTimer);
         this.guestTimer = GC.setGInterval(this.onGuestTimerHandler,delay);
      }
      
      private function onGuestTimerHandler() : void
      {
         GC.clearGInterval(this.guestTimer);
         this.guestTimer = null;
         if(RestaurantGuest.getInstance().isJoin())
         {
            RestaurantGuest.getInstance().randomGuest();
         }
         else
         {
            RestaurantView.getInstance().businessing();
         }
      }
      
      public function claerGuestTimer() : void
      {
         GC.clearGInterval(this.guestTimer);
      }
      
      public function clearLamu(lamuMc:MovieClip) : void
      {
         if(Boolean(lamuMc))
         {
            lamuMc.clearClass();
            GC.stopAllMC(lamuMc);
            ObjectPool.disposeObject(lamuMc,LamuNPC,7);
            lamuMc = null;
         }
      }
      
      public function destroy() : void
      {
         addLamuByRestaurant.instance = null;
      }
   }
}

