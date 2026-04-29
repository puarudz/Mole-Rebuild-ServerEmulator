package com.module.lahmClassRoom
{
   import com.common.dialogBox.DialogBox;
   import com.global.staticData.XMLInfo;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class lahmClassRoomStudentChat
   {
      
      private static var instance:lahmClassRoomStudentChat;
      
      private static var canotNew:Boolean = true;
      
      private var lahmclassroombeen:lahmClassRoomBeen;
      
      private var studentArr:Array;
      
      private var buttonMc:MovieClip;
      
      private var delayNum:int = 30;
      
      private var chatTimer:Timer;
      
      private var courseId:int;
      
      private var chatS:String;
      
      private var stuRandom:int;
      
      public function lahmClassRoomStudentChat()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomStudentChat不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomStudentChat
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomStudentChat();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         this.clearChatTimer();
         this.lahmclassroombeen = lahmClassRoomBeen.getInstance();
         this.studentArr = this.lahmclassroombeen.getLahmClassRoomInfo().studentArr;
         this.buttonMc = this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel;
         this.courseId = this.lahmclassroombeen.getLahmClassRoomInfo().coursesId;
         this.selectChat();
         this.startChatTimer();
      }
      
      private function selectChat() : void
      {
         var charArr:Array = null;
         var charRandomNum:int = 0;
         this.stuRandom = Math.random() * this.studentArr.length;
         var movieID:int = int(this.buttonMc["movie" + this.stuRandom].movieID);
         this.courseId = this.lahmclassroombeen.getLahmClassRoomInfo().coursesId;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1)
         {
            charArr = XMLInfo.lahmClassRoomClassingChat[this.courseId + "_" + movieID];
            charRandomNum = Math.random() * charArr.length;
            this.chatS = charArr[charRandomNum];
         }
         else
         {
            charArr = XMLInfo.lahmClassRoomUnClassChat.chat;
            charRandomNum = Math.random() * charArr.length;
            this.chatS = charArr[charRandomNum];
         }
      }
      
      private function startChatTimer() : void
      {
         this.chatTimer = new Timer(this.delayNum * 1000,1);
         this.chatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComp);
         this.chatTimer.start();
      }
      
      private function onTimerComp(evt:TimerEvent) : void
      {
         var mc:MovieClip = null;
         var box:DialogBox = null;
         var xp:int = 0;
         var yp:int = 0;
         this.clearChatTimer();
         try
         {
            mc = this.buttonMc["movie" + this.stuRandom].getChildByName("mc");
            box = DialogBox.showDialogBox(this.chatS);
            xp = mc.x;
            yp = mc.y;
            box.setPosXY(xp,yp);
            this.buttonMc["movie" + this.stuRandom].addChild(box);
            this.selectChat();
            this.startChatTimer();
         }
         catch(e:Error)
         {
         }
      }
      
      public function clearChatTimer() : void
      {
         if(this.chatTimer != null)
         {
            this.delayNum = 15;
            this.chatTimer.reset();
            this.chatTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComp);
            this.chatTimer = null;
         }
      }
   }
}

