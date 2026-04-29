package com.module.ninePicGame
{
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.logic.switchMapLogic.switchMapLogic;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class fourDoor
   {
      
      private var mcloader:MCLoader;
      
      private var MC:MovieClip;
      
      private var darkMC:MovieClip;
      
      private var posArr:Array = [0,1,2,3];
      
      private var gotoResultArr:Array = [0,1,2,3];
      
      private var firstBool:Boolean = true;
      
      private var trueDoor:uint = 0;
      
      public function fourDoor(mc:MovieClip, topmc:MovieClip)
      {
         super();
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         GV.onlineSocket.addEventListener("fireAction_suc",this.goto);
         this.darkMC = topmc.dark_mc;
         this.MC = mc;
         this.MC.guessBtn.visible = false;
         this.MC.gameMC.visible = false;
         PicGame.ghostFire = false;
         this.changearr();
         this.init();
      }
      
      public function init() : void
      {
         var num:int = 0;
         this.gotoResultArr = [0,1,2,3];
         for(var i:uint = 0; i < 4; i++)
         {
            this.MC["door" + i].x = this.posArr[i] * 160 + 219;
            this.MC["t_" + i].x = this.MC["door" + i].x;
            num = int(this.gotoResultArr.splice(int(Math.random() * this.gotoResultArr.length),1)[0]);
            this.MC["door" + i].num = num;
            trace(this.MC["door" + i].num);
            if(num == 0 || num == 1)
            {
               this.MC["door" + i].mc.gotoAndPlay(2);
            }
            else
            {
               this.MC["door" + i].mc.gotoAndStop(1);
            }
            if(this.firstBool)
            {
               this.MC["door" + i].buttonMode = true;
               this.MC["door" + i].addEventListener(MouseEvent.MOUSE_OVER,this.goto2);
               this.MC["door" + i].addEventListener(MouseEvent.MOUSE_OUT,this.goto1);
            }
         }
         this.MC.ghostFire.addEventListener(MouseEvent.CLICK,this.showDoorNO);
         this.firstBool = false;
      }
      
      public function showDoorNO(e:Event) : void
      {
         if(!this.MC.gameMC.visible)
         {
            PicGame.ghostFire = true;
         }
      }
      
      private function getRoomID(evt:MouseEvent) : void
      {
      }
      
      public function goto(e:EventTaomee) : void
      {
         var i:uint = 0;
         var num:int = int(e.EventObj.num);
         if(num == 0)
         {
            trace("--對",num);
            if(GV.MAN_PEOPLE.Petlevel > -1)
            {
               this.MC.room_mc.visible = true;
               this.MC.room_new.visible = true;
            }
            this.MC.gameMC.visible = true;
            for(i = 0; i < 4; i++)
            {
               this.MC["door" + i].visible = false;
            }
            new PicGame(this.MC.gameMC,5,5);
            this.MC.guessBtn.visible = true;
         }
         else if(num == 1)
         {
            this.changearr();
            this.init();
            this.darkMC.gotoAndPlay(2);
            trace("--重進",num);
         }
         else
         {
            GV.Room_DefaultRoomID = 0;
            LocalUserInfo.setMapID(0);
            switchMapLogic.switchMapLogicHandler(int(Math.random() * 10) + 1);
            trace("--錯",num);
         }
      }
      
      public function changearr() : void
      {
         for(var i:uint = 0; i < 4; i++)
         {
            this.posArr.push(this.posArr.splice(int(Math.random() * 4),1)[0]);
         }
         trace(this.posArr);
      }
      
      public function goto2(e:Event) : void
      {
         e.currentTarget.gotoAndStop(3);
      }
      
      public function goto1(e:Event) : void
      {
         e.currentTarget.gotoAndStop(1);
      }
      
      public function removeEventHandler(e:Event) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         GV.onlineSocket.removeEventListener("fireAction_suc",this.goto);
         this.MC.ghostFire.removeEventListener(MouseEvent.CLICK,this.showDoorNO);
         for(var i:uint = 0; i < 4; i++)
         {
            this.MC["door" + i].removeEventListener(MouseEvent.CLICK,this.goto);
            this.MC["door" + i].removeEventListener(MouseEvent.MOUSE_OVER,this.goto2);
            this.MC["door" + i].removeEventListener(MouseEvent.MOUSE_OUT,this.goto1);
         }
      }
   }
}

