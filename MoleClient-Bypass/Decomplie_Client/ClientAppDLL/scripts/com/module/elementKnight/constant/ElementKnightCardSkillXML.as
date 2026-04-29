package com.module.elementKnight.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.elementKnight.info.ElementKnightCardSkillInfo;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightCardSkillXML
   {
      
      private var _skillMap:HashMap;
      
      public function ElementKnightCardSkillXML()
      {
         super();
      }
      
      public function setup() : void
      {
         var skillInfo:ElementKnightCardSkillInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.elementKnightSkillCls());
         this._skillMap = new HashMap();
         for each(tempXml in xml.elements("card"))
         {
            skillInfo = new ElementKnightCardSkillInfo(tempXml);
            this._skillMap.add(skillInfo.skillId,skillInfo);
         }
      }
      
      public function get cardSkillMap() : HashMap
      {
         return this._skillMap;
      }
   }
}

