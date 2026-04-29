package com.view.JobView
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.smc.PickItem.PickItemReq;
   import com.logic.socket.smc.PickItem.PickItemRes;
   import com.mole.app.task.TaskManager;
   import flash.display.Sprite;
   import org.taomee.bean.BaseBean;
   
   public class JobView extends BaseBean
   {
      
      public static var JobID:int;
      
      public var ID:int = 0;
      
      public var msg:String;
      
      public var tip_info:String;
      
      public var finishID:int;
      
      public var finishNames:String;
      
      public var myObj:Object;
      
      public var RandomJobGoodsID:uint;
      
      public var RandomJobOkStr:String;
      
      public var NewExplainFlag:uint = 0;
      
      public var getOneGoodsJobID:uint = 24;
      
      private var newUserJobStr:String;
      
      private var _nowGet:Boolean;
      
      public function JobView()
      {
         super();
      }
      
      override public function start() : void
      {
         finish();
      }
      
      public function finishJob(JobID:int, picID:int, nowGet:Boolean = false) : void
      {
         this.ID = JobID;
         this.finishID = picID;
         this._nowGet = nowGet;
         GV.onlineSocket.addEventListener(GetItemCountRes.GET_ITEMCOUNT,this.chartFinish);
         GetItemCountReq.getItemCount(GV.MyInfo_userID,this.finishID,0);
      }
      
      public function chartFinish(e:EventTaomee = null) : void
      {
         var count:int = 0;
         GV.onlineSocket.removeEventListener(GetItemCountRes.GET_ITEMCOUNT,this.chartFinish);
         var myBoolean:Boolean = false;
         var taskState:uint = TaskManager.getTaskState(this.ID);
         if(taskState == 1)
         {
            count = int(e.EventObj.obj.Count);
            if(count == 0)
            {
               myBoolean = true;
            }
         }
         if(myBoolean)
         {
            switch(this.finishID)
            {
               case 190039:
                  this.msg = "get_Paper";
                  this.tip_info = "你已經得到了方格稿紙。";
                  this.finishNames = "方格稿紙";
                  break;
               case 190040:
                  this.msg = "get_Camera";
                  this.tip_info = "恭喜，你已經學會了拍照！";
                  this.finishNames = "照相機";
                  break;
               case 190041:
                  this.msg = "get_ReporterBook";
                  this.tip_info = "你已經得到了記者手冊。";
                  this.finishNames = "記者手冊";
            }
            GV.onlineSocket.removeEventListener(this.msg,this.otherJobOKFun);
            if(this._nowGet)
            {
               this.otherJobOKFun(null);
            }
            else
            {
               GV.onlineSocket.addEventListener(this.msg,this.otherJobOKFun);
            }
         }
      }
      
      public function del(ss:*) : void
      {
         GV.onlineSocket.removeEventListener(ss,this.otherJobOKFun);
      }
      
      public function otherJobOKFun(eve:*) : void
      {
         var myAle:* = undefined;
         GV.onlineSocket.removeEventListener(this.msg,this.otherJobOKFun);
         PickItemReq.pickItem(this.finishID);
         var tit:String = "resource/allJob/icon/" + this.finishID + ".swf";
         var info:String = "　　" + this.tip_info;
         myAle = Alert.showAlert(MainManager.getAppLevel(),tit,info,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function showJob(id:int) : void
      {
         var resID:uint = DownLoadManager.add("module/external/JobUI/JobUI" + id + ".swf",ResType.DISPLAY_OBJECT,true,"正在打開任務面板");
         DownLoadManager.addEvent(resID,function(e:DownLoadEvent):void
         {
            var mc:Sprite = new Sprite();
            mc.name = "otherJobMC";
            mc.addChild(e.data);
            LevelManager.appLevel.addChild(mc);
         });
      }
      
      public function finishRandomJob(num:uint, okstr:String, nostr:String, JobGoodsID:uint) : Boolean
      {
         var url:String = null;
         var str:String = null;
         var result:Boolean = false;
         result = this.chartRandom(num);
         if(result)
         {
            GV.onlineSocket.addEventListener(PickItemRes.PICK_ITEM,this.showAlertFun);
            PickItemReq.pickItem(JobGoodsID);
            this.RandomJobGoodsID = JobGoodsID;
            this.RandomJobOkStr = okstr;
         }
         else
         {
            url = "resource/allJob/icon/" + JobGoodsID + "no.swf";
            str = nostr;
            Alert.showAlert(MainManager.getAppLevel(),url,str,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
         }
         return result;
      }
      
      private function showAlertFun(event:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(PickItemRes.PICK_ITEM,this.showAlertFun);
         var url:String = "resource/allJob/icon/" + this.RandomJobGoodsID + ".swf";
         var str:String = this.RandomJobOkStr;
         Alert.showAlert(MainManager.getAppLevel(),url,str,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
      }
      
      public function chartRandom(num:int) : Boolean
      {
         var ap:int = int(Math.random() * 100);
         if(ap <= num)
         {
            return true;
         }
         return false;
      }
   }
}

