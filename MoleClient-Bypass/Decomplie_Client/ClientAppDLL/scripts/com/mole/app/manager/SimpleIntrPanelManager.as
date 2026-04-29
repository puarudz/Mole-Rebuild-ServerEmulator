package com.mole.app.manager
{
   import com.mole.app.module.SimpleIntrPanel;
   import com.view.mapView.activity.Task83.SoundManager;
   import org.taomee.ds.HashMap;
   
   public class SimpleIntrPanelManager
   {
      
      private static const INTR_ROOT_URL:String = "resource/intrswf/";
      
      private static var panelMap:HashMap = new HashMap();
      
      public function SimpleIntrPanelManager()
      {
         super();
      }
      
      public static function show(intrName:String) : void
      {
         if(intrName == "MelodiousDitty")
         {
            SoundManager.stopAll(false);
         }
         var panelUrl:String = VL.getURL(INTR_ROOT_URL + intrName + ".swf");
         panelMap.add(panelUrl,new SimpleIntrPanel(panelUrl));
      }
      
      public static function destroyPanel(url:String) : void
      {
         var panel:SimpleIntrPanel = panelMap.getValue(url);
         if(Boolean(panel))
         {
            if(url.indexOf("MelodiousDitty") != -1)
            {
               SoundManager.openAll();
            }
            panel.destroy();
            panelMap.remove(url);
         }
      }
   }
}

