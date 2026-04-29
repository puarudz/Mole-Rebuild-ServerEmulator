package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseJOB;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ShieldNpc extends BaseNPC
   {
      
      public var npc:BaseJOB;
      
      public function ShieldNpc()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip) : void
      {
         this.npc = new BaseJOB();
         this.npc.makeInfo("152");
         setModuleFun(this.npc);
         targetMC = MC;
         BC.addEvent(this,targetMC.btn,MouseEvent.CLICK,clickFun);
      }
   }
}

