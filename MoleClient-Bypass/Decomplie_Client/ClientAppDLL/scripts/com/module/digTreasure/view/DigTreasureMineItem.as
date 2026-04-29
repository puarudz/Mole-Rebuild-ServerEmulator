package com.module.digTreasure.view
{
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.digTreasure.DigTreasureSocket;
   import com.module.LocusWork.MCContorl;
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.data.DigTreasureConfig;
   import com.view.baseViewCtl.ProgressbarControler;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DigTreasureMineItem extends DigTreasureItem implements IDigTreasureItemCtl
   {
      
      private var _maxDigCount:int;
      
      private var _digCountProgressBar:ProgressbarControler;
      
      public function DigTreasureMineItem()
      {
         super();
      }
      
      override public function StartDig(tragger:IDigTreasureItemCtl = null) : void
      {
         var idgProgressBar:MovieClip = null;
         if(!IsMoleHitItem())
         {
            return;
         }
         ClearMouseEvent();
         idgProgressBar = DigTreasureConfig.instance.GetMovieClip("digTimerBar");
         MainManager.getAppLevel().addChild(idgProgressBar);
         idgProgressBar.x = _ui.x;
         idgProgressBar.y = _ui.y - idgProgressBar.height;
         ShowUseHpEffect();
         PlayMoleAction();
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = idgProgressBar;
         var _temp_1:* = "digTreasure_digProgressOver";
         with({})
         {
            _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function progressHandler(e:Event):void
            {
               GC.clearAll(idgProgressBar);
               InitMouseEvent();
               SendDigCmd();
               StopMoleAction();
            });
            idgProgressBar.gotoAndPlay(2);
            ShowEffect();
         }
         
         override protected function DigCmdHandler(e:EventTaomee) : void
         {
            if(e.EventObj.index == index)
            {
               BC.removeEvent(this,GV.onlineSocket,"read_" + DigTreasureSocket.DigAreaCmd,this.DigCmdHandler);
               this.SetDigCount(e.EventObj.digCount);
               this._digCountProgressBar.SetData(_digCount,this._maxDigCount);
               ShowAwards(e.EventObj.awards);
               ShowAddedExpEffect();
            }
         }
         
         override public function SetConfig(config:XML, index:int) : void
         {
            super.SetConfig(config,index);
            this._maxDigCount = int(_config.@ExplCount);
            if(Boolean(_tipMC.bar_mc))
            {
               this._digCountProgressBar = new ProgressbarControler(_tipMC.bar_mc);
            }
            else
            {
               this._digCountProgressBar = new ProgressbarControler(new MovieClip());
            }
            _tipMC.name_txt.text = _name;
            _tipMC.mouseType_mc.gotoAndStop(_mouseType);
         }
         
         override public function UpdateData(data:Object) : void
         {
            super.UpdateData(data);
            _digCount = data.digCount;
         }
         
         override protected function ItemUILoaderOver() : void
         {
            this.SetDigCount(_digCount,true);
            this._digCountProgressBar.SetData(_digCount,this._maxDigCount);
         }
         
         private function SetDigCount(value:int, stopToEnd:Boolean = false) : void
         {
            var showFrame:int = 0;
            _digCount = value;
            if(this._maxDigCount > 0 && _digCount >= this._maxDigCount)
            {
               ClearMouseEvent();
            }
            if(Boolean(_itemUI))
            {
               showFrame = Math.round(_digCount * _itemUI.totalFrames / this._maxDigCount);
               if(stopToEnd)
               {
                  MCContorl.stopTo(_itemUI,showFrame,function():void
                  {
                     var childDisplayObj:DisplayObject = null;
                     var childMC:MovieClip = null;
                     for(var i:int = 0; i < _itemUI.numChildren; i++)
                     {
                        childDisplayObj = _itemUI.getChildAt(i);
                        if(childDisplayObj is MovieClip)
                        {
                           childMC = childDisplayObj as MovieClip;
                           childMC.gotoAndStop(childMC.totalFrames);
                        }
                     }
                  });
               }
               else
               {
                  MCContorl.stopTo(_itemUI,showFrame);
               }
            }
            GV.onlineSocket.dispatchEvent(new Event(DigTreasureEvent.DigItemOver));
         }
      }
   }
   
   