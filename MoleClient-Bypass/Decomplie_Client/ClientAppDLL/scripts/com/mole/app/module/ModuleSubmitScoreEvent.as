package com.mole.app.module
{
   import com.mole.app.info.ModuleInfo;
   import flash.events.Event;
   
   public class ModuleSubmitScoreEvent extends Event
   {
      
      public static const SUBMIT_SCORE:String = "ModuleEvent_SubmitScore";
      
      private var _moduleInfo:ModuleInfo;
      
      public function ModuleSubmitScoreEvent(type:String, moduleInfo:ModuleInfo, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._moduleInfo = moduleInfo;
      }
      
      public function get moduleInfo() : ModuleInfo
      {
         return this._moduleInfo;
      }
      
      override public function clone() : Event
      {
         return new ModuleSubmitScoreEvent(this.type,this.moduleInfo,this.bubbles,this.cancelable);
      }
   }
}

