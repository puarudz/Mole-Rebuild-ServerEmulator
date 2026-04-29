package com.module.elementKnight.constant
{
   import com.global.staticData.XMLInfo;
   import com.module.elementKnight.info.ElementKnightEnemyCardInfo;
   import org.taomee.ds.HashMap;
   
   public class ElementKnightEnemyCardXML
   {
      
      private var _cardMap:HashMap;
      
      public function ElementKnightEnemyCardXML()
      {
         super();
      }
      
      public function setup() : void
      {
         var cardInfo:ElementKnightEnemyCardInfo = null;
         var tempXml:XML = null;
         var xml:XML = XML(new XMLInfo.elementKnightEnemyCardCls());
         this._cardMap = new HashMap();
         for each(tempXml in xml.elements("Enemy"))
         {
            cardInfo = new ElementKnightEnemyCardInfo(tempXml);
            this._cardMap.add(cardInfo.staticId,cardInfo);
         }
      }
      
      public function get enemyCardMap() : HashMap
      {
         return this._cardMap;
      }
   }
}

