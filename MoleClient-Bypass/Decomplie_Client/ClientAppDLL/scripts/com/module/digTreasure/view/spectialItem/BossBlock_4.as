package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class BossBlock_4 implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _tragger_1:IDigTreasureItemCtl;
      
      private var _tragger_2:IDigTreasureItemCtl;
      
      private var _tragger_3:IDigTreasureItemCtl;
      
      private var _tragger_4:IDigTreasureItemCtl;
      
      public function BossBlock_4()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._viewCtl = View;
         this._boss = this._viewCtl.GetSpecialCtlItem(0);
         this._tragger_1 = this._viewCtl.GetSpecialCtlItem(1);
         this._tragger_1.StartDigFun = this.TriggerStartDigFun;
         this._tragger_2 = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger_2.StartDigFun = this.TriggerStartDigFun;
         this._tragger_3 = this._viewCtl.GetSpecialCtlItem(3);
         this._tragger_3.StartDigFun = this.TriggerStartDigFun;
         this._tragger_4 = this._viewCtl.GetSpecialCtlItem(4);
         this._tragger_4.StartDigFun = this.TriggerStartDigFun;
         this._dataCtl = dataCtl;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function TriggerStartDigFun(tragger:IDigTreasureItemCtl = null) : void
      {
         if(this._boss.state <= 0)
         {
            if(this._boss.itemUI.currentFrame == 1)
            {
               this._boss.itemUI.gotoAndStop(2);
            }
         }
         else
         {
            tragger.StartDig();
         }
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

