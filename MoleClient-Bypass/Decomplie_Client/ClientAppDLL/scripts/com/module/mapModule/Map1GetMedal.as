package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.raceSport.RaceSportJoin;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Map1GetMedal extends Sprite
   {
      
      public var target_mc:MovieClip;
      
      private var score_num:uint = 0;
      
      public function Map1GetMedal()
      {
         super();
         this.target_mc = GV.MC_mapFrame["control_mc"];
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventFun);
         BC.addEvent(this,this.target_mc.medal_btn,MouseEvent.CLICK,this.chartMedal);
      }
      
      private function chartMedal(eve:MouseEvent) : void
      {
         var msg:String = null;
         if(LocalUserInfo.getTeam() == 0)
         {
            msg = "你還沒有報名炫風拉力賽哦。每天如果贏得超過100積分的話，就能來領取特別貢獻獎章哦！";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            return;
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + 1559,this.getScoreFun);
         RaceSportJoin.getDayScore();
      }
      
      private function getScoreFun(eve:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1559,this.getScoreFun);
         this.score_num = eve.EventObj.DayScore;
         if(this.score_num < 100)
         {
            msg = "    今天你已贏得了" + this.score_num + "點積分。加油，超過100積分就能來領取特別貢獻獎章了！";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            return;
         }
         if(this.score_num >= 100)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1563,this.getMedalFun);
            BC.addEvent(this,GV.onlineSocket,"back_100058_errorID",this.errorFun);
            RaceSportJoin.getIntegralItem();
         }
      }
      
      private function getMedalFun(eve:EventTaomee) : void
      {
         var ID:uint = uint(eve.EventObj.Itemid);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1563,this.getMedalFun);
         BC.removeEvent(this,GV.onlineSocket,"back_100058_errorID",this.errorFun);
         var msg:String = "    今天你已贏得了" + this.score_num + "點積分，感謝你為團隊做出的努力，特別貢獻獎章已經放到你的倉庫中了。明天也要加油哦！";
         Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      private function errorFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1563,this.getMedalFun);
         BC.removeEvent(this,GV.onlineSocket,"back_100058_errorID",this.errorFun);
         var msg:String = "    今天你已贏得了特別貢獻獎章了。明天也要加油哦！";
         Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      private function removeEventFun(eve:* = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventFun);
         BC.removeEvent(this);
      }
   }
}

