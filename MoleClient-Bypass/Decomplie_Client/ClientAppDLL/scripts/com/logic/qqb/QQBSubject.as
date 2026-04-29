package com.logic.qqb
{
   import com.view.PeopleView.PeopleManageView;
   
   public class QQBSubject
   {
      
      private var array:Array;
      
      public function QQBSubject()
      {
         super();
         this.array = [];
      }
      
      public function addObserver(mc:PeopleManageView) : void
      {
         this.array.push(mc);
      }
      
      public function delObserver(mc:PeopleManageView) : void
      {
         mc.avatarMC.wordBox.rotation = 0;
         var index:int = this.array.indexOf(mc);
         this.array.splice(index,1);
      }
      
      public function changeRtotaion(num:Number) : void
      {
         var i:PeopleManageView = null;
         for each(i in this.array)
         {
            if(i != null)
            {
               i.avatarMC.wordBox.rotation = -num;
            }
         }
      }
      
      public function clear() : void
      {
         this.array = [];
         this.array = null;
      }
   }
}

