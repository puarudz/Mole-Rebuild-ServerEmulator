package com.module.angelPark.viewControl
{
   import com.common.tip.tip;
   import com.module.angelPark.AngelParkView;
   import com.module.angelPark.ParkExtenalModelCtl;
   import com.module.angelPark.data.AngelParkDataCtl;
   import com.view.baseViewCtl.ProgressbarControler;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ParkAuraToolBar
   {
      
      private var _ui:MovieClip;
      
      private var _auraBar:ProgressbarControler;
      
      private var _angelParkData:AngelParkDataCtl = AngelParkView.instance.parkDataCtl;
      
      public function ParkAuraToolBar(ui:MovieClip)
      {
         super();
         this._ui = ui;
         this._auraBar = new ProgressbarControler(this._ui.auraBar_mc);
         if(this._angelParkData.isMyPark)
         {
            this._ui.buttonMode = true;
            tip.tipTailDisPlayObject(this._ui,"補充靈氣");
            BC.addEvent(this,this._ui,MouseEvent.CLICK,this.OpenAddAuraPanel);
         }
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_PARK_EVENT,this.UpdateParkHandler);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_PARK_AURA_EVENT,this.UpdateParkHandler);
         this.UpdateParkHandler();
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function OpenAddAuraPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenAddAuraPanel();
      }
      
      private function UpdateParkHandler(e:Event = null) : void
      {
         this._auraBar.SetData(this._angelParkData.angelParkVO.aura,this._angelParkData.angelParkVO.lvlMaxAura);
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
   }
}

