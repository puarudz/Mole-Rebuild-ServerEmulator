package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   
   public function F_AS3_SendMetricString() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc4_:String = null;
      var _loc12_:int = 0;
      var _loc8_:int = 0;
      var _loc6_:int = 0;
      var _loc10_:int = 0;
      var _loc11_:int = 0;
      var _loc1_:int = 0;
      var _loc9_:int = 0;
      var _loc7_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      _loc1_ = li32(_loc3_);
      _loc12_ = _loc1_ & -4;
      _loc11_ = li32(_loc12_);
      _loc10_ = _loc11_ + -16843009;
      _loc11_ &= -2139062144;
      _loc11_ = _loc11_ ^ -2139062144;
      _loc10_ = _loc11_ & _loc10_;
      _loc9_ = li32(_loc3_ + 4);
      if(_loc10_ != 0)
      {
         _loc8_ = _loc12_ + 4;
         _loc7_ = 0;
         while(true)
         {
            _loc6_ = _loc1_ + _loc7_;
            if((uint(_loc6_)) < uint(_loc8_))
            {
               _loc10_ = li8(_loc6_);
               if(_loc10_ == 0)
               {
                  break;
               }
               _loc7_ += 1;
               continue;
            }
         }
         §§goto(addr0160);
      }
      _loc12_ += 4;
      while(true)
      {
         _loc7_ = li32(_loc12_);
         _loc10_ = _loc7_ + -16843009;
         _loc11_ = _loc7_ & -2139062144;
         _loc11_ = _loc11_ ^ -2139062144;
         _loc10_ = _loc11_ & _loc10_;
         if(_loc10_ != 0)
         {
            _loc10_ = _loc7_ & 0xFF;
            if(_loc10_ == 0)
            {
               _loc7_ = _loc12_ - _loc1_;
               break;
            }
            _loc10_ = li8(_loc12_ + 1);
            if(_loc10_ == 0)
            {
               _loc10_ = 1 - _loc1_;
               _loc7_ = _loc10_ + _loc12_;
               break;
            }
            _loc10_ = li8(_loc12_ + 2);
            if(_loc10_ == 0)
            {
               _loc10_ = 2 - _loc1_;
               _loc7_ = _loc10_ + _loc12_;
               break;
            }
            _loc10_ = li8(_loc12_ + 3);
            if(_loc10_ == 0)
            {
               _loc10_ = 3 - _loc1_;
               _loc7_ = _loc10_ + _loc12_;
               break;
            }
         }
         _loc12_ += 4;
      }
      addr0160:
      _loc4_ = CModule.readString(_loc1_,_loc7_);
      _loc8_ = _loc9_ & -4;
      _loc11_ = li32(_loc8_);
      _loc10_ = _loc11_ + -16843009;
      _loc11_ &= -2139062144;
      _loc11_ = _loc11_ ^ -2139062144;
      _loc10_ = _loc11_ & _loc10_;
      if(_loc10_ != 0)
      {
         _loc12_ = _loc8_ + 4;
         _loc7_ = 0;
         while(true)
         {
            _loc1_ = _loc9_ + _loc7_;
            if(uint(_loc1_) < uint(_loc12_))
            {
               _loc10_ = li8(_loc1_);
               if(_loc10_ == 0)
               {
                  break;
               }
               _loc7_ += 1;
               continue;
            }
         }
         §§goto(addr028c);
      }
      _loc1_ = _loc8_ + 4;
      while(true)
      {
         _loc7_ = li32(_loc1_);
         _loc10_ = _loc7_ + -16843009;
         _loc11_ = _loc7_ & -2139062144;
         _loc11_ = _loc11_ ^ -2139062144;
         _loc10_ = _loc11_ & _loc10_;
         if(_loc10_ != 0)
         {
            _loc10_ = _loc7_ & 0xFF;
            if(_loc10_ == 0)
            {
               _loc7_ = _loc1_ - _loc9_;
               break;
            }
            _loc10_ = li8(_loc1_ + 1);
            if(_loc10_ == 0)
            {
               _loc10_ = 1 - _loc9_;
               _loc7_ = _loc10_ + _loc1_;
               break;
            }
            _loc10_ = li8(_loc1_ + 2);
            if(_loc10_ == 0)
            {
               _loc10_ = 2 - _loc9_;
               _loc7_ = _loc10_ + _loc1_;
               break;
            }
            _loc10_ = li8(_loc1_ + 3);
            if(_loc10_ == 0)
            {
               _loc10_ = 3 - _loc9_;
               _loc7_ = _loc10_ + _loc1_;
               break;
            }
         }
         _loc1_ += 4;
      }
      addr028c:
      var _loc5_:String = CModule.readString(_loc9_,_loc7_);
      CModule.sendMetric(_loc4_,_loc5_);
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

