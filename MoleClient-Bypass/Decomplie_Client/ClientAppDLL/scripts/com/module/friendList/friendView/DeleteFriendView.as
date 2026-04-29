package com.module.friendList.friendView
{
   import com.common.Alert.Alert;
   import com.common.scrollBar.ScrollBar;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.delFrend.DelFrendReq;
   import com.module.friendList.friendView.deleteFriendItem.DeleteFriendItemView;
   import com.mole.net.MoleSharedObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   
   public class DeleteFriendView
   {
      
      private var _ui:MovieClip;
      
      private var _itemContainer:MovieClip;
      
      private var _callBack:Function;
      
      private var _items:Array;
      
      private var _selectedCount:int;
      
      private var scrollBar:ScrollBar;
      
      public function DeleteFriendView(ui:MovieClip, closeCallBack:Function)
      {
         var itemView:DeleteFriendItemView = null;
         var item:Object = null;
         super();
         this._ui = ui;
         this._ui.visible = true;
         this._itemContainer = this._ui.container_mc;
         this._itemContainer.baseY = this._itemContainer.y;
         GC.clearAllChildren(this._itemContainer);
         this._callBack = closeCallBack;
         tip.tipTailDisPlayObject(this._ui.back_btn,"返回");
         BC.addEvent(this,this._ui.back_btn,MouseEvent.CLICK,this.Clear);
         BC.addEvent(this,this._ui.cancel_btn,MouseEvent.CLICK,this.Unselect);
         BC.addEvent(this,this._ui.delete_btn,MouseEvent.CLICK,this.TryDelete);
         this._items = new Array();
         var so:SharedObject = MainManager.getGlobalObject();
         var serverFriendsList:Array = so.data.ServerFriendsList;
         var startY:Number = 0;
         var offsetY:Number = 5;
         for each(item in serverFriendsList)
         {
            itemView = new DeleteFriendItemView(item.friend);
            this._itemContainer.addChild(itemView);
            itemView.y = startY;
            startY += itemView.height + offsetY;
            this._items.push(itemView);
            BC.addEvent(this,itemView,DeleteFriendItemView.DeleteFriendSuccess,this.DeleteSinalFriendOk);
            BC.addEvent(this,itemView,DeleteFriendItemView.UpdateSelectedState,this.UpdateSelctedCount);
         }
         this.scrollBar = new ScrollBar(null,this._itemContainer,{
            "length":36 * 6,
            "x":190,
            "y":this._itemContainer.y
         },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
         this.scrollBar.doChange();
         this.UpdateCountNum();
      }
      
      private function UpdateSelctedCount(e:Event) : void
      {
         var target:DeleteFriendItemView = e.currentTarget as DeleteFriendItemView;
         if(target.selected)
         {
            ++this._selectedCount;
         }
         else
         {
            --this._selectedCount;
         }
         this.UpdateCountNum();
      }
      
      private function UpdateCountNum() : void
      {
         if(this._selectedCount < 0)
         {
            this._selectedCount = 0;
         }
         var so:SharedObject = MainManager.getGlobalObject();
         var serverFriendsList:Array = so.data.ServerFriendsList;
         this._ui.count_txt.text = this._selectedCount + "/" + serverFriendsList.length;
      }
      
      private function DeleteSinalFriendOk(e:Event) : void
      {
         var target:DeleteFriendItemView = e.currentTarget as DeleteFriendItemView;
         if(target.selected)
         {
            --this._selectedCount;
            this.UpdateCountNum();
         }
         this.DeleteSinalFriend(target);
         this.scrollBar.doChange();
         var index:int = this._items.indexOf(target);
         if(Boolean(this._items[index]))
         {
            this.scrollBar.ScrollToItem(this._items[index]);
         }
         else if(Boolean(this._items[index - 1]))
         {
            this.scrollBar.ScrollToItem(this._items[index - 1]);
         }
      }
      
      private function DeleteSinalFriend(target:DeleteFriendItemView) : void
      {
         var itemView:DeleteFriendItemView = null;
         var startY:Number = NaN;
         var offsetY:Number = NaN;
         var childNum:int = 0;
         var i:int = 0;
         var item:* = undefined;
         this.DeleteFriendFromSO(target.userId);
         var index:int = this._items.indexOf(target);
         if(index != -1)
         {
            this._items.splice(index,1);
            this._itemContainer.removeChild(target);
            startY = 0;
            offsetY = 5;
            childNum = this._itemContainer.numChildren;
            for(i = 0; i < childNum; i++)
            {
               item = this._itemContainer.getChildAt(i);
               if(item is DeleteFriendItemView)
               {
                  itemView = item;
                  itemView.y = startY;
                  startY += itemView.height + offsetY;
               }
            }
         }
      }
      
      private function DeleteFriendFromSO(userId:int) : void
      {
         var so:SharedObject = MainManager.getGlobalObject();
         var serverFriendsList:Array = so.data.ServerFriendsList;
         var friendsList:Array = so.data.FriendsList;
         for(var i:int = 0; i < serverFriendsList.length; i++)
         {
            if(serverFriendsList[i].friend == userId)
            {
               friendsList.splice(i,1);
               break;
            }
         }
         MoleSharedObject.flush();
      }
      
      private function Unselect(e:MouseEvent) : void
      {
         var item:DeleteFriendItemView = null;
         for each(item in this._items)
         {
            item.selected = false;
         }
      }
      
      private function TryDelete(evt:MouseEvent) : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Deobfuscate code" option in Settings
          * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
      }
      
      private function DeleteFriends(friends:Array, friendIds:Array) : void
      {
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = "read_" + DelFrendReq.DeleteFriendsCmd;
         with({})
         {
            _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function h(e:EventTaomee):void
            {
               var delItem:DeleteFriendItemView = null;
               if(e.EventObj.state == 1)
               {
                  Alert.smileAlart("    刪除成功好友成功！");
                  for each(delItem in friends)
                  {
                     DeleteSinalFriend(delItem);
                  }
                  scrollBar.doChange();
                  _selectedCount = 0;
                  UpdateCountNum();
               }
               else
               {
                  Alert.smileAlart("    刪除失敗了，你今天還能刪除" + e.EventObj.canDeleteCount + "個好友！");
               }
            });
            DelFrendReq.DeleteFriends(friendIds);
         }
         
         private function Clear(e:*) : void
         {
            this.Close();
            if(this._callBack != null)
            {
               this._callBack();
            }
         }
         
         public function Close() : void
         {
            this._ui.visible = false;
            BC.removeEvent(this);
            this.scrollBar.clearClass();
            GC.clearAllChildren(this._itemContainer);
            this._itemContainer.y = this._itemContainer.baseY;
         }
      }
   }
   
   