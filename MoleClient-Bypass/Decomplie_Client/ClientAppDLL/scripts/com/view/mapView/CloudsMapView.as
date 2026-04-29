package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.module.npc.dialog.TalkEvent;
   import com.module.superGift.thanksgivingModule;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.Task83.LoaderCleanupAngelsGame;
   import com.view.mapView.activity.Task83.LoaderLamuDengLadderGame;
   import com.view.mapView.activity.Task83.SwitchMapToAngelPark;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class CloudsMapView extends MapBase
   {
      
      public var button_mc:MovieClip;
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var ldr:Loader;
      
      private var mc:*;
      
      public function CloudsMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         BC.addEvent(this,this.target_mc.gotoMap176,MouseEvent.CLICK,this.switchMap);
         BC.addEvent(this,this.target_mc.gotoMapAngle,MouseEvent.CLICK,this.angleGotoMap);
         tip.tipTailDisPlayObject(this.target_mc.gotoMapAngle,"進入天使園");
         tip.tipTailDisPlayObject(this.target_mc.gotoMap176,"進入神秘湖");
         BC.addEvent(this,GV.onlineSocket,"lamuDengCloudPanelLoad",this.loaderPanel);
         BC.addEvent(this,this.button_mc["cloud_btn"],MouseEvent.CLICK,this.onLoadLamuGame);
         BC.addEvent(this,this.button_mc["cloud2_btn"],MouseEvent.CLICK,this.onLoadLamuGame);
         BC.addEvent(this,TalkEvent,"threeEye_openPanle",this.openPanleFun);
         LoaderCleanupAngelsGame.instance.addEventFun(this.button_mc.cloud3_mc);
      }
      
      private function openPanleFun(evt:TalkEvent) : void
      {
         thanksgivingModule.getInstance().openWindowsFun();
      }
      
      private function angleGotoMap(evt:MouseEvent) : void
      {
         SwitchMapToAngelPark.instance.gotoAngelFun();
      }
      
      private function switchMap(evt:MouseEvent) : void
      {
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         GF.switchMap(176,true);
      }
      
      override public function destroy() : void
      {
         this.target_mc = null;
         this.depth_mc = null;
         this.top_mc = null;
         this.button_mc = null;
         BC.removeEvent(this);
         super.destroy();
      }
      
      private function onLoadLamuGame(e:MouseEvent) : void
      {
         var ss:String = e.currentTarget.name;
         if(ss == "cloud_btn")
         {
            LoaderLamuDengLadderGame.instance.loaderGameFun(1);
         }
         else if(ss == "cloud2_btn")
         {
            LoaderLamuDengLadderGame.instance.loaderGameFun(2);
         }
      }
      
      private function loaderPanel(e:Event) : void
      {
         this.ldr = new Loader();
         BC.addEvent(this,this.ldr.contentLoaderInfo,Event.COMPLETE,this.onLoaderOk);
         this.ldr.load(VL.getURLRequest("resource/task/lamuDengCloudPanel.swf"));
      }
      
      private function onLoaderOk(e:Event) : void
      {
         BC.removeEvent(this,e.currentTarget,Event.COMPLETE,this.onLoaderOk);
         this.mc = e.target.content;
         MainManager.getAppLevel().addChild(this.mc);
         BC.addEvent(this,this.mc["MC"]["yes_btn"],MouseEvent.CLICK,this.joinGame);
         BC.addEvent(this,this.mc["MC"]["close_btn"],MouseEvent.CLICK,this.closelamuPanel);
         BC.addEvent(this,this.mc["MC"]["no_btn"],MouseEvent.CLICK,this.closelamuPanel);
      }
      
      private function closelamuPanel(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.mc["MC"]["yes_btn"],MouseEvent.CLICK,this.joinGame);
         BC.removeEvent(this,this.mc["MC"]["close_btn"],MouseEvent.CLICK,this.closelamuPanel);
         BC.removeEvent(this,this.mc["MC"]["no_btn"],MouseEvent.CLICK,this.closelamuPanel);
         MainManager.getAppLevel().removeChild(this.mc);
         this.ldr = null;
         this.mc = null;
      }
      
      private function joinGame(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.mc["MC"]["yes_btn"],MouseEvent.CLICK,this.joinGame);
         BC.removeEvent(this,this.mc["MC"]["close_btn"],MouseEvent.CLICK,this.closelamuPanel);
         BC.removeEvent(this,this.mc["MC"]["no_btn"],MouseEvent.CLICK,this.closelamuPanel);
         MainManager.getAppLevel().removeChild(this.mc);
         this.ldr = null;
         this.mc = null;
         if(LocalUserInfo.getYXQ() < 100)
         {
            Alert.smileAlart("    你的摩爾豆不夠哦，快去玩莊園裡的小遊戲，獲取足夠的摩爾豆吧。");
         }
         else
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() - 100);
            LoaderLamuDengLadderGame.instance.loadGame();
         }
      }
   }
}

