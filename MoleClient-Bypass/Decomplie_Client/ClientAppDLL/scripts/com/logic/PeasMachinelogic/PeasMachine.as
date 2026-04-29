package com.logic.PeasMachinelogic
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.finishSomething.finishedSomethingRes;
   import com.logic.socket.userSurvey.userSurveyDoneReq;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.checkCloth;
   import com.module.activityModule.checkItem;
   import com.view.toolView.toolView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class PeasMachine extends Sprite
   {
      
      private var Jpanel:Sprite = new Sprite();
      
      private var doudouji:Sprite;
      
      private var card:MovieClip;
      
      private var beans:MovieClip;
      
      private var enter:*;
      
      private var reset:*;
      
      private var pingmu1:Sprite;
      
      private var pingmu2:Sprite;
      
      private var pingmu3:Sprite;
      
      private var pingmu4:Sprite;
      
      private var pingmu5:Sprite;
      
      private var pingmu6:*;
      
      private var pingmu7:Sprite;
      
      private var pingmu8:*;
      
      private var pingmu:Sprite = new Sprite();
      
      private var _back:Boolean = false;
      
      private var jclose:*;
      
      private var _checkItem:checkItem = new checkItem();
      
      private var enter_f:Function;
      
      private var reset_f:Function;
      
      private var lock:Boolean = false;
      
      private var lock2:Boolean = false;
      
      public function PeasMachine()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var mcloader:MCLoader = new MCLoader("module/external/PeasMachine.swf",MainManager.getAppLevel(),Loading.TITLE_AND_PERCENT,"正在打開豆豆機......");
         mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.onload);
         mcloader.doLoad();
         this.checkIteminit();
      }
      
      private function onload(event:MCLoadEvent) : void
      {
         var loader:Loader = event.getLoader();
         this.doudouji = new (this.getClass(loader,"fla_doudouji"))();
         this.card = new (this.getClass(loader,"fla_card"))();
         this.beans = new (this.getClass(loader,"fla_beans"))();
         this.enter = new (this.getClass(loader,"fla_enter"))();
         this.reset = new (this.getClass(loader,"fla_reset"))();
         this.pingmu1 = new (this.getClass(loader,"fla_pingmu1"))();
         this.pingmu2 = new (this.getClass(loader,"fla_pingmu2"))();
         this.pingmu3 = new (this.getClass(loader,"fla_pingmu3"))();
         this.pingmu4 = new (this.getClass(loader,"fla_pingmu4"))();
         this.pingmu5 = new (this.getClass(loader,"fla_pingmu5"))();
         this.pingmu6 = new (this.getClass(loader,"fla_pingmu6"))();
         this.pingmu7 = new (this.getClass(loader,"fla_pingmu7"))();
         this.pingmu8 = new (this.getClass(loader,"fla_pingmu8"))();
         this.jclose = new (this.getClass(loader,"fla_close"))();
         this.Jpanel.addChild(this.doudouji);
         this.Jpanel.addChild(this.jclose);
         this.jclose.x = 330;
         this.jclose.y = 170;
         this.Jpanel.addChild(this.card);
         this.card.gotoAndStop(1);
         this.card.x = 374;
         this.card.y = 350;
         this.Jpanel.addChild(this.beans);
         this.beans.x = 286;
         this.beans.y = 488;
         this.beans.gotoAndStop(1);
         this.Jpanel.addChild(this.pingmu);
         this.pingmu.x = 52;
         this.pingmu.y = 150;
         this.Jpanel.addChild(this.reset);
         this.reset.buttonMode = true;
         this.reset.x = 270;
         this.reset.y = 350;
         this.Jpanel.addChild(this.enter);
         this.enter.buttonMode = true;
         this.enter.x = 180;
         this.enter.y = 350;
         this.pingmu.addChild(this.pingmu5);
         this.Jpanel.x = 270;
         this.Jpanel.y = 10;
         MainManager.getAppLevel().addChild(this.Jpanel);
         var mcloader:MCLoader = event.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.onload);
         mcloader.clear();
         this.listener();
         this.enter_f = this.isCan;
         this.reset_f = this.removelisterner;
      }
      
      private function listener() : void
      {
         this.enter.addEventListener(MouseEvent.CLICK,this.__enter);
         this.reset.addEventListener(MouseEvent.CLICK,this.__reset);
         this.jclose.addEventListener(MouseEvent.CLICK,this.__reset);
         GV.onlineSocket.addEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.reShow);
         GV.onlineSocket.addEventListener("removeMapEvent",this.__reset);
      }
      
      public function removelisterner() : void
      {
         this.enter.removeEventListener(MouseEvent.CLICK,this.__enter);
         this.reset.removeEventListener(MouseEvent.CLICK,this.__reset);
         this.jclose.removeEventListener(MouseEvent.CLICK,this.__reset);
         GV.onlineSocket.removeEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.reShow);
      }
      
      private function __enter($e:Event) : void
      {
         this.reset_f();
         this.enter_f();
      }
      
      private function pclose() : void
      {
         GV.onlineSocket.dispatchEvent(new Event(toolView.SHOWBAG_EVENT));
         this.close();
      }
      
      public function isCan() : void
      {
         this.listener();
         this.pingmu.removeChildAt(0);
         if(!this.isVip())
         {
            trace("不是vip");
            this.pingmu.addChild(this.pingmu2);
            this.enter_f = this.jt;
            this.reset_f = this.close;
            return;
         }
         if(!this.isBackpack())
         {
            trace("在背包否");
            this.pingmu.addChild(this.pingmu3);
            this.enter_f = this.gt;
            this.reset_f = this.close;
            return;
         }
         if(!this.isHand())
         {
            trace(" // 在手上否");
            this.pingmu.addChild(this.pingmu4);
            this.enter_f = this.pclose;
            return;
         }
         this.card.play();
         this.send();
      }
      
      private function send() : void
      {
         if(!this.lock)
         {
            this.lock = true;
            userSurveyDoneReq.sendReq(5);
         }
      }
      
      private function reShow($e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishedSomethingRes.FINISHED_SOMETHING_SUCC,this.reShow);
         if($e.EventObj.count == 0)
         {
            this.pingmu.addChild(this.pingmu7);
            this.enter_f = this.close;
            return;
         }
         trace("pingmu6.txt.text",$e.EventObj.arr);
         var money:Number = Number($e.EventObj.arr[0].ItemCount);
         var format:TextFormat = new TextFormat();
         format.size = 32;
         this.pingmu8.txt.defaultTextFormat = format;
         this.pingmu8.txt.text = money.toString();
         if(!this.lock2)
         {
            this.lock2 = true;
            LocalUserInfo.countYXQ(money);
         }
         this.pingmu.addChild(this.pingmu8);
         this.Jpanel.removeChild(this.reset);
         this.enter.x += this.enter.width / 2;
         this.beans.play();
         this.enter_f = this.nowclose;
      }
      
      private function nowclose() : void
      {
         GV.GF.showAlert(GV.MC_AppLever,"豆豆已經放入你的百寶箱，一定要好好照顧超級拉姆噢！","",6,"E");
         this.close();
      }
      
      private function gt() : void
      {
         switchMapLogic.switchMapLogicHandler(143,true);
      }
      
      private function close() : void
      {
         this.removelisterner();
         this.Jpanel.parent.removeChild(this.Jpanel);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.__reset);
      }
      
      private function jt() : void
      {
         switchMapLogic.switchMapLogicHandler(18,true);
      }
      
      private function __reset($e:Event) : void
      {
         this.close();
         trace("--------------__ent結束");
      }
      
      private function getClass($loader:Loader, $d:String) : Class
      {
         return $loader.contentLoaderInfo.applicationDomain.getDefinition($d) as Class;
      }
      
      private function isWeek() : Boolean
      {
         return false;
      }
      
      private function checkIteminit() : void
      {
         checkItem.checkItemHandler(12205);
         GV.onlineSocket.addEventListener(checkItem.chekItem_suc,this.checkItemSuc);
      }
      
      private function checkItemSuc($e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(checkItem.chekItem_suc,this.checkItemSuc);
         if($e.EventObj.count > 0)
         {
            this._back = true;
         }
      }
      
      private function isHand() : Boolean
      {
         return checkCloth.doAction(12205);
      }
      
      private function isBackpack() : Boolean
      {
         return this._back;
      }
      
      private function isVip() : Boolean
      {
         return LocalUserInfo.getSuperPet();
      }
   }
}

