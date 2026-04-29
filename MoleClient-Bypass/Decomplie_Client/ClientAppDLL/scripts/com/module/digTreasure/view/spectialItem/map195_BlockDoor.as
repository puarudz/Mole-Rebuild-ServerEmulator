package com.module.digTreasure.view.spectialItem
{
   import com.module.digTreasure.DigTreasureEvent;
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.module.digTreasure.IDigTreasureItemCtl;
   import com.module.digTreasure.IDigTreasureSpecialCtl;
   import com.module.digTreasure.data.DigTreasureData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class map195_BlockDoor implements IDigTreasureSpecialCtl
   {
      
      private var _mapUI:MovieClip;
      
      private var _viewCtl:DigTreasureViewCtl;
      
      private var _dataCtl:DigTreasureData;
      
      private var _doorMC:MovieClip;
      
      private var _blockMC:MovieClip;
      
      private var _tragger_1:IDigTreasureItemCtl;
      
      private var _tragger_2:IDigTreasureItemCtl;
      
      private var _tragger_3:IDigTreasureItemCtl;
      
      private var _tragger_4:IDigTreasureItemCtl;
      
      private var _tragger_5:IDigTreasureItemCtl;
      
      private var _tragger_6:IDigTreasureItemCtl;
      
      private var _tragger_7:IDigTreasureItemCtl;
      
      private var _tragger_8:IDigTreasureItemCtl;
      
      private var _tragger_9:IDigTreasureItemCtl;
      
      private var _preDigTragger:IDigTreasureItemCtl;
      
      private var _pairDic:Dictionary;
      
      public function map195_BlockDoor()
      {
         super();
      }
      
      public function Init(mapUI:MovieClip, View:DigTreasureViewCtl, dataCtl:DigTreasureData) : void
      {
         this._mapUI = mapUI;
         this._pairDic = new Dictionary();
         this._doorMC = this._mapUI.buttonLevel.mapBtn;
         this._blockMC = this._mapUI.control_mc.block_mc;
         this._doorMC.visible = false;
         this._viewCtl = View;
         this._tragger_1 = this._viewCtl.GetSpecialCtlItem(1);
         this._tragger_2 = this._viewCtl.GetSpecialCtlItem(2);
         this._tragger_3 = this._viewCtl.GetSpecialCtlItem(3);
         this._tragger_4 = this._viewCtl.GetSpecialCtlItem(4);
         this._tragger_5 = this._viewCtl.GetSpecialCtlItem(5);
         this._tragger_6 = this._viewCtl.GetSpecialCtlItem(6);
         this._tragger_7 = this._viewCtl.GetSpecialCtlItem(7);
         this._tragger_8 = this._viewCtl.GetSpecialCtlItem(8);
         this._tragger_9 = this._viewCtl.GetSpecialCtlItem(9);
         this._tragger_5.ui.visible = false;
         this._pairDic[this._tragger_1] = this._tragger_2;
         this._pairDic[this._tragger_2] = this._tragger_1;
         this._pairDic[this._tragger_3] = this._tragger_8;
         this._pairDic[this._tragger_4] = this._tragger_9;
         this._pairDic[this._tragger_6] = this._tragger_7;
         this._pairDic[this._tragger_7] = this._tragger_6;
         this._pairDic[this._tragger_8] = this._tragger_3;
         this._pairDic[this._tragger_9] = this._tragger_4;
         this._tragger_1.StartDigFun = this.StartDigFun;
         this._tragger_2.StartDigFun = this.StartDigFun;
         this._tragger_3.StartDigFun = this.StartDigFun;
         this._tragger_4.StartDigFun = this.StartDigFun;
         this._tragger_6.StartDigFun = this.StartDigFun;
         this._tragger_7.StartDigFun = this.StartDigFun;
         this._tragger_8.StartDigFun = this.StartDigFun;
         this._tragger_9.StartDigFun = this.StartDigFun;
         this._tragger_1.ui.name = "1";
         this._tragger_2.ui.name = "2";
         this._tragger_3.ui.name = "3";
         this._tragger_4.ui.name = "4";
         this._tragger_6.ui.name = "6";
         this._tragger_7.ui.name = "7";
         this._tragger_8.ui.name = "8";
         this._tragger_9.ui.name = "9";
         this._dataCtl = dataCtl;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,GV.onlineSocket,DigTreasureEvent.DigItemOver,this.CheckState);
         this.CheckState(null);
      }
      
      private function StartDigFun(tragger:IDigTreasureItemCtl = null) : void
      {
         var tempPreTragger:IDigTreasureItemCtl = null;
         if(Boolean(this._preDigTragger))
         {
            if(this._preDigTragger == this._pairDic[tragger])
            {
               tragger.StartDig();
               tempPreTragger = this._preDigTragger;
               with({})
               {
                  
                  setTimeout(function handler():void
                  {
                     var effect1:MovieClip = _mapUI.control_mc["effect_" + tragger.ui.name];
                     var effect2:MovieClip = _mapUI.control_mc["effect_" + tempPreTragger.ui.name];
                     effect1.gotoAndPlay(2);
                     effect2.gotoAndPlay(2);
                  },2950);
               }
               else
               {
                  if(tragger != this._preDigTragger)
                  {
                     this._preDigTragger.SendDigCmd();
                  }
                  tragger.StartDig();
                  this._preDigTragger = tragger;
               }
            }
            else
            {
               tragger.StartDig();
               this._preDigTragger = tragger;
            }
         }
         
         private function CheckState(e:Event) : void
         {
            var tragger:IDigTreasureItemCtl = null;
            var pairTragger:IDigTreasureItemCtl = null;
            for each(tragger in this._pairDic)
            {
               pairTragger = this._pairDic[tragger];
               if(pairTragger.state > 1 && tragger.state > 1)
               {
                  pairTragger.ui.visible = false;
                  pairTragger.ui.visible = false;
               }
            }
            if(this._tragger_1.ui.visible == false && this._tragger_2.ui.visible == false && this._tragger_3.ui.visible == false && this._tragger_4.ui.visible == false && this._tragger_6.ui.visible == false && this._tragger_7.ui.visible == false && this._tragger_8.ui.visible == false && this._tragger_9.ui.visible == false)
            {
               this._tragger_5.ui.visible = true;
            }
            if(this._tragger_5.state > 1)
            {
               this._tragger_5.ClearMouseEvent();
               this._blockMC.gotoAndStop(2);
               this._doorMC.visible = true;
            }
         }
         
         private function removeEventHandler(e:Event) : void
         {
            BC.removeEvent(this);
         }
      }
   }
   
   