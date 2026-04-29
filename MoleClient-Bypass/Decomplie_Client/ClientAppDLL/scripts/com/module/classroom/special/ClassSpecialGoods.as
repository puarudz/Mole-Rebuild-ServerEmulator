package com.module.classroom.special
{
   import com.module.classroom.ClassroomView;
   
   public class ClassSpecialGoods
   {
      
      public static var guestbook:*;
      
      public function ClassSpecialGoods()
      {
         super();
      }
      
      public static function specialgood(mc:Object) : void
      {
         switch(mc.ID)
         {
            case 1260013:
               mc.classname.text = ClassroomView.UserName;
               break;
            case 1260075:
               new DoctorScore(mc);
               break;
            case 1260100:
               new ABCScore(mc);
               break;
            default:
               new ClassBasicGood(mc);
         }
      }
   }
}

