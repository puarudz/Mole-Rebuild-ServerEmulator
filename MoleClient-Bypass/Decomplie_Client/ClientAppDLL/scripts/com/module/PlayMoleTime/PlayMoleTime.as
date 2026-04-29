package com.module.PlayMoleTime
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.manager.IndexManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.taomee.mole.library.utils.TimeFormat;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.net.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Tick;
   
   public class PlayMoleTime
   {
      
      private static const ONLINE_TIME_LIMIT:Array = [3600,2 * 3600,3 * 3600,3 * 3600 + 1800,4 * 3600,4 * 3600 + 1800,5 * 3600];
      
      private var faceMc:MovieClip;
      
      private var onlineTime:uint = 0;
      
      private var alertPanel:MovieClip;
      
      public function PlayMoleTime(mc:MovieClip)
      {
         super();
         this.faceMc = mc;
         this.faceMc.buttonMode = true;
         this.faceMc.addEventListener(MouseEvent.MOUSE_OVER,this.showTip);
         this.faceMc.addEventListener(MouseEvent.MOUSE_OUT,this.clearTip);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         GV.onlineSocket.addCmdListener(CommandID.REC_ONLINE_TIME,this.playLongTime);
         Tick.instance.addRender(this.updateOnlineTime,1000);
      }
      
      private function updateOnlineTime(val:uint) : void
      {
         ++this.onlineTime;
         GV.onlineSocket.dispatchEvent(new EventTaomee("notice_getOnLineTimeNum",{"num":this.onlineTime}));
      }
      
      private function playLongTime(evt:SocketEvent) : void
      {
         var recData:ByteArray = evt.data as ByteArray;
         this.onlineTime = recData.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("notice_getOnLineTimeNum",{"num":this.onlineTime}));
         var index:int = -1;
         var val:uint = 0;
         for(var ix:int = 0; ix < ONLINE_TIME_LIMIT.length; ix++)
         {
            val = ONLINE_TIME_LIMIT[ix] - this.onlineTime;
            if(val < 60)
            {
               index = ix;
               break;
            }
         }
         if(index == -1)
         {
            return;
         }
         var msg:String = "";
         switch(index)
         {
            case 0:
               msg = "您累計在線時間已滿1小時";
               break;
            case 1:
               msg = "您累計在線時間已滿2小時";
               break;
            case 2:
               msg = "您累計在線時間已滿3小時,您已經進入疲勞遊戲時間，您的遊戲收益將降為正常值的50%，為了您的健康，請盡快下線休息，做適當身體活動，合理安排學習生活。";
               break;
            case 3:
            case 4:
            case 5:
               msg = "您已經進入疲勞遊戲時間，您的遊戲收益將降為正常值的50%，為了您的健康，請盡快下線休息，做適當身體活動，合理安排學習生活。";
               break;
            case 6:
               msg = "您已經進入不健康遊戲時間，為了您的健康，請您立即下線休息，如不下線，您的身體將受到損害，您的收益已降為零，直到您的累計下線時間滿5小時後，才能恢復正常。";
         }
         if(index > 1)
         {
            this.showMsg(msg);
         }
         else
         {
            Alert.angryAlart(msg);
         }
      }
      
      private function showMsg(msg:String) : void
      {
         if(!this.alertPanel)
         {
            this.alertPanel = IndexManager.getInstance().getMovieClip("UI_AntiAddictionPanel");
            this.alertPanel["enter_btn"].addEventListener(MouseEvent.CLICK,this.iknowHandler);
            this.alertPanel.x = (TaomeeManager.stageWidth - this.alertPanel.width) / 2;
            this.alertPanel.y = (TaomeeManager.stageHeight - this.alertPanel.height) / 2;
         }
         this.alertPanel["content_txt"].text = msg;
         MainManager.getAlertLevel().addChild(this.alertPanel);
      }
      
      private function iknowHandler(evt:MouseEvent) : void
      {
         DisplayUtil.removeFromParent(this.alertPanel);
      }
      
      private function showTip(evt:MouseEvent) : void
      {
         GF.showTip("您已經累計在線時間" + TimeFormat.getTimeStrFromSec(this.onlineTime,TimeFormat.TIME_FORMAT_HHMMSS),{
            "noDelay":true,
            "x":150,
            "y":500
         });
      }
      
      private function clearTip(evt:MouseEvent) : void
      {
         GF.clearTip();
      }
      
      private function removeEventHandler(evt:Event) : void
      {
      }
   }
}

