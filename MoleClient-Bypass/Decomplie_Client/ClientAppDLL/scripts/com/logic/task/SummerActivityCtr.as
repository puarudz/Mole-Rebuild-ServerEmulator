package com.logic.task
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.home.HomeCarSocket;
   import com.logic.socket.summerAct.SummerSocket;
   import com.mole.app.info.SocketInfo;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SocketManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import com.mole.app.utils.PlayMovie;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SummerActivityCtr
   {
      
      private static var _instance:SummerActivityCtr;
      
      public var gameStep:int = 0;
      
      private var _movie:PlayMovie;
      
      public var saveSirenTimes:int = 0;
      
      public var isTransing:Boolean = false;
      
      private var _fishBtn:DisplayObject;
      
      private var _plumberTimes:int = 0;
      
      public function SummerActivityCtr()
      {
         super();
      }
      
      public static function get inst() : SummerActivityCtr
      {
         if(_instance == null)
         {
            _instance = new SummerActivityCtr();
         }
         return _instance;
      }
      
      public function getStepData() : void
      {
         BC.addEvent(this,GV.onlineSocket,SummerSocket.GET_STEP + "_sm",this.getStepOver,false,0,true);
         SocketManager.add(new SocketInfo(SummerSocket.GET_STEP_CMD,SummerSocket.GET_STEP,"getStep"));
      }
      
      private function getStepOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SummerSocket.GET_STEP + "_sm",this.getStepOver);
         this.gameStep = e.EventObj.gameStep;
      }
      
      private function configGame0Events() : void
      {
         if(LocalUserInfo.getMapID() == 254)
         {
            this._fishBtn = MapButtonView.regeditEvent(GV.MC_mapFrame["depth_mc"].fishBtn,this.openGame0);
            tip.tipTailDisPlayObject(this._fishBtn,"拯救小海妖");
         }
      }
      
      private function openGame0(e:MouseEvent) : void
      {
         var appModule:AppModuleControl = ModuleManager.openPanel(ModuleType.SAVE_SIREN_PANEL);
         appModule.addEventListener(ModuleEvent.DESTROY,this.onGame0Destroy);
      }
      
      private function onGame0Destroy(e:ModuleEvent) : void
      {
         var appControl:AppModuleControl = e.currentTarget as AppModuleControl;
         appControl.removeEventListener(ModuleEvent.DESTROY,this.onGame0Destroy);
         if(e.data == true)
         {
            ephemeralDataSocket.setData(23,this.saveSirenTimes + 1);
            this.saveSirenTimes += 1;
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1581Over,false,0,true);
            exchange.exchange_goods(1581);
            if(this.gameStep == 0)
            {
               this.gameStep = 1;
            }
         }
         else if(e.data == false)
         {
            Alert.angryAlart("    如果再放手不管，可憐的小胖魚就生命垂危啦！");
         }
      }
      
      private function exchange1581Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1581)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1581Over);
            if(this.saveSirenTimes <= 1)
            {
               Alert.smileAlart("    感謝你救活了小海妖，獲得海底樂園遊戲幣1枚！海洋娛樂協會聲望上升6！",this.showGame0Movie);
            }
            else
            {
               Alert.smileAlart("    感謝你救活了小海妖，獲得海底樂園遊戲幣1枚！海洋娛樂協會聲望上升6！");
            }
         }
      }
      
      private function showGame0Movie(e:*) : void
      {
         if(LocalUserInfo.getMapID() == 254)
         {
            this._movie = PlayMovie.play("resource/task/summerAct/movie6.swf",null,null,this.playGame0MovieOver);
         }
      }
      
      private function playGame0MovieOver() : void
      {
         var tFunc:Function = null;
         if(LocalUserInfo.getMapID() == 254)
         {
            this._movie.destroy();
            this._movie = null;
            GV.MC_mapFrame["depth_mc"].fishBtn.gotoAndStop(3);
            tFunc = function():void
            {
               MapManageView.inst.mapControl.map.mapSay(3);
               SystemEventManager.addEventListener("SummerActGame2",openAdvertise);
            };
            TweenLite.to(this,7,{"onComplete":tFunc});
         }
      }
      
      private function openAdvertise(e:*) : void
      {
         SystemEventManager.removeEventListener("SummerActGame2",this.openAdvertise);
         var appModule:AppModuleControl = ModuleManager.openPanel(ModuleType.ADVERTISE_PANEL);
         appModule.addEventListener(ModuleEvent.DESTROY,this.advertisePanelDestroy);
      }
      
      private function advertisePanelDestroy(e:ModuleEvent) : void
      {
         var appControl:AppModuleControl = e.currentTarget as AppModuleControl;
         appControl.removeEventListener(ModuleEvent.DESTROY,this.onGame0Destroy);
         ModuleManager.openPanel(ModuleType.POSTER_PANEL);
      }
      
      public function initPlumber() : void
      {
         BC.addEvent(this,GV.MC_mapFrame["top_mc"].hose,MouseEvent.CLICK,this.openPlumberGame,false,0,true);
         tip.tipTailDisPlayObject(GV.MC_mapFrame["top_mc"].hose,"接水管");
      }
      
      private function openPlumberGame(e:MouseEvent) : void
      {
         var appModule:AppModuleControl = ModuleManager.openModule(ModuleType.PLUMBER_GAME);
         appModule.addEventListener(ModuleEvent.DESTROY,this.closePlumberGame,false,0,true);
      }
      
      private function closePlumberGame(e:ModuleEvent) : void
      {
         if(e.data == true)
         {
            this.playMovie8();
         }
      }
      
      private function playMovie8() : void
      {
         this._movie = PlayMovie.play("resource/task/summerAct/movie8.swf",null,null,this.playMovie8Over);
      }
      
      private function playMovie8Over() : void
      {
         this._movie.destroy();
         this._movie = null;
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getPlumberInfoOver);
         finishSomethingRes.sendReq(31405);
      }
      
      private function getPlumberInfoOver(e:EventTaomee) : void
      {
         if(e.EventObj.Type == 31405)
         {
            this._plumberTimes = e.EventObj.Done;
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getPlumberInfoOver);
            if(this.gameStep == 2)
            {
               this.gameStep = 3;
            }
            BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1582Over,false,0,true);
            exchange.exchange_goods(1582);
         }
      }
      
      private function exchange1582Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1582)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1582Over);
            Alert.smileAlart("    疏通了水管，獲得海底樂園遊戲幣1枚！海洋娛樂協會聲望上升6！",function(e:Event):void
            {
               if(_plumberTimes < 1)
               {
                  SystemEventManager.addEventListener("goGame4",openMainUI,false,0,true);
                  MapManageView.inst.mapControl.map.mapSay(1);
               }
               else
               {
                  ModuleManager.openPanel(ModuleType.SUMMER_MAIN_PANEL,"m4");
               }
            });
         }
      }
      
      private function openMainUI(e:*) : void
      {
         SystemEventManager.removeEventListener("goGame4",this.openMainUI);
         ModuleManager.openPanel(ModuleType.SUMMER_MAIN_PANEL,"m4");
      }
      
      public function initTrans() : void
      {
         if(LocalUserInfo.getMapID() == 85)
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getTransOver);
            finishSomethingRes.sendReq(31406);
         }
      }
      
      private function getTransOver(e:EventTaomee) : void
      {
         var tFunc:Function = null;
         if(e.EventObj.Type == 31406)
         {
            BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getTransOver);
            if(e.EventObj.Done < 1 && this.gameStep >= 3)
            {
               tFunc = function():void
               {
                  SystemEventManager.addEventListener("playMovie7",playMovie7);
                  MapManageView.inst.mapControl.map.mapSay(2);
               };
               TweenLite.to(this,1,{"onComplete":tFunc});
            }
         }
      }
      
      private function playMovie7(e:*) : void
      {
         SystemEventManager.removeEventListener("playMovie7",this.playMovie7);
         this._movie = PlayMovie.play("resource/task/summerAct/movie7.swf",null,null,this.playMovie7Over);
      }
      
      private function playMovie7Over() : void
      {
         this._movie.destroy();
         this._movie = null;
         MapManageView.inst.mapControl.map.mapSay(4);
      }
      
      public function init83Map(e:* = null) : void
      {
         this.isTransing = true;
         HomeCarSocket.RentACar();
      }
      
      public function goDesOver() : void
      {
         var tFunc:Function = null;
         if(Boolean(GV.MAN_PEOPLE.hasCar) && this.isTransing)
         {
            GV.MC_mapFrame["depth_mc"].longxia.visible = true;
            tFunc = function():void
            {
               SystemEventManager.addEventListener("transTaskOver",transTaskOver,false,0,true);
               MapManageView.inst.mapControl.map.mapSay(2);
            };
            TweenLite.to(this,1,{"onComplete":tFunc});
         }
      }
      
      private function transTaskOver(e:*) : void
      {
         SystemEventManager.removeEventListener("transTaskOver",this.transTaskOver);
         this.isTransing = false;
         HomeCarSocket.DOWNCar();
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1583Over,false,0,true);
         exchange.exchange_goods(1583);
         BufferManager.setBuffer(BufferManager.MOLE_RABBIT,20);
      }
      
      private function exchange1583Over(e:EventTaomee) : void
      {
         if(e.EventObj.type == 1583)
         {
            BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.exchange1583Over);
            Alert.smileAlart("    運送一批零件，送你海底樂園遊戲幣1枚！海底娛樂協會聲望上升6！");
         }
      }
   }
}

