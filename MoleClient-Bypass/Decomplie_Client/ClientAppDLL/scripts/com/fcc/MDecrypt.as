package com.fcc
{
   import avm2.intrinsics.memory.*;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import sample.MEncrypt.*;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.*;
   
   public function MDecrypt(param1:ByteArray, param2:int, param3:ByteArray) : void
   {
      var _loc15_:* = undefined;
      var _loc6_:int = 0;
      var _loc17_:int = 0;
      var _loc16_:int = 0;
      var _loc10_:int = 0;
      var _loc13_:int = 0;
      var _loc14_:int = 0;
      var _loc12_:int = 0;
      var _loc11_:int = 0;
      var _loc9_:int = 0;
      var _loc7_:int = 0;
      var _loc5_:int;
      _loc6_ = _loc5_ = sample.MEncrypt.ESP;
      ESP = _loc5_ & -16;
      var _loc4_:int = int(getDefinitionByName("com.taomee.mole.net.ConnectionServerAgent").size);
      if(_loc4_ == 5477)
      {
         ESP = _loc5_ & -16;
         _loc17_ = param2;
         _loc5_ -= 16;
         si32(_loc17_,_loc5_);
         ESP = _loc5_;
         F_malloc();
         _loc5_ += 16;
         _loc16_ = sample.MEncrypt.eax;
         ESP = _loc5_ & -16;
         CModule.writeBytes(_loc16_,_loc17_,param1);
         _loc5_ -= 16;
         _loc14_ = _loc17_ + -1;
         si32(_loc14_,_loc5_);
         ESP = _loc5_;
         F_malloc();
         _loc5_ += 16;
         _loc13_ = sample.MEncrypt.eax;
         if(_loc14_ >= 1)
         {
            _loc12_ = _loc16_ + 1;
            _loc11_ = _loc17_ + -1;
            _loc10_ = li8(_loc16_);
            _loc9_ = _loc13_;
            do
            {
               _loc4_ = _loc10_ & 0xE0;
               var _loc8_:int = _loc4_ >>> 5;
               _loc10_ = li8(_loc12_);
               _loc4_ = _loc10_ << 3;
               _loc4_ = _loc4_ | _loc8_;
               si8(_loc4_,_loc9_);
               _loc12_ += 1;
               _loc11_ += -1;
               _loc9_ += 1;
            }
            while(_loc11_ != 0);
            if(_loc14_ >= 1)
            {
               _loc12_ = _loc17_ + -1;
               _loc11_ = _loc13_;
               _loc7_ = 0;
               do
               {
                  _loc10_ = li8(_loc11_);
                  _loc9_ = 0;
                  _loc17_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str5;
                  if(_loc7_ != 21)
                  {
                     _loc17_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str5 + _loc7_;
                     _loc9_ = _loc7_ + 1;
                  }
                  _loc4_ = li8(_loc17_);
                  _loc4_ = _loc4_ ^ _loc10_;
                  si8(_loc4_,_loc11_);
                  _loc11_ += 1;
                  _loc12_ += -1;
                  _loc7_ = _loc9_;
               }
               while(_loc12_ != 0);
            }
         }
         if(_loc16_ != 0)
         {
            _loc5_ -= 16;
            si32(_loc16_,_loc5_);
            ESP = _loc5_;
            F_idalloc();
            _loc5_ += 16;
         }
         ESP = _loc5_ & -16;
         CModule.readBytes(_loc13_,_loc14_,param3);
         if(_loc13_ != 0)
         {
            _loc5_ -= 16;
            si32(_loc13_,_loc5_);
            ESP = _loc5_;
            F_idalloc();
            _loc5_ += 16;
         }
      }
      ESP = _loc5_ = _loc6_;
      return _loc15_;
   }
}

