package com.view.PeopleView
{
   import flash.display.MovieClip;
   
   public final dynamic class VisualizeView extends MovieClip
   {
      
      public function VisualizeView()
      {
         super();
      }
      
      override public function set visible(bool:Boolean) : void
      {
         if(Boolean(bool && parent.parent) && Boolean(PeopleManageView(parent.parent).hasCar) && Boolean(PeopleManageView(parent.parent).petMode))
         {
            bool = false;
         }
         super.visible = bool;
      }
      
      override public function set cacheAsBitmap(bool:Boolean) : void
      {
         if(Boolean(PeopleManageView(parent.parent)) && PeopleManageView(parent.parent).hasCar)
         {
            PeopleManageView(parent.parent).avatarMC.car_mc.cacheAsBitmap = bool;
         }
         super.cacheAsBitmap = bool;
      }
   }
}

