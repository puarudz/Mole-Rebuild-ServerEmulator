package patch.view.PeopleView
{
   public class PatchPeopleManageView
   {
      
      public function PatchPeopleManageView()
      {
         super();
      }
      
      public static function isBoyAvatarType(action:int) : Boolean
      {
         if(action > 17051 && action <= 50000)
         {
            return action != 19000;
         }
         return false;
      }
   }
}

