package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.HelpAngelsGetAngelSocket;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HelpAngelsCtl
   {
      
      private static var instance:HelpAngelsCtl;
      
      private var pldr:Loader;
      
      private var ldr:Loader;
      
      private var id:int;
      
      private var s_ldr:Loader;
      
      private var qus:int;
      
      private var l_ldr:Loader;
      
      public function HelpAngelsCtl()
      {
         super();
      }
      
      public static function getInstance() : HelpAngelsCtl
      {
         if(instance == null)
         {
            instance = new HelpAngelsCtl();
         }
         return instance;
      }
      
      public function loaderPanel() : void
      {
         this.pldr = new Loader();
         BC.addEvent(this,this.pldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderPanelOk);
         this.pldr.load(VL.getURLRequest("resource/task/HelpAngelsPanel.swf"));
      }
      
      private function onLoaderPanelOk(e:Event) : void
      {
         BC.removeEvent(this,this.pldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderPanelOk);
         MainManager.getAppLevel().addChild(this.pldr);
         BC.addEvent(this,this.pldr.content["goBtn"],MouseEvent.CLICK,this.onInGame);
         BC.addEvent(this,this.pldr.content["backBtn"],MouseEvent.CLICK,this.onClosePanel);
         BC.addEvent(this,this.pldr.content["closeBtn"],MouseEvent.CLICK,this.onClosePanel);
      }
      
      private function onInGame(e:MouseEvent) : void
      {
         this.onClosePanel(null);
         this.loaderGame();
      }
      
      private function onClosePanel(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.pldr.content["goBtn"],MouseEvent.CLICK,this.onInGame);
         BC.removeEvent(this,this.pldr.content["backBtn"],MouseEvent.CLICK,this.onClosePanel);
         BC.removeEvent(this,this.pldr.content["closeBtn"],MouseEvent.CLICK,this.onClosePanel);
         if(this.pldr != null)
         {
            MainManager.getAppLevel().removeChild(this.pldr);
            this.pldr = null;
         }
      }
      
      public function loaderGame() : void
      {
         this.ldr = new Loader();
         BC.addEvent(this,GV.onlineSocket,"HelpAngelsGameResult",this.onCheckResult);
         this.ldr.load(VL.getURLRequest("module/game/HelpAngelsGame.swf"));
         MainManager.getAppLevel().addChild(this.ldr);
      }
      
      private function onCheckResult(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"HelpAngelsGameResult",this.onCheckResult);
         this.ldr = null;
         if(Boolean(e.EventObj.result))
         {
            this.id = e.EventObj.id;
            this.loaderSucPanel();
         }
         else
         {
            this.loaderFailePanel();
         }
      }
      
      private function loaderSucPanel() : void
      {
         this.s_ldr = new Loader();
         BC.addEvent(this,this.s_ldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderSucPanel);
         this.s_ldr.load(VL.getURLRequest("resource/task/HelpAngelsSuc.swf"));
      }
      
      private function onLoaderSucPanel(e:Event) : void
      {
         BC.removeEvent(this,this.s_ldr,Event.COMPLETE,this.onLoaderSucPanel);
         MainManager.getAppLevel().addChild(this.s_ldr);
         BC.addEvent(this,this.s_ldr.content["closeBtn"],MouseEvent.CLICK,this.onCloseSucFun);
         this.s_ldr.content["icon"].gotoAndStop(this.id);
         this.qus = int(Math.random() * 10) + 1;
         this.s_ldr.content["ques"].gotoAndStop(this.qus);
         BC.addEvent(this,this.s_ldr.content["btn1"],MouseEvent.CLICK,this.onAnswer);
         BC.addEvent(this,this.s_ldr.content["btn2"],MouseEvent.CLICK,this.onAnswer);
         BC.addEvent(this,this.s_ldr.content["btn3"],MouseEvent.CLICK,this.onAnswer);
         BC.addEvent(this,this.s_ldr.content["btn4"],MouseEvent.CLICK,this.onAnswer);
      }
      
      private function onCloseSucFun(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.s_ldr.content["closeBtn"],MouseEvent.CLICK,this.onCloseSucFun);
         BC.removeEvent(this,this.s_ldr.content["btn1"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn2"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn3"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn4"],MouseEvent.CLICK,this.onAnswer);
         if(Boolean(this.s_ldr))
         {
            MainManager.getAppLevel().removeChild(this.s_ldr);
            this.s_ldr = null;
         }
      }
      
      private function onAnswer(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.s_ldr.content["btn1"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn2"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn3"],MouseEvent.CLICK,this.onAnswer);
         BC.removeEvent(this,this.s_ldr.content["btn4"],MouseEvent.CLICK,this.onAnswer);
         var ss:String = e.currentTarget.name;
         var i:int = int(ss.slice(3));
         if(this.qus == 1 || this.qus == 2)
         {
            if(i == 1)
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(2);
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(3);
            }
         }
         else if(this.qus == 3 || this.qus == 4 || this.qus == 5)
         {
            if(i == 2)
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(2);
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(3);
            }
         }
         else if(this.qus == 6 || this.qus == 7 || this.qus == 8)
         {
            if(i == 3)
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(2);
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(3);
            }
         }
         else if(this.qus == 9 || this.qus == 10)
         {
            if(i == 4)
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(2);
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
               this.s_ldr.content["icon"]["mc"].gotoAndStop(3);
            }
         }
      }
      
      private function onGetAngelsSucFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
         BC.removeEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 7087,this.onGetAngelRes);
         if(this.id == 1)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354071);
         }
         else if(this.id == 2)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354093);
         }
         else if(this.id == 3)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354085);
         }
         else if(this.id == 4)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354100);
         }
      }
      
      private function onGetAngelsFaileFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"GetAngelsSuc",this.onGetAngelsSucFun);
         BC.removeEvent(this,GV.onlineSocket,"GetAngelsFaile",this.onGetAngelsFaileFun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 7087,this.onGetAngelRes);
         if(this.id == 1)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354072);
         }
         else if(this.id == 2)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354094);
         }
         else if(this.id == 3)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354086);
         }
         else if(this.id == 4)
         {
            HelpAngelsGetAngelSocket.helpAngelsGetAngelFun(1354101);
         }
      }
      
      private function onGetAngelRes(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 7087,this.onGetAngelRes);
         this.onCloseSucFun(null);
         var url:String = GoodsInfo.getItemPathByID(e.EventObj.angelId) + e.EventObj.angelId + ".swf";
         var msg:String = "    恭喜你獲得" + e.EventObj.angelCount + "個" + GoodsInfo.getItemNameByID(e.EventObj.angelId) + "，已經放入你的天使聖殿中！";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
      }
      
      private function loaderFailePanel() : void
      {
         this.l_ldr = new Loader();
         BC.addEvent(this,this.l_ldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderFailePanel);
         this.l_ldr.load(VL.getURLRequest("resource/task/HelpAngelsFaile.swf"));
      }
      
      private function onLoaderFailePanel(e:Event) : void
      {
         BC.removeEvent(this,this.l_ldr,Event.COMPLETE,this.onLoaderFailePanel);
         MainManager.getAppLevel().addChild(this.l_ldr);
         BC.addEvent(this,this.l_ldr.content["closeBtn"],MouseEvent.CLICK,this.onCloseFaileFun);
         BC.addEvent(this,this.l_ldr.content["goBtn"],MouseEvent.CLICK,this.onAgainGameFun);
         BC.addEvent(this,this.l_ldr.content["backBtn"],MouseEvent.CLICK,this.onCloseFaileFun);
      }
      
      private function onAgainGameFun(e:MouseEvent) : void
      {
         this.onCloseFaileFun(null);
         this.loaderGame();
      }
      
      private function onCloseFaileFun(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.l_ldr.content["closeBtn"],MouseEvent.CLICK,this.onCloseFaileFun);
         BC.removeEvent(this,this.l_ldr.content["goBtn"],MouseEvent.CLICK,this.onAgainGameFun);
         BC.removeEvent(this,this.l_ldr.content["backBtn"],MouseEvent.CLICK,this.onCloseFaileFun);
         if(Boolean(this.l_ldr))
         {
            MainManager.getAppLevel().removeChild(this.l_ldr);
            this.l_ldr = null;
         }
      }
   }
}

