package com.module.lahmClassRoom
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.throwThing.throwHitTest;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class lahmClassRoomStudent
   {
      
      private static var instance:lahmClassRoomStudent;
      
      private static var canotNew:Boolean = true;
      
      private var lahmclassroombeen:lahmClassRoomBeen;
      
      private var buttonMc:MovieClip;
      
      private var depthMc:MovieClip;
      
      private var TABLE_MAX:int = 10;
      
      private var lahmMovieLoader:Loader;
      
      private var studentArr:Array;
      
      private var diguiSign:int;
      
      private var loaderStudentNum:int;
      
      private var courseId:int;
      
      private var lahmCMPArr:Array;
      
      private var selectMovieID:int;
      
      private var selectStudentNum:int;
      
      private var selectItemId:int;
      
      private var selectpetId:int;
      
      private var lahmQuestionSign:int;
      
      private var questionClass:int = 14;
      
      public function lahmClassRoomStudent()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomStudent不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomStudent
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomStudent();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         var courseId:int = 0;
         this.lahmclassroombeen = lahmClassRoomBeen.getInstance();
         this.buttonMc = this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel;
         this.depthMc = this.lahmclassroombeen.getLahmClassRoomMC().depth_mc;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1)
         {
            courseId = int(this.lahmclassroombeen.getLahmClassRoomInfo().coursesId);
            this.setupClassLahmMovie(courseId);
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 2)
         {
            this.setupUnClassLahmMovie();
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 3)
         {
            this.clearLahmMovie();
            this.clearLahmName();
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 4)
         {
            this.setupUnClassLahmMovie();
         }
         else if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 5)
         {
         }
      }
      
      public function setupClassLahmMovie(courseId:int, sign:int = 0) : void
      {
         this.lahmQuestionSign = sign;
         courseId = courseId;
         this.clearLahmMovie();
         if(courseId == 0)
         {
            throw new Error("課程ID為0了！！！");
         }
         this.studentArr = this.lahmclassroombeen.getLahmClassRoomInfo().studentArr;
         this.lahmCMPArr = XMLInfo.lahmClassRoomClassing[courseId];
         this.diguiSign = 0;
         if(this.lahmCMPArr[0] == "-1")
         {
            lahmClassRoomStudentChat.getInstance().clearChatTimer();
            this.loaderActionClass(this.lahmCMPArr[1]);
         }
         else
         {
            this.loaderLahm(this.studentArr.length);
         }
      }
      
      private function loaderActionClass(path:String) : void
      {
         var UI:MovieClip = this.lahmclassroombeen.getLahmClassRoomMC().UI;
         this.lahmMovieLoader = new Loader();
         this.lahmMovieLoader.load(VL.getURLRequest(path));
         GC.clearAllChildren(UI.showImage);
         UI.actionClassPanel.showImage.addChild(this.lahmMovieLoader);
         lahmClassRoomUI.getInstance().openActionClass();
      }
      
      private function loaderLahm(studentCount:int) : void
      {
         if(this.diguiSign < studentCount)
         {
            this.lahmMovieLoaderFun(this.diguiSign);
         }
         else
         {
            this.diguiSign = 0;
            lahmClassRoomStudentChat.getInstance().init();
            if(this.lahmQuestionSign == 1 && this.lahmclassroombeen.getLahmClassRoomInfo().questionClassCount > 0 && (this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 0 || this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 1))
            {
               this.lahmQuestionSign = 0;
               if(this.chackQuestionClass() == this.questionClass)
               {
                  this.loaderLahmMovie5();
               }
               else
               {
                  this.changelahmMovieQuestion();
               }
            }
         }
      }
      
      private function changelahmMovieQuestion() : void
      {
         var randomNum:int = Math.random() * 100;
         var percent:int = int(XMLInfo.lahmClassRoom.lahmQuestionRandom);
         if(randomNum < percent)
         {
            this.loaderLahmMovie5();
         }
      }
      
      private function loaderLahmMovie5() : void
      {
         this.diguiSign = this.studentArr.length;
         var randomN:int = Math.random() * this.studentArr.length;
         this.loaderStudentNum = randomN;
         var studentInfo:Object = this.studentArr[randomN];
         var path:String = "resource/lahmClassRoom/lahmMovie/pet" + studentInfo.studentLevel + "Movie/5.swf";
         this.buttonMc["movie" + randomN].movieID = 5;
         this.lahmMovieLoader = new Loader();
         this.lahmMovieLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComp);
         this.lahmMovieLoader.load(VL.getURLRequest(path));
      }
      
      private function lahmMovieLoaderFun(studentNum:int) : void
      {
         this.loaderStudentNum = studentNum;
         var randomNum:int = Math.random() * this.lahmCMPArr.length;
         var path:String = this.changePath(this.studentArr[studentNum],this.lahmCMPArr[randomNum]);
         var indexS:int = path.lastIndexOf("/") + 1;
         var indexE:int = path.lastIndexOf(".");
         var movieID:int = int(path.slice(indexS,indexE));
         this.buttonMc["movie" + studentNum].movieID = movieID;
         this.lahmMovieLoader = new Loader();
         this.lahmMovieLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComp);
         this.lahmMovieLoader.load(VL.getURLRequest(path));
         trace("**************學生序號:" + studentNum + "******************");
         trace("**************加載路徑:" + path + "******************");
      }
      
      private function onLoaderComp(evt:Event) : void
      {
         var lahmMc:MovieClip = evt.currentTarget.content.mc;
         this.studentArr = this.lahmclassroombeen.getLahmClassRoomInfo().studentArr;
         GC.clearAllChildren(this.buttonMc["movie" + this.loaderStudentNum]);
         this.buttonMc["movie" + this.loaderStudentNum].addChild(evt.currentTarget.content.mc);
         GF.setPetColor(evt.currentTarget.content.mc.lahm,this.studentArr[this.loaderStudentNum].studentColor);
         var stName:String = XMLInfo.lahmClassRoom.studentName[this.studentArr[this.loaderStudentNum].studentName];
         this.depthMc["table" + this.loaderStudentNum].nameTxt.text = stName;
         if(LocalUserInfo.getUserID() == this.lahmclassroombeen.getLahmClassRoomInfo().classRoomUserId)
         {
            evt.currentTarget.content.mc.buttonMode = true;
            BC.addEvent(this,evt.currentTarget.content.mc,MouseEvent.CLICK,this.onLahmHandler);
            BC.addEvent(this,throwHitTest.throwObj,"hitTest",this.OnHitTestByItem);
         }
         this.diguiSign += 1;
         this.loaderLahm(this.studentArr.length);
      }
      
      private function OnHitTestByItem(e:EventTaomee) : void
      {
         var mc:MovieClip = null;
         for(var i:int = 0; i < this.studentArr.length; i++)
         {
            mc = this.buttonMc["movie" + i];
            if(!(Boolean(mc) && mc.hitTestPoint(e.EventObj.po.x,e.EventObj.po.y,true)))
            {
               continue;
            }
            switch(e.EventObj.id)
            {
               case 150011:
                  this.diguiSign = this.studentArr.length;
                  this.lahmMovieLoaderFun(i);
                  return;
               default:
                  return;
            }
         }
      }
      
      private function onLahmHandler(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = null;
         var UI:MovieClip = null;
         var ltg:Point = null;
         var lahmMovieEventArr:Array = null;
         var i:int = 0;
         var movieID:int = int(MovieClip(evt.currentTarget.parent).movieID);
         var studentNum:int = int(String(MovieClip(evt.currentTarget).parent.name).slice(5));
         var movieMc:MovieClip = MovieClip(evt.currentTarget.parent);
         var lahmMc:MovieClip = MovieClip(evt.currentTarget);
         if(movieID == 5)
         {
            BC.addEvent(this,GV.onlineSocket,"QuestionOver",this.onQuestionOver);
            loadGame = new LoadGame("module/external/lahmQuestionMain.swf","正在加載拉姆問題",MainManager.getGameLevel());
            loadGame = null;
         }
         else
         {
            UI = this.lahmclassroombeen.getLahmClassRoomMC().UI;
            ltg = lahmMc.localToGlobal(new Point(0,0));
            UI.lahmMovieEvent.movieID = movieID;
            UI.lahmMovieEvent.studentNum = studentNum;
            if(UI.lahmMovieEvent.x == ltg.x && UI.lahmMovieEvent.y == ltg.y)
            {
               this.hideLahmMovieEvent();
            }
            else
            {
               UI.lahmMovieEvent.x = ltg.x;
               UI.lahmMovieEvent.y = ltg.y;
               lahmMovieEventArr = XMLInfo.lahmClassRoom.lahmMovieEventArr;
               for(i = 1; i <= UI.lahmMovieEvent.numChildren; i++)
               {
                  UI.lahmMovieEvent["btn" + i].filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
                  if(lahmMovieEventArr[i].indexOf(movieID) != -1)
                  {
                     UI.lahmMovieEvent["btn" + i].filters = [];
                  }
                  BC.addEvent(this,UI.lahmMovieEvent["btn" + i],MouseEvent.CLICK,this.onLahmMovieEvent);
                  BC.addEvent(this,UI.lahmMovieEvent["btn" + i],MouseEvent.MOUSE_OVER,this.onLahmMovieEventFun);
                  BC.addEvent(this,UI.lahmMovieEvent["btn" + i],MouseEvent.MOUSE_OUT,this.onLahmMovieEventFun);
               }
            }
         }
      }
      
      private function chackQuestionClass() : int
      {
         var ret:int = 0;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().coursesId == this.questionClass)
         {
            ret = this.questionClass;
         }
         return ret;
      }
      
      private function onQuestionOver(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"QuestionOver",this.onQuestionOver);
         this.diguiSign = this.studentArr.length;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().questionClassCount > 0)
         {
            this.lahmQuestionSign = 1;
            this.lahmclassroombeen.getLahmClassRoomInfo().questionClassCount = this.lahmclassroombeen.getLahmClassRoomInfo().questionClassCount - 1;
         }
         this.lahmMovieLoaderFun(evt.EventObj.studentNum);
      }
      
      private function hideLahmMovieEvent() : void
      {
         var UI:MovieClip = this.lahmclassroombeen.getLahmClassRoomMC().UI;
         UI.lahmMovieEvent.x = -100;
         UI.lahmMovieEvent.y = 630;
      }
      
      private function onLahmMovieEvent(evt:MouseEvent) : void
      {
         var btnnum:int = int(String(evt.currentTarget.name).slice(3));
         this.selectMovieID = int(MovieClip(evt.currentTarget.parent).movieID);
         this.selectStudentNum = int(MovieClip(evt.currentTarget.parent).studentNum);
         var lahmMovieEventArr:Array = XMLInfo.lahmClassRoom.lahmMovieEventArr;
         if(lahmMovieEventArr[btnnum].indexOf(this.selectMovieID) != -1)
         {
            trace("符合規則的拉姆動畫");
            this.selectItemId = lahmClassRoomUI.getInstance().toolSpecialGoodsArr[btnnum - 1];
            this.selectpetId = this.studentArr[this.selectStudentNum].studentId;
            BC.addEvent(this,GV.onlineSocket,"read_1271",this.onRead1271);
            lahmClassRoomSocket.queryClassRoomGoods();
         }
      }
      
      private function onLahmMovieEventFun(evt:MouseEvent) : void
      {
         var tipsS:String = null;
         var btnnum:int = int(String(evt.currentTarget.name).slice(3));
         this.selectItemId = lahmClassRoomUI.getInstance().toolSpecialGoodsArr[btnnum - 1];
         if(evt.type == MouseEvent.MOUSE_OVER)
         {
            tipsS = GoodsInfo.getItemNameByID(this.selectItemId);
            tip.tipTailDisPlayObject(evt.currentTarget,tipsS);
         }
         else if(evt.type == MouseEvent.MOUSE_OUT)
         {
            tip.hideTip();
         }
      }
      
      private function onRead1271(evt:EventTaomee) : void
      {
         var str:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_1271",this.onRead1271);
         var arr:Array = evt.EventObj.itenArr;
         if(new lahmClassRoomTool().haveItemByArr(arr,this.selectItemId))
         {
            trace("檢查條件");
            if(this.checkItemCondition(this.selectItemId))
            {
               BC.addEvent(this,GV.onlineSocket,"read_1270",this.onRead1270);
               lahmClassRoomSocket.usingItem(this.selectItemId,this.selectpetId);
            }
         }
         else
         {
            str = XMLInfo.LahmMovieEvent[this.selectItemId];
            Alert.smileAlart(str);
         }
      }
      
      private function checkItemCondition(itemId:int) : Boolean
      {
         var ret:Boolean = false;
         var unClassToolGoodsArr:Array = lahmClassRoomUI.getInstance().unClassToolGoodsArr;
         var otherToolGoodsArr:Array = lahmClassRoomUI.getInstance().toolSpecialGoodsArr;
         if(this.lahmclassroombeen.getLahmClassRoomInfo().studentCount != 0)
         {
            if(unClassToolGoodsArr.indexOf(itemId) != -1)
            {
               if(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag == 2)
               {
                  ret = true;
               }
               else
               {
                  Alert.smileAlart("    此道具只有下課時可以使用！");
               }
            }
            else if(otherToolGoodsArr.indexOf(itemId) != -1)
            {
               ret = true;
            }
         }
         return ret;
      }
      
      private function onRead1270(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1270",this.onRead1270);
         var UI:MovieClip = this.lahmclassroombeen.getLahmClassRoomMC().UI;
         UI.showLME.x = UI.lahmMovieEvent.x;
         UI.showLME.y = UI.lahmMovieEvent.y;
         var farme:int = lahmClassRoomUI.getInstance().toolSpecialGoodsArr.indexOf(evt.EventObj.itemId);
         BC.addEvent(this,GV.onlineSocket,"EventMovieOver",this.onEventMovieOver);
         UI.showLME.gotoAndStop(farme + 2);
         this.hideLahmMovieEvent();
      }
      
      private function onEventMovieOver(evt:Event) : void
      {
         var UI:MovieClip = this.lahmclassroombeen.getLahmClassRoomMC().UI;
         UI.showLME.x = -100;
         UI.showLME.y = 630;
         this.diguiSign = this.studentArr.length;
         this.lahmMovieLoaderFun(this.selectStudentNum);
      }
      
      private function changePath(studentInfo:Object, path:String) : String
      {
         var ret:String = path;
         var pathArr:Array = ret.split("*");
         return pathArr[0] + studentInfo.studentLevel + pathArr[1];
      }
      
      public function setupUnClassLahmMovie() : void
      {
         this.clearLahmMovie();
         this.studentArr = this.lahmclassroombeen.getLahmClassRoomInfo().studentArr;
         if(this.studentArr.length > 0)
         {
            this.lahmCMPArr = XMLInfo.lahmClassRoomUnClass.movie;
            this.diguiSign = 0;
            this.loaderLahm(this.studentArr.length);
         }
      }
      
      public function setupTestLahmMovie() : void
      {
         this.lahmclassroombeen = lahmClassRoomBeen.getInstance();
         this.buttonMc = this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel;
         this.depthMc = this.lahmclassroombeen.getLahmClassRoomMC().depth_mc;
         this.clearLahmMovie();
         this.studentArr = this.lahmclassroombeen.getLahmClassRoomInfo().studentArr;
         if(this.studentArr.length > 0)
         {
            this.lahmCMPArr = XMLInfo.lahmClassRoomUnClass.Graduation;
            this.diguiSign = 0;
            this.loaderLahm(this.studentArr.length);
         }
      }
      
      public function clearLahmMovie() : void
      {
         for(var i:int = 0; i < this.TABLE_MAX; i++)
         {
            this.buttonMc["movie" + i].movieID = -1;
            GC.clearAllChildren(this.buttonMc["movie" + i]);
         }
      }
      
      public function clearLahmName() : void
      {
         for(var i:int = 0; i < this.TABLE_MAX; i++)
         {
            this.buttonMc["movie" + i].movieID = -1;
            this.depthMc["table" + i].nameTxt.text = "";
         }
      }
   }
}

