package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.simpleAlert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.GetItemCount.*;
   import com.module.sendBirthdayCard.ChargeGiveThing;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class JobMap28View
   {
      
      public static var LahmRunning:Boolean;
      
      public var target_mc:MovieClip;
      
      public var run_mc:MovieClip;
      
      public var finishRunID:uint;
      
      public var FinishRunJob:Boolean;
      
      public function JobMap28View(mc:MovieClip)
      {
         super();
         this.target_mc = mc;
         var randomNumX:int = Math.floor(Math.random() * 50);
         var randomNumY:int = Math.floor(Math.random() * 20);
         this.target_mc.discreteness_tommy.x += randomNumX;
         this.target_mc.discreteness_tommy.y -= randomNumY;
         this.run_mc = this.target_mc.petGameBtn;
         GC.stopAllMC(this.run_mc.pet);
         GV.onlineSocket.addEventListener("move_for_game",this.RunTip);
         GV.onlineSocket.addEventListener("lahm_go_home",this.run_mcStop);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function run_mcStop(e:Event) : void
      {
         this.run_mc.gotoAndStop(1);
         GC.stopAllMC(this.run_mc.pet);
         this.kaddishEndHandler();
      }
      
      public function RunTip(e:Event) : void
      {
         var url:String = null;
         var msg:String = null;
         var myAlert:simpleAlert = null;
         if(this.run_mc.currentFrame == 2)
         {
            this.kaddishEndHandler();
         }
         else if(GV.MyInfo_PetObj.Level > 1)
         {
            this.chartFun();
         }
         else
         {
            url = "resource/allJob/icon/paobu1.swf";
            msg = "    這可是發明家大衛我為拉姆發明的新型跑步機！你要帶著拉姆才能鍛煉！";
            myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
      }
      
      public function doyes(e:Object) : void
      {
         this.chartFun();
      }
      
      public function dono(e:Object) : void
      {
      }
      
      public function chartFun() : void
      {
         var url:String = "resource/allJob/icon/paobu2.swf";
         var msg:String = "    現在開始讓你的拉姆跑步嗎？";
         var myAlert:simpleAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.startRun,false,0,true);
         this.FinishRunJob = true;
      }
      
      private function startRun(e:Event) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("iskaddish"));
         this.lahmRun();
      }
      
      private function backSand(e:Object) : void
      {
         GV.JobViews.showJob(55);
      }
      
      private function finishRun() : void
      {
         trace("完成跑步");
         LahmRunning = false;
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.avatarClass.avatarMC.pet_mc.visible = true;
         this.run_mc.gotoAndStop(1);
         var arr:Array = [{
            "id":180022,
            "name":"一瓶清爽沐浴露"
         },{
            "id":180019,
            "name":"一塊水晶蛋糕"
         },{
            "id":180014,
            "name":"一瓶運動可樂"
         }];
         var obj:Object = arr[uint(Math.random() * 3)];
         var chargeGiveThing:ChargeGiveThing = new ChargeGiveThing();
         chargeGiveThing.itemID = obj.id;
         chargeGiveThing.itemCount = 1;
         chargeGiveThing.msg = "我真高興看到你的拉姆在堅持鍛煉！送你" + obj.name + "，再接再“厲”哦!";
         chargeGiveThing.url = "resource/pet/icon/" + obj.id + ".swf";
         chargeGiveThing.panle = 0;
         chargeGiveThing.getThing();
      }
      
      private function lahmRun() : void
      {
         var mc:MovieClip = null;
         for(var i:uint = 0; i < this.run_mc.pet.numChildren; i++)
         {
            mc = this.run_mc.pet.getChildAt(i);
            if(Boolean(mc))
            {
               mc.play();
            }
         }
         LahmRunning = true;
         this.finishRunID = setTimeout(this.finishRun,60000);
         GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.avatarClass.avatarMC.pet_mc.visible = false;
         this.run_mc.gotoAndStop(2);
         GF.setPetColor(this.run_mc.pet.petBody,GV.MyInfo_PetObj.Color);
      }
      
      private function kaddishEndHandler(e:Event = null) : void
      {
         LahmRunning = false;
         clearTimeout(this.finishRunID);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.avatarClass.avatarMC.pet_mc.visible = true;
         this.run_mc.gotoAndStop(1);
      }
      
      private function removeEventHandler(evetn:EventTaomee = null) : void
      {
         LahmRunning = false;
         GV.onlineSocket.removeEventListener("lahm_go_home",this.run_mcStop);
         GV.onlineSocket.removeEventListener("move_for_game",this.RunTip);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         BC.removeEvent(this);
      }
   }
}

