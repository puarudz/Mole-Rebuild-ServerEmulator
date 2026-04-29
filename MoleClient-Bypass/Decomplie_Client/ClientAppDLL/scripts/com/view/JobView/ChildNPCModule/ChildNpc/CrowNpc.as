package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseOverJob;
   import flash.display.MovieClip;
   
   public class CrowNpc extends BaseNPC
   {
      
      private var npc:BaseOverJob;
      
      public function CrowNpc()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip) : void
      {
         this.npc = new BaseOverJob();
         this.npc.makeInfo("131");
         setModuleFun(this.npc);
         targetMC = MC;
      }
   }
}

