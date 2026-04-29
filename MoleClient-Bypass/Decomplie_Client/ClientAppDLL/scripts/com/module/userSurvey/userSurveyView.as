package com.module.userSurvey
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.userSurvey.userBirthReq;
   import com.logic.socket.userSurvey.userBirthRes;
   import com.logic.socket.userSurvey.userSurveyReq;
   import com.logic.socket.userSurvey.userSurveyRes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class userSurveyView
   {
      
      public var depth_mc:MovieClip;
      
      public var sex:int = -1;
      
      public var mc:MovieClip;
      
      public function userSurveyView(mc:MovieClip)
      {
         super();
         this.depth_mc = mc;
         this.init();
      }
      
      public function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         this.depth_mc.userSurvey_mc.addEventListener(MouseEvent.CLICK,this.showUserSurveyPanel);
      }
      
      private function removeEventHandler(evt:Event) : void
      {
         this.depth_mc.userSurvey_mc.removeEventListener(MouseEvent.CLICK,this.showUserSurveyPanel);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         try
         {
            this.mc.close_btn.removeEventListener(MouseEvent.CLICK,this.closeUserSurveyPanel);
            this.mc.submit_btn.removeEventListener(MouseEvent.CLICK,this.submitResult);
            this.mc.select_btn1.removeEventListener(MouseEvent.CLICK,this.changeUserSex1);
            this.mc.select_btn2.removeEventListener(MouseEvent.CLICK,this.changeUserSex2);
         }
         catch(e:Error)
         {
         }
         this.depth_mc.userSurvey_mc = null;
         this.depth_mc = null;
      }
      
      private function showUserSurveyPanel(event:MouseEvent) : void
      {
         if(!Boolean(MainManager.getAppLevel().getChildByName("userSurveyPanel")))
         {
            userSurveyReq.sendReq();
            GV.onlineSocket.addEventListener(userSurveyRes.GET_USERSURVEY_SUCC,this.isDone);
         }
      }
      
      private function isDone(e:EventTaomee) : void
      {
         var info:String = null;
         var classuserSurvey:Class = null;
         GV.onlineSocket.removeEventListener(userSurveyRes.GET_USERSURVEY_SUCC,this.isDone);
         if(e.EventObj.Done == 1)
         {
            trace("做過le");
            info = "    你已經提交過用戶資訊，公民管理處已經認真記錄了。以後這裡還會有其它的調查，記得常來看看。";
            Alert.showAlert(MainManager.getAppLevel(),"resource/allJob/AlertPic/roc.swf",info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else
         {
            trace("mei做過");
            classuserSurvey = GV.Lib_Map.getClass("userSurveyPanel");
            this.mc = new classuserSurvey();
            this.mc.close_btn.addEventListener(MouseEvent.CLICK,this.closeUserSurveyPanel);
            this.mc.select_btn1.addEventListener(MouseEvent.CLICK,this.changeUserSex1);
            this.mc.select_btn2.addEventListener(MouseEvent.CLICK,this.changeUserSex2);
            this.mc.submit_btn.addEventListener(MouseEvent.CLICK,this.submitResult);
            this.mc.name = "userSurveyPanel";
            this.mc.x = 321;
            this.mc.y = 100;
            MainManager.getAppLevel().addChild(this.mc);
         }
      }
      
      private function closeUserSurveyPanel(event:MouseEvent = null) : void
      {
         this.mc.close_btn.removeEventListener(MouseEvent.CLICK,this.closeUserSurveyPanel);
         MainManager.getAppLevel().removeChild(this.mc);
      }
      
      private function changeUserSex1(event:MouseEvent) : void
      {
         this.sex = 1;
         this.mc.select_mc1.gotoAndStop(2);
         this.mc.select_mc2.gotoAndStop(1);
      }
      
      private function changeUserSex2(event:MouseEvent) : void
      {
         this.sex = 0;
         this.mc.select_mc1.gotoAndStop(1);
         this.mc.select_mc2.gotoAndStop(2);
      }
      
      private function submitResult(event:MouseEvent) : void
      {
         var year:* = undefined;
         var month:* = undefined;
         var day:* = undefined;
         if(this.sex != -1 && Number(this.mc.year_txt.text) >= 1900 && Number(this.mc.year_txt.text) < 2011 && Number(this.mc.month_txt.text) > 0 && Number(this.mc.month_txt.text) < 13 && Number(this.mc.day_txt.text) > 0 && Number(this.mc.day_txt.text) < 32)
         {
            this.mc.submit_btn.removeEventListener(MouseEvent.CLICK,this.submitResult);
            this.mc.select_btn1.removeEventListener(MouseEvent.CLICK,this.changeUserSex1);
            this.mc.select_btn2.removeEventListener(MouseEvent.CLICK,this.changeUserSex2);
            trace("滿足提交要求");
            year = this.mc.year_txt.text;
            month = this.mc.month_txt.text;
            day = this.mc.day_txt.text;
            if(int(month) < 10)
            {
               month = "0" + int(month);
            }
            if(int(day) < 10)
            {
               day = "0" + int(day);
            }
            userBirthReq.sendReq(uint(year + month + day),this.sex);
            GV.onlineSocket.addEventListener(userBirthRes.GET_USERSURVEYDONE_SUCC,this.getresult);
         }
         else
         {
            GF.showAlert(MainManager.getAppLevel(),"你填寫的內容有誤，要仔細填寫哦！","",6,"D");
            trace("沒滿足提交要求");
         }
      }
      
      private function getresult(e:EventTaomee) : void
      {
         this.closeUserSurveyPanel();
         GV.onlineSocket.removeEventListener(userBirthRes.GET_USERSURVEYDONE_SUCC,this.getresult);
         var yxb:int = int(e.EventObj.arr[0].ItemCount);
         LocalUserInfo.countYXQ(yxb);
         var info:String = "    我們已經收到你的資訊，感謝你配合公民管理處的工作，特獎勵你" + yxb + "摩爾豆。";
         Alert.showAlert(MainManager.getAppLevel(),"resource/allJob/AlertPic/roc.swf",info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
      }
   }
}

