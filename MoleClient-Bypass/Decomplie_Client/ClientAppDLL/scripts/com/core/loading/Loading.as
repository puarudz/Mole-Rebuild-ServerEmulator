package com.core.loading
{
   import com.core.MainManager;
   import com.core.loading.loadingstyle.BaseLoadingStyle;
   import com.core.loading.loadingstyle.ILoadingStyle;
   import com.core.loading.loadingstyle.MainLoadingStyle;
   import com.core.loading.loadingstyle.TitleOnlyLoading;
   import com.core.loading.loadingstyle.TitlePercentLoading;
   import com.core.manager.LevelManager;
   
   public class Loading
   {
      
      private static var _loadingStyle:ILoadingStyle;
      
      public static const MAIN_LOAD:int = -1;
      
      public static const TITLE_AND_PERCENT:int = 1;
      
      public static const JUST_TITLE:int = 0;
      
      public static const NO_ALL:int = 2;
      
      public function Loading()
      {
         super();
      }
      
      public static function getLoadingStyle(style:int, title:String = "Loading...", isShowCloseBtn:Boolean = false) : ILoadingStyle
      {
         if(Boolean(_loadingStyle))
         {
            _loadingStyle.close();
            _loadingStyle = null;
         }
         switch(style)
         {
            case MAIN_LOAD:
               _loadingStyle = new MainLoadingStyle(LevelManager.stage,title,isShowCloseBtn);
               break;
            case TITLE_AND_PERCENT:
               _loadingStyle = new TitlePercentLoading(MainManager.getAppLevel(),title,isShowCloseBtn);
               break;
            case JUST_TITLE:
               _loadingStyle = new TitleOnlyLoading(MainManager.getAppLevel(),title,isShowCloseBtn);
               break;
            case NO_ALL:
               _loadingStyle = new BaseLoadingStyle(MainManager.getAppLevel(),isShowCloseBtn);
               break;
            default:
               _loadingStyle = new BaseLoadingStyle(MainManager.getAppLevel(),isShowCloseBtn);
         }
         return _loadingStyle;
      }
   }
}

