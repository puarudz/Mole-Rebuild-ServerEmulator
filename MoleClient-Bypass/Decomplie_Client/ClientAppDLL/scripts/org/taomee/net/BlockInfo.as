package org.taomee.net
{
   import flash.utils.ByteArray;
   import org.taomee.net.tmf.HeadInfo;
   
   internal class BlockInfo
   {
      
      internal var headInfo:HeadInfo;
      
      internal var data:ByteArray;
      
      public function BlockInfo(headInfo:HeadInfo, data:ByteArray = null)
      {
         super();
         this.headInfo = headInfo;
         this.data = data;
      }
   }
}

