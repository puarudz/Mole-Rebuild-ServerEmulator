package com.module.angelPark
{
   import com.core.MainManager;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.mapView.activity.Task83.ComposeAngelCtl;
   import com.view.mapView.activity.Task83.StatisticsClass;
   
   public class ParkExtenalModelCtl
   {
      
      public function ParkExtenalModelCtl()
      {
         super();
      }
      
      public static function OpenLvlPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelParkLvlPanel.swf","正在加載等級面板....");
      }
      
      public static function OpenHonorPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelHoner.swf","正在打開天使榮譽....");
      }
      
      public static function OpenHospital() : void
      {
         OpenPanel("module/external/angelPark/AngelHospital.swf","正在打開天使醫院....");
      }
      
      public static function OpenShopPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelParkShopPanel.swf","正在打開天使園商店....");
      }
      
      public static function OpenAddAuraPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelParkAuraMain.swf","正在加載增加靈氣....");
      }
      
      public static function OpenHelpPanel() : void
      {
         OpenPanel("module/external/BooksUI/angelGuideBook.swf","正在加載天使園手冊....");
      }
      
      public static function OpenVisitorPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelParkRankAndVisitorPanel.swf","正在加載我的訪客....");
      }
      
      public static function OpenAngelParkMenu() : void
      {
         StatisticsClass.getInstance().init(67674943);
         OpenPanel("module/external/angelPark/AngelParkMenuMain.swf","正在加載天使聖殿....");
      }
      
      public static function OpenAngelCollectionPanel() : void
      {
         OpenPanel("module/external/angelPark/AngelCollection.swf","正在加載天使收藏....");
      }
      
      public static function OpenCombinePanel() : void
      {
         ComposeAngelCtl.getInstance().laoderComposePanel();
      }
      
      private static function OpenPanel(url:String, msg:String) : void
      {
         var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getAppLevel());
         loadGame = null;
      }
   }
}

