package com.view.PeopleView.ChildPeople
{
   import com.core.manager.IndexManager;
   import com.core.manager.UIManager;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.loader.ContentInfo;
   import org.taomee.log.Logger;
   
   public class TransfigurationAvatar extends simplePeople
   {
      
      private var curLabel:String;
      
      public function TransfigurationAvatar()
      {
         super();
         offset = 8;
      }
      
      public function init(instanceMC:MovieClip, mc:MovieClip) : void
      {
         initSimplePeople(instanceMC,mc);
         if(InstanceMC.address == "17001" || InstanceMC.address == "17004")
         {
            instanceMC.isFootballBay = true;
         }
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
         var isSpecial:Boolean = false;
         switch(InstanceMC.address)
         {
            case "17001":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
               speed = defaultSpeed;
               break;
            case "19000":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 1.2;
               break;
            case "17023":
            case "17024":
            case "17025":
            case "17026":
            case "10000":
            case "10001":
            case "10002":
            case "17027":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
               speed = defaultSpeed;
               break;
            case "19002":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 1.2;
               break;
            case "17010":
            case "17011":
            case "17013":
            case "17014":
            case "17015":
            case "17016":
            case "17017":
            case "17018":
            case "17019":
            case "17020":
            case "17021":
            case "17028":
            case "17029":
            case "17030":
            case "17031":
            case "17032":
            case "17033":
            case "150017":
            case "17037":
            case "17038":
            case "17051":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.9;
               avatarMC.shadow_mc.alpha = 1;
               speed = defaultSpeed * 0.8;
               break;
            case "17004":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.9;
               avatarMC.shadow_mc.alpha = 0.8;
               speed = defaultSpeed * 0.8;
               break;
            case "17002":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
               speed = defaultSpeed * 1.1;
               break;
            case "18001":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 1.2;
               break;
            case "17005":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.6;
               speed = defaultSpeed * 0.8;
               break;
            case "10013":
            case "10014":
            case "10015":
            case "10016":
            case "10017":
            case "10018":
            case "10019":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed;
               break;
            case "17008":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 0.4;
               break;
            case "17007":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 0.4;
               break;
            case "17006":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
               speed = defaultSpeed * 1.4;
               break;
            case "19001":
               avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               speed = defaultSpeed * 1.2;
               break;
            default:
               GC.clearAllChildren(avatarMC.Visualize_mc);
               if(InstanceMC.address == "17003")
               {
                  isSpecial = true;
                  isActionMovie = false;
                  body_mc = IndexManager.getInstance().getMovieClip("body1");
                  scaleBody(1.5);
               }
               else if(InstanceMC.address != "0")
               {
                  avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 0.5;
               }
               else
               {
                  isSpecial = true;
                  isActionMovie = false;
                  body_mc = IndexManager.getInstance().getMovieClip("body1");
                  avatarMC.shadow_mc.scaleX = avatarMC.shadow_mc.scaleY = 1;
               }
         }
         Logger.info(this,"變身ID:" + InstanceMC.address);
         if(isSpecial)
         {
            BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
            avatarMC.Visualize_mc.addChild(body_mc);
         }
         else
         {
            tempAvatar = UIManager.getClass("body_" + InstanceMC.address);
            body_mc = new tempAvatar();
            avatarMC.Visualize_mc.addChild(body_mc);
         }
      }
      
      override public function showActionWithId(actionId:uint, dir:uint, loop:uint = 0, loopOverAction:int = 1) : void
      {
         var mc:MovieClip = null;
         super.showActionWithId(actionId,dir,loop,loopOverAction);
         this.curLabel = LABEL_ACTION_ARR[dir];
         if(Boolean(body_mc))
         {
            body_mc.removeEventListener(Event.ENTER_FRAME,this.bodyMcEnterFrameHandler);
            if(actionId == PlayerActionConstant.ACTION_RUN)
            {
               body_mc.addEventListener(Event.ENTER_FRAME,this.bodyMcEnterFrameHandler);
            }
            else
            {
               mc = body_mc.getChildAt(0) as MovieClip;
               mc.gotoAndStop(1);
            }
         }
      }
      
      private function bodyMcEnterFrameHandler(evt:Event) : void
      {
         var mc:MovieClip = null;
         var targetMc:MovieClip = evt.target as MovieClip;
         if(targetMc.currentFrameLabel == this.curLabel)
         {
            mc = targetMc.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               mc.play();
            }
            targetMc.removeEventListener(Event.ENTER_FRAME,this.bodyMcEnterFrameHandler);
         }
         if(!body_mc)
         {
            targetMc.removeEventListener(Event.ENTER_FRAME,this.bodyMcEnterFrameHandler);
         }
      }
      
      private function getAvatarSwf(loadContext:ContentInfo) : void
      {
         body_mc = loadContext.content as MovieClip;
         BC.addEvent(this,body_mc,Event.ADDED_TO_STAGE,initHandler);
         avatarMC.Visualize_mc.addChild(body_mc);
      }
   }
}

