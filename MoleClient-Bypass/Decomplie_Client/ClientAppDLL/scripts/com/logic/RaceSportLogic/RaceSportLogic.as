package com.logic.RaceSportLogic
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.raceSport.RaceSportJoin;
   import flash.events.Event;
   
   public class RaceSportLogic
   {
      
      public static var ownScore:uint;
      
      public static var trackNum1:uint;
      
      public static var trackNum2:uint;
      
      public static var trackNum3:uint;
      
      public static var trackNum4:uint;
      
      public static var raceSportLogics:RaceSportLogic;
      
      public static var isGetServerData:Boolean = false;
      
      public function RaceSportLogic()
      {
         super();
      }
      
      public static function getRaceSportLogic() : RaceSportLogic
      {
         if(raceSportLogics == null)
         {
            raceSportLogics = new RaceSportLogic();
         }
         return raceSportLogics;
      }
      
      public function getData() : void
      {
         if(LocalUserInfo.getTeam() > 0)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1553,this.getOwnScoreBack);
            RaceSportJoin.getOwnScore();
         }
      }
      
      private function getOwnScoreBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1553,this.getOwnScoreBack);
         var obj:Object = evt.EventObj;
         ownScore = obj.Score;
         BC.addEvent(this,GV.onlineSocket,"read_" + 1558,this.getTrackNumBack);
         RaceSportJoin.getTrackNum();
      }
      
      private function getTrackNumBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1558,this.getTrackNumBack);
         var obj:Object = evt.EventObj;
         trackNum1 = obj.Track1Num;
         trackNum2 = obj.Track2Num;
         trackNum3 = obj.Track3Num;
         trackNum4 = obj.Track4Num;
         isGetServerData = true;
         GV.onlineSocket.dispatchEvent(new Event("getRaceDataRes"));
      }
   }
}

