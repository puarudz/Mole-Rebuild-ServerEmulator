package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.newAngel.info.NewAngelTowerStaticInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelTowerXML
   {
      
      private static var towerMap:HashMap;
      
      setup();
      
      public function NewAngelTowerXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var towerInfo:NewAngelTowerStaticInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.newAngelTowerCls());
         towerMap = new HashMap();
         for each(tempXml in xml.elements("tower"))
         {
            towerInfo = new NewAngelTowerStaticInfo(tempXml);
            towerMap.add(towerInfo.id,towerInfo);
         }
      }
      
      public static function getTowerInfoById(towerId:uint) : NewAngelTowerStaticInfo
      {
         return towerMap.getValue(towerId);
      }
   }
}

