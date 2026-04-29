package com.module.newAngel.info
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.info.AngelStaticInfo;
   import flash.utils.IDataInput;
   
   public class AngelIncubateInfo
   {
      
      public var angelId:uint;
      
      public var angelStaticId:uint;
      
      public var angelStartTime:uint;
      
      public var angelState:Array;
      
      public var angelLastOptTime:uint;
      
      public function AngelIncubateInfo(data:IDataInput = null)
      {
         var stateCount:uint = 0;
         var ix:int = 0;
         super();
         this.angelState = new Array();
         if(Boolean(data))
         {
            this.angelId = data.readUnsignedInt();
            this.angelStaticId = data.readUnsignedInt();
            this.angelStartTime = data.readUnsignedInt();
            this.angelLastOptTime = data.readUnsignedInt();
            stateCount = data.readUnsignedInt();
            for(ix = 0; ix < stateCount; ix++)
            {
               this.angelState.push(data.readUnsignedInt());
            }
         }
      }
      
      public function get angelStaticInfo() : AngelStaticInfo
      {
         return GoodsInfo.getAngelInfoById(this.angelStaticId);
      }
   }
}

