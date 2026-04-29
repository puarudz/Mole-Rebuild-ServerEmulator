package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.core.login.LoginShared;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.module.query.QueryImpl;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class MoleKingActy
   {
      
      private static var _inst:MoleKingActy;
      
      public var curStep:int;
      
      private var mid:int;
      
      private var treeState:int;
      
      private var _movie:PlayMovie;
      
      private var itemArr:Array = [{
         "itemID":190238,
         "count":2
      },{
         "itemID":190241,
         "count":1
      },{
         "itemID":190289,
         "count":5
      }];
      
      private var itemIndex:int = 0;
      
      private var overFunc:Function;
      
      public function MoleKingActy()
      {
         super();
      }
      
      public static function get inst() : MoleKingActy
      {
         if(_inst == null)
         {
            _inst = new MoleKingActy();
         }
         return _inst;
      }
      
      public function getStep(overFunc:Function = null) : void
      {
         GV.onlineSocket.addCmdListener(9200,this.getStepOver);
         GF.sendSocket(9200);
         this.overFunc = overFunc;
      }
      
      private function getStepOver(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(9200,this.getStepOver);
         var data:ByteArray = e.data as ByteArray;
         this.curStep = data.readUnsignedInt();
         if(this.overFunc != null)
         {
            this.overFunc.apply();
            this.overFunc = null;
         }
      }
      
      public function init() : void
      {
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
         GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 229)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         this.mid = LocalUserInfo.getMapID();
         if(this.mid == 331 || this.mid == 353 || this.mid == 351 || this.mid == 354 || this.mid == 152 || this.mid == 259)
         {
            this.getStep(this.initMap);
         }
      }
      
      private function initMap() : void
      {
         if(this.mid == 331)
         {
            this.initMap331();
         }
         else if(this.mid == 353)
         {
            this.initMap353();
         }
         else if(this.mid == 351)
         {
            this.initMap351();
         }
         else if(this.mid == 354)
         {
            this.initMap354();
         }
         else if(this.mid == 152)
         {
            this.initMap152();
         }
         else if(this.mid == 259)
         {
            this.initMap259();
         }
      }
      
      private function initMap259() : void
      {
         var resID:int = 0;
         if(this.curStep == 7)
         {
            resID = int(DownLoadManager.add("module/external/exeModule/201311/moleKingArrow.swf",ResType.DISPLAY_OBJECT));
            DownLoadManager.addEvent(resID,this.loadArrowOver);
         }
      }
      
      private function loadArrowOver(e:DownLoadEvent) : void
      {
         var data:MovieClip = e.data as MovieClip;
         data.buttonMode = true;
         LevelManager.mapLevel.addChild(data);
         BC.addEvent(this,data,MouseEvent.CLICK,this.clickArrow);
      }
      
      private function clickArrow(e:MouseEvent) : void
      {
         BC.removeEvent(this,e.currentTarget,MouseEvent.CLICK,this.clickArrow);
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie3.swf",null,null,this.playMovieOver5);
      }
      
      private function playMovieOver5() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         Alert.smileAlart("      恭喜你獲得八音盒！",function():void
         {
            GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,onEnter354Over);
            MapManager.enterMap(354);
         });
      }
      
      private function onEnter354Over(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onEnter354Over);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(17));
         SystemEventManager.addEventListener("moleKingStep70",this.moleKingStep70);
      }
      
      private function moleKingStep70(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep70",this.moleKingStep70);
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie4.swf",null,null,this.playMovieOver6);
      }
      
      private function playMovieOver6() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         SystemEventManager.addEventListener("moleKingOver",this.moleKingOver);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(19));
      }
      
      private function moleKingOver(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingOver",this.moleKingOver);
         GV.onlineSocket.addCmdListener(9201,this.getTaskPrize);
         GF.sendSocket(9201,1,8);
         this.curStep = 8;
         LoginShared.getCurMoleDate().data.moleKingOverDate = ServerUpTime.getInstance().date.date;
      }
      
      private function initMap331() : void
      {
         SystemEventManager.addEventListener("moleKingAct",this.moleKingAct);
      }
      
      private function initMap353() : void
      {
         GV.MC_mapFrame["control_mc"].npc_10234.buttonMode = true;
         if(this.curStep > 1)
         {
            BC.addEvent(this,GV.MC_mapFrame["control_mc"].npc_10234,MouseEvent.CLICK,this.clickSolder);
            SystemEventManager.addEventListener("step2Talk",this.step2Talk);
         }
         else
         {
            GV.MC_mapFrame["control_mc"].npc_10234.visible = false;
         }
         this.initTask1();
      }
      
      private function initTask1() : void
      {
         SystemEventManager.addEventListener("helpEvent",this.onHelpEvent);
         SystemEventManager.addEventListener("helpEventTask0",this.helpEventTask0);
         SystemEventManager.addEventListener("helpTask0Over",this.helpTask0Over);
      }
      
      private function helpTask0Over(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(9201,this.getTask1PrizeOver);
         GF.sendSocket(9201,0,8);
      }
      
      private function getTask1PrizeOver(e:SocketEvent) : void
      {
         var state:int = 0;
         var count:int = 0;
         var msg:String = null;
         var itemID:int = 0;
         var i:int = 0;
         var cnt:int = 0;
         GV.onlineSocket.removeCmdListener(9201,this.getTask1PrizeOver);
         var data:ByteArray = e.data as ByteArray;
         if(data != null)
         {
            state = int(data.readUnsignedInt());
            if(state == 1)
            {
               count = int(data.readUnsignedInt());
               msg = "    恭喜你獲得";
               for(i = 0; i < count; i++)
               {
                  itemID = int(data.readUnsignedInt());
                  cnt = int(data.readUnsignedInt());
                  msg += cnt + "個" + GoodsInfo.getItemNameByID(itemID);
                  if(i < count - 1)
                  {
                     msg += ",";
                  }
               }
               msg += "!";
               Alert.smileAlart(msg);
            }
            else if(state == 0)
            {
               Alert.smileAlart("    你今天已經幫過忙了，明天再來吧！");
            }
         }
      }
      
      private function helpEventTask0(e:SystemEvent) : void
      {
         this.checkNumEnough();
      }
      
      private function checkNumEnough() : void
      {
         QueryImpl.getInstance().QueryItem([this.itemArr[0].itemID,this.itemArr[1].itemID,this.itemArr[2].itemID],this.queryOver);
      }
      
      private function queryOver(arr:Array) : void
      {
         var i:int = 0;
         var msg:String = "    你的";
         var tarr:Array = [];
         for(i = 0; i < 3; i++)
         {
            if(arr[i].itemID == this.itemArr[i].itemID)
            {
               if(arr[i].count < this.itemArr[i].count)
               {
                  tarr.push(i);
               }
            }
         }
         for(i = 0; i < tarr.length; i++)
         {
            msg += GoodsInfo.getItemNameByID(arr[tarr[i]].itemID);
            if(i < tarr.length - 1)
            {
               msg += "，";
            }
         }
         msg += "不足喲！";
         if(tarr.length == 0)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(11));
         }
         else
         {
            Alert.angryAlart(msg);
         }
      }
      
      private function onHelpEvent(e:SystemEvent) : void
      {
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(5));
      }
      
      private function clickSolder(e:MouseEvent) : void
      {
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(1));
      }
      
      private function initMap351() : void
      {
         var obj0:Object = null;
         if(this.curStep >= 3)
         {
            BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
            obj0 = {
               "btn":GV.MC_mapFrame["control_mc"].tree,
               "mc":new MovieClip(),
               "id":"swf150001",
               "fre":1,
               "hide":true
            };
            throwHitTest.HitTestMC(obj0);
         }
      }
      
      private function initMap152() : void
      {
         GV.MC_mapFrame["control_mc"].npc_10060.buttonMode = true;
         BC.addEvent(this,GV.MC_mapFrame["control_mc"].npc_10060,MouseEvent.CLICK,this.clickTulin);
      }
      
      private function clickTulin(e:MouseEvent) : void
      {
         if(this.curStep >= 6)
         {
            if(this.curStep == 6)
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(3));
               SystemEventManager.addEventListener("moleKingStep60",this.moleKingStep60);
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(19));
            }
         }
         else
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(2));
         }
      }
      
      private function moleKingStep60(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep60",this.moleKingStep60);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(20));
         SystemEventManager.addEventListener("moleKingStep61",this.moleKingStep61);
      }
      
      private function moleKingStep61(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep61",this.moleKingStep61);
         GF.sendSocket(9201,1,7);
         this.goMap259();
         this.curStep = 7;
      }
      
      private function goMap259() : void
      {
         MapManager.enterMap(259);
      }
      
      private function initMap354() : void
      {
         if(this.curStep == 4 || this.curStep == 5 || this.curStep == 6 || this.curStep == 8 || this.curStep == 9)
         {
            GV.MC_mapFrame["control_mc"].yorick.visible = true;
            BC.addEvent(this,GV.MC_mapFrame["control_mc"].yorick,MouseEvent.CLICK,this.clickYorick);
         }
         else
         {
            GV.MC_mapFrame["control_mc"].yorick.visible = false;
         }
         GV.MC_mapFrame["control_mc"].yorick.buttonMode = true;
         SystemEventManager.addEventListener("moleKingStep40",this.moleKingStep40);
      }
      
      private function clickYorick(e:MouseEvent) : void
      {
         if(this.curStep == 4)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(1));
         }
         else if(this.curStep == 5)
         {
            trace("LoginShared.getCurMoleDate().data.moleKingDay" + LoginShared.getCurMoleDate().data.moleKingDay);
            trace("ServerUpTime.getInstance().date.date" + ServerUpTime.getInstance().date.date);
            GV.onlineSocket.addCmdListener(CommandID.COME_BK_STATUS,this.typeHandle);
            GF.sendSocket(CommandID.COME_BK_STATUS,653);
         }
         else if(this.curStep == 6)
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(16));
         }
         else if(this.curStep == 8 || this.curStep == 9)
         {
            GV.onlineSocket.addCmdListener(CommandID.COME_BK_STATUS,this.typeHideHandle);
            GF.sendSocket(CommandID.COME_BK_STATUS,654);
         }
      }
      
      private function typeHideHandle(e:SocketEvent) : void
      {
         var timeueu:uint = 0;
         var time:uint = 0;
         var tarData:uint = 0;
         GV.onlineSocket.removeCmdListener(CommandID.COME_BK_STATUS,this.typeHideHandle);
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var type:uint = data.readUnsignedInt();
         if(type == 654)
         {
            timeueu = data.readUnsignedInt();
            time = data.readUnsignedInt();
            tarData = uint(String(time).slice(6));
            if(tarData != ServerUpTime.getInstance().date.date)
            {
               SystemEventManager.addEventListener("mokeKingTask2Event",this.mokeKingTask2Event);
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(20));
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(21));
            }
         }
      }
      
      private function typeHandle(e:SocketEvent) : void
      {
         var time2:uint = 0;
         var time:uint = 0;
         var tarData:uint = 0;
         GV.onlineSocket.removeCmdListener(CommandID.COME_BK_STATUS,this.typeHandle);
         var data:ByteArray = e.data as ByteArray;
         data.position = 0;
         var type:uint = data.readUnsignedInt();
         if(type == 653)
         {
            time2 = data.readUnsignedInt();
            time = data.readUnsignedInt();
            tarData = uint(String(time).slice(6));
            if(tarData != ServerUpTime.getInstance().date.date)
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(9));
               SystemEventManager.addEventListener("moleKingStep50",this.moleKingStep50);
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(22));
            }
         }
      }
      
      private function mokeKingTask2Event(e:SystemEvent) : void
      {
         GV.MC_mapFrame["control_mc"].yorick.visible = false;
         GV.MAN_PEOPLE.visible = false;
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie0.swf",null,null,this.playMovieOver7);
      }
      
      private function playMovieOver7() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         GV.MC_mapFrame["control_mc"].yorick.visible = true;
         GV.MAN_PEOPLE.visible = true;
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(21));
         SystemEventManager.addEventListener("task2Over",this.onTask2Over);
      }
      
      private function onTask2Over(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(9201,this.getTask2PrizeOver);
         GF.sendSocket(9201,1,9);
      }
      
      private function getTask2PrizeOver(e:SocketEvent) : void
      {
         var state:int = 0;
         var count:int = 0;
         var msg:String = null;
         var itemID:int = 0;
         var i:int = 0;
         var cnt:int = 0;
         GV.onlineSocket.removeCmdListener(9201,this.getTask2PrizeOver);
         var data:ByteArray = e.data as ByteArray;
         if(data != null)
         {
            state = int(data.readUnsignedInt());
            if(state == 1)
            {
               count = int(data.readUnsignedInt());
               msg = "    恭喜你獲得";
               for(i = 0; i < count; i++)
               {
                  itemID = int(data.readUnsignedInt());
                  cnt = int(data.readUnsignedInt());
                  msg += cnt + "個" + GoodsInfo.getItemNameByID(itemID);
                  if(i < count - 1)
                  {
                     msg += ",";
                  }
               }
               msg += "!";
               Alert.smileAlart(msg);
               LoginShared.getCurMoleDate().data.moleKingDay = ServerUpTime.getInstance().date.date;
            }
            else
            {
               Alert.smileAlart("    你今天已經站過崗了，明天再來吧！");
            }
         }
      }
      
      private function moleKingStep50(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep50",this.moleKingStep50);
         GV.MC_mapFrame["control_mc"].yorick.visible = false;
         GV.MAN_PEOPLE.visible = false;
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie0.swf",null,null,this.playMovieOver2);
      }
      
      private function playMovieOver2() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(10));
         SystemEventManager.addEventListener("moleKingStep51",this.moleKingStep51);
      }
      
      private function moleKingStep51(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep51",this.moleKingStep51);
         GV.MC_mapFrame["control_mc"].yorick.visible = false;
         GV.MAN_PEOPLE.visible = false;
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie1.swf",null,null,this.playMovieOver3);
      }
      
      private function playMovieOver3() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         GV.MC_mapFrame["control_mc"].yorick.visible = true;
         GV.MAN_PEOPLE.visible = true;
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(12));
         SystemEventManager.addEventListener("moleKingStep52",this.moleKingStep52);
      }
      
      private function moleKingStep52(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep52",this.moleKingStep52);
         GF.sendSocket(9201,1,6);
         this.curStep = 6;
      }
      
      private function getHitTestInfo(e:EventTaomee) : void
      {
         if(e.EventObj.mc.userID == LocalUserInfo.getUserID())
         {
            if(this.treeState < 5)
            {
               ++this.treeState;
            }
            if(this.treeState == 5)
            {
               BC.removeEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
               GV.MC_mapFrame["control_mc"].tree.buttonMode = true;
               GV.MC_mapFrame["control_mc"].tree.gotoAndStop(2);
               BC.addEvent(this,GV.MC_mapFrame["control_mc"].tree,MouseEvent.CLICK,this.goMap354);
               GF.sendSocket(9201,1,4);
               this.curStep = 4;
            }
         }
      }
      
      private function goMap354(e:MouseEvent) : void
      {
         MapManager.enterMap(354);
      }
      
      private function moleKingAct(e:SystemEvent) : void
      {
         if(this.curStep == 1)
         {
            SystemEventManager.addEventListener("moleKingStep2",this.moleKingStep2);
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(10));
         }
         else
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(14));
         }
      }
      
      private function step2Talk(e:SystemEvent) : void
      {
         if(this.curStep == 2)
         {
            SystemEventManager.addEventListener("moleKingStep3",this.moleKingStep3);
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(2));
         }
         else
         {
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(4));
         }
      }
      
      private function moleKingStep3(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep3",this.moleKingStep3);
         GF.sendSocket(9201,1,3);
         this.curStep = 3;
      }
      
      private function moleKingStep2(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep2",this.moleKingStep2);
         GV.onlineSocket.addCmdListener(9201,this.getTaskPrize);
         GF.sendSocket(9201,1,2);
         this.curStep = 2;
      }
      
      private function moleKingStep40(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep40",this.moleKingStep40);
         GV.MC_mapFrame["control_mc"].yorick.visible = false;
         GV.MAN_PEOPLE.visible = false;
         this._movie = PlayMovie.play("module/external/exeModule/201311/moleKingMovie0.swf",null,null,this.playMovieOver);
      }
      
      private function playMovieOver() : void
      {
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         GV.MAN_PEOPLE.visible = true;
         SystemEventManager.addEventListener("moleKingStep41",this.moleKingStep41);
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(6));
      }
      
      private function moleKingStep41(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("moleKingStep41",this.moleKingStep41);
         GV.onlineSocket.addCmdListener(9201,this.getTaskPrize);
         GF.sendSocket(9201,1,5);
         this.curStep = 5;
      }
      
      private function getTaskPrize(e:SocketEvent) : void
      {
         var state:int = 0;
         var count:int = 0;
         var msg:String = null;
         var itemID:int = 0;
         var i:int = 0;
         var cnt:int = 0;
         GV.onlineSocket.removeCmdListener(9201,this.getTaskPrize);
         var data:ByteArray = e.data as ByteArray;
         if(data != null)
         {
            state = int(data.readUnsignedInt());
            if(state == 1)
            {
               count = int(data.readUnsignedInt());
               if(count == 6)
               {
                  StatisticsClass.getInstance().init(67750849);
               }
               msg = "    恭喜你獲得";
               for(i = 0; i < count; i++)
               {
                  itemID = int(data.readUnsignedInt());
                  cnt = int(data.readUnsignedInt());
                  msg += cnt + "個" + GoodsInfo.getItemNameByID(itemID);
                  if(i < count - 1)
                  {
                     msg += ",";
                  }
               }
               msg += "!";
               Alert.smileAlart(msg);
               LoginShared.getCurMoleDate().data.moleKingDay = ServerUpTime.getInstance().date.date;
            }
         }
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(9200,this.getStepOver);
         SystemEventManager.removeEventListener("moleKingAct",this.moleKingAct);
         SystemEventManager.removeEventListener("moleKingStep3",this.moleKingStep3);
         SystemEventManager.removeEventListener("moleKingStep2",this.moleKingStep2);
         SystemEventManager.removeEventListener("moleKingStep40",this.moleKingStep40);
         SystemEventManager.removeEventListener("moleKingStep41",this.moleKingStep41);
         SystemEventManager.removeEventListener("moleKingStep50",this.moleKingStep50);
         SystemEventManager.removeEventListener("moleKingStep51",this.moleKingStep51);
         SystemEventManager.removeEventListener("moleKingStep52",this.moleKingStep52);
         SystemEventManager.removeEventListener("moleKingStep60",this.moleKingStep60);
         SystemEventManager.removeEventListener("helpEvent",this.onHelpEvent);
         SystemEventManager.removeEventListener("helpTask0Over",this.helpTask0Over);
         SystemEventManager.removeEventListener("mokeKingTask2Event",this.mokeKingTask2Event);
         SystemEventManager.removeEventListener("task2Over",this.onTask2Over);
         GV.onlineSocket.removeCmdListener(9201,this.getTask1PrizeOver);
         GV.onlineSocket.removeCmdListener(9201,this.getTaskPrize);
         this.overFunc = null;
         if(this._movie != null)
         {
            this._movie.destroy();
            this._movie = null;
         }
         var i:int = 0;
         for(i = 0; i < 3; i++)
         {
            SystemEventManager.removeEventListener("helpEventTask0" + i,this.helpEventTask0);
         }
         this.treeState = 0;
      }
   }
}

