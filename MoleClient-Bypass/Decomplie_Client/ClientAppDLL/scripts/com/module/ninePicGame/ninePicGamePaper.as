package com.module.ninePicGame
{
   import com.common.Tween.TweenLite;
   import com.event.EventTaomee;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ninePicGamePaper extends MovieClip
   {
      
      public var arr:Array = new Array();
      
      public var posarr:Array = new Array();
      
      public var MC:* = new Array();
      
      public var doorMC:MovieClip;
      
      public var funNum:uint;
      
      public var props_obj:Object;
      
      public var w:Number;
      
      public var offSet:Number;
      
      public var pwd:uint = 0;
      
      public var bu:uint = 0;
      
      public var Type:int = 0;
      
      public function ninePicGamePaper(emptymc:MovieClip, offset:Number = 0)
      {
         this.props_obj = {"onComplete":this.onFinishTween};
         super();
         this.funNum = 0;
         this.MC = emptymc.parent;
         this.doorMC = emptymc;
         this.w = this.MC["mc" + 0].height + offset;
         this.offSet = offset;
         this.posarr = [[0,0],[this.w,0],[this.w * 2,0],[0,this.w],[this.w,this.w],[this.w * 2,this.w],[0,this.w * 2],[this.w,this.w * 2],[this.w * 2,this.w * 2]];
         this.init();
      }
      
      public function init() : void
      {
         for(var i:uint = 0; i < 9; i++)
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
         for(var j:uint = 0; j < 9; j++)
         {
            this.MC["mc" + this.arr[j]].num = this.arr[j];
            this.MC["mc" + this.arr[j]].x = this.posarr[j][0];
            this.MC["mc" + this.arr[j]].y = this.posarr[j][1];
            this.MC["mc" + this.arr[j]].addEventListener(MouseEvent.CLICK,this.moveStone);
         }
         this.doorMC.visible = false;
      }
      
      public function moveStone(e:MouseEvent) : void
      {
         var dis:Number = NaN;
         var num:int = int(e.target.num);
         ++this.bu;
         if(num == 0)
         {
            ++this.pwd;
            if(this.pwd > 10)
            {
               this.Type = 0;
               this.openthedoor();
            }
         }
         else
         {
            this.pwd = 0;
         }
         var moveMC:DisplayObject = e.target as DisplayObject;
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
         if(this.bu >= 50)
         {
            this.Type = 1;
            this.openthedoor();
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
      
      public function changePos(mc1:DisplayObject, mc2:DisplayObject) : void
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
            this.Type = 2;
            this.openDoor();
         }
      }
      
      public function openDoor() : void
      {
         this.doorMC.visible = true;
         this.doorMC.play();
         GV.onlineSocket.dispatchEvent(new EventTaomee("win_paper_ninegame",{"WinType":this.Type}));
      }
      
      public function win() : Boolean
      {
         for(var j:uint = 1; j < 9; j++)
         {
            if(this.MC["mc" + j].x + Math.round(this.MC["mc" + j].y / this.w) * this.w * 3 <= this.MC["mc" + (j - 1)].x + Math.round(this.MC["mc" + (j - 1)].y / this.w) * this.w * 3)
            {
               return false;
            }
         }
         return true;
      }
      
      public function openthedoor(e:* = null) : void
      {
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
   }
}

