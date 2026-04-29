package com.mole.app.manager
{
   import com.event.EventTaomee;
   import com.logic.socket.GetGoodsInfoByArr;
   import com.logic.socket.finishSomething.finishSomethingRes;
   
   public class QueryItemTool
   {
      
      public function QueryItemTool()
      {
         super();
      }
      
      public static function dayTypeQuery(dayType:uint, callBack:Function) : void
      {
         var getDoneTimesOver:Function = null;
         getDoneTimesOver = function(e:EventTaomee):void
         {
            if(e.EventObj.Type == dayType)
            {
               GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getDoneTimesOver);
               callBack.apply(null,[e.EventObj.Done]);
            }
         };
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,getDoneTimesOver);
         finishSomethingRes.sendReq(dayType);
      }
      
      public static function someGoosQuery(goodsIDArr:Array, callBack:Function) : void
      {
         var goodsArr:Array = null;
         var onCheckItemCount:Function = null;
         onCheckItemCount = function(e:EventTaomee):void
         {
            var i:uint = 0;
            var j:uint = 0;
            GV.onlineSocket.removeEventListener("read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,onCheckItemCount);
            var tarArr:Array = new Array();
            for(i = 0; i < goodsArr.length; i++)
            {
               tarArr[i] = 0;
            }
            var itemArr:Array = e.EventObj.itemArr;
            for(i = 0; i < itemArr.length; i++)
            {
               for(j = 0; j < goodsArr.length; j++)
               {
                  if(itemArr[i].itemID == goodsArr[j])
                  {
                     tarArr[j] = itemArr[i].count;
                  }
               }
            }
            trace("查詢的相對應的物品數量的數組為" + tarArr);
            callBack.apply(null,[tarArr]);
         };
         goodsArr = goodsIDArr;
         GV.onlineSocket.addEventListener("read_" + GetGoodsInfoByArr.GetGoodsInfoByArrCmd,onCheckItemCount);
         GetGoodsInfoByArr.GetGoodsInfo(2,goodsArr);
      }
   }
}

