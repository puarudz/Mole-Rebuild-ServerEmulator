package org.taomee.log
{
   import flash.utils.getTimer;
   
   public class TraceAppender
   {
      
      public function TraceAppender()
      {
         super();
      }
      
      public static function append(level:String, name:String, msg:String) : void
      {
         trace("[time=" + getTimer() + "]" + level + ": " + "(" + name + ") " + msg);
      }
   }
}

