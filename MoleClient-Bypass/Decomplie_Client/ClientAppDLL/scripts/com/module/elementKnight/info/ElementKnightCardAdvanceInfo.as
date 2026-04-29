package com.module.elementKnight.info
{
   import com.module.elementKnight.ElementKnightInfoManager;
   
   public class ElementKnightCardAdvanceInfo
   {
      
      private var _cardId:uint;
      
      private var _advanceId:uint;
      
      private var _cardName:String;
      
      private var _needCardList:Array;
      
      private var _cardInfo:ElementKnightCardInfo;
      
      public function ElementKnightCardAdvanceInfo(xml:XML)
      {
         var attributeName:String = null;
         var card:Array = null;
         var name:String = null;
         var str:String = null;
         var index:uint = 0;
         super();
         this._cardId = uint(xml.@Id);
         this._advanceId = uint(xml.@Advance_id);
         this._cardName = String(xml.@Name);
         var attributesList:XMLList = xml.@*;
         var cardList:Array = [];
         for(var i:int = 0; i < attributesList.length(); )
         {
            attributeName = attributesList[i].name();
            if(attributeName.indexOf("card") != -1)
            {
               cardList.push([attributeName,uint(xml.attribute(attributeName))]);
            }
            i++;
         }
         this._needCardList = new Array(cardList.length / 2);
         while(cardList.length > 0)
         {
            name = cardList[0][0];
            str = name.split("card")[1].toString();
            index = uint(str.charAt(0));
            if(str.indexOf("lv") == -1)
            {
               if(this._needCardList[index - 1] == null)
               {
                  this._needCardList[index - 1] = [];
               }
               this._needCardList[index - 1][0] = cardList[0][1];
            }
            else
            {
               if(this._needCardList[index - 1] == null)
               {
                  this._needCardList[index - 1] = [];
               }
               this._needCardList[index - 1][1] = cardList[0][1];
            }
            cardList.splice(0,1);
         }
         this._cardInfo = ElementKnightInfoManager.getInstace().getCardInfoById(this._cardId);
      }
      
      public function get cardId() : uint
      {
         return this._cardId;
      }
      
      public function get advanceId() : uint
      {
         return this._advanceId;
      }
      
      public function get cardName() : String
      {
         return this._cardName;
      }
      
      public function get needCardList() : Array
      {
         return this._needCardList;
      }
      
      public function get cardInfo() : ElementKnightCardInfo
      {
         return this._cardInfo;
      }
   }
}

