package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.raceSport.RaceSportJoin;
   import com.module.loadExtentPanel.LoadGame;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Map85AddMakeCar extends Sprite
   {
      
      public var target_mc:MovieClip;
      
      private var url:String;
      
      private var betaFlag:Boolean = false;
      
      private var davidFlag:Boolean = false;
      
      private var flag_1300001:Boolean = false;
      
      private var flag_1300003:Boolean = false;
      
      public function Map85AddMakeCar()
      {
         super();
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventFun);
         this.target_mc = GV.MC_mapFrame["control_mc"];
         BC.addEvent(this,this.target_mc.add_makeCar_btn,MouseEvent.CLICK,this.chartTeamFun);
         BC.addEvent(this,this.target_mc.add_makeCar_btn,MouseEvent.MOUSE_OVER,this.overFun);
         BC.addEvent(this,this.target_mc.add_makeCar_btn,MouseEvent.MOUSE_OUT,this.outFun);
         this.target_mc.makeCar_mc.gotoAndStop(1);
      }
      
      private function chartTeamFun(eve:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 1707,this.check1300001Back);
         RaceSportJoin.isHaveCar(1300001);
      }
      
      private function check1300001Back(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1707,this.check1300001Back);
         if(eve.EventObj.Count > 0)
         {
            this.flag_1300001 = true;
         }
         BC.addEvent(this,GV.onlineSocket,"read_" + 1707,this.check1300003Back);
         RaceSportJoin.isHaveCar(1300003);
      }
      
      private function check1300003Back(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1707,this.check1300003Back);
         if(evt.EventObj.Count > 0)
         {
            this.flag_1300003 = true;
         }
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBack);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190435,2,190437);
      }
      
      private function getItemCountBack(evt:EventTaomee = null) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getItemCountBack);
         var obj:Object = evt.EventObj.obj;
         this.target_mc.makeCar_mc.gotoAndStop(11);
         if(obj.Count <= 0)
         {
            msg = "    要帶著設計圖才能制造炫風車哦，快去旁邊的桌上挑選設計圖吧！";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
            return;
         }
         if(obj.arr[0].id == 190435)
         {
            this.betaFlag = true;
            if(this.flag_1300001)
            {
               msg = "    貝塔螺旋動力炫風車已經放入你的車庫中了！";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
               return;
            }
            BC.addEvent(this,GV.onlineSocket,"makecar85_close",this.overAddGame);
            this.url = "module/external/MakeCarsGameTwo.swf";
         }
         else if(obj.arr[0].id == 190436)
         {
            this.davidFlag = true;
            if(this.flag_1300003)
            {
               msg = "    大衛三葉草炫風車已經放入你的車庫中了！";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
               return;
            }
            BC.addEvent(this,GV.onlineSocket,"makecar85_close",this.overAddGame);
            this.url = "module/external/MakeCarsGame.swf";
         }
         msg = "正在加載生產流程";
         var loadGame:LoadGame = new LoadGame(this.url,msg,MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function overAddGame(eve:EventTaomee) : void
      {
         var temp:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,"makecar85_close",this.overAddGame);
         if(Boolean(eve.EventObj.bln))
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1568,this.getCarFun);
            if(this.betaFlag)
            {
               RaceSportJoin.getCarItem(1300001);
            }
            else if(this.davidFlag)
            {
               RaceSportJoin.getCarItem(1300003);
            }
         }
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
      }
      
      private function getCarFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1568,this.getCarFun);
         var msg:String = "";
         if(this.betaFlag)
         {
            msg = "    恭喜你，貝塔螺旋動力炫風車已經放入你的車庫中了！";
         }
         else if(this.davidFlag)
         {
            msg = "    恭喜你，大衛三葉草炫風車已經放入你的車庫中了！";
         }
         Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
      }
      
      private function overFun(eve:MouseEvent) : void
      {
         this.target_mc.makeCar_mc.gotoAndPlay(2);
      }
      
      private function outFun(eve:MouseEvent) : void
      {
         this.target_mc.makeCar_mc.gotoAndStop(1);
      }
      
      private function removeEventFun(eve:* = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventFun);
         BC.removeEvent(this);
      }
   }
}

