package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.BaseMCLoader;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.active.MaylstActiveCtl;
   import com.logic.socket.action.ActionReq;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.giveMeMoney.giveMeMoneyReq;
   import com.logic.socket.grayGirlActive.GrayGirlSocket;
   import com.module.activityModule.Presented;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.query.QueryImpl;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Anniversary
   {
      
      private static var instance:Anniversary;
      
      private static var typeBool:Boolean = false;
      
      public static var _okInt:int = 0;
      
      public static var currentInt:int = 1;
      
      private static var IsGet:int = 0;
      
      private var type:int;
      
      private var getType:int;
      
      private var msg:String;
      
      private var loadPath:String = "resource/task/task10005/";
      
      private var loadNpc:MovieClip;
      
      private var notMC:MovieClip;
      
      private var typeNum:int = 0;
      
      private var actionReq:ActionReq;
      
      private var clickNum:int;
      
      private var checkTimer:Timer;
      
      private var _playMovie:PlayMovie;
      
      private var maxNum:int;
      
      private var id:int;
      
      private var _okStr:String;
      
      private var _noStr:String;
      
      public function Anniversary()
      {
         super();
      }
      
      public static function getInstance() : Anniversary
      {
         if(!instance)
         {
            instance = new Anniversary();
         }
         return instance;
      }
      
      public function getGameAwards(_gamseId:int, _s:int) : void
      {
         MaylstActiveCtl.instance.GetGameAwards(_gamseId,_s);
      }
      
      public function useCard(cound:uint) : void
      {
      }
      
      public function init() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.mapEvent();
      }
      
      public function openSMCAlent(_a:int) : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         GC.clearGInterval(this.checkTimer);
         this.checkTimer = GC.setGInterval(this.checkhaspan,40);
         this.clickNum = _a;
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            taskMC["SMC_btn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function checkhaspan() : void
      {
         var listMC:MovieClip = null;
         var smcMC:MovieClip = MainManager.getAppLevel().getChildByName("smcListMC") as MovieClip;
         if(Boolean(smcMC))
         {
            listMC = smcMC.getChildByName("List_mc") as MovieClip;
            if(Boolean(listMC))
            {
               if(Boolean(listMC.btnMC) && Boolean(listMC.btnMC["MC_" + this.clickNum]))
               {
                  listMC.btnMC["MC_" + this.clickNum].btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  GC.clearGInterval(this.checkTimer);
               }
            }
         }
      }
      
      public function openAlEvent() : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/NostalgiaPacksView.swf","正在加載面板",MainManager.getAppLevel());
         loadGame = null;
      }
      
      public function openPanel() : void
      {
         ModuleManager.openPanel(ModuleType.MAY_1ST_ACTIVE_EXCHANGE2,null,"正在加載面板，請耐心等待......",MainManager.getTopLevel());
      }
      
      public function openMoleShop() : void
      {
         var tempMC:Sprite = new Sprite();
         tempMC.name = "MoleShop";
         MainManager.getAppLevel().addChild(tempMC);
         var mcloader:MCLoader = new MCLoader("module/external/MoleShop.swf",tempMC,Loading.TITLE_AND_PERCENT,"請耐心等待...");
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.moleShopHandler);
         mcloader.doLoad();
      }
      
      private function moleShopHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.moleShopHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
      }
      
      public function openMC(_a:int) : void
      {
         PlayMovie.play("module/external/taskMc/task10003/task10003_mc_" + _a + ".swf",null,null,null,null,MainManager.getTopLevel());
      }
      
      private function mapEvent() : void
      {
         switch(LocalUserInfo.getMapID())
         {
            case 7:
            case 38:
            case 10:
            case 37:
         }
      }
      
      public function getGifEvent(_a:int, _b:int) : void
      {
         BC.addOnceEvent(this,GV.onlineSocket,"read_" + GrayGirlSocket.GIFTCmd,this.gigHandler);
         GrayGirlSocket.GetGift(_a,_b);
      }
      
      private function gigHandler(evt:EventTaomee) : void
      {
         var str:String = null;
         var i:int = 0;
         var _m:int = int(evt.EventObj.value);
         if(evt.EventObj.type != 0)
         {
            if(_m == 0)
            {
               Alert.smileAlart("    沒有完成兌換條件或勛章數量不足，點擊兌換物品可查看兌換要求。");
            }
            else
            {
               if(_m == 1 && evt.EventObj["itemID" + 0] == 0)
               {
                  Alert.smileAlart("    你已經擁有這件物品了，看看其他的吧！");
                  return;
               }
               str = "    恭喜你獲得";
               for(i = 0; i < _m; i++)
               {
                  str += GoodsInfo.getItemNameByID(evt.EventObj["itemID" + i]);
               }
               Alert.smileAlart(str + "！");
            }
         }
      }
      
      public function gotoMap() : void
      {
         if(LocalUserInfo.isVIP())
         {
            StatisticsClass.getInstance().init(67744890);
         }
         else
         {
            StatisticsClass.getInstance().init(67744891);
         }
         var loadGame:LoadGame = new LoadGame("resource/movie/guoqing.swf","請耐心等待......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      public function checkJYFun() : void
      {
         if(IsGet == 1)
         {
            return;
         }
         BC.addEvent(this,GV.onlineSocket,"read_2008",this.NpcBallotHandler);
         NpcBallotSocket.NpcBallotReq();
      }
      
      private function NpcBallotHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_2008",this.NpcBallotHandler);
         if(GF.getBitBool(int(evt.EventObj.arr[3]),int(8)))
         {
            IsGet = 1;
            return;
         }
         Presented.getInstance().celebrate1225(320);
      }
      
      private function getClothesHandler() : void
      {
         QueryImpl.getInstance().QueryItem([13783],this.checkHaveClothRes);
      }
      
      private function checkHaveClothRes(arr:Array) : void
      {
         var throwArr:Array = null;
         var getArr:Array = null;
         var giveCS:giveMeMoneyReq = null;
         if(arr[0].count <= 0)
         {
            throwArr = [];
            getArr = [{
               "kind":13783,
               "num":1
            },{
               "kind":13784,
               "num":1
            },{
               "kind":13785,
               "num":1
            },{
               "kind":13786,
               "num":1
            }];
            giveCS = new giveMeMoneyReq(throwArr,getArr);
         }
      }
      
      public function activaityOpanGame(_a:int) : void
      {
         if(_a == 1)
         {
            if(this.activityHandler(31390) < 10)
            {
               BC.addOnceEvent(this,GV.onlineSocket,"WolfGrandmotherGameOver",this.wolfGrandHandler);
               MaylstActiveCtl.instance.onLoadGame("module/active/smallRedHat/WolfGrandmotherGame.swf");
            }
            else
            {
               Alert.smileAlart("    對不起，今天已經達到遊戲上限，明天再來吧！");
            }
         }
         else if(_a == 2)
         {
            MaylstActiveCtl.instance.onLoadGame("module/active/smallRedHat/HitHamster.swf");
         }
      }
      
      private function wolfGrandHandler(evt:EventTaomee) : void
      {
         if(Boolean(evt.EventObj))
         {
            this.checkJYFunForType(1435,31390,10);
         }
         else
         {
            Alert.smileAlart("    真遺憾，沒有足夠證據指認大灰狼。");
         }
      }
      
      public function activityHandler(_type:int) : int
      {
         var _a:int = 0;
         BC.addOnceEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,function(e:EventTaomee):void
         {
            _a = e.EventObj.Done;
         });
         finishSomethingReq.sendReq(_type);
         return _a;
      }
      
      public function checkJYFunForType(_id:int, type:int, _maxNum:int, _s:String = "", _noS:String = "") : void
      {
         this.maxNum = _maxNum;
         this.id = _id;
         this._okStr = _s;
         this._noStr = _noS;
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
         finishSomethingReq.sendReq(type);
      }
      
      private function getFinishNumHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
         if(evt.EventObj.Done < this.maxNum)
         {
            Presented.getInstance().celebrate1225(this.id,1,0,this._okStr,this._noStr);
         }
         else if(Boolean(this._noStr))
         {
            if(this._noStr == "no")
            {
               return;
            }
            Alert.smileAlart("    " + this._noStr);
         }
         else
         {
            Alert.smileAlart("    你已經領取過了，不能太貪心哦！");
         }
      }
      
      private function removeEventHandler(evt:EventTaomee) : void
      {
         GC.clearGInterval(this.checkTimer);
         _okInt = 0;
         BC.removeEvent(this);
      }
   }
}

