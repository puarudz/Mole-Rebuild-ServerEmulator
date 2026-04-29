package com.view.PeopleView
{
   import com.module.pet.petLogic;
   import flash.display.MovieClip;
   
   public final dynamic class petView extends MovieClip
   {
      
      public function petView()
      {
         super();
      }
      
      override public function set visible(bool:Boolean) : void
      {
         var p:PeopleManageView = parent.parent as PeopleManageView;
         if(bool && p.hasCar && p.Petlevel > 0)
         {
            if(p.Petlevel == 101 || p.id == GV.MyInfo_userID && petLogic.PetCan(11))
            {
               bool = true;
            }
            else if(p.Petlevel == 101 || Boolean(p.canFly))
            {
               bool = true;
            }
            else
            {
               bool = false;
            }
         }
         super.visible = bool;
      }
      
      override public function set cacheAsBitmap(bool:Boolean) : void
      {
      }
      
      override public function set x(num:Number) : void
      {
         if(!parent)
         {
            super.x = num;
            return;
         }
         var p:PeopleManageView = parent.parent as PeopleManageView;
         if(p.hasDragon)
         {
            super.x = -15;
         }
         else
         {
            super.x = num;
         }
      }
      
      override public function set y(num:Number) : void
      {
         if(!parent)
         {
            super.y = num;
            return;
         }
         var p:PeopleManageView = parent.parent as PeopleManageView;
         if(p.hasDragon)
         {
            super.y = -8;
         }
         else
         {
            super.y = num;
         }
      }
   }
}

