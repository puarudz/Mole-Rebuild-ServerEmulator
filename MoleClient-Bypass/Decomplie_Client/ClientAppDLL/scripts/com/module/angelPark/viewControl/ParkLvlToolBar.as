package com.module.angelPark.viewControl
{
   import com.core.MainManager;
   import com.module.LocusWork.NumSprite;
   import com.module.angelPark.AngelParkView;
   import com.module.angelPark.ParkExtenalModelCtl;
   import com.module.angelPark.data.AngelParkDataCtl;
   import com.view.baseViewCtl.ProgressbarControler;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   
   public class ParkLvlToolBar
   {
      
      private var _angelParkData:AngelParkDataCtl = AngelParkView.instance.parkDataCtl;
      
      private var _ui:MovieClip;
      
      private var _lvlNum:NumSprite;
      
      private var _expBar:ProgressbarControler;
      
      private var _baseX:Number;
      
      public function ParkLvlToolBar(ui:MovieClip, checkSelfPark:Boolean = true)
      {
         super();
         this._ui = ui;
         if(checkSelfPark && this._angelParkData.isMyPark)
         {
            this._ui.buttonMode = true;
            BC.addEvent(this,this._ui,MouseEvent.CLICK,this.OpenLvlPanel);
            BC.addEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.ShowTip);
            BC.addEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.HideTip);
         }
         this._lvlNum = new NumSprite(ui.lvlNum_mc,1,false);
         this._baseX = ui.lvlNum_mc.x;
         this._expBar = new ProgressbarControler(ui.expBar_mc);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_PARK_EVENT,this.UpdateParkHandler);
         this.UpdateParkHandler();
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      private function HideTip(e:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function ShowTip(e:MouseEvent) : void
      {
         var tipStr:String = "恭喜你已經升至頂級";
         if(!this._angelParkData.angelParkVO.isTopLvl)
         {
            tipStr = "距離下一等級還剩" + this._angelParkData.angelParkVO.nextLvlNeedExp + "點經驗";
         }
         var tip_Class:* = ApplicationDomain.currentDomain.getDefinition("com.common.tip::tip") as Class;
         var tip_mc:* = new tip_Class();
         tip_mc.message = tipStr;
         MainManager.getRootMC().addChild(tip_mc);
         tip_mc.x = tip_mc.width / 2 + 10;
         tip_mc.y = 80;
      }
      
      private function OpenLvlPanel(e:MouseEvent) : void
      {
         ParkExtenalModelCtl.OpenLvlPanel();
      }
      
      private function UpdateParkHandler(e:Event = null) : void
      {
         var lvl:int = this._angelParkData.angelParkVO.level;
         var exp:int = this._angelParkData.angelParkVO.exp;
         this._lvlNum.value = lvl;
         if(lvl < 10)
         {
            this._lvlNum.content.x = this._baseX - 17;
         }
         else
         {
            this._lvlNum.content.x = this._baseX;
         }
         if(this._angelParkData.angelParkVO.isTopLvl)
         {
            this._expBar.SetData(this._angelParkData.angelParkVO.topLvlExp,this._angelParkData.angelParkVO.topLvlExp);
         }
         else
         {
            this._expBar.SetData(exp,this._angelParkData.angelParkVO.nextLvlExp);
         }
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
      }
   }
}

