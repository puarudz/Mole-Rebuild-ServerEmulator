package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.soundControl.soundControl;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.logic.socket.presentGoods.PresentGoodsReq;
   import com.logic.socket.presentGoods.PresentGoodsRes;
   import com.module.activityModule.Presented;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ActivityTmpDataManager;
   import com.mole.app.manager.SystemEventManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.creatShareObject;
   import com.view.mapView.housebase.HouseBase;
   import fl.transitions.easing.Bounce;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FlowerHouse extends HouseBase
   {
      
      private var gunzi:MovieClip;
      
      private var startPoint:Point;
      
      private var woniu:MovieClip;
      
      private var chongzi:MovieClip;
      
      private var huadeng:MovieClip;
      
      private var secretNum:int;
      
      private var currentNum:int;
      
      private var hua:MovieClip;
      
      private var cao:MovieClip;
      
      private var getBaiheNum:int;
      
      private var shuizhu:MovieClip;
      
      private var _npc_10084:MovieClip;
      
      private var canMove:Boolean = false;
      
      public function FlowerHouse()
      {
         super();
      }
      
      override protected function initView() : void
      {
         this._npc_10084 = controlLevel["npc_10084"];
         this._npc_10084.visible = false;
         this.gunzi = this.top_mc["gunzi"] as MovieClip;
         this.gunzi.buttonMode = true;
         this.gunzi.mouseChildren = false;
         this.startPoint = new Point(this.gunzi.x,this.gunzi.y);
         this.woniu = this.target_mc["woniu"] as MovieClip;
         BC.addEvent(this,this.woniu,MouseEvent.MOUSE_MOVE,this.woniuOver);
         BC.addEvent(this,this.woniu,"getSeed",this.onShowNpc10084);
         this.woniu.buttonMode = true;
         BC.addEvent(this,this.woniu,MouseEvent.CLICK,this.woniuClick);
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBaiheBack);
         finishSomethingReq.sendReq(330);
         this.chongzi = this.target_mc["chongzi"] as MovieClip;
         this.huadeng = this.target_mc["huadeng"] as MovieClip;
         BC.addEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
         var obj0:Object = {
            "btn":this.chongzi,
            "mc":this.chongzi.logic,
            "id":"swf150001",
            "fre":2,
            "hide":true
         };
         throwHitTest.HitTestMC(obj0);
         this.currentNum = -1;
         BC.addEvent(this,this.huadeng["light1"],MouseEvent.CLICK,this.lightClick);
         BC.addEvent(this,this.huadeng["light2"],MouseEvent.CLICK,this.lightClick);
         BC.addEvent(this,this.huadeng["light3"],MouseEvent.CLICK,this.lightClick);
         BC.addEvent(this,this.huadeng["light4"],MouseEvent.CLICK,this.lightClick);
         BC.addEvent(this,this.huadeng["light5"],MouseEvent.CLICK,this.lightClick);
         this.huadeng["light1"].buttonMode = this.huadeng["light2"].buttonMode = this.huadeng["light3"].buttonMode = this.huadeng["light4"].buttonMode = this.huadeng["light5"].buttonMode = true;
         this.hua = MovieClip(this.target_mc["hua"]);
         this.cao = MovieClip(this.target_mc["cao"]);
         BC.addEvent(this,this.cao,MouseEvent.CLICK,this.caoClick);
         this.initPanel();
         this.initGot();
         SystemEventManager.addEventListener("woniu_checkIsVip",this.onCheckVip);
         SystemEventManager.addEventListener("woniu_getSeed",this.onGetSeed);
         SystemEventManager.addEventListener("mysticFlower",this.mysticFlower);
      }
      
      private function mysticFlower(evt:Event) : void
      {
         ActivityTmpDataManager.getTransferItem(2);
      }
      
      private function onCheckVip(e:SystemEvent) : void
      {
         if(LocalUserInfo.isVIP())
         {
            mapSay(2);
         }
         else
         {
            mapSay(3);
         }
      }
      
      private function onShowNpc10084(e:Event) : void
      {
         this._npc_10084.visible = true;
      }
      
      private function initGot() : void
      {
         BC.addEvent(this,target_mc.itemID_mc1,MouseEvent.CLICK,this.gotMoGuHandler);
         BC.addEvent(this,target_mc.itemID_mc2,MouseEvent.CLICK,this.gotcai1_mcHandler);
         BC.addEvent(this,target_mc.itemID_mc3,MouseEvent.CLICK,this.gotcai2_mcHandler);
      }
      
      private function gotMoGuHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,1230022);
      }
      
      private function gotcai1_mcHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,1230046);
      }
      
      private function gotcai2_mcHandler(e:MouseEvent) : void
      {
         var targetMC:MovieClip = e.currentTarget as MovieClip;
         this.checkGetSkillItem(targetMC,1230045);
      }
      
      private function checkGetSkillItem(mc:MovieClip, item:int) : void
      {
         var p:PeopleManageView = GV.MAN_PEOPLE as PeopleManageView;
         if(p.hasLamu)
         {
            if(!p.lamu.checkCanGetItem(item))
            {
               return;
            }
            p.lamu.geocaching(mc,function(mc:MovieClip):*
            {
               return item;
            },function(E:*):*
            {
               Alert.getIconByID_Alart(item,"    恭喜你獲得" + GoodsInfo.getItemNameByID(item) + ",已經放入你的" + GoodsInfo.getItemCollectionBoxNameByID(item) + "中！");
               mc.gotoAndStop(2);
            },function(E:*):*
            {
               Alert.getIconByID_Alart(item,"    你今天已經拿了太多的" + GoodsInfo.getItemNameByID(item) + "，明天再來看看吧！");
            });
         }
         else
         {
            Alert.smileAlart("    你好像還沒有帶拉姆來哦!");
         }
      }
      
      private function caoClick(e:MouseEvent) : void
      {
         var mc:MovieClip = null;
         if(!LocalUserInfo.isVIP())
         {
            Alert.SLAlart("    鈴蘭花只有在超級拉姆的能力下才能健康成長，擁有超級拉姆馬上就能把漂亮鈴蘭花種子帶回家。");
            return;
         }
         if(this.cao.currentFrame == 3)
         {
            mc = MovieClip(this.cao.getChildAt(1));
            if(mc.currentFrame == mc.totalFrames)
            {
               BC.addEvent(this,GV.onlineSocket,PresentGoodsRes.PRESENT_GOODS_SUCC,this.getLinglan);
               BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_1116",this.getSeedError);
               PresentGoodsReq.req(81);
            }
         }
      }
      
      private function getSeedError(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,PresentGoodsRes.PRESENT_GOODS_SUCC);
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_1116");
      }
      
      private function getLinglan(e:EventTaomee) : void
      {
         var obj:Object = null;
         this.getSeedError();
         if(Boolean(e.EventObj.Flag))
         {
            obj = e.EventObj;
            Alert.getIconByID_Alart(1230030,"    恭喜你得到1顆鈴蘭花種子，已經放入你的家園倉庫中了！");
            creatShareObject.getInstance().setIsGetSeed(1);
         }
         else
         {
            Alert.getIconByID_Alart(1230030,"    今天已經拿過鈴蘭種子了，明天再來看看吧！");
         }
      }
      
      private function checkBaiheBack(e:EventTaomee) : void
      {
         this.getBaiheNum = e.EventObj.Done;
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkBaiheBack);
         BC.addEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkWoNiuBack);
         finishSomethingReq.sendReq(328);
      }
      
      private function lightClick(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         var id:int = int(mc.name.slice(-1));
         mc.gotoAndPlay(2);
         var sc:soundControl = new soundControl();
         sc.getSound(GV.Lib_Map.getClass("Sound" + id),0,1);
         if(this.hua.currentFrame == 2)
         {
            return;
         }
         if(this.currentNum == -1)
         {
            this.currentNum = id;
         }
         else
         {
            this.currentNum = this.currentNum * 10 + id;
         }
         if(String(this.currentNum).indexOf(String(this.secretNum)) != -1)
         {
            Presented.getInstance().celebrate1225(2023);
         }
         else if(this.currentNum > 100000)
         {
            this.currentNum %= 100000;
         }
         switch(id)
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
         }
      }
      
      private function getBaihe(e:EventTaomee) : void
      {
         if(Boolean(e.EventObj.Flag))
         {
            Alert.getIconByID_Alart(1230034,"    恭喜你得到1顆四色百合花種子，已經放入你的家園倉庫中了！");
            ++this.getBaiheNum;
            BC.removeEvent(this,this.hua,MouseEvent.CLICK,this.huaClick);
         }
         else
         {
            Alert.getIconByID_Alart(1230034,"    四色百合種子似乎已經拿光了，明天再來找找吧。");
         }
         this.getSeedError();
      }
      
      private function initPanel() : void
      {
         BC.removeEvent(this,this.hua,MouseEvent.CLICK,this.huaClick);
         this.top_mc.infoPanel.visible = false;
         this.chongzi.gotoAndStop(1);
         this.hua.gotoAndStop(1);
         var arr:Array = [51234,32145,52413,21453,12543,51423];
         this.secretNum = arr[int(Math.random() * 5)];
         top_mc.infoPanel.setNum(this.secretNum);
         this.currentNum = -1;
      }
      
      private function huaClick(e:MouseEvent) : void
      {
         if(this.getBaiheNum < 3)
         {
            BC.addEvent(this,GV.onlineSocket,PresentGoodsRes.PRESENT_GOODS_SUCC,this.getBaihe);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_1116",this.getSeedError);
            PresentGoodsReq.req(82);
         }
         else
         {
            Alert.smileAlart("    四色百合種子似乎已經拿光了，明天再來找找吧。");
         }
      }
      
      private function getHitTestInfo(evt:EventTaomee) : void
      {
         if(target_mc.getChildByName("huaban") != null)
         {
            return;
         }
         this.chongzi.gotoAndStop(this.chongzi.currentFrame + 1);
         if(this.chongzi.currentFrame == this.chongzi.totalFrames)
         {
            BC.removeEvent(this,GV.onlineSocket,throwHitTest.HITTEST_SUC_FIRE,this.getHitTestInfo);
         }
      }
      
      private function onGetSeed(e:*) : void
      {
         if(LocalUserInfo.isVIP())
         {
            BC.addEvent(this,GV.onlineSocket,PresentGoodsRes.PRESENT_GOODS_SUCC,this.getJuhua);
            BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_1116",this.getSeedError);
            PresentGoodsReq.req(80);
         }
      }
      
      private function getJuhua(e:EventTaomee) : void
      {
         this.getSeedError();
         BC.removeEvent(this,this.woniu,MouseEvent.CLICK,this.woniuClick);
         if(Boolean(e.EventObj.Flag))
         {
            Alert.getIconByID_Alart(1230027,"    恭喜你得到2顆神秘菊花種子，已經放入你的百寶箱中了！");
         }
         else
         {
            Alert.getIconByID_Alart(1230027,"    你今天已經拿過菊花種子了，明天再來看看吧！");
         }
      }
      
      private function checkWoNiuBack(e:*) : void
      {
         var flag:Boolean = false;
         if(Boolean(e as EventTaomee))
         {
            flag = e.EventObj.Done < 1;
         }
         else
         {
            flag = e;
         }
         BC.removeEvent(this,GV.onlineSocket,finishSomethingRes.FINISH_SOMETHING_SUCC,this.checkWoNiuBack);
         if(flag)
         {
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_OVER,this.gunziOver);
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_OUT,this.gunziOut);
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_DOWN,this.gunziClick);
         }
         else
         {
            this.gunzi.visible = false;
            this.woniu.visible = false;
         }
      }
      
      private function gunziOver(e:MouseEvent) : void
      {
         this.gunzi.gotoAndStop(2);
      }
      
      private function gunziOut(e:MouseEvent) : void
      {
         this.gunzi.gotoAndStop(1);
      }
      
      private function woniuClick(e:MouseEvent) : void
      {
         if(this.woniu.currentFrame == 1)
         {
            this.woniu.gotoAndStop(2);
         }
         else if(this.woniu.currentFrame == 4)
         {
         }
      }
      
      private function woniuOver(e:MouseEvent) : void
      {
         if(!this.canMove)
         {
            return;
         }
         BC.removeEvent(this,this.woniu,MouseEvent.CLICK,this.woniuClick);
         var mc:MovieClip = this.woniu.getChildAt(0) as MovieClip;
         if(this.woniu.currentFrame == 1)
         {
            this.woniu.gotoAndStop(3);
         }
         else if(this.woniu.currentFrame == 2)
         {
            this.woniu.gotoAndStop(3);
         }
         else if(this.woniu.currentFrame == 3)
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               this.woniu.gotoAndStop(4);
            }
         }
         else if(mc.currentFrame == 85 || mc.currentFrame == 205)
         {
            mc.gotoAndPlay(mc.currentFrame + 1);
         }
         else if(mc.currentFrame == 327)
         {
            BC.removeEvent(this,this.woniu,MouseEvent.MOUSE_OVER,this.woniuOver);
            BC.addEvent(this,this.woniu,MouseEvent.CLICK,this.woniuClick);
         }
      }
      
      private function gunziClick(e:MouseEvent) : void
      {
         this.gunzi.gotoAndStop(3);
         this.gunzi.startDrag(true);
         this.canMove = true;
         this.gunzi.mouseEnabled = false;
         BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_OVER,this.gunziOver);
         BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_OUT,this.gunziOut);
         BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_DOWN,this.gunziClick);
         BC.addEvent(this,this.gunzi.stage,MouseEvent.MOUSE_UP,this.stageUp);
      }
      
      private function stageUp(e:MouseEvent) : void
      {
         BC.removeEvent(this,this.gunzi.stage,MouseEvent.MOUSE_UP,this.stageUp);
         this.gunzi.stopDrag();
         this.canMove = false;
         this.gunzi.gotoAndStop(1);
         this.gunzi.mouseEnabled = true;
         var mc:MovieClip = this.woniu.getChildAt(0) as MovieClip;
         if(this.woniu.currentFrame != this.woniu.totalFrames || mc.currentFrame != mc.totalFrames)
         {
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_OVER,this.gunziOver);
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_OUT,this.gunziOut);
            BC.addEvent(this,this.gunzi,MouseEvent.MOUSE_DOWN,this.gunziClick);
            TweenLite.to(this.gunzi,0.5,{
               "x":this.startPoint.x,
               "y":this.startPoint.y,
               "ease":Bounce.easeInOut
            });
         }
         else
         {
            BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_OVER,this.gunziOver);
            BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_OUT,this.gunziOut);
            BC.removeEvent(this,this.gunzi,MouseEvent.MOUSE_DOWN,this.gunziClick);
            TweenLite.to(this.gunzi,0.5,{"autoAlpha":0});
            BC.removeEvent(this,this.woniu,MouseEvent.MOUSE_OVER,this.woniuOver);
            BC.addEvent(this,this.woniu,MouseEvent.CLICK,this.woniuClick);
         }
      }
      
      override public function destroy() : void
      {
         SystemEventManager.removeEventListener("woniu_checkIsVip",this.onCheckVip);
         SystemEventManager.removeEventListener("woniu_getSeed",this.onGetSeed);
         SystemEventManager.removeEventListener("mysticFlower",this.mysticFlower);
         super.destroy();
      }
   }
}

