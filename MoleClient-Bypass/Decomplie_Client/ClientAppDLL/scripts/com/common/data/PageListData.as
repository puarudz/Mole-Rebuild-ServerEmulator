package com.common.data
{
   public class PageListData
   {
      
      private var _dataList:Array;
      
      private var _curPage:uint;
      
      private var _pageNum:uint;
      
      public function PageListData(list:Array, pageNum:uint)
      {
         super();
         this.updateListData(list,pageNum);
      }
      
      public function get list() : Array
      {
         return this._dataList;
      }
      
      public function get pageNum() : uint
      {
         return this._pageNum;
      }
      
      public function updateListData(list:Array, pageNum:uint) : void
      {
         this.changeList(list);
         this._pageNum = pageNum;
      }
      
      public function getCurrentPageData() : Array
      {
         var curData:Array = new Array();
         var startPage:uint = this._pageNum * this._curPage;
         for(var i:uint = 0; i < this._pageNum; i++)
         {
            if(startPage + i >= this._dataList.length)
            {
               break;
            }
            curData.push(this._dataList[startPage + i]);
         }
         return curData;
      }
      
      public function next() : Boolean
      {
         if(this._curPage + 1 < this.totalPage)
         {
            ++this._curPage;
            return true;
         }
         return false;
      }
      
      public function prev() : Boolean
      {
         if(this._curPage - 1 >= 0)
         {
            --this._curPage;
            return true;
         }
         return false;
      }
      
      public function get curPage() : uint
      {
         return this._curPage + 1;
      }
      
      public function changeToPage(page:uint) : Boolean
      {
         page--;
         if(page < this.totalPage)
         {
            this._curPage = page;
            return true;
         }
         return false;
      }
      
      public function changeList(list:Array) : void
      {
         if(list == null)
         {
            list = new Array();
         }
         this._dataList = list;
         if(this.curPage > this.totalPage)
         {
            this._curPage = 0;
         }
      }
      
      public function get totalPage() : uint
      {
         var total:uint = Math.ceil(this._dataList.length / this._pageNum);
         return total == 0 ? 1 : total;
      }
      
      public function destroy() : void
      {
         this._dataList = null;
      }
   }
}

