package com.module.superGift
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.logic.socket.dragon.DragonBagSocket;
   import com.logic.socket.kakunianSocket;
   import com.module.activityModule.Presented;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.query.QueryImpl;
   import com.mole.debug.DebugManager;
   
   public class thanksgivingModule
   {
      
      private static var instance:thanksgivingModule;
      
      public static var thanksObj:Object;
      
      private static var canotNew:Boolean = true;
      
      private static var IsOpen:Boolean = false;
      
      private static var IsGet:int = 0;
      
      private var _fun:Function = null;
      
      private var myAlert:*;
      
      public function thanksgivingModule()
      {
         super();
         if(canotNew)
         {
            throw new Error("thanksgivingModule不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : thanksgivingModule
      {
         if(!instance)
         {
            canotNew = false;
            instance = new thanksgivingModule();
            canotNew = true;
         }
         return instance;
      }
      
      public function openWindowsFun() : void
      {
         DebugManager.traceMsg("  本來加載１２月的超級拉姆包月活動");
      }
      
      public function openKakunianFun() : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/kakunianPanle.swf","正在加載大禮包",MainManager.getGameLevel());
         loadGame = null;
      }
      
      public function domesticateFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1227,this.checkDragonBagFun);
         DragonBagSocket.getDragonBagRequest();
      }
      
      private function checkDragonBagFun(evt:EventTaomee) : void
      {
         var _msg:String = null;
         var type:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1227,this.checkDragonBagFun);
         var isHave:Boolean = true;
         var obj:Object = evt.EventObj;
         var dragonID:int = 1350012;
         for(var i:int = 0; i < obj.arr.length; i++)
         {
            if(obj.arr[i].id == dragonID)
            {
               isHave = false;
            }
         }
         if(isHave)
         {
            QueryImpl.getInstance().QueryItem([190836],this.checkDomesticateNum);
         }
         else
         {
            _msg = "      你已經馴化好一隻卡酷年坐騎了，不能太貪心喲！";
            type = "sure";
            this.alertFun(_msg,type);
         }
      }
      
      private function checkDomesticateNum(arr:Array) : void
      {
         var _msg:String = null;
         var type:String = null;
         if(arr[0].count > 0)
         {
            this.searchTrainingNum();
         }
         else
         {
            _msg = "      你還沒有卡酷年呢！先去餵養一隻收獲了後再來馴化吧！";
            type = "sure";
         }
         this.alertFun(_msg,type);
      }
      
      private function searchTrainingNum() : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 6028,this.trainingNumFun);
         kakunianSocket.trainingNumRequest();
      }
      
      private function trainingNumFun(evt:EventTaomee) : void
      {
         var _msg:String = null;
         var type:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 6028,this.trainingNumFun);
         if(evt.EventObj == 0)
         {
            _msg = "      要馴化你的卡酷年嗎？馴化後可以成為坐騎，騎上卡酷年可威風了！";
            type = "sure,notgo";
         }
         else if(evt.EventObj == 1)
         {
            _msg = "      你的卡酷年還是頑固不化，不肯被馴服呢！需要花費5點點豆購買乖乖聽話糖，再次馴化一次嗎？";
            type = "sure,notgo";
         }
         else if(evt.EventObj == 2)
         {
            _msg = "      你的卡酷年很頑劣呢，不肯被馴服呢！需要購買乖乖聽話糖，花費5點點豆。再馴化一次嗎？";
            type = "sure,notgo";
         }
         else if(evt.EventObj > 2)
         {
            _msg = "      你的卡酷年頑固不化啊，不肯被馴服呢！需要購買乖乖聽話糖，花費5點點豆。再馴化一次嗎？";
            type = "sure,notgo";
         }
         this.alertFun(_msg,type,this.getDomIsSucc);
      }
      
      private function alertFun(_msg:String, type:String, fristFun:Function = null) : void
      {
         this.myAlert = Alert.smileAlart(_msg,null,type,110);
         if(fristFun != null)
         {
            this._fun = fristFun;
            this.myAlert.addEventListener(Alert.CLICK_ + "1",this.confirmHander);
         }
      }
      
      private function confirmHander(e:*) : void
      {
         this.myAlert.removeEventListener(Alert.CLICK_ + "1",this.confirmHander);
         this._fun();
      }
      
      private function getDomIsSucc() : void
      {
         QueryImpl.getInstance().QueryItem([16012],this.checkDididouNum);
      }
      
      private function checkDididouNum(arr:Array) : void
      {
         var _msg:String = null;
         var type:String = null;
         if(arr[0].count > 4)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 6027,this.DomesticateFun);
            kakunianSocket.DomesticateRequest();
         }
         else
         {
            _msg = "      你的點點豆不足哦！";
            type = "sure";
            this.alertFun(_msg,type);
         }
      }
      
      private function DomesticateFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 6027,this.DomesticateFun);
         BC.addEvent(this,GV.onlineSocket,"MadeKakuOver",this.MadeKakuOverFun);
         var flag:uint = uint(evt.EventObj);
         var loadGame:LoadGame = new LoadGame("module/external/madeKakunian.swf?flag=" + flag,"正在打開......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function MadeKakuOverFun(evt:EventTaomee) : void
      {
         var _msg:String = null;
         var type:String = null;
         BC.removeEvent(this,GV.onlineSocket,"MadeKakuOver",this.MadeKakuOverFun);
         var flag:uint = uint(evt.EventObj);
         if(flag == 0)
         {
            this.searchTrainingNum();
         }
         else if(flag == 1)
         {
            _msg = "      恭喜你！你的卡酷年馴化成功了，真是很難得喲！打開騎寵背包看看吧，騎上它多拉風呀！";
            type = "sure";
            this.alertFun(_msg,type);
         }
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
         if(GF.getBitBool(int(evt.EventObj.arr[2]),int(95 - 32)))
         {
            IsGet = 1;
            return;
         }
         this.getJYFun();
      }
      
      private function getJYFun() : void
      {
         Presented.getInstance().celebrate1225(260);
      }
   }
}

