package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.common.util.DisplayUtil;
   import com.common.util.MovieClipUtil;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.wheel.WheelCheckStateProtocol;
   import com.logic.socket.wheel.WheelSeizePointProtocol;
   import com.logic.socket.wheel.WheelStartTurnProtocol;
   import com.logic.task.SeaParkCtrl;
   import com.module.activityModule.Presented;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.GameSocketManager;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.OnlineManager;
   import com.mole.app.manager.PeopleManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.module.AppModuleControl;
   import com.mole.app.module.ModuleEvent;
   import com.mole.app.type.ModuleType;
   import com.mole.info.ItemInfo;
   import com.mole.net.events.SocketEvent;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class Map257View extends MapBase
   {
      
      private static var _yellowObj:Object;
      
      private static var _greenObj:Object;
      
      private static var _blueObj:Object;
      
      private static var _redObj:Object;
      
      private var _wheel_mc:MovieClip;
      
      private var _tarList:Array;
      
      private var _shark_mc:DisplayObject;
      
      private var _seatList:Array;
      
      public function Map257View()
      {
         super();
      }
      
      public static function get greenObj() : Object
      {
         return _greenObj;
      }
      
      public static function get blueObj() : Object
      {
         return _blueObj;
      }
      
      public static function get redObj() : Object
      {
         return _redObj;
      }
      
      public static function get yellowObj() : Object
      {
         return _yellowObj;
      }
      
      override protected function initView() : void
      {
         var i:uint;
         var tar_mc:MovieClip = null;
         this._wheel_mc = controlLevel["wheel_mc"];
         this._shark_mc = controlLevel["shark_mc"];
         tip.tipTailDisPlayObject(this._shark_mc,"鯊魚咬手");
         OnlineManager.addCmdListener(CommandID.WHEEL_CHECK_STATE,this.onWheelCheckState);
         OnlineManager.addCmdListener(CommandID.WHEEL_SEIZE_POINT,this.onWheelSeizePoint);
         OnlineManager.addCmdListener(CommandID.WHEEL_START_TURN,this.onWheelStartTurn);
         SystemEventManager.addEventListener("WheelSeizePoint",this.onPlaceholder);
         SystemEventManager.addEventListener("teaseShark",this.onTeaseShark);
         OnlineManager.send(CommandID.WHEEL_CHECK_STATE);
         this._tarList = new Array();
         for(i = 1; i <= 3; i++)
         {
            tar_mc = topLevel["tar" + i + "_mc"];
            tar_mc.mouseChildren = false;
            tar_mc.buttonMode = true;
            tar_mc.addEventListener(MouseEvent.CLICK,this.onGetAward1);
            this._tarList.push(tar_mc);
         }
         SeaParkCtrl.inst.initSpout();
         SeaParkCtrl.inst.initSurge();
         BC.addEvent(this,topLevel["card1_mc"],MouseEvent.CLICK,function(e:Event):void
         {
            ModuleManager.openPanel(ModuleType.HAPPY_SUMMER_PANEL);
         });
      }
      
      override public function init() : void
      {
         super.init();
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.hideMount();
      }
      
      private function onGetAward1(e:MouseEvent) : void
      {
         var clothObj:Object = null;
         var tar_mc:MovieClip = null;
         var mc:MovieClip = null;
         var peopleView:PeopleManageView = null;
         var angle:Number = NaN;
         var disX:Number = NaN;
         var disY:Number = NaN;
         var isUse:Boolean = false;
         var clothList:Array = LocalUserInfo.getClothItem();
         for each(clothObj in clothList)
         {
            if(clothObj.id == 14335)
            {
               isUse = true;
               break;
            }
         }
         if(isUse)
         {
            tar_mc = e.currentTarget as MovieClip;
            tar_mc.mouseChildren = false;
            tar_mc.mouseEnabled = false;
            mc = GV.Lib_Map.getMovieClip("RES_WaterBall") as MovieClip;
            peopleView = GV.MAN_PEOPLE;
            mc.x = peopleView.x;
            mc.y = peopleView.y - 30;
            angle = Math.atan2(tar_mc.y - mc.y,tar_mc.x - mc.x);
            disX = Math.cos(angle) * 90;
            disY = Math.sin(angle) * 90;
            mc.rotation = angle * 180 / Math.PI;
            topLevel.addChild(mc);
            TweenLite.to(mc,0.6,{
               "x":tar_mc.x - disX,
               "y":tar_mc.y - 50 - disY,
               "onComplete":function():void
               {
                  DisplayUtil.removeForParent(mc);
                  if(Math.random() > 0.7)
                  {
                     MovieClipUtil.playAppointFrameAndFunc(tar_mc,2,function():void
                     {
                        var win_mc:* = undefined;
                        win_mc = tar_mc["win_mc"];
                        MovieClipUtil.playEndAndFunc(win_mc,function():void
                        {
                           win_mc.stop();
                           Presented.getInstance().celebrate1225(1599,1,1,"","　　這個靶子的禮品今天已經全部發完了哦！明天再來吧！");
                        });
                     });
                  }
                  else
                  {
                     tar_mc.gotoAndStop(3);
                  }
               }
            });
         }
         else
         {
            Alert.smileAlart("　　請先裝備好水槍！");
         }
      }
      
      private function onOpenCard(e:MouseEvent) : void
      {
         ModuleManager.openPanel(ModuleType.PARADISE_POSTCARD_PANEL);
      }
      
      private function onTeaseShark(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckItem);
         finishSomethingReq.sendReq(50028);
      }
      
      private function onCheckItem(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.onCheckItem);
         if(evt.EventObj.Done < 20)
         {
            GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190954,2);
            OnlineManager.addCmdListener(CommandID.ITEMCOUNT,this.onCheckElsaItem);
         }
         else
         {
            Alert.smileAlart("　　今天次數太多了！");
         }
      }
      
      private function onCheckElsaItem(e:SocketEvent) : void
      {
         var itemPro:GetItemCountRes;
         var itemInfo:ItemInfo;
         var appCtl:AppModuleControl = null;
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckElsaItem);
         itemPro = e.bodyInfo;
         itemInfo = itemPro.itemHash.getValue(190954);
         if(itemInfo != null && itemInfo.count >= 2)
         {
            appCtl = ModuleManager.openPanel("SuggestiveSharksHelpPanel");
            appCtl.addEventListener(ModuleEvent.DESTROY,function(e:ModuleEvent):void
            {
               if(Boolean(e.data))
               {
                  GameSocketManager.enter(7,downTeaseShark);
               }
            });
         }
         else
         {
            Alert.smileAlart("　　遊戲幣不足！");
         }
      }
      
      private function downTeaseShark() : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         peopleView.moveTo(130,240);
      }
      
      private function onPlaceholder(e:SystemEvent) : void
      {
         Alert.smileAlart("　　乘坐八爪摩天輪，要消耗2枚遊戲代幣，是否繼續玩？",function(e:Event):void
         {
            OnlineManager.send(CommandID.WHEEL_SEIZE_POINT,0);
         },AlertType.SURE + "," + AlertType.CANCEL);
      }
      
      private function onWheelCheckState(e:SocketEvent) : void
      {
         var statePro:WheelCheckStateProtocol = e.bodyInfo;
         this.setSeat(statePro.seatList);
      }
      
      private function onWheelSeizePoint(e:SocketEvent) : void
      {
         var seizePro:WheelSeizePointProtocol = e.bodyInfo;
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(seizePro.op == 0)
         {
            if(seizePro.state == 1)
            {
               peopleView.visible = false;
               peopleView.addEventListener(PeopleManageView.ON_GO_START,this.onDownSeizePoint);
            }
            else if(seizePro.state == 2)
            {
               Alert.smileAlart("　　每次乘坐需要兩枚遊戲幣！");
            }
            else if(seizePro.state == 0)
            {
               peopleView.visible = true;
               Alert.smileAlart("　　人滿了！");
            }
         }
         else if(seizePro.op == 1)
         {
            if(seizePro.state == 1)
            {
               peopleView.visible = true;
            }
            else if(seizePro.state == 0)
            {
               peopleView.visible = false;
            }
         }
      }
      
      private function onDownSeizePoint(e:Event) : void
      {
         Alert.smileAlart("　　遊戲幣已經被扣了，真的不想玩了嗎？",function(e:Event):void
         {
            OnlineManager.send(CommandID.WHEEL_SEIZE_POINT,1);
            var peopleView:PeopleManageView = GV.MAN_PEOPLE;
            peopleView.removeEventListener(PeopleManageView.ON_GO_START,onDownSeizePoint);
         },AlertType.SURE + "," + AlertType.CANCEL);
      }
      
      private function onWheelStartTurn(e:SocketEvent) : void
      {
         var turnPro:WheelStartTurnProtocol = null;
         var posList:Array = null;
         var tmp_mc:DisplayObject = null;
         var i:uint = 0;
         var resName:String = null;
         turnPro = e.bodyInfo;
         if(Boolean(this._seatList))
         {
            posList = ["yellow_mc","green_mc","blue_mc","red_mc"];
            for(i = 0; i < this._wheel_mc.numChildren; i++)
            {
               tmp_mc = this._wheel_mc.getChildAt(i);
               DisplayUtil.stopAllMovieClip(tmp_mc as DisplayObjectContainer);
               tmp_mc.visible = false;
            }
            resName = posList[turnPro.point];
            tmp_mc = this._wheel_mc[resName];
            tmp_mc.visible = true;
            DisplayUtil.playAllMovieClip(tmp_mc as DisplayObjectContainer);
            MovieClipUtil.playEndAndFunc(MovieClip(tmp_mc),function():void
            {
               var peopleView:PeopleManageView;
               tmp_mc.visible = false;
               tmp_mc = _wheel_mc["normal_mc"];
               tmp_mc.visible = true;
               if(LocalUserInfo.getUserID() == turnPro.userID)
               {
                  Alert.smileAlart("　　恭喜你獲得" + turnPro.itemCount + "個" + GoodsInfo.getItemNameByID(turnPro.itemID) + "！");
               }
               else
               {
                  Alert.smileAlart("　　謝謝參與，下次再來！");
               }
               _wheel_mc.gotoAndStop(1);
               setTimeout(function():void
               {
                  setSeat([0,0,0,0]);
               },2000);
               peopleView = GV.MAN_PEOPLE;
               peopleView.removeEventListener(PeopleManageView.ON_GO_START,onDownSeizePoint);
            });
         }
      }
      
      private function setSeat(list:Array) : void
      {
         var tmp_mc:Sprite = null;
         var userID:uint = 0;
         var peopleView:PeopleManageView = null;
         var resNameList:Array = null;
         var res_mc:Sprite = null;
         var i:uint = 0;
         if(this._wheel_mc.currentFrame == 1)
         {
            tmp_mc = this._wheel_mc["normal_mc"];
            for each(userID in this._seatList)
            {
               if(list.indexOf(userID) == -1)
               {
                  peopleView = PeopleManager.getPeopleView(userID);
                  if(Boolean(peopleView))
                  {
                     peopleView.visible = true;
                  }
               }
            }
            this._seatList = list;
            if(this._seatList.indexOf(LocalUserInfo.getUserID()) == -1)
            {
               controlLevel.mouseChildren = true;
            }
            else
            {
               controlLevel.mouseChildren = false;
            }
            resNameList = ["yellow_mc","green_mc","blue_mc","red_mc"];
            for(i = 0; i < this._seatList.length; i++)
            {
               userID = uint(this._seatList[i]);
               res_mc = tmp_mc[resNameList[i]];
               if(Boolean(userID))
               {
                  peopleView = PeopleManager.getPeopleView(userID);
                  if(Boolean(peopleView))
                  {
                     peopleView.visible = false;
                  }
                  switch(i)
                  {
                     case 0:
                        _yellowObj = peopleView.colorObj;
                        break;
                     case 1:
                        _greenObj = peopleView.colorObj;
                        break;
                     case 2:
                        _blueObj = peopleView.colorObj;
                        break;
                     case 3:
                        _redObj = peopleView.colorObj;
                  }
                  if(Boolean(res_mc))
                  {
                     res_mc.visible = true;
                  }
               }
               else if(Boolean(res_mc))
               {
                  res_mc.visible = false;
               }
            }
         }
      }
      
      override public function destroy() : void
      {
         var tar_mc:DisplayObject = null;
         var peopleView:PeopleManageView = null;
         OnlineManager.removeCmdListener(CommandID.ITEMCOUNT,this.onCheckElsaItem);
         SeaParkCtrl.inst.destroy();
         for each(tar_mc in this._tarList)
         {
            tar_mc.removeEventListener(MouseEvent.CLICK,this.onGetAward1);
         }
         this._tarList = null;
         peopleView = GV.MAN_PEOPLE;
         peopleView.removeEventListener(PeopleManageView.ON_GO_START,this.onDownSeizePoint);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownSeizePoint);
         SystemEventManager.removeEventListener("WheelSeizePoint",this.onPlaceholder);
         SystemEventManager.removeEventListener("teaseShark",this.onTeaseShark);
         OnlineManager.removeCmdListener(CommandID.WHEEL_CHECK_STATE,this.onWheelCheckState);
         OnlineManager.removeCmdListener(CommandID.WHEEL_SEIZE_POINT,this.onWheelSeizePoint);
         OnlineManager.removeCmdListener(CommandID.WHEEL_START_TURN,this.onWheelStartTurn);
         super.destroy();
      }
   }
}

