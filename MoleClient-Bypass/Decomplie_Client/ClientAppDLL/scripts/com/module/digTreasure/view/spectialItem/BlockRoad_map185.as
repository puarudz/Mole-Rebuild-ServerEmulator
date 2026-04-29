package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BlockRoad_map185 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _blockMC:MovieClip;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _mole:PeopleManageView;
      
      public function BlockRoad_map185()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._blockMC = this._mapUI.depth_mc.roadBlock_mc;
         this._blockMC.visible = false;
         this._viewCtl = View;
         this._boss = this._viewCtl.GetSpecialCtlItem(0);
         this._dataCtl = dataCtl;
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
         BC.addEvent(this,this._mapUI.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
         this.CheckState(null);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
      
      private function onEntreFrameHandler(e:Event) : void
      {
         if(this._blockMC.hitTestPoint(this._mole.x,this._mole.y,true))
         {
            this._mole.moveTo(this._mole.x,this._mole.y + 50);
            if(this._boss.itemUI.currentFrame == 1)
            {
               this._boss.itemUI.gotoAndStop(2);
            }
         }
      }
      
      private function CheckState(e:Event) : void
      {
         if(this._boss.state > 0)
         {
            BC.removeEvent(this);
         }
      }
   }
}

