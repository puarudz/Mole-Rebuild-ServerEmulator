package com.module.farm
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class FishJump
   {
      
      public static var instance:FishJump;
      
      private var FishArr:Array;
      
      public var InterID:uint;
      
      public var FishMC:MovieClip;
      
      public var FishPoint:Point;
      
      public function FishJump()
      {
         super();
      }
      
      public static function getInstance() : FishJump
      {
         if(instance == null)
         {
            instance = new FishJump();
         }
         return instance;
      }
      
      public function init(arr:Array, fishmc:MovieClip, p:Point) : void
      {
         this.FishPoint = p;
         this.FishMC = fishmc;
         this.FishArr = arr;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         this.InterID = setInterval(this.dupfish,10000);
      }
      
      public function dupfish() : void
      {
         var fishID:Object = null;
         var tempLoader:Loader = null;
         if(Math.random() > 0)
         {
            this.FishArr = FieldView.getInstance().FishArr;
            if(this.FishArr.length > 0)
            {
               fishID = this.FishArr[int(Math.random() * this.FishArr.length)].ID;
               tempLoader = new Loader();
               tempLoader.load(VL.getURLRequest("resource/farm/fish/" + fishID + ".swf"));
               tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
            }
         }
      }
      
      public function FishToPool(id:Object) : void
      {
         var tempLoader:Loader = new Loader();
         tempLoader.load(VL.getURLRequest("resource/farm/fish/" + id + ".swf"));
         tempLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeFishToPool);
      }
      
      public function completeFishToPool(e:Event) : void
      {
         var goodsMC:* = e.target.content;
         goodsMC.mc.gotoAndStop(1);
         BC.addEvent(this,goodsMC.mc,"fish_jump_finish",this.finishJump);
         goodsMC.x = this.FishPoint.x + Math.random() + 150;
         goodsMC.y = this.FishPoint.y + Math.random() + 60;
         goodsMC.scaleX = Math.random() > 0.5 ? 1 : -1;
         this.FishMC.addChild(goodsMC);
      }
      
      public function completeHandler(e:Event) : void
      {
         var goodsMC:* = e.target.content;
         goodsMC.mc.gotoAndStop(int(Math.random() * 3) + 1);
         BC.addEvent(this,goodsMC.mc,"fish_jump_finish",this.finishJump);
         goodsMC.x = this.FishPoint.x + Math.random() + 150;
         goodsMC.y = this.FishPoint.y + Math.random() + 60;
         goodsMC.scaleX = Math.random() > 0.5 ? 1 : -1;
         this.FishMC.addChild(goodsMC);
      }
      
      public function finishJump(e:Event) : void
      {
         var mc:Object = e.currentTarget;
         BC.removeEvent(this,mc,"fish_jump_finish",this.finishJump);
         mc.parent.removeChild(mc);
      }
      
      public function removeEventHandler(e:Event) : void
      {
         clearInterval(this.InterID);
         BC.removeEvent(this);
      }
   }
}

