package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.logic.socket.PageSandMsg.sandMsgReq;
   import com.logic.socket.PageSandMsg.sandMsgRes;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ContributeControl
   {
      
      private static var instance:ContributeControl;
      
      private var alStr:String;
      
      private var bool:Boolean = false;
      
      private var panelMC:MovieClip;
      
      public function ContributeControl()
      {
         super();
      }
      
      public static function getInstance() : ContributeControl
      {
         if(!instance)
         {
            instance = new ContributeControl();
         }
         return instance;
      }
      
      public function Init(_mc:MovieClip) : void
      {
         this.panelMC = _mc;
         this.panelMC.name_txt.text = GV.MyInfo_nickName;
         this.panelMC.usID_txt.text = GV.MyInfo_userID;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         BC.addEvent(this,this.panelMC.close_btn,MouseEvent.CLICK,this.clickHandler);
         BC.addEvent(this,this.panelMC.submit_mc,MouseEvent.CLICK,this.successFun);
      }
      
      private function successFun(evt:MouseEvent = null) : void
      {
         var info:String = null;
         var pp:sandMsgReq = new sandMsgReq();
         var sandType:int = 1002;
         var msg:String = this.panelMC.txt.text;
         var tit:String = "天使蛋相關信息";
         if(msg != "" && tit != "")
         {
            pp.sandFun(sandType,tit,msg);
            BC.addEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         }
         else
         {
            info = "一定要填寫標題和內容才可以哦~";
            Alert.showAlert(MainManager.getAppLevel(),info,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         }
      }
      
      private function showsandTit(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,sandMsgRes.PAGESANDBACK_SUCCESS,this.showsandTit);
         var alStr:String = "太好了！投稿成功\r摩爾莊園管理處感謝您的參與";
         Alert.showAlert(MainManager.getAppLevel(),alStr,"",Alert.CHANG_ALERT,"sure",true,false,"F");
         this.clickHandler();
      }
      
      private function clickHandler(evt:MouseEvent = null) : void
      {
         this.removeEventHandler();
         if(Boolean(this.panelMC.parent.parent.parent.parent))
         {
            this.panelMC.parent.parent.parent.parent.removeChild(this.panelMC.parent.parent.parent);
         }
      }
      
      private function removeEventHandler(evt:* = null) : void
      {
         BC.removeEvent(this);
      }
   }
}

