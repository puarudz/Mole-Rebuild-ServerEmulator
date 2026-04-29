package com.module.npc.task
{
   public interface ITaskMessageManage
   {
      
      function get taskList() : Array;
      
      function getConditionMsg(param1:int = 0) : TaskConditionMessage;
      
      function getTaskMsg(param1:int = 0) : TaskMessage;
      
      function get taskNeedments() : Array;
   }
}

