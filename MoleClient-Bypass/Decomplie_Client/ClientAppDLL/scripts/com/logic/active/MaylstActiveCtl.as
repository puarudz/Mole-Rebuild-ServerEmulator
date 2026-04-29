package com.logic.active
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.hotCup.hotCupSocket;
   import com.mole.app.map.MapManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class MaylstActiveCtl
   {
      
      private static var _instance:MaylstActiveCtl;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      private var isClearMap:Boolean = false;
      
      private var isClearBGMusic:Boolean = true;
      
      public function MaylstActiveCtl()
      {
         super();
      }
      
      public static function get instance() : MaylstActiveCtl
      {
         if(_instance == null)
         {
            _instance = new MaylstActiveCtl();
         }
         return _instance;
      }
      
      public function onLoadGame(url:String, isClearMap:Boolean = false, isClearBGMusic:Boolean = false) : void
      {
         this.isClearMap = isClearMap;
         this.isClearBGMusic = isClearBGMusic;
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         MainManager.getAppLevel().addChild(this.gift_MC);
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"正在打開......");
         BC.addOnceEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         if(this.isClearMap)
         {
            MapManager.clearMap();
         }
         if(this.isClearBGMusic)
         {
            GameframeLogic.stopMousicHandler();
         }
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
      }
      
      public function clearHandler() : void
      {
         DisplayUtil.removeForParent(this.gift_MC);
         MapManager.refreshMap();
         if(this.isClearBGMusic)
         {
            GameframeLogic.playMousicHandler();
         }
         this.isClearMap = false;
         this.isClearBGMusic = false;
      }
      
      public function GetGameAwards(gameID:uint, score:uint) : void
      {
         this.clearHandler();
         BC.addEvent(this,GV.onlineSocket,"read_" + 1246,this.onResGetAwards);
         hotCupSocket.getGameAward(gameID,score);
      }
      
      private function onResGetAwards(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1246,this.onResGetAwards);
         var arr:Array = event.EventObj.arr;
         if(arr.length == 0)
         {
            return;
         }
         if(arr[0].itemCount == 0 && arr[0].itemId == 0)
         {
            return;
         }
         var msg:String = "      恭喜你獲得" + arr[0].itemCount + "個" + GoodsInfo.getItemNameByID(arr[0].itemId) + "！";
         Alert.smileAlart(msg);
      }
   }
}

