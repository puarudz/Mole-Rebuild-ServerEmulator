package com.mole.app.utils
{
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.ui.LoadingPanel;
   import com.mole.debug.DebugManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PlayMovie extends EventDispatcher
   {
      
      public static const MOVIE_PALY_OVER:String = "PlayMovie_Over";
      
      public static const SKIP_MOVIE:String = "PlayMovie_Skip";
      
      private var _actived:Boolean;
      
      private var _isBg:Boolean;
      
      private var _hideBg:Boolean;
      
      private var _loadFun:Function;
      
      private var _loadParam:Array;
      
      private var _backFun:Function;
      
      private var _backParam:Array;
      
      private var _parentMC:DisplayObjectContainer;
      
      private var _resID:uint;
      
      private var _url:String;
      
      private var _movie_mc:MovieClip;
      
      private var _movie_loader:Loader;
      
      public function PlayMovie()
      {
         super();
      }
      
      public static function play(url:String, loadFun:Function = null, loadParam:Array = null, backFun:Function = null, backParam:Array = null, parentMC:DisplayObjectContainer = null, isBg:Boolean = true, desc:String = "Loading...", hideBg:Boolean = false) : PlayMovie
      {
         var playMovie:PlayMovie = new PlayMovie();
         playMovie.play(url,loadFun,loadParam,backFun,backParam,parentMC,isBg,desc,hideBg);
         return playMovie;
      }
      
      public function play(url:String, loadFun:Function = null, loadParam:Array = null, backFun:Function = null, backParam:Array = null, parentMC:DisplayObjectContainer = null, isBg:Boolean = true, desc:String = "Loading...", hideBg:Boolean = false) : void
      {
         this._actived = true;
         this._loadFun = loadFun;
         this._loadParam = loadParam;
         this._backFun = backFun;
         this._backParam = backParam;
         this._parentMC = parentMC;
         this._isBg = isBg;
         this._hideBg = hideBg;
         this._url = url;
         this._resID = DownLoadManager.add(this._url,ResType.DISPLAY_OBJECT,true,desc);
         DownLoadManager.addEvent(this._resID,this.onLoaderMovieSucceed,null,null,this.onLoaderMovieFail);
         LoadingPanel.isShowClose = false;
         LoadingPanel.addRes(this._resID);
         GV.onlineSocket.addEventListener(MapEvent.READY_CHANGE_MAP,this.onDestroyMovie);
         if(DebugManager.DEBUG)
         {
            SystemEventManager.addEventListener(SKIP_MOVIE,this.onSkipMovie);
         }
      }
      
      private function onSkipMovie(e:Event) : void
      {
         this._movie_mc.gotoAndPlay(this._movie_mc.totalFrames);
      }
      
      private function onDestroyMovie(e:Event) : void
      {
         this.destroy();
      }
      
      private function onLoaderMovieSucceed(e:DownLoadEvent) : void
      {
         this._movie_mc = e.data as MovieClip;
         this._movie_loader = e.loader;
         if(this._parentMC == null)
         {
            LevelManager.appLevel.addChild(this._movie_mc);
         }
         else
         {
            this._parentMC.addChild(this._movie_mc);
         }
         if(this._isBg)
         {
            this._movie_mc.addChildAt(LevelManager.drawBG(0,0),0);
         }
         if(this._hideBg)
         {
            LevelManager.mapLevel.visible = false;
         }
         if(this._loadFun != null)
         {
            this._loadFun.apply(null,this._loadParam);
         }
         MovieClipUtil.playEndAndFunc(this._movie_mc,this.onPlayOver);
      }
      
      private function onLoaderMovieFail(e:DownLoadEvent) : void
      {
         this.destroy();
      }
      
      private function onPlayOver() : void
      {
         if(this._hideBg)
         {
            LevelManager.mapLevel.visible = true;
         }
         this._movie_mc.stop();
         if(this._backFun != null)
         {
            this._backFun.apply(null,this._backParam);
         }
         else
         {
            this.destroy();
         }
      }
      
      public function destroy() : void
      {
         if(this._actived)
         {
            SystemEventManager.removeEventListener(SKIP_MOVIE,this.onSkipMovie);
            GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.onDestroyMovie);
            this._actived = false;
            this._loadFun = null;
            this._loadParam = null;
            this._backFun = null;
            this._backParam = null;
            this._parentMC = null;
            DisplayUtil.removeForParent(this._movie_mc);
            if(Boolean(this._movie_loader))
            {
               this._movie_loader.unload();
            }
            DownLoadManager.remove(this._resID);
            dispatchEvent(new Event(MOVIE_PALY_OVER));
         }
      }
      
      public function get actived() : Boolean
      {
         return this._actived;
      }
      
      public function get movie_mc() : MovieClip
      {
         return this._movie_mc;
      }
   }
}

