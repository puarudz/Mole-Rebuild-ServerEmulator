include "sample/MEncrypt/ptr2funInit.as";
include "sample/MEncrypt/threadArbMutexLock.as";
include "sample/MEncrypt/threadArbMutexUnlock.as";
include "sample/MEncrypt/threadArbCondsNotify.as";
include "sample/MEncrypt/threadArbCondWait.as";
include "sample/MEncrypt/yield.as";
include "sample/MEncrypt/newThread.as";
include "sample/MEncrypt/sbrk.as";

import flash.utils.*;
import sample.MEncrypt.*;

§__force_ordering_ns_c0fb5340-e53f-433b-8dba-280c9401591d§;
if(!sample.MEncrypt.ptr2fun_init.length)
{
   sample.MEncrypt.ptr2fun_init[0] = function():void
   {
      throw new Error("null function pointer called");
   };
   sample.MEncrypt.ptr2fun_init.length = 1;
}
var _temp_13:* = this;
sample.MEncrypt.ram_init;
_temp_13;
sample.MEncrypt.ram_init.endian = Endian.LITTLE_ENDIAN;
if(sample.MEncrypt.ram_init.length < sample.MEncrypt.domainClass.MIN_DOMAIN_MEMORY_LENGTH)
{
   sample.MEncrypt.ram_init.length = sample.MEncrypt.domainClass.MIN_DOMAIN_MEMORY_LENGTH;
}
sample.MEncrypt.domainClass.currentDomain.domainMemory = sample.MEncrypt.ram_init;

