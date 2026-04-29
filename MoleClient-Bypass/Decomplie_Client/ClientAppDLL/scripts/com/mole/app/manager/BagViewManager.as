package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.useUserDItem.UseUserItemRigRes;
   import com.module.activityModule.Presented;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class BagViewManager
   {
      
      private static var _bagView:AppModuleControl;
      
      public static var showClassID:int;
      
      private static var _eventDispatcher:EventDispatcher;
      
      public static var USE_EFFECT_PROP:String = "useEffect_prop";
      
      public static var USE_PROP:String = "use_prop";
      
      public function BagViewManager()
      {
         super();
      }
      
      public static function closeBag() : void
      {
         if(Boolean(_bagView))
         {
            _bagView.close();
            _bagView = null;
         }
      }
      
      public static function openBag() : void
      {
         _bagView = ModuleManager.openPanel(ModuleType.BAG_VIEW_PANEL,null,"正在加載背包。");
         _bagView.addEventListener(ModuleEvent.DESTROY,onBagViewDestroy);
         GV.onlineSocket.addEventListener(UseUserItemRigRes.USE_USER_ITEM_RIG,onUpdateBag);
         addEventListener(USE_EFFECT_PROP + "_16019",openEffect);
         addEventListener(USE_EFFECT_PROP + "_16020",openEffect);
         addEventListener(USE_EFFECT_PROP + "_16021",openEffect);
      }
      
      private static function openEffect(evt:EventTaomee) : void
      {
         var itemId:uint = evt.EventObj as uint;
         switch(itemId)
         {
            case 16019:
               Presented.getInstance().celebrate1225(2452,1,1);
               break;
            case 16020:
               Presented.getInstance().celebrate1225(2453,1,1);
               break;
            case 16021:
               GV.onlineSocket.addCmdListener(CommandID.PROTO_USER_GET_SEVEN_BOX,get8953BackInfo);
               GF.sendSocket(CommandID.PROTO_USER_GET_SEVEN_BOX,itemId);
         }
      }
      
      private static function get8953BackInfo(e:Event) : void
      {
         var id:uint = 0;
         var count:uint = 0;
         var id2:uint = 0;
         GV.onlineSocket.removeCmdListener(CommandID.PROTO_USER_GET_SEVEN_BOX,get8953BackInfo);
         var date:ByteArray = e["data"] as ByteArray;
         if(Boolean(date))
         {
            id = date.readUnsignedInt();
            count = date.readUnsignedInt();
            id2 = date.readUnsignedInt();
            Alert.smileAlart("恭喜你獲得1個" + GoodsInfo.getItemNameByID(id2) + "，" + count + "個" + GoodsInfo.getItemNameByID(id) + "，已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(id) + "中。");
         }
      }
      
      private static function onBagViewDestroy(e:ModuleEvent) : void
      {
         removeEventListener(USE_EFFECT_PROP + "_16019",openEffect);
         removeEventListener(USE_EFFECT_PROP + "_16020",openEffect);
         GV.onlineSocket.removeEventListener(UseUserItemRigRes.USE_USER_ITEM_RIG,onUpdateBag);
         _bagView.removeEventListener(ModuleEvent.DESTROY,onBagViewDestroy);
         _bagView = null;
      }
      
      private static function onUpdateBag(e:EventTaomee) : void
      {
         var userID:uint = uint(e.EventObj.UserID);
         if(userID == LocalUserInfo.getUserID())
         {
            updateBag();
         }
      }
      
      public static function updateBag() : void
      {
         if(Boolean(_bagView))
         {
            if(Boolean(_bagView.appModule))
            {
               _bagView.appModule["reloadBag"]();
            }
         }
      }
      
      private static function getEventDispathcer() : EventDispatcher
      {
         if(_eventDispatcher == null)
         {
            _eventDispatcher = new EventDispatcher();
         }
         return _eventDispatcher;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getEventDispathcer().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getEventDispathcer().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getEventDispathcer().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getEventDispathcer().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getEventDispathcer().willTrigger(type);
      }
   }
}

