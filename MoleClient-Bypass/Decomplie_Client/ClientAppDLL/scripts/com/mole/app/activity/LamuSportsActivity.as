package com.mole.app.activity
{
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   
   public class LamuSportsActivity
   {
      
      private static var _inst:LamuSportsActivity;
      
      private var depthLevel:MovieClip;
      
      public function LamuSportsActivity()
      {
         super();
      }
      
      public static function get inst() : LamuSportsActivity
      {
         if(_inst == null)
         {
            _inst = new LamuSportsActivity();
         }
         return _inst;
      }
      
      public function init(depthLevel:MovieClip) : void
      {
         this.depthLevel = depthLevel;
      }
      
      private function onChangeMapOver(e:EventTaomee) : void
      {
         var mapid:int = LocalUserInfo.getMapID();
         switch(mapid)
         {
            case 68:
               this.initTime();
         }
      }
      
      private function initTime() : void
      {
         var timeDis:int = (new Date(2013,2,3,19,30).time - ServerUpTime.getInstance().date.time) / 1000;
         if(timeDis > 0)
         {
            GV.MC_mapFrame["control_mc"]["bigTorch"].gotoAndStop(1);
         }
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
      }
   }
}

