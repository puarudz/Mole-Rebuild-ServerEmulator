package com.view.mapView
{
   import com.core.info.ServerInfo;
   import com.event.EventTaomee;
   import com.logic.socket.SendGameSocreRegistSocket;
   import com.module.helpPanel.HelpPanel;
   import com.mole.app.map.MapBase;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class carMapView extends MapBase
   {
      
      public var SendGameSocre:SendGameSocreRegistSocket;
      
      private var taskStatus:Object;
      
      private var loader:Loader;
      
      public function carMapView()
      {
         super();
      }
      
      private function get target_mc() : MovieClip
      {
         return _mapLevel.controlLevel as MovieClip;
      }
      
      override protected function initView() : void
      {
         this.target_mc.annunciate_mc.buttonMode = true;
         this.target_mc.annunciate_mc.addEventListener(MouseEvent.MOUSE_OVER,this.carOver);
         this.target_mc.annunciate_mc.addEventListener(MouseEvent.MOUSE_OUT,this.carOut);
         this.target_mc.annunciate_mc.addEventListener(MouseEvent.CLICK,this.carClick);
         var ip:String = ServerInfo.getGameInfo(ServerInfo.IP);
         var port:int = ServerInfo.getGameInfo(ServerInfo.PORT);
         var obj:Object = {
            "ip":ip,
            "port":port,
            "gameID":5,
            "type":10
         };
         this.SendGameSocre = new SendGameSocreRegistSocket(obj);
         this.SendGameSocre.addEventListener(SendGameSocreRegistSocket.LIST_SEQUENCE,this.getGameResult);
      }
      
      public function getGameResult(E:EventTaomee) : void
      {
         var winnerObj:Object = null;
         var i:uint = 0;
         var tm:String = null;
         var twm:String = null;
         var listNameObj:Object = null;
         this.SendGameSocre.removeEventListener(SendGameSocreRegistSocket.LIST_SEQUENCE,this.getGameResult);
         if(E.EventObj.GameID == 5)
         {
            E.EventObj.listArr.sortOn("Score",16);
            for(i = 0; i < E.EventObj.Count; i++)
            {
               listNameObj = E.EventObj.listArr[i];
               if(listNameObj.Score != 0)
               {
                  winnerObj = listNameObj;
                  break;
               }
            }
            this.target_mc.note_mc.userInfo.id = winnerObj.UserID;
            this.target_mc.note_mc.userInfo.buttonMode = true;
            this.target_mc.note_mc["f_mc"].gotoAndStop(int(int(winnerObj.Score / 100) / 60) + 1);
            tm = String(int(winnerObj.Score / 100) % 60);
            if(tm.length == 1)
            {
               this.target_mc.note_mc["m1_mc"].gotoAndStop(1);
               this.target_mc.note_mc["m2_mc"].gotoAndStop(Number(tm.substr(0,1)) + 1);
            }
            else
            {
               this.target_mc.note_mc["m1_mc"].gotoAndStop(Number(tm.substr(0,1)) + 1);
               this.target_mc.note_mc["m2_mc"].gotoAndStop(Number(tm.substr(1,1)) + 1);
            }
            twm = String(winnerObj.Score - int(winnerObj.Score / 100) * 100);
            if(twm.length == 1)
            {
               this.target_mc.note_mc["wm1_mc"].gotoAndStop(1);
               this.target_mc.note_mc["wm2_mc"].gotoAndStop(Number(twm.substr(0,1)) + 1);
            }
            else
            {
               this.target_mc.note_mc["wm1_mc"].gotoAndStop(Number(twm.substr(0,1)) + 1);
               this.target_mc.note_mc["wm2_mc"].gotoAndStop(Number(twm.substr(1,1)) + 1);
            }
            this.target_mc.note_mc["username_txt"].text = winnerObj.Nick;
         }
      }
      
      private function carOver(evt:MouseEvent) : void
      {
         this.target_mc.annunciate_mc.gotoAndStop(2);
      }
      
      private function carOut(evt:MouseEvent) : void
      {
         this.target_mc.annunciate_mc.gotoAndStop(1);
      }
      
      private function carClick(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("carTip");
      }
      
      private function getSeverResult(evt:EventTaomee) : void
      {
         var frameNum:* = undefined;
         for(var i:int = 0; i < evt.EventObj.senceArr.length; i++)
         {
            frameNum = evt.EventObj.senceArr[i].started;
            this.target_mc.banner_mc.gotoAndStop(Number(frameNum) + 1);
         }
      }
      
      override public function destroy() : void
      {
         this.target_mc.annunciate_mc.removeEventListener(MouseEvent.MOUSE_OVER,this.carOver);
         this.target_mc.annunciate_mc.removeEventListener(MouseEvent.MOUSE_OUT,this.carOut);
         this.target_mc.annunciate_mc.removeEventListener(MouseEvent.CLICK,this.carClick);
         super.destroy();
      }
   }
}

