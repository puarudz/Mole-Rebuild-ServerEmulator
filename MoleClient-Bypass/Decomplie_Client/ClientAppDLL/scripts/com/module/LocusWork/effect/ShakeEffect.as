package com.module.LocusWork.effect
{
   public class ShakeEffect
   {
      
      private var index:int = 0;
      
      private var diss:Array;
      
      public function ShakeEffect(diss:Array)
      {
         super();
         this.diss = diss;
      }
      
      public function clean() : void
      {
         this.diss = null;
      }
      
      public function start() : void
      {
         this.index = 15;
      }
      
      public function stop() : void
      {
         var i:* = undefined;
         this.index = 0;
         for(i in this.diss)
         {
            this.diss[i].x = 0;
            this.diss[i].y = 0;
         }
      }
      
      public function updata() : void
      {
         var i:* = undefined;
         var ind:int = 0;
         var tx:int = 0;
         var ty:int = 0;
         if(this.index <= 0)
         {
            for(i in this.diss)
            {
               this.diss[i].x = 0;
               this.diss[i].y = 0;
            }
            return;
         }
         --this.index;
         ind = this.index % 5;
         switch(ind)
         {
            case 0:
               tx = 0;
               ty = 0;
               break;
            case 1:
               tx = 0;
               ty = -2;
               break;
            case 2:
               tx = 0;
               ty = 2;
               break;
            case 3:
               tx = -2;
               ty = 0;
               break;
            case 4:
               tx = 2;
               ty = 0;
         }
         for(i in this.diss)
         {
            this.diss[i].x = tx;
            this.diss[i].y = ty;
         }
      }
   }
}

