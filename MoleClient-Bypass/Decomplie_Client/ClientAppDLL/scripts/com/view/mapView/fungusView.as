package com.view.mapView
{
   import com.core.info.LocalUserInfo;
   import com.logic.socket.PageSandMsg.*;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.clothBuyModule.clothBuyModule;
   import com.mole.app.map.MapBase;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   
   public class fungusView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      private var sevenBool:Boolean;
      
      private var timer:Timer;
      
      public function fungusView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.target_mc.allitem.item190015.policeMC.gotoAndStop(1);
         this.target_mc.allitem.item190015.policeMC.visible = false;
         GV.onlineSocket.addEventListener("petAction_suc",this.switchMapHandler);
         for(var i:int = 1; i <= 5; i++)
         {
            this.target_mc["mc_" + i].buttonMode = true;
            this.target_mc["mc_" + i].addEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         this.target_mc.allitem.item190015.item_btn.addEventListener(MouseEvent.CLICK,this.finishPoliceJob);
      }
      
      public function finishPoliceJob(event:MouseEvent) : void
      {
         this.target_mc.allitem.item190015.item_btn.visible = false;
         this.target_mc.allitem.item190015.policeMC.gotoAndPlay(2);
         this.target_mc.allitem.item190015.policeMC.visible = true;
         GV.onlineSocket.addEventListener("police_over_num_one",this.makeTimerFun);
      }
      
      private function makeTimerFun(E:*) : void
      {
         GV.onlineSocket.removeEventListener("police_over_num_one",this.makeTimerFun);
         var myBoolean:Boolean = false;
         var num:uint = 10;
         var okstr:String = "    太幸運了！挖到了一塊魔幻水晶已經放入你的百寶箱中。";
         var nostr:String = "    看來你運氣不太好，只挖到了一塊普通水晶。";
         var JobGoodsID:uint = 190015;
         this.target_mc.allitem.item190015.policeMC.gotoAndStop(1);
         this.target_mc.allitem.item190015.policeMC.visible = false;
         myBoolean = Boolean(GV.JobViews.finishRandomJob(num,okstr,nostr,JobGoodsID));
         if(!myBoolean)
         {
            this.target_mc.allitem.item190015.item_btn.visible = true;
         }
      }
      
      public function clickHandler(evt:MouseEvent) : void
      {
         var itemObj:Object = new Object();
         itemObj.id = 17003;
         itemObj.price = 200;
         itemObj.info = "超級蘑菇";
         clothBuyModule.buyAction(itemObj,false);
      }
      
      override public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("petAction_suc",this.switchMapHandler);
         this.target_mc.allitem.item190015.item_btn.removeEventListener(MouseEvent.CLICK,this.finishPoliceJob);
         for(var i:int = 1; i <= 5; i++)
         {
            this.target_mc["mc_" + i].removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         this.target_mc = null;
         this.depth_mc = null;
         super.destroy();
      }
      
      private function switchMapHandler(evt:Event) : void
      {
         var arr:Array = [34,32,9];
         var tempNum:int = Math.floor(Math.random() * 3);
         GV.Room_DefaultRoomID = 0;
         LocalUserInfo.setMapID(0);
         switchMapLogic.switchMapLogicHandler(arr[tempNum]);
      }
   }
}

