package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.F_idalloc;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._freelist;
   
   public function F___Bfree_D2A() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc6_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      _loc1_ = li32(_loc3_);
      if(_loc1_ != 0)
      {
         _loc6_ = li32(_loc1_ + 4);
         if(_loc6_ >= 10)
         {
            _loc2_ -= 16;
            si32(_loc1_,_loc2_);
            ESP = _loc2_;
            F_idalloc();
            _loc2_ += 16;
         }
         else
         {
            var _loc5_:int = li32(sample.MEncrypt.___isthreaded);
            if(_loc5_ != 0)
            {
               _loc2_ -= 16;
               si32(sample.MEncrypt.___gdtoa_locks,_loc2_);
               ESP = _loc2_;
               sample.MEncrypt.F__pthread_mutex_lock();
               _loc2_ += 16;
               _loc6_ = li32(_loc1_ + 4);
            }
            _loc5_ = _loc6_ << 2;
            _loc5_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._freelist + _loc5_;
            var _loc4_:int = li32(_loc5_);
            si32(_loc4_,_loc1_);
            si32(_loc1_,_loc5_);
            _loc5_ = li32(sample.MEncrypt.___isthreaded);
            if(_loc5_ != 0)
            {
               _loc2_ -= 16;
               si32(sample.MEncrypt.___gdtoa_locks,_loc2_);
               ESP = _loc2_;
               sample.MEncrypt.F__pthread_mutex_unlock();
               _loc2_ += 16;
            }
         }
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

