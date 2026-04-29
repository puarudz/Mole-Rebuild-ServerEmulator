package com.module.acclimationSMC.data
{
   public class AcclimationSMC_UserInfo
   {
      
      public var userid:uint;
      
      public var vip:uint;
      
      public var level:uint;
      
      public var exp:uint;
      
      public var needExp:uint;
      
      public var bagsize:uint;
      
      public var exchg_bagsize:uint;
      
      public var max_training_num:uint;
      
      public var training_lv:uint;
      
      public var instrument1:uint;
      
      public var instrument2:uint;
      
      public var nick:String = "";
      
      public var color:uint = 0;
      
      public var friend_size:uint = 1;
      
      public var friendArr:Array = [null,null];
      
      public function AcclimationSMC_UserInfo()
      {
         super();
      }
   }
}

