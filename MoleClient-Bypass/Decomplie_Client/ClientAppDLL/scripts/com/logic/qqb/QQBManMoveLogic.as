package com.logic.qqb
{
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   
   public class QQBManMoveLogic
   {
      
      private var qqbLogic:QQBLogic;
      
      private var DIR:Number;
      
      private var targetX:Number;
      
      private var VX:Number = 2;
      
      private var MAN:PeopleManageView;
      
      public function QQBManMoveLogic(qqbLogic:QQBLogic)
      {
         super();
         this.qqbLogic = qqbLogic;
      }
      
      public function move(userID:int, posX:int) : void
      {
         this.MAN = GF.getPeopleByID(userID) as PeopleManageView;
         this.targetX = posX;
         this.DIR = this.targetX >= this.MAN.x ? 1 : -1;
         this.addEventHandler();
      }
      
      public function clear() : void
      {
         this.MAN.removeEventListener(Event.ENTER_FRAME,this.peopleMoveHandler);
         this.MAN = null;
         this.qqbLogic = null;
      }
      
      private function addEventHandler() : void
      {
         this.MAN.addEventListener(Event.ENTER_FRAME,this.peopleMoveHandler);
      }
      
      private function removeEventHandler() : void
      {
         this.MAN.removeEventListener(Event.ENTER_FRAME,this.peopleMoveHandler);
      }
      
      private function peopleMoveHandler(event:Event) : void
      {
         if(this.DIR == 1 && this.MAN.x + this.VX * this.DIR > this.targetX || this.DIR == -1 && this.MAN.x + this.VX * this.DIR < this.targetX)
         {
            this.removeEventHandler();
            this.MAN.x = this.targetX;
         }
         else
         {
            this.MAN.x += this.VX * this.DIR;
         }
         if(this.MAN.x < 0)
         {
            this.MAN.avatarMC.Visualize_mc.scaleX = -1;
         }
         else if(this.MAN.x > 0)
         {
            this.MAN.avatarMC.Visualize_mc.scaleX = 1;
         }
      }
   }
}

