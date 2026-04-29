package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.events.Event;
   
   public class BaseAlbumJob extends BaseNPCModule
   {
      
      public static var PHOTO_1:uint = 190479;
      
      public static var PHOTO_2:uint = 190480;
      
      public static var PHOTO_3:uint = 190481;
      
      public static var PHOTO_4:uint = 190482;
      
      public static var PHOTO_5:uint = 190483;
      
      public static var PHOTO_6:uint = 190484;
      
      public static var PHOTO_7:uint = 190485;
      
      public var JOB_ID:uint = 89;
      
      public function BaseAlbumJob()
      {
         super();
      }
      
      public function makeInfo(NPC_ID:String) : void
      {
         var obj:Object = XMLInfo.npcXML[NPC_ID];
         setInfo(obj);
      }
      
      override public function npcClientFun(a:* = null) : void
      {
         var nowmode:* = GV.JobLogics.findJobTaskStatus(89);
         if(nowmode == 0)
         {
            this.showTipFun(0);
         }
         else if(nowmode == 1)
         {
            this.checkJobFun();
         }
      }
      
      public function checkJobFun() : void
      {
         GV.JobLogics.chartNowJobArr(89);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.chartBegFun);
      }
      
      private function chartBegFun(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.chartBegFun);
         var get_arr:Array = e.EventObj.arr;
         if(get_arr.indexOf(0) == -1)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("check_album_back",{"isFinish":true}));
         }
         else
         {
            msg = "    你還沒有找全十張照片嗎？如果完成就去找麼麼公主送給她吧，她一定會非常高興的！";
            Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
            GV.onlineSocket.dispatchEvent(new EventTaomee("check_album_back",{"isFinish":false}));
         }
      }
      
      public function JobOver() : void
      {
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(89);
      }
      
      private function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showGetM();
      }
      
      private function showGetM(e:* = null) : void
      {
         this.showTipFun(4);
      }
      
      private function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(this.JOB_ID,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandJobBack);
      }
      
      private function sandJobBack(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.sandJobBack);
         GV.JobViews.showJob(this.JOB_ID);
         this.showNpcBtn();
      }
      
      private function showNpcBtn(e:* = null) : void
      {
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      private function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var msg:String = "";
         switch(type)
         {
            case 0:
               url = "resource/allJob/AlertPic/bodhi/67_03.swf";
               msg = "    嗨，你也知道我有一份驚喜想要送給麼麼公主？不過我準備了很久，還沒有完成這幅巨作，請你幫我一起把這份驚喜，親手準備完畢，送給我們的麼麼好嗎？rr    相信麼麼收到這份大家的心意，一定非常感動！";
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"Job_begin,nextCome",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
               BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showNpcBtn,false,0,true);
               break;
            case 4:
               msg = "    恭喜你獲得與麼麼的合影，已經放入你的小屋倉庫了！";
               Alert.getIconByID_Alart(160540,msg);
         }
      }
   }
}

