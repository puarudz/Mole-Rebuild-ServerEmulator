package com.mole.app.task.action
{
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.app.utils.PlayMovie;
   import com.view.mapView.activity.Task83.SoundManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class TaskPlayMovieAction extends TaskActionBase
   {
      
      public static const TASK_MOVIE_PATH:String = "resource/newTask/task";
      
      private static var _isPlayCount:uint = 0;
      
      private var _name:String;
      
      private var _isBg:Boolean;
      
      private var _isFullScreen:Boolean;
      
      private var _hideBg:Boolean;
      
      private var _isStopSound:Boolean;
      
      private var _isShowOthersMole:Boolean;
      
      private var _isMouseDisable:Boolean;
      
      private var _nowPlayMovieClipId:String;
      
      private var _isHideOtherMole:Boolean;
      
      private var _playMovie:PlayMovie;
      
      public function TaskPlayMovieAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._name = "TaskMovie_" + _parent.step.task.id + "_" + actionXml.@Name;
         this._isBg = uint(actionXml.@IsBg) == 1;
         this._isFullScreen = uint(actionXml.@IsFullScreen) == 1;
         this._hideBg = uint(actionXml.@hideBg) == 1;
         this._isStopSound = uint(actionXml.@IsStopSound) == 1;
         this._isShowOthersMole = uint(actionXml.@IsShowOthersMole) == 1;
         this._isMouseDisable = uint(actionXml.@IsMouseDisable) == 1;
      }
      
      override public function execute() : void
      {
         var parent_mc:DisplayObjectContainer = null;
         if(this._nowPlayMovieClipId == this.resID)
         {
            return;
         }
         this._nowPlayMovieClipId = this.resID;
         var mc:Sprite = new Sprite();
         mc.name = this._name;
         if(this._isFullScreen)
         {
            parent_mc = LevelManager.topLevel;
         }
         else
         {
            parent_mc = LevelManager.mapMovieLevel;
         }
         parent_mc.addChild(mc);
         if(this._isShowOthersMole == false)
         {
            if(_isPlayCount == 0)
            {
               this._isHideOtherMole = LocalUserInfo.getIsHideOtherMole();
               if(this._isHideOtherMole == false)
               {
                  LocalUserInfo.setIsHideOtherMole(true);
               }
            }
         }
         ++_isPlayCount;
         this._playMovie = PlayMovie.play(TASK_MOVIE_PATH + _parent.step.task.id + "/movie/task_movie_" + _parent.step.task.id + "_" + this.resID + ".swf",null,null,this.onPlayMovieComplete,null,mc,this._isBg,"正在加載任務動畫",this._hideBg);
         this._playMovie.addEventListener(PlayMovie.MOVIE_PALY_OVER,this.onDestroyMovie);
         if(this._isStopSound)
         {
            SoundManager.stopAll();
         }
         mc.mouseChildren = mc.mouseEnabled = !this._isMouseDisable;
      }
      
      private function onDestroyMovie(e:Event) : void
      {
         this.destroyMovie();
      }
      
      private function destroyMovie() : void
      {
         if(Boolean(this._playMovie))
         {
            if(Boolean(this._playMovie.movie_mc))
            {
               this._playMovie.movie_mc.stop();
            }
            this._playMovie.removeEventListener(PlayMovie.MOVIE_PALY_OVER,this.onDestroyMovie);
            this._playMovie = null;
            if(this._isShowOthersMole == false)
            {
               --_isPlayCount;
               if(_isPlayCount == 0)
               {
                  if(this._isHideOtherMole == false)
                  {
                     LocalUserInfo.setIsHideOtherMole(false);
                  }
               }
            }
            if(this._isStopSound)
            {
               SoundManager.openAll();
            }
         }
      }
      
      private function onPlayMovieComplete() : void
      {
         this.destroyMovie();
         nextAction();
      }
      
      private function get resID() : String
      {
         return _param;
      }
      
      override public function destroy() : void
      {
         this.destroyMovie();
         super.destroy();
      }
   }
}

