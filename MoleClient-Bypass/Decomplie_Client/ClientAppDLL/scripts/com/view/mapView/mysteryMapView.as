package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.tip.npcTip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.exchange;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.module.activityModule.Presented;
   import com.module.loadExtentPanel.LoadGame;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.TaskManager;
   import com.view.mapView.activity.Task83.Anniversary;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.Timer;
   
   public class mysteryMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      private var isFirst:Boolean = false;
      
      private var npcTime:Timer;
      
      private var currentInt:int;
      
      private var currentArr:Array = [[576,183],[426,208],[276,208],[131,219],[104,431],[345,458],[496,455],[710,459]];
      
      private var goInt:int = 0;
      
      private var _evtObj:Object;
      
      private var _pigMC:MovieClip;
      
      private var _zhuPig:MovieClip;
      
      public function mysteryMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         GV.onlineSocket.addEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
         this.target_mc.MapBtn71.visible = false;
         this.npcTime = new Timer(4000,1);
         this.npcTime.addEventListener(TimerEvent.TIMER,this.clearTip);
         this.depth_mc.mouseEnabled = false;
         this.depth_mc.mouseChildren = false;
         var obj1:Object = {
            "btn":this.target_mc.hitBtn_1,
            "mc":this.botton_mc.black_mc.mc_2,
            "id":"swf150003",
            "fre":3,
            "hide":true
         };
         var obj2:Object = {
            "btn":this.target_mc.hitBtn_2,
            "mc":this.botton_mc.black_mc.mc_3,
            "id":"swf150003",
            "fre":3,
            "hide":true
         };
         var obj3:Object = {
            "btn":this.target_mc.hitBtn_1,
            "mc":this.botton_mc.black_mc.mc_2,
            "id":"swf150001",
            "fre":1,
            "hide":true
         };
         var obj4:Object = {
            "btn":this.target_mc.hitBtn_2,
            "mc":this.botton_mc.black_mc.mc_3,
            "id":"swf150001",
            "fre":1,
            "hide":true
         };
         throwHitTest.HitTestMC(obj1,obj2,obj3,obj4);
         for(var i:int = 0; i < 3; i++)
         {
            this.target_mc.activMC["mc_" + i].visible = false;
         }
         this.target_mc.doBtn.buttonMode = true;
         this.target_mc.doBtn.addEventListener(MouseEvent.CLICK,this.talkHandler);
         if(TaskManager.getTaskState(365) == 1)
         {
            this.botton_mc.black_mc.visible = false;
            BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
            finishSomethingReq.sendReq(31155);
            BC.addEvent(this,this.target_mc.open_btn,MouseEvent.CLICK,this.openHandler);
         }
         else
         {
            this.target_mc.open_btn.visible = false;
            this.botton_mc.black_mc.visible = true;
         }
      }
      
      private function openHandler(evt:MouseEvent) : void
      {
         var loadGame:LoadGame = new LoadGame("resource/movie/map40_type_mc.swf","請耐心等待......",MainManager.getAppLevel());
         loadGame = null;
      }
      
      private function getFinishNumHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.getFinishNumHandler);
         if(evt.EventObj.Done < 20 && evt.EventObj.Type == 31155)
         {
            this.smcEvent();
         }
      }
      
      private function smcEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FLOWER,this.getHitTestInfo);
         var obj0:Object = {
            "btn":this.depth_mc.hitMC,
            "mc":new MovieClip(),
            "id":"swf150002",
            "fre":1,
            "hide":true
         };
         var obj1:Object = {
            "btn":this.depth_mc.hitMC,
            "mc":new MovieClip(),
            "id":"swf150003",
            "fre":1,
            "hide":true
         };
         var obj2:Object = {
            "btn":this.depth_mc.hitMC,
            "mc":new MovieClip(),
            "id":"swf150013",
            "fre":1,
            "hide":true
         };
         throwHitTest.HitTestMC(obj0,obj1,obj2);
         for(var i:int = 0; i < 3; i++)
         {
            this.target_mc["getBtn" + i].visible = true;
            BC.addEvent(this,this.target_mc["getBtn" + i],MouseEvent.CLICK,this.getBtnHandler);
         }
         this.startGameEvent();
      }
      
      private function startGameEvent() : void
      {
         this.goInt = 0;
         ++this.currentInt;
         if(this.currentInt > 3)
         {
            this.currentInt == 1;
         }
         this._pigMC = this.depth_mc["big_mc" + this.currentInt];
         this._pigMC.gotoAndStop(1);
         this._pigMC.x = 743.9;
         this._pigMC.y = 200;
         this._zhuPig = this.botton_mc.z_mc;
         this._pigMC.visible = true;
         this._zhuPig.visible = true;
         this.pointEvent();
      }
      
      private function pointEvent() : void
      {
         this.depth_mc._typeBig.gotoAndStop(2);
         if(this.goInt < 4)
         {
            this.depth_mc._typeBig.x = this._pigMC.x - 150;
            this.depth_mc._typeBig.y = this._pigMC.y;
         }
         else if(this.goInt == 4)
         {
            this.depth_mc._typeBig.x = this._pigMC.x;
            this.depth_mc._typeBig.y = this._pigMC.y + 150;
         }
         else if(this.goInt < this.currentArr.length)
         {
            this.depth_mc._typeBig.x = this._pigMC.x + 150;
            this.depth_mc._typeBig.y = this._pigMC.y;
         }
      }
      
      private function getBtnHandler(evt:MouseEvent) : void
      {
         var a:int = int(String(evt.currentTarget.name.substr(-1)));
         if(evt.currentTarget.currentFrame == 1)
         {
            evt.currentTarget.gotoAndStop(2);
            Presented.getInstance().celebrate1225(int(660 + a),1);
         }
      }
      
      private function getHitTestInfo(evt:EventTaomee) : void
      {
         var p1:Point = null;
         var a:int = 0;
         this._evtObj = evt.EventObj.mc;
         if(this._evtObj.userID == LocalUserInfo.getUserID())
         {
            p1 = new Point(this._pigMC.x,this._pigMC.y);
            a = Point.distance(p1,this._evtObj.Point);
            if(a < 200 && this.goInt < this.currentArr.length)
            {
               if(this.detectEvent() == 0)
               {
                  return;
               }
               if(this.detectEvent() != 1)
               {
                  this.ovenEvent();
               }
               else if(this.goInt < 4 && this._evtObj.Point.x < this._pigMC.x || this.goInt == 4 && this._evtObj.Point.y > this._pigMC.y || this.goInt > 4 && this._evtObj.Point.x > this._pigMC.x)
               {
                  this.gotoEvent(this._evtObj.Point);
               }
            }
         }
      }
      
      private function ovenEvent() : void
      {
         if(this.goInt > 4)
         {
            this._pigMC.gotoAndStop(2);
            TweenLite.to(this._pigMC,1,{
               "x":469,
               "y":366,
               "onComplete":this.gameOvenHandler
            });
         }
         else
         {
            this._pigMC.gotoAndStop(2);
            TweenLite.to(this._pigMC,1,{
               "x":793,
               "y":158,
               "onComplete":this.gameOvenHandler
            });
         }
         if(Boolean(this._pigMC.h_mc))
         {
            this._pigMC.t_mc.visible = true;
            this._pigMC.t_mc.gotoAndPlay(2);
         }
      }
      
      private function gameOvenHandler() : void
      {
         TweenLite.to(this._pigMC,1,{"alpha":0});
         Alert.smileAlart("    小豬豬不喜歡你丟給他的東西，生氣跑了！");
         this.startGameEvent();
      }
      
      private function detectEvent() : int
      {
         var _b:int = 0;
         switch(this.currentInt)
         {
            case 1:
               if(this._evtObj.ThrowID == 150002)
               {
                  _b = 1;
               }
               else if(this._evtObj.ThrowID == 150003)
               {
                  _b = 2;
               }
               break;
            case 2:
               if(this._evtObj.ThrowID == 150013)
               {
                  _b = 1;
               }
               else if(this._evtObj.ThrowID == 150002)
               {
                  _b = 2;
               }
               break;
            case 3:
               if(this._evtObj.ThrowID == 150003)
               {
                  _b = 1;
               }
               else if(this._evtObj.ThrowID == 150013)
               {
                  _b = 2;
               }
         }
         return _b;
      }
      
      private function gotoEvent(_p:Point) : void
      {
         if(this.goInt > 4 && this._pigMC.currentFrame == 1)
         {
            this._pigMC.gotoAndStop(2);
         }
         TweenLite.to(this._pigMC,1,{
            "x":this.currentArr[this.goInt][0],
            "y":this.currentArr[this.goInt][1],
            "onComplete":this.tweenOverHandler
         });
         if(Boolean(this._pigMC.h_mc))
         {
            this._pigMC.h_mc.visible = true;
            this._pigMC.h_mc.gotoAndPlay(2);
         }
      }
      
      private function tweenOverHandler() : void
      {
         if(this.goInt == 4)
         {
            this._pigMC.gotoAndStop(2);
         }
         ++this.goInt;
         this.pointEvent();
         if(this.goInt >= this.currentArr.length)
         {
            BC.addEvent(this,GV.onlineSocket,"pig_Oven",this.getItemHandler);
            this._pigMC.visible = false;
            this._zhuPig.gotoAndStop(this.currentInt + 1);
            if(Boolean(this.depth_mc._typeBig))
            {
               this.depth_mc._typeBig.gotoAndStop(1);
            }
         }
      }
      
      private function getItemHandler(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"pig_Oven",this.getItemHandler);
         BC.addEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
         exchange.exchange_goods(663,1,0);
      }
      
      private function socksHandler(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,exchange.EXCHANGE_ITEM,this.socksHandler);
         if(evt.EventObj.Count == 0)
         {
            Alert.smileAlart("    你今天已經抓了很多小豬豬了，明天再來抓吧！");
         }
         else
         {
            Alert.smileAlart("    恭喜你抓到了一隻豬豬，當你獲得3隻豬豬後去找獵人M吧！",function(e:*):void
            {
               charkEvent();
            });
         }
      }
      
      private function charkEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),1351122,2);
      }
      
      private function getPayNumHandler(eve:EventTaomee) : void
      {
         var str:String = null;
         var goodsNum_arr:Array = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.getPayNumHandler);
         var obj:Object = eve.EventObj.obj;
         if(obj.Count >= 1 && obj.arr[0].Count >= 30)
         {
            Anniversary.getInstance().openSMCAlent(11);
            goodsNum_arr = TaskManager.getTask(365).taskInfo.goodsNum;
            if(goodsNum_arr == null)
            {
               goodsNum_arr = [0,0,0,0];
            }
            goodsNum_arr[1] = 1;
            TaskManager.getTask(365).taskInfo.goodsNum = goodsNum_arr;
         }
         else
         {
            this.startGameEvent();
         }
      }
      
      private function talkHandler(evt:MouseEvent) : void
      {
         var obj1:Object = null;
         if(TaskManager.getTaskState(365) == 1)
         {
            if(Boolean(this._pigMC))
            {
               if(this._pigMC.visible)
               {
                  return;
               }
            }
         }
         var msg:String = "";
         if(this.target_mc.zhizhuBtn.currentFrame != 1)
         {
            msg = "我吃的好飽~~你真是個好心的摩爾!";
            this.showTipHandler(msg);
            return;
         }
         msg = "咕咕~~肚子好餓，真想吃些美味的番茄啊！";
         this.showTipHandler(msg);
         if(!this.isFirst)
         {
            obj1 = {
               "btn":this.botton_mc.hitTest_mc,
               "mc":this.target_mc.zhizhuBtn,
               "id":"swf150002",
               "fre":2,
               "hide":true
            };
            throwHitTest.HitTestMC(obj1);
            this.isFirst = true;
         }
      }
      
      private function showTipHandler(msg:String) : void
      {
         this.npcTime.reset();
         this.npcTime.start();
         npcTip.showTip(this.botton_mc.npc_wordbox,msg);
      }
      
      private function clearTip(evt:TimerEvent) : void
      {
         npcTip.hideTip(this.botton_mc.npc_wordbox);
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         for(var k:int = 0; k < 3; k++)
         {
            this.target_mc.activMC["mc_" + k].visible = false;
         }
         var itemArray:Array = evt.EventObj.itemArray;
         for(var i:int = 0; i < itemArray.length; i++)
         {
            tempArray = itemArray[i].itemArray;
            itemID = int(itemArray[i].itemID);
            for(j = 0; j < tempArray.length; j++)
            {
               num = int(tempArray[j]);
               tempNum = tempArray.length - j - 1;
               if(num == 1)
               {
                  this.target_mc.activMC["mc_" + tempNum].visible = true;
                  this.target_mc.activMC["mc_" + tempNum].discreteness.changeBool = false;
               }
            }
         }
      }
      
      override public function destroy() : void
      {
         BC.removeEvent(this);
         this.npcTime.stop();
         this.npcTime.removeEventListener(TimerEvent.TIMER,this.clearTip);
         GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         throwHitTest.removeHitTest();
         super.destroy();
      }
   }
}

