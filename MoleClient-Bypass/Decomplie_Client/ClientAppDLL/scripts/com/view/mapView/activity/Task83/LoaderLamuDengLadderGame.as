package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.GetAngelSeedsSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LoaderLamuDengLadderGame
   {
      
      private static var _instance:LoaderLamuDengLadderGame;
      
      private var type:int = 0;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      public function LoaderLamuDengLadderGame()
      {
         super();
      }
      
      public static function get instance() : LoaderLamuDengLadderGame
      {
         if(!_instance)
         {
            _instance = new LoaderLamuDengLadderGame();
         }
         return _instance;
      }
      
      public function loaderGameFun(_type:int = 0) : void
      {
         this.type = _type;
         finishSomethingReq.sendReq(40005);
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
      }
      
      private function dofinishSomething(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.dofinishSomething);
         if(e.EventObj.Type == 40005)
         {
            if(e.EventObj.Done < 5)
            {
               this.checkLamu();
            }
            else
            {
               Alert.smileAlart("    為了保證拉姆飛天服能正常使用，使用5次後，需要檢修，暫停使用，明天再來吧。");
            }
         }
      }
      
      private function checkLamu() : void
      {
         if(PeopleManageView(GV.MAN_PEOPLE).avatarMC.pet_mc.numChildren == 0)
         {
            Alert.smileAlart("    只有拉姆才能穿上飛天服，去高空拯救天使種子，快去把你的拉姆帶來吧！");
            return;
         }
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            BC.addEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
            this.onLoadPanel();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new Event("lamuDengCloudPanelLoad"));
         }
      }
      
      public function loadGame() : void
      {
         BC.addEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         this.onLoadPanel();
      }
      
      private function onLoadPanel() : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var url:String = "module/game/LamuDengLadderGame.swf?type=" + this.type;
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"正在打開遊戲......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         MapManager.clearMap();
         GameframeLogic.stopMousicHandler();
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler() : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.gift_MC = null;
      }
      
      private function gameOverFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"lamuJumpGameOver",this.gameOverFun);
         GameframeLogic.playMousicHandler();
         BC.addEvent(this,GV.onlineSocket,"read_" + 6031,this.getAngelSeedsFun);
         GetAngelSeedsSocket.getAngelSeeds(e.EventObj.type,e.EventObj.fraction);
      }
      
      private function getAngelSeedsFun(e:EventTaomee) : void
      {
         var arr:Array = null;
         var i:int = 0;
         var temp:Array = null;
         var sz:Array = null;
         var j:int = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 6031,this.getAngelSeedsFun);
         if(e.EventObj.arr[0] != 0)
         {
            arr = [];
            for(i = 0; i < e.EventObj.arr.length; i++)
            {
               if(e.EventObj.arr[i] != 0)
               {
                  arr.push(e.EventObj.arr[i]);
               }
            }
            if(arr.length == 1)
            {
               Alert.getIconByID_Alart(arr[0],"　  恭喜你獲得1個" + GoodsInfo.getItemNameByID(arr[0]) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(arr[0]) + "中！");
            }
            else
            {
               temp = [];
               sz = [];
               for(j = 0; j < arr.length; j++)
               {
                  if(temp.indexOf(arr[j]) == -1)
                  {
                     obj = new Object();
                     obj.itemId = arr[j];
                     obj.count = 1;
                     temp.push(arr[j]);
                     sz.push(obj);
                  }
                  else
                  {
                     sz[temp.indexOf(arr[j])]["count"] = sz[temp.indexOf(arr[j])]["count"] + 1;
                  }
               }
               if(sz.length == 1)
               {
                  Alert.getIconByID_Alart(arr[0],"　  恭喜你獲得" + sz[0]["count"] + "個" + GoodsInfo.getItemNameByID(sz[0]["itemId"]) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(arr[0]) + "中！");
               }
               else if(sz.length == 2)
               {
                  Alert.smileAlart("    恭喜你獲得" + sz[0]["count"] + "個" + GoodsInfo.getItemNameByID(sz[0]["itemId"]) + "、" + sz[1]["count"] + "個" + GoodsInfo.getItemNameByID(sz[1]["itemId"]) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(sz[0]["itemId"]) + "中！");
               }
               else if(sz.length == 3)
               {
                  Alert.smileAlart("    恭喜你獲得" + sz[0]["count"] + "個" + GoodsInfo.getItemNameByID(sz[0]["itemId"]) + "、" + sz[1]["count"] + "個" + GoodsInfo.getItemNameByID(sz[1]["itemId"]) + "、" + sz[2]["count"] + "個" + GoodsInfo.getItemNameByID(sz[2]["itemId"]) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(sz[0]["itemId"]) + "中！");
               }
               else if(sz.length == 4)
               {
                  Alert.smileAlart("    恭喜你獲得" + sz[0]["count"] + "個" + GoodsInfo.getItemNameByID(sz[0]["itemId"]) + "、" + sz[1]["count"] + "個" + GoodsInfo.getItemNameByID(sz[1]["itemId"]) + "、" + sz[2]["count"] + "個" + GoodsInfo.getItemNameByID(sz[2]["itemId"]) + sz[3]["count"] + "個" + GoodsInfo.getItemNameByID(sz[3]["itemId"]) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(sz[0]["itemId"]) + "中！");
               }
            }
         }
      }
   }
}

