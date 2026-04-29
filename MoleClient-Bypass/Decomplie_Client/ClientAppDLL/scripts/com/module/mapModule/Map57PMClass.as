package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.common.tip.NpcDialogBox;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.PetClassLogic.PetClassLogic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Map57PMClass extends Sprite
   {
      
      private var targetMC:MovieClip;
      
      private var tipMC:MovieClip;
      
      private var one_arr:Array;
      
      private var num_time:Timer;
      
      private var boxMC:NpcDialogBox;
      
      private var pet_id:uint;
      
      private var MC_timer:Timer;
      
      public function Map57PMClass()
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEvent);
         super();
      }
      
      public function Info(tempMC:MovieClip, tempBMC:MovieClip) : void
      {
         this.targetMC = tempMC.SL_class_mc;
         this.targetMC.visible = false;
         this.tipMC = tempBMC.tip_mc;
         if(!GV.JobLogics.havePetFollow())
         {
            return;
         }
         this.pet_id = GV.MyInfo_PetObj.SpriteID;
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
               if(this.one_arr[7] == 0)
               {
                  this.targetMC.visible = true;
                  this.targetMC.buttonMode = true;
                  this.targetMC.gotoAndStop(1);
                  this.setTipMC("氣球。。。我想要氣球。");
                  if(this.one_arr[6] > 0)
                  {
                     BC.addEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseFun);
                  }
               }
            }
         }
      }
      
      private function mouseFun(eve:MouseEvent) : void
      {
         var myAlt:* = undefined;
         BC.removeEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseFun);
         var msg:String = "";
         var url:String = "";
         this.closeTipFun();
         this.setTipMC("謝謝你給我氣球，可是我還是很傷心。。。");
         this.targetMC.MC.gotoAndPlay(2);
         this.MC_timer = GC.setGTimeout(this.set1MouseFun,3000);
      }
      
      private function set1MouseFun() : void
      {
         GC.clearGTimeout(this.MC_timer);
         this.MC_timer = null;
         this.targetMC.gotoAndStop(2);
         BC.addEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseTwoFun);
      }
      
      private function mouseTwoFun(eve:MouseEvent) : void
      {
         var myAlt:* = undefined;
         var msg:String = "";
         var url:String = "";
         url = "resource/allJob/AlertPic/petMagicClass/map57_01.swf";
         msg = "    謝謝你送我氣球。rr    本來答應在我生日派對上表演魔術變身的叔叔突然生病沒法來了，好傷心，我等了好久。你能幫我完成心願嗎？";
         myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.beginTip);
      }
      
      private function beginTip(eve:Event) : void
      {
         var myAlt:* = undefined;
         BC.removeEvent(this,this.targetMC,MouseEvent.CLICK,this.mouseTwoFun);
         var msg:String = "";
         var url:String = "";
         url = "resource/allJob/AlertPic/petMagicClass/101_1.swf";
         msg = "    用你的魔法變身，完成小摩爾的心願吧！";
         myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         BC.addEvent(this,myAlt,Alert.CLICK_ + "1",this.addBIBO);
      }
      
      private function addBIBO(eve:Event) : void
      {
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            GV.MAN_PEOPLE.petmc.visible = false;
         }
         this.targetMC.MC.gotoAndPlay(2);
         this.MC_timer = GC.setGTimeout(this.set2MouseFun,9000);
      }
      
      private function set2MouseFun() : void
      {
         GC.clearGTimeout(this.MC_timer);
         this.MC_timer = null;
         this.targetMC.gotoAndStop(3);
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            GV.MAN_PEOPLE.petmc.visible = true;
         }
         this.closeTipFun();
         this.setTipMC("好棒！你的拉姆真厲害！");
         this.one_arr[7] = 1;
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
         BC.removeEvent(this,PetClassLogic.getPetClassLogics(),PetClassLogic.SETCLASSDATA,this.setPetInfo);
         this.targetMC.MC.gotoAndPlay(2);
         this.MC_timer = GC.setGTimeout(this.set3MouseFun,5000);
      }
      
      private function set3MouseFun() : void
      {
         var myAlt:* = undefined;
         GC.clearGTimeout(this.MC_timer);
         this.MC_timer = null;
         var msg:String = "";
         var url:String = "";
         url = "resource/allJob/AlertPic/petMagicClass/map57_02.swf";
         msg = "    哇，好棒，你的超級拉姆真厲害。我也要讓我的超級拉姆去學。到時候我也能讓他變身啦！快回魔法閣樓找你的老師領取畢業徽章吧。";
         myAlt = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
      }
      
      public function setTipMC(msg:String) : void
      {
         this.boxMC = new NpcDialogBox(this.tipMC,0,0,1);
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
         this.closeTipFun();
         if(Boolean(this.MC_timer))
         {
            GC.clearGTimeout(this.MC_timer);
            this.MC_timer = null;
         }
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEvent);
      }
   }
}

