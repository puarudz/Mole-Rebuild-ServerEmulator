package com.fcc
{
   import avm2.intrinsics.memory.*;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import sample.MEncrypt.*;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.*;
   
   public function MEncrypt(param1:ByteArray, param2:int, param3:ByteArray) : void
   {
      var _temp_1:* = this;
      var _loc5_:* = undefined;
      var _loc8_:int = 0;
      var _loc19_:int = 0;
      var _loc18_:int = 0;
      var _loc4_:int = 0;
      var _loc16_:int = 0;
      var _loc17_:int = 0;
      var _loc15_:int = 0;
      var _loc14_:int = 0;
      var _loc13_:int = 0;
      var _loc12_:int = 0;
      var _loc10_:int = 0;
      var _loc9_:int = 0;
      var _loc6_:int;
      _loc8_ = _loc6_ = sample.MEncrypt.ESP;
      ESP = _loc6_ & -16;
      var _loc7_:int = int(getDefinitionByName("com.taomee.mole.net.ConnectionServerAgent").size);
      if(_loc7_ == 5477)
      {
         ESP = _loc6_ & -16;
         _loc19_ = param2;
         _loc6_ -= 16;
         si32(_loc19_,_loc6_);
         ESP = _loc6_;
         F_malloc();
         _loc6_ += 16;
         _loc18_ = sample.MEncrypt.eax;
         ESP = _loc6_ & -16;
         CModule.writeBytes(_loc18_,_loc19_,param1);
         _loc6_ -= 16;
         _loc17_ = _loc19_ + 1;
         si32(_loc17_,_loc6_);
         ESP = _loc6_;
         F_malloc();
         _loc6_ += 16;
         _loc16_ = sample.MEncrypt.eax;
         _loc15_ = _loc18_;
         _loc14_ = _loc16_;
         _loc13_ = _loc19_;
         _loc12_ = 0;
         if(_loc19_ >= 1)
         {
            do
            {
               _loc4_ = li8(_loc15_);
               _loc9_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str5;
               _loc10_ = 0;
               if(_loc12_ != 21)
               {
                  _loc9_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str5 + _loc12_;
                  _loc10_ = _loc12_ + 1;
               }
               _loc7_ = li8(_loc9_);
               _loc7_ = _loc7_ ^ _loc4_;
               si8(_loc7_,_loc14_);
               _loc15_ += 1;
               _loc14_ += 1;
               _loc13_ += -1;
               _loc12_ = _loc10_;
            }
            while(_loc13_ != 0);
         }
         _loc4_ = _loc16_ + _loc19_;
         si8(0,_loc4_);
         _loc7_ = _loc19_ + -1;
         if(_loc7_ >= 0)
         {
            _loc13_ = 0 - _loc19_;
            if(_loc13_ <= -1)
            {
               _loc13_ = -1;
            }
            _loc7_ = _loc19_ + _loc13_;
            _loc19_ = _loc7_ + 1;
            do
            {
               _loc7_ = li8(_loc4_);
               var _loc11_:int = li8(_loc4_ - 1);
               _loc11_ = _loc11_ >>> 3;
               _loc7_ = _loc11_ | _loc7_;
               si8(_loc7_,_loc4_);
               _loc7_ = li8(_loc4_ - 1);
               _loc7_ = _loc7_ << 5;
               si8(_loc7_,_loc4_ - 1);
               _loc4_ += -1;
            }
            while(_loc19_ += -1, _loc19_ != 0);
         }
         _loc7_ = li8(_loc16_);
         _loc7_ = _loc7_ | 3;
         si8(_loc7_,_loc16_);
         if(_loc18_ != 0)
         {
            _loc6_ -= 16;
            si32(_loc18_,_loc6_);
            ESP = _loc6_;
            F_idalloc();
            _loc6_ += 16;
         }
         ESP = _loc6_ & -16;
         CModule.readBytes(_loc16_,_loc17_,param3);
         if(_loc16_ != 0)
         {
            _loc6_ -= 16;
            si32(_loc16_,_loc6_);
            ESP = _loc6_;
            F_idalloc();
            _loc6_ += 16;
         }
      }
      ESP = _loc6_ = _loc8_;
      return _loc5_;
   }
}

