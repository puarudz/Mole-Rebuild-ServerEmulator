package com.module.npc
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class NPCEvent extends Event
   {
      
      public static var ON_NPC_LEAVE:String = "onNPC_Leave";
      
      public static var ON_NPC_ENTER:String = "onNPC_Enter";
      
      public static var ON_NPC_LOADED:String = "onNPC_Loaded";
      
      public static var GET_NPC_BUTTON:String = "getNPC_Button";
      
      public static var GET_STAND_NPC_BUTTON:String = "getStandNPC_Button";
      
      public static var STAND_NPC_BUTTON_INIT_OK:String = "STAND_NPC_BUTTON_INIT_OK";
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = dispatchObj.dispatchEvent;
      
      public static var addEventListener:Function = dispatchObj.addEventListener;
      
      public static var removeEventListener:Function = dispatchObj.removeEventListener;
      
      private var _npc:I_NPC;
      
      private var _data:*;
      
      public function NPCEvent(type:String, npc:I_NPC, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._npc = npc;
      }
      
      public static function sendEvent(type:String, npc:I_NPC = null, data:* = null) : void
      {
         var e:NPCEvent = new NPCEvent(type,npc);
         e._data = data;
         NPCEvent.dispatchEvent(e);
      }
      
      public function get npc() : I_NPC
      {
         return this._npc;
      }
      
      public function get data() : *
      {
         return this._data;
      }
   }
}

