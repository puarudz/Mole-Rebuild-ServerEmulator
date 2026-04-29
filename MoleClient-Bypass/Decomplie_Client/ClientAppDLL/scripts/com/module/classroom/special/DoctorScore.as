package com.module.classroom.special
{
   import com.event.EventTaomee;
   import com.logic.socket.classSystem.DoctorQGSocket;
   import com.module.classroom.ClassroomView;
   
   public class DoctorScore
   {
      
      public var goodsMC:Object;
      
      public function DoctorScore(mc:Object)
      {
         super();
         this.goodsMC = mc;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,"DashuGuaiResultBack",this.updateScore);
         this.getScore();
      }
      
      public function getScore() : void
      {
         GV.onlineSocket.addEventListener("read_" + 5403,this.DoctorScoreSucc);
         DoctorQGSocket.doctor_seeStartQG(ClassroomView.hostID);
      }
      
      public function DoctorScoreSucc(e:EventTaomee) : void
      {
         this.goodsMC.score_txt.text = e.EventObj.Score;
         GV.onlineSocket.removeEventListener("read_" + 5403,this.DoctorScoreSucc);
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

