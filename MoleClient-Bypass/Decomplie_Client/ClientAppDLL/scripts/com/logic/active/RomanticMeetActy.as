package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.type.ActionType;
   import com.mole.app.utils.PlayMovie;
   import com.mole.app.utils.Tool;
   import com.view.MapManageView.MapButtonView;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class RomanticMeetActy
   {
      
      private static var _inst:RomanticMeetActy;
      
      private var xmlObj:Object = {};
      
      private var mapArr:Array;
      
      private var npcArr:Array;
      
      private var mapList:Array = [330,8,41,6,59,240,80];
      
      private var npcIDArr:Array = [10009,10013,10050,10012,10173,10015,10114,10125,10045,10007,10156,10192,10003,10188,10010,10000,10011,10118,10119,10199,10196];
      
      private var pos0:Array;
      
      private var pos1:Array;
      
      private var brandPos:Array;
      
      private var itemID:int;
      
      private var itemCnt:int;
      
      private var npcID:int;
      
      private var seatIndex:int;
      
      private var movie:PlayMovie;
      
      private var brandBtn:DisplayObject;
      
      private var optionSelect:int;
      
      private var talks:Array;
      
      private var talkIndex:int;
      
      private var talkLen:int;
      
      private var romanticMc:MovieClip;
      
      public function RomanticMeetActy()
      {
         super();
      }
      
      public static function get inst() : RomanticMeetActy
      {
         if(_inst == null)
         {
            _inst = new RomanticMeetActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         Tool.loadAndHandleXML("resource/xml/activity20130524.xml",this.xmlObj,this.loadXmlOver);
      }
      
      private function loadXmlOver() : void
      {
         this.mapArr = this.xmlObj.maps.map;
         this.npcArr = this.xmlObj.npclist.npc;
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         GV.onlineSocket.addEventListener(MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
      }
      
      private function onEnterMap(e:EventTaomee) : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
         var mapid:int = LocalUserInfo.getMapID();
         var len:int = int(this.mapArr.length);
         for(var i:int = 0; i < len; i++)
         {
            if(mapid == this.mapArr[i].id)
            {
               this.pos0 = this.mapArr[i].pos0.split(",");
               this.pos1 = this.mapArr[i].pos1.split(",");
               this.brandPos = this.mapArr[i].brandPos.split(",");
               this.brandBtn = MapButtonView.regeditEvent(GV.MC_mapFrame["depth_mc"].brandBtn,this.onClickBrand);
               BC.addEvent(this,GV.MC_mapFrame["control_mc"].posBtn0,MouseEvent.CLICK,this.onClickPosBtn0);
               BC.addEvent(this,GV.MC_mapFrame["control_mc"].posBtn1,MouseEvent.CLICK,this.onClickPosBtn1);
               break;
            }
         }
      }
      
      private function visibleBtns() : void
      {
         GV.MC_mapFrame["control_mc"].posBtn0.visible = true;
         GV.MC_mapFrame["control_mc"].posBtn1.visible = true;
         GV.MC_mapFrame["depth_mc"].brandBtn.visible = true;
      }
      
      private function unvisibleBtns() : void
      {
         GV.MC_mapFrame["control_mc"].posBtn0.visible = false;
         GV.MC_mapFrame["control_mc"].posBtn1.visible = false;
         GV.MC_mapFrame["depth_mc"].brandBtn.visible = false;
      }
      
      private function onClickPosBtn0(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goSeatOver);
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.pos0[0],this.pos0[1]);
      }
      
      private function onClickPosBtn1(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goSeatOver);
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.pos1[0],this.pos1[1]);
      }
      
      private function goSeatOver(e:Event) : void
      {
         if(GV.MAN_PEOPLE.x == this.pos0[0] && GV.MAN_PEOPLE.y == this.pos0[1])
         {
            this.seatIndex = 0;
            this.seat(0);
         }
         else if(GV.MAN_PEOPLE.x == this.pos1[0] && GV.MAN_PEOPLE.y == this.pos1[1])
         {
            this.seatIndex = 1;
            this.seat(1);
         }
      }
      
      private function seat(index:*) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.ROMANTIC_MEET_SEAT,this.onSeatOver);
         GF.sendSocket(CommandID.ROMANTIC_MEET_SEAT,index,this.mapList.indexOf(LocalUserInfo.getMapID()) + 1);
      }
      
      private function onSeatOver(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.ROMANTIC_MEET_SEAT,this.onSeatOver);
         var data:ByteArray = e.data as ByteArray;
         var state:int = int(data.readUnsignedInt());
         this.npcID = data.readUnsignedInt();
         this.itemID = data.readUnsignedInt();
         this.itemCnt = data.readUnsignedInt();
         if(state == 0)
         {
            this.unvisibleBtns();
            this.playMovie();
         }
         else if(state == 1)
         {
            Alert.smileAlart("    浪漫的邂逅是需要耐心等待的！邂逅5次後，要等待3分鐘才能繼續哦！");
         }
         else if(state == 2)
         {
            Alert.smileAlart("    一天只能獲得100次哦");
         }
      }
      
      private function playMovie() : void
      {
         var resID:int = 0;
         if(Boolean(this.movie))
         {
            this.movie.destroy();
         }
         if(this.npcID != 0)
         {
            this.movie = PlayMovie.play("resource/movie/romantickMovie0.swf",this.loadSucMovieOver,null,null,null,MainManager.getAppLevel(),true);
         }
         else
         {
            resID = int(DownLoadManager.add("resource/movie/romantickMovie1.swf",ResType.DISPLAY_OBJECT));
            DownLoadManager.addEvent(resID,this.loadFaiMovieOver);
         }
      }
      
      private function loadFaiMovieOver(e:DownLoadEvent) : void
      {
         var tFunc:Function;
         var mc:MovieClip = null;
         var failEndFunc:Function = null;
         failEndFunc = function():void
         {
            visibleBtns();
            DisplayUtil.removeForParent(mc);
            mc = null;
            var peoPleMC:PeopleManageView = PeopleManageView(GF.getPeopleByID(LocalUserInfo.getUserID()));
            if(Boolean(peoPleMC))
            {
               peoPleMC.visible = true;
            }
         };
         PeopleManageView(GV.MAN_PEOPLE).visible = false;
         mc = e.data as MovieClip;
         MainManager.getAppLevel().addChild(mc);
         tFunc = function():void
         {
            var tempMc:MovieClip = mc.getChildAt(0) as MovieClip;
            tempMc.x = pos0[0] - 100;
            tempMc.y = pos0[1] - 110;
            tempMc.play();
            MovieClipUtil.playEndAndFunc(tempMc,failEndFunc);
         };
         MovieClipUtil.playAppointFrameAndFunc(mc,2 - this.seatIndex,tFunc);
      }
      
      private function loadSucMovieOver() : void
      {
         var index:int;
         var tFunc:Function;
         PeopleManageView(GV.MAN_PEOPLE).visible = false;
         index = this.npcIDArr.indexOf(this.npcID);
         tFunc = function():void
         {
            var tempFunc:Function;
            var mc:MovieClip = null;
            mc = movie.movie_mc.getChildAt(1) as MovieClip;
            mc.x = pos0[0] - 100;
            mc.y = pos0[1] - 110;
            tempFunc = function():void
            {
               mc.stop();
               talk();
            };
            MovieClipUtil.playEndAndFunc(mc,tempFunc);
         };
         MovieClipUtil.playAppointFrameAndFunc(this.movie.movie_mc,index + 1,tFunc);
      }
      
      private function onClickBrand(e:MouseEvent) : void
      {
         BC.addEvent(this,GV.MAN_PEOPLE,PeopleManageView.ON_GO_OVER,this.goBrandOver);
         PeopleManageView(GV.MAN_PEOPLE).moveTo(this.brandPos[0],this.brandPos[1]);
      }
      
      private function selectOpEvent0(e:SystemEvent) : void
      {
         this.optionSelect = 0;
         this.nextTalkFunc();
      }
      
      private function selectOpEvent1(e:SystemEvent) : void
      {
         this.optionSelect = 1;
         this.nextTalkFunc();
      }
      
      private function selectOpEvent2(e:SystemEvent) : void
      {
         this.optionSelect = 2;
         this.nextTalkFunc();
      }
      
      private function talk() : void
      {
         var npcInfo:Object = null;
         for each(npcInfo in this.npcArr)
         {
            if(this.npcID == npcInfo.id)
            {
               this.talks = npcInfo.msg.talk;
               break;
            }
         }
         SystemEventManager.addEventListener("selectOpEvent0",this.selectOpEvent0);
         SystemEventManager.addEventListener("selectOpEvent1",this.selectOpEvent1);
         SystemEventManager.addEventListener("selectOpEvent2",this.selectOpEvent2);
         this.talkIndex = 0;
         this.talkLen = this.talks.length;
         this.nextTalkFunc.apply();
      }
      
      private function nextTalkFunc() : void
      {
         var info:NPCDialogInfo = null;
         var opInfo:NPCDialogOptionInfo = null;
         var optionArr:Array = this.talks[this.talkIndex + 1].msg.split("$");
         var sayList:Array = [];
         for(var i:int = 0; i < optionArr.length; i++)
         {
            if(optionArr[i] != "")
            {
               if(this.talkIndex + 2 < this.talkLen && this.talks[this.talkIndex + 2].msg.split("$")[i] != "")
               {
                  if(this.talkIndex != 0)
                  {
                     opInfo = new NPCDialogOptionInfo(optionArr[i],ActionType.FUNCTION,this.nextTalkFunc);
                  }
                  else
                  {
                     opInfo = new NPCDialogOptionInfo(optionArr[i],ActionType.SYSTEM_ACT,"selectOpEvent" + i);
                  }
               }
               else
               {
                  opInfo = new NPCDialogOptionInfo(optionArr[i],ActionType.FUNCTION,this.endTalkFunc);
               }
               if(this.talkIndex == 0 || this.talkIndex != 0 && i == this.optionSelect)
               {
                  sayList.push(opInfo);
               }
            }
         }
         if(this.talkIndex == 0)
         {
            info = new NPCDialogInfo(this.npcID,"正常",this.talks[this.talkIndex].msg,sayList,true);
         }
         else
         {
            info = new NPCDialogInfo(this.npcID,"正常",this.talks[this.talkIndex].msg.split("$")[this.optionSelect],sayList,true);
         }
         NPCDialogManager.say(info);
         this.talkIndex += 2;
      }
      
      private function endTalkFunc() : void
      {
         NPCDialogManager.destroyDialog();
         if(Boolean(this.movie))
         {
            this.movie.destroy();
         }
         var resID:int = int(DownLoadManager.add("resource/movie/romantickMovie2.swf",ResType.DISPLAY_OBJECT));
         DownLoadManager.addEvent(resID,this.loadEndMovieOver);
      }
      
      private function loadEndMovieOver(e:DownLoadEvent) : void
      {
         var tFunc:Function;
         var romanticMc:MovieClip = null;
         var endFunc:Function = null;
         endFunc = function():void
         {
            visibleBtns();
            DisplayUtil.removeForParent(romanticMc);
            if(Boolean(movie))
            {
               movie.destroy();
            }
            var peoPleMC:PeopleManageView = PeopleManageView(GF.getPeopleByID(LocalUserInfo.getUserID()));
            if(Boolean(peoPleMC))
            {
               peoPleMC.visible = true;
            }
            if(itemCnt > 0)
            {
               Tool.alert(itemID,itemCnt);
            }
         };
         romanticMc = e.data as MovieClip;
         MainManager.getAppLevel().addChild(romanticMc);
         tFunc = function():void
         {
            var tempMc:MovieClip = romanticMc.getChildAt(0) as MovieClip;
            tempMc.x = pos0[0] - 100;
            tempMc.y = pos0[1] - 110;
            tempMc.play();
            MovieClipUtil.playEndAndFunc(tempMc,endFunc);
         };
         MovieClipUtil.playAppointFrameAndFunc(romanticMc,2 - this.seatIndex,tFunc);
      }
      
      private function goBrandOver(e:Event) : void
      {
         if(GV.MAN_PEOPLE.x == this.brandPos[0] && GV.MAN_PEOPLE.y == this.brandPos[1])
         {
            ModuleManager.openPanel("RomanticMeetIntroPanel");
         }
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         SystemEventManager.removeEventListener("selectOpEvent0",this.selectOpEvent0);
         SystemEventManager.removeEventListener("selectOpEvent1",this.selectOpEvent1);
         SystemEventManager.removeEventListener("selectOpEvent2",this.selectOpEvent2);
         if(Boolean(this.brandBtn))
         {
            MapButtonView.removeEvent(this.brandBtn);
         }
         this.brandBtn = null;
         this.npcID = 0;
         this.itemID = 0;
         this.itemCnt = 0;
         if(Boolean(this.movie))
         {
            this.movie.destroy();
            this.movie = null;
         }
         DisplayUtil.removeForParent(this.romanticMc);
         this.romanticMc = null;
         this.xmlObj = null;
      }
   }
}

