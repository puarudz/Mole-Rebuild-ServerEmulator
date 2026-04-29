package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.util.DisplayUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.utils.Tool;
   import com.view.MapManageView.MapManageView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.net.SocketEvent;
   
   public class MoonActy
   {
      
      private static var _inst:MoonActy;
      
      private var mapArr:Array = [239,238,53,109,84,331,32,237,237];
      
      private var mapIndex:int;
      
      private var cakeNumArr:Array = [15,20,20,25,15,25,15,25,15];
      
      private var timer:uint;
      
      private var toMapArr:Array = [112,240,68,42,8];
      
      private var ptArr:Array = [new Point(101,352),new Point(92,332),new Point(427,174),new Point(833,277),new Point(477,280)];
      
      private var toMapIndex:int;
      
      public function MoonActy()
      {
         super();
      }
      
      public static function get inst() : MoonActy
      {
         if(_inst == null)
         {
            _inst = new MoonActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         BC.addEvent(this,GV.onlineSocket,MapEvent.CHANGE_MAP_COMPLETE,this.onEnterMap);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onLeaveMap(e:*) : void
      {
         this.destroy();
      }
      
      private function onEnterMap(e:*) : void
      {
         this.initMototo();
         this.initOnlineMoon();
         this.initNpcTalkEvent();
      }
      
      private function initNpcTalkEvent() : void
      {
         var i:int = 0;
         var mapID:int = LocalUserInfo.getMapID();
         for(i = 0; i < this.mapArr.length; i++)
         {
            if(mapID == this.mapArr[i])
            {
               this.mapIndex = i;
               if(mapID != 237)
               {
                  SystemEventManager.addEventListener("getMoonCakePrize",this.getMoonCakePrize);
               }
               else
               {
                  SystemEventManager.addEventListener("getMoonCakePrize0",this.getMoonCakePrize0);
                  SystemEventManager.addEventListener("getMoonCakePrize1",this.getMoonCakePrize1);
               }
               break;
            }
         }
      }
      
      public function destroy() : void
      {
         clearInterval(this.timer);
         this.mapIndex = -1;
         this.toMapIndex = -1;
         SystemEventManager.removeEventListener("getMoonCakePrize",this.getMoonCakePrize);
         SystemEventManager.removeEventListener("getMoonCakePrize0",this.getMoonCakePrize0);
         SystemEventManager.removeEventListener("getMoonCakePrize1",this.getMoonCakePrize1);
      }
      
      private function getMoonCakePrize(e:SystemEvent) : void
      {
         Tool.finishSomething(2100000319 + this.mapIndex,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               checkEnoughCake(function():void
               {
                  SystemEventManager.addEventListener("getPrize",getPrize);
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(122));
               });
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(123));
            }
         });
      }
      
      private function getPrize(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("getPrize",this.getPrize);
         Tool.exchangeGoods(2846 + this.mapIndex);
      }
      
      private function checkEnoughCake(overFunc:Function) : void
      {
         var checkOver:Function = null;
         checkOver = function(e:EventTaomee):void
         {
            GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,checkOver);
            var arr:Array = e.EventObj.obj.arr;
            var len:int = int(arr.length);
            if(len > 0 && arr[0].Count >= cakeNumArr[mapIndex])
            {
               overFunc.apply();
            }
            else
            {
               Alert.smileAlart("    你沒有足夠的月餅喲！");
            }
         };
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,checkOver);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),16022,2);
      }
      
      private function getPrize0(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("getPrize0",this.getPrize0);
         this.mapIndex = 7;
         this.checkEnoughCake(function():void
         {
            Tool.exchangeGoods(2853);
         });
      }
      
      private function getPrize1(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("getPrize1",this.getPrize1);
         this.mapIndex = 8;
         Tool.exchangeGoods(2854);
      }
      
      private function getMoonCakePrize0(e:SystemEvent) : void
      {
         Tool.finishSomething(2100000326,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               checkEnoughCake(function():void
               {
                  SystemEventManager.addEventListener("getPrize",getPrize0);
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(122));
               });
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(123));
            }
         });
      }
      
      private function getMoonCakePrize1(e:SystemEvent) : void
      {
         Tool.finishSomething(2100000327,function(doneTimes:int):void
         {
            if(doneTimes == 0)
            {
               checkEnoughCake(function():void
               {
                  SystemEventManager.addEventListener("getPrize",getPrize1);
                  NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(222));
               });
            }
            else
            {
               NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(223));
            }
         });
      }
      
      private function initOnlineMoon() : void
      {
         var day:int = ServerUpTime.getInstance().date.date;
         var hour:int = ServerUpTime.getInstance().getMoleHours % 24;
         if((hour == 19 || hour == 13) && (day >= 27 && day <= 29))
         {
            this.timer = setInterval(this.tick,1000);
         }
      }
      
      private function tick() : void
      {
         var hour:int = ServerUpTime.getInstance().getMoleHours % 24;
         var min:int = ServerUpTime.getInstance().date.minutes;
         var sec:int = ServerUpTime.getInstance().date.seconds;
         if((hour == 19 || hour == 13) && min % 5 == 0 && sec == 30)
         {
            GV.onlineSocket.addCmdListener(8935,this.getPrizeOver);
            GF.sendSocket(8935);
         }
         else if(hour != 19 && hour != 13)
         {
            clearInterval(this.timer);
         }
      }
      
      private function getPrizeOver(e:SocketEvent) : void
      {
         var itemID:int = 0;
         var count:int = 0;
         GV.onlineSocket.removeCmdListener(8935,this.getPrizeOver);
         var data:ByteArray = e.data as ByteArray;
         if(Boolean(data))
         {
            data.position = 0;
            itemID = int(data.readUnsignedInt());
            count = int(data.readUnsignedInt());
         }
      }
      
      private function initMototo() : void
      {
         var i:int = 0;
         var mapID:int = LocalUserInfo.getMapID();
         for(i = 0; i < this.toMapArr.length; i++)
         {
            if(mapID == this.toMapArr[i])
            {
               this.toMapIndex = i;
               Tool.finishSomething(31597 + i,this.getDoneTimesOver);
            }
         }
      }
      
      private function getDoneTimesOver(doneTimes:int) : void
      {
         var resID:int = 0;
         if(this.toMapIndex >= 0 && doneTimes == 0)
         {
            resID = int(DownLoadManager.add("module/external/exeModule/mototo.swf",ResType.DISPLAY_OBJECT));
            DownLoadManager.addEvent(resID,this.loadMototoOver);
         }
      }
      
      private function loadMototoOver(e:DownLoadEvent) : void
      {
         var data:MovieClip = null;
         data = e.data as MovieClip;
         data.buttonMode = true;
         if(this.toMapIndex >= 0)
         {
            data.x = this.ptArr[this.toMapIndex].x;
            data.y = this.ptArr[this.toMapIndex].y;
         }
         GV.MC_mapFrame["top_mc"].addChild(data);
         BC.addEvent(this,data,MouseEvent.CLICK,function():void
         {
            Tool.exchangeGoods(2841 + toMapIndex);
            DisplayUtil.removeForParent(data);
         });
      }
   }
}

