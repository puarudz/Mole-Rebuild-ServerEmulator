package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseOverJob;
   import flash.display.MovieClip;
   
   public class AndyNpc extends BaseNPC
   {
      
      private var npc:BaseOverJob;
      
      public function AndyNpc()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip) : void
      {
         this.npc = new BaseOverJob();
         this.npc.makeInfo("161");
         setModuleFun(this.npc);
         targetMC = MC;
      }
   }
}

