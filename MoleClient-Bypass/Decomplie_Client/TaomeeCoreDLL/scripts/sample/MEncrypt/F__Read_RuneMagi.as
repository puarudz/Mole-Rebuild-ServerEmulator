package sample.MEncrypt
{
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.sxi16;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.F_idalloc;
   import sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str466;
   
   public function F__Read_RuneMagi() : void
   {
      var _temp_1:* = this;
      var _loc8_:int = 0;
      var _loc4_:int = 0;
      var _loc19_:int = 0;
      var _loc18_:int = 0;
      var _loc16_:int = 0;
      var _loc9_:int = 0;
      var _loc13_:int = 0;
      var _loc5_:int = 0;
      var _loc7_:int = 0;
      var _loc6_:int = 0;
      var _loc10_:int = 0;
      var _loc11_:int = 0;
      var _loc12_:int = 0;
      var _loc1_:int = 0;
      var _loc3_:int = sample.MEncrypt.ESP;
      _loc8_ = _loc3_;
      _loc3_ -= 96;
      _loc4_ = li32(_loc8_);
      var _loc20_:int = li32(sample.MEncrypt.___isthreaded);
      if(_loc20_ == 0)
      {
         _loc19_ = si16(li16(_loc4_ + 14));
      }
      else
      {
         _loc3_ -= 16;
         si32(_loc4_,_loc3_);
         ESP = _loc3_;
         F_fileno();
         _loc3_ += 16;
         _loc19_ = sample.MEncrypt.eax;
      }
      _loc3_ -= 16;
      _loc20_ = _loc8_ - 96;
      si32(_loc20_,_loc3_ + 4);
      si32(_loc19_,_loc3_);
      ESP = _loc3_;
      sample.MEncrypt.F__fstat();
      _loc18_ = 0;
      _loc3_ += 16;
      _loc20_ = sample.MEncrypt.eax;
      if(_loc20_ >= 0)
      {
         _loc19_ = li32(_loc8_ - 48);
         if((uint(_loc19_)) <= 3127)
         {
            ESP = _loc3_;
            sample.MEncrypt.F___error();
            var _temp_9:* = sample.MEncrypt.eax;
            si32(79,_temp_9);
            _loc18_ = 0;
         }
         else
         {
            _loc3_ -= 16;
            si32(_loc19_,_loc3_);
            ESP = _loc3_;
            F_malloc();
            _loc18_ = 0;
            _loc3_ += 16;
            _loc19_ = sample.MEncrypt.eax;
            if(_loc19_ != 0)
            {
               ESP = _loc3_;
               sample.MEncrypt.F___error();
               _loc18_ = 0;
               var _temp_13:* = sample.MEncrypt.eax;
               si32(_loc18_,_temp_13);
               _loc3_ -= 16;
               si32(_loc4_,_loc3_);
               ESP = _loc3_;
               F_rewind();
               _loc3_ += 16;
               ESP = _loc3_;
               sample.MEncrypt.F___error();
               _loc20_ = sample.MEncrypt.eax;
               _loc20_ = li32(_loc20_);
               if(_loc20_ != 0)
               {
                  ESP = _loc3_;
                  sample.MEncrypt.F___error();
                  _loc20_ = sample.MEncrypt.eax;
                  var _temp_22:* = li32(_loc20_);
                  _loc3_ -= 16;
                  si32(_loc19_,_loc3_);
                  ESP = _loc3_;
                  F_idalloc();
                  _loc3_ += 16;
                  ESP = _loc3_;
                  sample.MEncrypt.F___error();
                  si32(_temp_22,sample.MEncrypt.eax);
               }
               else
               {
                  var _temp_23:* = li32(_loc8_ - 48);
                  _loc3_ -= 16;
                  si32(_loc4_,_loc3_ + 12);
                  si32(1,_loc3_ + 8);
                  si32(_temp_23,_loc3_ + 4);
                  si32(_loc19_,_loc3_);
                  ESP = _loc3_;
                  F_fread();
                  _loc3_ += 16;
                  _loc20_ = sample.MEncrypt.eax;
                  if(_loc20_ != 1)
                  {
                     ESP = _loc3_;
                     sample.MEncrypt.F___error();
                     _loc20_ = sample.MEncrypt.eax;
                     var _temp_30:* = li32(_loc20_);
                     _loc3_ -= 16;
                     si32(_loc19_,_loc3_);
                     ESP = _loc3_;
                     F_idalloc();
                     _loc3_ += 16;
                     ESP = _loc3_;
                     sample.MEncrypt.F___error();
                     si32(_temp_30,sample.MEncrypt.eax);
                     _loc18_ = 0;
                  }
                  else
                  {
                     var _temp_31:* = li32(_loc8_ - 48);
                     _loc18_ = _loc19_ + _temp_31;
                     _loc16_ = _loc19_ + 3128;
                     _loc4_ = 0;
                     while(true)
                     {
                        _loc20_ = sample.MEncrypt__3A__5C_Development_5C_Crossbridge_5C_cygwin_5C_tmp_5C_cc4krDaY_2E_lto_2E_bc_3A_d3346e37_2D_9080_2D_43e6_2D_a632_2D_6710752e3a2f.L__2E_str466 - _loc4_;
                        _loc20_ = li8(_loc20_);
                        var _loc17_:int = _loc19_ - _loc4_;
                        _loc17_ = li8(_loc17_);
                        if(_loc17_ != _loc20_)
                        {
                           if(_loc19_ != 0)
                           {
                              _loc3_ -= 16;
                              si32(_loc19_,_loc3_);
                              ESP = _loc3_;
                              F_idalloc();
                              _loc3_ += 16;
                           }
                           ESP = _loc3_;
                           sample.MEncrypt.F___error();
                           _loc20_ = sample.MEncrypt.eax;
                           si32(79,_loc20_);
                           _loc18_ = 0;
                           break;
                        }
                        _loc4_ += -1;
                        if(_loc4_ == -8)
                        {
                           _loc20_ = li32(_loc19_ + 3124);
                           var _temp_39:* = _loc20_ >>> 24;
                           var _loc15_:int;
                           var _temp_42:* = (_loc15_ = (_loc15_ = _loc20_ >>> 8) & 0xFF00) | _temp_39;
                           _loc20_ = (_loc20_ = _loc20_ << 24 | (_loc20_ <<= 8) & 0xFF0000) | _temp_42;
                           si32(_loc20_,_loc19_ + 3124);
                           _loc17_ = li32(_loc19_ + 3112);
                           var _temp_47:* = _loc17_ >>> 24;
                           var _temp_50:* = (_loc15_ = (_loc15_ = _loc17_ >>> 8) & 0xFF00) | _temp_47;
                           _loc20_ = (_loc17_ = _loc17_ << 24 | (_loc17_ <<= 8) & 0xFF0000) | _temp_50;
                           si32(_loc20_,_loc19_ + 3112);
                           _loc20_ = li32(_loc19_ + 3116);
                           var _temp_55:* = _loc20_ >>> 24;
                           var _temp_58:* = (_loc15_ = (_loc15_ = _loc20_ >>> 8) & 0xFF00) | _temp_55;
                           _loc20_ = (_loc20_ = _loc20_ << 24 | (_loc20_ <<= 8) & 0xFF0000) | _temp_58;
                           si32(_loc20_,_loc19_ + 3116);
                           _loc20_ = li32(_loc19_ + 3120);
                           var _temp_63:* = _loc20_ >>> 24;
                           var _temp_66:* = (_loc15_ = (_loc15_ = _loc20_ >>> 8) & 0xFF00) | _temp_63;
                           _loc20_ = (_loc20_ = _loc20_ << 24 | (_loc20_ <<= 8) & 0xFF0000) | _temp_66;
                           si32(_loc20_,_loc19_ + 3120);
                           _loc4_ = -522;
                           do
                           {
                              _loc20_ = _loc4_ << 2;
                              _loc20_ = _loc19_ - _loc20_;
                              _loc15_ = li32(_loc20_ - 2048);
                              _loc17_ = _loc15_ >>> 24;
                              var _loc14_:int = _loc15_ >>> 8;
                              _loc14_ = _loc14_ & 0xFF00;
                              _loc17_ = _loc14_ | _loc17_;
                              _loc14_ = _loc15_ << 24;
                              _loc15_ <<= 8;
                              _loc15_ = _loc15_ & 0xFF0000;
                              _loc15_ = _loc14_ | _loc15_;
                              _loc17_ = _loc15_ | _loc17_;
                              si32(_loc17_,_loc20_ - 2048);
                              _loc17_ = li32(_loc20_ - 1024);
                              _loc15_ = _loc17_ >>> 24;
                              _loc14_ = _loc17_ >>> 8;
                              _loc14_ = _loc14_ & 0xFF00;
                              _loc15_ = _loc14_ | _loc15_;
                              _loc14_ = _loc17_ << 24;
                              _loc17_ <<= 8;
                              _loc17_ = _loc17_ & 0xFF0000;
                              _loc17_ = _loc14_ | _loc17_;
                              _loc17_ = _loc17_ | _loc15_;
                              si32(_loc17_,_loc20_ - 1024);
                              _loc15_ = li32(_loc20_);
                              _loc17_ = _loc15_ >>> 24;
                              _loc14_ = _loc15_ >>> 8;
                              _loc14_ = _loc14_ & 0xFF00;
                              _loc17_ = _loc14_ | _loc17_;
                              _loc14_ = _loc15_ << 24;
                              _loc15_ <<= 8;
                              _loc15_ = _loc15_ & 0xFF0000;
                              _loc15_ = _loc14_ | _loc15_;
                              _loc17_ = _loc15_ | _loc17_;
                              si32(_loc17_,_loc20_);
                           }
                           while(_loc4_ += -1, _loc4_ != -778);
                           _loc13_ = li32(_loc19_ + 3112);
                           _loc1_ = _loc13_ * 12;
                           _loc20_ = _loc16_ + _loc1_;
                           if((uint(_loc20_)) > uint(_loc18_))
                           {
                              if(_loc19_ != 0)
                              {
                                 _loc3_ -= 16;
                                 si32(_loc19_,_loc3_);
                                 ESP = _loc3_;
                                 F_idalloc();
                                 _loc3_ += 16;
                              }
                              ESP = _loc3_;
                              sample.MEncrypt.F___error();
                              _loc20_ = sample.MEncrypt.eax;
                              si32(79,_loc20_);
                              _loc18_ = 0;
                              break;
                           }
                           _loc4_ = li32(_loc19_ + 3116);
                           _loc9_ = _loc4_ + _loc13_;
                           var _temp_94:* = int(_loc9_ * 12);
                           _loc20_ = _loc16_ + _temp_94;
                           if((uint(_loc20_)) > uint(_loc18_))
                           {
                              _loc3_ -= 16;
                              si32(_loc19_,_loc3_);
                              ESP = _loc3_;
                              F_idalloc();
                              _loc3_ += 16;
                              ESP = _loc3_;
                              sample.MEncrypt.F___error();
                              var _temp_98:* = sample.MEncrypt.eax;
                              si32(79,_temp_98);
                              _loc18_ = 0;
                              break;
                           }
                           _loc20_ = li32(_loc19_ + 3120);
                           _loc20_ = _loc20_ + _loc9_;
                           var _temp_101:* = int(_loc20_ * 12);
                           _loc10_ = _loc16_ + _temp_101;
                           _loc12_ = _loc11_ = 0;
                           if(uint(_loc10_) > uint(_loc18_))
                           {
                              _loc3_ -= 16;
                              si32(_loc19_,_loc3_);
                              ESP = _loc3_;
                              F_idalloc();
                              _loc3_ += 16;
                              ESP = _loc3_;
                              sample.MEncrypt.F___error();
                              var _temp_104:* = sample.MEncrypt.eax;
                              si32(79,_temp_104);
                              _loc18_ = 0;
                              break;
                           }
                           while(true)
                           {
                              _loc6_ = _loc10_;
                              if(_loc13_ <= _loc11_)
                              {
                                 _loc20_ = li32(_loc19_ + 3116);
                                 if(_loc20_ >= 1)
                                 {
                                    _loc10_ = _loc19_ + _loc1_;
                                    _loc11_ = 0;
                                    do
                                    {
                                       _loc20_ = _loc11_ * 3;
                                       _loc20_ = _loc20_ << 2;
                                       _loc20_ = _loc10_ + _loc20_;
                                       _loc17_ = li32(_loc20_ + 3128);
                                       _loc15_ = _loc17_ >>> 24;
                                       _loc14_ = _loc17_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc14_ = _loc17_ << 24;
                                       _loc17_ <<= 8;
                                       _loc17_ = _loc17_ & 0xFF0000;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc17_ = _loc17_ | _loc15_;
                                       si32(_loc17_,_loc20_ + 3128);
                                       _loc17_ = li32(_loc20_ + 3132);
                                       _loc15_ = _loc17_ >>> 24;
                                       _loc14_ = _loc17_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc14_ = _loc17_ << 24;
                                       _loc17_ <<= 8;
                                       _loc17_ = _loc17_ & 0xFF0000;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc17_ = _loc17_ | _loc15_;
                                       si32(_loc17_,_loc20_ + 3132);
                                       _loc15_ = li32(_loc20_ + 3136);
                                       _loc17_ = _loc15_ >>> 24;
                                       _loc14_ = _loc15_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc14_ = _loc15_ << 24;
                                       _loc15_ <<= 8;
                                       _loc15_ = _loc15_ & 0xFF0000;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc17_ = _loc15_ | _loc17_;
                                       si32(_loc17_,_loc20_ + 3136);
                                       _loc11_ += 1;
                                    }
                                    while(_loc20_ = li32(_loc19_ + 3116), _loc20_ > _loc11_);
                                 }
                                 _loc10_ = li32(_loc19_ + 3120);
                                 if(_loc10_ >= 1)
                                 {
                                    var _temp_128:* = int(_loc4_ * 12);
                                    _loc20_ = _loc1_ + _temp_128;
                                    _loc20_ = _loc20_ + _loc19_;
                                    _loc13_ = _loc20_ + 3128;
                                    _loc11_ = 0;
                                    do
                                    {
                                       _loc20_ = _loc11_ * 3;
                                       _loc20_ = _loc20_ << 2;
                                       _loc20_ = _loc13_ + _loc20_;
                                       _loc17_ = li32(_loc20_);
                                       _loc15_ = _loc17_ >>> 24;
                                       _loc14_ = _loc17_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc14_ = _loc17_ << 24;
                                       _loc17_ <<= 8;
                                       _loc17_ = _loc17_ & 0xFF0000;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc17_ = _loc17_ | _loc15_;
                                       si32(_loc17_,_loc20_);
                                       _loc15_ = li32(_loc20_ + 4);
                                       _loc17_ = _loc15_ >>> 24;
                                       _loc14_ = _loc15_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc14_ = _loc15_ << 24;
                                       _loc15_ <<= 8;
                                       _loc15_ = _loc15_ & 0xFF0000;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc17_ = _loc15_ | _loc17_;
                                       si32(_loc17_,_loc20_ + 4);
                                       _loc15_ = li32(_loc20_ + 8);
                                       _loc17_ = _loc15_ >>> 24;
                                       _loc14_ = _loc15_ >>> 8;
                                       _loc14_ = _loc14_ & 0xFF00;
                                       _loc17_ = _loc14_ | _loc17_;
                                       _loc14_ = _loc15_ << 24;
                                       _loc15_ <<= 8;
                                       _loc15_ = _loc15_ & 0xFF0000;
                                       _loc15_ = _loc14_ | _loc15_;
                                       _loc17_ = _loc15_ | _loc17_;
                                       si32(_loc17_,_loc20_ + 8);
                                       _loc11_ += 1;
                                    }
                                    while(_loc10_ = li32(_loc19_ + 3120), _loc10_ > _loc11_);
                                 }
                                 _loc11_ = li32(_loc19_ + 3124);
                                 _loc20_ = _loc6_ + _loc11_;
                                 if((uint(_loc20_)) > uint(_loc18_))
                                 {
                                    if(_loc19_ != 0)
                                    {
                                       _loc3_ -= 16;
                                       si32(_loc19_,_loc3_);
                                       ESP = _loc3_;
                                       F_idalloc();
                                       _loc3_ += 16;
                                    }
                                    ESP = _loc3_;
                                    sample.MEncrypt.F___error();
                                    _loc20_ = sample.MEncrypt.eax;
                                    si32(79,_loc20_);
                                    _loc18_ = 0;
                                    break;
                                 }
                                 _loc6_ = li32(_loc19_ + 3112);
                                 _loc20_ = int(_loc6_ + _loc10_) + (_loc13_ = li32(_loc19_ + 3116));
                                 _loc20_ = _loc20_ << 2;
                                 _loc20_ = _loc20_ + _loc12_;
                                 var _temp_160:* = _loc20_ << 2;
                                 _loc20_ = _loc11_ + _temp_160;
                                 var _temp_162:* = int(_loc20_ + 3156);
                                 _loc3_ -= 16;
                                 si32(_temp_162,_loc3_);
                                 ESP = _loc3_;
                                 F_malloc();
                                 _loc3_ += 16;
                                 _loc18_ = sample.MEncrypt.eax;
                                 if(_loc18_ == 0)
                                 {
                                    ESP = _loc3_;
                                    sample.MEncrypt.F___error();
                                    _loc20_ = sample.MEncrypt.eax;
                                    var _temp_169:* = li32(_loc20_);
                                    _loc3_ -= 16;
                                    si32(_loc19_,_loc3_);
                                    ESP = _loc3_;
                                    F_idalloc();
                                    _loc3_ += 16;
                                    ESP = _loc3_;
                                    sample.MEncrypt.F___error();
                                    si32(_temp_169,sample.MEncrypt.eax);
                                    _loc18_ = 0;
                                    break;
                                 }
                                 si32(1768382797,_loc18_ + 4);
                                 si32(1701737810,_loc18_);
                                 _loc20_ = li32(_loc19_ + 36);
                                 si32(_loc20_,_loc18_ + 36);
                                 _loc20_ = li32(_loc19_ + 32);
                                 si32(_loc20_,_loc18_ + 32);
                                 _loc20_ = li32(_loc19_ + 28);
                                 si32(_loc20_,_loc18_ + 28);
                                 _loc20_ = li32(_loc19_ + 24);
                                 si32(_loc20_,_loc18_ + 24);
                                 _loc20_ = li32(_loc19_ + 20);
                                 si32(_loc20_,_loc18_ + 20);
                                 _loc20_ = li32(_loc19_ + 16);
                                 si32(_loc20_,_loc18_ + 16);
                                 _loc20_ = li32(_loc19_ + 12);
                                 si32(_loc20_,_loc18_ + 12);
                                 _loc20_ = li32(_loc19_ + 8);
                                 si32(_loc20_,_loc18_ + 8);
                                 si32(0,_loc18_ + 48);
                                 si32(_loc11_,_loc18_ + 3152);
                                 si32(_loc6_,_loc18_ + 3124);
                                 si32(_loc13_,_loc18_ + 3132);
                                 si32(_loc10_,_loc18_ + 3140);
                                 _loc3_ -= 16;
                                 si32(1024,_loc3_ + 8);
                                 _loc20_ = _loc19_ + 40;
                                 si32(_loc20_,_loc3_ + 4);
                                 _loc20_ = _loc18_ + 52;
                                 si32(_loc20_,_loc3_);
                                 ESP = _loc3_;
                                 Fmemcpy();
                                 _loc3_ += 16;
                                 _loc3_ -= 16;
                                 si32(1024,_loc3_ + 8);
                                 _loc20_ = _loc19_ + 1064;
                                 si32(_loc20_,_loc3_ + 4);
                                 _loc20_ = _loc18_ + 1076;
                                 si32(_loc20_,_loc3_);
                                 ESP = _loc3_;
                                 Fmemcpy();
                                 _loc3_ += 16;
                                 _loc3_ -= 16;
                                 si32(1024,_loc3_ + 8);
                                 _loc20_ = _loc19_ + 2088;
                                 si32(_loc20_,_loc3_ + 4);
                                 _loc20_ = _loc18_ + 2100;
                                 si32(_loc20_,_loc3_);
                                 ESP = _loc3_;
                                 Fmemcpy();
                                 _loc3_ += 16;
                                 _loc20_ = _loc18_ + 3156;
                                 si32(_loc20_,_loc18_ + 3128);
                                 var _temp_188:* = _loc6_ << 4;
                                 _loc12_ = _loc20_ + _temp_188;
                                 si32(_loc12_,_loc18_ + 3136);
                                 _loc17_ = _loc13_ + _loc6_;
                                 var _temp_191:* = _loc17_ << 4;
                                 _loc15_ = _loc20_ + _temp_191;
                                 si32(_loc15_,_loc18_ + 3144);
                                 _loc17_ += _loc10_;
                                 var _temp_194:* = _loc17_ << 4;
                                 _loc20_ += _temp_194;
                                 si32(_loc20_,_loc18_ + 3148);
                                 _loc20_ = _loc10_ + _loc9_;
                                 var _temp_197:* = int(_loc20_ * 12);
                                 _loc16_ += _temp_197;
                                 if(_loc6_ >= 1)
                                 {
                                    _loc9_ = 0;
                                    do
                                    {
                                       _loc12_ = _loc16_;
                                       _loc20_ = _loc9_ << 4;
                                       _loc20_ = _loc18_ + _loc20_;
                                       _loc17_ = _loc9_ * 3;
                                       _loc17_ = _loc17_ << 2;
                                       _loc17_ = _loc19_ + _loc17_;
                                       _loc6_ = li32(_loc17_ + 3128);
                                       si32(_loc6_,_loc20_ + 3156);
                                       _loc10_ = li32(_loc17_ + 3132);
                                       si32(_loc10_,_loc20_ + 3160);
                                       _loc17_ = li32(_loc17_ + 3136);
                                       si32(_loc17_,_loc20_ + 3164);
                                       _loc16_ = _loc9_ << 2;
                                       _loc9_ += 1;
                                       if(_loc17_ == 0)
                                       {
                                          var _temp_203:* = _loc16_ << 2;
                                          _loc11_ = _loc18_ + _temp_203;
                                          _loc5_ = li32(_loc18_ + 3148);
                                          si32(_loc5_,_loc11_ + 3168);
                                          _loc13_ = _loc10_ - _loc6_;
                                          _loc20_ = _loc13_ + 1;
                                          _loc17_ = _loc20_ << 2;
                                          _loc15_ = _loc5_ + _loc17_;
                                          si32(_loc15_,_loc18_ + 3148);
                                          _loc16_ = _loc12_ + _loc17_;
                                          if(_loc20_ >= 1)
                                          {
                                             _loc17_ = _loc13_ << 2;
                                             var _temp_210:* = int(_loc5_ + _loc17_);
                                             si32(_loc17_ = li32(_loc17_ = _loc12_ + _loc17_),_temp_210);
                                             _loc20_ = 1 - _loc6_;
                                             _loc20_ = _loc20_ + _loc10_;
                                             if(_loc20_ != 1)
                                             {
                                                _loc20_ = _loc6_ + 1;
                                                _loc6_ = _loc20_ - _loc10_;
                                                do
                                                {
                                                   _loc20_ = _loc6_;
                                                   _loc17_ = li32(_loc11_ + 3168);
                                                   _loc15_ = _loc20_ << 2;
                                                   _loc17_ -= _loc15_;
                                                   _loc15_ = _loc12_ - _loc15_;
                                                   _loc15_ = li32(_loc15_);
                                                   si32(_loc15_,_loc17_);
                                                   _loc6_ = _loc20_ + 1;
                                                }
                                                while(_loc20_ != 0);
                                             }
                                          }
                                       }
                                       else
                                       {
                                          var _temp_216:* = _loc16_ << 2;
                                          var _temp_217:* = int(_loc18_ + _temp_216);
                                          si32(0,_temp_217 + 3168);
                                          _loc16_ = _loc12_;
                                       }
                                    }
                                    while(_loc20_ = li32(_loc18_ + 3124), _loc20_ > _loc9_);
                                    _loc13_ = li32(_loc18_ + 3132);
                                    _loc12_ = li32(_loc18_ + 3136);
                                 }
                                 if(_loc13_ >= 1)
                                 {
                                    _loc20_ = _loc1_ + _loc19_;
                                    _loc9_ = _loc20_ + 3136;
                                    _loc6_ = 0;
                                    do
                                    {
                                       _loc20_ = _loc6_ << 4;
                                       _loc20_ = _loc12_ + _loc20_;
                                       _loc17_ = _loc6_ * 3;
                                       _loc17_ = _loc17_ << 2;
                                       _loc17_ = _loc9_ + _loc17_;
                                       _loc15_ = li32(_loc17_ - 8);
                                       si32(_loc15_,_loc20_);
                                       _loc15_ = li32(_loc17_ - 4);
                                       si32(_loc15_,_loc20_ + 4);
                                       _loc17_ = li32(_loc17_);
                                       si32(_loc17_,_loc20_ + 8);
                                       _loc6_ += 1;
                                    }
                                    while(_loc20_ = li32(_loc18_ + 3132), _loc20_ > _loc6_);
                                 }
                                 _loc20_ = li32(_loc18_ + 3140);
                                 if(_loc20_ >= 1)
                                 {
                                    _loc9_ = li32(_loc18_ + 3144);
                                    var _temp_227:* = int(_loc4_ * 12);
                                    _loc20_ = _loc1_ + _temp_227;
                                    _loc20_ = _loc20_ + _loc19_;
                                    _loc4_ = _loc20_ + 3136;
                                    _loc1_ = 0;
                                    do
                                    {
                                       _loc20_ = _loc1_ << 4;
                                       _loc20_ = _loc9_ + _loc20_;
                                       _loc17_ = _loc1_ * 3;
                                       _loc17_ = _loc17_ << 2;
                                       _loc17_ = _loc4_ + _loc17_;
                                       _loc15_ = li32(_loc17_ - 8);
                                       si32(_loc15_,_loc20_);
                                       _loc15_ = li32(_loc17_ - 4);
                                       si32(_loc15_,_loc20_ + 4);
                                       _loc17_ = li32(_loc17_);
                                       si32(_loc17_,_loc20_ + 8);
                                       _loc1_ += 1;
                                    }
                                    while