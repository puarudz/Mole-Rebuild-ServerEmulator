package com.module.AngelsAndDemons
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.dragon.dragonInfo.DragonInfo;
   import com.core.newloader.MCLoader;
   import com.core.socketlogic.servermsg.ServerMsg;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.GameframeLogic.GameframeLogic;
   import com.logic.socket.angelsAndDemons.AngelsWarBeginSocket;
   import com.logic.socket.angelsAndDemons.AngelsWarEndResultsSocket;
   import com.logic.socket.angelsAndDemons.GetFightAngelsSocket;
   import com.logic.socket.angelsAndDemons.GetFightLevelSocket;
   import com.logic.socket.angelsAndDemons.GetFightScoreByIDSocket;
   import com.logic.socket.angelsAndDemons.KillMonsterSocket;
   import com.module.AngelsAndDemons.data.AngelsAndDemonsData;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class AngelsAndDemonsCtl
   {
      
      private static var _instance:AngelsAndDemonsCtl;
      
      public static var begin_url:String = "resource/angelsAndDemons/swf/JoinGameStartPanel.swf";
      
      public static var award_url:String = "resource/angelsAndDemons/swf/AwardPanel.swf";
      
      public static var choose_url:String = "resource/angelsAndDemons/swf/ChooseAngelsToFight.swf";
      
      public static var game_url:String = "resource/angelsAndDemons/tdgame/TDGame.swf";
      
      public static var game_url2:String = "resource/angelsAndDemons/tdgame/MoleFight.swf";
      
      public static var over_url:String = "resource/angelsAndDemons/swf/GameOverPanel.swf";
      
      public static var book_url:String = "module/external/BooksUI/angleBattle.swf";
      
      public static var exchange_url:String = "resource/angelsAndDemons/swf/ExchangeGoods.swf";
      
      public static var IP:String = "http://mole.61.com";
      
      private var angelData:AngelsAndDemonsData;
      
      private var now_id:int;
      
      private var game_type:int;
      
      private var lvl_ldr:Loader;
      
      private var gift_MC:MovieClip;
      
      private var childMC:*;
      
      private var type:int;
      
      private var bl:Boolean = false;
      
      private var _dragonInfo:DragonInfo;
      
      private var task_id:int;
      
      public function AngelsAndDemonsCtl()
      {
         super();
      }
      
      public static function get instance() : AngelsAndDemonsCtl
      {
         if(!_instance)
         {
            _instance = new AngelsAndDemonsCtl();
         }
         return _instance;
      }
      
      public static function clear() : void
      {
         var i:Object = null;
         for(i in AngelsAndDemonsData)
         {
            i = null;
         }
      }
      
      public function LoadBeginPanelFun(_url:String, mapID:int = 1, type:int = 0) : void
      {
         if(mapID == 81)
         {
            StatisticsClass.getInstance().init(67748707);
         }
         else if(mapID == 82)
         {
            StatisticsClass.getInstance().init(67748708);
         }
         else if(mapID == 83)
         {
            StatisticsClass.getInstance().init(67748717);
         }
         var url:String = _url + "?mapId=" + mapID + "&type=" + type;
         this.bl = true;
         this.dragonInfo = PeopleManageView(GV.MAN_PEOPLE).dragon_Info;
         this.onLoadPanel(url);
      }
      
      public function LoadAwardPanelFun(_url:String, mapID:int = 1) : void
      {
         var url:String = _url + "?mapId=" + mapID;
         this.onLoadPanel(url);
      }
      
      public function LoadChooseAngelsPanelFun(_url:String, mapID:int, type:int = 0) : void
      {
         if(Boolean(PeopleManageView(GV.MAN_PEOPLE).dragon_Info))
         {
            this.dragonInfo = PeopleManageView(GV.MAN_PEOPLE).dragon_Info;
         }
         var url:String = _url + "?mapId=" + mapID + "&type=" + type;
         this.onLoadPanel(url);
      }
      
      public function LoadOverPanelFun(_url:String, lvl:int) : void
      {
         var url:String = _url + "?level=" + lvl;
         this.onLoadPanel(url);
      }
      
      public function LoadHelpBookFun() : void
      {
         this.onLoadPanel(book_url);
      }
      
      public function LoadExchangePanelFun() : void
      {
         this.onLoadPanel(exchange_url);
      }
      
      public function LoadGame(taskid:int, type:int = 0) : void
      {
         this.now_id = taskid;
         this.game_type = type;
         BC.addEvent(this,GV.onlineSocket,"read_" + 7071,this.GoInGameOK);
         AngelsWarBeginSocket.angelsWarBeginFun(taskid);
      }
      
      private function GoInGameOK(e:Event) : void
      {
         var str:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7071,this.GoInGameOK);
         ServerMsg.errorBool = true;
         KillMonsterSocket.b_count = 0;
         this.bl = true;
         BC.addEvent(this,GV.onlineSocket,"tdGameOver",this.testFun);
         var url:String = "";
         if(this.game_type == 0)
         {
            url += game_url;
         }
         else if(this.game_type == 1)
         {
            url += game_url2;
         }
         url += "?taskid=" + this.now_id + "&level=" + AngelsAndDemonsData.instance.fight_lvl + "&exp=" + AngelsAndDemonsData.instance.exp;
         var arr:* = AngelsAndDemonsData.instance.choose_Angels;
         for(var i:int = 0; i < arr.length; i++)
         {
            str = "&angle" + i + "=" + arr[i].angelId + "!" + arr[i].angelCount;
            url += str;
         }
         GameframeLogic.stopMousicHandler();
         this.onLoadPanel(url,1);
      }
      
      public function testFun(e:EventTaomee) : void
      {
         var beatEnemyCount:int = 0;
         var i:Object = null;
         var totalScore:int = 0;
         this.dragonInfo = null;
         BC.removeEvent(this,GV.onlineSocket,"tdGameOver",this.testFun);
         GameframeLogic.playMousicHandler();
         var obj:Object = e.EventObj;
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12757",this.onGameLimitFun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 7072,this.GiveGameAward);
         for(i in obj.enemy)
         {
            beatEnemyCount += obj.enemy[i].count;
         }
         trace("後台最大戰利品數量：" + KillMonsterSocket.b_count);
         for(i in obj.prizeArr)
         {
            if(obj.prizeArr[i].prize_id == 1353433)
            {
               if(obj.prizeArr[i].prize_count > KillMonsterSocket.b_count)
               {
                  trace("超出後台限制了！");
                  obj.prizeCount = KillMonsterSocket.b_count;
                  obj.prizeArr[i].prize_count = KillMonsterSocket.b_count;
               }
            }
         }
         AngelsAndDemonsData.instance.over_obj = obj;
         totalScore = beatEnemyCount * 10 + obj.starCount * 10 + obj.lifeCount * 10 + obj.winScore;
         AngelsWarEndResultsSocket.angelsWarEndResultsFun(obj.id,int(obj.clearance),obj.round,totalScore,obj.enemy,obj.prizeArr,obj.attackArr);
      }
      
      private function GiveGameAward(e:EventTaomee) : void
      {
         var arr:Array = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7072,this.GiveGameAward);
         if(this.game_type == 1)
         {
            if(Boolean(AngelsAndDemonsData.instance.over_obj.clearance))
            {
               Alert.getIconByID_Alart(e.EventObj.arr[0].awardId,"　　恭喜你獲得了" + e.EventObj.arr[0].awardCount + "個" + GoodsInfo.getItemNameByID(e.EventObj.arr[0].awardId));
            }
            else
            {
               Alert.angryAlart("    你這次挑戰失敗，請再接再厲！");
            }
         }
         else
         {
            AngelsAndDemonsData.instance.fightExp = e.EventObj.exp;
            arr = e.EventObj.arr;
            AngelsAndDemonsData.instance.award_arr = arr;
            BC.addEvent(this,GV.onlineSocket,"clearTDGameData",this.clearData);
            this.LoadOverPanelFun(over_url,e.EventObj.level);
         }
      }
      
      private function onGameLimitFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12757",this.onGameLimitFun);
         if(this.game_type != 1)
         {
            this.checkLoadOverPanel();
         }
      }
      
      private function checkLoadOverPanel(exp:int = 0, id:int = 0, count:int = 0) : void
      {
         AngelsAndDemonsData.instance.fightExp = exp;
         AngelsAndDemonsData.instance.award_arr = null;
         BC.addEvent(this,GV.onlineSocket,"clearTDGameData",this.clearData);
         this.LoadOverPanelFun(over_url,AngelsAndDemonsData.instance.fight_lvl);
      }
      
      private function clearData(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"clearTDGameData",this.clearData);
         ServerMsg.errorBool = false;
         this.bl = false;
         var state:Boolean = Boolean(AngelsAndDemonsData.instance.over_obj.clearance);
         GV.onlineSocket.dispatchEvent(new EventTaomee("clearTDGameOverPanel",{"result":state}));
         clear();
      }
      
      private function onLoadPanel(url:String, _type:int = 0) : void
      {
         this.gift_MC = new MovieClip();
         this.gift_MC.name = "gift_MC";
         var tempMC:MCLoader = new MCLoader(url,this.gift_MC,1,"請耐心等待......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(e:*) : void
      {
         if(this.bl)
         {
            this.bl = false;
            this.removeStage();
         }
         var mainMC:DisplayObjectContainer = e.getParent();
         this.childMC = e.getLoader();
         mainMC.addChild(this.childMC);
         MainManager.getGameLevel().addChild(this.gift_MC);
      }
      
      public function clearHandler(e:* = null) : void
      {
         BC.removeEvent(this);
         GC.clearAll(this.gift_MC);
         this.childMC = null;
         this.gift_MC = null;
      }
      
      public function getUserBestResults(mapId:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 7005,this.resetUserBestResultsSucFun);
         GetFightScoreByIDSocket.getFightScoreByIDFun(mapId);
      }
      
      private function resetUserBestResultsSucFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7005,this.resetUserBestResultsSucFun);
         var arr:Array = [evt.EventObj.easy,evt.EventObj.nomal,evt.EventObj.hard];
         this.setUserNowBarrier(evt.EventObj.mapID);
         this.setUserBestResults(arr);
      }
      
      public function getUserFightAngels() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 7070,this.resetFightAngelsFun);
         GetFightAngelsSocket.getFightAngelsFun();
      }
      
      private function resetFightAngelsFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7070,this.resetFightAngelsFun);
         this.setUserFightAngels(evt.EventObj);
      }
      
      public function getUserFightProps() : void
      {
      }
      
      public function getUserFightLvl() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 7004,this.resetUserFightLvlFun);
         GetFightLevelSocket.getFightLevelFun();
      }
      
      private function resetUserFightLvlFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7004,this.resetUserFightLvlFun);
         AngelsAndDemonsData.instance.fight_lvl = evt.EventObj.level;
         AngelsAndDemonsData.instance.exp = evt.EventObj.score;
      }
      
      public function setUserBestResults(arr:Array) : void
      {
         AngelsAndDemonsData.instance.bestResult_arr = arr;
      }
      
      public function setUserNowBarrier(id:int) : void
      {
         AngelsAndDemonsData.instance.barrierId = id;
      }
      
      public function setUserFightLvl(lvl:int) : void
      {
         AngelsAndDemonsData.instance.barrier_lvl = lvl;
      }
      
      public function setUserFightAngels(arr:*) : void
      {
         AngelsAndDemonsData.instance.angel_arr = arr;
      }
      
      public function setUserPropsArr(arr:Array) : void
      {
         AngelsAndDemonsData.instance.props_arr = arr;
      }
      
      public function setUserBarrierLvl(lvl:int) : void
      {
         AngelsAndDemonsData.instance.barrier_lvl = lvl;
      }
      
      public function LoadTDForTask(taskid:int, angelArr:Array) : void
      {
         this.task_id = taskid;
         AngelsAndDemonsData.instance.choose_Angels = angelArr;
         BC.addEvent(this,GV.onlineSocket,"read_" + 7004,this.setTaskUserLvl);
         GetFightLevelSocket.getFightLevelFun();
      }
      
      private function setTaskUserLvl(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7004,this.setTaskUserLvl);
         AngelsAndDemonsData.instance.fight_lvl = e.EventObj.level;
         AngelsAndDemonsData.instance.exp = e.EventObj.score;
         this.LoadGame(this.task_id);
      }
      
      public function removeStage() : void
      {
         MapManager.clearMap();
      }
      
      public function get dragonInfo() : DragonInfo
      {
         return this._dragonInfo;
      }
      
      public function set dragonInfo(value:DragonInfo) : void
      {
         this._dragonInfo = value;
      }
   }
}

