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
   import flash.utils.setTimeout;
   
   public class JumpOutBoss_map187 implements IDigTreasureSpecialCtl
   {
      
      private static var _showBoss:Boolean = false;
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _blockMC:MovieClip;
      
      private var _treasureBox:IDigTreasureItemCtl;
      
      private var _boss:IDigTreasureItemCtl;
      
      private var _mole:PeopleManageView;
      
      public function JumpOutBoss_map187()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._viewCtl = View;
         this._treasureBox = this._viewCtl.GetSpecialCtlItem(1);
         this._boss = this._viewCtl.GetSpecialCtlItem(2);
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
      
      private function CheckState(e:Event) : void
      {
         var randomValue:Number = NaN;
         if(this._treasureBox.digCount > 0)
         {
            if(_showBoss == false)
            {
               randomValue = Math.random();
               if(randomValue > 0.5)
               {
                  _showBoss = true;
                  this._boss.ui.visible = true;
                  this._boss.itemUI.gotoAndStop(2);
                  BC.removeEvent(this);
                  setTimeout(this._boss.SendDigCmd,5000);
               }
               else
               {
                  _showBoss = false;
                  this._boss.ui.visible = false;
               }
            }
            else
            {
               this._boss.ui.visible = true;
            }
         }
         else
         {
            _showBoss = false;
            this._boss.ui.visible = false;
         }
      }
   }
}

