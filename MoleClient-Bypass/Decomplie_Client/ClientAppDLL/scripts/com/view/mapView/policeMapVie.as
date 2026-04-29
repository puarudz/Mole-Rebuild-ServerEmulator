package com.view.mapView
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import com.module.activityModule.Presented;
   import com.module.npc.dialog.TalkEvent;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.BufferManager;
   import com.mole.app.manager.QueryItemCntManager;
   import com.mole.app.manager.SystemEventManager;
   import com.mole.app.map.MapBase;
   import com.mole.app.task.Task;
   import com.mole.app.task.TaskManager;
   import com.mole.app.utils.GetItem;
   import com.mole.app.utils.PlayMovie;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class policeMapVie extends MapBase
   {
      
      public var target_mc:MovieClip;
      
      public var depth_mc:MovieClip;
      
      public var polic_mc:MovieClip;
      
      public var PoliceCard:MovieClip;
      
      private var childMC:*;
      
      private var loadObj:MCLoader;
      
      public var buttonLev:MovieClip;
      
      private var tempMC:MCLoader;
      
      private var AddP_MC:MovieClip;
      
      private var FireGameMC:MovieClip;
      
      private var _query:QueryItemCntManager;
      
      private var _lettercount:uint;
      
      private var _totemStep:uint;
      
      private var taskObj:Object;
      
      public function policeMapVie()
      {
         super();
      }
      
      private function getNPCJobObj(e:*) : void
      {
         GV.onlineSocket.removeEventListener("NPCwordMapChang_over",this.getNPCJobObj);
         BC.addEvent(this,TalkEvent,"aier_policeSmc",function(E:*):*
         {
            buttonLev.LL_npc.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         });
      }
      
      override protected function initView() : void
      {
         GV.onlineSocket.addEventListener("NPCwordMapChang_over",this.getNPCJobObj);
         this.target_mc = GV.MC_mapFrame["control_mc"];
         this.depth_mc = GV.MC_mapFrame["depth_mc"];
         this.buttonLev = GV.MC_mapFrame["buttonLevel"];
         this.target_mc.book_btn.addEventListener(MouseEvent.MOUSE_OVER,this.bookOverHandler);
         this.target_mc.book_btn.addEventListener(MouseEvent.MOUSE_OUT,this.bookOutHandler);
         this.target_mc.book_btn.addEventListener(MouseEvent.CLICK,this.paperShowHandler);
         this.target_mc.gun_btn.addEventListener(MouseEvent.MOUSE_OVER,this.gunOverHandler);
         this.target_mc.gun_btn.addEventListener(MouseEvent.MOUSE_OUT,this.gunOutHandler);
         this.target_mc.policGameBtn.addEventListener(MouseEvent.MOUSE_OVER,this.gameOverHandler);
         this.target_mc.policGameBtn.addEventListener(MouseEvent.MOUSE_OUT,this.gameOutHandler);
         this.target_mc.tableBtn.addEventListener(MouseEvent.CLICK,this.tableHandler);
         this.target_mc.passwordBtn.addEventListener(MouseEvent.CLICK,this.passwordHandler);
         this.buttonLev.LLBox.visible = false;
         GV.onlineSocket.addEventListener("NPCOldJob",this.onNPCOldJob);
         GV.onlineSocket.addEventListener("OVERNPCOldJob",this.overTaskTip);
         controlLevel.LLC_btn.addEventListener(MouseEvent.CLICK,this.overJob9);
         SystemEventManager.addEventListener("sayOver",this.onStartGame);
         SystemEventManager.addEventListener("talkPolice",this.policeOpenFun);
         this._query = new QueryItemCntManager();
         this._query.addEventListener(QueryItemCntManager.ONEITEM_QUERY,this.onOnetime);
         this._query.oneItemQuery(16026);
      }
      
      private function onOnetime(e:EventTaomee) : void
      {
         var count:uint = uint(e.EventObj);
         this._lettercount = count;
      }
      
      private function policeOpenFun(e:SystemEvent) : void
      {
         if(this._lettercount >= 1)
         {
            mapSay(5);
         }
         else
         {
            mapSay(7);
         }
      }
      
      private function onStartGame(e:SystemEvent) : void
      {
         Presented.getInstance().celebrate1225(3068);
      }
      
      private function totemStepHandle(e:EventTaomee) : void
      {
         BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.totemStepHandle);
         this._totemStep = uint(e.EventObj);
         if(this._totemStep == 0)
         {
            BufferManager.setBuffer(BufferManager.TOTEM_TASK_STEP,1);
         }
      }
      
      private function overJob9(e:MouseEvent) : void
      {
         this.taskObj = null;
         var id:uint = 9;
         var Tasks:Task = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         var msg:String = "";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/";
         if(State >= 2)
         {
            msg = "    感謝你辛勤的值勤，希望你能繼續為維護莊園安全作貢獻！";
            Alert.showAlert(MainManager.getAppLevel(),url + "001.swf",msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else if(State == 0)
         {
            msg = "    做為一名稱職的警官你有義務去維護莊園的安定和平，每個SMC警官都必須付出自己的努力，進行日常的站崗值勤！如果你想加入值勤可以直接點擊右上角的SMC徽章。";
            Alert.showAlert(MainManager.getAppLevel(),url + "001.swf",msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
         }
         else if(State == 1)
         {
            JobExpandLogic.getJobExpand().addEventListener(JobExpandLogic.ONEJOBINFO,this.getTaskEvent);
            JobExpandLogic.getJobExpand().getOneJob(9);
         }
      }
      
      private function getTaskEvent(evt:EventTaomee) : void
      {
         JobExpandLogic.getJobExpand().removeEventListener(JobExpandLogic.ONEJOBINFO,this.getTaskEvent);
         this.taskObj = evt.EventObj.obj;
         JobExpandLogic.getJobExpand().addEventListener(JobExpandLogic.NOWTIMES,this.getServerTime);
         JobExpandLogic.getJobExpand().getServerTime();
      }
      
      private function getServerTime(evt:EventTaomee) : void
      {
         JobExpandLogic.getJobExpand().removeEventListener(JobExpandLogic.NOWTIMES,this.getServerTime);
         var Tasks:Task = TaskManager.getTask(9);
         var msg:String = "";
         var url:String = "resource/allJob/AlertPic/PoliceDuty/";
         if(evt.EventObj.obj - this.taskObj.times >= 86400 * 7000)
         {
            msg = "    已經錯過交任務的時間了哦，你需要到smc中重新開始站崗任務，這次不要再過期了哦！";
            Alert.showAlert(MainManager.getAppLevel(),url + "001.swf",msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            return;
         }
         if(this.taskObj.Flag == 2)
         {
            msg = "    任務完成得非常棒，你真是一位出色的小警官！為了感謝你的辛勤勞動，1000摩爾豆已經放入你的百寶箱啦，快去看看吧！這週回家好好休息一下，下週可以繼續努力哦！";
            Alert.showAlert(MainManager.getAppLevel(),url + "001.swf",msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            Tasks.over();
            return;
         }
         if(this.taskObj.Flag < 2)
         {
            msg = "    做為一名稱職的警官你有義務去維護莊園的安定和平，每個SMC警官都必須付出自己的努力，趕快去站崗吧！";
            Alert.showAlert(MainManager.getAppLevel(),url + "001.swf",msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
            return;
         }
      }
      
      private function onNPCOldJob(e:Event) : void
      {
         var _t:MapBase = null;
         var Tasks:Task = null;
         var getItems:GetItem = null;
         var id:uint = 8;
         _t = this;
         Tasks = TaskManager.getTask(id);
         var State:uint = TaskManager.getTaskState(id);
         if(State == 1)
         {
            var _temp_4:* = BC;
            var _temp_3:* = _t;
            var _temp_2:* = getItems;
            var _temp_1:* = GetItem.BACKITEMNUM;
            with({})
            {
               
               _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function getItemNum(e:EventTaomee):void
               {
                  BC.removeEvent(_t,getItems,GetItem.BACKITEMNUM,getItemNum);
                  getItems.destroy();
                  getItems = null;
                  Tasks.taskInfo.goodsNum = e.EventObj.arr;
                  if(e.EventObj.arr.indexOf(0) == -1 && LocalUserInfo.getStrong() >= 20)
                  {
                     Tasks.over();
                     Tasks.checkEnterMap(100000003);
                  }
                  else
                  {
                     Tasks.checkEnterMap(100000002);
                  }
               });
               getItems.itemNum(Tasks.taskInfo.goods);
            }
            else if(State == 0)
            {
               Tasks.checkEnterMap(100000001);
            }
            else if(State == 2)
            {
               Tasks.checkEnterMap(100000004);
            }
         }
         
         public function overTaskTip(evt:Event) : void
         {
            var url:String = GoodsInfo.getItemPathByID(12057) + "12057.swf";
            var msg:String = "    恭喜你獲得警官三件套！快穿齊它吧！";
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         
         private function tableHandler(event:MouseEvent) : void
         {
            PlayMovie.play("resource/policeUI/passwordTable.swf",null,null,null,null,null,true,"正在打開密碼表");
         }
         
         private function passwordHandler(event:MouseEvent) : void
         {
            PlayMovie.play("resource/policeUI/passwordSign.swf",null,null,null,null,null,true,"正在打開密碼符號表");
         }
         
         private function removePoliceCar(evt:MouseEvent = null) : void
         {
            this.PoliceCard.closeBtn.removeEventListener(MouseEvent.CLICK,this.removePoliceCar);
            GC.stopAllMC(this.PoliceCard);
            GC.clearChildren(this.PoliceCard);
            GV.MC_AppLever.removeChild(this.PoliceCard);
            this.PoliceCard = null;
         }
         
         private function policClickHandler(evt:MouseEvent) : void
         {
            var myAle:* = undefined;
            this.removePoliceCar();
            if(!GV.MC_AppLever.getChildByName("changAlert_sandUIMC"))
            {
               myAle = Alert.showAlert(GV.MC_AppLever,"郵箱","",Alert.CHANG_ALERT,"sandmsg",true,true,"sandUI","400,300");
               myAle.addEventListener(Alert.CLICK_ + "1",this.next);
            }
         }
         
         private function next(e:*) : void
         {
            var myAle:* = undefined;
            var info:String = null;
            e.target.removeEventListener(Alert.CLICK_ + "1",this.next);
            var pp:sandMsgReq = new sandMsgReq();
            var sandType:int = 1014;
            var msg:* = Alert.back_msg;
            var tit:* = Alert.back_tit;
            if(msg != "" && tit != "")
            {
               pp.sandFun(sandType,tit,msg);
               GV.onlineSocket.addEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
            }
            else
            {
               info = "一定要填寫標題和內容才可以哦~";
               myAle = Alert.showAlert(GV.MC_AppLever,info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
            }
         }
         
         private function showsandTit(e:*) : void
         {
            var myAle:* = undefined;
            GV.onlineSocket.removeEventListener(sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
            var info:String = "太好了！投稿成功\r摩爾莊園管理處感謝您的參與";
            myAle = Alert.showAlert(GV.MC_AppLever,info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         }
         
         private function gunOverHandler(evt:MouseEvent) : void
         {
            this.target_mc.gun_mc.gotoAndPlay(2);
         }
         
         private function gunOutHandler(evt:MouseEvent) : void
         {
            this.target_mc.gun_mc.gotoAndStop(1);
         }
         
         private function gameOverHandler(evt:MouseEvent) : void
         {
            this.target_mc.policGameMC.gotoAndPlay(2);
         }
         
         private function gameOutHandler(evt:MouseEvent) : void
         {
            this.target_mc.policGameMC.gotoAndStop(1);
         }
         
         private function bookOverHandler(evt:MouseEvent) : void
         {
            this.depth_mc.desk_mc.book_mc.gotoAndPlay(2);
         }
         
         private function bookOutHandler(evt:MouseEvent) : void
         {
            this.depth_mc.desk_mc.book_mc.gotoAndStop(1);
         }
         
         private function paperShowHandler(evt:MouseEvent) : void
         {
            var url:String = null;
            if(!GV.MC_AppLever.getChildByName("polic_mc"))
            {
               this.polic_mc = new MovieClip();
               this.polic_mc.name = "polic_mc";
               GV.MC_AppLever.addChild(this.polic_mc);
               url = "module/external/BooksUI/policeBook.swf";
               this.loadObj = new MCLoader(url,this.polic_mc,1,"正在打開警官手冊......");
               this.loadObj.addEventListener(MCLoadEvent.ON_SUCCESS,this.policBookLoadOver);
               this.loadObj.doLoad();
            }
         }
         
         private function policBookLoadOver(evt:MCLoadEvent) : void
         {
            var mainMC:DisplayObjectContainer = evt.getParent();
            this.childMC = evt.getLoader();
            mainMC.addChild(this.childMC);
            GV.onlineSocket.addEventListener("removeGuideHandler",this.removeBookHandler);
            this.loadObj.removeEventListener(MCLoadEvent.ON_SUCCESS,this.policBookLoadOver);
            this.loadObj.clear();
         }
         
         private function removeBookHandler(evt:Event = null) : void
         {
            var main:MovieClip = this.childMC.content.root["main"];
            GC.clearAllChildren(main);
            this.polic_mc.parent.removeChild(this.polic_mc);
            this.polic_mc = null;
            GV.onlineSocket.removeEventListener("removeGuideHandler",this.removeBookHandler);
         }
         
         override public function destroy() : void
         {
            SystemEventManager.removeEventListener("sayOver",this.onStartGame);
            SystemEventManager.removeEventListener("talkPolice",this.policeOpenFun);
            if(this.polic_mc != null)
            {
               this.removeBookHandler();
            }
            if(this.PoliceCard != null)
            {
               this.removePoliceCar();
            }
            this.target_mc.book_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.bookOverHandler);
            this.target_mc.book_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.bookOutHandler);
            this.target_mc.book_btn.removeEventListener(MouseEvent.CLICK,this.paperShowHandler);
            this.target_mc.gun_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.gunOverHandler);
            this.target_mc.gun_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.gunOutHandler);
            this.target_mc.tableBtn.removeEventListener(MouseEvent.CLICK,this.tableHandler);
            this.target_mc.passwordBtn.removeEventListener(MouseEvent.CLICK,this.passwordHandler);
            this.depth_mc = null;
            this.depth_mc = null;
            BC.removeEvent(this);
            GV.onlineSocket.removeEventListener("NPCOldJob",this.onNPCOldJob);
            GV.onlineSocket.removeEventListener("OVERNPCOldJob",this.overTaskTip);
            this._query.removeEventListener(QueryItemCntManager.ONEITEM_QUERY,this.onOnetime);
            BufferManager.removeBufferEvent(BufferManager.TOTEM_TASK_STEP,this.totemStepHandle);
            super.destroy();
         }
      }
   }
   
   