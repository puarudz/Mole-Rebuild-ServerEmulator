package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.TaskManager;
   
   public class Map237View extends MapBase
   {
      
      public function Map237View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         SystemEventManager.addEventListener("task585Over",this.onTaskOver);
         SystemEventManager.addEventListener("nullBoxSwap",this.nullBoxHandle);
         SystemEventManager.addEventListener("findBoxSwap",this.findBoxHandle);
         SystemEventManager.addEventListener("gotoYouXi",this.gotoYouXi);
         GV.onlineSocket.addEventListener("KFCBoxOver",this.boxHandle);
      }
      
      private function gotoYouXi(e:SystemEvent) : void
      {
         Alert.angryAlart("　　大事不好！去西部遊樂場的路已經被小偷封死，快去尼爾拉塔找魔法師想辦法吧",function():void
         {
            BufferManager.setBuffer(BufferManager.KFC_JEWEL_BOX_SWAP,1);
            MapManager.enterMap(84);
         });
      }
      
      private function boxHandle(e:*) : void
      {
         mapSay(6);
      }
      
      private function nullBoxHandle(e:SystemEvent) : void
      {
         mapSay(5);
      }
      
      private function findBoxHandle(e:SystemEvent) : void
      {
         ModuleManager.openPanel("KFCBoxSwapGame");
      }
      
      private function onTaskOver(e:SystemEvent) : void
      {
         StatisticsManager.send(231);
         TaskManager.overTask(585);
         Alert.smileAlart("恭喜你已成為優秀小店員啦，可獲得1500摩爾豆/月的薪資喲。");
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 1500);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("gotoYouXi",this.gotoYouXi);
         SystemEventManager.removeEventListener("findBoxSwap",this.findBoxHandle);
         SystemEventManager.removeEventListener("nullBoxSwap",this.nullBoxHandle);
         SystemEventManager.removeEventListener("task585Over",this.onTaskOver);
         GV.onlineSocket.removeEventListener("KFCBoxOver",this.boxHandle);
         super.destroy();
      }
   }
}

