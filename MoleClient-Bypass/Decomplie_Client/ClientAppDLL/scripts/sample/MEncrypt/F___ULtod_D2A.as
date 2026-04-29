package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public function F___ULtod_D2A() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc1_:int = 0;
      var _loc9_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      _loc1_ = li32(_loc3_ + 12);
      _loc9_ = _loc1_ & 7;
      _loc8_ = li32(_loc3_ + 8);
      _loc7_ = li32(_loc3_ + 4);
      _loc6_ = li32(_loc3_);
      while(true)
      {
         if(_loc9_ <= 2)
         {
            if(_loc9_ == 0)
            {
               addr0097:
               si32(0,_loc6_ + 4);
               si32(0,_loc6_);
               break;
            }
            if(_loc9_ != 1)
            {
               if(_loc9_ != 2)
               {
                  break;
               }
               var _loc5_:int = li32(_loc7_);
               si32(_loc5_,_loc6_);
               _loc5_ = li32(_loc7_ + 4);
               si32(_loc5_,_loc6_ + 4);
               break;
            }
         }
         else
         {
            if(_loc9_ <= 4)
            {
               if(_loc9_ != 3)
               {
                  if(_loc9_ != 4)
                  {
                     break;
                  }
                  si32(0,_loc6_);
                  si32(2146959360,_loc6_ + 4);
                  break;
               }
               si32(2146435072,_loc6_ + 4);
               si32(0,_loc6_);
               break;
            }
            if(_loc9_ != 5)
            {
               if(_loc9_ != 6)
               {
                  break;
               }
               §§goto(addr0097);
            }
         }
         _loc5_ = li32(_loc7_);
         si32(_loc5_,_loc6_);
         _loc5_ = _loc8_ << 20;
         _loc5_ = _loc5_ + 1127219200;
         var _loc4_:int = li32(_loc7_ + 4);
         _loc4_ = _loc4_ & -1048577;
         _loc5_ = _loc4_ | _loc5_;
         si32(_loc5_,_loc6_ + 4);
         break;
      }
      _loc5_ = _loc1_ & 8;
      if(_loc5_ != 0)
      {
         _loc5_ = li32(_loc6_ + 4);
         _loc5_ = _loc5_ | -2147483648;
         si32(_loc5_,_loc6_ + 4);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

