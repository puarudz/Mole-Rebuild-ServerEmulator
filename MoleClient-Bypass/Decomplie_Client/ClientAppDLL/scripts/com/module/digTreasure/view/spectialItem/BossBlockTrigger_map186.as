package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BossBlockTrigger_map186 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _blockMC:MovieClip;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _tragger:IDigTreasureItemCtl;
      
      private var _mole:PeopleManageView;
      
      public function BossBlockTrigger_map186()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._blockMC = this._mapUI.depth_mc.block_mc;
         this._blockMC.visible = false;
         this._viewCtl = View;
         this._boss = this._viewCtl.GetSpecialCtlItem(5);
         this._tragger = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger.StartDigFun = this.TriggerStartDigFun;
         this._dataCtl = dataCtl;
         this._mole = GV.MAN_PEOPLE as PeopleManageView;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function TriggerStartDigFun(tragger:IDigTreasureItemCtl = null) : void
      {
         if(this._boss.state <= 0)
         {
            if(this._mole.x >= this._blockMC.x)
            {
               this._mole.moveTo(this._mole.x + 50,this._mole.y);
            }
            else
            {
               this._mole.moveTo(this._mole.x - 50,this._mole.y);
            }
            if(this._boss.itemUI.currentFrame == 1)
            {
               this._boss.itemUI.gotoAndStop(2);
            }
         }
         else
         {
            this._tragger.StartDig();
         }
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

