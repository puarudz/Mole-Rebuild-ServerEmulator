package com.view.PeopleView.ChildPeople
{
   import com.core.manager.UIManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class DigTreasureAvatar extends simplePeople
   {
      
      public function DigTreasureAvatar()
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
         isActionMovie = true;
         InstanceMC.isActionMovie = true;
         tempAvatar = UIManager.getClass("body_" + InstanceMC.address);
         body_mc = new tempAvatar();
         BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
         avatarMC.Visualize_mc.addChild(body_mc);
         avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
         speed = defaultSpeed;
      }
      
      override public function showAction(dir:String = "", changeDir:Boolean = true) : void
      {
         var tempDirection:String = null;
         var tempMC:MovieClip = null;
         var frameLabel:String = null;
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         if(Boolean(InstanceMC))
         {
            InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_BEFORE));
         }
         if(dir != "")
         {
            if(changeDir)
            {
               currentDirection = dir;
            }
            tempDirection = dir;
         }
         else
         {
            tempDirection = currentDirection;
         }
         for(var i:uint = 0; i < body_mc.parent.numChildren; i++)
         {
            tempMC = body_mc.parent.getChildAt(i) as MovieClip;
            if(Boolean(tempMC))
            {
               frameLabel = tempMC.currentLabel;
               if(frameLabel != tempDirection)
               {
                  BC.addEvent(this,tempMC,Event.ADDED,playMovieClip);
                  tempMC.gotoAndStop(tempDirection);
               }
               else
               {
                  BC.addEvent(this,tempMC,Event.ADDED,playMovieClip);
                  tempMC.dispatchEvent(new Event(Event.ADDED));
               }
            }
         }
         dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         if(Boolean(InstanceMC))
         {
            InstanceMC.dispatchEvent(new Event(PeopleManageView.ON_ACTION_SHOW_AFTER));
         }
      }
   }
}

