package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.PointUtil;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.fireCup.currentStatus.*;
   import com.logic.socket.fireCup.first.*;
   import com.logic.socket.fireCup.gold.*;
   import com.logic.socket.fireCup.torch.*;
   import com.logic.socket.getUserBasicInfo.*;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.logic.socket.superlamuParty.superlamuPartySocket;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.superPetModule.petItemModule;
   import com.mole.app.map.MapBase;
   import com.view.JobView.ChildMapJob.JobMap55View;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class LabyrinthView extends MapBase
   {
      
      private var itemArray:Array = [[12270,"骷髏面具",550],[12271,"骷髏裝",1500]];
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var effect_mc:MovieClip;
      
      private var clothMC:MovieClip;
      
      private var candle_mc:MovieClip;
      
      private var candleBar_mc:MovieClip;
      
      private var setTimeoutTimer:Timer;
      
      private var JobMap55Views:JobMap55View;
      
      private var intervalBoxID:uint;
      
      private var hasCheckUPlevel:Boolean = false;
      
      public function LabyrinthView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.effect_mc = GV.MC_mapFrame["effect_mc"];
         this.setTimeoutTimer = null;
         this.JobMap55Views = new JobMap55View();
         BC.addEvent(this,this.botton_mc.boxJob_btn,MouseEvent.CLICK,this.chartBoxJob);
         BC.addEvent(this,this.botton_mc.boxJob1_btn,MouseEvent.CLICK,this.chartBoxJob);
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         GV.MC_mapFrame["top_mc"].mouseEnabled = false;
         GV.MC_mapFrame["top_mc"].mouseChildren = false;
         this.candle_mc = GV.MC_mapFrame["top_mc"].candle_mc;
         this.candleBar_mc = GV.MC_mapFrame["top_mc"].candleBar_mc;
         GV.MC_ToolView.addChildAt(this.candleBar_mc,0);
         BC.addEvent(this,this.botton_mc.clothBox_btn,MouseEvent.MOUSE_OVER,this.overHandler);
         BC.addEvent(this,this.botton_mc.clothBox_btn,MouseEvent.MOUSE_OUT,this.outHandler);
         BC.addEvent(this,this.botton_mc.clothBox_btn,MouseEvent.CLICK,this.ShowClothHandler);
         BC.addEvent(this,GV.onlineSocket,randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
         this.getPeopleMoveEvent();
      }
      
      private function overHandler(evt:MouseEvent) : void
      {
         this.depth_mc.clothBox_mc.gotoAndPlay(2);
      }
      
      private function outHandler(evt:MouseEvent) : void
      {
         this.depth_mc.clothBox_mc.gotoAndStop(1);
      }
      
      private function ShowClothHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         var i:int = 0;
         if(!MainManager.getAppLevel().getChildByName("clothMC"))
         {
            tempMC = GV.Lib_Map.getClass("clothMC") as Class;
            this.clothMC = new tempMC();
            this.clothMC.name = "clothMC";
            MainManager.getAppLevel().addChild(this.clothMC);
            BC.addEvent(this,this.clothMC.close_btn,MouseEvent.CLICK,this.removeclothMCHandler);
            for(i = 1; i <= 2; i++)
            {
               BC.addEvent(this,this.clothMC["btn_" + i],MouseEvent.CLICK,this.buyHandler);
               this.clothMC["info_" + i].money_txt.text = String(this.itemArray[i - 1][2]);
            }
         }
      }
      
      private function buyHandler(evt:MouseEvent) : void
      {
         var tempName:String = evt.target.name;
         var num:int = int(tempName.substring(4)) - 1;
         var itemObj:Object = new Object();
         itemObj.id = this.itemArray[num][0];
         itemObj.price = this.itemArray[num][2];
         itemObj.info = this.itemArray[num][1];
         clothBuyModule.buyAction(itemObj);
      }
      
      private function removeclothMCHandler(evt:MouseEvent = null) : void
      {
         BC.removeEvent(this,null,MouseEvent.CLICK,this.buyHandler);
         BC.removeEvent(this,this.clothMC.close_btn,MouseEvent.CLICK,this.removeclothMCHandler);
         GC.clearAllChildren(this.clothMC);
         this.clothMC.parent.removeChild(this.clothMC);
         this.clothMC = null;
      }
      
      private function chartBoxJob(event:MouseEvent) : void
      {
         var myAlert:* = undefined;
         var msg:String = "    你發現了南瓜寶盒，要把它打開嗎？";
         var url:String = "resource/allJob/icon/pumpkin.swf";
         myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"EMP_BUY");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showJob);
      }
      
      private function showJob(event:Event) : void
      {
         var msg:String = null;
         if(GV.MAN_PEOPLE.Petlevel > 1)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.GetRandomGift);
            superlamuPartySocket.treasurebowl(60);
         }
         else
         {
            msg = "   只有拉姆才能打開箱子哦！快帶你的拉姆來吧！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function GetRandomGift(e:EventTaomee) : void
      {
         if(e.EventObj.type == 60)
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + CommandID.TreasureBowl,this.GetRandomGift);
            Alert.smileAlart("    恭喜你獲得" + GoodsInfo.getItemNameByID(e.EventObj.itemId));
         }
      }
      
      private function getPeopleMoveEvent() : void
      {
         var people:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(Boolean(people))
         {
            if(GF.getPeopleObj(GV.MyInfo_userID).Petlevel > -1)
            {
               BC.addEvent(this,people.avatarClass,PeopleManageView.ON_GO_ENTERFRAME,this.ManMoveing);
               BC.addEvent(this,people,PeopleManageView.ON_BACK_PET,this.ManMoveing);
               BC.addEvent(this,people,PeopleManageView.ON_AVATAR_REFURBISH,this.refurbishEvent);
               petItemModule.setPetEffectHandler(null,2);
               this.ManMoveing();
            }
            else
            {
               this.candle_mc.x = this.candleBar_mc.x = -100;
               petItemModule.setPetEffectHandler();
            }
         }
         else
         {
            GC.clearGTimeout(this.setTimeoutTimer);
            this.setTimeoutTimer = GC.setGTimeout(this.getPeopleMoveEvent,10);
         }
      }
      
      private function ManMoveing(E:Event = null) : void
      {
         var tempPoint:Point = null;
         if(GV.MAN_PEOPLE.Petlevel > -1)
         {
            this.candle_mc.x = GV.MAN_PEOPLE.x + 20;
            this.candle_mc.y = GV.MAN_PEOPLE.y - 10;
            tempPoint = PointUtil.P2P(GV.MC_mapFrame,new Point(this.candle_mc.x,this.candle_mc.y),GV.MC_ToolView);
            this.candleBar_mc.x = tempPoint.x;
            this.candleBar_mc.y = tempPoint.y;
         }
         else
         {
            this.candle_mc.x = this.candleBar_mc.x = -100;
            this.candle_mc.y = this.candleBar_mc.y = 0;
            BC.removeEvent(this,null,PeopleManageView.ON_GO_ENTERFRAME,this.ManMoveing);
            BC.removeEvent(this,null,PeopleManageView.ON_BACK_PET,this.ManMoveing);
         }
      }
      
      private function refurbishEvent(E:Event = null) : void
      {
         BC.removeEvent(this,null,PeopleManageView.ON_GO_ENTERFRAME,this.ManMoveing);
         BC.removeEvent(this,null,PeopleManageView.ON_BACK_PET,this.ManMoveing);
         BC.removeEvent(this,null,PeopleManageView.ON_AVATAR_REFURBISH,this.refurbishEvent);
         this.getPeopleMoveEvent();
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var i:int;
         var tempMC:MovieClip = null;
         var tempArray:Array = null;
         var j:int = 0;
         var tempNum:uint = 0;
         var num:int = 0;
         var itemArray:Array = evt.EventObj.itemArray;
         this.target_mc.moleB_mc.mc.visible = true;
         for(i = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               try
               {
                  tempMC = this.target_mc.moleB_mc.mc.getChildAt(tempNum) as MovieClip;
                  if(num == 1)
                  {
                     tempMC.pos = tempNum;
                     if(tempMC.currentFrame == 1)
                     {
                        tempMC.gotoAndStop(2);
                     }
                  }
                  else if(tempMC.currentFrame == 2)
                  {
                     tempMC.gotoAndStop(1);
                  }
               }
               catch(E:Error)
               {
               }
            }
         }
      }
      
      override public function destroy() : void
      {
         GC.clearAll(this.candleBar_mc);
         GC.clearGTimeout(this.setTimeoutTimer);
         BC.removeEvent(this);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         this.effect_mc = null;
         this.clothMC = null;
         this.candle_mc = null;
         this.candleBar_mc = null;
         this.JobMap55Views = null;
         super.destroy();
      }
   }
}

