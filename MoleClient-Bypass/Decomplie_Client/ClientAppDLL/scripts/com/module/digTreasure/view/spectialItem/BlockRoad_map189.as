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
   
   public class BlockRoad_map189 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _blockMC:MovieClip;
      
      private var _tragger_1:IDigTreasureItemCtl;
      
      private var _tragger_2:IDigTreasureItemCtl;
      
      private var _tragger_3:IDigTreasureItemCtl;
      
      private var _tragger_4:IDigTreasureItemCtl;
      
      private var _tragger_5:IDigTreasureItemCtl;
      
      private var _treasure_1:IDigTreasureItemCtl;
      
      private var _treasure_2:IDigTreasureItemCtl;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _mole:PeopleManageView;
      
      public function BlockRoad_map189()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._blockMC = this._mapUI.depth_mc.roadBlock_mc;
         this._blockMC.visible = false;
         this._viewCtl = View;
         this._tragger_1 = this._viewCtl.GetSpecialCtlItem(1);
         this._tragger_2 = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger_3 = this._viewCtl.GetSpecialCtlItem(3);
         this._tragger_4 = this._viewCtl.GetSpecialCtlItem(4);
         this._tragger_5 = this._viewCtl.GetSpecialCtlItem(5);
         this._treasure_1 = this._viewCtl.GetSpecialCtlItem(7);
         this._treasure_2 = this._viewCtl.GetSpecialCtlItem(8);
         this._treasure_1.ui.visible = false;
         this._treasure_2.ui.visible = false;
         this._boss = this._viewCtl.GetSpecialCtlItem(6);
         this._boss.ui.visible = false;
         this._dataCtl = dataCtl;
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
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
            this._mole.moveTo(this._mole.x,this._mole.y - 50);
            if(this._boss.itemUI.currentFrame == 1)
            {
               this._boss.itemUI.gotoAndStop(2);
            }
         }
      }
      
      private function CheckState(e:Event) : void
      {
         if(this._tragger_1.state == 2 && this._tragger_2.state == 2 && this._tragger_3.state == 2 && this._tragger_4.state == 2 && this._tragger_5.state == 2)
         {
            BC.addEvent(this,this._mapUI.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
            this._boss.ui.visible = true;
            this._treasure_1.ui.visible = true;
            this._treasure_2.ui.visible = true;
         }
         else
         {
            this._boss.ui.visible = false;
            this._treasure_1.ui.visible = false;
            this._treasure_2.ui.visible = false;
            BC.removeEvent(this,this._mapUI.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
         }
         if(this._boss.state > 0)
         {
            BC.removeEvent(this,this._mapUI.stage,Event.ENTER_FRAME,this.onEntreFrameHandler);
         }
      }
   }
}

