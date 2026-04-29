package com.view.userPanelView
{
   import com.common.tip.tip;
   import com.global.staticData.XMLInfo;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class MyHonor
   {
      
      public var MC:MovieClip;
      
      public var Arr:Array;
      
      private var checkTimer:Timer;
      
      private var currentID:int;
      
      private var space:int = 28;
      
      private var userID:uint;
      
      private var mcArr:Array;
      
      public function MyHonor(mc:MovieClip, id:uint, _mcArr:Array)
      {
         super();
         this.MC = mc;
         this.userID = id;
         this.mcArr = _mcArr;
         this.MC.parent["up2_btn"].visible = false;
         this.MC.parent["down2_btn"].visible = false;
         this.MC.x = 28;
         setTimeout(this.sortMC,100);
      }
      
      private function sortMC() : void
      {
         var mc:MovieClip = null;
         var tips:String = "";
         this.mcArr = this.mcArr.sortOn("currentFrame",16);
         this.mcArr = this.mcArr.reverse();
         for(var i:int = 0; i < this.mcArr.length; i++)
         {
            mc = this.mcArr[i] as MovieClip;
            if(this.userID == GV.MyInfo_userID)
            {
               mc.mouseChildren = true;
               tips = XMLInfo.HonorArr[mc.id][mc.currentFrame - 1] + (Boolean(mc.value) ? mc.value : "");
               if(Boolean(XMLInfo.HonorArr[mc.id][mc.currentFrame - 1]))
               {
                  tip.tipTailDisPlayObject(mc,tips);
               }
            }
            else
            {
               mc.mouseChildren = false;
               tips = XMLInfo.otherHonorArr[mc.id][mc.currentFrame - 1] + (Boolean(mc.value) ? mc.value : "");
               if(Boolean(XMLInfo.otherHonorArr[mc.id][mc.currentFrame - 1]))
               {
                  tip.tipTailDisPlayObject(mc,tips);
               }
            }
            mc.x = this.space * i;
            mc.y = 0;
            this.MC.addChild(mc);
         }
      }
      
      private function showSMC_Pan(e:MouseEvent) : void
      {
         this.currentID = int(e.currentTarget["id"]) + 1;
      }
      
      private function checkhaspan() : void
      {
      }
      
      private function removeEventHandler(E:*) : void
      {
         GC.clearGInterval(this.checkTimer);
         this.Arr = [];
         this.mcArr = [];
      }
   }
}

