package com.module.home.itemCon
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Item1220425Logic
   {
      
      private static var instance:Item1220425Logic = null;
      
      private var _targetMC:MovieClip;
      
      public function Item1220425Logic()
      {
         super();
      }
      
      public static function getInstance() : Item1220425Logic
      {
         return instance = instance || new Item1220425Logic();
      }
      
      public function init(targetMC:MovieClip) : void
      {
         this._targetMC = targetMC;
         this._targetMC.parent.addEventListener(MouseEvent.CLICK,this.onClick);
         this.randomPlay();
      }
      
      private function onClick(e:MouseEvent) : void
      {
         this.randomPlay();
      }
      
      private function randomPlay() : void
      {
         var i:uint = 0;
         var num:int = int(uint(Math.random() * 3));
         this._targetMC["mc_0"].visible = false;
         this._targetMC["mc_1"].visible = false;
         for(this._targetMC["mc_2"].visible = false; i < 3; )
         {
            if(num == i)
            {
               this._targetMC["mc_" + i.toString()].visible = true;
               this._targetMC["mc_" + i.toString()].play();
            }
            else
            {
               this._targetMC["mc_" + i.toString()].gotoAndStop(1);
            }
            i++;
         }
      }
   }
}

