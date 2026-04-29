package com.view.PeopleView.ChildPeople
{
   import com.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class hubbleAvatar extends simplePeople
   {
      
      public function hubbleAvatar()
      {
         super();
         offset = 8;
      }
      
      public function init(instanceMC:MovieClip, mc:MovieClip) : void
      {
         instanceMC.isFootballBay = true;
         ResetAndDisposeBmp();
         initSimplePeople(instanceMC,mc);
      }
      
      override public function initAvatar() : void
      {
         var tempAvatar:* = undefined;
         GF.hideActionView(InstanceMC.id);
         avatarMC.nickName_txt.text = InstanceMC["nickName"];
         avatarMC.nickName_txt.x = -avatarMC.nickName_txt.width / 2;
         GC.clearAllChildren(avatarMC.Visualize_mc);
         try
         {
            isActionMovie = true;
            InstanceMC.isActionMovie = true;
            tempAvatar = UIManager.getClass("body_" + InstanceMC.address);
            body_mc = new tempAvatar();
            BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
            avatarMC.Visualize_mc.addChild(body_mc);
            avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.9;
            avatarMC.shadow_mc.alpha = 0.8;
            speed = defaultSpeed * 0.8;
         }
         catch(E:Error)
         {
         }
      }
   }
}

