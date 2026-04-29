package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.getServerTimer.getServerTimerReq;
   import com.module.deal.Deal;
   
   public class TransmissionView extends BasicMapView
   {
      
      public function TransmissionView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,target_mc.start_mc,"hasStart",this.getPetProp);
         BC.addEvent(this,GV.onlineSocket,"move_for_game",this.leverMap);
         getServerTimerReq.getServerTimer(this,"getTimeDate");
      }
      
      private function getPetProp(E:*) : void
      {
         BC.removeEvent(this,target_mc.start_mc,"hasStart",this.getPetProp);
         Deal.BuyItem(12907,1,function(E:*):*
         {
            Alert.getIconByID_Alart(12907);
         });
      }
      
      private function leverMap(E:*) : void
      {
         GF.switchPrevMap();
      }
      
      public function getTimeDate(currentDate:Date) : void
      {
         target_mc.mouth_mc.showMonth(currentDate);
         target_mc.mouth_mc.visible = true;
      }
   }
}

