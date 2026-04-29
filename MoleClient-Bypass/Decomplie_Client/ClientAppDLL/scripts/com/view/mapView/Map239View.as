package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.global.staticData.CommandID;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.StatisticsManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class Map239View extends MapBase
   {
      
      public function Map239View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         SystemEventManager.addEventListener("eatCake",this.eatCake);
         SystemEventManager.addEventListener("task585Over",this.onTaskOver);
         SystemEventManager.addEventListener("birthdayInvited",this.birthdayHandle);
         SystemEventManager.addEventListener("loveTestState239",this.loveTestState239Handler);
      }
      
      private function loveTestState239Handler(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         GF.sendSocket(CommandID.MOVIE_PLAY,322,0);
      }
      
      private function back12047(e:SocketEvent) : void
      {
         var data:ByteArray;
         var type:uint;
         var flag:uint;
         var status:uint;
         var tempArrayFront:Array = null;
         var resultFront:Array = null;
         var tempArrayBehind:Array = null;
         var resultBehind:Array = null;
         GV.onlineSocket.removeCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         data = e.data as ByteArray;
         data.position = 0;
         type = data.readUnsignedInt();
         flag = data.readUnsignedInt();
         status = data.readUnsignedInt();
         if(status == 1)
         {
            ActivityTmpDataManager.loveTestFlag = 2;
         }
         if(ActivityTmpDataManager.loveTestFlag == 1)
         {
            tempArrayFront = ActivityTmpDataManager.loveTestArray.slice(0,7);
            resultFront = tempArrayFront.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 1 ? true : false;
            });
            tempArrayBehind = ActivityTmpDataManager.loveTestArray.slice(7);
            resultBehind = tempArrayBehind.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 0 ? true : false;
            });
            if(ActivityTmpDataManager.loveTestArray[7] == 1)
            {
               Alert.smileAlart("愛心測試已經完成了！");
            }
            else if(ActivityTmpDataManager.loveTestArray[7] == 0)
            {
               if(resultFront.length < tempArrayFront.length)
               {
                  Alert.smileAlart("先要通過其他人的愛心測試喲");
               }
               else if(resultFront.length == tempArrayFront.length)
               {
                  mapSay(101);
               }
            }
            else
            {
               Alert.angryAlart("伺服器數據錯誤。");
            }
         }
         else if(ActivityTmpDataManager.loveTestFlag == 2)
         {
            Alert.smileAlart("愛心測試已經完成了！");
         }
         else
         {
            ModuleManager.openPanel("LoveTestPanel");
         }
      }
      
      private function birthdayHandle(e:SystemEvent) : void
      {
         SystemEventManager.removeEventListener("birthdayInvited",this.birthdayHandle);
         mapSay(5);
      }
      
      private function onTaskOver(e:SystemEvent) : void
      {
         StatisticsManager.send(231);
         TaskManager.overTask(585);
         Alert.smileAlart("恭喜你已成為優秀小店員啦，可獲得1500摩爾豆/月的薪資喲。");
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 1500);
      }
      
      private function eatCake(e:SystemEvent) : void
      {
         if(TaskManager.getTask(585).getBit(3))
         {
            mapSay(2);
         }
         else
         {
            mapSay(4);
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("birthdayInvited",this.birthdayHandle);
         SystemEventManager.removeEventListener("eatCake",this.eatCake);
         SystemEventManager.removeEventListener("task585Over",this.onTaskOver);
         SystemEventManager.removeEventListener("loveTestState239",this.loveTestState239Handler);
         super.destroy();
      }
   }
}

