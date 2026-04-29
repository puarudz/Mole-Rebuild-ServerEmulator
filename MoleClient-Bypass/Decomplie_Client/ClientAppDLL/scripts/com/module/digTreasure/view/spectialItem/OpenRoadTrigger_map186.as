package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class OpenRoadTrigger_map186 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _roadMC:MovieClip;
      
      private var _roadBtn:MovieClip;
      
      private var _tragger_1:IDigTreasureItemCtl;
      
      private var _tragger_2:IDigTreasureItemCtl;
      
      private var _tragger_3:IDigTreasureItemCtl;
      
      private var _tragger_4:IDigTreasureItemCtl;
      
      public function OpenRoadTrigger_map186()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._roadMC = this._mapUI.control_mc.road_mc;
         this._roadBtn = this._mapUI.buttonLevel.mapBtn_187;
         this._roadBtn.visible = false;
         this._viewCtl = View;
         this._tragger_1 = this._viewCtl.GetSpecialCtlItem(1);
         this._tragger_2 = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger_3 = this._viewCtl.GetSpecialCtlItem(3);
         this._tragger_4 = this._viewCtl.GetSpecialCtlItem(4);
         this._dataCtl = dataCtl;
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
         this.CheckState(null);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function CheckState(e:Event) : void
      {
         if(this._tragger_1.state == 2 && this._tragger_2.state == 2 && this._tragger_3.state == 2 && this._tragger_4.state == 2)
         {
            BC.removeEvent(this);
            this._tragger_1.ui.buttonMode = false;
            this._tragger_1.ui.mouseEnabled = false;
            this._tragger_2.ui.buttonMode = false;
            this._tragger_2.ui.mouseEnabled = false;
            this._tragger_3.ui.buttonMode = false;
            this._tragger_3.ui.mouseEnabled = false;
            this._tragger_4.ui.buttonMode = false;
            this._tragger_4.ui.mouseEnabled = false;
            this._roadMC.gotoAndPlay(2);
            this._roadBtn.visible = true;
         }
      }
   }
}

