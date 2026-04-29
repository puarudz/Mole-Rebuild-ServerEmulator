package com.logic.RaceSportLogic
{
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.view.mapView.activity.creatShareObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DeliverPumpkinLogic extends EventDispatcher
   {
      
      public static var currentDay:int;
      
      public static var jobCount:int;
      
      public static var DeliverPumpkinLogics:DeliverPumpkinLogic;
      
      public static var isDoJob:Boolean = false;
      
      public static var hasGetTime:Boolean = false;
      
      private var nowdate:Date;
      
      public function DeliverPumpkinLogic()
      {
         super();
      }
      
      public static function getDeliverPumpkinLogic() : DeliverPumpkinLogic
      {
         if(DeliverPumpkinLogics == null)
         {
            DeliverPumpkinLogics = new DeliverPumpkinLogic();
         }
         return DeliverPumpkinLogics;
      }
      
      public function getCurrentDay() : void
      {
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.NOWTIMES,this.getTimeBack);
         JobExpandLogic.getJobExpand().getServerTime();
      }
      
      private function getTimeBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.NOWTIMES,this.getTimeBack);
         this.nowdate = new Date(evt.EventObj.obj);
         if(this.nowdate.getDate() != creatShareObject.getInstance().getCurrentDay())
         {
            creatShareObject.getInstance().setCurrentDay(this.nowdate.getDate());
            jobCount = 0;
            creatShareObject.getInstance().setJobCount(0);
         }
         else
         {
            jobCount = creatShareObject.getInstance().getJobCount();
         }
         hasGetTime = true;
         this.dispatchEvent(new Event("getDeliverDataRes"));
      }
      
      public function setJobCount(count:int) : void
      {
         jobCount = count;
         creatShareObject.getInstance().setJobCount(count);
      }
   }
}

