package com.mole.app.task
{
   import com.common.util.BitArray;
   import com.mole.app.task.trigger.TaskNowTrigger;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskStepTest
   {
      
      private var _inTrigger:TaskTriggerBase;
      
      private var _outTrigger:TaskTriggerBase;
      
      private var _testXml:XML;
      
      private var _step:TaskStep;
      
      private var _bits:Array;
      
      public function TaskStepTest(testXml:XML, step:TaskStep)
      {
         super();
         this._testXml = testXml;
         this._step = step;
         this._bits = String(testXml.@Bits).split(",");
         if(Boolean(testXml.In[0]))
         {
            this._inTrigger = new TaskNowTrigger(testXml.In[0],this._step,false);
         }
         if(Boolean(testXml.Out[0]))
         {
            this._outTrigger = new TaskNowTrigger(testXml.Out[0],this._step,false);
         }
      }
      
      public function test() : void
      {
         var bit:Object = null;
         var bitArr:BitArray = this._step.task.buffer.stateBit;
         var isPass:Boolean = true;
         for each(bit in this._bits)
         {
            if(bitArr.getBitAt(uint(bit) - 1) == false)
            {
               isPass = false;
               break;
            }
         }
         if(isPass)
         {
            if(Boolean(this._inTrigger))
            {
               this._inTrigger.check(null);
            }
         }
         else if(Boolean(this._outTrigger))
         {
            this._outTrigger.check(null);
         }
      }
   }
}

