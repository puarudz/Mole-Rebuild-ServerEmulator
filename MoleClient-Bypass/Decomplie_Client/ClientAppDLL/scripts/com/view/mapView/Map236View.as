package com.view.mapView
{
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.module.pig.npcPig.NpcPig;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.type.ModuleType;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Map236View extends MapBase
   {
      
      public function Map236View()
      {
         super();
      }
      
      override protected function initView() : void
      {
         var controlMC:MovieClip = GV.MC_mapFrame.control_mc;
         tip.tipTailDisPlayObject(controlMC.seed_btn,"肥肥抓捕記");
         BC.addEvent(this,controlMC.seed_btn,MouseEvent.CLICK,this.GetPigSeed);
         tip.tipTailDisPlayObject(controlMC.home_btn,"前往家園");
         BC.addEvent(this,controlMC.home_btn,MouseEvent.CLICK,this.GetHome);
         tip.tipTailDisPlayObject(controlMC.angelPark_btn,"前往天使園");
         BC.addEvent(this,controlMC.angelPark_btn,MouseEvent.CLICK,this.GetToAngelPark);
         tip.tipTailDisPlayObject(controlMC.back_btn,"返回摩爾城堡");
         BC.addEvent(this,controlMC.back_btn,MouseEvent.CLICK,this.BackToMap);
         tip.tipTailDisPlayObject(controlMC.find_btn,"臭臭新發現");
         BC.addEvent(this,controlMC.find_btn,MouseEvent.CLICK,this.onOpenFind);
         new NpcPig(1593028);
         new NpcPig(1593007);
         new NpcPig(1593030);
         new NpcPig(1593031);
         new NpcPig(1593034);
         new NpcPig(1593035);
         new NpcPig(1593036);
         new NpcPig(1593037);
         new NpcPig(1593038);
         new NpcPig(1593047);
         new NpcPig(1593051);
         new NpcPig(1603000);
         new NpcPig(1603001);
         new NpcPig(1603002);
         new NpcPig(1603003);
         new NpcPig(1603004);
         new NpcPig(1603006);
         new NpcPig(1603007);
         new NpcPig(1593060);
         new NpcPig(1593057);
         new NpcPig(1593055);
         new NpcPig(1593053);
         var url:String = "module/pig/NpcPigToolBar.swf";
         var loader:Loader = new Loader();
         loader.load(VL.getURLRequest(url));
         MainManager.getAppLevel().addChild(loader);
      }
      
      private function onOpenFind(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.SMELLY_FIND_PANEL);
      }
      
      private function GetPigSeed(e:MouseEvent) : void
      {
         GF.switchMapDirectly(34);
      }
      
      private function GetToAngelPark(e:MouseEvent) : void
      {
         GF.switchMapDirectly(LocalUserInfo.getUserID(),false,300);
      }
      
      private function GetHome(e:MouseEvent) : void
      {
         GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
         GF.switchMap(LocalUserInfo.getUserID() + GV.TwentyBillion);
      }
      
      private function BackToMap(e:MouseEvent) : void
      {
         GF.switchMapDirectly(1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

