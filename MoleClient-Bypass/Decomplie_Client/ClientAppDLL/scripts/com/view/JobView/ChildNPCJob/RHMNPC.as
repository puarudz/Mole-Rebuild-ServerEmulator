package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.freakClass.*;
   import com.view.JobView.ChildNPCJob.NPCanimation.Animation;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.*;
   
   public class RHMNPC extends EventDispatcher
   {
      
      private var PetMCArr:Array;
      
      private var PetBtArr:Array;
      
      private var Flag:uint = 0;
      
      private var NowPetObj:Object;
      
      private var timeoutNum:uint = 0;
      
      public function RHMNPC(MC_arr:Array, Btn_arr:Array)
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"wordMapChang_over",this.removeAll);
         this.PetMCArr = [];
         this.PetBtArr = [];
         this.PetMCArr = MC_arr;
         this.PetBtArr = Btn_arr;
         this.MouseLogFun();
      }
      
      private function MouseLogFun() : void
      {
         for(var i:uint = 0; i < this.PetMCArr.length; i++)
         {
            this.PetMCArr[i].visible = false;
            this.PetBtArr[i].addEventListener(MouseEvent.CLICK,this.chartDayJob);
         }
      }
      
      private function OKMouseMC(MC:MovieClip, Bt:*) : void
      {
         var temp:Animation = new Animation(MC,Bt);
      }
      
      private function chartDayJob(event:MouseEvent) : void
      {
         if(Boolean(GV.JobLogics.havePetFollow()))
         {
            this.NowPetObj = GV.MyInfo_PetObj;
            var str:String = event.target.name;
            this.Flag = uint(str.slice(4));
            if(Boolean(this.NowPetObj.Skill >> this.Flag & 1))
            {
               return;
            }
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.BeginJob);
            finishSomethingReq.sendReq(7);
            return;
         }
         this.showAlt(100);
      }
      
      private function BeginJob(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.BeginJob);
         if(event.EventObj.Type == 7 && event.EventObj.Done == 1)
         {
            this.showAlt(10);
         }
         else if(event.EventObj.Type == 7 && event.EventObj.Done == 0)
         {
            this.showAlt(this.Flag);
         }
      }
      
      private function showAlt(Type:uint = 0) : void
      {
         var myAlert:* = undefined;
         var msg:String = "";
         var url:String = "";
         switch(Type)
         {
            case 10:
               url = "resource/allJob/AlertPic/rhm_no.swf";
               msg = "    嗨~親愛的" + LocalUserInfo.getNickName() + "，很高興又見到你！你今天已經看過一次我們的表演啦！要想再看，明天再來吧！我們也要休息的，嘿嘿！";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
               return;
            case 100:
               msg = "    你沒有帶著拉姆哦！沒有拉姆我們可不表演哦^---^";
               myAlert = Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"otherJob_konw",true,false,"D");
               return;
            case 0:
               url = "resource/allJob/AlertPic/rhm_00.swf";
               msg = "    嘿~！你好，我是拉姆米米哈希奇，拉姆中的舞蹈之王。你想和你的拉姆一起看我的精彩舞蹈嗎？哈哈，認真欣賞1分鐘吧！看完我的表演也許你的拉姆也能學會哦！rr     想現在就看我舞蹈嗎？";
               break;
            case 1:
               url = "resource/allJob/AlertPic/rhm_10.swf";
               msg = "    哈羅哈~！我是拉姆米米克裡特，拉姆中的說唱高手！你想和你的拉姆一起看我的精彩說唱嗎？拉姆學院的新鮮事我可是都知道！專心看我表演1分鐘吧！你的拉姆也會變成百事通的！rr     現在就開始看我的說唱嗎？";
               break;
            case 2:
               url = "resource/allJob/AlertPic/rhm_20.swf";
               msg = "    嗨~你好！我是拉姆米米斯米奇。你想和你的拉姆一起看我塗鴉嗎？要專心看1分鐘訥！看完我塗鴉也許你的拉姆也學會啦！rr     現在就看我的塗鴉嗎？";
         }
         myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMCUI");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.studyOne);
         BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.backOne);
      }
      
      private function showOKFun(Type:uint = 0) : void
      {
         var myAlert:* = undefined;
         var msg:String = "";
         var url:String = "";
         switch(Type)
         {
            case 0:
               url = "resource/allJob/AlertPic/rhm_01.swf";
               msg = "    哇哦~沒想到你的拉姆舞蹈天賦還不錯，它已經學會一點兒舞蹈動作啦！當你把它帶在身邊跳舞時，它也會跟著你翩翩起舞的！";
               break;
            case 1:
               url = "resource/allJob/AlertPic/rhm_11.swf";
               msg = "    哇，你的拉姆記憶力不錯，已經跟我學會了唱歌了!也許你能在小屋裡看到它的說唱表演哦！";
               break;
            case 2:
               url = "resource/allJob/AlertPic/rhm_21.swf";
               msg = "    你的拉姆很聰明呢！它學會了一點兒塗鴉技巧！當你去摩爾城堡的地下迷宮探險時，別忘了帶著它！我有驚喜留給你們哦！嘻嘻~";
         }
         myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function showError(event:EventTaomee) : void
      {
         var url:String = "resource/allJob/AlertPic/rhm_no.swf";
         var msg:String = "    嗨~親愛的" + LocalUserInfo.getNickName() + "，很高興又見到你！你今天已經看過一次我們的表演啦！要想再看，明天再來吧！我們也要休息的，嘿嘿！";
         var myAlert:* = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         this.showLogic(0);
         BC.removeEvent(this);
      }
      
      private function studyOne(event:Event) : void
      {
         this.showLogic(1);
         BC.addEvent(this,GV.MAN_PEOPLE.avatarClass,PeopleManageView.ON_GO_START,this.stopJobFun);
         this.timeoutNum = setTimeout(this.playOver,60000);
      }
      
      private function stopJobFun(event:*) : void
      {
         BC.removeEvent(this,GV.MAN_PEOPLE.avatarClass,PeopleManageView.ON_GO_START,this.stopJobFun);
         clearTimeout(this.timeoutNum);
         this.showLogic(0);
      }
      
      private function playOver() : void
      {
         var myAlert:* = undefined;
         var msg:String = "";
         if(!GV.JobLogics.havePetFollow())
         {
            msg = "    你的拉姆看來並不喜歡我的表演，他回家了哦！";
            myAlert = Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"otherJob_konw",true,false,"D");
            this.showLogic(0);
            return;
         }
         BC.removeEvent(this,GV.MAN_PEOPLE.avatarClass,PeopleManageView.ON_GO_START,this.stopJobFun);
         clearTimeout(this.timeoutNum);
         BC.addEvent(this,GV.onlineSocket,PetFreakRes.LEARN_OK,this.okFun);
         BC.addEvent(this,GV.onlineSocket,"petFreak_error",this.showError);
         PetFreakReq.Info(this.Flag);
      }
      
      private function okFun(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,PetFreakRes.LEARN_OK,this.okFun);
         this.showLogic(0);
         this.showOKFun(this.Flag);
         var ap:uint = 0;
         if(this.Flag == 0)
         {
            ap = 1;
         }
         else
         {
            ap = 2 * this.Flag;
         }
         GV.MyInfo_PetObj.Skill |= ap;
      }
      
      private function showLogic(type:uint = 0) : void
      {
         var i:uint = 0;
         var ip:uint = 0;
         if(type == 0)
         {
            this.PetMCArr[this.Flag].visible = false;
            this.PetBtArr[this.Flag].visible = true;
            this.PetMCArr[this.Flag].gotoAndStop(1);
            for(i = 0; i < this.PetBtArr.length; i++)
            {
               this.PetBtArr[i].addEventListener(MouseEvent.CLICK,this.chartDayJob);
            }
         }
         else
         {
            this.PetMCArr[this.Flag].visible = true;
            this.PetBtArr[this.Flag].visible = false;
            this.PetMCArr[this.Flag].gotoAndPlay(2);
            for(ip = 0; ip < this.PetBtArr.length; ip++)
            {
               this.PetBtArr[ip].removeEventListener(MouseEvent.CLICK,this.chartDayJob);
            }
         }
      }
      
      private function backOne(event:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function removeAll(event:EventTaomee = null) : void
      {
         clearTimeout(this.timeoutNum);
         BC.removeEvent(this);
         for(var i:uint = 0; i < this.PetBtArr.length; i++)
         {
            this.PetBtArr[i].removeEventListener(MouseEvent.CLICK,this.chartDayJob);
         }
         this.PetMCArr = [];
         this.PetBtArr = [];
         this.Flag = 0;
         this.NowPetObj = null;
      }
   }
}

