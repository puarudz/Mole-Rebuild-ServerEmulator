package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.MCLoadEvent;
   import com.global.staticData.CommandID;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.thansGiveDayTask.ThanksDayTask;
   import com.module.tommyWork.nicWork;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class foodView extends MapBase
   {
      
      private var tipMC:MovieClip;
      
      private var bake_mc:MovieClip;
      
      private var eatMC:MovieClip;
      
      private var petFoodBook:MovieClip;
      
      private var _nicWork:nicWork;
      
      public function foodView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         buttonLevel.gameBtn_xxl.buttonMode = true;
         buttonLevel.gameBtn_xxl.addEventListener(MouseEvent.MOUSE_OVER,this.xxlRoomOverHandler);
         buttonLevel.gameBtn_xxl.addEventListener(MouseEvent.MOUSE_OUT,this.xxlRoomOutHandler);
         buttonLevel.door_1.buttonMode = true;
         buttonLevel.door_1.addEventListener(MouseEvent.MOUSE_OVER,this.btnDoorOverHandler);
         buttonLevel.door_1.addEventListener(MouseEvent.MOUSE_OUT,this.btnDoorOutHandler);
         controlLevel.food_btn.addEventListener(MouseEvent.MOUSE_OVER,this.foodOverHandler);
         controlLevel.food_btn.addEventListener(MouseEvent.MOUSE_OUT,this.foodOutHandler);
         GV.onlineSocket.addEventListener("fireAction_suc",this.bakeClickHandler);
         buttonLevel.petFoodBtn.addEventListener(MouseEvent.CLICK,this.petFoodLoadHandler);
         GV.onlineSocket.addEventListener(ThanksDayTask.FOOD,this.foodFull);
         controlLevel.nicClothBtn.addEventListener(MouseEvent.CLICK,this.workColthHandler);
         this._nicWork = new nicWork(controlLevel);
         SystemEventManager.addEventListener("nicWork",this.nicWorkEvent);
         SystemEventManager.addEventListener("nicLearn",this.nicLearnEvent);
         SystemEventManager.addEventListener("loveTestState17",this.loveTestState17Handler);
      }
      
      private function loveTestState17Handler(e:SystemEvent) : void
      {
         GV.onlineSocket.addCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         GF.sendSocket(CommandID.MOVIE_PLAY,322,0);
      }
      
      private function back12047(e:SocketEvent) : void
      {
         var data:ByteArray;
         var type:uint;
         var flag:uint;
         var status:uint;
         var tempArrayFront:Array = null;
         var resultFront:Array = null;
         var tempArrayBehind:Array = null;
         var resultBehind:Array = null;
         GV.onlineSocket.removeCmdListener(CommandID.MOVIE_PLAY,this.back12047);
         data = e.data as ByteArray;
         data.position = 0;
         type = data.readUnsignedInt();
         flag = data.readUnsignedInt();
         status = data.readUnsignedInt();
         if(status == 1)
         {
            ActivityTmpDataManager.loveTestFlag = 2;
         }
         if(ActivityTmpDataManager.loveTestFlag == 1)
         {
            tempArrayFront = ActivityTmpDataManager.loveTestArray.slice(0,5);
            resultFront = tempArrayFront.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 1 ? true : false;
            });
            tempArrayBehind = ActivityTmpDataManager.loveTestArray.slice(5);
            resultBehind = tempArrayBehind.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 0 ? true : false;
            });
            if(ActivityTmpDataManager.loveTestArray[5] == 1)
            {
               if(resultBehind.length < tempArrayBehind.length)
               {
                  Alert.smileAlart("尼克：我還有客人要招待，小摩爾不如去陽光草舍找尤尤聊聊。");
               }
               else if(resultBehind.length == tempArrayBehind.length)
               {
                  mapSay(101);
               }
            }
            else if(ActivityTmpDataManager.loveTestArray[5] == 0)
            {
               if(resultFront.length < tempArrayFront.length)
               {
                  Alert.smileAlart("先要通過其他人的愛心測試喲");
               }
               else if(resultFront.length == tempArrayFront.length)
               {
                  mapSay(101);
               }
            }
            else
            {
               Alert.angryAlart("伺服器數據錯誤。");
            }
         }
         else if(ActivityTmpDataManager.loveTestFlag == 2)
         {
            Alert.smileAlart("愛心測試已經完成了！");
         }
         else
         {
            ModuleManager.openPanel("LoveTestPanel");
         }
      }
      
      private function nicLearnEvent(e:Event) : void
      {
         this.nicHandler();
      }
      
      private function nicWorkEvent(evt:*) : void
      {
         this._nicWork.nicTask();
      }
      
      private function nicHandler() : void
      {
         new LoadGame("resource/movie/momo_mc_2.swf","正在打開面板......",MainManager.getAppLevel());
      }
      
      private function workColthHandler(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 12052;
         itemObj.price = 700;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function removeEatMCHandler(evt:MouseEvent = null) : void
      {
         this.eatMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.removeEatMCHandler);
         GC.clearAllChildren(this.eatMC);
         this.eatMC.parent.removeChild(this.eatMC);
         this.eatMC = null;
      }
      
      private function bakeClickHandler(evt:Event) : void
      {
         this.bake_mc = new MovieClip();
         MainManager.getTopLevel().addChild(this.bake_mc);
         var tempMC:MCLoader = new MCLoader("module/external/Bake.swf",this.bake_mc,Loading.TITLE_AND_PERCENT,"正在打開燒烤箱......");
         tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.bake_mcLoadOver);
         tempMC.doLoad();
      }
      
      private function bake_mcLoadOver(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
      }
      
      private function foodOverHandler(evt:MouseEvent) : void
      {
         depthLevel.box_mc.gotoAndStop(2);
      }
      
      private function foodOutHandler(evt:MouseEvent) : void
      {
         depthLevel.box_mc.gotoAndStop(1);
      }
      
      private function btnDoorOverHandler(evt:MouseEvent) : void
      {
         controlLevel.door_1.gotoAndStop(2);
      }
      
      private function btnDoorOutHandler(evt:MouseEvent) : void
      {
         controlLevel.door_1.gotoAndStop(1);
      }
      
      private function petFoodLoadHandler(evt:MouseEvent) : void
      {
         var tempMC:MCLoader = null;
         if(!MainManager.getAppLevel().getChildByName("petFoodBook"))
         {
            this.petFoodBook = new MovieClip();
            this.petFoodBook.name = "petFoodBook";
            MainManager.getAppLevel().addChild(this.petFoodBook);
            tempMC = new MCLoader("resource/pet/petFoodBook/petFoodBook.swf",this.petFoodBook,1,"正在打開拉姆食譜......");
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
            tempMC.doLoad();
         }
      }
      
      private function loadBookOverHandler(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         MCLoader(evt.target).removeEventListener(MCLoadEvent.ON_SUCCESS,this.loadBookOverHandler);
         MCLoader(evt.target).clear();
         GV.onlineSocket.addEventListener("removeGuideHandler",this.removeBookHandler);
      }
      
      private function removeBookHandler(evt:Event = null) : void
      {
         GV.onlineSocket.removeEventListener("removeGuideHandler",this.removeBookHandler);
         GC.stopAllMC(this.petFoodBook);
         GC.clearChildren(this.petFoodBook);
         this.petFoodBook.parent.removeChild(this.petFoodBook);
         this.petFoodBook = null;
      }
      
      private function xxlRoomOverHandler(evt:MouseEvent) : void
      {
         controlLevel.xxl_door.gotoAndPlay(2);
      }
      
      private function xxlRoomOutHandler(evt:MouseEvent) : void
      {
         controlLevel.xxl_door.gotoAndStop(1);
      }
      
      private function foodFull(event:Event) : void
      {
         GV.onlineSocket.removeEventListener(ThanksDayTask.FOOD,this.foodFull);
         controlLevel.foodBtn.buttonMode = false;
      }
      
      override public function destroy() : void
      {
         if(this.eatMC != null)
         {
            this.removeEatMCHandler();
         }
         if(this.petFoodBook != null)
         {
            this.removeBookHandler();
         }
         controlLevel.food_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.foodOutHandler);
         GV.onlineSocket.removeEventListener("fireAction_suc",this.bakeClickHandler);
         buttonLevel.gameBtn_xxl.removeEventListener(MouseEvent.MOUSE_OVER,this.xxlRoomOverHandler);
         buttonLevel.gameBtn_xxl.removeEventListener(MouseEvent.MOUSE_OUT,this.xxlRoomOutHandler);
         buttonLevel.door_1.removeEventListener(MouseEvent.MOUSE_OVER,this.btnDoorOverHandler);
         buttonLevel.door_1.removeEventListener(MouseEvent.MOUSE_OUT,this.btnDoorOutHandler);
         buttonLevel.petFoodBtn.removeEventListener(MouseEvent.CLICK,this.petFoodLoadHandler);
         GV.onlineSocket.removeEventListener(ThanksDayTask.FOOD,this.foodFull);
         controlLevel.nicClothBtn.removeEventListener(MouseEvent.CLICK,this.workColthHandler);
         SystemEventManager.removeEventListener("nicWork",this.nicWorkEvent);
         SystemEventManager.removeEventListener("nicLearn",this.nicLearnEvent);
         SystemEventManager.removeEventListener("loveTestState17",this.loveTestState17Handler);
         this._nicWork.destroy();
         super.destroy();
      }
   }
}

