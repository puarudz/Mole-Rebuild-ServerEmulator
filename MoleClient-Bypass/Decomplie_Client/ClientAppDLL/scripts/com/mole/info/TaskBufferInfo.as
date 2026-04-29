package com.mole.info
{
   import com.common.util.BitArray;
   
   public class TaskBufferInfo
   {
      
      private var _panelID:int;
      
      private var _stateBit:BitArray;
      
      private var _stepID:uint;
      
      public function TaskBufferInfo()
      {
         super();
         this.reset();
      }
      
      public function set bufferData(buffer:BitArray) : void
      {
         this._stepID = buffer.readByte();
         this._panelID = buffer.readUnsignedInt();
         this._stateBit = new BitArray();
         this._stateBit.writeUnsignedInt(buffer.readUnsignedInt());
      }
      
      public function get bufferData() : BitArray
      {
         var buffer:BitArray = new BitArray();
         buffer.writeByte(this._stepID);
         buffer.writeUnsignedInt(this._panelID);
         this._stateBit.position = 0;
         buffer.writeBytes(this._stateBit,0,4);
         return buffer;
      }
      
      public function reset() : void
      {
         this._panelID = 0;
         this._stepID = 0;
         this._stateBit = new BitArray();
         this._stateBit.writeUnsignedInt(0);
      }
      
      public function get panelId() : int
      {
         if(this._panelID == 0)
         {
            return 1;
         }
         return this._panelID;
      }
      
      public function set panelId(value:int) : void
      {
         this._panelID = value;
      }
      
      public function get stateBit() : BitArray
      {
         return this._stateBit;
      }
      
      public function get step() : uint
      {
         if(this._stepID == 0)
         {
            return 1;
         }
         return this._stepID;
      }
      
      public function set step(value:uint) : void
      {
         this._stepID = value;
      }
   }
}

