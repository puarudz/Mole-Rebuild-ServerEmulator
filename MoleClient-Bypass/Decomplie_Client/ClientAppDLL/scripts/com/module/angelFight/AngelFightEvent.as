package com.module.angelFight
{
   import com.event.EventTaomee;
   import com.view.mapView.activity.Task83.TestAngelFight;
   
   public class AngelFightEvent
   {
      
      public static const Update_UserInfo_Ok:String = "Update_UserInfo_Ok";
      
      public static const Update_WishState_Ok:String = "Update_WishState_Ok";
      
      public static const Update_TaskState_Ok:String = "Update_TaskState_Ok";
      
      public static const Update_MasterInfo_Ok:String = "Update_MasterInfo_Ok";
      
      public static const Delete_Bag_Item:String = "Delete_Bag_Item";
      
      public static const Add_Bag_Item:String = "Add_Bag_Item";
      
      public static const Show_Friend_List:String = "Show_Friend_List";
      
      public static const Add_Collect_Item:String = "Add_Collect_Item";
      
      public static const Delete_Donate_Item:String = "Delete_Donate_Item";
      
      public static const Add_Donate_Item:String = "Add_Donate_Item";
      
      public static const End_Fight_Event:String = "End_Fight_Event";
      
      public function AngelFightEvent()
      {
         super();
      }
      
      public static function AddBagItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(Add_Bag_Item,obj));
      }
      
      public static function DeleteBagItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(Delete_Bag_Item,obj));
      }
      
      public static function AddDonateItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(Add_Donate_Item,obj));
      }
      
      public static function DeleteDonateItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(Delete_Donate_Item,obj));
      }
      
      public static function AddCollectItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         GV.onlineSocket.dispatchEvent(new EventTaomee(Add_Collect_Item,obj));
      }
      
      public static function AddDiscipleFight(discipleId:int, discipleName:String, color:int, masterId:int, masterName:String, masterColor:int) : void
      {
         var fight:Object = null;
         var str:String = null;
         var _temp_4:* = BC;
         var _temp_3:* = fight;
         var _temp_2:* = GV.onlineSocket;
         var _temp_1:* = End_Fight_Event;
         with({})
         {
            _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function handler(e:EventTaomee):void
            {
               /*
                * Decompilation error
                * Code may be obfuscated
                * Tip: You can try enabling "Deobfuscate code" option in Settings
                * Error type: IndexOutOfBoundsException (Index -1 out of bounds for length 0)
                */
               throw new flash.errors.IllegalOperationError("Not decompiled due to error");
            });
            if(masterId > 0)
            {
               var _temp_6:* = AngelFightAlert;
               var _temp_5:* = str;
               with({})
               {
                  
                  _temp_6.ConfirmAlert(_temp_5,function h():void
                  {
                     TestAngelFight.getInstance().onJoinGame(3,masterId,masterName,discipleId,masterColor);
                  });
               }
               else
               {
                  var _temp_8:* = AngelFightAlert;
                  var _temp_7:* = str;
                  with({})
                  {
                     
                     _temp_8.ConfirmAlert(_temp_7,function h():void
                     {
                        TestAngelFight.getInstance().onJoinGame(2,discipleId,discipleName,0,color);
                     });
                  }
               }
            }
         }
         
         