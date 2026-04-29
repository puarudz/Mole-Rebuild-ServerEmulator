package com.mole.app.info
{
   public class ClothInfo
   {
      
      public var clothStaticInfo:Object;
      
      public var itemCnt:uint;
      
      public function ClothInfo(staticInfo:Object, itemCnt:uint)
      {
         super();
         this.clothStaticInfo = staticInfo;
         this.itemCnt = itemCnt;
      }
   }
}

