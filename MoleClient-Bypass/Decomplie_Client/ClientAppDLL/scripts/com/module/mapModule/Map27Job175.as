package com.module.mapModule
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   
   public class Map27Job175 extends Sprite
   {
      
      private var target_mc:MovieClip;
      
      private var JobID:uint = 175;
      
      private var Job_info:Object;
      
      private var goods_bln:Boolean;
      
      private var myTime:Timer;
      
      public function Map27Job175()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
      }
      
      public function Info() : void
      {
         this.target_mc = GV.MC_mapFrame["control_mc"];
         var task175State:uint = TaskManager.getTaskState(175);
         if(task175State >= 2)
         {
            this.target_mc.Job_175.gotoAndStop(4);
            BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.finishJobFun);
            return;
         }
         BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.fristJobInfo);
         JobExpandLogic.getJobExpand().getOneJob(this.JobID);
      }
      
      private function fristJobInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.fristJobInfo);
         this.Job_info = eve.EventObj.obj;
         var task175State:uint = TaskManager.getTaskState(175);
         if(task175State == 0)
         {
            this.target_mc.Job_175.gotoAndStop(1);
            BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.beginJobFun);
         }
         else if(task175State == 1)
         {
            if(this.Job_info.Count == 0)
            {
               this.target_mc.Job_175.gotoAndStop(1);
            }
            else
            {
               this.target_mc.Job_175.gotoAndStop(2);
            }
            BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.chartJobFun);
         }
         else if(task175State >= 2)
         {
            this.target_mc.Job_175.gotoAndStop(4);
            BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.finishJobFun);
         }
      }
      
      private function beginJobFun(eve:MouseEvent) : void
      {
         var myA:* = undefined;
         var url:String = "";
         var msg:String = "";
         if(!GV.JobLogics.havePetFollow())
         {
            msg = "看來，大衛又需要你的超級拉姆幫忙啦，趕快帶它過來吧！";
            this.showEAltUI(msg);
            return;
         }
         if(GV.MyInfo_PetObj.Level < 100)
         {
            msg = "看來，大衛又需要你的超級拉姆幫忙啦，趕快帶它過來吧！";
            this.showEAltUI(msg);
            return;
         }
         url = "resource/allJob/AlertPic/davidNPC/175_2.swf";
         msg = "    哎喲，這兩天忙著錘錘打打，胳膊都快抬不起來啦！rr    要是能早點做完，小摩爾就早點有自己的衣櫃啦！rr    咦，要不然，讓你的超級拉姆來做小木匠，跟我學手藝吧！";
         myA = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"npcgo,notgo",true,false,"SMCUI");
         BC.addEvent(this,myA,Alert.CLICK_ + "1",this.sandBeginJob);
      }
      
      private function sandBeginJob(eve:Event) : void
      {
         BC.removeEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.beginJobFun);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.changBtnEvent);
         GV.JobLogics.changJobList(this.JobID,1);
      }
      
      private function changBtnEvent(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.changBtnEvent);
         BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.chartJobFun);
         this.chartJobFun();
      }
      
      private function chartJobFun(eve:MouseEvent = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190391,2);
      }
      
      private function chartGoodsFun(eve:EventTaomee) : void
      {
         var loadGame:LoadGame = null;
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         this.goods_bln = false;
         if(eve.EventObj.obj.Count > 0)
         {
            if(eve.EventObj.obj.arr[0].itemCount > 4)
            {
               this.goods_bln = true;
            }
         }
         var url:String = "";
         var msg:String = "";
         if(!GV.JobLogics.havePetFollow())
         {
            msg = "看來，大衛又需要你的超級拉姆幫忙啦，趕快帶它過來吧！";
            this.showEAltUI(msg);
            return;
         }
         if(GV.MyInfo_PetObj.Level < 100)
         {
            msg = "看來，大衛又需要你的超級拉姆幫忙啦，趕快帶它過來吧！";
            this.showEAltUI(msg);
            return;
         }
         if(this.Job_info.Count == 0)
         {
            url = "module/external/MakeBureau.swf";
            msg = "正在加載衣櫃工匠台";
            BC.addEvent(this,GV.onlineSocket,"job175_gameevent",this.gameBackFun);
            loadGame = new LoadGame(Links.getUrl(url),msg,MainManager.getGameLevel());
            loadGame = null;
         }
         else if(this.goods_bln)
         {
            BC.removeEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.chartJobFun);
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
            TaskOverProtocol.send(this.JobID);
         }
         else
         {
            url = "resource/allJob/AlertPic/davidNPC/175_1.swf";
            msg = "    我可是魔法衣櫃，你以為用釘子把木頭釘在一起，就把我做好了嗎？rr    想不想看到更神奇的事情發生？那就先幫我到有七色花的地方摘5顆魔法星吧！它們會讓意外無限哦！";
            this.showNextAlt(url,msg);
         }
      }
      
      private function gameBackFun(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"job175_gameevent",this.gameBackFun);
         if(Boolean(eve.EventObj.bln))
         {
            this.Job_info.Count = 1;
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.twoJobInfo);
            JobExpandLogic.getJobExpand().setOneJob(this.JobID,this.Job_info);
         }
      }
      
      private function twoJobInfo(eve:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.twoJobInfo);
         this.target_mc.Job_175.gotoAndStop(2);
         this.chartJobFun();
      }
      
      private function showOverJobAlert(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         BC.addEvent(this,this.target_mc.Job_175,MouseEvent.CLICK,this.finishJobFun);
         this.target_mc.Job_175.gotoAndStop(3);
         this.myTime = GC.setGTimeout(this.tipsFun,5000);
      }
      
      private function tipsFun() : void
      {
         var url:String;
         var msg:String;
         var myA:*;
         GC.clearGTimeout(this.myTime);
         this.myTime = null;
         url = "resource/allJob/AlertPic/davidNPC/175_3.swf";
         msg = "    哇！好神奇的拉姆魔法星哦，它們的神奇能量，幫我變成了魔法的小衣櫃呢！趕快領取我放到你的小屋倉庫中吧！rr    嘻嘻，有了我的保護，你的漂亮衣服會變得更加漂亮哦！";
         var _temp_4:* = BC;
         var _temp_3:* = this;
         var _temp_2:* = myA;
         var _temp_1:* = Alert.CLICK_ + "1";
         with({})
         {
            _temp_4.addEvent(_temp_3,_temp_2,_temp_1,function showGetAlt(e:Event):void
            {
               Alert.showAlert(MainManager.getAppLevel(),"resource/goods/icon/160426.swf","    拉姆魔法小衣櫃已放入你的小屋倉庫中啦，趕快去看看吧！",Alert.CHANG_ALERT,"iknow",true,false,"EMP_BUY");
            });
         }
         
         private function finishJobFun(eve:MouseEvent) : void
         {
            var msg:String = "做好的衣櫃已經在你的家中了哦！";
            this.showEAltUI(msg);
         }
         
         private function showEAltUI(msg:String) : void
         {
            Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
         }
         
         private function showNextAlt(url:String, msg:String) : void
         {
            Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"iknow",true,false,"SMCUI");
         }
         
         public function removeAll(eve:* = null) : void
         {
            BC.removeEvent(this);
            if(Boolean(this.myTime))
            {
               GC.clearGTimeout(this.myTime);
               this.myTime = null;
            }
         }
      }
   }
   
   