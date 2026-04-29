package com.logic.houseLogic
{
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.JJLCard.*;
   import flash.display.Sprite;
   
   public class JJLCardLogic extends Sprite
   {
      
      public static var oneLogic:JJLCardLogic;
      
      public static var CHANG_BACK:String = "chang_back_jjl";
      
      public static var SET_BACK:String = "set_back_jjl";
      
      public static var GET_BACK:String = "get_back_jjl";
      
      public static var SEARCH_BACK:String = "search_back_jjl";
      
      public static var CHANGCLOTH_BACK:String = "chang_colth_back_jjl";
      
      public static var EXCHANGE_MAGICCARD_BACK:String = "exchange_magiccard_back";
      
      public function JJLCardLogic()
      {
         super();
      }
      
      public static function getOneLogic() : JJLCardLogic
      {
         if(oneLogic == null)
         {
            oneLogic = new JJLCardLogic();
         }
         return oneLogic;
      }
      
      public function getCard(userID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetJJLCardRes.BACK_JJL_GET,this.backGetCard);
         GetJJLCardReq.GetCard(userID);
      }
      
      private function backGetCard(event:EventTaomee = null) : void
      {
         var a:uint = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,GetJJLCardRes.BACK_JJL_GET,this.backGetCard);
         var Arr:Array = event.EventObj.arr;
         if(Arr == null)
         {
            this.dispatchEvent(new EventTaomee(GET_BACK,{"arr":Arr}));
            return;
         }
         if(Arr.length > 0)
         {
            for(a = 0; a < Arr.length; a++)
            {
               obj = this.findOneCardInfo(Arr[a].ID);
               Arr[a].Type = obj.type;
               Arr[a].Name = obj.name;
            }
         }
         this.dispatchEvent(new EventTaomee(GET_BACK,{"arr":Arr}));
      }
      
      public function setCard(Flag:uint, myCardID:uint, getCardID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,SetJJLCardRes.BACK_JJL_SET,this.backSetCard);
         SetJJLCardReq.SetCard(Flag,myCardID,getCardID);
      }
      
      private function backSetCard(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SetJJLCardRes.BACK_JJL_SET,this.backSetCard);
         this.dispatchEvent(new EventTaomee(SET_BACK));
      }
      
      public function ExChang(friendID:uint, myCardID:uint, getCardID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,ExchangeJJLCardRes.BACK_JJL_CHANG,this.backExChang);
         ExchangeJJLCardReq.ChangCard(friendID,myCardID,getCardID);
      }
      
      private function backExChang(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ExchangeJJLCardRes.BACK_JJL_CHANG,this.backExChang);
         this.dispatchEvent(new EventTaomee(CHANG_BACK));
      }
      
      public function SearchUser(myID:uint, wantID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,SearchCardRes.BACK_JJL_GET,this.backSearch);
         SearchCardReq.findFun(myID,wantID);
      }
      
      private function backSearch(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SearchCardRes.BACK_JJL_GET,this.backSearch);
         var user_arr:Array = event.EventObj.arr;
         this.dispatchEvent(new EventTaomee(SEARCH_BACK,{"arr":user_arr}));
      }
      
      public function ChangCloth() : void
      {
         BC.addEvent(this,GV.onlineSocket,ExchangeJJLClothRes.BACK_JJL_CHANG,this.backChangCloth);
         ExchangeJJLClothReq.ChangCloth();
      }
      
      private function backChangCloth(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ExchangeJJLClothRes.BACK_JJL_CHANG,this.backChangCloth);
         this.dispatchEvent(new EventTaomee(CHANGCLOTH_BACK,{"obj":event.EventObj.obj}));
      }
      
      public function ExchangeMagic() : void
      {
         BC.addEvent(this,GV.onlineSocket,ExchangeMagicCardRes.EXCHANGE_MAGIC_FINISH,this.backMagic);
         ExchangeMagicCardReq.ExchangeMagicCard();
      }
      
      private function backMagic(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,ExchangeMagicCardRes.EXCHANGE_MAGIC_FINISH,this.backMagic);
         this.dispatchEvent(new EventTaomee(EXCHANGE_MAGICCARD_BACK,{"obj":event.EventObj.obj}));
      }
      
      public function findOneCardInfo(cardID:uint) : Object
      {
         var item:* = undefined;
         var obj:Object = new Object();
         var xml:XML = XMLInfo.JJLCardXML;
         xml.ignoreWhitespace = true;
         for each(item in xml.children())
         {
            if(item.@ID == cardID)
            {
               obj.id = uint(item.@ID);
               obj.name = String(item.@Name);
               obj.type = uint(item.@Type);
               return obj;
            }
         }
         return obj;
      }
      
      public function getAllCardInfo() : Array
      {
         var item:* = undefined;
         var obj:Object = null;
         var Arr:Array = new Array();
         var xml:XML = XMLInfo.JJLCardXML;
         xml.ignoreWhitespace = true;
         for each(item in xml.children())
         {
            obj = new Object();
            obj.id = uint(item.@ID);
            obj.name = String(item.@Name);
            obj.type = uint(item.@Type);
            obj.num = 0;
            obj.flag = 0;
            obj.wantid = 0;
            Arr.push(obj);
         }
         return Arr;
      }
   }
}

