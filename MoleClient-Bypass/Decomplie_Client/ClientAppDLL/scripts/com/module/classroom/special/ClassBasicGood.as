package com.module.classroom.special
{
   import com.logic.FindPathLogic.MoveTo;
   import com.module.classroom.ClassEditView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ClassBasicGood
   {
      
      public var goodsMC:Object;
      
      public function ClassBasicGood(mc:Object)
      {
         super();
         this.goodsMC = mc;
         this.goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OVER,this.CanMove);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OUT,this.CantMove);
      }
      
      public function changeStatus(e:MouseEvent) : void
      {
         var mc:Object = e.target.parent.mc2.getChildAt(0);
         if(!ClassEditView.Editable)
         {
            if(mc is MovieClip)
            {
               mc.userTool = true;
               if(mc.currentFrame == mc.totalFrames)
               {
                  mc.gotoAndStop(1);
               }
               else
               {
                  mc.nextFrame();
               }
            }
         }
      }
      
      public function CanMove(e:MouseEvent) : void
      {
         if(!ClassEditView.Editable && e.target.parent.mc2.getChildAt(0) is MovieClip)
         {
            MoveTo.CanMove = false;
         }
      }
      
      public function CantMove(e:MouseEvent) : void
      {
         if(!ClassEditView.Editable)
         {
            MoveTo.CanMove = true;
         }
      }
   }
}

