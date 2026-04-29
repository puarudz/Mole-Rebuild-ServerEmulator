package com.module.home
{
   import com.event.EventTaomee;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class HomeHitTest extends EventDispatcher
   {
      
      public static var houseBMD:BitmapData;
      
      public static var itemBMD:BitmapData;
      
      public static var moveGoodsBMD:BitmapData;
      
      public static var p:Point;
      
      public static var actionGoods:Object;
      
      public static var movingMC:MovieClip;
      
      public static var RootMC:MovieClip;
      
      public static var child:*;
      
      public static var backOldPos:Boolean = false;
      
      public static var backDepot:Boolean = false;
      
      public static var face:int = -1;
      
      public static var SpecialArr:Array = [160142,160185,160202,160203,160206,160208,1220115,1220116,161102];
      
      public function HomeHitTest()
      {
         super();
      }
      
      public static function getBMD(rootmc:MovieClip) : void
      {
         RootMC = rootmc;
         dogetbmd();
      }
      
      private static function dogetbmd() : void
      {
         var mc:MovieClip = RootMC.hittest_mc;
         if(Boolean(houseBMD))
         {
            houseBMD.dispose();
            itemBMD.dispose();
         }
         itemBMD = new BitmapData(960,560,true,0);
         itemBMD.draw(mc.getChildAt(0));
         houseBMD = new BitmapData(960,560,true,0);
         houseBMD.draw(mc.getChildAt(1));
      }
      
      public static function stopMoveHouseBG() : void
      {
         backOldPos = false;
         RootMC.removeEventListener(Event.ENTER_FRAME,movingHouseBG);
         RootMC.stage.removeEventListener(KeyboardEvent.KEY_UP,houseBGUpHandler);
      }
      
      public static function stopHitTesting() : void
      {
         backOldPos = false;
         backDepot = false;
         RootMC.removeEventListener(Event.ENTER_FRAME,movingTest);
         try
         {
            RootMC.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function moveHouseBG(actiongoods:Object, movingmc:MovieClip) : void
      {
         actionGoods = actiongoods;
         movingMC = movingmc;
         RootMC.addEventListener(Event.ENTER_FRAME,movingHouseBG);
         RootMC.stage.addEventListener(KeyboardEvent.KEY_UP,houseBGUpHandler);
      }
      
      public static function movingHouseBG(e:Event) : void
      {
         if(actionGoods.y > 170 && actionGoods.y < 200 && actionGoods.x > 100 && actionGoods.x < 760)
         {
            trace("可放");
            actionGoods.alpha = 1;
            backOldPos = false;
            RootMC.tip_mc.visible = false;
         }
         else
         {
            trace("不可放");
            RootMC.tip_mc.x = RootMC.mouseX + 100;
            RootMC.tip_mc.y = RootMC.mouseY + 100;
            RootMC.tip_mc.visible = true;
            actionGoods.alpha = 0.6;
            backOldPos = true;
         }
      }
      
      public static function houseBGUpHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.LEFT)
         {
            if(actionGoods.mc1.currentFrame != actionGoods.mc1.totalFrames)
            {
               gotonext();
            }
            else
            {
               gotostop(1);
            }
         }
         else if(event.keyCode == Keyboard.RIGHT)
         {
            if(actionGoods.mc1.currentFrame != 1)
            {
               gotoprev();
            }
            else
            {
               gotostop(actionGoods.mc1.totalFrames);
            }
         }
      }
      
      public static function hitTesting(actiongoods:Object, movingmc:MovieClip) : void
      {
         actionGoods = actiongoods;
         movingMC = movingmc;
         moveGoodsBMD = new BitmapData(actionGoods.mc1.width,actionGoods.mc1.height,true,0);
         moveGoodsBMD.draw(actionGoods.mc1);
         RootMC.addEventListener(Event.ENTER_FRAME,movingTest);
         RootMC.stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
      }
      
      public static function movingTest(e:Event) : void
      {
         var mox:Number = movingMC.x;
         var moy:Number = movingMC.y;
         var acy:Number = Number(actionGoods.y);
         var acmcy:Number = Number(actionGoods.mc1.y);
         var tmp:Point = new Point(movingMC.x - actionGoods.mc1.width / 2,movingMC.y + actionGoods.y + actionGoods.mc1.y);
         p = RootMC.localToGlobal(tmp);
         TestingFloorGoods();
      }
      
      public static function TestingFloorGoods() : void
      {
         if(moveGoodsBMD.hitTest(p,0,itemBMD,new Point(0,0)))
         {
            backDepot = false;
            backOldPos = false;
            depotXY();
            movingMC.alpha = 1;
         }
         else
         {
            backOldPos = true;
            movingMC.alpha = 0.6;
            RootMC.depot_mc.x = movingMC.x + 30;
            RootMC.depot_mc.y = movingMC.y + 30;
            backDepot = true;
         }
      }
      
      public static function depotXY() : void
      {
         if(RootMC.depot_mc.y < 900)
         {
            RootMC.depot_mc.x = 1000;
            RootMC.depot_mc.y = 1000;
         }
      }
      
      public static function keyUpHandler(event:KeyboardEvent) : void
      {
         if(movingMC.Layer == 4 || movingMC.Layer == 6)
         {
            if(event.keyCode == Keyboard.LEFT)
            {
               if(actionGoods.mc1.currentFrame != actionGoods.mc1.totalFrames)
               {
                  gotonext();
               }
               else
               {
                  gotostop(1);
               }
               RootMC.dispatchEvent(new EventTaomee("changeDirection",actionGoods.mc1.currentFrame));
            }
            if(event.keyCode == Keyboard.RIGHT)
            {
               if(actionGoods.mc1.currentFrame != 1)
               {
                  gotoprev();
               }
               else
               {
                  gotostop(actionGoods.mc1.totalFrames);
               }
               RootMC.dispatchEvent(new EventTaomee("changeDirection",actionGoods.mc1.currentFrame));
            }
         }
         if(event.keyCode == Keyboard.UP)
         {
            child = actionGoods.mc2.getChildAt(0);
            if(child is MovieClip)
            {
               if(!isSpecial(actionGoods.ID))
               {
                  if(child.currentFrame != child.totalFrames)
                  {
                     child.nextFrame();
                  }
                  else
                  {
                     child.gotoAndStop(1);
                  }
               }
               RootMC.dispatchEvent(new EventTaomee("changeVisible",child.currentFrame));
            }
         }
         if(event.keyCode == Keyboard.DOWN)
         {
            child = actionGoods.mc2.getChildAt(0);
            if(child is MovieClip)
            {
               if(!isSpecial(actionGoods.ID))
               {
                  if(child.currentFrame != 1)
                  {
                     child.prevFrame();
                  }
                  else
                  {
                     child.gotoAndStop(child.totalFrames);
                  }
               }
               RootMC.dispatchEvent(new EventTaomee("changeVisible",child.currentFrame));
            }
         }
      }
      
      public static function isSpecial(id:uint) : Boolean
      {
         return SpecialArr.indexOf(id) >= 0;
      }
      
      public static function gotostop(i:uint) : void
      {
         actionGoods.mc1.gotoAndStop(i);
         actionGoods.mc2.gotoAndStop(i);
      }
      
      public static function gotoprev() : void
      {
         actionGoods.mc1.prevFrame();
         actionGoods.mc2.prevFrame();
      }
      
      public static function gotonext() : void
      {
         actionGoods.mc1.nextFrame();
         actionGoods.mc2.nextFrame();
      }
   }
}

