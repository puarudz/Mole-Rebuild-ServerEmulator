package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.loading.Loading;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.shopItem.BuyItemRes;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class Job161MapView extends Sprite
   {
      
      private var Flag:uint = 0;
      
      private var buyItems:BuyItemReq;
      
      private var buy_ID:uint;
      
      private var Job_arr:Array = [190353,190354];
      
      private var MCLoaders:MCLoader;
      
      public function Job161MapView()
      {
         super();
      }
      
      public function JobFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAllFun);
         this.Flag = 0;
         this.chartFunA();
      }
      
      private function chartFunA() : void
      {
         var MC:MovieClip = null;
         if(!MainManager.getGameLevel().getChildByName("doctor_test"))
         {
            MC = new MovieClip();
            MC.name = "doctor_test";
            MainManager.getGameLevel().addChild(MC);
            this.MCLoaders = new MCLoader("module/external/JobUI/DoctorTest.swf",MC,Loading.TITLE_AND_PERCENT,"正在進入配置藥水考核");
            BC.addEvent(this,this.MCLoaders,MCLoadEvent.ON_SUCCESS,this.loadOverFun);
            this.MCLoaders.doLoad();
         }
      }
      
      private function loadOverFun(evt:MCLoadEvent) : void
      {
         BC.removeEvent(this,this.MCLoaders,MCLoadEvent.ON_SUCCESS,this.loadOverFun);
         BC.addEvent(this,GV.onlineSocket,"doctor_test_1",this.removeBFun);
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:Loader = evt.getLoader();
         mainMC.addChild(childMC);
         this.MCLoaders.clear();
      }
      
      private function removeBFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"doctor_test_1",this.removeBFun);
         var Bln:Boolean = Boolean(eve.EventObj.flag);
         var task161:Task = TaskManager.getTask(161);
         if(Bln && task161.state == 1 && task161.buffer.step == 0)
         {
            task161.setStepAndPanel(1);
            this.Flag = this.Flag > 1 ? 0 : this.Flag;
            this.buy_ID = this.Job_arr[this.Flag];
            this.buyItems = new BuyItemReq();
            this.GetItem();
         }
         var temp:* = MainManager.getGameLevel().getChildByName("doctor_test");
         MainManager.getGameLevel().removeChild(temp);
         temp = null;
      }
      
      private function GetItem() : void
      {
         BC.addEvent(this,GV.onlineSocket,BuyItemRes.BUY_ITEM_SUCCESS,this.getItemFun);
         this.buyItems.buyItems(this.buy_ID,1);
      }
      
      private function getItemFun(eve:EventTaomee) : void
      {
         var url:String = null;
         var msg:String = null;
         var names:String = null;
         if(GF.getItemName(this.buy_ID).@Name == null)
         {
            url = String(GF.getItemName(this.buy_ID).@typeObject.path) + this.buy_ID + ".swf";
            names = String(GF.getItemName(this.buy_ID).@Name);
         }
         else
         {
            url = String(GoodsInfo.getInfoById(this.buy_ID).typeObject.path) + this.buy_ID + ".swf";
            names = GoodsInfo.getItemNameByID(this.buy_ID);
         }
         msg = "　　" + names + "已經放入你的百寶箱中。";
         Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function removeAllFun(eve:* = null) : void
      {
         var temp:* = undefined;
         BC.removeEvent(this);
         if(Boolean(MainManager.getGameLevel().getChildByName("doctor_test")))
         {
            temp = MainManager.getGameLevel().getChildByName("doctor_test");
            MainManager.getGameLevel().removeChild(temp);
            temp = null;
         }
      }
   }
}

