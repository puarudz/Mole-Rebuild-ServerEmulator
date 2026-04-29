package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.logic.socket.examinePack.examinePackStuff;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.cutMapModule.SaveCutMap;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.view.monthlyView.MonthlyView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class newspaperMapView extends MapBase
   {
      
      public static var paperNum:int = 1;
      
      private var monthlyView:MonthlyView;
      
      private var bookMC:MovieClip;
      
      private var showEmailMC:MovieClip;
      
      private var sendEmailMC:MovieClip;
      
      public function newspaperMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"NPCwordMapChang_over",this.getNPCJobObj);
         controlLevel.mapRoom.buttonMode = true;
         BC.addEvent(this,controlLevel.mapRoom,MouseEvent.MOUSE_OVER,this.mcOverHandler);
         BC.addEvent(this,controlLevel.mapRoom,MouseEvent.MOUSE_OUT,this.mcOutHandler);
         controlLevel.camera_mc.buttonMode = false;
         buttonLevel.newsPaper_btn.buttonMode = true;
         controlLevel.camera_mc.addEventListener(MouseEvent.CLICK,this.tryCameraHandler);
         for(var i:int = 1; i <= 8; i++)
         {
            controlLevel["paper_" + i].buttonMode = true;
            controlLevel["paper_" + i].addEventListener(MouseEvent.MOUSE_OVER,this.paperOverHandler);
            controlLevel["paper_" + i].addEventListener(MouseEvent.MOUSE_OUT,this.paperOutHandler);
            controlLevel["paper_" + i].addEventListener(MouseEvent.CLICK,this.paperClickHandler);
         }
         controlLevel.emailBtn.addEventListener(MouseEvent.CLICK,this.showEmailHandler);
         buttonLevel.sendBtn.addEventListener(MouseEvent.CLICK,this.sendEmailHandler);
         buttonLevel.bookBtn.addEventListener(MouseEvent.CLICK,this.showBookHandler);
         controlLevel.amyBook_btn.addEventListener(MouseEvent.CLICK,this.showBookHandler);
         buttonLevel.newsPaper_btn.addEventListener(MouseEvent.CLICK,this.showEbookHandler);
         SystemEventManager.addEventListener("checkAmySay",this.onCheckAmySay);
         SystemEventManager.addEventListener("joinAimiSMC",this.onJoinAimiSMC);
         SystemEventManager.addEventListener("aimi16TaskSMC",this.onAimi16TaskSmc);
         SystemEventManager.addEventListener("aimi17TaskSMC",this.onAimi17TaskSmc);
         SystemEventManager.addEventListener("setAimiSMC",this.onSetAimiSmc);
         SystemEventManager.addEventListener("checkTuSay",this.onCheckTuSay);
         SystemEventManager.addEventListener("loveTestState45",this.loveTestState45Handler);
         buttonLevel.amy_Box.visible = false;
      }
      
      private function loveTestState45Handler(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         GF.sendSocket(CommandID.MOVIE_PLAY,322,0);
      }
      
      private function back12047(e:SocketEvent) : void
      {
         var data:ByteArray;
         var type:uint;
         var flag:uint;
         var status:uint;
         var tempArrayFront:Array = null;
         var resultFront:Array = null;
         var tempArrayBehind:Array = null;
         var resultBehind:Array = null;
         GV.onlineSocket.removeCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         data = e.data as ByteArray;
         data.position = 0;
         type = data.readUnsignedInt();
         flag = data.readUnsignedInt();
         status = data.readUnsignedInt();
         if(status == 1)
         {
            ActivityTmpDataManager.loveTestFlag = 2;
         }
         if(ActivityTmpDataManager.loveTestFlag == 1)
         {
            tempArrayFront = ActivityTmpDataManager.loveTestArray.slice(0,3);
            resultFront = tempArrayFront.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 1 ? true : false;
            });
            tempArrayBehind = ActivityTmpDataManager.loveTestArray.slice(3);
            resultBehind = tempArrayBehind.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 0 ? true : false;
            });
            if(ActivityTmpDataManager.loveTestArray[3] == 1)
            {
               if(resultBehind.length < tempArrayBehind.length)
               {
                  Alert.smileAlart("兔兔：聽說大衛最近又發明了什麼好東西？小摩爾幫我去看看吧~");
               }
               else if(resultBehind.length == tempArrayBehind.length)
               {
                  mapSay(101);
               }
            }
            else if(ActivityTmpDataManager.loveTestArray[3] == 0)
            {
               if(resultFront.length < tempArrayFront.length)
               {
                  Alert.smileAlart("先要通過其他人的愛心測試喲");
               }
               else if(resultFront.length == tempArrayFront.length)
               {
                  mapSay(101);
               }
            }
            else
            {
               Alert.angryAlart("伺服器數據錯誤。");
            }
         }
         else if(ActivityTmpDataManager.loveTestFlag == 2)
         {
            Alert.smileAlart("愛心測試已經完成了！");
         }
         else
         {
            ModuleManager.openPanel("LoveTestpanel");
         }
      }
      
      private function onCheckTuSay(e:Event) : void
      {
         var task497:Task = TaskManager.getTask(497);
         if(Boolean(task497) && task497.state == TaskStateType.FINISH)
         {
            mapSay(200);
         }
         else
         {
            mapSay(2);
         }
      }
      
      public function onAimi17TaskSmc(e:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.taskItemIDEvent);
         examinePackStuff.examinePack_create([190039,190040,190041]);
      }
      
      private function taskItemIDEvent(evt:EventTaomee) : void
      {
         var task17State:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.taskItemIDEvent);
         if(evt.EventObj.arr[0].count >= 1 && evt.EventObj.arr[1].count >= 1 && evt.EventObj.arr[2].count >= 1)
         {
            task17State = TaskManager.getTaskState(17);
            if(task17State == 1 && LocalUserInfo.getIQ() >= 20)
            {
               TaskManager.addEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOver17JobAlert);
               TaskOverProtocol.send(17);
            }
            else
            {
               Alert.smileAlart("    智慧值需達到20以上，城堡二樓拼圖大師遊戲可增加智慧值！");
            }
         }
         else
         {
            mapSay(16);
         }
      }
      
      private function onShowOver17JobAlert(evt:*) : void
      {
         TaskManager.removeEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOver17JobAlert);
         mapSay(17);
      }
      
      public function onSetAimiSmc(evt:Event) : void
      {
         var url:String = "resource/allJob/icon/amy17.swf";
         var msg:String = "    恭喜你獲得記者三件套！快穿齊它，點擊動作欄裡的揮手動作，開始拍照吧！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function onJoinAimiSMC(e:Event) : void
      {
         ModuleManager.openPanel(ModuleType.SMC_PANEL);
      }
      
      private function onAimi16TaskSmc(e:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1915,this.itemIDEvent);
         examinePackStuff.examinePack_create([190036,190037,190038]);
      }
      
      private function itemIDEvent(evt:EventTaomee) : void
      {
         var task16State:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1915,this.itemIDEvent);
         if(evt.EventObj.arr[0].count >= 1 && evt.EventObj.arr[1].count >= 1 && evt.EventObj.arr[2].count >= 1)
         {
            task16State = TaskManager.getTaskState(16);
            if(task16State == 1)
            {
               TaskManager.addEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOverJobAlert);
               TaskOverProtocol.send(16);
            }
            else
            {
               Alert.smileAlart("    任務還沒有完成！");
            }
         }
         else
         {
            mapSay(13);
         }
      }
      
      private function onShowOverJobAlert(evt:*) : void
      {
         TaskManager.removeEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOverJobAlert);
         mapSay(14);
         GV.onlineSocket.dispatchEvent(new EventTaomee("showCameraMC"));
      }
      
      private function onCheckAmySay(e:SystemEvent) : void
      {
         var task16State:uint = TaskManager.getTaskState(16);
         switch(task16State)
         {
            case 0:
               mapSay(11);
               break;
            case 1:
               mapSay(12);
               break;
            case 2:
               this.taskEvent();
         }
      }
      
      private function taskEvent() : void
      {
         var task17State:uint = TaskManager.getTaskState(17);
         switch(task17State)
         {
            case 0:
               mapSay(23);
               break;
            case 1:
               mapSay(15);
               break;
            case 2:
               mapSay(18);
         }
      }
      
      private function paperOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(2);
      }
      
      private function paperOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      private function mcOverHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(2);
      }
      
      private function mcOutHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      private function showBookHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.MC_AppLever.getChildByName("bookMC"))
         {
            this.bookMC = new MovieClip();
            this.bookMC.name = "bookMC";
            GV.MC_AppLever.addChild(this.bookMC);
            tempMC = new MCLoader("resource/pressman/pressmanBook.swf",this.bookMC,1,"正在打開記者手冊......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function showEbookHandler(evt:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.NEWS_PAPER_PANEL);
      }
      
      private function loadBookOverHandler(evt:MCLoadEvent) : void
      {
         var task17State:uint = TaskManager.getTaskState(17);
         if(task17State == 1)
         {
            GV.JobViews.finishJob(17,190041,true);
         }
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         childMC.content.root.main.close_btn.addEventListener(MouseEvent.CLICK,this.removeBook);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
         MCLoader(evt.target).clear();
      }
      
      private function removeBook(evt:MouseEvent) : void
      {
         var task17State:uint = TaskManager.getTaskState(17);
         if(task17State == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("get_ReporterBook"));
         }
         evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.removeBook);
         GC.stopAllMC(this.bookMC);
         GC.clearChildren(this.bookMC);
         this.bookMC.parent.removeChild(this.bookMC);
         this.bookMC = null;
      }
      
      private function getNPCJobObj(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"NPCwordMapChang_over",this.getNPCJobObj);
         var task16State:uint = TaskManager.getTaskState(16);
         if(task16State >= 2)
         {
            controlLevel.camera_mc.visible = true;
         }
         else
         {
            controlLevel.camera_mc.visible = false;
            BC.addEvent(this,GV.onlineSocket,"showCameraMC",this.showCameraMC);
         }
      }
      
      private function showCameraMC(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"showCameraMC",this.showCameraMC);
         controlLevel.camera_mc.visible = true;
      }
      
      private function tryCameraHandler(E:MouseEvent) : void
      {
         var task17State:uint = 0;
         SaveCutMap.G_addEventListener(SaveCutMap.CAMERA_CLOSE,this.closeCamera);
         if(!SaveCutMap.isUseCamera)
         {
            SaveCutMap.GetCamera();
            task17State = TaskManager.getTaskState(17);
            if(task17State == 1)
            {
               GV.JobViews.finishJob(17,190040,true);
            }
         }
      }
      
      private function closeCamera(E:Event) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.CAMERA_CLOSE,this.closeCamera);
         var task17State:uint = TaskManager.getTaskState(17);
         if(task17State == 1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("get_Camera"));
         }
      }
      
      private function paperHandler() : void
      {
         ModuleManager.openPanel(ModuleType.TIMES_ARK_PANEL,2007 + paperNum);
      }
      
      private function paperClickHandler(evt:MouseEvent) : void
      {
         var tempName:String = evt.target.name;
         paperNum = int(tempName.substr(6));
         this.paperHandler();
      }
      
      private function showEmailHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("showEmailMC"))
         {
            this.showEmailMC = new MovieClip();
            this.showEmailMC.name = "showEmailMC";
            MainManager.getGameLevel().addChild(this.showEmailMC);
            tempMC = new MCLoader("module/external/Contribute.swf",this.showEmailMC,1,"正在打開信件......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadshowEmailHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadshowEmailHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadshowEmailHandler);
         MCLoader(evt.target).clear();
      }
      
      private function sendEmailHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getGameLevel().getChildByName("sendEmailMC"))
         {
            this.sendEmailMC = new MovieClip();
            this.sendEmailMC.name = "sendEmailMC";
            MainManager.getGameLevel().addChild(this.sendEmailMC);
            tempMC = new MCLoader("module/external/ReporterPaper.swf",this.sendEmailMC,1,"正在打開信件......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadsendEmailHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadsendEmailHandler(evt:MCLoadEvent) : void
      {
         var task17State:uint = TaskManager.getTaskState(17);
         if(task17State == 1)
         {
            GV.JobViews.finishJob(17,190039,true);
         }
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadsendEmailHandler);
         MCLoader(evt.target).clear();
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("checkAmySay",this.onCheckAmySay);
         SystemEventManager.removeEventListener("joinAimiSMC",this.onJoinAimiSMC);
         SystemEventManager.removeEventListener("aimi16TaskSMC",this.onAimi16TaskSmc);
         SystemEventManager.removeEventListener("aimi17TaskSMC",this.onAimi17TaskSmc);
         SystemEventManager.removeEventListener("setAimiSMC",this.onSetAimiSmc);
         SystemEventManager.removeEventListener("loveTestState5",this.loveTestState45Handler);
         SystemEventManager.removeEventListener("checkTuSay",this.onCheckTuSay);
         TaskManager.removeEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOver17JobAlert);
         TaskManager.removeEventListener(TaskManager.TASK_STATE_CHANGE,this.onShowOverJobAlert);
         controlLevel.emailBtn.removeEventListener(MouseEvent.CLICK,this.showEmailHandler);
         for(var i:int = 1; i <= 8; i++)
         {
            controlLevel["paper_" + i].removeEventListener(MouseEvent.MOUSE_OVER,this.paperOverHandler);
            controlLevel["paper_" + i].removeEventListener(MouseEvent.MOUSE_OUT,this.paperOutHandler);
            controlLevel["paper_" + i].removeEventListener(MouseEvent.CLICK,this.paperClickHandler);
         }
         var mc:Sprite = MainManager.getAppLevel().getChildByName("SixOneBook") as Sprite;
         if(mc != null)
         {
            MainManager.getAppLevel().removeChild(mc);
         }
         controlLevel.amyBook_btn.removeEventListener(MouseEvent.CLICK,this.showBookHandler);
         super.destroy();
      }
   }
}

