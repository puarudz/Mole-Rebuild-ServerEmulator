package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.common.tip.NpcDialogBox;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.PetClassLogic.PetClassLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Map76PMClass extends Sprite
   {
      
      private var targetMC:MovieClip;
      
      private var moveMC:MovieClip;
      
      private var one_arr:Array = new Array();
      
      private var num_time:Timer;
      
      private var boxMC:NpcDialogBox;
      
      private var pet_id:uint;
      
      private var myT:Timer;
      
      public function Map76PMClass()
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         super();
      }
      
      public function Info() : void
      {
         var tempMC:MovieClip = GV.MC_mapFrame["control_mc"];
         var tempMCB:MovieClip = GV.MC_mapFrame["buttonLevel"];
         this.targetMC = tempMC.box_PM_btn;
         this.targetMC.buttonMode = false;
         this.moveMC = tempMCB.SL_class_mc;
         if(!GV.JobLogics.havePetFollow())
         {
            return;
         }
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         this.pet_id = peopleView.PetID;
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getNowInfo);
         PetClassLogic.getPetClassLogics().GetPetClass(this.pet_id);
      }
      
      private function getNowInfo(eve:EventTaomee) : void
      {
         var one_arrs:Array = null;
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GET_PETCLASS,this.getNowInfo);
         if(eve.EventObj.petClassList.length == 0)
         {
            return;
         }
         var pet_info:Object = null;
         for(var i:uint = 0; i < eve.EventObj.petClassList.length; i++)
         {
            if(eve.EventObj.petClassList[i].classID == 101)
            {
               pet_info = {};
               pet_info = eve.EventObj.petClassList[i];
            }
         }
         if(pet_info == null)
         {
            return;
         }
         if(pet_info.classStep == 5)
         {
            one_arrs = pet_info.arr.slice(0,6);
            this.one_arr = pet_info.arr;
            if(one_arrs.indexOf(0) == -1)
            {
               if(this.one_arr[6] == 0)
               {
                  this.targetMC.buttonMode = true;
                  this.moveMC.gotoAndStop(1);
                  BC.addEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseFun);
               }
            }
         }
      }
      
      private function mouseFun(eve:MouseEvent) : void
      {
         BC.removeEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseFun);
         this.targetMC.visible = false;
         this.moveMC.gotoAndStop(2);
         this.moveMC.buttonMode = true;
         BC.addEvent(this,this.moveMC,MouseEvent.CLICK,this.mouseTwoFun);
      }
      
      private function mouseTwoFun(eve:MouseEvent) : void
      {
         BC.removeEvent(this,this.moveMC,MouseEvent.CLICK,this.mouseTwoFun);
         this.moveMC.gotoAndStop(3);
         BC.addEvent(this,this.moveMC,MouseEvent.CLICK,this.mouseThreeFun);
      }
      
      private function mouseThreeFun(eve:MouseEvent) : void
      {
         BC.removeEvent(this,this.moveMC,MouseEvent.CLICK,this.mouseThreeFun);
         this.moveMC.gotoAndStop(4);
         this.moveMC.buttonMode = false;
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            GV.MAN_PEOPLE.petmc.visible = false;
         }
         this.myT = GC.setGTimeout(this.getItemFun,11000);
      }
      
      private function getItemFun() : void
      {
         GC.clearGTimeout(this.myT);
         this.myT = null;
         this.one_arr[6] = 1;
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GETCLASSDATA,this.getPetInfo);
         PetClassLogic.getPetClassLogics().getClassData(this.pet_id,101);
      }
      
      private function getPetInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.GETCLASSDATA,this.getPetInfo);
         BC.addEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SETCLASSDATA,this.setPetInfo);
         PetClassLogic.getPetClassLogics().setClassData(this.pet_id,101,this.one_arr);
      }
      
      private function setPetInfo(eve:EventTaomee) : void
      {
         var myAlt:* = undefined;
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SETCLASSDATA,this.setPetInfo);
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            GV.MAN_PEOPLE.petmc.visible = true;
         }
         var msg:String = "";
         var url:String = "";
         url = "";
         msg = "    恭喜！你獲得了氣球！";
         myAlt = Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      public function setTipMC(msg:String) : void
      {
         this.boxMC = new NpcDialogBox(this.targetMC,0,0,1);
         this.boxMC.show(msg);
         this.num_time = GC.setGTimeout(this.closeTipFun,10000);
      }
      
      public function closeTipFun() : void
      {
         if(this.boxMC != null)
         {
            GC.clearGTimeout(this.num_time);
            this.boxMC.destroy();
         }
         this.boxMC = null;
      }
      
      private function removeEvent(eve:Event = null) : void
      {
         BC.removeEvent(this);
         if(this.myT != null)
         {
            GC.clearGTimeout(this.myT);
            this.myT = null;
         }
         this.closeTipFun();
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
      }
   }
}

