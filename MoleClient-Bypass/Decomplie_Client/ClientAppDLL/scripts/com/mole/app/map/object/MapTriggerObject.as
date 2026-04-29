package com.mole.app.map.object
{
   public class MapTriggerObject extends MapObjectBase
   {
      
      public function MapTriggerObject(triggerXml:XML)
      {
         super(String(triggerXml.@Layer),triggerXml.@ResName,triggerXml);
      }
   }
}

