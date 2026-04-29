package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DoorCtl_map189 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _roadBtn:MovieClip;
      
      private var _tragger_door:IDigTreasureItemCtl;
      
      public function DoorCtl_map189()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._roadBtn = this._mapUI.buttonLevel.mapBtn_190;
         this._roadBtn.visible = false;
         this._viewCtl = View;
         this._tragger_door = this._viewCtl.GetSpecialCtlItem(0);
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
         if(this._tragger_door.state == 2)
         {
            BC.removeEvent(this);
            this._tragger_door.ui.buttonMode = false;
            this._tragger_door.ui.mouseEnabled = false;
            this._roadBtn.visible = true;
         }
      }
   }
}

