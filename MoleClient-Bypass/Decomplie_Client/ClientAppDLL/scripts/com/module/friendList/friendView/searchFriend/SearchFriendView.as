package com.module.friendList.friendView.searchFriend
{
   import com.common.tip.tip;
   import com.common.util.PinYinUtil;
   import com.module.friendList.friendView.FView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SearchFriendView
   {
      
      private var _ui:MovieClip;
      
      private var _searchTxt:TextField;
      
      public function SearchFriendView(ui:MovieClip)
      {
         super();
         this._ui = ui;
         this._searchTxt = this._ui.search_txt;
         BC.addEvent(this,this._searchTxt,Event.CHANGE,this.StartSearch);
         BC.addEvent(this,this._ui.clear_btn,MouseEvent.CLICK,this.ClearTxt);
         tip.tipTailDisPlayObject(this._ui.clear_btn,"清空搜索");
      }
      
      private function ClearTxt(e:MouseEvent) : void
      {
         this._searchTxt.text = "";
         this.StartSearch(null);
      }
      
      private function StartSearch(e:Event) : void
      {
         var txt:String = this._searchTxt.text;
         if(txt.length > 0)
         {
            this._ui.clear_btn.visible = true;
            this._ui.search_icon.visible = false;
            this.GetSearchResult(txt);
         }
         else
         {
            this._ui.clear_btn.visible = false;
            this._ui.search_icon.visible = true;
            FView.FilterUser(FView.arrMC);
         }
      }
      
      private function GetSearchResult(content:String) : void
      {
         var man:MovieClip = null;
         var name:String = null;
         var index:int = 0;
         var data:Array = null;
         var item:Object = null;
         var txt:String = PinYinUtil.toPinyin(content);
         var arr:Array = new Array();
         for each(man in FView.arrMC)
         {
            name = man.enNick;
            if(name != null)
            {
               index = name.indexOf(txt);
               if(index != -1)
               {
                  arr.push({
                     "obj":man,
                     "index":index
                  });
               }
            }
         }
         if(arr.length > 0)
         {
            arr.sortOn("index",Array.NUMERIC);
            data = new Array();
            for each(item in arr)
            {
               data.push(item.obj);
            }
            FView.FilterUser(data);
         }
      }
   }
}

