package com.view.PeopleView.ChildPeople
{
   import com.core.manager.IndexManager;
   import com.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class moreAvatar extends simplePeople
   {
      
      public function moreAvatar()
      {
         super();
         offset = 8;
      }
      
      public function init(instanceMC:MovieClip, mc:MovieClip) : void
      {
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
            if(InstanceMC.address == "17003")
            {
               isActionMovie = false;
               body_mc = IndexManager.getInstance().getMovieClip("body1");
               BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
               avatarMC.Visualize_mc.addChild(body_mc);
               scaleBody(1.5);
            }
            else if(InstanceMC.address != "0")
            {
               isActionMovie = true;
               InstanceMC.isActionMovie = true;
               tempAvatar = UIManager.getClass("body_" + InstanceMC.address);
               body_mc = new tempAvatar();
               BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
               avatarMC.Visualize_mc.addChild(body_mc);
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
            }
            else
            {
               isActionMovie = false;
               body_mc = IndexManager.getInstance().getMovieClip("body1");
               BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
               avatarMC.Visualize_mc.addChild(body_mc);
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
            }
         }
         catch(E:Error)
         {
         }
      }
   }
}

