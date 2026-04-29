package com.module.tommyWork
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.doWork.DoWorkSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.pet.petClassLearnStatus;
   import com.module.pet.petLogic;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class nicWork
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var itemID:Number;
      
      public var price:Number;
      
      public var TipStr:String;
      
      private var tipName:String;
      
      public var BuyTip:MovieClip;
      
      public var buy_Err:MovieClip;
      
      public var Buy_suc:MovieClip;
      
      public var NicWorkMC:MovieClip;
      
      private var sgm_mc:MovieClip;
      
      private var working:Boolean;
      
      private var kaddish_mc:MovieClip;
      
      private var myAlert:*;
      
      private var petTimer:Timer;
      
      public var tempLoader:Loader;
      
      public var nicworktype:String;
      
      public function nicWork(mc:MovieClip)
      {
         super();
         this.target_mc = mc;
         this.init();
      }
      
      private function init() : void
      {
         var randomNum:int = Math.floor(Math.random() * 50);
         this.target_mc.discreteness_nic.x += randomNum;
         this.tempLoader = new Loader();
      }
      
      public function nicTask() : void
      {
         var url:String = null;
         var btns:String = null;
         var info:String = null;
         if(Boolean(GV.JobLogics.chartbagClothFun([[12052]])))
         {
            finishSomethingReq.sendReq(8);
            GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         }
         else
         {
            url = "resource/allJob/AlertPic/nic11.swf";
            btns = "iknow";
            info = "    你必須穿好侍者衣服才能進行打掃哦！如果你還沒有領取的話，可以在我身邊的找到它們。";
            Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
         }
      }
      
      private function dofinishSomething(e:EventTaomee) : void
      {
         var url:String = null;
         var btns:String = null;
         var info:String = null;
         var tempMC:Class = null;
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         if(e.EventObj.Type == 8)
         {
            if(e.EventObj.Done == 1)
            {
               url = "resource/allJob/AlertPic/nic11.swf";
               btns = "iknow";
               info = "    你可真是一個勤勞的小摩爾哦！不過你今天已經參加過餐廳打工了，有時間可以幫助媽媽做點事，回去好好休息，養足精神明天再來吧！";
               this.myAlert = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
            }
            else if(!this.NicWorkMC)
            {
               tempMC = GV.Lib_Map.getClass("nic_work") as Class;
               this.NicWorkMC = new tempMC();
               this.NicWorkMC.name_txt.text = "    嘿！" + LocalUserInfo.getNickName() + "，想來打工嗎？穿上侍者服，認真打工2分鐘，你就能拿到一份不錯的報酬。我還要提醒你哦：打工要專心，幹幹就跑了，我可不會付你工資的。";
               MainManager.getAppLevel().addChild(this.NicWorkMC);
               this.NicWorkMC.x = 388;
               this.NicWorkMC.y = 100;
               this.NicWorkMC.close_btn.addEventListener(MouseEvent.CLICK,this.closePanel);
               this.NicWorkMC.work1.addEventListener(MouseEvent.CLICK,this.dowork);
               this.NicWorkMC.work2.addEventListener(MouseEvent.CLICK,this.dowork);
               this.NicWorkMC.work3.addEventListener(MouseEvent.CLICK,this.dowork);
            }
         }
      }
      
      private function closePanel(e:* = null) : void
      {
         if(Boolean(this.NicWorkMC))
         {
            this.NicWorkMC.close_btn.removeEventListener(MouseEvent.CLICK,this.closePanel);
            this.NicWorkMC.work1.removeEventListener(MouseEvent.CLICK,this.dowork);
            this.NicWorkMC.work2.removeEventListener(MouseEvent.CLICK,this.dowork);
            this.NicWorkMC.work3.removeEventListener(MouseEvent.CLICK,this.dowork);
            this.NicWorkMC.parent.removeChild(this.NicWorkMC);
            this.NicWorkMC = null;
         }
      }
      
      private function donotwork(e:*) : void
      {
      }
      
      private function dowork(evt:*) : void
      {
         var str:String = null;
         var ran:Number = NaN;
         if(!this.working)
         {
            this.nicworktype = evt.target.name;
            this.petTimer = new Timer(120000,1);
            this.petTimer.addEventListener(TimerEvent.TIMER,this.kaddishSuc);
            GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
            this.petTimer.reset();
            this.petTimer.start();
            this.loadMoleWorking();
            this.closePanel();
            if(PeopleManageView(GV.MAN_PEOPLE).Petlevel > 1 && petLogic.PetCan(1))
            {
               str = "";
               ran = Math.random();
               if(ran > 0.7)
               {
                  str = LocalUserInfo.getNickName() + "加油！勞動最光榮！";
               }
               else if(ran < 0.3)
               {
                  str = "加把勁兒啊，你是最棒的！";
               }
               else
               {
                  str = LocalUserInfo.getNickName() + "努力工作,我們一會再玩捉迷藏！";
               }
               PeopleManageView(GV.MAN_PEOPLE).lamu_say(str);
            }
         }
      }
      
      private function kaddishEndHandler(evt:EventTaomee) : void
      {
         this.petTimer.removeEventListener(TimerEvent.TIMER,this.kaddishSuc);
         this.working = false;
         this.clearKaddish_mc();
         this.petTimer.stop();
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
      }
      
      private function loadMoleWorking() : void
      {
         var peopleMC:MovieClip = null;
         var tempMC:Class = null;
         if(!this.working)
         {
            this.working = true;
            peopleMC = GV.MAN_PEOPLE.avatarMC.tomatoMC;
            if(!peopleMC.getChildByName("kaddish_mc"))
            {
               tempMC = GV.Lib_Map.getClass("nic_working") as Class;
               this.kaddish_mc = new tempMC();
               this.kaddish_mc.name = "kaddish_mc";
               this.kaddish_mc.gotoAndPlay(this.nicworktype);
               peopleMC.addChild(this.kaddish_mc);
            }
         }
      }
      
      private function kaddishSuc(evt:TimerEvent) : void
      {
         trace("--------------------成功");
         DoWorkSocket.doWork_getMoney(2);
         GV.onlineSocket.addEventListener("read_" + 1481,this.dofinishwork);
         GV.onlineSocket.addEventListener("hasLevel_" + 1481,this.dofinishwork2);
         GV.onlineSocket.addEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         this.clearKaddish_mc();
      }
      
      private function errorDofinishwork(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         var url:String = "resource/allJob/AlertPic/nic11.swf";
         var btns:String = "iknow";
         var info:String = "    你可真是一個勤勞的小摩爾哦！不過你今天已經參加過餐廳打工了，有時間可以幫助媽媽做點事，回去好好休息，養足精神明天再來吧！";
         this.myAlert = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"SMCUI");
      }
      
      private function dofinishwork(e:EventTaomee) : void
      {
         var info:String = null;
         GV.onlineSocket.removeEventListener("read_" + 1481,this.dofinishwork);
         var url:String = "resource/allJob/icon/" + "money" + ".swf";
         var btns:String = "iknow";
         var get:int = int(e.EventObj) - LocalUserInfo.getYXQ();
         LocalUserInfo.setYXQ(int(e.EventObj));
         var classObj:petClassLearnStatus = petLogic.getPetMagicClass(GV.MAN_PEOPLE as PeopleManageView);
         info = "　　感謝你的辛勤勞動，10000摩爾豆已經放入你的百寶箱中。";
         var task408Alert:* = Alert.showAlert(GV.MC_AppLever,url,info,Alert.CHANG_ALERT,btns,true,false,"EMP_BUY");
         task408Alert.addEventListener(Alert.CLICK_ + "1",this.task408Fun);
      }
      
      private function task408Fun(evt:*) : void
      {
      }
      
      private function dofinishwork2(E:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("hasLevel_" + 1481,this.dofinishwork2);
         if(E.EventObj == 1)
         {
            Alert.smileAlart("　　恭喜你成為摩爾莊園總工程師！",function(E:*):void
            {
               try
               {
                  GV.map_ManagerChange.refreshMap();
               }
               catch(E:Error)
               {
               }
            });
         }
      }
      
      private function clearKaddish_mc() : void
      {
         GC.stopAllMC(this.kaddish_mc);
         GC.clearChildren(this.kaddish_mc);
         this.kaddish_mc.parent.removeChild(this.kaddish_mc);
         this.kaddish_mc = null;
      }
      
      public function destroy() : void
      {
         if(this.petTimer != null)
         {
            this.petTimer.stop();
            this.petTimer.removeEventListener(TimerEvent.TIMER,this.kaddishSuc);
            this.petTimer = null;
         }
         this.closePanel();
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         GV.onlineSocket.removeEventListener("ERROR_CMD_" + 1481,this.errorDofinishwork);
         GV.onlineSocket.removeEventListener("hasLevel_" + 1481,this.dofinishwork2);
         this.target_mc = null;
         this.depth_mc = null;
      }
   }
}

