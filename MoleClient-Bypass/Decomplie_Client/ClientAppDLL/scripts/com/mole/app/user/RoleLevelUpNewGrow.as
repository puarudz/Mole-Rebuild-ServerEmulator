package com.mole.app.user
{
   import com.core.info.LocalUserInfo;
   import com.mole.app.utils.PlayMovie;
   
   public class RoleLevelUpNewGrow
   {
      
      public function RoleLevelUpNewGrow()
      {
         super();
         if(LocalUserInfo.getLevel() - 5 >= 10)
         {
            PlayMovie.play("resourcemovie\newGrowTask_movie.swf",null,null,null,null,null,false);
         }
      }
   }
}

