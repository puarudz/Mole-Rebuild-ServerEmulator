package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseTogetherNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseExplainNpc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class rocNPC extends BaseTogetherNPC
   {
      
      private var npc:BaseExplainNpc;
      
      public function rocNPC()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip, mc:MovieClip) : void
      {
         this.npc = new BaseExplainNpc();
         setModuleFun(this.npc);
         targetMC = MC;
         moveMC = mc;
         BC.addEvent(this,targetMC.btn,MouseEvent.CLICK,clickFun);
         setTipMC("我是行政官洛克");
      }
   }
}

