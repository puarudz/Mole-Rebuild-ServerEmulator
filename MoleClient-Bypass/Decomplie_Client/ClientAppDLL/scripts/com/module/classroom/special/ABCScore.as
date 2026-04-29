package com.module.classroom.special
{
   import com.event.EventTaomee;
   import com.logic.socket.classSystem.DoctorQGSocket;
   
   public class ABCScore
   {
      
      public var goodsMC:Object;
      
      public function ABCScore(mc:Object)
      {
         super();
         this.goodsMC = mc;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.getScore();
      }
      
      public function getScore() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1535,this.ABCScoreSucc);
         DoctorQGSocket.classABCScore();
      }
      
      public function ABCScoreSucc(e:EventTaomee) : void
      {
         this.goodsMC.score_txt.text = e.EventObj.Score;
         GV.onlineSocket.removeEventListener("read_" + 1535,this.ABCScoreSucc);
      }
      
      public function updateScore(e:*) : void
      {
         this.getScore();
      }
      
      public function removeEventHandler(e:*) : void
      {
         BC.removeEvent(this);
      }
   }
}

