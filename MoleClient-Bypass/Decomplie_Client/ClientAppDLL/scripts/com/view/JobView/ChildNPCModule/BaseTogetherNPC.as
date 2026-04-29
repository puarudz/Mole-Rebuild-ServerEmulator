package com.view.JobView.ChildNPCModule
{
   import com.common.tip.NpcDialogBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class BaseTogetherNPC extends Sprite
   {
      
      public var targetMC:MovieClip;
      
      public var moveMC:MovieClip;
      
      public var boxMC:NpcDialogBox;
      
      public var moduleFun:BaseNPCModule;
      
      private var num_time:Timer;
      
      public function BaseTogetherNPC()
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEvent);
         super();
      }
      
      public function setTargetMC(MC:MovieClip, mc:MovieClip) : void
      {
         this.targetMC = MC;
         this.moveMC = mc;
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.clickFun);
         BC.addEvent(this,this.targetMC.btn,MouseEvent.MOUSE_OVER,this.OverFun);
         BC.addEvent(this,this.targetMC.btn,MouseEvent.MOUSE_OUT,this.OutFun);
      }
      
      public function clickFun(event:MouseEvent = null) : void
      {
         BC.removeEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.clickFun);
         BC.addEvent(this,this.moduleFun,BaseNPCModule.SHOWNPCBTN,this.showNpcBtn);
         this.moduleFun.npcClientFun(event);
      }
      
      public function showNpcBtn(event:Event) : void
      {
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.clickFun);
      }
      
      public function setModuleFun(fun:BaseNPCModule) : void
      {
         this.moduleFun = fun;
      }
      
      public function OverFun(event:MouseEvent = null) : void
      {
         if(this.moveMC.currentFrame == 1)
         {
            this.moveMC.gotoAndPlay(2);
         }
      }
      
      public function OutFun(event:MouseEvent = null) : void
      {
         this.moveMC.gotoAndStop(1);
      }
      
      public function setTipMC(msg:String) : void
      {
         this.boxMC = new NpcDialogBox(this.targetMC,0,0,1);
         this.boxMC.show(msg);
         this.num_time = GC.setGTimeout(this.closeTipFun,10000);
      }
      
      public function closeTipFun() : void
      {
         if(this.boxMC != null)
         {
            GC.clearGTimeout(this.num_time);
            this.boxMC.destroy();
         }
         this.boxMC = null;
      }
      
      public function removeEvent(eve:*) : void
      {
         if(!this.moduleFun)
         {
            return;
         }
         this.moduleFun.removeEventFun();
         this.closeTipFun();
         BC.removeEvent(this);
      }
   }
}

