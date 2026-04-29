package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.module.classModule.classManage;
   import com.module.helpPanel.HelpPanel;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.BagViewManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.utils.PlayMovie;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class UniversityRoomMapView extends BasicMapView
   {
      
      public var buyReq:BuyItemReq = new BuyItemReq();
      
      public function UniversityRoomMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BC.addEvent(this,target_mc.draw_btn,MouseEvent.CLICK,this.drawBtnHandler);
         BC.addEvent(this,target_mc.ordainBtn,MouseEvent.CLICK,this.tipEvent);
         BC.addEvent(this,target_mc.classListBtn,MouseEvent.CLICK,this.onClassListBtn);
         BC.addEvent(this,target_mc.getItemBtn,MouseEvent.CLICK,this.getItemEvent);
         BC.addEvent(this,target_mc.class_mc,"onHit",this.gotoClassHandle);
         SystemEventManager.addEventListener("silky_CreateClass",this.onCreateClass);
         SystemEventManager.addEventListener("loveTestState78",this.loveTestState78Handler);
         SystemEventManager.addEventListener("BeginPlayMovie",this.onPlayMovie);
         GV.onlineSocket.addEventListener("BeginPlayMovie",this.onPlayMovie);
         super.initView();
      }
      
      private function loveTestState78Handler(e:SystemEvent) : void
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
            tempArrayFront = ActivityTmpDataManager.loveTestArray.slice(0,2);
            resultFront = tempArrayFront.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 1 ? true : false;
            });
            tempArrayBehind = ActivityTmpDataManager.loveTestArray.slice(2);
            resultBehind = tempArrayBehind.filter(function(item:uint, index:int, array:Array):Boolean
            {
               return item == 0 ? true : false;
            });
            if(ActivityTmpDataManager.loveTestArray[2] == 1)
            {
               if(resultBehind.length < tempArrayBehind.length)
               {
                  Alert.smileAlart("絲爾特：快去和兔兔主編討教一下，她是一名熱衷於採訪的好記者。");
               }
               else if(resultBehind.length == tempArrayBehind.length)
               {
                  mapSay(101);
               }
            }
            else if(ActivityTmpDataManager.loveTestArray[2] == 0)
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
      
      private function onCreateClass(e:Event) : void
      {
         classManage.getInstance().createClass();
      }
      
      private function gotoClassHandle(evt:*) : void
      {
         var msg:String = null;
         if(BagViewManager.showClassID > 0)
         {
            GF.switchMap(BagViewManager.showClassID,false,1);
         }
         else
         {
            msg = "    你想進入哪個班級呢？戴上班級徽章吧！如果沒有班級徽章,就趕快創建或加入班級吧.";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function getItemEvent(evt:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,"read_" + 5014,this.ClassArray);
         classSocket.class_getMyClassList();
      }
      
      private function ClassArray(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 5014,this.ClassArray);
         var arr:Array = evt.EventObj.classList;
         var userID:int = LocalUserInfo.getUserID();
         if(arr.indexOf(userID) > -1)
         {
            BC.addEvent(this,GV.onlineSocket,"sameEvent",this.sameItemEvent);
            BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.itemEvents);
            this.buyReq.buyItems(1260067,1);
         }
         else
         {
            msg = "    非常抱歉，只有班長才能為班級領取班級榮譽榜哦。";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
         }
      }
      
      private function sameItemEvent(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"sameEvent",this.sameItemEvent);
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.itemEvents);
      }
      
      private function itemEvents(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.itemEvents);
         var msg:String = "    班級榮譽榜已放入你的班級倉庫中!";
         GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
      }
      
      private function onClassListBtn(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("module/external/ClassListMain.swf","正在班級列表",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function createClass(evt:MouseEvent) : void
      {
         classManage.getInstance().createClass();
      }
      
      private function tipEvent(evt:MouseEvent) : void
      {
         HelpPanel.getInstance().panelVisible("ordainTip");
      }
      
      private function drawBtnHandler(event:MouseEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getClothInfo);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),12620,2,12622);
      }
      
      private function getClothInfo(evt:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getClothInfo);
         if(evt.EventObj.obj.arr.length > 0)
         {
            msg = "你已經領過學生服了哦，趕緊穿上它進入你的班級吧！";
            GF.showAlert(GV.MC_AppLever,msg,"",100,"iknow",true,false,"E");
            return;
         }
         new LoadGame("module/external/ChoiceCloth.swf","正在加載選擇衣服鍵面",MainManager.getGameLevel());
      }
      
      private function onPlayMovie(e:Event) : void
      {
         trace("......");
         PlayMovie.play("resource/newTask/task526/movie/task_movie_526_3.swf",null,null,function():void
         {
         },null,null,false);
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("silky_CreateClass",this.onCreateClass);
         SystemEventManager.removeEventListener("PlayMovie",this.onPlayMovie);
         SystemEventManager.removeEventListener("loveTestState78",this.loveTestState78Handler);
         super.destroy();
      }
   }
}

