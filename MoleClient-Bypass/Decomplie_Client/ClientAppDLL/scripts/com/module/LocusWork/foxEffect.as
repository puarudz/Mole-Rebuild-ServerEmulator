package com.module.LocusWork
{
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   
   public class foxEffect
   {
      
      public function foxEffect()
      {
         super();
      }
      
      public static function disable(tDio:InteractiveObject, tBo:Boolean = false, moveFlag:Boolean = false) : void
      {
         if(tDio == null)
         {
            return;
         }
         if(!tBo)
         {
            tDio.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
            tDio.mouseEnabled = false;
         }
         else
         {
            tDio.filters = [];
            tDio.mouseEnabled = true;
         }
         if(tDio is MovieClip)
         {
            if(moveFlag)
            {
               if(!tBo)
               {
                  MCContorl.stopAllMC(tDio);
               }
               else
               {
                  MCContorl.playAllMC(tDio);
               }
            }
         }
      }
   }
}

