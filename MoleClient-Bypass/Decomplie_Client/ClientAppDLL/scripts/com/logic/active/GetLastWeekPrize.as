package com.logic.active
{
   import com.common.Alert.Alert;
   import com.global.staticData.CommandID;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class GetLastWeekPrize
   {
      
      private static var _inst:GetLastWeekPrize;
      
      private var type:int = 6;
      
      public function GetLastWeekPrize()
      {
         super();
      }
      
      public static function get inst() : GetLastWeekPrize
      {
         if(_inst == null)
         {
            _inst = new GetLastWeekPrize();
         }
         return _inst;
      }
      
      public function init() : void
      {
         this.getPrize(this.type);
      }
      
      private function getPrize(type:int) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.GARDON_RANK_PRIZE,this.getPrizeOver);
         GF.sendSocket(CommandID.GARDON_RANK_PRIZE,type);
      }
      
      private function getPrizeOver(e:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GARDON_RANK_PRIZE,this.getPrizeOver);
         var bArr:ByteArray = e.data as ByteArray;
         var type:int = int(bArr.readUnsignedInt());
         var count:int = int(bArr.readUnsignedInt());
         if(count > 0)
         {
            if(type == 6)
            {
               Alert.smileAlart("    為了表彰小摩爾付出的的辛勤努力並進入了前100名，特別贈送抹茶團子髮型*1");
            }
            else if(type == 7)
            {
               Alert.smileAlart("    小摩爾的後勤工作做得太棒了，累積捐獻800木材，特別贈送藍莓團子髮型*1");
            }
         }
         type++;
         if(type < 8)
         {
            this.getPrize(type);
         }
      }
   }
}

