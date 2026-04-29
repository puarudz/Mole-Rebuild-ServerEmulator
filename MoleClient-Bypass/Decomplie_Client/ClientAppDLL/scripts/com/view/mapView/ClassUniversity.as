package com.view.mapView
{
   import com.common.util.Tick;
   import com.core.info.LocalUserInfo;
   import com.core.music.TopicMusicManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import flash.events.MouseEvent;
   
   public class ClassUniversity extends MapBase
   {
      
      private var _bool:Boolean = true;
      
      public function ClassUniversity()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,controlLevel["tip_1Btn"],MouseEvent.CLICK,this.tip1Event);
         BC.addEvent(this,controlLevel["tip_2Btn"],MouseEvent.CLICK,this.tip2Event);
         this.initSound();
         this.Watches();
      }
      
      private function initSound() : void
      {
         BC.addEvent(this,_mapLevel.topLevel["soundMC"],MouseEvent.CLICK,this.closeHandler);
      }
      
      private function closeHandler(evt:MouseEvent) : void
      {
         if(this._bool)
         {
            TopicMusicManager.instance.stopSound();
         }
         else
         {
            TopicMusicManager.instance.playSound(LocalUserInfo.getMapID());
         }
         this._bool = !this._bool;
      }
      
      private function tip1Event(evt:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.MAP77_HELP_PANEL);
      }
      
      private function tip2Event(evt:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.MAP77_MOTTO_PANEL);
      }
      
      public function Watches() : void
      {
         _mapLevel.controlLevel["watches"].hourHand.visible = true;
         _mapLevel.controlLevel["watches"].minuteHand.visible = true;
         Tick.instance.addCallback(this.onTick);
      }
      
      private function onTick(delay:Number) : void
      {
         var currentTime:Date = new Date();
         var minutes:uint = currentTime.getMinutes();
         var hours:uint = currentTime.getHours();
         _mapLevel.controlLevel["watches"].minuteHand.rotation = minutes * 6;
         _mapLevel.controlLevel["watches"].hourHand.rotation = hours % 12 * 30;
      }
      
      override public function destroy() : void
      {
         Tick.instance.removeCallback(this.onTick);
         super.destroy();
      }
   }
}

