package com.module.LocusWork
{
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CollectProp
   {
      
      public static const GET_PROP:String = "get_prop";
      
      private var mc:MovieClip;
      
      private var timer:Timer;
      
      private var count:int;
      
      private var time:int;
      
      private var brokenFrame:int = 1;
      
      public function CollectProp(mc:MovieClip, time:int = 30, brokenFrame:int = 1)
      {
         super();
         this.mc = mc;
         this.brokenFrame = brokenFrame;
         mc.colorObj = GV.MAN_PEOPLE.colorObj;
         mc.gotoAndStop(1);
         this.time = time;
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         GV.onlineSocket.addEventListener("POLICE_DUTY_EVENT",this.onDuty);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      public function get content() : MovieClip
      {
         return this.mc;
      }
      
      private function onDuty(e:EventTaomee) : void
      {
         if(e.EventObj.mc.name.indexOf(this.mc.name) == -1)
         {
            return;
         }
         if(!GV.JobLogics.chartbagClothFun([[13310,13311,13312,13313],[13311,13312,13313,13368]]))
         {
            GF.showAlert(GV.MC_AppLever,"幫助莊園建設只能穿上一套建築師套裝哦！趕快打開百寶箱穿齊吧！","",100,"iknow",true,false,"E");
            return;
         }
         if(e.EventObj.mc.name.indexOf(this.mc.name) != -1)
         {
            this.startWork();
         }
      }
      
      public function startWork() : void
      {
         this.mc.gotoAndStop(2);
         this.count = 0;
         this.timer.start();
         this.setPeople(false);
         GV.MAN_PEOPLE.addEventListener("onGoStart",this.stageClick);
      }
      
      private function stageClick(e:Event) : void
      {
         this.stopWork();
      }
      
      private function setPeople(flag:Boolean) : void
      {
         if(GV.MAN_PEOPLE == null)
         {
            return;
         }
         GV.MAN_PEOPLE.visible = flag;
         GV.MAN_PEOPLE.hitBtn.visible = flag;
         if(Boolean(GV.MAN_PEOPLE.pet_hitBtn))
         {
            GV.MAN_PEOPLE.pet_hitBtn.visible = flag;
         }
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         ++this.count;
         if(this.count >= this.time)
         {
            this.finishWork();
            this.getProp();
         }
      }
      
      public function getProp() : void
      {
         GV.onlineSocket.dispatchEvent(new Event(GET_PROP));
      }
      
      public function stopWork() : void
      {
         this.timer.stop();
         this.mc.gotoAndStop(this.brokenFrame);
         this.setPeople(true);
         GV.MAN_PEOPLE.removeEventListener("onGoStart",this.stageClick);
      }
      
      public function finishWork() : void
      {
         this.timer.stop();
         this.mc.gotoAndStop(3);
         this.setPeople(true);
         GV.MAN_PEOPLE.removeEventListener("onGoStart",this.stageClick);
      }
      
      public function clean() : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         GV.MAN_PEOPLE.removeEventListener("onGoStart",this.stageClick);
         GV.onlineSocket.removeEventListener("POLICE_DUTY_EVENT",this.onDuty);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      public function removeEventHandler(E:*) : void
      {
         this.clean();
      }
   }
}

