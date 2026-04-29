package com.module.strangeMachineModule
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.StrangeMachineSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.mapView.activity.creatShareObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StrangeMachineAI
   {
      
      private var machine:MovieClip;
      
      private var readyFlag:Boolean;
      
      public function StrangeMachineAI(mc:MovieClip)
      {
         super();
         this.machine = mc;
         this.machine.buttonMode = true;
         this.readyFlag = creatShareObject.getInstance().getGuiGuiJi() == 1;
         BC.addEvent(this,this.machine,MouseEvent.CLICK,this.ClickHandler);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAllHandler);
         if(!this.readyFlag)
         {
            (this.machine.getChildAt(0) as MovieClip).gotoAndPlay(2);
         }
      }
      
      public static function isVipItem(ID:int) : Boolean
      {
         var itemArray:Array = [12205,12204,12206,12202,12201,12203,12247,12299,12300,160169,12336,160192,12398,12444,190137,190180,12563,12618,1220018];
         for(var i:int = 0; i < itemArray.length; i++)
         {
            if(ID == itemArray[i])
            {
               return true;
            }
         }
         return false;
      }
      
      private function taskHandler(e:EventTaomee) : void
      {
         var msg:String = null;
         var url:String = null;
         var SELF:StrangeMachineAI = null;
         var loadGame:LoadGame = null;
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.taskHandler);
         if(e.EventObj.Done > 9)
         {
            msg = "    呃~我的肚皮都要撐破了，今天再也吃不下東西啦！明天我再幫你吧！啊……啊……阿嚏，我得休息休息啦！";
            url = "resource/allJob/AlertPic/strangeMachine.swf";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         }
         else
         {
            SELF = this;
            url = "module/external/MachineCollectModule.swf";
            msg = "正在加載怪怪機";
            BC.addEvent(SELF,GV.onlineSocket,"Close_Guaiguai",this.CloseGuaiguaiji);
            loadGame = new LoadGame(url,msg,MainManager.getAppLevel());
            loadGame = null;
         }
      }
      
      private function CloseGuaiguaiji(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"Close_Guaiguai",this.CloseGuaiguaiji);
         var pid:uint = uint(e.EventObj);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1521,this.succeedHandler);
         StrangeMachineSocket.sellProp(pid);
      }
      
      private function succeedHandler(e:EventTaomee) : void
      {
         var pid:uint = 0;
         var SELF:StrangeMachineAI = null;
         pid = uint(e.EventObj);
         SELF = this;
         this.machine.gotoAndStop(3);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1521,this.succeedHandler);
         BC.addEvent(this,this.machine,"Make_Over",function(e:Event):void
         {
            var join:*;
            var url:String = null;
            var msg:String = "    恭喜你獲得了" + GoodsInfo.getItemNameByID(pid) + "," + getAddress(pid);
            if(pid >= 1230001 && pid <= 1239999)
            {
               url = GoodsInfo.getItemPathByID(pid) + "/icon/" + pid + ".swf";
            }
            else
            {
               url = GoodsInfo.getItemPathByID(pid) + "/" + pid + ".swf";
            }
            join = Alert.getIconByID_Alart(pid,msg);
            BC.removeEvent(SELF,machine,"Make_Over");
            BC.addEvent(SELF,join,"CLICK" + 1,function(e:Event):void
            {
               BC.removeEvent(SELF);
               BC.addEvent(SELF,machine,MouseEvent.CLICK,ClickHandler);
            });
         });
      }
      
      private function getAddress(itemID:int) : String
      {
         var sucString:String = "";
         if(itemID >= 17001 && itemID < 17999 || itemID >= 150001 && itemID < 159999)
         {
            sucString = "物品已放入你的投擲道具箱中!";
         }
         else if(itemID >= 160001 && itemID < 169999)
         {
            sucString = "物品已放入你的小屋倉庫中!";
         }
         else if(Boolean(XMLInfo.ClothHint[itemID]) || isVipItem(itemID))
         {
            sucString = "物品已放入你的百寶箱中!";
         }
         else if(itemID > 180000 && itemID < 190000)
         {
            sucString = "物品已放入拉姆的背包中";
         }
         else if(itemID > 1260000 && itemID < 1270000)
         {
            sucString = "物品已放入班級倉庫中!";
         }
         else if(itemID > 1270000 && itemID < 1280000)
         {
            sucString = "物品已放入牧場倉庫中!";
         }
         else if(itemID > 1220000 && itemID < 1230000 || itemID > 1230000 && itemID < 1240000)
         {
            sucString = "物品已經放入你的家園倉庫中!";
         }
         else
         {
            sucString = "物品已放入你的百寶箱中!";
         }
         if(itemID == 160144)
         {
            sucString = "保險箱已放入你的小屋倉庫中,趕快去小屋倉庫看看吧!記得及時設置安全資料哦!";
         }
         if(itemID == 1220040)
         {
            sucString = "物品已經放入你的家園倉庫中!";
         }
         return sucString;
      }
      
      private function ClickHandler(e:MouseEvent) : void
      {
         var msg:String = null;
         var url:String = null;
         var joinObj:* = undefined;
         var SELF:StrangeMachineAI = null;
         if(this.machine.currentFrame == 1)
         {
            if((this.machine.getChildAt(0) as MovieClip).currentFrame == 1)
            {
               finishSomethingReq.sendReq(153);
               BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.taskHandler);
            }
            else
            {
               msg = "    唉，這些調皮的小拉姆們，魔法還沒學好，就敢亂用，害得我受苦了！啊……啊……阿嚏，嗚嗚——鼻子裡好癢呀，啊……啊……阿嚏！要麼，你幫我塗一下藥水吧！";
               url = "resource/allJob/AlertPic/strangeMachine.swf";
               joinObj = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"npcgo,notgo",true,false,"SMCUI");
               SELF = this;
               BC.addEvent(this,joinObj,"CLICK" + 1,function(e:Event):void
               {
                  (machine.getChildAt(0) as MovieClip).gotoAndStop(1);
                  url = "module/external/StrangeMachine.swf";
                  msg = "正在加載怪怪機";
                  BC.removeEvent(SELF,joinObj,"CLICK" + 1);
                  BC.addEvent(SELF,GV.onlineSocket,"Close_Guaiguai",gameBackFun);
                  var loadGame:LoadGame = new LoadGame(url,msg,MainManager.getGameLevel());
                  loadGame = null;
               });
            }
         }
      }
      
      private function gameBackFun(e:EventTaomee) : void
      {
         var temp:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,"Close_Guaiguai",this.gameBackFun);
         if(Boolean(e.EventObj.bln))
         {
            creatShareObject.getInstance().setGuiGuiJi(1);
            this.readyFlag = true;
            this.machine.gotoAndStop(2);
         }
         else
         {
            (this.machine.getChildAt(0) as MovieClip).gotoAndPlay(2);
         }
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChild(temp);
            temp = null;
         }
      }
      
      private function removeAllHandler(e:*) : void
      {
         BC.removeEvent(this);
      }
   }
}

