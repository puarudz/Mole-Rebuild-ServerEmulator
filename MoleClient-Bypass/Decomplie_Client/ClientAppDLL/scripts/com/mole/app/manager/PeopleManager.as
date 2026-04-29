package com.mole.app.manager
{
   import com.logic.PeopleCountLogic.PeopleCountLogic;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.task.type.TaskStateType;
   import com.view.PeopleView.PeopleManageView;
   
   public class PeopleManager
   {
      
      private static var _isHideMount:Boolean = false;
      
      public function PeopleManager()
      {
         super();
      }
      
      public static function getPeopleView(userID:uint) : PeopleManageView
      {
         return GF.getPeopleByID(userID);
      }
      
      public static function get peopleList() : Array
      {
         return PeopleCountLogic.getAllPeopleList();
      }
      
      public static function get isNew() : Boolean
      {
         var task300:Task = TaskManager.getTask(300);
         if(task300 != null && task300.state == TaskStateType.FINISH)
         {
            return false;
         }
         return true;
      }
      
      public static function get isHideMount() : Boolean
      {
         return _isHideMount;
      }
      
      public static function set isHideMount(value:Boolean) : void
      {
         _isHideMount = value;
      }
   }
}

