package com.view.mapView
{
   import com.module.digTreasure.DigTreasureViewCtl;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DigTreasure_Map2_Screen2_MapView extends MapBase
   {
      
      private var _botton_mc:MovieClip;
      
      private var peopleView:PeopleManageView;
      
      public function DigTreasure_Map2_Screen2_MapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
      }
      
      override public function init() : void
      {
         var dig:DigTreasureViewCtl = new DigTreasureViewCtl();
         dig.Init(GV.MC_mapFrame,GV.MapInfo_mapID);
         this.isShowTips();
         this._botton_mc["mapGo193_Btn"].buttonMode = true;
         BC.addEvent(this,this._botton_mc["mapGo193_Btn"],MouseEvent.CLICK,this.onClickGoBtn);
      }
      
      private function onClickGoBtn(e:Event) : void
      {
         this.peopleView = GV.MAN_PEOPLE;
         this.peopleView.addEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         this.peopleView.moveTo(863,388);
      }
      
      private function onGoOver(e:Event) : void
      {
         this.peopleView.removeEventListener(PeopleManageView.ON_GO_OVER,this.onGoOver);
         MapManager.enterMap(193);
      }
      
      private function isShowTips() : void
      {
         this._botton_mc = GV.MC_mapFrame["buttonLevel"];
         var mc:MovieClip = this._botton_mc["hideBox_mc"];
         mc.gotoAndStop(1);
         var tipsMc:MovieClip = mc["tips_mc"];
         tipsMc.visible = false;
      }
   }
}

