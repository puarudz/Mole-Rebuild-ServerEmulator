package com.module.angelPark.viewControl
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class SLParkLivePointView extends ParkLivePointView
   {
      
      public function SLParkLivePointView(ui:MovieClip, posId:int)
      {
         super(ui,posId);
      }
      
      override public function UpdateAngel() : void
      {
         super.UpdateAngel();
         if(!this.hasAngel)
         {
            if(!_angelParkData.angelParkVO.isVip)
            {
               this.locked = true;
            }
         }
      }
      
      override protected function OnMouseOver(e:MouseEvent) : void
      {
         super.OnMouseOver(e);
         if(locked)
         {
            GF.showTip("擁有超級拉姆後解鎖");
            return;
         }
      }
   }
}

