package com.mole.app.activity
{
   import com.mole.app.manager.BufferManager;
   
   public class FireCupStep
   {
      
      private static var _inst:FireCupStep;
      
      public var fireStep:uint;
      
      public function FireCupStep()
      {
         super();
      }
      
      public static function get inst() : FireCupStep
      {
         if(_inst == null)
         {
            _inst = new FireCupStep();
         }
         return _inst;
      }
      
      public function getStep() : void
      {
         BufferManager.addBufferEvent(BufferManager.FIRE_VULCAN_CUP,this.fireVulcanHandle);
         BufferManager.getBuffer(BufferManager.FIRE_VULCAN_CUP);
      }
      
      private function fireVulcanHandle(e:*) : void
      {
         BufferManager.removeBufferEvent(BufferManager.FIRE_VULCAN_CUP,this.fireVulcanHandle);
         this.fireStep = uint(e.EventObj);
      }
   }
}

