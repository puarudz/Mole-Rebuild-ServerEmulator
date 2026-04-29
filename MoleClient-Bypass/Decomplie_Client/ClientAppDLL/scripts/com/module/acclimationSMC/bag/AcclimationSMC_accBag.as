package com.module.acclimationSMC.bag
{
   import com.common.data.HashMap;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.module.acclimationSMC.AcclimationSMCManager;
   import com.module.acclimationSMC.data.AcclimationSMC_ItemInfo;
   import com.module.acclimationSMC.socket.AcclimationSMC_SocketInfo;
   import com.mole.info.ItemInfo;
   import flash.events.Event;
   
   public class AcclimationSMC_accBag
   {
      
      private var userID:uint = 0;
      
      private var date:HashMap;
      
      private var InBag_date:HashMap;
      
      private var ExpBag_date:HashMap;
      
      private var Stockade_date:Array;
      
      public var InBag_size:int = 0;
      
      public var ExpBag_size:int = 0;
      
      public function AcclimationSMC_accBag()
      {
         super();
      }
      
      public function init(user:uint = 0) : void
      {
         this.userID = user;
         this.date = new HashMap();
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getInBagNum);
         GetItemCountReq.getItemCount(this.userID,1740001,0,1749999);
      }
      
      private function getInBagNum(e:EventTaomee) : void
      {
         var item:ItemInfo = null;
         var id:uint = 0;
         var num:uint = 0;
         var info:AcclimationSMC_ItemInfo = null;
         this.InBag_size = 0;
         this.InBag_date = new HashMap();
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getInBagNum);
         var itemPro:Object = e.EventObj.obj;
         var count:uint = uint(itemPro.itemHash.values.length);
         for(var i:uint = 0; i < count; i++)
         {
            item = itemPro.itemHash.values[i] as ItemInfo;
            id = item.ID;
            num = item.count;
            info = AcclimationSMCManager.makeItemInfo(id,num);
            this.InBag_date.add(id,info);
            this.date.add(id,info);
            this.InBag_size += item.count;
         }
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getExpBagNum);
         GetItemCountReq.getItemCount(this.userID,1740001,1,1749999);
      }
      
      private function getExpBagNum(e:EventTaomee) : void
      {
         var item:ItemInfo = null;
         var id:uint = 0;
         var num:uint = 0;
         var info:AcclimationSMC_ItemInfo = null;
         var old:AcclimationSMC_ItemInfo = null;
         var news:AcclimationSMC_ItemInfo = null;
         this.ExpBag_size = 0;
         this.ExpBag_date = new HashMap();
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getExpBagNum);
         var itemPro:Object = e.EventObj.obj;
         var count:uint = uint(itemPro.itemHash.values.length);
         for(var i:uint = 0; i < count; i++)
         {
            item = itemPro.itemHash.values[i] as ItemInfo;
            id = item.ID;
            num = item.count;
            info = AcclimationSMCManager.makeItemInfo(id,num,1);
            this.ExpBag_date.add(id,info);
            this.ExpBag_size += num;
            if(this.date.getValue(id) != null)
            {
               old = this.date.getValue(id);
               news = AcclimationSMCManager.makeItemInfo(id,old.count + num,1);
               this.date.add(id,news);
            }
            else
            {
               this.date.add(id,info);
            }
         }
         AcclimationSMC_SocketInfo.getInstance().addEventListener(AcclimationSMC_SocketInfo.GETSTOCKADEINFO,this.getListInfo);
         AcclimationSMC_SocketInfo.getInstance().getStockade(this.userID);
      }
      
      private function getListInfo(e:EventTaomee) : void
      {
         var info:AcclimationSMC_ItemInfo = null;
         var old:AcclimationSMC_ItemInfo = null;
         this.Stockade_date = new Array();
         AcclimationSMC_SocketInfo.getInstance().removeEventListener(AcclimationSMC_SocketInfo.GETSTOCKADEINFO,this.getListInfo);
         var obj:Object = e.EventObj;
         var i:uint = 0;
         for(i = 0; i < obj.count; i++)
         {
            info = obj.arr[i];
            this.Stockade_date.push(info);
            if(this.date.getValue(info.id) != null)
            {
               old = this.date.getValue(info.id);
               info.count += old.count;
            }
            this.date.add(info.id,info);
         }
         if(this.userID == LocalUserInfo.getUserID())
         {
            AcclimationSMCManager.getInstance().userInfo.friendArr = obj.friendArr;
            AcclimationSMCManager.getInstance().accBag = this;
         }
         AcclimationSMCManager.getInstance().dispatchEvent(new Event(AcclimationSMCManager.INIT_ACC_BAG));
      }
      
      public function getStockade_date() : Array
      {
         return this.Stockade_date;
      }
      
      public function getExpBag_date() : HashMap
      {
         return this.ExpBag_date;
      }
      
      public function getInBag_date() : HashMap
      {
         return this.InBag_date;
      }
      
      public function getInfoById(ItemID:uint) : AcclimationSMC_ItemInfo
      {
         var tempObj:AcclimationSMC_ItemInfo = this.date.getValue(ItemID);
         if(tempObj == null)
         {
            tempObj = AcclimationSMCManager.makeItemInfo(ItemID);
         }
         return tempObj;
      }
      
      public function setInfoById(info:AcclimationSMC_ItemInfo) : void
      {
         if(info != null)
         {
            this.date.add(info.id,info);
         }
      }
      
      public function getIsFullIoc(info:AcclimationSMC_ItemInfo) : uint
      {
         var id:uint = 0;
         var item:AcclimationSMC_ItemInfo = null;
         var flag:uint = 0;
         var arr:Array = info.material;
         var have:uint = 0;
         for(var i:uint = 0; i < arr.length; i++)
         {
            id = uint(arr[i]);
            item = this.getInfoById(id);
            if(item.count > 0)
            {
               have++;
            }
         }
         if(have == arr.length)
         {
            flag = 1;
         }
         return flag;
      }
      
      public function destroy() : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getInBagNum);
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getExpBagNum);
         BC.removeEvent(this);
         AcclimationSMC_SocketInfo.getInstance().removeEventListener(AcclimationSMC_SocketInfo.GETSTOCKADEINFO,this.getListInfo);
      }
   }
}

