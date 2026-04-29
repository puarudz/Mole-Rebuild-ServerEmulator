package com.view.mapView
{
   import com.event.EventTaomee;
   import com.mole.app.map.MapBase;
   
   public class Bmhspace extends MapBase
   {
      
      public function Bmhspace()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"fireAction_select",this.lookHandler);
      }
      
      private function lookHandler(evt:EventTaomee) : void
      {
         var a:int = 0;
         if(evt.EventObj.type == 2)
         {
            a = int(Math.random() * 10);
            if(a < 3)
            {
               GF.switchMap(173,true);
            }
            else
            {
               GF.switchMap(174,true);
            }
         }
      }
   }
}

