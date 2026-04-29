package com.view.JobView.ChildNPCModule.ChildNpc
{
   import com.view.JobView.ChildNPCModule.BaseNPC;
   import com.view.JobView.ChildNPCModule.ModuleJob.BaseAddGameJob;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TestNpc extends BaseNPC
   {
      
      public var npc:BaseAddGameJob;
      
      public function TestNpc()
      {
         super();
      }
      
      override public function setTargetMC(MC:MovieClip) : void
      {
         this.npc = new BaseAddGameJob();
         var game_obj:Object = {
            "name":"game",
            "url":"module/external/MakeYearCard.swf",
            "msg":"try"
         };
         this.npc.setGameInfo(game_obj);
         this.npc.makeInfo("61");
         setModuleFun(this.npc);
         targetMC = MC;
         BC.addEvent(this,targetMC.btn,MouseEvent.CLICK,clickFun);
      }
   }
}

