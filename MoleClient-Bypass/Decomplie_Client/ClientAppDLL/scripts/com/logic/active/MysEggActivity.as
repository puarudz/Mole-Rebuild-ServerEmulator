package com.logic.active
{
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.login.LoginShared;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.module.npcFollowMole.EggFollowMole;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.mole.net.events.SocketEvent;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   
   public class MysEggActivity
   {
      
      private static var _inst:MysEggActivity;
      
      private var _mapArr:Array = [42,3,47,41,68,37,53,109,21];
      
      private var _itemID:int = 1351478;
      
      private var eggFollowMole:EggFollowMole;
      
      private var hasEgg:Boolean = false;
      
      private var man:PeopleManageView;
      
      private var timer:uint;
      
      private var interIndex:int;
      
      private var leftDoneTimes:int;
      
      public var leftTime:int;
      
      public var eggState:int;
      
      private var _movie:PlayMovie;
      
      private var tempMc:MovieClip;
      
      private var type:int = 2210;
      
      private var dayType:int = 31494;
      
      private var type0:int = 2212;
      
      private var dayType0:int = 2100000236;
      
      private var tempTimer:uint;
      
      private var tempTips:Array = ["麼麼公主正在拉姆廣場主持頒獎典禮！","本週熱點：拉姆排排站！","絢爛的煙花盛典，你參加了嗎？"];
      
      private var _mapTips:Array = ["聽說在彩虹瀑布放一盞河燈可以許一個願望，而且還很靈驗！你帶我去放河燈許願好不好？","我也要為拉姆運動會吶喊助威！低調做人，高調做事！淘淘樂街人多最熱鬧，我們就去那兒！","怎麼所有人都去粒粒小廣場了，那兒有什麼能如此吸引大家？我也要去湊熱鬧！我也要去湊熱鬧！","嗚嗚嗚~~~肚子餓了！想起迪迪拉給我說過漿果叢林的大紅棗和紅色漿果最香甜可口了……","我們去找迪迪拉聊聊天吧！我有點想她了！","莊園之大，無奇不有，東邊可以春光明媚，西邊卻仍舊白雪皚皚。哇~不知能不能見到雪……雪……雪……","莊園裡最受人尊敬，最有地位的摩爾是誰？他一定很有威嚴，又很有學問的感覺！我有這個榮幸見到他嗎？","一天，我問魔鏡：“這個世界上最美的人是誰？“他說：“當然是麼麼公主！”她有我可愛，有我萌嗎？我要當面和她比一比。","拉姆寵物店？拉姆，是果凍做的嗎？可是，果凍怎麼能變成寵物呢？好想知道！","快點擊瀑布下的蓮花河燈！","我也要為拉姆運動會吶喊助威！","什麼是拉姆排排站？不明白……我想看看說明面板！","我要吃又大又甜的紅棗和紅色漿果！","快去找迪迪拉聊會兒天吧！","快點我！我要看雪……雪……雪……","菩提大伯~~~嗯~~~一聽名字就很有氣質，很有學問的感覺。","快帶我去見見那位傳說中的最美公主！","快去找彩虹姐姐聊會兒天吧！"];
      
      private var _tips:Array = ["快點我！我想到要去哪裡了！"];
      
      public function MysEggActivity()
      {
         super();
      }
      
      public static function get inst() : MysEggActivity
      {
         if(_inst == null)
         {
            _inst = new MysEggActivity();
         }
         return _inst;
      }
      
      public function init() : void
      {
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = MapEvent.CHANGE_MAP_COMPLETE;
         with({})
         {
            _temp_2.addEventListener(_temp_1,function changeOver():void
            {
               GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,changeOver);
               man = PeopleManageView(GV.MAN_PEOPLE);
               getInterDoneTimes();
            });
         }
         
         public function openPanel() : void
         {
            Tool.finishSomething(this.dayType0,function(doneTimes:int):void
            {
               if(doneTimes < 1)
               {
                  Tool.exchangeGoods(type0,false);
                  ModuleManager.openPanel("MysEggIntroPanel");
               }
               else
               {
                  getFriendly(function(count:int):void
                  {
                     if(count == 100)
                     {
                        ModuleManager.openPanel("MysEggPanel4");
                     }
                     else
                     {
                        ModuleManager.openPanel("MysEggPanel0");
                     }
                  });
               }
            });
         }
         
         private function getInterDoneTimes() : void
         {
            Tool.finishSomething(this.dayType,this.getDoneTimes);
         }
         
         private function getDoneTimes(doneTimes:int) : void
         {
            if(doneTimes == 0)
            {
               LoginShared.getCurMoleDate().data.mysEggInterArr = [];
            }
            this.leftDoneTimes = 5 - doneTimes;
            this.getLeftTime();
         }
         
         public function eggFollow() : void
         {
            if(this.eggFollowMole == null)
            {
               BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.changeMapOver);
               this.eggFollowMole = new EggFollowMole(GV.MAN_PEOPLE);
               this.hasEgg = true;
               this.eggSay();
            }
         }
         
         private function eggSay() : void
         {
            if(this.leftDoneTimes > 0 && this.leftTime == 0)
            {
               if(this.hasEgg)
               {
                  this.eggFollowMole.say(this._tips[0]);
               }
            }
         }
         
         private function changeMapOver(e:EventTaomee) : void
         {
            if(this.hasEgg)
            {
               this.eggFollowMole = new EggFollowMole(GV.MAN_PEOPLE);
               this.eggSay();
            }
            else
            {
               this.eggFollowMole.Clear();
            }
         }
         
         public function delEgg() : void
         {
         }
         
         public function getFriendly(callBack:Function) : void
         {
            var _temp_2:* = GV.onlineSocket;
            var _temp_1:* = GetItemCountRes.GET_ITEMCOUNT;
            with({})
            {
               _temp_2.addEventListener(_temp_1,function checkOver(e:EventTaomee):void
               {
                  GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,checkOver);
                  var arr:Array = e.EventObj.obj.arr;
                  var len:int = int(arr.length);
                  var num:int = 0;
                  if(len > 0)
                  {
                     num = int(arr[0].Count);
                  }
                  callBack.apply(null,[num]);
               });
               GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._itemID,2);
            }
            
            public function handleInter(index:int) : void
            {
               GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.changeMapOver2);
            }
            
            private function changeMapOver2(e:*) : void
            {
               GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.changeMapOver2);
               this.eggFollowMole.say(this._mapTips[9 + this.interIndex]);
               if(LocalUserInfo.getMapID() == this._mapArr[this.interIndex])
               {
                  switch(this.interIndex)
                  {
                     case 0:
                        this.loadArrow1();
                        break;
                     case 1:
                        this.loadCountDown();
                        break;
                     case 2:
                        this.loadArrow2();
                        break;
                     case 3:
                        this.loadArrow3();
                        break;
                     case 4:
                        this.loadDidila();
                        break;
                     case 5:
                        this.eggFollowMole.addClickEvent();
                        break;
                     case 6:
                        this.loadGantanhao1();
                        break;
                     case 7:
                        this.loadGantanhao2();
                        break;
                     case 8:
                        this.loadGantanhao3();
                  }
               }
            }
            
            public function playEggSnowMovie() : void
            {
               GV.MAN_PEOPLE.visible = false;
               this.eggFollowMole.visible = false;
               this._movie = PlayMovie.play("resource/movie/eggSnowMovie.swf",null,null,this.playEggSnowMovieOver);
            }
            
            private function playEggSnowMovieOver() : void
            {
               GV.MAN_PEOPLE.visible = true;
               this.eggFollowMole.visible = true;
               this._movie.destroy();
               this._movie = null;
               this.doInter(5);
            }
            
            private function loadCountDown() : void
            {
               var resID:int = int(DownLoadManager.add("resource/movie/countDown.swf",ResType.DISPLAY_OBJECT));
               DownLoadManager.addEvent(resID,this.loadCountOver);
            }
            
            private function loadCountOver(e:DownLoadEvent) : void
            {
               var mc:MovieClip = null;
               var index:int = 0;
               var changeMapOver:Function = null;
               var clearMc:Function = function():void
               {
                  GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,changeMapOver);
                  clearTimeout(tempTimer);
                  DisplayUtil.removeForParent(mc);
               };
               changeMapOver = function(e:*):void
               {
                  clearMc();
               };
               mc = (e.data as MovieClip).getChildAt(0) as MovieClip;
               mc.y = -120;
               mc.x = 0;
               GV.MAN_PEOPLE.addChild(mc);
               index = 0;
               PeopleManageView(GV.MAN_PEOPLE).say(this.tempTips[index]);
               this.tempTimer = setInterval(function():void
               {
                  ++index;
                  index %= 3;
                  PeopleManageView(GV.MAN_PEOPLE).say(tempTips[index]);
               },10000);
               MovieClipUtil.playEndAndFunc(mc,function():void
               {
                  clearMc();
                  doInter(1);
               });
               GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,changeMapOver);
            }
            
            private function loadDidila() : void
            {
               var resID:int = int(DownLoadManager.add("module/external/exeModule/didila.swf",ResType.DISPLAY_OBJECT));
               DownLoadManager.addEvent(resID,this.loadDidilaOver);
            }
            
            private function loadDidilaOver(e:DownLoadEvent) : void
            {
               this.tempMc = (e.data as MovieClip).getChildAt(0) as MovieClip;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.buttonMode = true;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickDidila);
            }
            
            private function clickDidila(e:MouseEvent) : void
            {
               SystemEventManager.addEventListener("mysEggDidilaOver",this.didilaTalkOver);
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(6));
            }
            
            private function didilaTalkOver(e:SystemEvent) : void
            {
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               SystemEventManager.removeEventListener("mysEggDidilaOver",this.didilaTalkOver);
               this.doInter(4);
            }
            
            private function loadArrow3() : void
            {
               this.loadArrow(this.loadArrowOver3);
            }
            
            private function loadArrowOver3(e:DownLoadEvent) : void
            {
               this.tempMc = (e.data as MovieClip).getChildAt(0) as MovieClip;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.buttonMode = true;
               this.tempMc.x = 674;
               this.tempMc.y = 293;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow3);
            }
            
            private function loadArrow2() : void
            {
               this.loadArrow(this.loadArrowOver2);
            }
            
            private function loadArrowOver2(e:DownLoadEvent) : void
            {
               this.tempMc = (e.data as MovieClip).getChildAt(0) as MovieClip;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.buttonMode = true;
               this.tempMc.x = 542;
               this.tempMc.y = 125;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow2);
            }
            
            private function clickArrow3(e:MouseEvent) : void
            {
               GV.MAN_PEOPLE.visible = false;
               this.eggFollowMole.visible = false;
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow3);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               this._movie = PlayMovie.play("resource/movie/eggEatMovie.swf",null,null,this.playEatMovieOver);
            }
            
            private function playEatMovieOver() : void
            {
               GV.MAN_PEOPLE.visible = true;
               this.eggFollowMole.visible = true;
               this._movie.destroy();
               this._movie = null;
               this.doInter(3);
            }
            
            private function clickArrow2(e:MouseEvent) : void
            {
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow2);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               this.doInter(2);
            }
            
            private function loadGantanhao3() : void
            {
               this.loadGantanhao(this.loadGantanOver3);
            }
            
            private function loadGantanOver3(e:DownLoadEvent) : void
            {
               this.tempMc = (e.data as MovieClip).getChildAt(0) as MovieClip;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.x = 337;
               this.tempMc.y = 177;
               this.tempMc.buttonMode = true;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan3);
            }
            
            private function clickGantan3(e:MouseEvent) : void
            {
               SystemEventManager.addEventListener("rainbowTalkOver",this.rainbowTalkOver);
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(6));
            }
            
            private function rainbowTalkOver(e:SystemEvent) : void
            {
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan3);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               SystemEventManager.removeEventListener("rainbowTalkOver",this.rainbowTalkOver);
               this.doInter(8);
            }
            
            private function loadGantanhao2() : void
            {
               this.loadGantanhao(this.loadGantanOver2);
            }
            
            private function loadGantanOver2(e:DownLoadEvent) : void
            {
               this.tempMc = e.data;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.x = -210;
               this.tempMc.y = 180;
               this.tempMc.buttonMode = true;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan2);
            }
            
            private function clickGantan2(e:MouseEvent) : void
            {
               SystemEventManager.addEventListener("momoTalkOver",this.momoTalkOver);
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(105));
            }
            
            private function momoTalkOver(e:SystemEvent) : void
            {
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan2);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               SystemEventManager.removeEventListener("momoTalkOver",this.momoTalkOver);
               this.doInter(7);
            }
            
            private function loadGantanhao1() : void
            {
               this.loadGantanhao(this.loadGantanOver1);
            }
            
            private function loadGantanOver1(e:DownLoadEvent) : void
            {
               this.tempMc = e.data;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.buttonMode = true;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan1);
            }
            
            private function clickGantan1(e:MouseEvent) : void
            {
               SystemEventManager.addEventListener("putiTalkOver",this.putiTalkOver);
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(4));
            }
            
            private function putiTalkOver(e:SystemEvent) : void
            {
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickGantan1);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               SystemEventManager.removeEventListener("putiTalkOver",this.putiTalkOver);
               this.doInter(6);
            }
            
            private function loadGantanhao(func:Function) : void
            {
               var resID:int = int(DownLoadManager.add("module/external/exeModule/gantanhao.swf",ResType.DISPLAY_OBJECT));
               DownLoadManager.addEvent(resID,func);
            }
            
            private function loadArrow1() : void
            {
               this.loadArrow(this.loadArrowOver);
            }
            
            private function loadArrowOver(e:DownLoadEvent) : void
            {
               this.tempMc = e.data;
               MainManager.getAppLevel().addChild(this.tempMc);
               this.tempMc.buttonMode = true;
               BC.addEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow);
            }
            
            private function clickArrow(e:MouseEvent) : void
            {
               BC.removeEvent(this,this.tempMc,MouseEvent.CLICK,this.clickArrow);
               DisplayUtil.removeForParent(this.tempMc);
               this.tempMc = null;
               GV.onlineSocket.dispatchEvent(new EventTaomee("mysEggClickLotus"));
            }
            
            private function loadArrow(func:Function) : void
            {
               var resID:int = int(DownLoadManager.add("module/external/exeModule/tempArrow.swf",ResType.DISPLAY_OBJECT));
               DownLoadManager.addEvent(resID,func);
            }
            
            public function doInter(index:int) : void
            {
               var arr:Array = null;
               if(this.leftDoneTimes > 0)
               {
                  --this.leftDoneTimes;
                  Tool.exchangeGoods(this.type,false);
                  arr = LoginShared.getCurMoleDate().data.mysEggInterArr;
                  if(arr == null)
                  {
                     arr = [];
                  }
                  arr.push(index);
                  LoginShared.getCurMoleDate().data.mysEggInterArr = arr;
                  this.checkOpenPanel4();
                  ephemeralDataSocket.setData(24,ServerUpTime.getInstance().date.time / 1000);
               }
               this.eggFollowMole.clearTips();
            }
            
            private function checkOpenPanel4() : void
            {
               this.getFriendly(function(count:int):void
               {
                  if(count == 100)
                  {
                     ModuleManager.openPanel("MysEggPanel4");
                  }
                  else if(leftDoneTimes > 0)
                  {
                     ModuleManager.openPanel("MysEggPanel2");
                  }
                  else
                  {
                     ModuleManager.openPanel("MysEggPanel3");
                  }
               });
            }
            
            public function getLeftTime() : void
            {
               OnlineManager.addErrorListener(1215,this.onGetTimeError);
               GV.onlineSocket.addEventListener("read_1215",this.readTimeOver);
               ephemeralDataSocket.getData(24);
            }
            
            private function onGetTimeError(e:SocketEvent) : void
            {
               if(e.cmdID == 1215)
               {
                  ephemeralDataSocket.setData(24,0);
                  this.leftTime = 0;
               }
            }
            
            private function readTimeOver(e:EventTaomee) : void
            {
               GV.onlineSocket.removeEventListener("read_1215",this.readTimeOver);
               var time:uint = uint(e.EventObj.data);
               var date:Date = ServerUpTime.getInstance().date;
               var timeNow:Number = date.time;
               this.leftTime = 3 * 60 - (timeNow / 1000 - time);
               this.leftTime = this.leftTime < 0 ? 0 : this.leftTime;
               this.startTimer();
            }
            
            private function startTimer() : void
            {
               clearInterval(this.timer);
               this.timer = setInterval(this.tick,1000);
            }
            
            private function tick() : void
            {
               if(this.leftTime > 0)
               {
                  --this.leftTime;
               }
               else
               {
                  this.eggSay();
                  clearTimeout(this.timer);
               }
            }
            
            public function handelClickEgg() : void
            {
               this.getFriendly(function(count:int):void
               {
                  if(count == 100)
                  {
                     ModuleManager.openPanel("MysEggPanel4");
                  }
                  else if(leftDoneTimes > 0)
                  {
                     if(leftTime == 0)
                     {
                        interIndex = getInterIndex();
                        ModuleManager.openPanel("MysEggPanel1",interIndex);
                     }
                     else
                     {
                        ModuleManager.openPanel("MysEggPanel2");
                     }
                  }
               });
            }
            
            private function getInterIndex() : int
            {
               var arr:Array = LoginShared.getCurMoleDate().data.mysEggInterArr;
               if(arr == null)
               {
                  arr = [];
               }
               var rand:int = 0;
               for(var i:int = 0; i < 30; i++)
               {
                  rand = Math.random() * 9;
                  if(arr.indexOf(rand) == -1)
                  {
                     break;
                  }
               }
               arr.push(rand);
               return rand;
            }
            
            public function destroy() : void
            {
               clearTimeout(this.timer);
               BC.removeEvent(this);
            }
         }
      }
      
      