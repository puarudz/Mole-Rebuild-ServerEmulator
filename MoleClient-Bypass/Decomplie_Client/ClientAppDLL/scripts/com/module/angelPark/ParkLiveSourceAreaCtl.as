package com.module.angelPark
{
   import com.module.angelPark.data.AngelParkDataCtl;
   import com.module.angelPark.viewControl.ParkLivePointView;
   import com.module.angelPark.viewControl.SLParkLivePointView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ParkLiveSourceAreaCtl
   {
      
      public static const MAX_ANGEL_COUNT:int = 15;
      
      private static const SLAngelCount:int = 3;
      
      private static const NomalAngelCount:int = MAX_ANGEL_COUNT - SLAngelCount;
      
      private var _angelLivePointList:Array;
      
      private var _slAngelLivePointList:Array;
      
      private var _angelParkData:AngelParkDataCtl;
      
      private var _ui:MovieClip;
      
      public function ParkLiveSourceAreaCtl(ui:MovieClip)
      {
         var parkLivePoint:ParkLivePointView = null;
         var posIndex:int = 0;
         var slparkLivePoint:SLParkLivePointView = null;
         this._angelParkData = AngelParkView.instance.parkDataCtl;
         super();
         this._ui = ui;
         this._angelLivePointList = new Array();
         for(var i:int = 0; i < NomalAngelCount; i++)
         {
            ui = this._ui["livePoint_" + i];
            parkLivePoint = new ParkLivePointView(ui,i);
            this._angelLivePointList.push(parkLivePoint);
         }
         this._slAngelLivePointList = new Array();
         for(var j:int = 0; j < SLAngelCount; j++)
         {
            posIndex = NomalAngelCount + j;
            ui = this._ui["livePoint_" + posIndex];
            slparkLivePoint = new SLParkLivePointView(ui,posIndex);
            this._slAngelLivePointList.push(slparkLivePoint);
         }
         this.UpdateAngel();
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_ANGELINFO_EVENT,this.UpdateAngel);
      }
      
      public function Clear() : void
      {
         var livePoint:ParkLivePointView = null;
         BC.removeEvent(this);
         for each(livePoint in this._angelLivePointList)
         {
            livePoint.Clear();
         }
         for each(livePoint in this._slAngelLivePointList)
         {
            livePoint.Clear();
         }
         this._angelLivePointList = null;
         this._slAngelLivePointList = null;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function UpdateAngel(e:Event = null) : void
      {
         this.UpdateNormalAngel();
         this.UpdateSLAngel();
      }
      
      private function UpdateNormalAngel() : void
      {
         var parkLivePoint:ParkLivePointView = null;
         for(var i:int = 0; i < NomalAngelCount; i++)
         {
            parkLivePoint = this._angelLivePointList[i];
            parkLivePoint.UpdateAngel();
            parkLivePoint.locked = false;
            if(i == this._angelParkData.canSeedAngelCount)
            {
               parkLivePoint.locked = true;
            }
            else if(i > this._angelParkData.canSeedAngelCount)
            {
               parkLivePoint.visible = false;
            }
         }
      }
      
      private function UpdateSLAngel() : void
      {
         var slParkLivePoint:SLParkLivePointView = null;
         for(var i:int = 0; i < SLAngelCount; i++)
         {
            slParkLivePoint = this._slAngelLivePointList[i];
            slParkLivePoint.UpdateAngel();
         }
      }
   }
}

