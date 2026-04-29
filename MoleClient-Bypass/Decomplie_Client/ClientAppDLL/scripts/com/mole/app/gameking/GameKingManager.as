package com.mole.app.gameking
{
   import com.common.Alert.Alert;
   import com.global.staticData.XMLInfo;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.enterGame.EnterGameReq;
   import com.module.activityModule.Presented;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import org.taomee.ds.HashMap;
   
   public class GameKingManager
   {
      
      private static var _instance:GameKingManager;
      
      private var _infoHash:HashMap;
      
      public function GameKingManager(inner:InnerClass)
      {
         var info:GameKingConfigInfo = null;
         var gameXml:XML = null;
         super();
         this._infoHash = new HashMap();
         var infoXml:XML = XML(new XMLInfo.gameKingConfig());
         for each(gameXml in infoXml.children())
         {
            info = new GameKingConfigInfo(gameXml);
            this._infoHash.add(info.id,info);
         }
      }
      
      public static function get instance() : GameKingManager
      {
         if(!_instance)
         {
            _instance = new GameKingManager(new InnerClass());
         }
         return _instance;
      }
      
      public function enterGameById(gameId:uint) : void
      {
         var appCtl:AppModuleControl = null;
         var _info:GameKingConfigInfo = this.getInfo(gameId);
         switch(_info.gameType)
         {
            case 0:
               MapManager.enterMap(_info.mapid);
               break;
            case 105:
               MapManager.clearMap();
               appCtl = ModuleManager.openGame("SailedGame");
               appCtl.addEventListener(ModuleEvent.DESTROY,function(me:ModuleEvent):void
               {
                  submitScore(1742,uint(me.data));
               });
               break;
            case 106:
               MapManager.clearMap();
               appCtl = ModuleManager.openPanel(ModuleType.SIREN_COMBAT_DEFEND_PANEL);
               appCtl.addEventListener(ModuleEvent.DESTROY,function(me:ModuleEvent):void
               {
                  submitScore(1743,uint(me.data));
               });
               break;
            default:
               if(_info.chairID > 0)
               {
                  EnterGameReq.send(_info.chairID,_info.mapid);
               }
               GameframeLogic.loadGame(_info.id,_info.gameType);
         }
      }
      
      private function submitScore(typeID:uint, score:uint) : void
      {
         MapManager.refreshMap();
         if(score == 0)
         {
            Alert.angryAlart("　　好弱呀，是不是沒吃飯呢？再去練練吧！");
         }
         else
         {
            score = score > 200 ? 200 : score;
            Presented.getInstance().celebrate1225(typeID,score);
         }
      }
      
      public function getInfo(gameID:uint) : GameKingConfigInfo
      {
         return this._infoHash.getValue(gameID);
      }
      
      public function get infoList() : Array
      {
         return this._infoHash.getValues();
      }
      
      public function setScore(gameID:uint, gameScore:uint) : void
      {
         var info:GameKingConfigInfo = this._infoHash.getValue(gameID);
         info.score = gameScore;
      }
   }
}

class InnerClass
{
   
   public function InnerClass()
   {
      super();
   }
}
