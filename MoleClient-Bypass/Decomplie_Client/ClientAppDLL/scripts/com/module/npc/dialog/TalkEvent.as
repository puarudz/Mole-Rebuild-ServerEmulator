package com.module.npc.dialog
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class TalkEvent extends Event
   {
      
      public static var THROW_DATA:String = "throw_Data";
      
      public static var SHOW_FACE:String = "show_Face";
      
      public static var CHAT_ACTION:String = "chat_action";
      
      public static var CHAT_ADD_ATTITUDE:String = "chat_add_Attitude";
      
      public static var CHAT_CASUAL:String = "chat_casual";
      
      public static var ON_PRINT_START:String = "onPrintStart";
      
      public static var ON_PRINT_BREAK:String = "onPrintBreak";
      
      public static var ON_PRINT_CONTINUE:String = "onPrintContinue";
      
      public static var ON_PRINT_OVER:String = "onPrintOver";
      
      public static var ON_DIALOG_OPEN:String = "onDialogOpen";
      
      public static var ON_DIALOG_CLOSE:String = "onDialogClose";
      
      private static var dispatchObj:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = dispatchObj.dispatchEvent;
      
      public static var addEventListener:Function = dispatchObj.addEventListener;
      
      public static var removeEventListener:Function = dispatchObj.removeEventListener;
      
      private var actionData:*;
      
      public function TalkEvent(type:String, act:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.actionData = act;
      }
      
      public function get data() : *
      {
         return this.actionData;
      }
      
      public function set data(_data:*) : void
      {
         this.actionData = _data;
      }
      
      public function get act() : String
      {
         return Boolean(this.actionData) ? this.actionData.act : "";
      }
      
      public function get arg() : Array
      {
         if(Boolean(this.actionData) && Boolean(this.actionData.arg))
         {
            return this.actionData.arg.split(",");
         }
         return new Array();
      }
   }
}

