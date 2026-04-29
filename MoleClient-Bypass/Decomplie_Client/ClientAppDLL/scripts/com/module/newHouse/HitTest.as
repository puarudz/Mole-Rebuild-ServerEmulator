package com.module.newHouse
{
   import com.event.EventTaomee;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class HitTest extends EventDispatcher
   {
      
      public static var leftBMD:BitmapData;
      
      public static var midBMD:BitmapData;
      
      public static var rightBMD:BitmapData;
      
      public static var floorBMD:BitmapData;
      
      public static var sideBMD:BitmapData;
      
      public static var moveGoodsBMD:BitmapData;
      
      public static var p:Point;
      
      public static var secondp:Point;
      
      public static var mc:*;
      
      public static var actionGoods:*;
      
      public static var movingMC:MovieClip;
      
      public static var RootMC:MovieClip;
      
      public static var child:MovieClip;
      
      public static var backOldPos:Boolean = false;
      
      public static var backDepot:Boolean = false;
      
      public static var face:int = -1;
      
      public static var bmdwidth:int = 960;
      
      public static var bmdheight:int = 560;
      
      public static var SpecialArr:Array = [161102,160142,160185,160202,160203,160206,160208,160229,160283,160525,160617,160618,160619,160602,160695,160725,160773];
      
      public function HitTest()
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
         mc = RootMC.TestMC.getChildAt(0);
         try
         {
            leftBMD.dispose();
            midBMD.dispose();
            rightBMD.dispose();
            floorBMD.dispose();
            sideBMD.dispose();
         }
         catch(e:Error)
         {
         }
         var houseBGID:int = int(newEditHouseView.owner.BG.ID);
         if(newEditHouseView.owner.twofloorhouse.indexOf(houseBGID) != -1)
         {
            bmdheight = 1120;
         }
         leftBMD = new BitmapData(bmdwidth,bmdheight,true,0);
         leftBMD.draw(mc.left_mc);
         midBMD = new BitmapData(bmdwidth,bmdheight,true,0);
         midBMD.draw(mc.mid_mc);
         rightBMD = new BitmapData(bmdwidth,bmdheight,true,0);
         rightBMD.draw(mc.right_mc);
         floorBMD = new BitmapData(bmdwidth,bmdheight,true,0);
         floorBMD.draw(mc.floor_mc);
         sideBMD = new BitmapData(bmdwidth,bmdheight,true,0);
         sideBMD.draw(mc.side_mc);
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
      
      public static function hitTesting(actiongoods:*, movingmc:MovieClip) : void
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
         if(movingMC.Layer == 4)
         {
            TestingWallGoods();
         }
         else
         {
            TestingFloorGoods();
         }
      }
      
      public static function TestingWallGoods() : void
      {
         var floorSecondp:Point = mc.floor_mc.localToGlobal(new Point(0,0));
         var sideSecondp:Point = mc.side_mc.localToGlobal(new Point(0,0));
         var midSecondp:Point = mc.mid_mc.localToGlobal(new Point(0,0));
         var leftSecondp:Point = mc.left_mc.localToGlobal(new Point(0,0));
         var rightSecondp:Point = mc.right_mc.localToGlobal(new Point(0,0));
         if(moveGoodsBMD.hitTest(p,0,sideBMD,sideSecondp))
         {
            movingMC.alpha = 0.6;
            if(moveGoodsBMD.hitTest(p,0,leftBMD,leftSecondp) || moveGoodsBMD.hitTest(p,0,midBMD,midSecondp) || moveGoodsBMD.hitTest(p,0,rightBMD,rightSecondp))
            {
               backOldPos = true;
               backDepot = false;
               depotXY();
            }
            else
            {
               RootMC.depot_mc.x = movingMC.x + 30;
               RootMC.depot_mc.y = movingMC.y + 30;
               backDepot = true;
               backOldPos = false;
            }
         }
         else
         {
            backDepot = false;
            depotXY();
            if(moveGoodsBMD.hitTest(p,0,floorBMD,floorSecondp))
            {
               backOldPos = true;
               movingMC.alpha = 0.6;
            }
            else
            {
               backOldPos = false;
               movingMC.alpha = 1;
               if(moveGoodsBMD.hitTest(p,0,midBMD,midSecondp))
               {
                  if(face != 1)
                  {
                     face = 1;
                     gotostop(face);
                     RootMC.dispatchEvent(new EventTaomee("changeDirection",actionGoods.mc1.currentFrame));
                  }
               }
               else if(moveGoodsBMD.hitTest(p,0,leftBMD,leftSecondp))
               {
                  if(face != 2)
                  {
                     face = 2;
                     gotostop(face);
                     RootMC.dispatchEvent(new EventTaomee("changeDirection",actionGoods.mc1.currentFrame));
                  }
               }
               else if(moveGoodsBMD.hitTest(p,0,rightBMD,rightSecondp))
               {
                  if(face != 3)
                  {
                     face = 3;
                     gotostop(face);
                     RootMC.dispatchEvent(new EventTaomee("changeDirection",actionGoods.mc1.currentFrame));
                  }
               }
               else
               {
                  backOldPos = true;
                  movingMC.alpha = 0.6;
               }
            }
         }
      }
      
      public static function TestingFloorGoods() : void
      {
         var floorSecondp:Point = mc.floor_mc.localToGlobal(new Point(0,0));
         var sideSecondp:Point = mc.side_mc.localToGlobal(new Point(0,0));
         var midSecondp:Point = mc.mid_mc.localToGlobal(new Point(0,0));
         var leftSecondp:Point = mc.left_mc.localToGlobal(new Point(0,0));
         var rightSecondp:Point = mc.right_mc.localToGlobal(new Point(0,0));
         if(moveGoodsBMD.hitTest(p,0,sideBMD,sideSecondp))
         {
            backOldPos = false;
            movingMC.alpha = 0.6;
            RootMC.depot_mc.x = movingMC.x + 30;
            RootMC.depot_mc.y = movingMC.y + 30;
            backDepot = true;
         }
         else
         {
            backDepot = false;
            depotXY();
            if(moveGoodsBMD.hitTest(p,0,floorBMD,floorSecondp))
            {
               backOldPos = false;
               if(moveGoodsBMD.hitTest(p,0,midBMD,midSecondp) || moveGoodsBMD.hitTest(p,0,leftBMD,leftSecondp) || moveGoodsBMD.hitTest(p,0,rightBMD,rightSecondp))
               {
                  backOldPos = true;
                  movingMC.alpha = 0.6;
               }
               else
               {
                  movingMC.alpha = 1;
               }
            }
            else
            {
               backOldPos = true;
               movingMC.alpha = 0.6;
            }
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
         if(movingMC.Layer == 1 || movingMC.Layer == 2)
         {
            GC.stopAllMC(actionGoods.mc2);
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
      
      public static function isSpecial(id:Object) : Boolean
      {
         return SpecialArr.indexOf(uint(id)) >= 0;
      }
      
      public static function gotostop(i:Object) : void
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

