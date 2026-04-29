package com.mole.app.utils
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import flash.display.Sprite;
   
   public class GetItem extends Sprite
   {
      
      public static var BACKITEMNUM:String = "get_goods_num";
      
      public var p:uint = 0;
      
      private var _taskGood:Array;
      
      private var goodsNum_arr:Array;
      
      public function GetItem()
      {
         super();
      }
      
      public function itemNum(idarr:Array) : void
      {
         this.p = 0;
         this._taskGood = idarr;
         this.goodsNum_arr = [];
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.backGoodsInfo);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._taskGood[this.p],2);
      }
      
      private function backGoodsInfo(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj.obj;
         if(obj.Count == 0)
         {
            this.goodsNum_arr.push(0);
         }
         else if(obj.arr[0].itemCount > 0)
         {
            this.goodsNum_arr.push(obj.arr[0].itemCount);
         }
         else
         {
            this.goodsNum_arr.push(0);
         }
         if(this.p >= this._taskGood.length - 1)
         {
            GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.backGoodsInfo);
            this.dispatchEvent(new EventTaomee("get_goods_num",{"arr":this.goodsNum_arr}));
         }
         else
         {
            ++this.p;
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),this._taskGood[this.p],2);
         }
      }
      
      public function destroy() : void
      {
         try
         {
            GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.backGoodsInfo);
         }
         catch(e:*)
         {
         }
      }
   }
}

