package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._freelist;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._pmem_next;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._private_mem;
   
   public function F___Balloc_D2A() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc9_:int = 0;
      var _loc4_:int = 0;
      var _loc1_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc6_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      _loc1_ = li32(sample.MEncrypt.___isthreaded);
      if(_loc1_ != 0)
      {
         _loc2_ -= 16;
         si32(sample.MEncrypt.___gdtoa_locks,_loc2_);
         ESP = _loc2_;
         sample.MEncrypt.F__pthread_mutex_lock();
         _loc2_ += 16;
      }
      while(true)
      {
         _loc9_ = li32(_loc3_);
         if(_loc9_ >= 10)
         {
            _loc8_ = 1 << _loc9_;
            _loc7_ = (_loc8_ << 2) + 27;
         }
         else
         {
            var _temp_5:* = _loc9_ << 2;
            _loc7_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._freelist + _temp_5;
            _loc6_ = li32(_loc7_);
            if(_loc6_ != 0)
            {
               si32(li32(_loc6_),_loc7_);
               §§goto(addr011d);
            }
            _loc6_ = li32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._pmem_next);
            var _loc5_:int;
            if(uint(int((int(_loc6_ - sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._private_mem) >> 3) + (_loc4_ = (_loc7_ = (_loc5_ = (_loc8_ = 1 << _loc9_) << 2) + 27) >>> 3))) <= 288)
            {
               var _temp_16:* = _loc4_ << 3;
               si32(int(_loc6_ + _temp_16),sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f._pmem_next);
               break;
            }
         }
         _loc2_ -= 16;
         _loc1_ = _loc7_ & -8;
         si32(_loc1_,_loc2_);
         ESP = _loc2_;
         F_malloc();
         _loc2_ += 16;
         _loc6_ = sample.MEncrypt.eax;
         break;
      }
      si32(_loc9_,_loc6_ + 4);
      si32(_loc8_,_loc6_ + 8);
      addr011d:
      _loc1_ = li32(sample.MEncrypt.___isthreaded);
      if(_loc1_ != 0)
      {
         _loc2_ -= 16;
         si32(sample.MEncrypt.___gdtoa_locks,_loc2_);
         ESP = _loc2_;
         sample.MEncrypt.F__pthread_mutex_unlock();
         _loc2_ += 16;
      }
      si32(0,_loc6_ + 16);
      si32(0,_loc6_ + 12);
      eax = _loc6_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

