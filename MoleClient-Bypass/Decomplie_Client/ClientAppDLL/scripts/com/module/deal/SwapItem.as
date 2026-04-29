package com.module.deal
{
   public class SwapItem
   {
      
      public var kind:uint;
      
      public var num:uint;
      
      public function SwapItem(ItemID:uint, Count:uint)
      {
         super();
         this.kind = ItemID;
         this.num = Count;
      }
   }
}

