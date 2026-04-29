package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ChrisLamu.ChrisSocket;
   import com.logic.socket.ballot.NpcBallotSocket;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ReceiveGiftView
   {
      
      private static var instance:ReceiveGiftView;
      
      private var giftMC:MovieClip;
      
      private var childMC:*;
      
      private var panelMC:MovieClip;
      
      private var ismyhome:Boolean;
      
      private var panleMc:MovieClip;
      
      private var homeID_C:int;
      
      private var typeArr:Array = [93,87,88,89,90,91];
      
      private var proArr:Array = [201,202,203,204,205,206];
      
      private var countArr:Array = [1,5,10,15,20,30];
      
      private var dataArr:Array;
      
      private var count_C:int;
      
      private var tipsArr:Array = ["20枚銀元寶，收獲1隻極品聖光獸後獲取","5顆爆豆種子，收獲5隻極品聖光獸後獲取","20個快快長脆脆酥，收獲10隻極品聖光獸後獲取","10個天使蛋果實，收獲15隻極品聖光獸後獲取","1顆純白天使蛋，收獲20隻極品聖光獸後獲取","兔兔金錢紅包裝，收獲30隻極品聖光獸後獲取"];
      
      public function ReceiveGiftView()
      {
         super();
      }
      
      public static function getInstance() : ReceiveGiftView
      {
         if(!instance)
         {
            instance = new ReceiveGiftView();
         }
         return instance;
      }
      
      public function init(homeID:int) : void
      {
         this.homeID_C = homeID;
         this.ismyhome = homeID == LocalUserInfo.getUserID();
         this.giftMC = new MovieClip();
         this.giftMC.name = "giftMC";
         tip.tipTailDisPlayObject(this.giftMC,"聖光獸養成計劃");
         MainManager.getAppLevel().addChild(this.giftMC);
         var url:String = "resource/task/receiveGiftMC.swf";
         var tempMC:MCLoader = new MCLoader(url,this.giftMC,1,"正在打開面板......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadCallBoardHandler);
         tempMC.doLoad();
      }
      
      private function loadCallBoardHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         this.childMC = evt.getLoader();
         mainMC.addChild(this.childMC);
         this.panelMC = MovieClip(this.childMC.content.root.panelMC);
         this.panelMC = MovieClip(this.childMC.content.root.panelMC);
         this.panelMC.buttonMode = true;
         this.panelMC.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/task/receiveMC.swf","正在加載......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      public function mcInit(mc:MovieClip) : void
      {
         var i:int = 0;
         var j:int = 0;
         this.panleMc = mc;
         if(!this.ismyhome)
         {
            for(i = 1; i < 7; i++)
            {
               this.panleMc["mc" + i].visible = false;
            }
         }
         else
         {
            for(j = 1; j < 7; j++)
            {
               tip.tipTailDisPlayObject(this.panleMc["mc" + j],this.tipsArr[int(j - 1)]);
            }
         }
         BC.addEvent(this.panleMc,this.panleMc.close_btn,MouseEvent.CLICK,this.removePanleFun);
         BC.addEvent(this,this.panleMc.eggBtn,MouseEvent.CLICK,this.onOpenEggPanel);
         BC.addEvent(this.panleMc,GV.onlineSocket,"read_1486",this.getBeastInfoHandlerFun);
         ChrisSocket.getBeastInfo(this.homeID_C);
      }
      
      private function onOpenEggPanel(event:MouseEvent) : void
      {
         this.removePanleFun();
         var loadGame:LoadGame = new LoadGame("module/external/AngelEggMain.swf","正在加載天使蛋屋",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function getBeastInfoHandlerFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this.panleMc,GV.onlineSocket,"read_1486",this.getBeastInfoHandlerFun);
         this.count_C = evt.EventObj.count;
         if(this.count_C > 999)
         {
            this.count_C = 999;
         }
         this.barAndTipsHandler();
         this.getDataLoopFun();
      }
      
      private function getDataLoopFun() : void
      {
         BC.addEvent(this.panleMc,GV.onlineSocket,"read_2008",this.NpcBallotHandler);
         NpcBallotSocket.NpcBallotReq();
      }
      
      private function NpcBallotHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this.panleMc,GV.onlineSocket,"read_2008",this.NpcBallotHandler);
         this.dataArr = new Array();
         for(var i:int = 0; i < this.typeArr.length; i++)
         {
            if(GF.getBitBool(int(evt.EventObj.arr[2]),int(this.typeArr[i] - 32)))
            {
               this.dataArr.push(1);
            }
            else
            {
               this.dataArr.push(0);
            }
         }
         this.btnHandlerFun();
      }
      
      private function btnHandlerFun() : void
      {
         var i:int = 0;
         var num:int = this.count_C > 30 ? 30 : this.count_C;
         if(this.ismyhome)
         {
            for(i = 0; i < this.dataArr.length; i++)
            {
               if(this.dataArr[i] == 0 && num >= this.countArr[i])
               {
                  this.panleMc["mc" + (i + 1)].gotoAndStop(2);
                  this.panleMc["mc" + (i + 1)].buttonMode = true;
                  BC.addEvent(this.panleMc,this.panleMc["mc" + (i + 1)],MouseEvent.CLICK,this.btnClickHandler);
               }
               else if(this.dataArr[i] == 1)
               {
                  this.panleMc["mc" + (i + 1)].gotoAndStop(3);
               }
               else if(num >= this.countArr[i])
               {
                  this.panleMc["mc" + (i + 1)].gotoAndStop(1);
               }
            }
         }
      }
      
      private function btnClickHandler(evt:MouseEvent) : void
      {
         var i:int = int(evt.currentTarget.name.substr(-1,1)) - 1;
         if(i > -1)
         {
            BC.addEvent(this.panleMc,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.giftHandlerFun);
            exchange.exchange_goods(this.proArr[i]);
         }
      }
      
      private function giftHandlerFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this.panleMc,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.giftHandlerFun);
         var type:int = int(evt.EventObj.type);
         var i:int = this.getPositionForProArr(type);
         if(i > -1)
         {
            BC.removeEvent(this.panleMc,this.panleMc["mc" + (i + 1)],MouseEvent.CLICK,this.btnClickHandler);
            this.panleMc["mc" + (i + 1)].gotoAndStop(3);
            this.panleMc["mc" + (i + 1)].buttonMode = false;
         }
         var count:int = int(evt.EventObj.arr[0].count);
         var itemID:int = int(evt.EventObj.arr[0].itemID);
         Alert.smileAlart("    恭喜你獲得了" + count + "個" + GoodsInfo.getItemNameByID(itemID) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(itemID) + "中了。");
      }
      
      private function getPositionForProArr(type:int) : int
      {
         for(var i:int = 0; i < this.proArr.length; i++)
         {
            if(this.proArr[i] == type)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function barAndTipsHandler() : void
      {
         var num:int = this.count_C > 30 ? 30 : this.count_C;
         var frame_num:int = int(num / 30 * this.panleMc.bar.totalFrames);
         this.panleMc.bar.gotoAndStop(frame_num);
         this.panleMc.g.gotoAndStop(int(this.count_C.toString().substr(-1,1)) + 1);
         if(this.count_C > 9)
         {
            this.panleMc.s.gotoAndStop(int(this.count_C.toString().substr(-2,1)) + 1);
         }
         else
         {
            this.panleMc.s.visible = false;
         }
         if(this.count_C > 99)
         {
            this.panleMc.b.gotoAndStop(int(this.count_C.toString().substr(-3,1)) + 1);
         }
         else
         {
            this.panleMc.b.visible = false;
         }
      }
      
      private function removePanleFun(evt:MouseEvent = null) : void
      {
         BC.removeEvent(this.panleMc);
         if(Boolean(this.panleMc.parent.parent.parent.parent))
         {
            this.panleMc.parent.parent.parent.parent.removeChild(this.panleMc.parent.parent.parent);
         }
      }
   }
}

