package com.module.query
{
   import com.event.EventTaomee;
   import com.logic.socket.examinePack.examinePackStuff;
   
   public class QueryImpl implements IQuery
   {
      
      private static var instance:QueryImpl;
      
      private static var canotNew:Boolean = true;
      
      private static var querySuccFunList:Array = new Array();
      
      private static var queryGroupList:Array = new Array();
      
      private static var currentArray:Array = new Array();
      
      public function QueryImpl()
      {
         super();
         if(canotNew)
         {
            throw new Error("QueryImpl不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : IQuery
      {
         if(!instance)
         {
            canotNew = false;
            instance = new QueryImpl();
            canotNew = true;
         }
         return instance;
      }
      
      public function QueryItem(itemIDArr:Array, successFun:Function, failFun:Function = null) : void
      {
         var qa:Array = null;
         var qa1:Array = null;
         if(itemIDArr.length < 1)
         {
            throw new Error("你查詢的物品數量小於1個，請從新查詢。");
         }
         if(this.checkItemIDArr(itemIDArr))
         {
            querySuccFunList.push(successFun);
            queryGroupList.push(int((itemIDArr.length - 1) / 20) + 1);
            GV.onlineSocket.addEventListener("QueryItem_read_" + 1915,this.querySuccFun);
            if(itemIDArr.length > 20)
            {
               qa = itemIDArr.splice(0);
               qa1 = qa.splice(0,20);
               while(Boolean(qa1.length))
               {
                  examinePackStuff.examinePack_create(qa1,true);
                  qa1 = qa.splice(0,qa.length >= 20 ? 20 : qa.length);
               }
            }
            else
            {
               examinePackStuff.examinePack_create(itemIDArr,true);
            }
            return;
         }
         throw new Error("你查詢的物品重復查詢的物品ID，請從新查詢。");
      }
      
      private function checkItemIDArr(tempArr:Array) : Boolean
      {
         var j:int = 0;
         var ret:Boolean = true;
         for(var i:int = 0; i < tempArr.length - 1; i++)
         {
            for(j = i + 1; j < tempArr.length; j++)
            {
               if(tempArr[i] == tempArr[j])
               {
                  return false;
               }
            }
         }
         return ret;
      }
      
      private function querySuccFun(evt:EventTaomee) : void
      {
         var sf:Function = null;
         var _arr:Array = null;
         try
         {
            currentArray = currentArray.concat(evt.EventObj.arr);
            if(queryGroupList[0] <= 1)
            {
               if(Boolean(querySuccFunList[0]))
               {
                  sf = querySuccFunList.shift();
                  queryGroupList.shift();
                  _arr = currentArray;
                  currentArray = [];
                  sf(_arr);
               }
            }
            else if(isNaN(queryGroupList[0]))
            {
               sf = querySuccFunList.shift();
               queryGroupList.shift();
            }
            else
            {
               --queryGroupList[0];
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

