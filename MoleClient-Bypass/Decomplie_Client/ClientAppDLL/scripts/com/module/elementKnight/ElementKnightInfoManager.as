package com.module.elementKnight
{
   import com.common.Alert.Alert;
   import com.module.elementKnight.constant.ElementKnightCardAdvanceXML;
   import com.module.elementKnight.constant.ElementKnightCardSkillXML;
   import com.module.elementKnight.constant.ElementKnightEnemyCardXML;
   import com.module.elementKnight.constant.ElementKnightTalnetXML;
   import com.module.elementKnight.constant.ElementKnightTollgateXML;
   import com.module.elementKnight.info.ElementKnightCardAdvanceInfo;
   import com.module.elementKnight.info.ElementKnightCardInfo;
   import com.module.elementKnight.info.ElementKnightCardSkillInfo;
   import com.module.elementKnight.info.ElementKnightEnemyCardInfo;
   import com.module.elementKnight.info.ElementKnightTalnetInfo;
   import com.module.elementKnight.info.ElementKnightTollgateInfo;
   import com.mole.app.manager.ModuleManager;
   import flash.events.EventDispatcher;
   
   public class ElementKnightInfoManager extends EventDispatcher
   {
      
      private static var _instace:ElementKnightInfoManager;
      
      private var _tollgateXML:ElementKnightTollgateXML;
      
      private var _enemyCardXML:ElementKnightEnemyCardXML;
      
      private var _advanceXML:ElementKnightCardAdvanceXML;
      
      private var _skillXML:ElementKnightCardSkillXML;
      
      public function ElementKnightInfoManager()
      {
         super();
      }
      
      public static function getInstace() : ElementKnightInfoManager
      {
         return _instace = _instace || new ElementKnightInfoManager();
      }
      
      public function setup() : void
      {
         this._tollgateXML = new ElementKnightTollgateXML();
         this._tollgateXML.setup();
         this._enemyCardXML = new ElementKnightEnemyCardXML();
         this._enemyCardXML.setup();
         this._advanceXML = new ElementKnightCardAdvanceXML();
         this._advanceXML.setup();
         this._skillXML = new ElementKnightCardSkillXML();
         this._skillXML.setup();
         ElementKnightTalnetXML.setup();
         ElementCardManager.instance.getElementInfo();
      }
      
      public function openTollgate(tollgateId:Object = null) : void
      {
         if(this.checkElement())
         {
            ModuleManager.openPanel("ElementKnightTollgateChallengePanel",tollgateId);
         }
      }
      
      public function checkElement() : Boolean
      {
         if(ElementCardManager.instance.type == 0)
         {
            Alert.showChooseAlart("\t你還不是元素騎士，不能進行戰鬥，需要轉職為元素騎士嗎？",function():void
            {
               ModuleManager.openPanel("ElementKnightTransferPanel");
            });
            return false;
         }
         return true;
      }
      
      public function getTollgateInfoByID(id:uint) : ElementKnightTollgateInfo
      {
         return this._tollgateXML.tollgateMap.getValue(id);
      }
      
      public function getTalnetInfoById(id:uint, type:uint) : ElementKnightTalnetInfo
      {
         return ElementKnightTalnetXML.getTalnetInfo(id,type);
      }
      
      public function getCardInfoById(cardId:uint) : ElementKnightCardInfo
      {
         var cardInfo:ElementKnightCardInfo = new ElementKnightCardInfo(null);
         cardInfo.staticId = cardId;
         return cardInfo;
      }
      
      public function getUserCardInfoById(id:uint) : ElementKnightCardInfo
      {
         var cardInfo:ElementKnightCardInfo = null;
         for each(cardInfo in ElementCardManager.instance.cardList)
         {
            if(cardInfo.id == id)
            {
               return cardInfo;
            }
         }
         return null;
      }
      
      public function getEnemyCardInfoById(cardId:uint) : ElementKnightEnemyCardInfo
      {
         return this._enemyCardXML.enemyCardMap.getValue(cardId);
      }
      
      public function getCardAdvanceInfoById(cardId:uint) : ElementKnightCardAdvanceInfo
      {
         return this._advanceXML.advanceMap.getValue(cardId);
      }
      
      public function getCardSkillInfoById(skillId:uint) : ElementKnightCardSkillInfo
      {
         return this._skillXML.cardSkillMap.getValue(skillId);
      }
      
      public function sortByAcquiescence(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         var label:uint = 0;
         if(a.cardStatus == 1 && b.cardStatus == 1 || a.cardStatus == 0 && b.cardStatus == 0)
         {
            label = uint(this.sortByStar(a,b));
            if(label == 0)
            {
               label = uint(this.sortByLv(a,b));
               if(label == 0)
               {
                  return uint(this.sortById(a,b));
               }
               return label;
            }
            return label;
         }
         if(a.cardStatus == 1 && b.cardStatus == 0)
         {
            return 1;
         }
         if(a.cardStatus == 0 && b.cardStatus == 1)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortByStar(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         if(a.staticInfo.star > b.staticInfo.star)
         {
            return 1;
         }
         if(a.staticInfo.star < b.staticInfo.star)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortByLv(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         if(a.lv > b.lv)
         {
            return 1;
         }
         if(a.lv < b.lv)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortByAtk(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         if(a.maxAtk > b.maxAtk)
         {
            return 1;
         }
         if(a.maxAtk < b.maxAtk)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortByDef(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         if(a.maxDef > b.maxDef)
         {
            return 1;
         }
         if(a.maxDef < b.maxDef)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortById(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         if(a.id > b.id)
         {
            return 1;
         }
         if(a.id < b.id)
         {
            return -1;
         }
         return 0;
      }
      
      public function sortByUpGrade(a:ElementKnightCardInfo, b:ElementKnightCardInfo) : int
      {
         var label:uint = 0;
         label = uint(this.sortByLv(a,b));
         if(label == 0)
         {
            label = uint(this.sortByStar(a,b));
            if(label == 0)
            {
               return uint(this.sortById(a,b));
            }
            return label;
         }
         return label;
      }
   }
}

