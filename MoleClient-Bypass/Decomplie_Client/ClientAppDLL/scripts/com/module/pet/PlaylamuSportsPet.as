package com.module.pet
{
   import com.core.info.LocalUserInfo;
   import com.logic.socket.petSocket.adoptPet.petPlayReq;
   import com.logic.socket.petSocket.adoptPet.petPlayRes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlaylamuSportsPet
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var playpet:MovieClip;
      
      public function PlaylamuSportsPet(mc:MovieClip, dmc:MovieClip)
      {
         super();
         this.target_mc = mc;
         this.depth_mc = dmc;
         this.target_mc.play1_btn.addEventListener(MouseEvent.CLICK,this.playpet1);
         this.target_mc.play2_btn.addEventListener(MouseEvent.CLICK,this.playpet2);
         GV.onlineSocket.addEventListener("play_pet_finish",this.finishPlay);
         GV.onlineSocket.addEventListener("lahm_go_home",this.run_mcStop);
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
      }
      
      public function run_mcStop(e:Event) : void
      {
         this.kaddishEndHandler();
      }
      
      public function playpet1(e:Event) : void
      {
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         if(GV.MyInfo_PetObj.Level > 1 && Boolean(mole.avatarClass.avatarMC.pet_mc.visible))
         {
            if(Boolean(this.playpet))
            {
               this.stopPlayPet();
            }
            this.playpet = this.target_mc.lahm1;
            this.lahmRun();
         }
      }
      
      public function playpet2(e:Event) : void
      {
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         if(GV.MyInfo_PetObj.Level > 1 && Boolean(mole.avatarClass.avatarMC.pet_mc.visible))
         {
            if(Boolean(this.playpet))
            {
               this.stopPlayPet();
            }
            this.playpet = this.depth_mc.petSkip.lahm2;
            this.lahmRun();
         }
      }
      
      private function finishPlay(e:Event) : void
      {
         GV.onlineSocket.addEventListener(petPlayRes.GET_PETSHOP_SUCC,this.addSpirit);
         petPlayReq.sendpetPlayReq();
      }
      
      private function stopPlayPet() : void
      {
         if(Boolean(this.playpet))
         {
            GC.stopAllMC(this.playpet);
            this.playpet.visible = false;
            this.depth_mc.petSkip.left_lahm.gotoAndStop(1);
            this.depth_mc.petSkip.right_lahm.gotoAndStop(1);
         }
      }
      
      private function addSpirit(e:Event) : void
      {
         GV.onlineSocket.removeEventListener(petPlayRes.GET_PETSHOP_SUCC,this.addSpirit);
         trace("增加心情OK");
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         if(Boolean(mole))
         {
            mole.avatarClass.avatarMC.pet_mc.visible = true;
            this.stopPlayPet();
         }
      }
      
      private function lahmRun() : void
      {
         GV.onlineSocket.addEventListener("iskaddish",this.kaddishEndHandler);
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.avatarClass.avatarMC.pet_mc.visible = false;
         if(this.playpet.name == "lahm2")
         {
            this.depth_mc.petSkip.left_lahm.play();
            this.depth_mc.petSkip.right_lahm.play();
         }
         this.playpet.visible = true;
         this.playpet.hat.gotoAndPlay(2);
         this.playpet.petBody.gotoAndPlay(2);
         this.playpet.yy.gotoAndPlay(2);
         GF.setPetColor(this.playpet.petBody,GV.MyInfo_PetObj.Color);
      }
      
      private function kaddishEndHandler(e:Event = null) : void
      {
         trace("取消");
         var mole:* = GF.getPeopleByID(LocalUserInfo.getUserID());
         mole.avatarClass.avatarMC.pet_mc.visible = true;
         this.stopPlayPet();
      }
      
      private function removeEventHandler(e:Event = null) : void
      {
         this.target_mc.play1_btn.removeEventListener(MouseEvent.CLICK,this.playpet1);
         this.target_mc.play2_btn.removeEventListener(MouseEvent.CLICK,this.playpet2);
         GV.onlineSocket.removeEventListener("play_pet_finish",this.finishPlay);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         GV.onlineSocket.removeEventListener("iskaddish",this.kaddishEndHandler);
         GV.onlineSocket.removeEventListener("lahm_go_home",this.run_mcStop);
      }
   }
}

