package com.view.mapView
{
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.module.activityModule.Presented;
   import com.mole.app.utils.PlayMovie;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ShowMapViewGame
   {
      
      private var _thinkMC:MovieClip;
      
      private var _cut_mc:MovieClip;
      
      private var _add_mc:MovieClip;
      
      private var _heartCount_mc:MovieClip;
      
      private var _heartCount:int = 1;
      
      private var _ask_mc:MovieClip;
      
      private var _right_mc:MovieClip;
      
      private var _wrong_mc:MovieClip;
      
      private var _cat_mc:MovieClip;
      
      private var _begin_btn:SimpleButton;
      
      private var _randomArr:Array;
      
      private var _btnArr:Array;
      
      private var _count:int = 0;
      
      private var _panel:MovieClip;
      
      private var _task_movie_2:PlayMovie;
      
      private var _close_btn:SimpleButton;
      
      private var _isClose:Boolean;
      
      public function ShowMapViewGame()
      {
         super();
         this._panel = this._panel;
      }
      
      public function GreedCatgamePanel(panel:MovieClip) : void
      {
         this._panel = panel;
         this._close_btn = this._panel["close_btn"];
         this._thinkMC = this._panel["think_mc"];
         this._cut_mc = this._panel["cut_mc"];
         this._cut_mc.gotoAndStop(1);
         this._add_mc = this._panel["add_mc"];
         this._add_mc.gotoAndStop(1);
         this._ask_mc = this._panel["ask_mc"];
         this._begin_btn = this._panel["begin_btn"];
         this._wrong_mc = this._panel["wrong_mc"];
         this._cat_mc = this._panel["cat_mc"];
         this._right_mc = this._panel["right_mc"];
         this._begin_btn.addEventListener(MouseEvent.CLICK,this.onBeginClickHandle);
         this._close_btn.addEventListener(MouseEvent.CLICK,this.onColseClickHandle);
         this._close_btn.visible = false;
         this._ask_mc.gotoAndStop(1);
         this._ask_mc.visible = false;
         this._heartCount_mc = this._panel["heartCount_mc"];
         this._heartCount_mc.gotoAndStop(1);
         this._thinkMC.visible = false;
      }
      
      private function onBeginClickHandle(e:MouseEvent) : void
      {
         this._task_movie_2 = PlayMovie.play("resource/newTask/task10009/task_10009_2.swf",null,null,function():void
         {
            _task_movie_2.destroy();
            addBtnEvent();
            isCanClickBtn(false);
            playCatThink();
            LocalUserInfo.setIsHideOtherMole(true);
            _close_btn.visible = true;
            _isClose = false;
            _begin_btn.visible = false;
            _heartCount = 1;
         },null,null,false);
      }
      
      private function addBtnEvent() : void
      {
         var btn:SimpleButton = null;
         this._btnArr = new Array();
         for(var i:int = 0; i < 5; i++)
         {
            btn = this._panel["btn_" + i] as SimpleButton;
            btn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandle);
            this._btnArr.push(btn);
         }
      }
      
      private function onBtnClickHandle(e:MouseEvent) : void
      {
         this.isCanClickBtn(false);
         this._ask_mc.visible = false;
         var btn:SimpleButton = e.target as SimpleButton;
         var index:int = this._btnArr.indexOf(btn);
         if(index == int(this._randomArr[int(this._randomArr[2])]))
         {
            this._heartCount += 2;
            this._add_mc.gotoAndPlay(1);
            this._right_mc.gotoAndPlay(1);
            this._right_mc.x = btn.x;
            this._right_mc.y = btn.y;
            this._cat_mc.gotoAndStop(3);
         }
         else
         {
            this._wrong_mc.gotoAndPlay(1);
            --this._heartCount;
            this._cut_mc.gotoAndPlay(1);
            this._wrong_mc.x = btn.x;
            this._wrong_mc.y = btn.y;
            this._cat_mc.gotoAndStop(4);
         }
         if(this._heartCount <= 0)
         {
            this._heartCount = 1;
         }
         this._heartCount_mc.gotoAndStop(this._heartCount);
         if(this._heartCount >= 11)
         {
            this._cat_mc.gotoAndStop(5);
            this.onColseClickHandle();
            LocalUserInfo.setIsHideOtherMole(false);
            this._heartCount = 1;
            Presented.getInstance().celebrate1225(2073);
         }
         else
         {
            this.playCatThink();
         }
      }
      
      private function isCanClickBtn(bool:Boolean) : void
      {
         for(var i:int = 0; i < this._btnArr.length; i++)
         {
            (this._btnArr[i] as SimpleButton).mouseEnabled = bool;
         }
      }
      
      private function playCatThink() : void
      {
         var arr:Array = [4,2,1,3,0];
         this._randomArr = this.randomArr(arr);
         this._count = 0;
         this.playMovie();
      }
      
      private function playMovie() : void
      {
         var time:int = 1500;
         setTimeout(function():void
         {
            if(_isClose)
            {
               return;
            }
            if(_count > 4)
            {
               _thinkMC.visible = false;
               _ask_mc.visible = true;
               (_ask_mc["num_mc"] as MovieClip).gotoAndStop(int(_randomArr[2]) + 1);
               _ask_mc.gotoAndPlay(1);
               MovieClipUtil.playEndAndFunc(_ask_mc,function():void
               {
                  _ask_mc.stop();
                  isCanClickBtn(true);
               });
               return;
            }
            _cat_mc.gotoAndStop(2);
            _thinkMC.visible = true;
            _thinkMC.gotoAndStop(int(_randomArr[_count]) + 1);
            ++_count;
            playMovie();
         },time);
      }
      
      private function randomArr(arr:Array) : Array
      {
         var outputArr:Array = arr.slice();
         var i:int = int(outputArr.length);
         while(Boolean(i))
         {
            outputArr.push(outputArr.splice(int(Math.random() * i--),1));
         }
         return outputArr;
      }
      
      private function onColseClickHandle(e:MouseEvent = null) : void
      {
         for(var i:int = 0; i < this._btnArr.length; i++)
         {
            (this._btnArr[i] as SimpleButton).removeEventListener(MouseEvent.CLICK,this.onBtnClickHandle);
         }
         this._heartCount_mc.gotoAndStop(1);
         this._cut_mc.gotoAndStop(1);
         this._add_mc.gotoAndStop(1);
         this._ask_mc.gotoAndStop(1);
         this._begin_btn.visible = true;
         this._close_btn.visible = false;
         this._thinkMC.visible = false;
         this._isClose = true;
         this._heartCount = 1;
      }
   }
}

