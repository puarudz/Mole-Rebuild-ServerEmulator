package com.module.screenMovie
{
   import com.core.gameSimulator.SEI;
   import com.core.gameSimulator.SEI_Event;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class screenMovie extends EventDispatcher
   {
      
      private static var owner:screenMovie;
      
      private static var movieURL:String;
      
      public static var PLAY_COMPLETE:String = "play_complete";
      
      private var ts:Sprite;
      
      public function screenMovie()
      {
         super();
         BC.addEvent(this,SEI.getSEI(),SEI.CONVEYANCE,this.conveyanceDispatch);
         owner = this;
      }
      
      public static function getInstance() : screenMovie
      {
         if(Boolean(owner))
         {
            return owner;
         }
         return new screenMovie();
      }
      
      public function loadMovie(_movieURL:String) : void
      {
         if(movieURL == _movieURL)
         {
            return;
         }
         movieURL = _movieURL;
         BC.addEvent(this,SEI.getSEI(),SEI_Event.REVERT_GAME_MSG,this.onConnection);
         BC.addEvent(this,SEI.getSEI(),SEI_Event.REVERT_GAME_MSG,this.onPlayEnd);
         BC.addEvent(this,SEI.getSEI(),SEI_Event.ON_CONNECTION_ERROR,this.onErrorHandler);
         this.ts = new Sprite();
         GV.MC_AppLever.addChild(this.ts);
         var tempMC:MCLoader = new MCLoader(_movieURL,this.ts,Loading.TITLE_AND_PERCENT,"正在打開......");
         BC.addEvent(this,tempMC,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         BC.addEvent(this,tempMC,MCLoadEvent.ERROR,this.onErrorHandler);
         tempMC.doLoad();
      }
      
      private function loadPassHandler(E:*) : void
      {
         GC.clearAll(this.ts);
         BC.removeEvent(owner,null,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         BC.removeEvent(owner,null,MCLoadEvent.ERROR,this.onErrorHandler);
         SEI.getSEI().openGame(10000);
      }
      
      private function onConnection(E:EventTaomee) : void
      {
         if(SEI.gameID == 10000 && E.EventObj == Event.INIT)
         {
            BC.removeEvent(owner,SEI.getSEI(),SEI_Event.REVERT_GAME_MSG,this.onConnection);
            BC.addEvent(owner,SEI.getSEI(),SEI_Event.REVERT_GAME_OBJ,this.conveyanceDispatch);
            SEI.getSEI().sendMainObj({
               "type":"loadMovie",
               "url":movieURL
            });
         }
      }
      
      private function onErrorHandler(E:*) : void
      {
         GC.clearAll(this.ts);
         BC.removeEvent(owner,null,MCLoadEvent.ON_SUCCESS,this.loadPassHandler);
         BC.removeEvent(owner,null,MCLoadEvent.ERROR,this.onErrorHandler);
         movieURL = "";
      }
      
      private function onPlayEnd(E:EventTaomee) : void
      {
         if(SEI.gameID == 10000 && E.EventObj == Event.UNLOAD)
         {
            dispatchEvent(new EventTaomee(PLAY_COMPLETE));
            movieURL = "";
         }
      }
      
      private function conveyanceDispatch(E:EventTaomee) : void
      {
         var obj:Object = null;
         if(SEI.gameID == 10000)
         {
            obj = E.EventObj;
            dispatchEvent(new EventTaomee(obj.type,obj.data));
         }
      }
   }
}

