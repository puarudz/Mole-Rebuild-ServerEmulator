package com.module.newAngel.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.newAngel.info.NewAngelBuffInfo;
   import com.module.newAngel.info.NewAngelSkillInfo;
   import org.taomee.ds.HashMap;
   
   public class NewAngelSkillXML
   {
      
      private static var skillMap:HashMap;
      
      private static var buffMap:HashMap;
      
      setup();
      
      public function NewAngelSkillXML()
      {
         super();
      }
      
      public static function setup() : void
      {
         var skillInfo:NewAngelSkillInfo = null;
         var buffInfo:NewAngelBuffInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.newAngelSkillCls());
         skillMap = new HashMap();
         buffMap = new HashMap();
         for each(tempXml in xml.descendants("skill"))
         {
            skillInfo = new NewAngelSkillInfo(tempXml);
            skillMap.add(skillInfo.id,skillInfo);
         }
         for each(tempXml in xml.descendants("buffer"))
         {
            buffInfo = new NewAngelBuffInfo(tempXml);
            buffMap.add(buffInfo.id,buffInfo);
         }
      }
      
      public static function getSkillInfoById(skillId:uint) : NewAngelSkillInfo
      {
         return skillMap.getValue(skillId);
      }
      
      public static function getBuffInfoById(buffId:uint) : NewAngelBuffInfo
      {
         return buffMap.getValue(buffId);
      }
   }
}

