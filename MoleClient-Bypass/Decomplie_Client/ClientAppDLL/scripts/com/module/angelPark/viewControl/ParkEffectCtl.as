package com.module.angelPark.viewControl
{
   import com.common.Tween.TweenLite;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.angelPark.AngelParkSocket;
   import com.module.angelPark.AngelParkView;
   import fl.motion.easing.Bounce;
   import flash.display.MovieClip;
   
   public class ParkEffectCtl
   {
      
      private var _honerMC:MovieClip;
      
      private var _hospitalMC:MovieClip;
      
      public function ParkEffectCtl()
      {
         super();
      }
      
      public function InitHonerBtnEffect(ui:MovieClip) : void
      {
         this._honerMC = ui;
         tip.tipTailDisPlayObject(this._honerMC,"查看天使榮譽");
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "read_" + AngelParkSocket.GetHonerCmd;
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function handler(e:EventTaomee):void
            {
               if(Boolean(e.EventObj.hasHonerAward))
               {
                  tip.tipTailDisPlayObject(_honerMC,"獲取新的榮譽啦！");
                  _honerMC.gotoAndStop(2);
               }
               else
               {
                  tip.tipTailDisPlayObject(_honerMC,"查看天使榮譽");
                  _honerMC.gotoAndStop(1);
               }
            });
            var _temp_8:* = BC;
            var _temp_7:* = this;
            var _temp_6:* = GV.onlineSocket;
            var _temp_5:* = "all_angel_park_award_over_event";
            with({})
            {
               _temp_8.addEvent(_temp_7,_temp_6,_temp_5,function overHandler(e:EventTaomee):void
               {
                  tip.tipTailDisPlayObject(_honerMC,"查看天使榮譽");
                  _honerMC.gotoAndStop(1);
               });
            }
            
            private function UnlockHonerHandler(e:EventTaomee) : void
            {
               var effectMC:MovieClip = null;
               effectMC = GV.Lib_Map.getMovieClip("getHoner_effect") as MovieClip;
               var moveOver:Function = function MoveBack():void
               {
                  _honerMC.gotoAndStop(2);
                  tip.tipTailDisPlayObject(_honerMC,"獲取新的榮譽啦！");
                  effectMC.visible = false;
                  GC.clearAll(effectMC);
               };
               MainManager.getAppLevel().addChild(effectMC);
               effectMC.x = 100;
               effectMC.y = 500;
               TweenLite.to(effectMC,2,{
                  "x":this._honerMC.x,
                  "y":this._honerMC.y,
                  "onComplete":moveOver,
                  "easeOut":Bounce.easeIn
               });
            }
            
            public function InitHospitalBtnEffect(ui:MovieClip) : void
            {
               this._hospitalMC = ui;
               this.CheckAngelHospitalState();
            }
            
            private function CheckAngelHospitalState() : void
            {
               var thisObj:Object = null;
               var fun:Function = null;
               this._hospitalMC.gotoAndStop(1);
               thisObj = this;
               fun = function handler(e:EventTaomee):void
               {
                  var angel:Object = null;
                  BC.removeEvent(thisObj,GV.onlineSocket,"read_" + AngelParkSocket.getAngelsInHospitalCmd,fun);
                  var angelList:Array = e.EventObj as Array;
                  var canOutCount:int = 0;
                  for each(angel in angelList)
                  {
                     if(angel.time == 0)
                     {
                        _hospitalMC.gotoAndStop(2);
                        break;
                     }
                  }
               };
               BC.addEvent(this,GV.onlineSocket,"read_" + AngelParkSocket.getAngelsInHospitalCmd,fun);
               var _temp_4:* = BC;
               var _temp_3:* = this;
               var _temp_2:* = GV.onlineSocket;
               var _temp_1:* = "update_hospital_angel_count";
               with({})
               {
                  _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function hand(e:EventTaomee):void
                  {
                     if(int(e.EventObj) > 0)
                     {
                        _hospitalMC.gotoAndStop(2);
                     }
                     else
                     {
                        _hospitalMC.gotoAndStop(1);
                     }
                  });
               }
               
               public function Clear() : void
               {
                  BC.removeEvent(this);
               }
            }
         }
         
         