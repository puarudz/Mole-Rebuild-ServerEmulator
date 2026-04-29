package com.global.staticData.database.MagicSpirit
{
   import com.global.staticData.XMLInfo;
   import flash.utils.Dictionary;
   
   public class MagicSpiriteAchievementDefined
   {
      
      private static var _dictionary:Dictionary;
      
      private static var _idList:Array;
      
      initialize();
      
      public function MagicSpiriteAchievementDefined()
      {
         super();
      }
      
      private static function initialize() : void
      {
         var defintion:MagicSpiriteAchievementDefintion = null;
         var xml:XML = null;
         _dictionary = new Dictionary();
         _idList = new Array();
         var baseXML:XML = new XML(new XMLInfo.magicSpiritAchievement());
         var xmlList:XMLList = baseXML.elements("Achievement");
         for each(xml in xmlList)
         {
            defintion = new MagicSpiriteAchievementDefintion(xml);
            _dictionary[defintion.id] = defintion;
            _idList.push(defintion.id);
         }
      }
      
      public static function getDefintionById(id:uint) : MagicSpiriteAchievementDefintion
      {
         return _dictionary[id];
      }
      
      public static function getIdList() : Array
      {
         return _idList.concat();
      }
   }
}

