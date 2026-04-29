package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.activityModule.Presented;
   import com.module.friendList.friendView.listView;
   import com.module.present.PresentManager;
   import com.mole.app.activity.CheckBirthday;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.mole.debug.DebugManager;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class KFCmap extends MapBase
   {
      
      private static const SMALL_CLERK_TASK_ID:uint = 577;
      
      private var smallClerkMc:Vector.<MovieClip>;
      
      private var smallClerkTask:Task;
      
      private var _kfcSpeaked:uint;
      
      private var _kfcInvited:uint;
      
      private var _kfcClothIndex:uint;
      
      private var _getKFCPrize:uint;
      
      private var kfcHatStep:uint;
      
      private var _kfcSpcQue:QueryItemCntManager;
      
      private var kfcquery:QueryItemCntManager;
      
      public function KFCmap()
      {
         super();
         StatisticsClass.getInstance().init(67746808,"http://g.cn.miaozhen.com/x.gif?k=1002815&p=3xzNs0&rt=2&o=");
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,this.target_mc["game_btn"],MouseEvent.CLICK,this.onStartGame);
         BC.addEvent(this,topLevel["activity_btn"],MouseEvent.MOUSE_OVER,this.overKfcActivityIntr);
         SystemEventManager.addEventListener("qiqi_gameStart",this.onStartGame);
         SystemEventManager.addEventListener("kfcdizhi",this.goqiqizhidao);
         SystemEventManager.addEventListener("getEgg",this.getEgg);
         GV.onlineSocket.addEventListener("goStop4",this.goStop4);
         GV.onlineSocket.addEventListener("sendData",this.sendData);
         this.smallClerkMc = new Vector.<MovieClip>();
         this.smallClerkMc.push(controlLevel["smallClerk1_mc"]);
         this.smallClerkMc.push(controlLevel["smallClerk2_mc"]);
         this.smallClerkMc.push(buttonLevel["smallClerk3_mc"]);
         this.smallClerkTask = TaskManager.getTask(SMALL_CLERK_TASK_ID);
         this.smallClerkTask.addEventListener(Task.TASK_OPEN,this.taskOpen);
         this.showSmallClerkMcState();
         SystemEventManager.addEventListener("childrenDay",this.onChildrenDay);
         SystemEventManager.addEventListener("KFCInvited",this.onKFCInvited);
         SystemEventManager.addEventListener("task589Over",this.task589OverHandle);
         SystemEventManager.addEventListener("KFCsmallSpy",this.kfcSmallSpyHandle);
         SystemEventManager.addEventListener("KFCSpyEight",this.KFCSpyEightHandle);
         SystemEventManager.addEventListener("KFCSuiPianSwap",this.suiPianSwapHandle);
         SystemEventManager.addEventListener("suipianrenwuOver",this.suipianrenwuOver);
         for(var i:uint = 1; i < 11; i++)
         {
            SystemEventManager.addEventListener("wactch" + i,this.watchHandle);
         }
         if(TaskManager.getTask(578).state == 1)
         {
            controlLevel["smallClerk200_mc"].visible = true;
         }
         if(TaskManager.getTask(579).state == 1)
         {
            controlLevel["smallClerk300_mc"].visible = true;
         }
         controlLevel["smallClerk200_mc"].visible = false;
         controlLevel["smallClerk300_mc"].visible = false;
         this.checkBirthday();
         SystemEventManager.addEventListener("putiMagic",this.puTiMagicHandle);
         BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCStepMagicHandle);
         BufferManager.getBuffer(BufferManager.KFC_MAGIC_DETECT_STEP);
         SystemEventManager.addEventListener("teacher",this.teacherHandle);
         SystemEventManager.addEventListener("musicCartoon",this.musicCarHandle);
         SystemEventManager.addEventListener("artTeacher",this.artTeacher);
         SystemEventManager.addEventListener("secondPrize",this.secondPrizeHandle);
         BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,this.bufferHanalde);
         BufferManager.getBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT);
      }
      
      private function bufferHanalde(e:EventTaomee) : void
      {
         var movie1:PlayMovie = null;
         this.kfcHatStep = uint(e.EventObj);
         if(this.kfcHatStep == 7)
         {
            movie1 = PlayMovie.play("resource/lucas/20131218/cartoon1.swf",null,null,function():void
            {
               var movie2:* = undefined;
               movie1.destroy();
               movie2 = PlayMovie.play("resource/lucas/20131218/cartoon2.swf",null,null,function():void
               {
                  movie2.destroy();
                  BufferManager.setBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,8);
                  Presented.getInstance().celebrate1225(3094);
                  BufferManager.setBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,9);
                  StatisticsManager.send(359);
               });
            });
         }
      }
      
      private function secondPrizeHandle(e:*) : void
      {
         if(this.kfcHatStep == 5 || this.kfcHatStep == 6)
         {
            Alert.smileAlart("快進入奪寶奇兵捕捉蛋撻精靈吧",function():void
            {
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,6);
               BufferManager.getBuffer(BufferManager.KFC_MAGIC_CHRISTMAS_HAT);
               ModuleManager.openPanel("KFCNewPlateARKGame");
            });
         }
      }
      
      private function artTeacher(e:*) : void
      {
         ModuleManager.openPanel(ModuleType.KFC_SEARCH_PIC_PANEL);
      }
      
      private function musicCarHandle(e:*) : void
      {
         var playMovie:PlayMovie = null;
         playMovie = PlayMovie.play("resource/map/cartoon/kfcmusicLes.swf",null,null,function():void
         {
            playMovie.destroy();
            ModuleManager.openPanel(ModuleType.KFC_SEARCH_CARD_PANEL);
         });
      }
      
      private function teacherHandle(e:*) : void
      {
         StatisticsManager.send(330);
         BufferManager.addBufferEvent(BufferManager.KFC_TEACHERDAY_ACT,this.bufferTeacher);
         BufferManager.getBuffer(BufferManager.KFC_TEACHERDAY_ACT);
      }
      
      private function bufferTeacher(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_TEACHERDAY_ACT,this.bufferTeacher);
         var times:uint = uint(e.EventObj);
         if(times == 0)
         {
            mapSay(24);
         }
         else if(times == 1)
         {
            mapSay(25);
         }
         else if(times == 2)
         {
            mapSay(27);
         }
      }
      
      private function KFCStepMagicHandle(e:EventTaomee) : void
      {
         var times:uint;
         var movie4:PlayMovie = null;
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCStepMagicHandle);
         times = uint(e.EventObj);
         if(times == 6)
         {
            movie4 = PlayMovie.play("resource/map/cartoon/cartoon4.swf",null,null,function():void
            {
               movie4.destroy();
               BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,7);
               MapManager.enterMap(57);
            });
         }
      }
      
      private function puTiMagicHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
         BufferManager.getBuffer(BufferManager.KFC_MAGIC_DETECT_STEP);
      }
      
      private function KFCMagicHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCMagicHandle);
         var times:uint = uint(e.EventObj);
         if(times == 3)
         {
            mapSay(21);
            BufferManager.setBuffer(BufferManager.KFC_MAGIC_DETECT_STEP,4);
         }
         else
         {
            Alert.angryAlart("  哎呀。。很可惜。。奇奇現在還不能告訴你有關的信息!");
         }
      }
      
      private function suipianrenwuOver(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("suipianrenwuOver",this.suipianrenwuOver);
         TaskManager.overTask(595);
         StatisticsManager.send(308);
         Alert.smileAlart("　　恭喜你已經成為中級小神探,得到經驗果實（大）和榮譽摩爾星！");
      }
      
      private function suiPianSwapHandle(e:SystemEvent) : void
      {
         if(TaskManager.getTask(595).getBit(7))
         {
            mapSay(19);
         }
         else
         {
            mapSay(20);
         }
      }
      
      private function KFCSpyEightHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_SPY_NECK_STEP,this.stepEight);
         BufferManager.getBuffer(BufferManager.KFC_SPY_NECK_STEP);
      }
      
      private function stepEight(e:EventTaomee) : void
      {
         var KFCNeckStep:uint;
         var movie:PlayMovie = null;
         BufferManager.removeBufferEvent(BufferManager.KFC_SPY_NECK_STEP,this.stepEight);
         KFCNeckStep = uint(e.EventObj);
         if(KFCNeckStep == 7)
         {
            BufferManager.setBuffer(BufferManager.KFC_SPY_NECK_STEP,8);
            BufferManager.setBuffer(BufferManager.KFC_SPY_NECK_STEP,9);
            movie = PlayMovie.play("resource/map/activity/kfcNeckEat.swf",null,null,function():void
            {
               movie.destroy();
               BufferManager.setBuffer(BufferManager.KFC_SPY_NECK_STEP,10);
               Alert.smileAlart("　　終於恢復體力了，現在就去牧場打開真相瓶子吧！",function():void
               {
                  MapManager.enterMap(9);
               });
            });
         }
      }
      
      private function getSpecialPre() : void
      {
         this._kfcSpcQue = new QueryItemCntManager();
         this._kfcSpcQue.addEventListener(QueryItemCntManager.DayTYPE_QUERY,this.KFCSpeHandle);
         this._kfcSpcQue.dayTypeQuery(2100000264);
      }
      
      private function KFCSpeHandle(e:EventTaomee) : void
      {
         this._kfcSpcQue.removeEventListener(QueryItemCntManager.DayTYPE_QUERY,this.KFCSpeHandle);
         var time:uint = uint(e.EventObj);
         if(time == 0)
         {
            if(TaskManager.getTask(593).state == 1)
            {
               Presented.getInstance().celebrate1225(2588);
            }
         }
      }
      
      private function checkBirthday() : void
      {
         if(CheckBirthday.CheckKFCBirthday() == 1)
         {
            trace("是生日");
            if(TaskManager.getTask(593).state != 2)
            {
               Alert.smileAlart("　　親愛的小摩爾，今天是你的生日，快點來參加KFC生日召集令吧，有豐富獎品等著你喲");
            }
         }
         else if(CheckBirthday.CheckKFCBirthday() == 0)
         {
            trace("不是生日");
         }
         else
         {
            trace("沒有注冊生日信息");
            Alert.angryAlart("　　親愛的小摩爾，快到生日飛艇留下你的生日，等待生日大禮的召喚吧");
         }
      }
      
      private function kfcSmallSpyHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_SPY_NECK_STEP,this.taskOne);
         BufferManager.getBuffer(BufferManager.KFC_SPY_NECK_STEP);
      }
      
      private function taskOne(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_SPY_NECK_STEP,this.taskOne);
         var KFCNeckStep:uint = uint(e.EventObj);
         if(KFCNeckStep == 7)
         {
            mapSay(16);
         }
         else
         {
            ModuleManager.openPanel(ModuleType.KFC_SMALL_SPY_PANEL);
         }
      }
      
      private function task589OverHandle(e:SystemEvent) : void
      {
         StatisticsManager.send(260);
         SystemEventManager.removeEventListener("task589Over",this.task589OverHandle);
         TaskManager.overTask(589);
         Alert.smileAlart("　　恭喜你，已完成了任務，成為超級小店員啦，可獲得2000元/月工資。");
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 2000);
      }
      
      private function watchHandle(e:SystemEvent) : void
      {
         for(var i:uint = 1; i < 11; i++)
         {
            SystemEventManager.removeEventListener("wactch" + i,this.watchHandle);
         }
         this._kfcClothIndex = uint(String(e.type).slice(6));
         GF.sendSocket(CommandID.SCENE_ACTIVITY_SEND_RESULT,this._kfcClothIndex);
         DebugManager.traceMsg("選擇了第" + this._kfcClothIndex + "款手表");
         for(var n:uint = 1; n < 11; n++)
         {
            SystemEventManager.removeEventListener("wactch" + n,this.watchHandle);
         }
         if(this._kfcClothIndex >= 1 && this._kfcClothIndex <= 5)
         {
            StatisticsManager.send(229);
            trace("送男款手表");
            Presented.getInstance().celebrate1225(2456);
         }
         else
         {
            StatisticsManager.send(229);
            trace("送女款手表");
            Presented.getInstance().celebrate1225(2457);
         }
         BufferManager.setBuffer(BufferManager.KFCWATCHED,1);
      }
      
      private function kfcFiveHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFCTASKFIVE,this.kfcFiveHandle);
         this._kfcSpeaked = uint(e.EventObj);
         BufferManager.addBufferEvent(BufferManager.KFCINVITED,this.kfcInvited);
         BufferManager.getBuffer(BufferManager.KFCINVITED);
      }
      
      private function kfcInvited(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFCINVITED,this.kfcInvited);
         this._kfcInvited = uint(e.EventObj);
         BufferManager.getBuffer(BufferManager.KFCINVITED);
         if(this._kfcSpeaked == 1 && this._kfcInvited == 1)
         {
            mapSay(6);
         }
         else if(this._kfcSpeaked == 1 && this._kfcInvited == 0)
         {
            mapSay(5);
         }
         else if(this._kfcSpeaked == 0 && this._kfcInvited == 0)
         {
            mapSay(4);
         }
         else
         {
            trace("lucas檢查下，有問題");
         }
      }
      
      private function onChildrenDay(e:Event) : void
      {
         var task:Task = null;
         StatisticsManager.send(283);
         if(CheckBirthday.CheckKFCBirthday() == 1)
         {
            trace("是生日");
            task = TaskManager.getTask(593);
            if(task.state == 2)
            {
               Alert.angryAlart("　　小摩爾已經完成了生日召集令了!");
            }
            else
            {
               this.getSpecialPre();
               ModuleManager.openPanel(ModuleType.KFC_BIRTHDAY_CALL_PANEL);
            }
         }
         else if(CheckBirthday.CheckKFCBirthday() == 0)
         {
            trace("不是生日");
            Alert.angryAlart("　　小摩爾只能在生日當天才能開始生日召集令活動哦！");
         }
         else
         {
            trace("沒有注冊生日信息");
            Alert.angryAlart("　　親愛的小摩爾,你還沒有填寫生日哦，快去生日飛艇登記吧！");
         }
      }
      
      private function kfcWatched(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFCWATCHED,this.kfcWatched);
         var _getKFCPrize:uint = uint(e.EventObj);
         if(_getKFCPrize == 0)
         {
            BufferManager.addBufferEvent(BufferManager.KFCTASKFIVE,this.kfcFiveHandle);
            BufferManager.getBuffer(BufferManager.KFCTASKFIVE);
         }
         else if(_getKFCPrize == 1)
         {
            mapSay(11);
         }
      }
      
      private function onKFCInvited(e:Event) : void
      {
         var tempMC:Class = null;
         var man:Class = null;
         var friendMC:MovieClip = null;
         var fmc:DisplayObject = null;
         BufferManager.setBuffer(BufferManager.KFCTASKFIVE,1);
         if(!MainManager.getAppLevel().getChildByName("friendMC") && !GV.isChangeMap)
         {
            tempMC = UIManager.getClass("friendListMC");
            man = UIManager.getClass("Man");
            friendMC = new tempMC();
            friendMC.name = "friendMC";
            friendMC.x = 623;
            friendMC.y = 164;
            friendMC.visible = PresentManager.showFriendPanelBool;
            MainManager.getAppLevel().addChild(friendMC);
            new listView(friendMC,man);
         }
         else
         {
            fmc = MainManager.getAppLevel().getChildByName("friendMC");
            if(Boolean(fmc))
            {
               fmc.visible = true;
            }
         }
      }
      
      private function taskOpen(evt:Event) : void
      {
         this.showSmallClerkMcState();
      }
      
      private function showSmallClerkMcState() : void
      {
         for(var ix:int = 0; ix < 3; ix++)
         {
            this.smallClerkMc[ix].visible = this.smallClerkTask.state == TaskStateType.OPEN || this.smallClerkTask.state == TaskStateType.FINISH;
            this.smallClerkMc[ix].buttonMode = true;
            if(this.smallClerkTask.getBit(ix + 1) == true || this.smallClerkTask.state == TaskStateType.FINISH)
            {
               this.smallClerkMc[ix].gotoAndStop(this.smallClerkMc[ix].totalFrames);
            }
            else
            {
               this.smallClerkMc[ix].addEventListener(MouseEvent.CLICK,this.changeSmallClerkTaskBuffer);
            }
         }
      }
      
      private function changeSmallClerkTaskBuffer(evt:MouseEvent) : void
      {
         var curSelMc:MovieClip = MovieClip(evt.currentTarget);
         for(var ix:int = 0; ix < this.smallClerkMc.length; ix++)
         {
            if(curSelMc == this.smallClerkMc[ix])
            {
               if(this.smallClerkTask.getBit(ix + 1))
               {
                  return;
               }
               this.smallClerkTask.setBit(ix + 1);
            }
         }
         curSelMc.gotoAndPlay(2);
         if(this.smallClerkTask.getBit(1) && this.smallClerkTask.getBit(2) && this.smallClerkTask.getBit(3))
         {
            StatisticsManager.send(162);
            TaskManager.overTask(SMALL_CLERK_TASK_ID);
            Alert.smileAlart("恭喜小摩爾完成任務，獲得1000摩爾豆，還有2個任務就可以晉升到普通小店員了");
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 1000);
         }
      }
      
      private function sendData(e:*) : void
      {
         GV.onlineSocket.removeEventListener("sendData",this.sendData);
         StatisticsManager.send(7);
      }
      
      private function goStop4(e:*) : void
      {
         SystemEventManager.removeEventListener("goStop4",this.goStop4);
         TaskManager.getTask(552).setStepAndPanel(4,4);
      }
      
      private function getEgg(e:*) : void
      {
         StatisticsManager.send(8);
         var tLimit:Number = new Date(2013,0,10,20,0,0).time;
         var tNow:Date = ServerUpTime.getInstance().date;
         var h:int = ServerUpTime.getInstance().getMoleHours;
         if(tNow.time < tLimit)
         {
            if(h == 18 || h == 19)
            {
               BC.addEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver,false,0,true);
               superlamuPartySocket.treasurebowl(101);
            }
            else
            {
               Alert.smileAlart("    每天18:00——20:00才能領取彩蛋哦！");
            }
         }
      }
      
      private function getPrizeOver(e:EventTaomee) : void
      {
         StatisticsManager.send(8);
         BC.removeEvent(this,GV.onlineSocket,"read_1242",this.getPrizeOver);
         var itemID:int = int(e.EventObj.itemId);
         var count:int = int(e.EventObj.count);
         Tool.alert(itemID,count);
      }
      
      private function overKfcActivityIntr(evt:MouseEvent) : void
      {
         StatisticsManager.send(184);
      }
      
      private function onStartGame(evt:*) : void
      {
         ModuleManager.openPanel(ModuleType.KFC_WORKSHOP_PANEL);
      }
      
      private function get target_mc() : MovieClip
      {
         return _mapLevel.controlLevel as MovieClip;
      }
      
      private function goqiqizhidao(e:*) : void
      {
         navigateToURL(new URLRequest("http://event.61.com/molekfc"),"_blank");
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("KFCSpyEight",this.KFCSpyEightHandle);
         SystemEventManager.removeEventListener("KFCsmallSpy",this.kfcSmallSpyHandle);
         GV.onlineSocket.removeEventListener("sendData",this.sendData);
         SystemEventManager.removeEventListener("goStop4",this.goStop4);
         SystemEventManager.removeEventListener("getEgg",this.getEgg);
         SystemEventManager.removeEventListener("qiqi_gameStart",this.onStartGame);
         SystemEventManager.removeEventListener("kfcdizhi",this.goqiqizhidao);
         SystemEventManager.removeEventListener("childrenDay",this.onChildrenDay);
         SystemEventManager.removeEventListener("KFCInvited",this.onKFCInvited);
         BufferManager.removeBufferEvent(BufferManager.KFCTASKFIVE,this.kfcFiveHandle);
         this.smallClerkTask.removeEventListener(Task.TASK_OPEN,this.taskOpen);
         BufferManager.removeBufferEvent(BufferManager.KFCINVITED,this.kfcInvited);
         BufferManager.removeBufferEvent(BufferManager.KFCWATCHED,this.kfcWatched);
         for(var i:uint = 1; i < 11; i++)
         {
            SystemEventManager.addEventListener("wactch" + i,this.watchHandle);
         }
         BufferManager.removeBufferEvent(BufferManager.KFC_SPY_NECK_STEP,this.stepEight);
         SystemEventManager.removeEventListener("task589Over",this.task589OverHandle);
         SystemEventManager.removeEventListener("KFCSuiPianSwap",this.suiPianSwapHandle);
         SystemEventManager.removeEventListener("suipianrenwuOver",this.suipianrenwuOver);
         SystemEventManager.removeEventListener("putiMagic",this.puTiMagicHandle);
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_DETECT_STEP,this.KFCStepMagicHandle);
         SystemEventManager.removeEventListener("teacher",this.teacherHandle);
         SystemEventManager.removeEventListener("musicCartoon",this.musicCarHandle);
         SystemEventManager.removeEventListener("artTeacher",this.artTeacher);
         SystemEventManager.removeEventListener("secondPrize",this.secondPrizeHandle);
         BufferManager.removeBufferEvent(BufferManager.KFC_MAGIC_CHRISTMAS_HAT,this.bufferHanalde);
         super.destroy();
      }
   }
}

