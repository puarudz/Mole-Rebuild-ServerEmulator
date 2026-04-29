package com.module.lahmClassRoom
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.links.Links;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class lahmClassRoomView
   {
      
      private static var instance:lahmClassRoomView;
      
      private static var canotNew:Boolean = true;
      
      private var lahmclassroombeen:lahmClassRoomBeen;
      
      private var backGrounLoader:MCLoader;
      
      public var isChangeStyle:Boolean;
      
      private var lahmclassroomTool:lahmClassRoomTool;
      
      public function lahmClassRoomView()
      {
         super();
         if(canotNew)
         {
            throw new Error("lahmClassRoomView不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : lahmClassRoomView
      {
         if(!instance)
         {
            canotNew = false;
            instance = new lahmClassRoomView();
            canotNew = true;
         }
         return instance;
      }
      
      public function setValue(tempObj:Loader, lahmClassRoomInfoObj:Object) : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.lahmclassroomTool = new lahmClassRoomTool();
         this.lahmclassroombeen = lahmClassRoomBeen.getInstance();
         this.lahmclassroombeen.setInLahmClassRoom(true);
         this.lahmclassroombeen.setLahmClassRoomMC(tempObj.content as MovieClip);
         this.setupLahmClassRoomData(lahmClassRoomInfoObj);
      }
      
      private function setupLahmClassRoomData(lahmClassRoomInfoObj:Object) : void
      {
         this.lahmclassroombeen.setLahmClassRoomInfo(lahmClassRoomInfoObj);
         var lahmClassRoomUserId:int = int(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomUserId);
         var isMyLahmClassRoom:Boolean = false;
         if(lahmClassRoomUserId == LocalUserInfo.getUserID())
         {
            isMyLahmClassRoom = true;
         }
         this.lahmclassroombeen.setMyLahmClassRoom(isMyLahmClassRoom);
         var exp:int = int(this.lahmclassroombeen.getLahmClassRoomInfo().exp);
         this.lahmclassroombeen.getLahmClassRoomInfo().level = this.lahmclassroomTool.teachLevelExpChangeTeachLevel(exp);
         this.loadBackGround();
      }
      
      private function loadBackGround() : void
      {
         var backGroundPath:String = "resource/oneBigStree/swf/" + this.lahmclassroombeen.getLahmClassRoomInfo().classRoomInnerStyle + ".swf";
         this.backGrounLoader = new MCLoader(Links.getUrl(backGroundPath),MainManager.getAppLevel(),1,"正在加載拉姆教室背景...");
         BC.addEvent(this,this.backGrounLoader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         BC.addEvent(this,this.backGrounLoader,MCLoadEvent.ERROR,this.loadBGErr);
         LoaderList.getInstance().addItem(this.backGrounLoader,null,LoaderList.HIGH);
      }
      
      private function loadBGSucc(evt:MCLoadEvent) : void
      {
         BC.removeEvent(this,this.backGrounLoader,MCLoadEvent.ON_SUCCESS,this.loadBGSucc);
         this.lahmclassroombeen.setLahmClassRoomBG(evt.getContent() as MovieClip);
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().bg_mc,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().bg_mc));
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().control_mc,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().control_mc));
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().depth_mc,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().depth_mc));
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().buttonLevel,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel));
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().type_mc,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().type_mc));
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomBG().top_mc,this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().top_mc));
         var bgIndex:int = this.lahmclassroombeen.getLahmClassRoomMC().getChildIndex(this.lahmclassroombeen.getLahmClassRoomMC().bg_mc);
         this.lahmclassroombeen.getLahmClassRoomMC().bg_mc = this.lahmclassroombeen.getLahmClassRoomBG().bg_mc;
         this.lahmclassroombeen.getLahmClassRoomMC().control_mc = this.lahmclassroombeen.getLahmClassRoomBG().control_mc;
         this.lahmclassroombeen.getLahmClassRoomMC().depth_mc = this.lahmclassroombeen.getLahmClassRoomBG().depth_mc;
         this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel = this.lahmclassroombeen.getLahmClassRoomBG().buttonLevel;
         this.lahmclassroombeen.getLahmClassRoomMC().type_mc = this.lahmclassroombeen.getLahmClassRoomBG().type_mc;
         this.lahmclassroombeen.getLahmClassRoomMC().top_mc = this.lahmclassroombeen.getLahmClassRoomBG().top_mc;
         this.lahmclassroombeen.getLahmClassRoomMC().type_mc.mouseEnabled = false;
         this.lahmclassroombeen.getLahmClassRoomMC().type_mc.mouseChildren = false;
         this.lahmclassroombeen.getLahmClassRoomMC().top_mc.mouseEnabled = false;
         this.lahmclassroombeen.getLahmClassRoomMC().top_mc.mouseChildren = false;
         this.lahmclassroombeen.getLahmClassRoomMC().depth_mc.mouseEnabled = false;
         this.lahmclassroombeen.getLahmClassRoomMC().depth_mc.mouseChildren = false;
         GV.onlineSocket.dispatchEvent(new EventTaomee("allLamuClassRoomGoodsLoaded"));
         this.lahmclassroombeen.getLahmClassRoomMC().bg_mc = new MovieClip();
         this.lahmclassroombeen.getLahmClassRoomMC().addChildAt(this.lahmclassroombeen.getLahmClassRoomMC().bg_mc,bgIndex);
         BC.addEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.peopOver);
      }
      
      private function peopOver(evt:Event) : void
      {
         var tempitem:Object = null;
         var p:Point = null;
         var item:PeopleManageView = null;
         BC.removeEvent(this,PeopleCountLogic.owner,PeopleCountLogic.onAddChildPeopleOver,this.peopOver);
         if(this.isChangeStyle)
         {
            for each(tempitem in PeopleCountLogic.peopleList)
            {
               p = MoveTo.getRandomFloorPoint();
               item = tempitem.Instance as PeopleManageView;
               item.x = p.x;
               item.y = p.y;
            }
            this.isChangeStyle = false;
         }
         this.initLahmClassRoom();
         lahmClassRoomStudent.getInstance().init();
         this.initHouseName(this.lahmclassroombeen.getLahmClassRoomInfo().classRoomName);
         lahmClassRoomUI.getInstance().init();
         this.closeClassRoomTimer();
         this.CheckHasStudent();
         GetClassrootGift.GetInstance().GetGift();
      }
      
      private function initLahmClassRoom() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.actionHandler);
         BC.addEvent(this,GV.onlineSocket,"queryClassState",this.onQueryClassState);
         BC.addEvent(this,GV.onlineSocket,"selectCoutseOver",this.onSelectCoutseOver);
         BC.addEvent(this,GV.onlineSocket,"read_1291",this.onClassEvent);
         BC.addEvent(this,GV.onlineSocket,"read_1290",this.onClassBaseInfo);
         BC.addEvent(this,GV.onlineSocket,"read_1286",this.onStartClass);
         BC.addEvent(this,GV.onlineSocket,"read_1288",this.onClassOver);
         BC.addEvent(this,GV.onlineSocket,"read_1273",this.onQueryGraduation);
         BC.addEvent(this,GV.onlineSocket,"read_1265",this.onHonorHandler);
      }
      
      private function actionHandler(evt:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         var type:int = int(evt.EventObj.type);
         if(type == 0)
         {
            loadGame = new LoadGame("module/external/lamuClassroom/LeaveClassroom.swf","正在加載離開面板",MainManager.getAppLevel());
            loadGame = null;
         }
      }
      
      private function onQueryClassState(evt:Event) : void
      {
         lahmClassRoomEvent.getInstance().queryClassState();
      }
      
      private function onSelectCoutseOver(evt:EventTaomee) : void
      {
         lahmClassRoomState.getInstance().courseTest(evt.EventObj.courseArr,evt.EventObj.courseCount);
      }
      
      private function onStartClass(evt:EventTaomee) : void
      {
         lahmClassRoomState.getInstance().changeState(evt.EventObj);
      }
      
      private function onClassOver(evt:EventTaomee) : void
      {
         lahmClassRoomState.getInstance().changeState(evt.EventObj);
      }
      
      private function onQueryGraduation(evt:EventTaomee) : void
      {
         this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag = evt.EventObj.classFlag;
         lahmClassRoomUI.getInstance().init();
      }
      
      private function onHonorHandler(evt:EventTaomee) : void
      {
         lahmClassRoomUI.getInstance().honorFun(evt.EventObj);
      }
      
      private function onClassBaseInfo(evt:EventTaomee) : void
      {
         var obj:Object = evt.EventObj;
         obj.level = this.lahmclassroomTool.teachLevelExpChangeTeachLevel(obj.exp);
         lahmClassRoomUI.getInstance().setMsgPanelData(obj);
      }
      
      private function onClassEvent(evt:EventTaomee) : void
      {
         var obj:Object = evt.EventObj;
         lahmClassRoomEvent.getInstance().checkEvent(obj);
      }
      
      public function initHouseName(name:String) : void
      {
         var control_mc:MovieClip = this.lahmclassroombeen.getLahmClassRoomMC().control_mc;
         control_mc.myNameMc.nameTxt.text = name;
      }
      
      private function loadBGErr(evt:MCLoadEvent) : void
      {
         throw new Error("加載拉姆教室背景出錯");
      }
      
      private function closeClassRoomTimer() : void
      {
         var num:int = 0;
         var t:Number = NaN;
         var d:Date = ServerUpTime.getInstance().date;
         var hours:int = d.getHours();
         if(hours < 6)
         {
            num = new Date(d.fullYear,d.month,d.date,6).valueOf() - d.valueOf();
         }
         else
         {
            t = new Date(d.fullYear,d.month,d.date).valueOf() + 24 * 3600 * 1000;
            num = t - d.valueOf();
         }
         setTimeout(this.changeState,num + 1000);
      }
      
      private function changeState() : void
      {
         this.lahmclassroombeen.getLahmClassRoomInfo().classRoomFlag = 3;
         lahmClassRoomStudentChat.getInstance().clearChatTimer();
         lahmClassRoomState.getInstance().clearTestTimer();
         lahmClassRoomState.getInstance().clearCourseTimer();
         lahmClassRoomStudent.getInstance().init();
         lahmClassRoomUI.getInstance().init();
      }
      
      private function removeEventHandler(evt:*) : void
      {
         this.lahmclassroombeen.setInLahmClassRoom(false);
         this.lahmclassroombeen.setMyLahmClassRoom(false);
         lahmClassRoomStudentChat.getInstance().clearChatTimer();
         lahmClassRoomState.getInstance().clearTestTimer();
         lahmClassRoomState.getInstance().clearCourseTimer();
         BC.removeEvent(this);
      }
      
      private function CheckHasStudent() : void
      {
         var url:String = null;
         var myAlert:* = undefined;
         if(lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().classRoomUserId == LocalUserInfo.getUserID() && lahmClassRoomBeen.getInstance().getLahmClassRoomInfo().studentArr.length == 0)
         {
            url = "resource/allJob/AlertPic/putiTeacher.swf";
            var _temp_3:* = myAlert;
            var _temp_2:* = Alert.CLICK_ + "1";
            with({})
            {
               
               _temp_3.addEventListener(_temp_2,function handler():void
               {
                  GF.switchMap(53,true);
               },false,0,true);
            }
         }
         
         public function onChangeHouseInnerStyle() : void
         {
            lahmClassRoomStudentChat.getInstance().clearChatTimer();
            lahmClassRoomState.getInstance().clearTestTimer();
            lahmClassRoomState.getInstance().clearCourseTimer();
            GF.clearTip();
            BC.removeEvent(this);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().bg_mc);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().control_mc);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().depth_mc);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().buttonLevel);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().type_mc);
            GC.clearChildren(this.lahmclassroombeen.getLahmClassRoomMC().top_mc);
            this.setupLahmClassRoomData(this.lahmclassroombeen.getLahmClassRoomInfo());
         }
      }
   }
   
   