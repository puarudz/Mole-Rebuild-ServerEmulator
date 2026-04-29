package com.module.npc.task
{
   public dynamic class TaskConditionMessage
   {
      
      private var talk:Object;
      
      public var id:int;
      
      public var status:String;
      
      public var type:String;
      
      public function TaskConditionMessage(info:Object, _type:String)
      {
         var name:String = null;
         super();
         for(name in info)
         {
            try
            {
               this[name] = info[name];
            }
            catch(Err:Error)
            {
               throw TaskConditionMessage + "缺少關鍵字:" + name;
            }
         }
         this.type = _type + "_" + this.id;
      }
      
      public function get statusList() : Array
      {
         return Boolean(this.status) ? this.status.split(",") : [];
      }
   }
}

