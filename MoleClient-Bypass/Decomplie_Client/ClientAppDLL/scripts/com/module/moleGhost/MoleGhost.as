package com.module.moleGhost
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.module.cutMapModule.SaveCutMap;
   import fl.transitions.Tween;
   import fl.transitions.easing.Strong;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MoleGhost
   {
      
      public static var targetMC_Array:Array;
      
      private var targetX:int = 0;
      
      private var targetY:int = 0;
      
      private var ghostMoveX:Timer;
      
      private var ghostMoveY:Timer;
      
      private var ghostTweenX:Tween;
      
      private var ghostTweenY:Tween;
      
      public var targetMC:MovieClip;
      
      public function MoleGhost()
      {
         super();
         this.targetMC = new (Class(GV.Lib_Map.getClass("ghost_mc")))();
         this.ghostMoveX = new Timer(4000);
         this.ghostMoveY = new Timer(7000);
         BC.addEvent(this,this.ghostMoveX,TimerEvent.TIMER,this.setPosX);
         BC.addEvent(this,this.ghostMoveY,TimerEvent.TIMER,this.setPosY);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
         this.ghostMoveX.start();
         this.ghostMoveY.start();
         this.targetMC.x = Math.random() * 960;
         this.targetMC.y = Math.random() * 560;
         var scale:Number = (Math.random() * 8 - 4) / 100;
         this.targetMC.scaleX += scale;
         this.targetMC.scaleY += scale;
         this.setPosX();
         this.setPosY();
         BC.addEvent(this,this.targetMC,MouseEvent.CLICK,this.tryCameraHandler);
         if(targetMC_Array == null)
         {
            targetMC_Array = new Array();
         }
         targetMC_Array.push(this.targetMC);
      }
      
      public static function getGhost(contentMC:MovieClip, count:int) : void
      {
         var tempMoleGhost:MoleGhost = null;
         for(var i:int = 0; i < count; i++)
         {
            tempMoleGhost = new MoleGhost();
            contentMC.addChild(tempMoleGhost.getTargetMC());
         }
      }
      
      public function getTargetMC() : MovieClip
      {
         return this.targetMC;
      }
      
      public function setPosX(E:TimerEvent = null) : void
      {
         try
         {
            this.ghostTweenX.stop();
         }
         catch(E:*)
         {
         }
         this.targetX = Math.random() * 960;
         var duration:int = Math.random() * 5 + 5;
         if(this.targetX < this.targetMC.x)
         {
            if(this.targetMC.scaleX < 0)
            {
               this.targetMC.scaleX *= -1;
            }
         }
         else if(this.targetMC.scaleX >= 0)
         {
            this.targetMC.scaleX *= -1;
         }
         this.ghostTweenX = new Tween(this.targetMC,"x",Strong.easeOut,this.targetMC.x,this.targetX,duration,true);
         this.ghostMoveX.delay = (int(Math.random() * 7) + 4) * 1000;
      }
      
      public function setPosY(E:TimerEvent = null) : void
      {
         try
         {
            this.ghostTweenY.stop();
         }
         catch(E:*)
         {
         }
         var duration:int = Math.random() * 5 + 10;
         this.targetY = Math.random() * 560;
         this.ghostTweenY = new Tween(this.targetMC,"y",Strong.easeOut,this.targetMC.y,this.targetY,duration,true);
         this.ghostMoveX.delay = (int(Math.random() * 7) + 5) * 1000;
      }
      
      private function tryCameraHandler(E:MouseEvent) : void
      {
         var tempNum:int = 0;
         if(!SaveCutMap.isUseCamera && Boolean(GV.MAN_PEOPLE))
         {
            tempNum = int(GV.JobLogics.chartUnusualCloth(GV.MAN_PEOPLE.clothsArray));
            if(!SaveCutMap.isUseCamera && GoodsInfo.ClothObject[tempNum] == "记者")
            {
               SaveCutMap.G_addEventListener(SaveCutMap.GET_CAMERA_CLASS,this.getCameraClass);
               SaveCutMap.GetCamera();
            }
         }
      }
      
      private function getCameraClass(E:EventTaomee) : void
      {
         SaveCutMap.G_removeEventListener(SaveCutMap.GET_CAMERA_CLASS,this.getCameraClass);
         var tempClass:* = E.EventObj;
         tempClass.lockTargetMC(this.targetMC);
      }
      
      public function clearClass(E:* = null) : void
      {
         var mc:MovieClip = null;
         BC.removeEvent(this);
         for each(mc in targetMC_Array)
         {
            GC.clearAll(mc);
         }
         this.ghostMoveX.stop();
         this.ghostMoveY.stop();
         this.ghostMoveX = null;
         this.ghostMoveY = null;
         this.targetMC = null;
         targetMC_Array = null;
      }
   }
}

