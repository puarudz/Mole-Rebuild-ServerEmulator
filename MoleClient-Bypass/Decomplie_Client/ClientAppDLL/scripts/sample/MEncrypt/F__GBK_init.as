package sample.MEncrypt
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_mbrtowc;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_mbsinit;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_wcrtomb;
   
   public function F__GBK_init() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = sample.MEncrypt.ESP;
      _loc3_ = _loc2_;
      si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_mbrtowc,sample.MEncrypt.___mbrtowc);
      si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_wcrtomb,sample.MEncrypt.___wcrtomb);
      si32(sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.__GBK_mbsinit,sample.MEncrypt.___mbsinit);
      _loc1_ = li32(_loc3_);
      si32(_loc1_,sample.MEncrypt.__CurrentRuneLocale);
      si32(2,sample.MEncrypt.___mb_cur_max);
      si32(128,sample.MEncrypt.___mb_sb_limit);
      eax = 0;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

