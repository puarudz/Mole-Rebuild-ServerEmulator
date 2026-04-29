package com.logic.task
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.NewStatisticsManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.map.MapManager;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.mole.app.type.ModuleType;
   import com.view.PeopleView.PeopleManageView;
   import com.view.toolView.toolView;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Task382
   {
      
      private const TASK_ID:uint = 382;
      
      private var _giftIndex:int = 0;
      
      private var _gifts:Array = [905,906,907,908,910,909];
      
      private var _task:Task;
      
      private var _topBtn:uint = 7;
      
      public function Task382()
      {
         super();
      }
      
      public static function get state() : uint
      {
         var myBirthday:uint = uint(LocalUserInfo.getBirthday());
         var date:Date = new Date(2012,5,20);
         var minTime:Number = date.getTime() / 1000;
         if(myBirthday < minTime)
         {
            return TaskStateType.FINISH;
         }
         var task382:Task = TaskManager.getTask(382);
         return task382.state;
      }
      
      public function init() : void
      {
         var task382:Task = null;
         if(state != TaskStateType.FINISH)
         {
            LocalUserInfo.setIsHideOtherMole(true);
            this._task = TaskManager.getTask(this.TASK_ID);
            this._task.addEventListener(Task.TASK_OVER,this.onTaskOver);
            GV.onlineSocket.addEventListener("beginTask382InMap15",this.beginTask382InMap15);
            GV.onlineSocket.addEventListener("overTask382tohome",this.overTask382tohome);
            GV.onlineSocket.addEventListener("showBagBtn_task382",this.showBagBtn_task382);
            if(TaskManager.getTask(300).state == TaskStateType.FINISH)
            {
               if(this._task.state == TaskStateType.NO_OPEN)
               {
                  this._task.apply();
                  this._task.addEventListener(Task.TASK_OPEN,this.onTask382Open);
               }
               else
               {
                  this.initStep();
               }
            }
         }
         else
         {
            task382 = TaskManager.getTask(382);
            if(Boolean(task382) && task382.state != TaskStateType.FINISH)
            {
               task382.over();
            }
         }
      }
      
      private function onTask382Open(e:Event) : void
      {
         this.initStep();
      }
      
      private function initStep(e:* = null) : void
      {
         if(this._task.state == TaskStateType.OPEN && this._task.buffer.step == 1)
         {
            if(MapManager.curMapID != 15)
            {
               MapManager.enterMap(15);
            }
         }
         else if(this._task.buffer.step == 2)
         {
            if(MapManager.curMapID != LocalUserInfo.getUserID())
            {
               MapManager.enterMap(LocalUserInfo.getUserID());
            }
         }
         else if(this._task.buffer.step >= 3)
         {
            this._task.over();
         }
      }
      
      private function setAllBtn(bln:Boolean = false, type:uint = 0) : void
      {
         var i:uint = 0;
         var one:* = undefined;
         if(bln)
         {
            toolView.setToolBtns(1,1,1,1,1,1,1,1,1,1,1,1,1);
         }
         else if(type == 1)
         {
            toolView.setToolBtns(0,0,0,0,1,0,0,0,0,0,0,0,0,0);
         }
         else
         {
            toolView.setToolBtns(0,0,0,0,0,0,0,0,0,0,0,0,0,0);
         }
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            for(i = 0; i < taskMC.numChildren; i++)
            {
               one = taskMC.getChildAt(i);
               if(Boolean(one && one.name.indexOf("instance") == -1) && Boolean(one.name != "clothes_btn") && one.name != "task382_mc")
               {
                  one.visible = bln;
                  one.mouseEnabled = bln;
               }
            }
         }
      }
      
      private function showSomeBtn(_arr:Array, bln:Boolean = true) : void
      {
         var one:* = undefined;
         var topUI:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         for(var i:uint = 0; i < _arr.length; i++)
         {
            one = topUI[_arr[i]];
            if(!one)
            {
               return;
            }
            one.visible = true;
            one.mouseEnabled = false;
            if(i == _arr.length - 1 && bln)
            {
               topUI["task382_mc"].x = one.x;
               topUI["task382_mc"].y = one.y;
            }
         }
      }
      
      private function hidBtnTipUI() : void
      {
         var topUI:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(topUI))
         {
            topUI["task382_mc"].x = 670;
            topUI["task382_mc"].y = -200;
         }
      }
      
      private function beginTask382InMap15(e:Event) : void
      {
         this.setAllBtn(false,0);
         NewStatisticsManager.send(473);
      }
      
      private function overTask382tohome(e:Event) : void
      {
         NewStatisticsManager.send(476);
         MapManager.enterMap(LocalUserInfo.getUserID());
      }
      
      private function showBagBtn_task382(e:Event) : void
      {
         this.setAllBtn(false,0);
         NewStatisticsManager.send(474);
      }
      
      private function onTaskOver(e:Event) : void
      {
         this.destroy();
         this.setAllBtn(true);
         ModuleManager.openPanel(ModuleType.TASK_FILES_PANEL,TaskManager.getDefaultShowTaskId());
      }
      
      public function destroy() : void
      {
         GV.onlineSocket.removeEventListener("beginTask382InMap15",this.beginTask382InMap15);
         GV.onlineSocket.removeEventListener("overTask382tohome",this.overTask382tohome);
         GV.onlineSocket.removeEventListener("showBagBtn_task382",this.showBagBtn_task382);
         this._task.removeEventListener(Task.TASK_OVER,this.onTaskOver);
         LocalUserInfo.setIsHideOtherMole(false);
         var self:PeopleManageView = PeopleManager.getPeopleView(LocalUserInfo.getUserID());
         self.visible = true;
         self.alpha = 1;
         toolView.setToolBtns(1,1,1,1,1,1,1,1,1,1,1,1,1);
         BC.removeEvent(this);
      }
   }
}

