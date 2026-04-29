package com.module.home.special
{
   import com.logic.FindPathLogic.MoveTo;
   import com.module.home.HomeEditView;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.media.SoundMixer;
   
   public class BasicGood
   {
      
      public var goodsMC:*;
      
      public function BasicGood(mc:*)
      {
         super();
         this.goodsMC = mc;
         this.goodsMC.btn.addEventListener(MouseEvent.CLICK,this.changeStatus);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OVER,this.CanMove);
         this.goodsMC.btn.addEventListener(MouseEvent.MOUSE_OUT,this.CantMove);
      }
      
      public function changeStatus(e:MouseEvent) : void
      {
         SoundMixer.stopAll();
         var mc:* = e.target.parent.mc2.getChildAt(0);
         if(!HomeEditView.Editable)
         {
            if(mc is MovieClip)
            {
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
         if(!HomeEditView.Editable && e.target.parent.mc2.getChildAt(0) is MovieClip)
         {
            MoveTo.CanMove = false;
         }
      }
      
      public function CantMove(e:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            MoveTo.CanMove = true;
         }
      }
   }
}

