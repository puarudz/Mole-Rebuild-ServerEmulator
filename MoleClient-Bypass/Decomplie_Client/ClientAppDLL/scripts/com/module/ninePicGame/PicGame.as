package com.module.ninePicGame
{
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PicGame extends MovieClip
   {
      
      public static var ghostFire:Boolean;
      
      public var arr:Array;
      
      public var posarr:Array;
      
      public var winposarr:Array;
      
      public var MC:MovieClip;
      
      public var w:Number = 73;
      
      public var h:Number = 39;
      
      public var oneMC:*;
      
      public var twoMC:*;
      
      public var doorMC:*;
      
      public var nums:uint;
      
      public var getCandy:Boolean;
      
      public function PicGame(mc:MovieClip, xnum:uint, ynum:uint)
      {
         var j:uint = 0;
         this.arr = new Array();
         this.posarr = new Array();
         this.winposarr = new Array();
         super();
         this.getCandy = false;
         this.MC = mc;
         this.MC.goldkey.visible = false;
         for(var i:uint = 0; i < xnum; i++)
         {
            for(j = 0; j < ynum; j++)
            {
               this.posarr.push([j * this.w,i * this.h]);
            }
         }
         this.nums = xnum * ynum;
         this.init();
      }
      
      public function initwinpos() : void
      {
         this.winposarr = new Array();
         for(var i:uint = 0; i < this.nums; i++)
         {
            this.winposarr.push([this.posarr[i][0],this.posarr[i][1]]);
         }
      }
      
      public function init() : void
      {
         for(var i:uint = 0; i < this.nums; i++)
         {
            if(Math.random() > 0.5)
            {
               this.arr.push(i);
            }
            else
            {
               this.arr.unshift(i);
            }
         }
         this.initwinpos();
         for(var j:uint = 0; j < this.nums; j++)
         {
            this.MC["mc" + this.arr[j]].num = this.arr[j];
            this.MC["mc" + this.arr[j]].x = this.posarr[j][0];
            this.MC["mc" + this.arr[j]].y = this.posarr[j][1];
            this.MC["mc" + this.arr[j]].addEventListener(MouseEvent.CLICK,this.moveStone);
         }
      }
      
      private function changePlace(a:DisplayObject, b:DisplayObject) : void
      {
         var ax:Number = NaN;
         ax = a.x;
         a.x = b.x;
         b.x = ax;
         var ay:Number = a.y;
         a.y = b.y;
         b.y = ay;
      }
      
      public function moveStone(e:Event) : void
      {
         var handbg:* = undefined;
         if(this.oneMC == null)
         {
            this.oneMC = e.currentTarget;
            handbg = this.oneMC.getChildAt(1);
            if(handbg is MovieClip)
            {
               handbg.gotoAndStop(2);
            }
            if(this.oneMC.name == "mc0" && ghostFire && e.target.name == "hand")
            {
               this.mywin();
               if(this.win())
               {
                  this.openDoor();
               }
            }
         }
         else
         {
            handbg = this.oneMC.getChildAt(1);
            handbg.gotoAndStop(1);
            this.twoMC = e.currentTarget;
            trace(this.oneMC.name,this.twoMC.name);
            this.changePlace(this.oneMC,this.twoMC);
            if(this.win())
            {
               this.openDoor();
            }
            this.oneMC = null;
            this.twoMC = null;
         }
      }
      
      public function openDoor() : void
      {
         if(!this.getCandy)
         {
            this.MC.goldkey.visible = true;
            this.getCandy = true;
            GV.onlineSocket.dispatchEvent(new EventTaomee("REACH_KEY",{"type":9}));
         }
      }
      
      public function mywin() : void
      {
         for(var j:uint = 0; j < this.nums; j++)
         {
            this.MC["mc" + j].x = this.winposarr[j][0];
            this.MC["mc" + j].y = this.winposarr[j][1];
         }
      }
      
      public function win() : Boolean
      {
         for(var j:uint = 0; j < this.nums; j++)
         {
            if(!(this.MC["mc" + j].x == this.winposarr[j][0] && this.MC["mc" + j].y == this.winposarr[j][1]))
            {
               return false;
            }
         }
         return true;
      }
   }
}

