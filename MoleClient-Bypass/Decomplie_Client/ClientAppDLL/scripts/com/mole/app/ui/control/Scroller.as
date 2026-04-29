package com.mole.app.ui.control
{
   import com.common.Tween.TweenLite;
   import com.common.util.DisplayUtil;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import fl.motion.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Scroller extends Sprite
   {
      
      protected static const conName:String = "container";
      
      private var _panel:MovieClip;
      
      private var _btn:SimpleButton;
      
      protected var _container:MovieClip;
      
      protected var _itemInfoArr:Array;
      
      protected var _elementArr:Array;
      
      protected var _itemArrLen:int;
      
      private var _targetIndex:int;
      
      protected var _elementW:int;
      
      protected var _elementH:int;
      
      protected var _maskRect:Rectangle;
      
      private var _isShow:Boolean;
      
      protected var _elementIndex:int;
      
      private var _scrollTime:Number;
      
      private var _stMax:Number;
      
      private var _stMin:Number;
      
      public var endFunc:Function;
      
      public var clickFunc:Function;
      
      protected var _showTip:Boolean;
      
      private var _waitTime:Number;
      
      private var s:Sprite;
      
      public function Scroller(panel:MovieClip, itemInfoArr:Array = null, maskRect:Rectangle = null, scrollTime:Number = 0.2, waitTime:Number = 0, stMax:Number = 0.6, showTip:Boolean = true)
      {
         super();
         this._panel = panel;
         this.initUI();
         this.initData(maskRect,scrollTime,waitTime,stMax,showTip);
         this.initItemArr(itemInfoArr);
      }
      
      protected function initUI() : void
      {
         this._btn = this._panel["btn"];
         this._container = this._panel["container"];
         addChild(this._panel);
      }
      
      protected function initData(maskRect:Rectangle, scrollTime:Number, waitTime:Number, stMax:Number, showTip:Boolean) : void
      {
         this._itemInfoArr = [];
         this._elementArr = [];
         this._itemArrLen = 0;
         this._targetIndex = -1;
         this._elementW = maskRect.width;
         this._elementH = maskRect.height;
         this._maskRect = maskRect;
         this._scrollTime = scrollTime;
         this._waitTime = waitTime;
         this._stMin = scrollTime;
         this._stMax = stMax;
         this._showTip = showTip;
         this._isShow = false;
      }
      
      private function configListeners() : void
      {
         if(this._btn != null)
         {
            BC.addEvent(this,this._btn,MouseEvent.CLICK,this.clickBtn,false,0,true);
         }
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.removeMapFunc,false,0,true);
      }
      
      protected function clickBtn(e:MouseEvent) : void
      {
      }
      
      protected function addElement() : void
      {
      }
      
      private function addMask() : void
      {
         this.s = LevelManager.drawBG(0,0.3,this._maskRect);
         this._container.addChild(this.s);
         this.s.x = this._maskRect.x;
         this.s.y = this._maskRect.y;
         this._container.mask = this.s;
      }
      
      public function beginShow() : void
      {
         if(!this._isShow)
         {
            this._isShow = true;
            this.showNextElement();
         }
      }
      
      private function showNextElement() : void
      {
         var s:Sprite = null;
         var scrollOver:Function = null;
         var func:Function = null;
         if(this._isShow)
         {
            s = this.getContainer();
            scrollOver = function():void
            {
               s.y = 0;
               changeIconY();
               ++_elementIndex;
               if(_elementIndex == _itemArrLen)
               {
                  _elementIndex = 0;
               }
               if(_targetIndex == -1)
               {
                  showNextElement();
               }
               else if(_elementIndex != _targetIndex)
               {
                  if(_scrollTime < _stMax)
                  {
                     _scrollTime += 0.1;
                  }
                  showNextElement();
               }
               else
               {
                  stopShow();
                  if(endFunc != null)
                  {
                     endFunc.apply();
                  }
                  _targetIndex = -1;
                  _scrollTime = _stMin;
               }
            };
            func = function():void
            {
               new TweenLite(s,_scrollTime,{
                  "y":_elementH,
                  "onComplete":scrollOver,
                  "ease":Linear.easeNone
               });
            };
            if(this._waitTime > 0)
            {
               new TweenLite(s,this._waitTime,{"onComplete":func});
            }
            else
            {
               func.apply(null,null);
            }
         }
      }
      
      private function changeIconY() : void
      {
         for(var i:int = 0; i < this._itemArrLen; i++)
         {
            if(this._elementArr[i].y == 0)
            {
               this._elementArr[i].y = -(this._itemArrLen - 1) * this._elementH;
            }
            else
            {
               this._elementArr[i].y += this._elementH;
            }
         }
      }
      
      private function stopShow() : void
      {
         this._isShow = false;
      }
      
      public function initItemArr(itemInfoArr:Array) : void
      {
         if(itemInfoArr == null)
         {
            return;
         }
         this._itemInfoArr = itemInfoArr;
         this._itemArrLen = this._itemInfoArr.length;
         this.configListeners();
         this.addElement();
         this.addMask();
      }
      
      public function get panel() : MovieClip
      {
         return this._panel;
      }
      
      public function get itemInfoArr() : Array
      {
         return this._itemInfoArr;
      }
      
      public function get targetIndex() : int
      {
         return this._targetIndex;
      }
      
      public function set targetIndex(targetIndex:int) : void
      {
         this._targetIndex = targetIndex;
      }
      
      public function get elementIndex() : int
      {
         return this._elementIndex;
      }
      
      public function get btn() : SimpleButton
      {
         return this._btn;
      }
      
      protected function getContainer() : Sprite
      {
         return this._container.getChildByName(conName) as Sprite;
      }
      
      private function removeMapFunc(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.s);
         this._itemInfoArr = null;
         this._elementArr = null;
         BC.removeEvent(this);
         TweenLite.killTweensOf(this.getContainer());
      }
   }
}

