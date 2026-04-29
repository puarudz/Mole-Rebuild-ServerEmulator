package com.module.npc.task
{
   public dynamic class TaskMessage
   {
      
      private var talk:Object;
      
      public var id:int;
      
      public var def:int;
      
      public var note:String;
      
      public var con:String;
      
      public var ass:String;
      
      public var hours:String;
      
      public var items:String;
      
      public var que:String;
      
      public var ans:String;
      
      public var arg:String;
      
      public var type:String;
      
      public var random:int;
      
      public function TaskMessage(info:Object, _type:String)
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
               throw TaskMessage + "缺少關鍵字:" + name;
            }
         }
         this.type = _type + "_" + this.id;
      }
      
      public function get itemsList() : Array
      {
         if(Boolean(this.items) && Boolean(this.items.length))
         {
            return this.items.split(",");
         }
         return [];
      }
      
      public function get assList() : Array
      {
         return this.ass.split(",");
      }
      
      public function get hoursList() : Array
      {
         return this.parsehours(this.hours);
      }
      
      private function parsehours(msg:String) : Array
      {
         var tempArr:Array = null;
         var i:int = 0;
         var j:int = 0;
         var hoursArray:Array = new Array(24);
         if(!msg || !msg.length)
         {
            for(i = 0; i < 24; i++)
            {
               hoursArray[i] = 1;
            }
            return hoursArray;
         }
         var lv30:Array = [];
         var lv20:Array = [];
         var lv10:Array = [];
         var lv1:Array = [];
         var all:Array = msg.split(",");
         for(i = 0; i < all.length; i++)
         {
            if(isNaN(all[i]))
            {
               if(String(all[i]).indexOf("~") > -1 && String(all[i]).indexOf("!") > -1)
               {
                  lv20.push(all[i]);
               }
               else if(String(all[i]).indexOf("!") > -1)
               {
                  lv10.push(all[i]);
               }
               else
               {
                  if(String(all[i]).indexOf("~") <= -1)
                  {
                     throw "表達式錯誤:不支持該表達式\"" + all[i] + "\"";
                  }
                  lv30.push(all[i]);
               }
            }
            else
            {
               lv1.push(int(all[i]));
            }
         }
         for(i = 0; i < lv30.length; i++)
         {
            if(Boolean(lv30[i]))
            {
               tempArr = String(lv30[i]).split("~");
               for(j = int(tempArr[0]); j < tempArr[1]; j++)
               {
                  hoursArray[j] = 1;
               }
            }
         }
         for(i = 0; i < lv20.length; i++)
         {
            if(Boolean(lv20[i]))
            {
               tempArr = String(lv20[i]).substring(1).split("~");
               for(j = int(tempArr[0]); j < tempArr[1]; j++)
               {
                  hoursArray[j] = 0;
               }
            }
         }
         for(i = 0; i < lv10.length; i++)
         {
            if(Boolean(lv10[i]))
            {
               hoursArray[String(lv10[i]).substring(1)] = 0;
            }
         }
         for(i = 0; i < lv1.length; i++)
         {
            if(Boolean(lv1[i]))
            {
               hoursArray[lv1[i]] = 1;
            }
         }
         return hoursArray;
      }
   }
}

