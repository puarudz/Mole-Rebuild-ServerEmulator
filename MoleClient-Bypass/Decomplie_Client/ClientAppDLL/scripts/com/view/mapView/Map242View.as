package com.view.mapView
{
   import com.common.tip.tip;
   import com.logic.active.MaylstActiveCtl;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import flash.events.MouseEvent;
   
   public class Map242View extends MapBase
   {
      
      public function Map242View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         tip.tipTailDisPlayObject(controlLevel.btn_egg,"金鵝歷險記");
         tip.tipTailDisPlayObject(controlLevel.door_10,"開心農場");
         BC.addEvent(this,controlLevel.btn_egg,MouseEvent.CLICK,this.openGame,false,0,true);
         depthLevel.bigMan.addEventListener(MouseEvent.CLICK,this.clickBig);
      }
      
      private function clickBig(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.ANGEL_SELECT_PANEL);
      }
      
      private function openGame(e:MouseEvent) : void
      {
         MaylstActiveCtl.instance.onLoadGame("module/game/flyeavesgowall.swf",true,true);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

