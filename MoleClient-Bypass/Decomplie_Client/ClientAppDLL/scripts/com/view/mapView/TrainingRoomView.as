package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.gotBigProp.GotPropOnlyOneTime;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.I_NPC;
   import com.module.npc.NPC;
   import com.module.npc.NPCEvent;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TrainingRoomView extends MapBase
   {
      
      private var npc:I_NPC;
      
      private var bounds_panel:MovieClip;
      
      public function TrainingRoomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,GV.onlineSocket,"give_bounds",this.giveBoundsCheck);
         BC.addEvent(this,GV.onlineSocket,"service_start",this.serviceStartHandler);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1994,this.giveBoundsHandler);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + -100161,this.giveBoundsHandler);
         BC.addEvent(this,GV.onlineSocket,"movie_start",this.movieStartHandler);
         BC.addEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.initNpc);
      }
      
      private function initNpc(e:NPCEvent) : void
      {
         BC.removeEvent(this,NPCEvent,NPCEvent.ON_NPC_LOADED,this.initNpc);
      }
      
      private function movieStartHandler(e:EventTaomee) : void
      {
         GV.onlineSocket.addEventListener("movie_over",this.onMovieOver);
         var loadGame:LoadGame = new LoadGame("resource/movie/lamuCooking.swf","正在打開......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function onMovieOver(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("movie_over",this.onMovieOver);
         _mapLevel.controlLevel["dish"].visible = true;
      }
      
      private function giveBoundsCheck(e:EventTaomee) : void
      {
         GotPropOnlyOneTime.trainingMarkRequest(5);
      }
      
      private function giveBoundsHandler(e:EventTaomee) : void
      {
         var txt:String = null;
         if(e.type != "ERROR_CMD_" + -100161)
         {
            txt = "    感謝你的參與，給你10個毛毛豆、10份面粉、10枚鴨蛋，在自己的餐廳中要好好利用這些原料哦。";
            Alert.smileAlart(txt,function():void
            {
            },"iknow",110);
         }
      }
      
      private function serviceStartHandler(e:EventTaomee) : void
      {
         this.npc.clearClass();
         MovieClip(_mapLevel.controlLevel["service_movie"]).visible = true;
         MovieClip(_mapLevel.controlLevel["service_movie"]).gotoAndPlay(2);
         BC.addEvent(this,GV.onlineSocket,"service_over",this.serviceOverHandler);
      }
      
      private function serviceOverHandler(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"service_over",this.serviceOverHandler);
         MovieClip(_mapLevel.controlLevel["service_movie"]).visible = false;
         this.npc = NPC.getNPCInstance(18,true);
      }
   }
}

