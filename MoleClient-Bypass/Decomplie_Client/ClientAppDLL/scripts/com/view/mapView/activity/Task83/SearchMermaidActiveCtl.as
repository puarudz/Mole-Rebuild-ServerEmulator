package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.sizeAlert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   
   public class SearchMermaidActiveCtl
   {
      
      private static var _instance:SearchMermaidActiveCtl;
      
      private var resultObj:Object;
      
      private var ply:PlayMovie;
      
      public function SearchMermaidActiveCtl()
      {
         super();
      }
      
      public static function instance() : SearchMermaidActiveCtl
      {
         if(_instance == null)
         {
            _instance = new SearchMermaidActiveCtl();
         }
         return _instance;
      }
      
      public function OpenActivePanel() : void
      {
         ModuleManager.openPanel(ModuleType.SEARCH_MERMAID_PANEL);
      }
      
      public function OpenMakeMusicGame() : void
      {
         StatisticsClass.getInstance().init(67748843);
         MapManager.clearMap();
         GameframeLogic.stopMousicHandler();
         BC.addEvent(this,GV.onlineSocket,"getGameFraction",this.checkScore);
         ModuleManager.openGameByMCLoader("SearchMermaidMakeMusic");
      }
      
      public function OpenPackMusicGame() : void
      {
         this.getPackMusicNum();
      }
      
      public function OpenFlightHobbyhorse() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic2);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1351369,0);
      }
      
      public function OpenExchangePanel() : void
      {
         ModuleManager.openPanel(ModuleType.SEARCH_MERMAID_EXCHANGE_PANEL);
      }
      
      public function ShowFlyHippo(obj:Object) : void
      {
         this.resultObj = obj;
         if(this.resultObj.count == 3 || this.resultObj.count == 6 || this.resultObj.count == 10)
         {
            if(this.resultObj.count == 3)
            {
               this.ply = PlayMovie.play("resource/task/task484/flyHippo1.swf",null,null,this.playOver);
            }
            else if(this.resultObj.count == 6)
            {
               this.ply = PlayMovie.play("resource/task/task484/flyHippo2.swf",null,null,this.playOver);
            }
            else if(this.resultObj.count == 10)
            {
               this.ply = PlayMovie.play("resource/task/task484/flyHippo3.swf",null,null,this.playOver);
            }
         }
         else
         {
            this.showAlert();
         }
      }
      
      private function playOver() : void
      {
         this.ply.destroy();
         this.ply = null;
         this.showAlert();
      }
      
      private function showAlert() : void
      {
         if(this.resultObj.result == 1)
         {
            Alert.angryAlart("    很遺憾，你派遣出去的小海馬隻得到了一點線索，恭喜你獲得了5個貝殼作為獎勵!");
         }
         else if(this.resultObj.result == 2)
         {
            Alert.smileAlart("    你派去探索的小海馬發現了重大的線索，恭喜你獲得了10個貝殼作為獎勵!");
         }
         else if(this.resultObj.result == 3)
         {
            Alert.smileAlart("    你今天可以獲得的貝殼已經太多了，去玩其他的活動吧！");
         }
         if(this.resultObj.specialCnt != 0)
         {
            Alert.smileAlart("    感謝你為尋找美人魚付出的努力，恭喜你獲得" + GoodsInfo.getItemNameByID(this.resultObj.specialCnt) + "！");
         }
      }
      
      private function checkScore(event:EventTaomee) : void
      {
         GameframeLogic.playMousicHandler();
         BC.removeEvent(this,GV.onlineSocket,"getGameFraction",this.checkScore);
         if(event.EventObj.fraction >= 100)
         {
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetMakeAwards);
            exchange.exchange_goods(1506);
         }
         else
         {
            Alert.angryAlart("    很遺憾你制造音符失敗了，再試試吧！");
         }
      }
      
      private function onGetMakeAwards(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.onGetMakeAwards);
         var myAlert:sizeAlert = Alert.smileAlart("    恭喜你完成了音符制造，獲得1個音符！",this.openPack);
      }
      
      private function openPack(event:*) : void
      {
         this.OpenPackMusicGame();
      }
      
      private function getPackMusicNum() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1351368,0);
      }
      
      private function getItemCountLogic(event:EventTaomee) : void
      {
         var i:int = 0;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic);
         var arr:Array = event.EventObj.obj.arr;
         var num:int = 0;
         if(arr.length != 0)
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i].id == 1351368)
               {
                  num = int(arr[i].itemCount);
                  break;
               }
            }
         }
         if(num > 0)
         {
            StatisticsClass.getInstance().init(67748844);
            MapManager.clearMap();
            ModuleManager.openGame(ModuleType.SEARCH_MERMAID_PACK_MUSIC);
         }
         else
         {
            Alert.smileAlart("    包裝音符需要消耗一個音符，先去制造一個音符吧！");
         }
      }
      
      private function getItemCountLogic2(event:EventTaomee) : void
      {
         var i:int = 0;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountLogic2);
         var arr:Array = event.EventObj.obj.arr;
         var num:int = 0;
         if(arr.length != 0)
         {
            for(i = 0; i < arr.length; i++)
            {
               if(arr[i].id == 1351369)
               {
                  num = int(arr[i].itemCount);
                  break;
               }
            }
         }
         if(num > 0)
         {
            StatisticsClass.getInstance().init(67748845);
            ModuleManager.openPanel(ModuleType.SEARCH_MERMAID_FLY_HIPPO);
         }
         else
         {
            Alert.smileAlart("    需要先包裝完成一個音符才能放飛小海馬哦！");
         }
      }
   }
}

