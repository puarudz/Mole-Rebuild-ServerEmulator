package com.view.JobView.ChildMapJob
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CSItems.*;
   import com.logic.socket.GetItemCount.*;
   
   public class JobMap55View
   {
      
      private var Bln:Boolean = false;
      
      public function JobMap55View()
      {
         super();
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public function chartFun(bln:Boolean = false) : void
      {
         this.Bln = bln;
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.chartGoodsFun);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190049,0);
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
            this.getkey(503);
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
         var p:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,CSRes.GETITEM_OK,this.getAndThing);
         BC.removeEvent(this,GV.onlineSocket,"sameEvent",this.removeEventHandler);
         var obj:Object = event.EventObj;
         var Arr:Array = [];
         if(obj.Cnt == 0)
         {
            return;
         }
         p = LocalUserInfo.getYXQ();
         LocalUserInfo.setYXQ(p + 1000);
         if(this.Bln)
         {
            this.showNowJobAlt(2);
         }
         else
         {
            this.showNowJobAlt(1);
         }
      }
      
      private function showNowJobAlt(Flag:uint) : void
      {
         var myAlert:* = undefined;
         var msg:String = "";
         var url:String = "";
         switch(Flag)
         {
            case 0:
               msg = "寶箱需要金鑰匙才能打開。去地下迷宮找找吧！";
               myAlert = Alert.showAlert(GV.MC_AppLever,msg,"",Alert.CHANG_ALERT,"otherJob_konw",true,false,"D");
               return;
            case 1:
               msg = "　　1000摩爾豆已放入你的百寶箱中。";
               url = "resource/allJob/icon/money2.swf";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
               return;
            case 2:
               msg = "    金鑰匙，轉呀轉！寶盒寶貝快出來！哇哦！這裡有一大箱摩爾豆，快把它們收起來吧！";
               url = "resource/allJob/AlertPic/seaBox3.swf";
               myAlert = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetOne);
               return;
            default:
               return;
         }
      }
      
      private function showGetOne(event:*) : void
      {
         this.showNowJobAlt(1);
      }
      
      private function removeEventHandler(evetn:EventTaomee) : void
      {
         BC.removeEvent(this);
      }
   }
}

