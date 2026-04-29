package com.mole.app.manager
{
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.event.EventTaomee;
   import com.logic.task.Task382;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.view.noticeView.noticeView;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class TaskSpecialManager
   {
      
      private static var _isInit:Boolean = false;
      
      public function TaskSpecialManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         TaskManager.addEventListener(TaskManager.TASK_INIT_COMPLETE,onInitSpecial);
      }
      
      private static function onInitSpecial(e:Event) : void
      {
         _isInit = true;
         var myBirthday:uint = uint(LocalUserInfo.getBirthday());
         var date:Date = new Date(2014,7,1);
         var minTime:Number = date.getTime() / 1000;
         if(myBirthday < minTime)
         {
            BufferManager.setBuffer(BufferManager.TASK_382_201408_1,3);
            BufferManager.setBuffer(BufferManager.TASK_382_201408_2,3);
         }
         new Task382().init();
         var task273:Task = TaskManager.getTask(273);
         if(Boolean(task273) && task273.state == TaskStateType.FINISH)
         {
            task273.apply(false);
         }
         var jobType:int = int(GV.JobLogics.findJobTaskStatus(171));
         if(jobType == 1)
         {
            noticeView.owner.showCloakClothesIcon();
         }
         var tash382:uint = TaskManager.getTask(382).state;
         if(tash382 == 4)
         {
            openTask382overPanel();
         }
      }
      
      private static function openTask382overPanel() : void
      {
         GV.onlineSocket.addCmdListener(8606,back8606_1022);
         GF.sendSocket(8606,1022);
      }
      
      private static function back8606_1022(e:*) : void
      {
         var myBirthday:uint = 0;
         var date:Date = null;
         var minTime:Number = NaN;
         GV.onlineSocket.removeCmdListener(8606,back8606_1022);
         var data:ByteArray = e.data as ByteArray;
         var state:uint = data.readUnsignedInt();
         var arr:Array = [];
         var flag:uint = 0;
         for(var i:uint = 0; i < 8; i++)
         {
            flag = uint(Boolean(state >> i & 1));
            arr.push(flag);
         }
         if(arr[7] == 0)
         {
            myBirthday = uint(LocalUserInfo.getBirthday());
            date = new Date(2014,2,28,0,0,0);
            minTime = date.getTime() / 1000;
            if(myBirthday >= minTime)
            {
               ModuleManager.openPanel("Task382Panel_3");
            }
         }
      }
      
      private static function openTask382Box() : void
      {
         BufferManager.addBufferEvent(BufferManager.TASK_382_OVER_BOX,onCheckgame2);
         BufferManager.getBuffer(BufferManager.TASK_382_OVER_BOX);
      }
      
      private static function onCheckgame2(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TASK_382_OVER_BOX,onCheckgame2);
         var _buff:uint = uint(e.EventObj);
         var myBirthday:uint = uint(LocalUserInfo.getBirthday());
         var myDate:Date = new Date();
         myDate.time = myBirthday * 1000;
         var MyServer:Date = new Date(myDate.fullYear,myDate.month,myDate.date);
         var myMinTime:Number = MyServer.getTime() / 1000;
         var date:Date = ServerUpTime.getInstance().date;
         var server:Date = new Date(date.fullYear,date.month,date.date);
         var minTime:Number = server.getTime() / 1000;
         var oneNum:Number = 24 * 60 * 60;
         var _day:uint = 1;
         var _bln:Boolean = true;
         if(myMinTime < minTime)
         {
            _day = Math.floor((minTime - myMinTime) / oneNum) + 1;
         }
         if(_day > 3)
         {
            _bln = false;
         }
         else if(_day == _buff)
         {
            _bln = false;
         }
         if(_bln)
         {
            ModuleManager.openPanel("Task382Panel_2");
         }
      }
      
      public static function get isInit() : Boolean
      {
         return _isInit;
      }
   }
}

