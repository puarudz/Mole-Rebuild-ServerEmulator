package com.taomee.component.geom
{
   public class IntDimension
   {
      
      private var __width:int = 0;
      
      private var __height:int = 0;
      
      public function IntDimension(w:int = 0, h:int = 0)
      {
         super();
         this.__width = w;
         this.__height = h;
      }
      
      public function setSize(dim:IntDimension) : void
      {
         this.__width = dim.width;
         this.__height = dim.height;
      }
      
      public function setSizeWH(w:int, h:int) : void
      {
         this.__width = w;
         this.__height = h;
      }
      
      public function get width() : int
      {
         return this.__width;
      }
      
      public function get height() : int
      {
         return this.__height;
      }
      
      public function set width(i:int) : void
      {
         this.__width = i;
      }
      
      public function set height(i:int) : void
      {
         this.__height = i;
      }
   }
}

