package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.newAngel.info.NewAngelMonsterStaticInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelFightMonsterXML
   {
      
      private static var map:HashMap;
      
      setup();
      
      public function NewAngelFightMonsterXML()
      {
         super();
      }
      
      private static function setup() : void
      {
         var monsterInfo:NewAngelMonsterStaticInfo = null;
         var monsterXML:XML = null;
         map = new HashMap();
         var xml:XML = new XML(new XMLInfo.newAngelMonsterCls());
         for each(monsterXML in xml.Monster)
         {
            monsterInfo = new NewAngelMonsterStaticInfo(monsterXML);
            map.add(monsterInfo.id,monsterInfo);
         }
      }
      
      public static function getMonsterInfoById(monsterId:uint) : NewAngelMonsterStaticInfo
      {
         return map.getValue(monsterId);
      }
   }
}

