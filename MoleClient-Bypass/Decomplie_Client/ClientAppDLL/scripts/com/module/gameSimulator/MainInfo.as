package com.module.gameSimulator
{
   import com.core.gameSimulator.SEI;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.event.EventTaomee;
   import com.logic.socket.SendGameSocreRegistSocket;
   import com.logic.socket.getSceneUserInfo.GetSceneUserInfoReq;
   import com.logic.socket.getSceneUserInfo.GetSceneUserRes;
   import com.view.outputGameProp.OutputGameProp;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MainInfo
   {
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public function MainInfo()
      {
         super();
      }
      
      public static function dispatchEvent(event:Event) : Boolean
      {
         return dispatchObj.dispatchEvent(event);
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         dispatchObj.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         dispatchObj.removeEventListener(type,listener,useCapture);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return dispatchObj.hasEventListener(type);
      }
      
      public static function hasOwnProperty(name:String) : Boolean
      {
         return dispatchObj.hasOwnProperty(name);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return dispatchObj.willTrigger(type);
      }
      
      public static function getMole_baseInfo(userID:uint) : void
      {
         var f:Function = null;
         f = function(E:EventTaomee):void
         {
            BC.removeEvent(MainInfo,GV.onlineClass,ClientOnLineSerSocket.GET_BASIC_MESSAGE,f);
            var info:Object = E.EventObj;
            SEI.getSEI().sendMainObj({
               "type":"MainInfo",
               "type2":"getMole_baseInfo",
               "data":info
            });
         };
         BC.addEvent(MainInfo,GV.onlineSocket,GetSceneUserRes.GET_SCENE_INFO,f);
         new GetSceneUserInfoReq().getSeceeUserInfo(userID);
      }
      
      public static function getMole_simpleInfo(userID:uint) : void
      {
         var f:Function = null;
         f = function(E:EventTaomee):void
         {
            var info:Object = E.EventObj;
            SEI.getSEI().sendMainObj({
               "type":"MainInfo",
               "type2":"getMole_simpleInfo",
               "data":info
            });
            BC.removeEvent(MainInfo,GV.onlineSocket,E.type,f);
         };
         GF.getUserInfoByID(userID,MainInfo,f);
      }
      
      public static function submit_GameSocre(gameSocreObj:Object) : void
      {
         var showItem:Function = null;
         showItem = function(E:EventTaomee):void
         {
            BC.removeEvent(MainInfo,SEI.getSEI(),Event.UNLOAD,showItem);
            if(gameSocreObj.ItemID > 100 && gameSocreObj.ItemID < 104)
            {
               GV.GF.showMadel(gameSocreObj.ItemID);
            }
            else if(gameSocreObj.ItemID > 0)
            {
               OutputGameProp.output(gameSocreObj.GameID,gameSocreObj.ItemID);
            }
         };
         trace("\n獲得分數包:");
         trace("gameSocreObj.GameID",gameSocreObj.GameID);
         trace("gameSocreObj.Rank",gameSocreObj.Rank);
         trace("gameSocreObj.Strong",gameSocreObj.Strong);
         trace("gameSocreObj.IQ",gameSocreObj.IQ);
         trace("gameSocreObj.Lovely",gameSocreObj.Lovely);
         trace("gameSocreObj.Exp",gameSocreObj.Exp);
         trace("gameSocreObj.score",gameSocreObj.score);
         trace("gameSocreObj.Time",gameSocreObj.Time);
         trace("gameSocreObj.ItemID",gameSocreObj.ItemID);
         trace("gameSocreObj.Yxb/gameSocreObj.gameRMB",gameSocreObj.Yxb);
         dispatchEvent(new EventTaomee("submit_GameSocre",gameSocreObj));
         BC.addEvent(MainInfo,SEI.getSEI(),Event.UNLOAD,showItem);
      }
      
      public static function submit_GameSocreToServer(gameSocreObj:Object) : void
      {
         var ip:String = ServerInfo.getGameInfo(ServerInfo.IP);
         var port:int = ServerInfo.getGameInfo(ServerInfo.PORT);
         var obj1:Object = {
            "ip":ip,
            "port":port,
            "gameID":gameSocreObj.submitGameID,
            "type":0,
            "score":gameSocreObj.Time,
            "session":gameSocreObj.Session
         };
         new SendGameSocreRegistSocket(obj1);
      }
      
      public static function flush_gameHarvest(obj:Object) : void
      {
         LocalUserInfo.setStrong(LocalUserInfo.getStrong() + (Boolean(obj.Strong) ? obj.Strong : 0));
         LocalUserInfo.setIQ(LocalUserInfo.getIQ() + (Boolean(obj.IQ) ? obj.IQ : 0));
         LocalUserInfo.setCharm(LocalUserInfo.getCharm() + (Boolean(obj.Lovely) ? obj.Lovely : 0));
         LocalUserInfo.setExp(LocalUserInfo.getExp() + (Boolean(obj.Exp) ? obj.Exp : 0));
         LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + (Boolean(obj.Yxb) ? obj.Yxb : 0));
      }
   }
}

