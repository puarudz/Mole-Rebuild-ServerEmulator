package com.logic.PetClassLogic
{
   import com.event.EventTaomee;
   import com.view.mapView.SilkyHouseView;
   
   public class PowerClassInfo
   {
      
      private static var Instanse:PowerClassInfo;
      
      private var petID:uint;
      
      private var _fishFlag:Boolean = false;
      
      public var scene:*;
      
      private var dataArr:Array;
      
      public function PowerClassInfo()
      {
         super();
         this.petID = GV.MyInfo_PetObj.SpriteID;
      }
      
      public static function getInstanse() : PowerClassInfo
      {
         if(Instanse == null)
         {
            Instanse = new PowerClassInfo();
         }
         return Instanse;
      }
      
      public function get workFlag() : Boolean
      {
         var flag:Boolean = false;
         if(Boolean(this.dataArr) && Boolean(this.dataArr[5]))
         {
            flag = true;
         }
         return flag;
      }
      
      public function get finishFlag() : Boolean
      {
         return this._fishFlag;
      }
      
      public function get hasDingzi() : Boolean
      {
         var flag:Boolean = false;
         if(Boolean(this.dataArr) && Boolean(this.dataArr[6]))
         {
            flag = true;
         }
         return flag;
      }
      
      public function get hasBanzi() : Boolean
      {
         var flag:Boolean = false;
         if(Boolean(this.dataArr) && Boolean(this.dataArr[7]))
         {
            flag = true;
         }
         return flag;
      }
      
      public function getDingzi() : void
      {
         if(Boolean(this.dataArr) && this.petID != 0)
         {
            this.dataArr[6] = 1;
            PetClassLogic.getPetClassLogics().setClassData(this.petID,102,this.dataArr);
         }
      }
      
      public function getMuban() : void
      {
         if(Boolean(this.dataArr) && this.petID != 0)
         {
            this.dataArr[7] = 1;
            PetClassLogic.getPetClassLogics().setClassData(this.petID,102,this.dataArr);
         }
      }
      
      public function repairHouse() : void
      {
         if(Boolean(this.dataArr) && this.petID != 0)
         {
            this.dataArr[8] = 1;
            PetClassLogic.getPetClassLogics().setClassData(this.petID,102,this.dataArr);
         }
      }
      
      public function getClassData() : void
      {
         if(this.petID != 0)
         {
            PetClassLogic.getPetClassLogics().addEventListener("get_petclass",this.getInfoHandler);
            PetClassLogic.getPetClassLogics().GetPetClass(this.petID);
         }
      }
      
      private function getInfoHandler(evt:EventTaomee) : void
      {
         PetClassLogic.getPetClassLogics().removeEventListener("get_petclass",this.getInfoHandler);
         var obj:* = evt.EventObj.petClassList[0];
         if(obj != null && obj.classID == 102)
         {
            if(obj.classStep == 5)
            {
               PetClassLogic.getPetClassLogics().getClassData(this.petID,102);
               PetClassLogic.getPetClassLogics().addEventListener("get_class_data",this.getPowerHandler);
            }
            else if(obj.classStep == 6)
            {
               this._fishFlag = true;
               if(this.scene is SilkyHouseView)
               {
                  this.scene.powerFun();
               }
            }
         }
      }
      
      private function getPowerHandler(evt:EventTaomee) : void
      {
         PetClassLogic.getPetClassLogics().removeEventListener("get_class_data",this.getInfoHandler);
         var obj:* = evt.EventObj.obj;
         this.dataArr = obj.arr;
         if(this.dataArr[8] == 1)
         {
            this._fishFlag = true;
         }
         if(this.dataArr[5] == 1)
         {
            if(this.scene is SilkyHouseView)
            {
               this.scene.powerFun();
            }
            if(this.dataArr[7] == 0)
            {
            }
         }
      }
      
      public function clear() : void
      {
         this.scene = null;
         Instanse = null;
         this.dataArr = null;
         PetClassLogic.getPetClassLogics().removeEventListener("get_class_data",this.getPowerHandler);
         PetClassLogic.getPetClassLogics().removeEventListener("get_petclass",this.getInfoHandler);
      }
      
      public function saveArr(obj:*) : void
      {
      }
   }
}

