package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.GetItemCount.*;
   import flash.events.Event;
   
   public class JobMap57View
   {
      
      public function JobMap57View()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function chartFun() : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190065,0);
      }
      
      private function chartGoodsFun(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         var obj:Object = e.EventObj.obj;
         if(obj.Count == 0)
         {
            this.showNowJobAlt(0);
         }
         else
         {
            this.showNowJobAlt(1);
         }
      }
      
      private function getkey(ID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getAndThing);
         BC.addEvent(this,GV.onlineSocket,"sameEvent",this.removeEventHandler);
         CSReq.Info(ID);
      }
      
      private function getAndThing(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getAndThing);
         BC.removeEvent(this,GV.onlineSocket,"sameEvent",this.removeEventHandler);
         var obj:Object = event.EventObj;
         var Arr:Array = [];
         if(obj.Cnt == 0)
         {
            return;
         }
         this.showNowJobAlt(2);
      }
      
      private function showNowJobAlt(Flag:uint) : void
      {
         var myAlert:* = undefined;
         var msg:String = "";
         var url:String = "";
         switch(Flag)
         {
            case 0:
               msg = "這裡是麼麼公主的賀卡箱子。製作桌上的蛋糕可以獲得賀卡哦！";
               myAlert = Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"otherJob_konw",true,false,"E");
               return;
            case 1:
               msg = "    嘻嘻，小摩爾，你怎麼知道我生日到了？麼麼好開心哦，你手裡這張卡片是送給我的嗎？";
               url = "resource/allJob/AlertPic/momoBir0.swf";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"sure,cancel",true,false,"SMC");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGet);
               return;
            case 2:
               msg = "    親愛的" + LocalUserInfo.getNickName() + "，謝謝你的賀卡，我真是喜歡極了!一定好好珍藏！我親手製作了一些好看的蛋糕帽子，送你一頂！喜歡嗎？rr    我是11月28日出生的，你能來和我一起分享快樂美好的生日嗎？我等你哦！";
               url = "resource/allJob/AlertPic/momoBir1.swf";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetOne);
               return;
            case 3:
               url = "resource/cloth/icon/12227.swf";
               msg = "    麼麼公主親手製作的蛋糕帽子已經放入你的百寶箱中！";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
               return;
            default:
               return;
         }
      }
      
      private function showGet(event:Event) : void
      {
         this.getkey(518);
      }
      
      private function showGetOne(event:*) : void
      {
         this.showNowJobAlt(3);
      }
      
      private function removeEventHandler(evetn:EventTaomee = null) : void
      {
         BC.removeEvent(this);
      }
   }
}

