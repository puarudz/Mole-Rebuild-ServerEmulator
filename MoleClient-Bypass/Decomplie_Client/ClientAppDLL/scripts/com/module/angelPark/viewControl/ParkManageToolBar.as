package com.module.angelPark.viewControl
{
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.angelPark.AngelParkView;
   import com.module.angelPark.ParkExtenalModelCtl;
   import com.module.angelPark.data.AngelParkDataCtl;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ParkManageToolBar
   {
      
      private var _angelParkData:AngelParkDataCtl = AngelParkView.instance.parkDataCtl;
      
      private var _ui:MovieClip;
      
      private var _toolMC:MovieClip;
      
      private var _visitorListBtn:SimpleButton;
      
      private var _helpBtn:SimpleButton;
      
      private var _manageBtn:SimpleButton;
      
      private var _honorBtn:SimpleButton;
      
      private var _backBtn:SimpleButton;
      
      private var _hospitalMC:MovieClip;
      
      private var _featureToolBar:ParkFeatureToolBar;
      
      public function ParkManageToolBar(ui:MovieClip)
      {
         super();
         this._ui = ui;
         var wareHouseBar:ParkWarehouseToolBar = new ParkWarehouseToolBar(this._ui.wareHouseBar_mc);
         this._featureToolBar = new ParkFeatureToolBar(this._ui.featureBar_mc,wareHouseBar);
         BC.addEvent(this,this._featureToolBar,ParkFeatureToolBar.HIDE_FEATURE_TOOLBAR,this.HideFeatureToolBar);
         this.InitBtn();
      }
      
      public function get featureToolBar() : ParkFeatureToolBar
      {
         return this._featureToolBar;
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function InitBtn() : void
      {
         if(this._angelParkData.isMyPark)
         {
            this._toolMC = this._ui.myParkToo_mc;
            this._visitorListBtn = this._toolMC.visitor_btn;
            this._helpBtn = this._toolMC.help_btn;
            this._manageBtn = this._toolMC.manage_btn;
            this._hospitalMC = this._toolMC.hospital_mc;
         }
         else
         {
            this._toolMC = this._ui.otherParkToo_mc;
            this._visitorListBtn = this._toolMC.visitor_btn;
            this._honorBtn = this._toolMC.honor_btn;
            this._backBtn = this._toolMC.back_btn;
         }
         this._toolMC.visible = true;
         if(Boolean(this._visitorListBtn))
         {
            if(this._angelParkData.isMyPark)
            {
               tip.tipTailDisPlayObject(this._visitorListBtn,"好友列表");
            }
            else
            {
               tip.tipTailDisPlayObject(this._visitorListBtn,"天使園訪客");
            }
            BC.addEvent(this,this._visitorListBtn,MouseEvent.CLICK,this.OpenVisitorPanel);
         }
         if(Boolean(this._helpBtn))
         {
            tip.tipTailDisPlayObject(this._helpBtn,"天使園指南");
            BC.addEvent(this,this._helpBtn,MouseEvent.CLICK,this.OpenHelpPanel);
         }
         if(Boolean(this._manageBtn))
         {
            tip.tipTailDisPlayObject(this._manageBtn,"管理天使園");
            BC.addEvent(this,this._manageBtn,MouseEvent.CLICK,this.ShowFeatureToolBar);
         }
         if(Boolean(this._honorBtn))
         {
            tip.tipTailDisPlayObject(this._honorBtn,"查看天使榮譽");
            BC.addEvent(this,this._honorBtn,MouseEvent.CLICK,this.OpenHonorPanel);
         }
         if(Boolean(this._backBtn))
         {
            tip.tipTailDisPlayObject(this._backBtn,"返回自己的天使園");
            BC.addEvent(this,this._backBtn,MouseEvent.CLICK,this.BackToMyPark);
         }
         if(Boolean(this._hospitalMC))
         {
            tip.tipTailDisPlayObject(this._hospitalMC,"天使病房");
            BC.addEvent(this,this._hospitalMC,MouseEvent.CLICK,this.OpenHospital);
            AngelParkView.instance.parkEffectCtl.InitHospitalBtnEffect(this._hospitalMC);
         }
      }
      
      private function OpenHospital(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenHospital();
      }
      
      public function ShowFeatureToolBar(e:MouseEvent = null) : void
      {
         this._featureToolBar.visible = true;
         this._toolMC.visible = false;
         GV.MC_ToolView.y = 10000;
         this._angelParkData.HidePeople();
         MoveTo.CanMove = false;
      }
      
      private function HideFeatureToolBar(e:Event = null) : void
      {
         this._featureToolBar.visible = false;
         this._toolMC.visible = true;
         GV.MC_ToolView.y = 340;
         this._angelParkData.ShowPeople();
         MoveTo.CanMove = true;
      }
      
      private function BackToMyPark(e:MouseEvent) : void
      {
         GF.switchMap(LocalUserInfo.getUserID(),false,300);
      }
      
      private function OpenHonorPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenHonorPanel();
      }
      
      private function OpenHelpPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenHelpPanel();
      }
      
      private function OpenVisitorPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenVisitorPanel();
      }
      
      public function Clear() : void
      {
         GV.MC_ToolView.y = 340;
         MoveTo.CanMove = true;
         BC.removeEvent(this);
         this._featureToolBar.Clear();
      }
   }
}

