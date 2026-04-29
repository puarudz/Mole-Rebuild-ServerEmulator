package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.activityModule.Presented;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.map.MapBase;
   import com.view.mapView.activity.Task83.Anniversary;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MomoBedroomView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var type_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var button_mc:MovieClip;
      
      public var top_mc:MovieClip;
      
      private var startCount:int = 0;
      
      private var clickMC:MovieClip;
      
      private var frameMC:MovieClip;
      
      private var startBool:Boolean = false;
      
      private var firstBool:Boolean = false;
      
      public function MomoBedroomView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.type_mc = GV.MC_mapFrame["type_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.button_mc = GV.MC_mapFrame["buttonLevel"];
         this.top_mc = GV.MC_mapFrame["top_mc"];
         BC.addEvent(this,TalkEvent,"maid2_openGame110",function(e:*):*
         {
         });
         this.gameStart();
      }
      
      private function gameStart() : void
      {
         if(creatShareObject.getInstance().getNoteData() == 7)
         {
            creatShareObject.getInstance().setNoteData(7);
            Anniversary.getInstance().openMC(7);
         }
         if(this.startCount <= 10)
         {
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
            finishSomethingReq.sendReq(31386);
         }
         this.target_mc.npc_btn.buttonMode = true;
         BC.addEvent(this,this.target_mc.npc_btn,MouseEvent.CLICK,this.npcClickHndler);
      }
      
      private function npcClickHndler(evt:MouseEvent) : void
      {
      }
      
      private function getFinishNumHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
         this.startCount = evt.EventObj.Done;
      }
      
      private function activityClickHandler(evt:MouseEvent) : void
      {
         if(this.startBool)
         {
            Alert.smileAlart("    公主已深深陷入沉睡，找侍女一起喚醒公主吧！");
            return;
         }
         this.startEvent();
      }
      
      private function startEvent() : void
      {
         var _m:int = 0;
         this.startBool = true;
         if(this.startCount < 10)
         {
            _m = Math.random() * 10;
            this.clickMC = this.button_mc.activity_mc["mc" + _m];
            this.clickMC.visible = true;
            this.clickMC.buttonMode = true;
            BC.addOnceEvent(this,this.clickMC,MouseEvent.CLICK,this.clickMCHandler);
         }
         else
         {
            Alert.smileAlart("    今天你已經不能再參與這次活動了，明天再來吧!");
         }
      }
      
      private function clickMCHandler(evt:MouseEvent) : void
      {
         this.clickMC.gotoAndStop(2);
         BC.addEvent(this,this.clickMC,Event.ENTER_FRAME,this.enterHandler);
      }
      
      private function enterHandler(evt:Event) : void
      {
         if(this.clickMC.currentFrame == 2)
         {
            if(this.frameMC == null)
            {
               this.frameMC = MovieClip(this.clickMC.getChildAt(0));
            }
            else if(this.frameMC.currentFrame == this.frameMC.totalFrames)
            {
               BC.removeEvent(this,this.clickMC,Event.ENTER_FRAME,this.enterHandler);
               this.frameMC.gotoAndStop(1);
               this.clickMC.gotoAndStop(1);
               this.clickMC.visible = false;
               this.clickMC.buttonMode = false;
               this.frameMC = null;
               this.clickMC = null;
               this.startBool = false;
               this.firstBool = true;
               Presented.getInstance().celebrate1225(1416,1,0,"","對不起，今天已經達到遊戲上限，明天再來吧！");
            }
         }
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
   }
}

