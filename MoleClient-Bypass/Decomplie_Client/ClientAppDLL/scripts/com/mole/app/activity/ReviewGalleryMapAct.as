package com.mole.app.activity
{
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   
   public class ReviewGalleryMapAct
   {
      
      private static var _inst:ReviewGalleryMapAct;
      
      private const MAPVEC:Vector.<uint> = new <uint>[63,40,68,2,331,120,342,349,319,357];
      
      private const BUFFERVEC:Vector.<uint> = new <uint>[137,138,139,140,141,142,143,145,146,148];
      
      private var _mapIndex:uint;
      
      public function ReviewGalleryMapAct()
      {
         super();
      }
      
      public static function getInst() : ReviewGalleryMapAct
      {
         if(!_inst)
         {
            _inst = new ReviewGalleryMapAct();
         }
         return _inst;
      }
      
      public function setUp() : void
      {
         for(var i:uint = 0; i < this.MAPVEC.length; i++)
         {
            if(MapManager.curMapID == this.MAPVEC[i])
            {
               this._mapIndex = i;
               BufferManager.addBufferEvent(this.BUFFERVEC[i],this.bufferHandle);
               BufferManager.getBuffer(this.BUFFERVEC[i]);
               break;
            }
         }
      }
      
      private function bufferHandle(e:EventTaomee) : void
      {
         var task:Task = null;
         BufferManager.removeBufferEvent(this.BUFFERVEC[this._mapIndex],this.bufferHandle);
         var times:uint = uint(e.EventObj);
         if(times == 1)
         {
            task = TaskManager.getTask(626);
            switch(this._mapIndex)
            {
               case 0:
                  task.buffer.step = 4;
                  TaskManager.runTask(626);
                  break;
               case 1:
                  task.buffer.step = 7;
                  TaskManager.runTask(626);
                  break;
               case 2:
                  task.buffer.step = 10;
                  TaskManager.runTask(626);
                  break;
               case 3:
                  task.buffer.step = 13;
                  TaskManager.runTask(626);
                  break;
               case 4:
                  task.buffer.step = 16;
                  TaskManager.runTask(626);
                  break;
               case 5:
                  task.buffer.step = 19;
                  TaskManager.runTask(626);
                  break;
               case 6:
                  task.buffer.step = 22;
                  TaskManager.runTask(626);
                  break;
               case 7:
                  task.buffer.step = 26;
                  TaskManager.runTask(626);
                  break;
               case 8:
                  task.buffer.step = 29;
                  TaskManager.runTask(626);
                  break;
               case 9:
                  task.buffer.step = 33;
                  TaskManager.runTask(626);
            }
         }
      }
      
      private function clearAll(e:EventTaomee) : void
      {
         this.destroy();
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this);
         GV.onlineSocket.removeEventListener(MapEvent.READY_CHANGE_MAP,this.destroy);
      }
   }
}

