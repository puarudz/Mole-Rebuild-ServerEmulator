package com.common.util
{
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   
   public class ShowUtil
   {
      
      public function ShowUtil()
      {
         super();
      }
      
      public static function disableShow(mc:*, buttonMode:Boolean = false, visible:Boolean = false, isMatrix:Boolean = true, mouseEnabled:Boolean = true, mouseChildren:Boolean = true) : void
      {
         var matrix:ColorMatrix = null;
         if(visible && Boolean(mc.hasOwnProperty("visible")))
         {
            mc.visible = false;
         }
         if(buttonMode && Boolean(mc.hasOwnProperty("buttonMode")))
         {
            (mc as MovieClip).buttonMode = false;
         }
         if(isMatrix && Boolean(mc.hasOwnProperty("filters")))
         {
            matrix = new ColorMatrix();
            matrix.adjustSaturation(-255);
            mc.filters = [new ColorMatrixFilter(matrix)];
         }
         if(mouseEnabled && Boolean(mc.hasOwnProperty("mouseEnabled")))
         {
            mc.mouseEnabled = false;
         }
         if(mouseChildren && Boolean(mc.hasOwnProperty("mouseChildren")))
         {
            mc.mouseChildren = false;
         }
      }
      
      public static function ableShow(mc:*, buttonMode:Boolean = false, visible:Boolean = false, isMatrix:Boolean = true, mouseEnabled:Boolean = true, mouseChildren:Boolean = true) : void
      {
         if(visible && Boolean(mc.hasOwnProperty("visible")))
         {
            mc.visible = true;
         }
         if(buttonMode && Boolean(mc.hasOwnProperty("buttonMode")))
         {
            (mc as MovieClip).buttonMode = true;
         }
         if(isMatrix && Boolean(mc.hasOwnProperty("filters")))
         {
            mc.filters = [];
         }
         if(mouseEnabled && Boolean(mc.hasOwnProperty("mouseEnabled")))
         {
            mc.mouseEnabled = true;
         }
         if(mouseChildren && Boolean(mc.hasOwnProperty("mouseChildren")))
         {
            mc.mouseChildren = true;
         }
      }
   }
}

