package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.manager.SystemTimeController;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.map066.RiddlesActivity;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BoatMapView extends MapBase
   {
      
      private var _riddles:RiddlesActivity;
      
      private var peopleView:PeopleManageView;
      
      public function BoatMapView()
      {
         super();
      }
      
      private function onOpenFlower(e:*) : void
      {
         trace(SystemTimeController.instance.checkSysTimeAchieve(35));
         if(SystemTimeController.instance.checkSysTimeAchieve(35))
         {
            ModuleManager.openPanel("FlowerFromEastPanel");
         }
         else
         {
            Alert.angryAlart("　　此活動還未開啟，活動時間為2月15號到2月21號！敬請關注！");
         }
      }
      
      private function onClickFlower(e:Event) : void
      {
         this.peopleView = GV.MAN_PEOPLE;
         this.peopleView.addEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         this.peopleView.moveTo(290,303);
      }
      
      private function onGoOver(e:Event) : void
      {
         this.peopleView.removeEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         if(SystemTimeController.instance.checkSysTimeAchieve(35))
         {
            ModuleManager.openPanel("FlowerFromEastPanel");
         }
         else
         {
            Alert.angryAlart("　　此活動還未開啟，活動時間為2月15號到2月21號！敬請關注！");
         }
      }
      
      private function openHomePanel(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.HOME_PANEL);
      }
      
      override protected function initView() : void
      {
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("openFlowerPanel",this.onOpenFlower);
         this._riddles.destroy();
         super.destroy();
      }
   }
}

