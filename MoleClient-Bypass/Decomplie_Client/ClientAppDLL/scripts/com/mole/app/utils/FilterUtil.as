package com.mole.app.utils
{
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   
   public class FilterUtil
   {
      
      public function FilterUtil()
      {
         super();
      }
      
      public static function applyGray(child:DisplayObject) : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         applyFilter(child,matrix);
      }
      
      private static function applyFilter(child:DisplayObject, matrix:Array) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var filters:Array = new Array();
         filters.push(filter);
         child.filters = filters;
      }
   }
}

