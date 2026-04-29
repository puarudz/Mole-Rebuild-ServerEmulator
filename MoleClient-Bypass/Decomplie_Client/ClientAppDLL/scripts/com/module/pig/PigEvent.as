package com.module.pig
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class PigEvent extends EventDispatcher
   {
      
      private static var _instance:PigEvent;
      
      public static const Go_Bathe:String = "Go_Bathe";
      
      public static const Go_Eat_Food:String = "Go_Eat_Food";
      
      public static const Get_PigHouse_Data_OK:String = "Get_PigHouse_Data_OK";
      
      public static const Pig_Init_OK:String = "Pig_Init_OK";
      
      public static const Show_Toolbar:String = "Show_Toolbar";
      
      public static const Hide_Toolbar:String = "Hide_Toolbar";
      
      public static const Add_Bag_Item:String = "Add_Bag_Item";
      
      public static const Delete_Bag_Item:String = "Delete_Bag_Item";
      
      public static const Update_Pig_Count:String = "Update_Pig_Count";
      
      public static const Update_Exp:String = "Update_Exp";
      
      public static const Use_Card:String = "Use_Card";
      
      public static const Change_BG:String = "Change_BG";
      
      public static const Make_Goods_Over:String = "Make_Goods_Over";
      
      public static const Sell_Pig_Over:String = "Sell_Pig_Over";
      
      public static const Breed_Pig_Over:String = "Breed_Pig_Over";
      
      public static const Beauty_Match_Show:String = "Beauty_Match_Show";
      
      public static const Beauty_Match_PK:String = "Beauty_Match_PK";
      
      public static const Beauty_Time_Prop:String = "Beauty_Time_Prop";
      
      public static const Beauty_Match_Prop:String = "Beauty_Match_Prop";
      
      public static const Beauty_Change_Suc:String = "Beauty_Change_Suc";
      
      public static const Beauty_Has_Suc:String = "Beauty_Has_Suc";
      
      public static const Get_MachinistSquare_Data_OK:String = "Get_MachinistSquare_Data_OK";
      
      public static const Click_MachinePig:String = "Click_MachinePig";
      
      public static const Intensify_Pig:String = "Intensify_Pig";
      
      public static const Ronglu_Loader_Suc:String = "Ronglu_Loader_Suc";
      
      public static const Click_Ronglu:String = "Click_Ronglu";
      
      public static const Ready_To_Smelt:String = "Ready_To_Smelt";
      
      public static const Socket_Back_Smelt_Result:String = "Socket_Back_Smelt_Result";
      
      public static const JiChuang_Loader_Suc:String = "JiChuang_Loader_Suc";
      
      public static const Click_JiChuang:String = "Click_JiChuang";
      
      public static const Ready_To_Machine:String = "Ready_To_Machine";
      
      public static const Socket_Back_Machine_Result:String = "Socket_Back_Machine_Result";
      
      public static const Delete_Pig:String = "Delete_Pig";
      
      public static const Make_Assembly_Line_Suc:String = "Make_Assembly_Line_Suc";
      
      public static const Make_Special_Suc:String = "Make_Special_Suc";
      
      public static const HAS_WORK_MACHINE:String = "HAS_WORK_MACHINE";
      
      public static const WORK_MACHINE_OVER:String = "WORK_MACHINE_OVER";
      
      public static const Get_Pig_Info_Over:String = "Get_Pig_Info_Over";
      
      public function PigEvent()
      {
         super();
      }
      
      public static function get instance() : PigEvent
      {
         if(_instance == null)
         {
            _instance = new PigEvent();
         }
         return _instance;
      }
      
      public function AddBagItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         this.dispatchEvent(new EventTaomee(Add_Bag_Item,obj));
      }
      
      public function DeleteBagItem(itemId:int, itemCount:int = 1) : void
      {
         var obj:Object = {
            "id":itemId,
            "count":itemCount
         };
         this.dispatchEvent(new EventTaomee(Delete_Bag_Item,obj));
      }
   }
}

