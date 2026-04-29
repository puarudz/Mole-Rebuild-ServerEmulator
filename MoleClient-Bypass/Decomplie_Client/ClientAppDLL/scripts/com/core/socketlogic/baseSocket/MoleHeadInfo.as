package com.core.socketlogic.baseSocket
{
   import flash.utils.IDataInput;
   import org.taomee.net.tmf.HeadInfo;
   
   public class MoleHeadInfo extends HeadInfo
   {
      
      private var _packLen:uint;
      
      private var _verson:int;
      
      public function MoleHeadInfo(data:IDataInput)
      {
         super();
         if(Boolean(data))
         {
            this._verson = data.readByte();
            commandID = data.readUnsignedInt();
            userID = data.readUnsignedInt();
            result = data.readUnsignedInt();
         }
      }
      
      public function get verson() : uint
      {
         return this._verson;
      }
      
      public function get packLen() : uint
      {
         return this._packLen;
      }
      
      public function set packLen(len:uint) : void
      {
         this._packLen = len;
      }
   }
}

