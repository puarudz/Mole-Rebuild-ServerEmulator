package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.map.MapManager;
   
   public class Map238View extends MapBase
   {
      
      public function Map238View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         SystemEventManager.addEventListener("kfcNoise",this.kfcNoiseHandle);
         SystemEventManager.addEventListener("noiceOne",this.noiceOneHandle);
      }
      
      private function noiceOneHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStepOne);
         BufferManager.getBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP);
      }
      
      private function kfcStepOne(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStepOne);
         var noiseStep:uint = uint(e.EventObj);
         if(noiseStep == 0)
         {
            BufferManager.setBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP,1);
            MapManager.enterMap(240);
         }
      }
      
      private function kfcNoiseHandle(e:SystemEvent) : void
      {
         BufferManager.addBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStepHandle);
         BufferManager.getBuffer(BufferManager.KFC_DISAPPLE_NOISE_STEP);
      }
      
      private function kfcStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.KFC_DISAPPLE_NOISE_STEP,this.kfcStepHandle);
         var noiseStep:uint = uint(e.EventObj);
         if(noiseStep == 0)
         {
            mapSay(2);
         }
         else
         {
            Alert.angryAlart("　　小摩爾再去找找別的線索吧!");
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("kfcNoise",this.kfcNoiseHandle);
         SystemEventManager.removeEventListener("noiceOne",this.noiceOneHandle);
         super.destroy();
      }
   }
}

