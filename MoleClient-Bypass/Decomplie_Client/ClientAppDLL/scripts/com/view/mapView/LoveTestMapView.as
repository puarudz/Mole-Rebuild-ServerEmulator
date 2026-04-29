package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.global.staticData.CommandID;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class LoveTestMapView
   {
      
      private static var _inst:LoveTestMapView;
      
      private static var _temp:uint;
      
      public function LoveTestMapView()
      {
         super();
      }
      
      public static function get inst() : LoveTestMapView
      {
         if(_inst == null)
         {
            _inst = new LoveTestMapView();
         }
         return _inst;
      }
      
      public function initV() : void
      {
         SystemEventManager.addEventListener("loveTestMap",this.nextStep);
      }
      
      private function nextStep(e:SystemEvent) : void
      {
         _temp = MapManager.curMapID;
         GV.onlineSocket.addCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         GF.sendSocket(CommandID.MOVIE_PLAY,322,0);
      }
      
      private function back12047(e:SocketEvent) : void
      {
         var data:ByteArray;
         var type:uint;
         var flag:uint;
         var status:uint;
         GV.onlineSocket.removeCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         data = e.data as ByteArray;
         data.position = 0;
         type = data.readUnsignedInt();
         flag = data.readUnsignedInt();
         status = data.readUnsignedInt();
         if(status == 1)
         {
            ActivityTmpDataManager.loveTestFlag = 2;
            Alert.smileAlart("愛心測試已經完成。");
         }
         else
         {
            switch(_temp)
            {
               case 32:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestFlag = 1;
                     ActivityTmpDataManager.loveTestArray[0] = 1;
                     trace(ActivityTmpDataManager.loveTestFlag);
                     switchMapLogic.switchMapLogicHandler(344);
                  }
                  break;
               case 344:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[1] = 1;
                     switchMapLogic.switchMapLogicHandler(78);
                  }
                  break;
               case 78:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[2] = 1;
                     switchMapLogic.switchMapLogicHandler(45);
                  }
                  break;
               case 45:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[3] = 1;
                     switchMapLogic.switchMapLogicHandler(27);
                  }
                  break;
               case 27:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[4] = 1;
                     switchMapLogic.switchMapLogicHandler(17);
                  }
                  break;
               case 17:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[5] = 1;
                     switchMapLogic.switchMapLogicHandler(79);
                  }
                  break;
               case 79:
                  if(ActivityTmpDataManager.loveTestFlag != 2)
                  {
                     ActivityTmpDataManager.loveTestArray[6] = 1;
                     switchMapLogic.switchMapLogicHandler(239);
                  }
                  break;
               case 239:
                  ActivityTmpDataManager.loveTestArray[7] = 1;
                  ActivityTmpDataManager.loveTestFlag = 2;
                  GF.sendSocket(CommandID.MOVIE_PLAY,322,1);
                  Alert.smileAlart("愛心測試已經結束，請繼續進行下一項測試！",function():void
                  {
                     ModuleManager.openPanel(ModuleType.FIRE_CUP_REGISTRATION_PANEL);
                  });
            }
         }
      }
      
      private function destroyD() : void
      {
         SystemEventManager.removeEventListener("loveTestMap",this.nextStep);
      }
   }
}

