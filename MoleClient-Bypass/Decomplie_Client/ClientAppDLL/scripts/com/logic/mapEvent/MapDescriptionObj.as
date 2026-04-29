package com.logic.mapEvent
{
   public class MapDescriptionObj
   {
      
      public var descrpiton:String = "";
      
      public var colorNum:uint = 0;
      
      public var color:uint = 0;
      
      public function MapDescriptionObj(Cdec:String, CcolorNum:uint = 0)
      {
         super();
         this.descrpiton = Cdec;
         this.colorNum = CcolorNum;
         if(this.colorNum == 0)
         {
            this.color = 10066329;
         }
         else if(this.colorNum == 1)
         {
            this.color = 16711680;
         }
         else if(this.colorNum == 2)
         {
            this.color = 39372;
         }
         else
         {
            this.color = 0;
         }
      }
   }
}

