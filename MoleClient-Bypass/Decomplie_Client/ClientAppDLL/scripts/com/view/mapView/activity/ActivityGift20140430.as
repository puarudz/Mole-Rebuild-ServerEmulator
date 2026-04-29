package com.view.mapView.activity
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.NPCDialogManager;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.view.MapManageView.MapManageView;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class ActivityGift20140430
   {
      
      private var _arr:Array = [239,237,149,3,20,52,1,360,53,15,32,109];
      
      private var _bln:Boolean = false;
      
      public function ActivityGift20140430()
      {
         super();
         if(LocalUserInfo.getMapID() == 20)
         {
            return;
         }
         SystemEventManager.addEventListener("ComeGetGift",this.getTimeBln);
         SystemEventManager.addEventListener("socketGetItem",this.socketGetItem);
      }
      
      public function socketGetItem(e:SystemEvent = null) : void
      {
         GV.onlineSocket.addCmdListener(6042,this.back6042);
         GF.sendSocket(6042);
      }
      
      private function back6042(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(6042,this.back6042);
         if(e.headInfo.result < 0)
         {
            Alert.angryAlart("6042返回錯誤碼：" + e.headInfo.result);
            return;
         }
         var date:ByteArray = e.data as ByteArray;
         var flag:uint = date.readUnsignedInt();
         var ids:uint = date.readUnsignedInt();
         var num:uint = date.readUnsignedInt();
         if(flag == 0)
         {
            Alert.smileAlart("恭喜你獲得" + num + "個" + GoodsInfo.getItemNameByID(ids) + "。");
         }
         else if(flag == 1)
         {
            Alert.smileAlart("還沒到活動時間哦！");
         }
         else if(flag == 2 || flag == 3)
         {
            Alert.smileAlart("已經擁有很多了，不能再獲得了哦！");
         }
      }
      
      private function getTimeBln(e:SystemEvent) : void
      {
         var bln:Boolean = this.ComeGetGiftTime();
         if(bln == true)
         {
            GV.onlineSocket.addCmdListener(8755,this.back8755);
            GF.sendSocket(8755,749);
         }
         else
         {
            this.oldSay();
         }
      }
      
      private function back8755(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(8755,this.back8755);
         var date:ByteArray = e.data as ByteArray;
         var flag:uint = date.readUnsignedInt();
         if(flag > 12 || flag < 1)
         {
            flag = 0;
         }
         var _ip:uint = uint(this._arr.indexOf(LocalUserInfo.getMapID()));
         this._bln = false;
         if(flag != _ip + 1)
         {
            this._bln = true;
         }
         else if(_ip >= flag)
         {
            if(_ip > flag)
            {
            }
         }
         if(this._bln == false)
         {
            this.oldSay();
         }
         else
         {
            NewStatisticsManager.send(152 + _ip);
            NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(1111));
         }
      }
      
      private function oldSay() : void
      {
         var id:uint = LocalUserInfo.getMapID();
         var ip:uint = 1;
         if(id == 149)
         {
            ip = 100;
         }
         else
         {
            if(id == 20)
            {
               return;
            }
            if(id == 53)
            {
               ip = 3;
            }
            else if(id == 32)
            {
               ip = 2;
            }
         }
         NPCDialogManager.say(MapManageView.inst.mapControl.getNpcDialogInfo(ip));
      }
      
      public function ComeGetGiftTime() : Boolean
      {
         var mapid:uint = LocalUserInfo.getMapID();
         var ip:int = this._arr.indexOf(mapid);
         if(ip == -1)
         {
            return false;
         }
         var bln:Boolean = false;
         var server:Date = ServerUpTime.getInstance().date;
         if(server.month == 4)
         {
            if(server.date <= 3)
            {
               if(server.hours >= 14 && server.hours < 15)
               {
                  if(server.minutes >= ip * 5 && server.minutes < ip * 5 + 5)
                  {
                     bln = true;
                  }
               }
            }
         }
         return bln;
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeCmdListener(6042,this.back6042);
         GV.onlineSocket.removeCmdListener(8755,this.back8755);
         SystemEventManager.removeEventListener("ComeGetGift",this.getTimeBln);
         SystemEventManager.removeEventListener("socketGetItem",this.socketGetItem);
      }
   }
}

