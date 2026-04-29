package com.view.JobView
{
   import com.view.JobView.ChildNPCJob.JesseNPC;
   import com.view.JobView.ChildNPCJob.LLNPC;
   import com.view.JobView.ChildNPCJob.amyNPC;
   import com.view.JobView.ChildNPCJob.bodhiNPC;
   import com.view.JobView.ChildNPCJob.guideNPC;
   import com.view.JobView.ChildNPCJob.kevinNPC;
   import flash.display.MovieClip;
   
   public class NPCLogic extends MovieClip
   {
      
      public static var NPC_ID:int = 0;
      
      public function NPCLogic()
      {
         super();
      }
      
      public static function init(box:MovieClip, btn:*, mc:MovieClip, ID:int) : MovieClip
      {
         var temp:MovieClip = null;
         NPC_ID = ID;
         return generalVersionFun(box,btn,mc,ID);
      }
      
      public static function generalVersionFun(box:MovieClip, btn:*, mc:MovieClip, ID:int) : MovieClip
      {
         var temp:MovieClip = null;
         switch(NPC_ID)
         {
            case 0:
               temp = new guideNPC(box,btn,mc,ID);
               break;
            case 46:
               temp = new JesseNPC(box,btn,mc,ID);
               break;
            case 44:
               temp = new LLNPC(box,btn,mc,ID);
               break;
            case 45:
               temp = new amyNPC(box,btn,mc,ID);
               break;
            case 52:
               temp = new kevinNPC(box,btn,mc,ID);
               break;
            case 53:
               temp = new bodhiNPC(box,btn,mc,ID);
         }
         return temp;
      }
   }
}

