package com.view.mapView
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.utils.PlayMovie;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TVWallView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var btn_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var tempLoader:Loader;
      
      private var Movie:Sprite;
      
      private var playInt:int;
      
      private var _movie:PlayMovie;
      
      public function TVWallView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.btn_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["buttonLevel"];
         if(this.checkTask590())
         {
            return;
         }
         this.tempLoader = new Loader();
         this.tempLoader.load(new URLRequest("module/flvMovie/TVPlayer.swf"));
         BC.addEvent(this,this.tempLoader.contentLoaderInfo,Event.COMPLETE,this.completeHandler);
      }
      
      private function onClickBtn(e:MouseEvent) : void
      {
         MapManager.clearMap();
         this._movie = PlayMovie.play("resource/movie/magicMovie.swf",null,null,this.playMovieOver);
      }
      
      private function playMovieOver() : void
      {
         this._movie.destroy();
         this._movie = null;
         ModuleManager.openPanel("MagicSealGamePanel");
      }
      
      private function checkTask590() : Boolean
      {
         var task590:Task = TaskManager.getTask(590);
         if(Boolean(task590) && task590.state == TaskStateType.OPEN)
         {
            if(task590.buffer.step == 4 || task590.buffer.step == 5)
            {
               return true;
            }
         }
         return false;
      }
      
      private function playMovie() : void
      {
         for(var i:int = 0; i < 7; i++)
         {
            this.target_mc["movieBtn" + i].buttonMode = true;
            BC.addEvent(this,this.target_mc["movieBtn" + i],MouseEvent.CLICK,this.playClickHnalder);
            if(Boolean(i > 1) && Boolean(this.target_mc["movieBtn" + i]) && i < 4)
            {
               tip.tipTailDisPlayObject(this.target_mc["movieBtn" + i],"敬請期待");
            }
         }
         BC.addEvent(this,this.Movie,"onStatus",this.changeStatus);
         BC.addEvent(this,this.target_mc.b1_btn,MouseEvent.CLICK,this.playfun);
         BC.addEvent(this,this.target_mc.b2_btn,MouseEvent.CLICK,this.soundfun);
         BC.addEvent(this,this.target_mc.b3_btn,MouseEvent.CLICK,this.goFullScreen);
         BC.addEvent(this,this.top_mc.stage,Event.RESIZE,this.resizeHandler);
      }
      
      public function resizeHandler(E:Event) : void
      {
         if(this.top_mc.stage.displayState == "fullScreen")
         {
            MainManager.getRootMC().parent.addChild(this.Movie);
            MainManager.getRootMC().visible = false;
         }
         else
         {
            this.target_mc.tvMC.movie_mc.addChild(this.Movie);
            MainManager.getRootMC().visible = true;
         }
      }
      
      private function playfun(E:MouseEvent = null) : void
      {
         this.Movie["controlMC"].play_icon.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function soundfun(E:MouseEvent) : void
      {
         this.Movie["controlMC"].mute_button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function listfun(E:MouseEvent) : void
      {
         this.Movie["controlMC"].more_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function goFullScreen(E:MouseEvent) : void
      {
         this.Movie["controlMC"].fullScreen_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         this.changeStatus();
      }
      
      private function changeStatus(E:Event = null) : void
      {
         MovieClip(this.target_mc.b1_btn).gotoAndStop(this.Movie["controlMC"].play_icon.currentFrame);
         MovieClip(this.target_mc.b2_btn).gotoAndStop(this.Movie["controlMC"].mute_button.currentFrame);
         MovieClip(this.target_mc.b3_btn).gotoAndStop(this.Movie["controlMC"].fullScreen_btn.currentFrame);
         if(MovieClip(this.target_mc.b1_btn).currentFrame == 1)
         {
            this.playVidonEvent(0);
         }
         else
         {
            this.playVidonEvent(this.playInt);
         }
      }
      
      private function playClickHnalder(evt:MouseEvent) : void
      {
         this.playInt = int(String(evt.currentTarget.name.substr(-1)));
         if(this.playInt == 0)
         {
            this.playVidonEvent(this.playInt);
            this.Movie["playVideo"](this.playInt);
         }
         else if(this.playInt == 1)
         {
            this.playVidonEvent(this.playInt);
            this.Movie["tvTypeEvent"](["3.swf","4.flv"],1);
         }
         else if(this.playInt == 4 || this.playInt == 5)
         {
            this.playVidonEvent(this.playInt);
            this.Movie["tvTypeEvent"]([this.playInt + 1 + ".flv"],1);
         }
      }
      
      private function playVidonEvent(_i:int) : void
      {
         if(_i == 0)
         {
            this.target_mc.moveMC0.gotoAndStop(1);
            this.target_mc.moveMC1.gotoAndStop(1);
            this.target_mc.moveMC2.gotoAndStop(1);
            this.target_mc.moveMC3.gotoAndStop(1);
         }
         else if(_i < 4)
         {
            this.target_mc.moveMC0.gotoAndPlay(2);
            this.target_mc.moveMC1.gotoAndPlay(2);
            this.target_mc.moveMC2.gotoAndStop(1);
            this.target_mc.moveMC3.gotoAndStop(1);
         }
         else
         {
            this.target_mc.moveMC0.gotoAndStop(1);
            this.target_mc.moveMC1.gotoAndStop(1);
            this.target_mc.moveMC2.gotoAndPlay(2);
            this.target_mc.moveMC3.gotoAndPlay(2);
         }
      }
      
      private function completeHandler(e:Event) : void
      {
         this.target_mc.moveMC0.gotoAndPlay(2);
         this.target_mc.moveMC1.gotoAndPlay(2);
         this.target_mc.moveMC2.gotoAndStop(2);
         this.target_mc.moveMC3.gotoAndStop(2);
         this.Movie = e.target.content;
         this.target_mc.tvMC.movie_mc.addChild(this.Movie);
         this.Movie["init"](this.target_mc.tvMC.movie_mc.rect_mc.width,this.target_mc.tvMC.movie_mc.rect_mc.height);
         this.playMovie();
      }
      
      override public function destroy() : void
      {
         if(this.Movie != null)
         {
            this.Movie["clearClass"]();
         }
         this.Movie = null;
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
   }
}

