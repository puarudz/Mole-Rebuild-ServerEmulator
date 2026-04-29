package com.module.lahmClassRoom
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class lahmClassRoomState
   {
      
      private static var instance:lahmClassRoomState;
      
      private static var canotNew:Boolean = true;
      
      private var lahmclassroomBeen:lahmClassRoomBeen;
      
      private var UI:MovieClip;
      
      private var courseTimer:Timer;
      
      private var courseArr:Array;
      
      private var courseCount:int;
      
      private var testTimer:Timer;
      
      private var stateInfoObj:Object;
      
      private var classMovieLoader:Loader;
      
      public function lahmClassRoomState()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomState不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomState
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomState();
            canotNew = true;
         }
         return instance;
      }
      
      public function changeState(stateInfo:Object) : void
      {
         this.lahmclassroomBeen = lahmClassRoomBeen.getInstance();
         this.UI = this.lahmclassroomBeen.getLahmClassRoomMC().UI;
         this.stateInfoObj = stateInfo;
         this.lahmclassroomBeen.getLahmClassRoomInfo().coursesId = this.stateInfoObj.courseId;
         this.lahmclassroomBeen.getLahmClassRoomInfo().classRoomFlag = this.stateInfoObj.classFlag;
         this.lahmclassroomBeen.getLahmClassRoomInfo().questionClassCount = this.stateInfoObj.questionClassCount;
         lahmClassRoomUI.getInstance().initMsgPanel();
         lahmClassRoomUI.getInstance().initFunBtn();
         this.classMoviePlay();
      }
      
      private function classMoviePlay() : void
      {
         BC.addEvent(this,GV.onlineSocket,"MovieOver",this.onMovieOver);
         var path:String = XMLInfo.lahmClassRoom.classMoviePath + this.stateInfoObj.classFlag + ".swf";
         this.classMovieLoader = new Loader();
         this.classMovieLoader.load(VL.getURLRequest(path));
         this.UI.addChild(this.classMovieLoader);
      }
      
      private function onMovieOver(evt:Event) : void
      {
         var unShowLahmQuestionMovieArr:Array = null;
         BC.removeEvent(this,GV.onlineSocket,"MovieOver",this.onMovieOver);
         this.UI.removeChild(this.classMovieLoader);
         if(this.stateInfoObj.classFlag == 0)
         {
            this.setupClassFlag1A2(this.stateInfoObj.time);
            unShowLahmQuestionMovieArr = XMLInfo.lahmClassRoom.lahmQuestionClass;
            if(unShowLahmQuestionMovieArr.indexOf(this.stateInfoObj.courseId) == -1)
            {
               lahmClassRoomStudent.getInstance().setupClassLahmMovie(this.stateInfoObj.courseId,1);
            }
            lahmCourseSpecial.getInstance().courseSpecial(this.stateInfoObj.courseId);
         }
         else if(this.stateInfoObj.classFlag == 1)
         {
            this.setupClassFlag1A2(this.stateInfoObj.time);
            unShowLahmQuestionMovieArr = XMLInfo.lahmClassRoom.lahmQuestionClass;
            if(unShowLahmQuestionMovieArr.indexOf(this.stateInfoObj.courseId) == -1)
            {
               lahmClassRoomStudent.getInstance().setupClassLahmMovie(this.stateInfoObj.courseId,1);
            }
         }
         else if(this.stateInfoObj.classFlag == 2)
         {
            lahmClassRoomStudent.getInstance().setupUnClassLahmMovie();
         }
         else if(this.stateInfoObj.classFlag == 3)
         {
         }
      }
      
      public function setupClassFlag1A2(time:Number) : void
      {
         var classNameS:String = null;
         this.lahmclassroomBeen = lahmClassRoomBeen.getInstance();
         this.UI = this.lahmclassroomBeen.getLahmClassRoomMC().UI;
         if(this.lahmclassroomBeen.isMyLahmClassRoom())
         {
            this.UI.myMenu.planBtn.visible = false;
            this.UI.myMenu.phoneBtn.visible = false;
            classNameS = XMLInfo.lahmClassRoom.courses[this.lahmclassroomBeen.getLahmClassRoomInfo().coursesId];
            this.UI.nowMsgPanel.classNameTxt.text = classNameS;
            this.clearCourseTimer();
            trace("課程時間倒計時： " + time + "秒");
            this.startCourseTimer(time);
         }
      }
      
      private function startCourseTimer(delay:Number) : void
      {
         var delayNum:Number = 1000 * 60;
         var repeatCountNum:int = Math.ceil(delay / 60);
         this.setupTimerPanel(repeatCountNum);
         this.courseTimer = new Timer(delayNum,repeatCountNum);
         this.courseTimer.addEventListener(TimerEvent.TIMER,this.onCourseTimer);
         this.courseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCourseTimerComp);
         this.courseTimer.start();
      }
      
      private function onCourseTimer(evt:TimerEvent) : void
      {
         var repeatCountNum:int = evt.currentTarget.repeatCount - evt.currentTarget.currentCount;
         trace("課程倒計時次數： " + repeatCountNum);
         this.setupTimerPanel(repeatCountNum);
      }
      
      private function onCourseTimerComp(evt:TimerEvent) : void
      {
         this.clearCourseTimer();
         var courseId:int = int(this.lahmclassroomBeen.getLahmClassRoomInfo().coursesId);
         lahmClassRoomSocket.classOver(courseId);
      }
      
      private function setupTimerPanel(repeatCount1:int) : void
      {
         var xss:int = 0;
         var xsg:int = 0;
         var fzs:int = 0;
         var fzg:int = 0;
         var repeatCount:Number = repeatCount1 * 60;
         var xs:int = int(repeatCount / 3600);
         var fz:int = repeatCount1 % 60;
         try
         {
            xss = int(xs / 10) + 1;
            xsg = int(xs % 10) + 1;
            this.UI.nowMsgPanel.hs.gotoAndStop(xss);
            this.UI.nowMsgPanel.hg.gotoAndStop(xsg);
            fzs = int(fz / 10) + 1;
            fzg = int(fz % 10) + 1;
            this.UI.nowMsgPanel.ms.gotoAndStop(fzs);
            this.UI.nowMsgPanel.mg.gotoAndStop(fzg);
         }
         catch(e:Error)
         {
         }
      }
      
      public function clearCourseTimer() : void
      {
         if(this.courseTimer != null)
         {
            this.courseTimer.reset();
            this.courseTimer.removeEventListener(TimerEvent.TIMER,this.onCourseTimer);
            this.courseTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCourseTimerComp);
            this.courseTimer = null;
         }
      }
      
      public function courseTest(tcourseArr:Array, tcourseCount:int) : void
      {
         this.courseArr = tcourseArr;
         this.courseCount = tcourseCount;
         this.UI = lahmClassRoomBeen.getInstance().getLahmClassRoomMC().UI;
         this.UI.msgPanel.crState.mouseEnabled = false;
         this.UI.msgPanel.crState.mouseChildren = false;
         BC.removeEvent(this,this.UI.msgPanel.crState,MouseEvent.CLICK,lahmClassRoomUI.getInstance().onCrState);
         lahmClassRoomStudent.getInstance().setupTestLahmMovie();
         this.startTestTimer();
      }
      
      private function startTestTimer() : void
      {
         this.UI.mouseEnabled = false;
         this.UI.mouseChildren = false;
         var testTimerDelay:int = 5 * 1000;
         this.testTimer = new Timer(testTimerDelay,1);
         this.testTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTestTimerComp);
         this.testTimer.start();
      }
      
      private function onTestTimerComp(evt:TimerEvent) : void
      {
         this.clearTestTimer();
         BC.addEvent(this,GV.onlineSocket,"read_1292",this.onCourseTest);
         lahmClassRoomSocket.courseTest(this.courseArr,this.courseCount);
         this.UI.mouseEnabled = true;
         this.UI.mouseChildren = true;
         this.courseArr = null;
         this.courseCount = 0;
      }
      
      public function clearTestTimer() : void
      {
         if(this.testTimer != null)
         {
            this.testTimer.reset();
            this.testTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTestTimerComp);
            this.testTimer = null;
         }
      }
      
      private function onCourseTest(evt:EventTaomee) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/TestResultMain.swf","正在加載查詢成績面板",MainManager.getGameLevel());
         loadGame = null;
      }
   }
}

