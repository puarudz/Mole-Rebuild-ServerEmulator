package com.view.PeopleView.ChildPeople
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class footballAvatar extends simplePeople
   {
      
      public function footballAvatar()
      {
         super();
         offset = 8;
      }
      
      public function init(instanceMC:MovieClip, mc:MovieClip) : void
      {
         instanceMC.isFootballBay = true;
         this.ResetAndDisposeBmp();
         initSimplePeople(instanceMC,mc);
      }
      
      public function dance2() : void
      {
         isdoAction = true;
         currentDirection = "dance2_down";
         showAction();
         dispatchEvent(new Event("dance2"));
      }
      
      override public function ReplaceToBmp(bool:Boolean = false) : void
      {
      }
      
      override public function ResetAndDisposeBmp() : void
      {
      }
      
      override public function initAvatar() : void
      {
         var tempAvatar:* = undefined;
         avatarMC.nickName_txt.text = InstanceMC["nickName"];
         avatarMC.nickName_txt.x = -avatarMC.nickName_txt.width / 2;
         trace("",InstanceMC.address);
         GC.clearAllChildren(avatarMC.Visualize_mc);
         InstanceMC.isActionMovie = isActionMovie = true;
         tempAvatar = GV.Lib_Map.getClass(InstanceMC.address);
         body_mc = new tempAvatar();
         BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
         avatarMC.Visualize_mc.addChild(body_mc);
         avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
      }
   }
}

