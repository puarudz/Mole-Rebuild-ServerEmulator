package com.view.mapView.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.SystemEventManager;
   
   public class FathersDayTalk
   {
      
      private var _npc:uint = 1111111111;
      
      private var _map:Array = [53,15,52,18,70,27,56,75,62,44];
      
      private var time:Date;
      
      public function FathersDayTalk()
      {
         super();
      }
      
      public function startBuffer() : void
      {
         this.time = ServerUpTime.getInstance().date;
         if(this.time.date < 21)
         {
            Alert.angryAlart("時間還不到哦！（2014.06.21日、22日，每天19:00-20:00）");
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_DATE,0);
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,0);
            return;
         }
         if(this.time.date > 22)
         {
            Alert.angryAlart("活動已經結束了哦！");
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_DATE,0);
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,0);
            return;
         }
         this._npc = 1111111111;
         BufferManager.addBufferEvent(BufferManager.FATHERSDAY_TALK_DATE,this.onCheckgame);
         BufferManager.getBuffer(BufferManager.FATHERSDAY_TALK_DATE);
      }
      
      private function onCheckgame(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.FATHERSDAY_TALK_DATE,this.onCheckgame);
         var num:uint = uint(e.EventObj);
         if(num == 0)
         {
            if(this.time.date == 21 || this.time.date == 22)
            {
               if(this.time.hours == 19)
               {
                  BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_DATE,this.time.date);
                  BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,this._npc);
                  SystemEventManager.dispatchEvent(new SystemEvent("fathersDay_nextSay"));
               }
               else
               {
                  if(this.time.hours < 19)
                  {
                     Alert.angryAlart("時間還不到哦！（2014.06.21日、22日，每天19:00-20:00）");
                     return;
                  }
                  if(this.time.hours > 19)
                  {
                     Alert.angryAlart("活動已經結束了哦！");
                     return;
                  }
               }
            }
            else
            {
               if(this.time.date < 21)
               {
                  Alert.angryAlart("時間還不到哦！（2014.06.21日、22日，每天19:00-20:00）");
                  return;
               }
               if(this.time.date > 22)
               {
                  Alert.angryAlart("活動已經結束了哦！");
                  return;
               }
            }
         }
         else if(num == this.time.date)
         {
            if(this.time.hours == 19)
            {
               BufferManager.addBufferEvent(BufferManager.FATHERSDAY_TALK_INFO,this.onCheckgamet);
               BufferManager.getBuffer(BufferManager.FATHERSDAY_TALK_INFO);
            }
            else
            {
               if(this.time.hours < 19)
               {
                  Alert.angryAlart("時間還不到哦！（2014.06.21日、22日，每天19:00-20:00）");
                  return;
               }
               if(this.time.hours > 19)
               {
                  Alert.angryAlart("活動已經結束了哦！");
                  return;
               }
            }
         }
         else if(num == 21 && this.time.date == 22)
         {
            this._npc = 1111111111;
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_DATE,this.time.date);
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,this._npc);
            if(this.time.hours == 19)
            {
               SystemEventManager.dispatchEvent(new SystemEvent("fathersDay_nextSay"));
            }
            else
            {
               if(this.time.hours < 19)
               {
                  Alert.angryAlart("時間還不到哦！（2014.06.21日、22日，每天19:00-20:00）");
                  return;
               }
               if(this.time.hours > 19)
               {
                  Alert.angryAlart("活動已經結束了哦！");
                  return;
               }
            }
         }
      }
      
      private function onCheckgamet(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.FATHERSDAY_TALK_INFO,this.onCheckgamet);
         var n:uint = uint(e.EventObj);
         if(n == 0)
         {
            this._npc = 1111111111;
            BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,this._npc);
            this.sendEvent();
         }
         else
         {
            this._npc = n;
            this.sendEvent();
         }
      }
      
      private function sendEvent() : void
      {
         var s:String = this._npc.toString();
         var mapip:int = this._map.indexOf(LocalUserInfo.getMapID());
         var n:int = int(s.substr(mapip,1));
         if(n > 1)
         {
            Alert.smileAlart("已經點亮過了哦！");
         }
         else
         {
            SystemEventManager.dispatchEvent(new SystemEvent("fathersDay_nextSay"));
         }
      }
      
      public function setBuffer() : void
      {
         var s:String = this._npc.toString();
         var mapip:int = this._map.indexOf(LocalUserInfo.getMapID());
         var a:String = s.substr(0,mapip);
         var b:String = s.substr(mapip + 1);
         var so:String = a + 2 + b;
         GF.sendSocket(9294,mapip);
         this._npc = int(so);
         BufferManager.setBuffer(BufferManager.FATHERSDAY_TALK_INFO,this._npc);
         this.expFun();
      }
      
      private function expFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         superlamuPartySocket.treasurebowl(222);
      }
      
      private function back1242(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.back1242);
         var infoObj:Object = e.EventObj;
         if(infoObj.type == 222)
         {
            msg = GoodsInfo.getItemNameByID(infoObj.itemId) + "x" + infoObj.count;
            Alert.smileAlart("恭喜你獲得" + msg + "。");
         }
      }
      
      public function destroy() : void
      {
         BufferManager.removeBufferEvent(BufferManager.FATHERSDAY_TALK_DATE,this.onCheckgame);
         BufferManager.removeBufferEvent(BufferManager.FATHERSDAY_TALK_INFO,this.onCheckgamet);
         BC.removeEvent(this);
      }
   }
}

