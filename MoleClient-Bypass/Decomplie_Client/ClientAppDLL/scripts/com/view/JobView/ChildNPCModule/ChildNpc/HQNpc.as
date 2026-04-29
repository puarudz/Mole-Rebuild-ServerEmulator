package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseAddGameJob;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HQNpc extends BaseNPC
   {
      
      public var npc:BaseAddGameJob;
      
      public function HQNpc()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip) : void
      {
         this.npc = new BaseAddGameJob();
         this.npc.makeInfo("62");
         var game_obj:Object = {
            "name":"BakeBread",
            "url":"module/game/BakeBread.swf",
            "msg":"try"
         };
         this.npc.setGameInfo(game_obj);
         setModuleFun(this.npc);
         targetMC = MC;
         BC.addEvent(this,targetMC.btn,MouseEvent.CLICK,clickFun);
      }
   }
}

