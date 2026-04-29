package com.module.npc.disposition
{
   public interface I_DispositionManage
   {
      
      function upData() : void;
      
      function get dispositionNameList() : Array;
      
      function get dispositionInstanceList() : Array;
      
      function getDispositionInstance(param1:String) : I_Disposition;
      
      function destroy(param1:* = null) : void;
   }
}

