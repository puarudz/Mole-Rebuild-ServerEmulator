package com.common.newAlert
{
   import com.taomee.component.MLoadPane;
   import com.taomee.component.MPanel;
   import com.taomee.component.MTextField;
   
   public interface IAlert
   {
      
      function close() : void;
      
      function getMainPanel() : MPanel;
      
      function getButtonPanel() : MPanel;
      
      function getTextField() : MTextField;
      
      function getLoadPane() : MLoadPane;
      
      function setApplyFun(param1:Function) : void;
      
      function setCancelFun(param1:Function) : void;
      
      function setMiniWidthEnabled(param1:Boolean) : void;
      
      function setMiniHeightEnabled(param1:Boolean) : void;
      
      function updateUI() : void;
   }
}

