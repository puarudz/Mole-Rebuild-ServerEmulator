package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.PetClassLogic.PowerClassInfo;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.getServerTimer.getServerTimerRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.activityModule.giftModule;
   import com.module.specialGoods.GuestBookLogic;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.SilkyHousePanelAI;
   import com.view.monthlyView.EmailMomoView;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SilkyHouseView extends MapBase
   {
      
      private var target_mc:MovieClip;
      
      private var depth_mc:MovieClip;
      
      private var botton_mc:MovieClip;
      
      private var oldMailMC:MovieClip;
      
      private var guestbook:*;
      
      private var momoEmail:EmailMomoView;
      
      public function SilkyHouseView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.doorMC.buttonMode = true;
         BC.addEvent(this,this.target_mc.msgBtn,MouseEvent.CLICK,this.showHouseMsg);
         BC.addEvent(this,GV.onlineSocket,"SILKYROOM_SUC",this.openDoorEvent);
         BC.addEvent(this,this.target_mc.gift_btn,MouseEvent.CLICK,this.giftHandler);
         BC.addEvent(this,this.target_mc.doorMC,MouseEvent.MOUSE_OVER,this.overHandler);
         BC.addEvent(this,this.target_mc.doorMC,MouseEvent.MOUSE_OUT,this.outHandler);
         BC.addEvent(this,this.botton_mc.emailBtn,MouseEvent.CLICK,this.emaiOldHandler);
         PowerClassInfo.getInstanse().scene = this;
         PowerClassInfo.getInstanse().getClassData();
      }
      
      public function powerFun() : void
      {
         this.target_mc["jialin_mc"].visible = true;
         if(PowerClassInfo.getInstanse().finishFlag)
         {
            this.target_mc["jialin_mc"].gotoAndStop(this.target_mc["jialin_mc"].totalFrames);
         }
         else
         {
            this.target_mc["jialin_mc"].buttonMode = true;
         }
         BC.addEvent(this,this.target_mc.hitMC,"onHit",this.holeClick);
      }
      
      private function holeClick(e:Event) : void
      {
         var msg:String = null;
         var PowerPanelClass:Class = null;
         if(this.target_mc["jialin_mc"].currentFrame != 1)
         {
            this.playOver(e);
            return;
         }
         if(!PowerClassInfo.getInstanse().hasDingzi)
         {
            if(!PowerClassInfo.getInstanse().hasBanzi)
            {
               msg = " 謝謝你來幫絲姐姐，不過你好像沒帶齊維修材料。快去工頭湯米和發明家大衛那看看吧。記得帶著你的拉姆一起去哦!";
            }
            else
            {
               msg = " 工具最多的發明屋裡應該有釘子。記得帶著你的拉姆一起去哦!";
            }
         }
         else
         {
            if(PowerClassInfo.getInstanse().hasBanzi)
            {
               PowerPanelClass = GV.Lib_Map.getClass("PowerPanel");
               if(SilkyHousePanelAI.getInstanse().getContent() == null)
               {
                  this.target_mc["powerPanel"] = MainManager.getAppLevel().addChild(new PowerPanelClass());
                  BC.addEvent(this,this.target_mc["powerPanel"],"START_POWER",this.startPowerHandler);
                  BC.addEvent(this,this.target_mc["powerPanel"],"WRIGHT_POWER",this.wrightPowerHandler);
                  SilkyHousePanelAI.getInstanse().setContent(this.target_mc["powerPanel"]);
               }
               else
               {
                  SilkyHousePanelAI.getInstanse().getContent().visible = true;
               }
               return;
            }
            msg = " 找工頭湯米吧，他那應該有木板。記得帶著你的拉姆一起去哦!";
         }
         var url:String = "resource/allJob/AlertPic/silky560.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function startPowerHandler(e:Event) : void
      {
         this.target_mc["jialin_mc"].gotoAndPlay(2);
         LamuMantra.yishouzhetian("yishouzhetian");
         SilkyHousePanelAI.getInstanse().clear();
         PowerClassInfo.getInstanse().repairHouse();
         BC.addEvent(this,this.target_mc["jialin_mc"],"PLAY_OVER",this.playOver);
      }
      
      private function playOver(e:Event) : void
      {
         BC.removeEvent(this,this.target_mc["jialin_mc"],"PLAY_OVER",this.playOver);
         BC.removeEvent(this,this.target_mc["jialin_mc"],MouseEvent.CLICK,this.holeClick);
         var msg:String = "     謝謝你幫了我大忙了，趕快回你的魔法老師那領取畢業徽章吧！";
         var url:String = "resource/allJob/AlertPic/silky560.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function wrightPowerHandler(e:Event) : void
      {
         var msg:String = " 魔咒輸入錯誤哦！";
         var url:String = "resource/allJob/AlertPic/petMagicClass/102_6.swf";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
      }
      
      private function getServerDate(evt:EventTaomee) : void
      {
         var E:Date = evt.EventObj as Date;
         this.getServerTimer(E);
      }
      
      public function getServerTimer(E:Date) : void
      {
         BC.addEvent(this,GV.onlineSocket,getServerTimerRes.GET_SERVER_TIMER,this.getServerDate);
         var days:int = E.getDate();
         var hours:int = E.getHours();
         if(days == 30)
         {
            if(hours == 19)
            {
               this.depth_mc.momo_npc.visible = false;
            }
            else
            {
               this.depth_mc.momo_npc.visible = true;
            }
         }
         else
         {
            this.depth_mc.momo_npc.visible = true;
         }
      }
      
      private function showHouseMsg(evt:MouseEvent) : void
      {
         if(!this.guestbook)
         {
            this.guestbook = new GuestBookLogic();
         }
         else
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("reshow_guest_book"));
         }
      }
      
      private function overHandler(evt:MouseEvent) : void
      {
         evt.target.gotoAndStop(2);
      }
      
      private function outHandler(evt:MouseEvent) : void
      {
         evt.target.gotoAndStop(1);
      }
      
      private function giftHandler(evt:MouseEvent) : void
      {
         var type:Number = 2;
         var str:String = "resource/giftItem/gift022.swf";
         var info:String = "你發現了絲姐姐送出的雪人果實，快收起來裡吧!";
         giftModule.succMsg = "雪人果實已放入你的投擲箱中!!!";
         giftModule.giftData = "giftData_1";
         giftModule.isPet = true;
         giftModule.giftHandler(type,str,info);
      }
      
      private function openDoorEvent(evt:EventTaomee) : void
      {
         GV.Room_DefaultRoomID = 0;
         if(GV.MapInfo_mapID < 1000)
         {
            GV.MyInfo_PrevMap = GV.MapInfo_mapID;
         }
         LocalUserInfo.setMapID(0);
         GV.MyInfo_PrevMap = GV.MyInfo_PrevMap == 58 ? 1 : GV.MyInfo_PrevMap;
         switchMapLogic.switchMapLogicHandler(GV.MyInfo_PrevMap);
      }
      
      private function emaiOldHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!GV.MC_AppLever.getChildByName("oldMailMC"))
         {
            this.oldMailMC = new MovieClip();
            this.oldMailMC.name = "oldMailMC";
            GV.MC_AppLever.addChild(this.oldMailMC);
            tempMC = new MCLoader("resource/email/momoEmail.swf",this.oldMailMC,1,"正在打開公主的信箱......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadMcOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadMcOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         this.momoEmail = new EmailMomoView(childMC);
         childMC.content.root.close_btn.addEventListener(MouseEvent.CLICK,this.removeMoMoEmailHandler);
         var mcloader:MCLoader = evt.target as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadMcOverHandler);
         mcloader.clear();
      }
      
      private function removeMoMoEmailHandler(evt:MouseEvent) : void
      {
         evt.currentTarget.removeEventListener(MouseEvent.CLICK,this.removeMoMoEmailHandler);
         this.momoEmail.removeBtnHandler();
         GC.stopAllMC(this.oldMailMC);
         GC.clearChildren(this.oldMailMC);
         this.oldMailMC.parent.removeChild(this.oldMailMC);
         this.oldMailMC = null;
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         PowerClassInfo.getInstanse().clear();
         SilkyHousePanelAI.getInstanse().clear();
         super.destroy();
      }
   }
}

