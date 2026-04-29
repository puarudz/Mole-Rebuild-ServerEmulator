package com.module.elementKnight.info
{
   public class ElementKnightTollgateFightInfo
   {
      
      private var _id:uint;
      
      private var _attribute:uint;
      
      private var _enemyList:Vector.<uint>;
      
      private var _rewardCardId:uint;
      
      public function ElementKnightTollgateFightInfo(xml:XML)
      {
         var attributeName:String = null;
         super();
         this._id = uint(xml.@No);
         this._attribute = uint(xml.@Attribute);
         this._rewardCardId = uint(xml.@card);
         this._enemyList = new Vector.<uint>();
         var attributesList:XMLList = xml.@*;
         for(var i:int = 0; i < attributesList.length(); i++)
         {
            attributeName = attributesList[i].name();
            if(attributeName.indexOf("enemy") != -1)
            {
               this._enemyList.push(xml.attribute(attributeName));
            }
         }
      }
      
      public function get lifeId() : uint
      {
         return this._id;
      }
      
      public function get attribute() : uint
      {
         return this._attribute;
      }
      
      public function get enemyList() : Vector.<uint>
      {
         return this._enemyList;
      }
      
      public function get rewardCardId() : uint
      {
         return this._rewardCardId;
      }
   }
}

