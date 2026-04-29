package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.F_idalloc;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_mbrtowc;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_mbsinit;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_wcrtomb;
   
   public function F__EUC_init() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc10_:int = 0;
      var _loc4_:int = 0;
      var _loc9_:int = 0;
      var _loc7_:int = 0;
      var _loc11_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:int = 0;
      var _loc12_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 16;
      _loc1_ = li32(_loc3_);
      _loc12_ = li32(_loc1_ + 3148);
      _loc11_ = 79;
      if(_loc12_ != 0)
      {
         while(true)
         {
            _loc10_ = li8(_loc12_);
            if(_loc10_ != 9)
            {
               if(_loc10_ != 32)
               {
                  break;
               }
            }
            _loc12_ += 1;
         }
         _loc2_ -= 16;
         si32(36,_loc2_);
         ESP = _loc2_;
         F_malloc();
         _loc2_ += 16;
         _loc10_ = sample.MEncrypt.eax;
         _loc9_ = 0;
         _loc11_ = 0;
         if(_loc10_ == 0)
         {
            ESP = _loc2_;
            sample.MEncrypt.F___error();
            var _loc8_:int = sample.MEncrypt.eax;
            var _temp_6:* = li32(_loc8_);
            _loc11_ = 12;
            if(_temp_6 != 0)
            {
               ESP = _loc2_;
               sample.MEncrypt.F___error();
               _loc8_ = sample.MEncrypt.eax;
               _loc11_ = li32(_loc8_);
            }
         }
         else
         {
            while(true)
            {
               _loc2_ -= 16;
               si32(0,_loc2_ + 8);
               _loc4_ = _loc3_ - 4;
               si32(_loc4_,_loc2_ + 4);
               si32(_loc12_,_loc2_);
               ESP = _loc2_;
               F_strtol();
               _loc2_ += 16;
               _loc6_ = sample.MEncrypt.eax;
               if(_loc9_ >= 4)
               {
                  si32(_loc6_,_loc10_ + 32);
                  _loc9_ = li32(_loc3_ - 4);
                  while(true)
                  {
                     if(_loc12_ != _loc9_)
                     {
                        if(_loc9_ != 0)
                        {
                           si32(_loc10_,_loc1_ + 3148);
                           si32(36,_loc1_ + 3152);
                           si32(_loc1_,sample.MEncrypt.__CurrentRuneLocale);
                           si32(_loc11_,sample.MEncrypt.___mb_cur_max);
                           si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_mbrtowc,sample.MEncrypt.___mbrtowc);
                           si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_wcrtomb,sample.MEncrypt.___wcrtomb);
                           si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__EUC_mbsinit,sample.MEncrypt.___mbsinit);
                           si32(256,sample.MEncrypt.___mb_sb_limit);
                           _loc11_ = 0;
                           break;
                        }
                     }
                     _loc2_ -= 16;
                     si32(_loc10_,_loc2_);
                     ESP = _loc2_;
                     F_idalloc();
                     _loc2_ += 16;
                     _loc11_ = 79;
                     break;
                  }
               }
               else
               {
                  var _temp_12:* = _loc9_ << 2;
                  _loc7_ = _loc10_ + _temp_12;
                  si32(_loc6_,_loc7_);
                  _loc5_ = li32(_loc3_ - 4);
                  if(_loc12_ == _loc5_)
                  {
                     break;
                  }
                  if(_loc5_ == 0)
                  {
                     break;
                  }
                  while(true)
                  {
                     _loc12_ = li8(_loc5_);
                     if(_loc12_ != 9)
                     {
                        if(_loc12_ != 32)
                        {
                           break;
                        }
                     }
                     _loc5_ += 1;
                  }
                  _loc2_ -= 16;
                  si32(0,_loc2_ + 8);
                  si32(_loc4_,_loc2_ + 4);
                  si32(_loc5_,_loc2_);
                  ESP = _loc2_;
                  F_strtol();
                  _loc2_ += 16;
                  _loc8_ = sample.MEncrypt.eax;
                  si32(_loc8_,_loc7_ + 16);
                  if(_loc6_ <= _loc11_)
                  {
                     _loc6_ = _loc11_;
                  }
                  _loc12_ = li32(_loc3_ - 4);
                  if(_loc12_ != _loc5_)
                  {
                     if(_loc12_ != 0)
                     {
                        while(true)
                        {
                           _loc11_ = li8(_loc12_);
                           if(_loc11_ != 9)
                           {
                              if(_loc11_ != 32)
                              {
                                 break;
                              }
                           }
                           _loc12_ += 1;
                        }
                        continue;
                     }
                  }
                  _loc11_ = 79;
                  if(_loc10_ != 0)
                  {
                     _loc2_ -= 16;
                     si32(_loc10_,_loc2_);
                     ESP = _loc2_;
                     F_idalloc();
                     _loc2_ += 16;
                     _loc11_ = 79;
                  }
               }
               _loc9_ += 1;
               _loc11_ = _loc6_;
            }
            _loc11_ = 79;
            if(_loc10_ != 0)
            {
               _loc2_ -= 16;
               si32(_loc10_,_loc2_);
               ESP = _loc2_;
               F_idalloc();
               _loc2_ += 16;
               _loc11_ = 79;
            }
         }
      }
      eax = _loc11_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

