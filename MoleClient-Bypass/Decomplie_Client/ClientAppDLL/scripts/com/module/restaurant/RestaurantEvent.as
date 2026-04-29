package com.module.restaurant
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.oneBigStreetSocket.oneBigStreetSocket;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.npc.I_NPC;
   import com.module.npc.npcInstance.GhostNPC;
   import com.view.MapManageView.MapButtonView;
   import com.view.MapManageView.TailButtonView;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.setTimeout;
   
   public class RestaurantEvent
   {
      
      private static var instance:RestaurantEvent;
      
      private static var canotNew:Boolean = true;
      
      private var restaurantBeen:RestaurantBeen;
      
      private var goodsPath:String = "resource/restaurant/eventResource/goods/";
      
      private var loader:Loader;
      
      private var childNum:int;
      
      private var addGoodsMc:MovieClip;
      
      public var eventId:int;
      
      private var npcMc:I_NPC;
      
      private var tailBitton:TailButtonView;
      
      private var restaurantTool:RestaurantTool;
      
      public function RestaurantEvent()
      {
         super();
         if(canotNew)
         {
            throw new Error("RestaurantEvent不能直接new , 用靜態方法 getInstance()!");
         }
      }
      
      public static function getInstance() : RestaurantEvent
      {
         if(!instance)
         {
            canotNew = false;
            instance = new RestaurantEvent();
            canotNew = true;
         }
         return instance;
      }
      
      public function init() : void
      {
         this.restaurantTool = new RestaurantTool();
         this.childNum = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.showGood.numChildren;
         var showGoodIndex:int = Math.random() * this.childNum;
         this.addGoodsMc = RestaurantBeen.getInstance().getRestaurantMC().depth_mc.showGood.getChildAt(showGoodIndex);
         RestaurantBeen.getInstance().getRestaurantMC().control_mc.addChild(this.addGoodsMc);
         BC.addEvent(this,GV.onlineSocket,"Event_SelectOver",this.onEventSelectOver);
         BC.addEvent(this,GV.onlineSocket,"Activa_NPCEDT",this.onActivaNPCEDT);
         BC.addEvent(this,GV.onlineSocket,"read_1031",this.onQueryRestaurantEvent);
         oneBigStreetSocket.queryRestaurantEvent();
         mysticPeople.getInstance().init();
         if(RestaurantBeen.getInstance().isMyRestaurant())
         {
         }
      }
      
      private function onQueryRestaurantEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"read_1031",this.onQueryRestaurantEvent);
         this.eventId = evt.EventObj.eventId;
         this.restaurantBeen = RestaurantBeen.getInstance();
         if(this.eventId != 0 && RestaurantBeen.getInstance().isMyRestaurant() == false)
         {
            if(this.eventId < 100)
            {
               this.restaurantEventType1();
            }
         }
         else if(this.eventId != 0 && RestaurantBeen.getInstance().isMyRestaurant() == true)
         {
            if(this.eventId >= 100 && this.eventId < 200)
            {
               this.restaurantEventType2();
            }
            else if(this.eventId >= 200 && this.eventId < 300)
            {
               this.restaurantEventType1();
            }
         }
      }
      
      private function restaurantEventType1() : void
      {
         var path:String = this.goodsPath + this.eventId + ".swf";
         this.loader = new Loader();
         this.loader.unload();
         this.loader.load(new URLRequest(path));
         BC.addEvent(this,this.addGoodsMc,MouseEvent.CLICK,this.onAddGoodsMc);
         this.addGoodsMc.addChild(this.loader);
      }
      
      private function onAddGoodsMc(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.addGoodsMc,MouseEvent.CLICK,this.onAddGoodsMc);
         GC.clearChildren(this.addGoodsMc);
         var loadGame:LoadGame = new LoadGame("module/external/BeforeEventMain.swf","正在加載事件面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function restaurantEventType2() : void
      {
         var npcName:String = "";
         if(this.eventId == 100)
         {
            npcName = "mofashi";
         }
         this.addRelatedNPC(npcName);
      }
      
      private function addRelatedNPC(npcName:String) : void
      {
         this.npcMc = new GhostNPC(npcName);
         RestaurantBeen.getInstance().getRestaurantMC().depth_mc.addChild(this.npcMc);
         this.npcMc.hideButton();
         this.npcMc.Speed = 70;
         setTimeout(function():void
         {
            npcMc.autoMove = true;
            this["npcMc"] = null;
         },500);
         this.tailBitton = new TailButtonView();
         this.tailBitton.fineTail3Target(this.npcMc as DisplayObjectContainer);
         this.tailBitton.buttonMode = true;
         this.tailBitton.x = this.npcMc.x;
         this.tailBitton.y = this.npcMc.y;
         MapButtonView.getTarget().addChild(this.tailBitton);
         BC.addEvent(this,this.tailBitton,MouseEvent.CLICK,this.onNPC);
      }
      
      private function onNPC(evt:MouseEvent) : void
      {
         BC.removeEvent(this,this.tailBitton,MouseEvent.CLICK,this.onNPC);
         this.npcMc.clearClass();
         GC.clearAll(this.npcMc);
         this.npcMc = null;
         var loadGame:LoadGame = new LoadGame("module/external/BeforeEventMain.swf","正在加載事件面板",MainManager.getGameLevel());
         loadGame = null;
      }
      
      private function onEventSelectOver(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"Event_SelectOver",this.onEventSelectOver);
         if(evt.EventObj.eventId == 100 && evt.EventObj.solution == 1)
         {
            this.clearOutFood();
         }
      }
      
      private function clearOutFood() : void
      {
         var type:int = 0;
         var obj:Object = null;
         var foodArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseFoodInfo.foodArr;
         var isDelFood:int = this.checkHasDelFood();
         if(isDelFood != -1)
         {
            type = int(foodArr[isDelFood].foodLocation);
            this.restaurantBeen.getRestaurantMC().depth_mc["shuo" + type].visible = true;
            RestaurantMakeFoodTips.getInstance().removeBiaoTips(type);
            obj = new Object();
            obj.itemId = foodArr[isDelFood].itemId;
            obj.foodIndex = foodArr[isDelFood].foodIndex;
            obj.foodLocation = foodArr[isDelFood].foodLocation;
            obj.money = LocalUserInfo.getYXQ();
            GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1019,obj));
            this.clearOutFood();
         }
      }
      
      private function checkHasDelFood() : int
      {
         var ret:int = -1;
         var foodArr:Array = RestaurantBeen.getInstance().getRestaurantInfo().houseFoodInfo.foodArr;
         for(var i:int = 0; i < foodArr.length; i++)
         {
            if(foodArr[i].foodState == 5)
            {
               ret = i;
               break;
            }
         }
         return ret;
      }
      
      private function onActivaNPCEDT(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"Activa_NPCEDT",this.onActivaNPCEDT);
      }
   }
}

