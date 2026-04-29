package com.view.mapView
{
   import com.common.tip.npcTip;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.CollectRrandomItemLoginc.CollectRrandomItemRes;
   import com.logic.socket.randomItemLogic.randomItemReq;
   import com.logic.socket.randomItemLogic.randomItemRes;
   import com.logic.socket.task.TaskSetBufferProtocol;
   import com.module.clothBuyModule.clothBuyModule;
   import com.module.collectItem.CollectBreadItem;
   import com.module.superPetModule.petItemModule;
   import com.module.throwThing.throwHitTest;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.utils.PlayMovie;
   import com.view.mapView.activity.BackToYouthMapManager;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class waterMapView extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var botton_mc:MovieClip;
      
      public var waterLevel:MovieClip;
      
      public var showTipMC:MovieClip;
      
      private var frameNum:int = 0;
      
      private var itemArr:Array = [["swf150001","水彈"],["swf150002","番茄"],["swf150003","炮竹"]];
      
      private var npcTime:Timer;
      
      private var eidolonTime:Timer;
      
      private var RandomNum:int = 0;
      
      private var talk_num:int = 0;
      
      private var isFirst:Boolean = false;
      
      public function waterMapView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         BackToYouthMapManager.instence.initView(controlLevel["npc_mc"]);
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.botton_mc = GV.MC_mapFrame["buttonLevel"];
         this.waterLevel = GV.MC_mapFrame["waterLevel"];
         this.npcTime = new Timer(4000,1);
         this.npcTime.addEventListener(TimerEvent.TIMER,this.clearTip);
         this.eidolonTime = new Timer(4000,1);
         this.eidolonTime.addEventListener(TimerEvent.TIMER,this.clearEidolonTimeTip);
         this.RandomNum = Math.floor(Math.random() * 4);
         this.waterLevel.water_mc.visible = false;
         this.botton_mc.npc_wordbox.visible = false;
         this.botton_mc.eidolon_wordbox.visible = false;
         GV.onlineSocket.addEventListener("eidolon_talk",this.eidolonTalkHandler);
         GV.onlineSocket.addEventListener(CollectRrandomItemRes.GETITEM_ACINUS,this.getItemAcinus);
         this.target_mc.water_btn.buttonMode = true;
         this.target_mc.water_btn.addEventListener(MouseEvent.CLICK,this.waterClickHandler);
         this.target_mc.treeBtn.addEventListener(MouseEvent.CLICK,this.treeBuyHandler);
         this.target_mc.marbleBtn.addEventListener(MouseEvent.CLICK,this.marbleHandler);
         this.botton_mc.talk_btn.buttonMode = true;
         this.botton_mc.talk_btn.addEventListener(MouseEvent.CLICK,this.talkHandler);
         for(var i:int = 0; i < 5; i++)
         {
            this.target_mc.activMC["mc_" + i].visible = false;
         }
         GV.onlineSocket.addEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         randomItemReq.randomItemReqAction();
         this.target_mc.mmgBtn.addEventListener(MouseEvent.CLICK,this.tipShowHandler);
         this.target_mc.slBtn.addEventListener(MouseEvent.CLICK,this.getSLEvent);
         this.initSlEvent();
      }
      
      private function setTask548Step() : void
      {
         var task:Task = TaskManager.getTask(548);
         if(task.buffer.step == 7)
         {
            task.buffer.step = 8;
            task.buffer.panelId = 8;
            TaskSetBufferProtocol.send(548,task.buffer.bufferData);
         }
      }
      
      private function addTask() : void
      {
         var task:Task = TaskManager.getTask(548);
         if(task.buffer.step == 8)
         {
            GV.onlineSocket.addEventListener("Task382_TryOpenBook",this.onTryOpenBook);
         }
      }
      
      private function onTryOpenBook(e:Event) : void
      {
      }
      
      private function initSlEvent() : void
      {
         if(GV.MAN_PEOPLE.Petlevel == 101)
         {
            this.target_mc.slBtn.visible = true;
            petItemModule.setPetEffectHandler(null,2);
         }
      }
      
      private function getSLEvent(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 1220018;
         itemObj.price = 0;
         itemObj.info = "";
         clothBuyModule.buyAction(itemObj);
         petItemModule.setPetEffectHandler();
      }
      
      private function getItemAcinus(evt:Event) : void
      {
         CollectBreadItem.getInstance().jobID = 63;
         CollectBreadItem.getInstance().goodLen = 4;
         CollectBreadItem.getInstance().startItemID = 190192;
         CollectBreadItem.getInstance().endItemID = 190196;
         CollectBreadItem.getInstance().checkAllItem();
      }
      
      private function tipShowHandler(evt:MouseEvent) : void
      {
         var tempMC:Class = null;
         if(!MainManager.getAppLevel().getChildByName("showTipMC"))
         {
            tempMC = GV.Lib_Map.getClass("tipMC") as Class;
            this.showTipMC = new tempMC();
            MainManager.getAppLevel().addChild(this.showTipMC);
            this.showTipMC.name = "showTipMC";
            this.showTipMC.y = (MainManager.getStageHeight() - this.showTipMC.height) / 2;
            this.showTipMC.x = (MainManager.getStageWidth() - this.showTipMC.width) / 2;
            this.showTipMC.closeBtn.addEventListener(MouseEvent.CLICK,this.tipMCRemove);
            this.showTipMC.enterBtn.addEventListener(MouseEvent.CLICK,this.tipMCRemove);
            this.showTipMC.cancelBtn.addEventListener(MouseEvent.MOUSE_OVER,this.cancelHandler);
         }
      }
      
      private function cancelHandler(evt:MouseEvent) : void
      {
         var tempX:int = Math.floor(Math.random() * 850);
         var tempY:int = Math.floor(Math.random() * 400);
         var point:Point = new Point(tempX,tempY);
         point = this.showTipMC.globalToLocal(point);
         this.showTipMC.cancelBtn.x = point.x;
         this.showTipMC.cancelBtn.y = point.y;
      }
      
      private function tipMCRemove(evt:MouseEvent = null) : void
      {
         this.showTipMC.closeBtn.removeEventListener(MouseEvent.CLICK,this.tipMCRemove);
         this.showTipMC.enterBtn.removeEventListener(MouseEvent.CLICK,this.tipMCRemove);
         this.showTipMC.cancelBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.cancelHandler);
         GC.stopAllMC(this.showTipMC);
         GC.clearChildren(this.showTipMC);
         this.showTipMC.parent.removeChild(this.showTipMC);
         this.showTipMC = null;
      }
      
      private function marbleHandler(event:MouseEvent) : void
      {
         PlayMovie.play("resource/policeUI/marble.swf");
      }
      
      private function clearTip(evt:TimerEvent) : void
      {
         npcTip.hideTip(this.botton_mc.npc_wordbox);
      }
      
      private function clearEidolonTimeTip(evt:TimerEvent) : void
      {
         npcTip.hideTip(this.botton_mc.eidolon_wordbox);
      }
      
      private function eidolonTalkHandler(evt:Event) : void
      {
         ++this.talk_num;
         var msg:String = "";
         switch(this.talk_num)
         {
            case 1:
               msg = "你想過去?";
               break;
            case 2:
               msg = "這裡很危險的，水很深，不能過去啦!";
               break;
            case 3:
               msg = "你還是想過去？別白費力氣了";
               break;
            case 4:
               msg = "跟你說不能過去啦，你還堅持要去?";
               break;
            case 5:
               msg = "看你這麼執著的想過去，我也不為難你了，過去吧，祝你好運!";
               this.target_mc.mc_mask.x = -3000;
         }
         this.eidolonTime.reset();
         this.eidolonTime.start();
         npcTip.showTip(this.botton_mc.eidolon_wordbox,msg);
      }
      
      private function talkHandler(evt:MouseEvent) : void
      {
         var itemID:String = null;
         var obj1:Object = null;
         var obj2:Object = null;
         this.RandomNum = 0;
         var msg:String = "";
         if(this.depth_mc.tree_mc.currentFrame != 1)
         {
            msg = "哈哈,我吃飽了,你真是個可愛的小傢伙兒!";
            this.showTipHandler(msg);
            return;
         }
         throwHitTest.removeHitTest();
         if(this.RandomNum == 3)
         {
            msg = "咕嚕咕嚕,你想要黑色漿果才來找我的吧?真不巧,現在沒有果子了,下次再來吧!";
         }
         else
         {
            if(!this.isFirst)
            {
               msg = "嗨,小傢伙,你好!我是咕嚕咕嚕黑漿果樹.我現在肚子餓,好想吃" + this.itemArr[this.RandomNum][1];
               this.isFirst = true;
            }
            else
            {
               msg = "嘿，我還沒吃飽呢，沒有營養哪來的力氣生成漿果呀？我想吃" + this.itemArr[this.RandomNum][1];
            }
            itemID = this.itemArr[this.RandomNum][0];
            obj1 = {
               "btn":this.botton_mc.hitTest_mc_1,
               "mc":this.depth_mc.tree_mc,
               "id":itemID,
               "fre":2,
               "hide":true
            };
            obj2 = {
               "btn":this.botton_mc.hitTest_mc_2,
               "mc":this.depth_mc.tree_mc,
               "id":itemID,
               "fre":2,
               "hide":true
            };
            throwHitTest.HitTestMC(obj1,obj2);
         }
         this.showTipHandler(msg);
      }
      
      private function showTipHandler(msg:String) : void
      {
         this.npcTime.reset();
         this.npcTime.start();
         npcTip.showTip(this.botton_mc.npc_wordbox,msg);
      }
      
      private function activeHandler(evt:EventTaomee) : void
      {
         var tempArray:Array = null;
         var itemID:int = 0;
         var j:int = 0;
         var num:int = 0;
         var tempNum:int = 0;
         for(var k:int = 0; k < 5; k++)
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
      
      private function waterClickHandler(evt:MouseEvent) : void
      {
         this.target_mc.water_btn.x = -2000;
         this.target_mc.water_btn.removeEventListener(MouseEvent.CLICK,this.waterClickHandler);
         this.waterLevel.water_mc.visible = true;
         this.waterLevel.water_mc.gotoAndStop(2);
         this.waterLevel.water_mc.btn.addEventListener(MouseEvent.CLICK,this.waterGuessHandler);
      }
      
      private function treeBuyHandler(evt:MouseEvent) : void
      {
         GV.itemID = 3;
         var itemObj:Object = new Object();
         itemObj.id = 160142;
         itemObj.price = 0;
         itemObj.info = "酋長帽";
         clothBuyModule.buyAction(itemObj);
      }
      
      private function waterGuessHandler(evt:MouseEvent) : void
      {
         this.waterLevel.water_mc.nextFrame();
      }
      
      override public function destroy() : void
      {
         if(this.showTipMC != null)
         {
            this.tipMCRemove();
         }
         this.npcTime.stop();
         throwHitTest.removeHitTest();
         this.npcTime.removeEventListener(TimerEvent.TIMER,this.clearTip);
         this.npcTime = null;
         this.eidolonTime.stop();
         this.eidolonTime.removeEventListener(TimerEvent.TIMER,this.clearEidolonTimeTip);
         this.eidolonTime = null;
         this.target_mc.water_btn.removeEventListener(MouseEvent.CLICK,this.waterClickHandler);
         this.botton_mc.talk_btn.removeEventListener(MouseEvent.CLICK,this.talkHandler);
         GV.onlineSocket.removeEventListener(CollectRrandomItemRes.GETITEM_ACINUS,this.getItemAcinus);
         GV.onlineSocket.removeEventListener(randomItemRes.RANMOM_ITEM,this.activeHandler);
         GV.onlineSocket.removeEventListener("eidolon_talk",this.eidolonTalkHandler);
         this.target_mc = null;
         this.depth_mc = null;
         this.botton_mc = null;
         this.waterLevel = null;
         super.destroy();
      }
   }
}

