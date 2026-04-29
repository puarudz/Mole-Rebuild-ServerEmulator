package com.module.ninePicGame
{
   import com.common.Tween.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ninePicGame extends MovieClip
   {
      
      public var arr:Array = new Array();
      
      public var posarr:Array = new Array();
      
      public var MC:* = new Array();
      
      public var doorMC:MovieClip;
      
      public var funNum:int;
      
      public var props_obj:Object;
      
      public var w:Number;
      
      public var offSet:Number;
      
      public var pwd:int = 0;
      
      public var Finish:Boolean;
      
      public var _easy:uint = 0;
      
      public function ninePicGame(emptymc:MovieClip, offset:Number = 0, wh:uint = 0, easy:uint = 0)
      {
         this.props_obj = {"onComplete":this.onFinishTween};
         super();
         this.funNum = 0;
         this.MC = emptymc.parent;
         this.doorMC = emptymc;
         this._easy = easy;
         if(wh > 0)
         {
            this.w = wh + offset;
         }
         else
         {
            this.w = this.MC["mc" + 0].height + offset;
         }
         this.offSet = offset;
         this.posarr = [[0,0],[this.w,0],[this.w * 2,0],[0,this.w],[this.w,this.w],[this.w * 2,this.w],[0,this.w * 2],[this.w,this.w * 2],[this.w * 2,this.w * 2]];
         this.init();
      }
      
      public function init() : void
      {
         var j:int = 0;
         this.Finish = false;
         for(var i:int = 0; i < 9; i++)
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
         for(j = 0; j < 9; j++)
         {
            MovieClip(this.MC["mc" + this.arr[j]]).mouseChildren = false;
            this.MC["mc" + this.arr[j]].num = this.arr[j];
            this.MC["mc" + this.arr[j]].x = this.posarr[j][0];
            this.MC["mc" + this.arr[j]].y = this.posarr[j][1];
            this.MC["mc" + this.arr[j]].addEventListener(MouseEvent.CLICK,this.moveStone);
         }
         this.doorMC.visible = false;
      }
      
      public function moveStone(e:MouseEvent) : void
      {
         var num:Number = NaN;
         var moveMC:Object = null;
         var dis:Number = NaN;
         if(!this.Finish)
         {
            num = Number(e.target.num);
            if(num == 0)
            {
               ++this.pwd;
               trace(this.pwd);
               if(this.pwd > 10 && this._easy == 0)
               {
                  this.openthedoor();
               }
            }
            else
            {
               this.pwd = 0;
            }
            moveMC = e.target;
            if(num != Number(this.doorMC.name.slice(2)))
            {
               dis = Math.abs(moveMC.x - this.doorMC.x) + Math.abs(moveMC.y - this.doorMC.y);
               if(dis > this.w - this.offSet * 2 - 3 && dis < this.w + this.offSet * 2 + 3)
               {
                  this.MCenable();
                  try
                  {
                     this.MC.soundMC.gotoAndPlay(2);
                  }
                  catch(err:Error)
                  {
                  }
                  this.changePos(moveMC,this.doorMC);
               }
            }
         }
      }
      
      private function MCenable() : void
      {
         for(var j:uint = 0; j < 9; j++)
         {
            this.MC["mc" + j].mouseEnabled = false;
         }
      }
      
      private function MCable() : void
      {
         for(var j:uint = 0; j < 9; j++)
         {
            this.MC["mc" + j].mouseEnabled = true;
         }
      }
      
      public function changePos(mc1:Object, mc2:Object) : void
      {
         TweenLite.to(mc1,0.3,{
            "x":mc2.x,
            "y":mc2.y
         });
         TweenLite.to(mc2,0.3,{
            "y":mc1.y,
            "x":mc1.x,
            "onComplete":this.onFinishTween
         });
      }
      
      public function onFinishTween() : void
      {
         this.MCable();
         for(var j:uint = 0; j < 9; j++)
         {
            this.MC["mc" + j].x = Math.round(this.MC["mc" + j].x);
            this.MC["mc" + j].y = Math.round(this.MC["mc" + j].y);
         }
         if(this.win())
         {
            this.MCenable();
            this.openDoor();
         }
      }
      
      public function openDoor() : void
      {
         this.Finish = true;
         this.doorMC.visible = true;
         this.doorMC.play();
         GV.onlineSocket.dispatchEvent(new Event("openthedoor"));
         GV.onlineSocket.dispatchEvent(new Event("pintuwancheng"));
      }
      
      public function win() : Boolean
      {
         for(var j:int = 1; j < 9; j++)
         {
            if(this.MC["mc" + j].x + Math.round(this.MC["mc" + j].y / this.w) * this.w * 3 <= this.MC["mc" + (j - 1)].x + Math.round(this.MC["mc" + (j - 1)].y / this.w) * this.w * 3)
            {
               return false;
            }
         }
         return true;
      }
      
      public function openthedoor(e:Event = null) : void
      {
         GV.onlineSocket.dispatchEvent(new Event("pintuwancheng"));
         this.MCenable();
         for(var j:uint = 0; j < 9; j++)
         {
            TweenLite.to(this.MC["mc" + j],0.3,{
               "x":this.posarr[j][0],
               "y":this.posarr[j][1]
            });
         }
         setTimeout(this.openDoor,300);
      }
      
      public function destroy() : void
      {
         for(var j:int = 0; j < 9; j++)
         {
            try
            {
               this.MC["mc" + j].removeEventListener(MouseEvent.CLICK,this.moveStone);
            }
            catch(e:*)
            {
            }
         }
      }
   }
}

