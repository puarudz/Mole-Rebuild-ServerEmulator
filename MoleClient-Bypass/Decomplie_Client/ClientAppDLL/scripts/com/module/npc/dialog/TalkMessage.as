package com.module.npc.dialog
{
   import com.mole.debug.DebugManager;
   import com.mole.manager.DialogManager;
   
   public dynamic class TalkMessage
   {
      
      private var talk:Object;
      
      public var close:int;
      
      public var id:int;
      
      public var amity:int;
      
      public var hours:int;
      
      public var def:int;
      
      public var arg:String = "";
      
      public var face:String = "";
      
      public var que:String = "";
      
      public var ans:String = "";
      
      private var _msg:String = "";
      
      public var bubble:String = "";
      
      public var action:String = "";
      
      public var type:String = "";
      
      private var _info:Object;
      
      private var __type:String = "";
      
      public function TalkMessage(info:Object = null, _type:String = "a")
      {
         var name:String = null;
         super();
         for(name in info)
         {
            try
            {
               this[name] = info[name];
            }
            catch(E:Error)
            {
               if(DebugManager.DEBUG)
               {
                  throw E;
               }
            }
         }
         this.type = _type + "_" + this.id;
         this._info = info;
         this.__type = _type;
      }
      
      public static function getCustomMessage(message:String, quest:String = "", answer:String = "", arguments:String = "", face:String = "") : TalkMessage
      {
         var tm:TalkMessage = new TalkMessage();
         tm.msg = message;
         tm.que = quest;
         tm.ans = answer;
         tm.arg = arguments;
         tm.face = face;
         return tm;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function set msg(message:String) : void
      {
         if(Boolean(message))
         {
            this._msg = DialogManager.analysis(message);
         }
      }
      
      public function clone() : TalkMessage
      {
         return new TalkMessage(this._info,this.__type);
      }
   }
}

