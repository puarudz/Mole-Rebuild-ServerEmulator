package com.mole.app.manager
{
   import com.common.util.BitArray;
   import com.event.EventTaomee;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.module.activityModule.Presented;
   import com.module.newHouse.newHouseView;
   
   public class HouseManager
   {
      
      public function HouseManager()
      {
         super();
      }
      
      public static function getAward() : void
      {
         if(newHouseView.isMyHouse)
         {
            NpcBallotSocket.NpcBallotReq();
            GV.onlineSocket.addEventListener("read_" + 2008,onCheckFlag);
         }
      }
      
      private static function onCheckFlag(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 2008,onCheckFlag);
         var bits:BitArray = e.EventObj.data;
         if(bits.getBitAt(199) == false)
         {
            Presented.getInstance().celebrate1225(996);
         }
      }
   }
}

