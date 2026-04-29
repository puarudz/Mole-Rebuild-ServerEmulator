package com.module.checkBirthday
{
   import com.core.info.LocalUserInfo;
   import flash.display.MovieClip;
   
   public class MyselfBirthday
   {
      
      private var depthMC:MovieClip;
      
      public function MyselfBirthday(mc:MovieClip)
      {
         super();
         this.depthMC = mc;
         this.birthdayVis();
      }
      
      private function birthdayVis() : void
      {
         var date:Date = new Date();
         var day:uint = date.getDate();
         var month:uint = date.getMonth() + 1;
         var bornDate:Date = new Date(LocalUserInfo.getBookBirthday() * 1000);
         var bornDay:uint = bornDate.getDate();
         var bornMonth:uint = bornDate.getMonth() + 1;
         if(day == bornDay && month == bornMonth)
         {
            this.depthMC.boomBtn.userName.text = LocalUserInfo.getNickName();
            this.depthMC.boomBtn.gotoAndPlay(2);
         }
         else
         {
            this.depthMC.boomBtn.userName.text = "";
         }
      }
   }
}

