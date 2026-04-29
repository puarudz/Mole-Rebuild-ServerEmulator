package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.hotCup.hotCupSocket;
   import com.mole.app.module.AppModuleBase;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   
   public class GameScoreSubmitManager
   {
      
      private static var _gameID:uint;
      
      private static var _gameScore:uint;
      
      private static var _gameModule:AppModuleBase;
      
      public function GameScoreSubmitManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _gameID = 0;
         OnlineManager.addCmdListener(CommandID.EXCHANGE_GAME_SCORE,onSubmitSucc);
         OnlineManager.addErrorListener(CommandID.EXCHANGE_GAME_SCORE,onSubmitFail);
      }
      
      private static function onSubmitFail(e:SocketEvent) : void
      {
         closeModule();
      }
      
      private static function closeModule() : void
      {
         if(_gameID == 47)
         {
            if(_gameScore > 5000)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("Throw_Suc"));
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("Throw_Fai"));
            }
         }
         if(Boolean(_gameModule))
         {
            _gameModule.close();
            _gameModule = null;
         }
         _gameID = 0;
      }
      
      public static function send(gameID:uint, gameScore:uint, appModule:AppModuleBase = null) : void
      {
         _gameModule = appModule;
         _gameID = gameID;
         _gameScore = gameScore;
         hotCupSocket.getGameAward(gameID,gameScore);
      }
      
      private static function onSubmitSucc(e:SocketEvent) : void
      {
         var itemInfo:ItemInfo = null;
         var gameAward:hotCupSocket = e.bodyInfo;
         switch(_gameID)
         {
            case 47:
               itemInfo = gameAward.itemList[0];
               showAlert(itemInfo);
               break;
            case 48:
               itemInfo = gameAward.itemList[0];
               showAlert(itemInfo);
               break;
            case 56:
               showAlert1(gameAward.itemList);
               break;
            case 0:
               break;
            default:
               showAlert1(gameAward.itemList);
         }
      }
      
      private static function showAlert1(itemList:Array) : void
      {
         var msg:String = null;
         var itemInfo:ItemInfo = null;
         var i:uint = 0;
         if(Boolean(itemList) && itemList.length > 0)
         {
            msg = "　　恭喜你獲得";
            for(i = 0; i < itemList.length; i++)
            {
               itemInfo = itemList[i];
               msg += itemInfo.count + "個" + GoodsInfo.getItemNameByID(itemInfo.ID) + ",";
            }
            msg = msg.substr(0,msg.length - 1);
            msg += "。";
            Alert.smileAlart(msg);
         }
      }
      
      private static function showAlert(itemInfo:ItemInfo) : void
      {
         if(Boolean(itemInfo))
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemInfo.count);
            Alert.smileAlart("    恭喜你獲得" + itemInfo.count + "個摩爾豆！",function(e:Event):void
            {
               closeModule();
            });
            return;
         }
      }
   }
}

