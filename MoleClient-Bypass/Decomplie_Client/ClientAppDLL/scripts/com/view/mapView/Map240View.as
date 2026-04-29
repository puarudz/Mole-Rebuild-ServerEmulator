package com.view.mapView
{
   import com.common.util.DisplayUtil;
   import com.event.EventTaomee;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import com.view.mapView.activity.BackToYouthMapManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Map240View extends MapBase
   {
      
      public function Map240View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BackToYouthMapManager.instence.initView(controlLevel["npc_mc"]);
         BufferManager.addBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStep);
         BufferManager.getBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP);
         super.initView();
      }
      
      private function kfcStep(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStep);
         var noiseStep:uint = uint(e.EventObj);
         if(noiseStep == 1 || noiseStep == 2 || noiseStep == 3)
         {
            BC.addEvent(this,controlLevel["kfcKula_btn"],MouseEvent.CLICK,this.onClickKula);
         }
         else
         {
            DisplayUtil.removeForParent(controlLevel["KFCTip_mc"]);
            DisplayUtil.removeForParent(controlLevel["kfcKula_btn"]);
         }
      }
      
      private function onClickKula(e:Event) : void
      {
         ModuleManager.openPanel(ModuleType.KFC_KULA_STONE_PANEL);
      }
      
      override public function destroy() : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStep);
         super.destroy();
      }
   }
}

