package com.logic.NPCJobLogic
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.logic.socket.NPCJob.NpcJobSocket;
   import com.module.ListSMC.conSMC;
   import com.mole.app.task.TaskManager;
   import com.view.PeopleView.PeopleManageView;
   
   public class NPCJobLogic
   {
      
      public static var transportJobList:Array;
      
      public static var buildJobList:Array;
      
      public static var npcJobLogic:NPCJobLogic;
      
      public static var npcJobList:Array = [];
      
      public static var GET_JOB:String = "GET_JOB";
      
      public static var GET_NPC_JOB:String = "GET_NPC_JOB";
      
      public static var CHECK_JOB_ITEM:String = "CHECK_JOB_ITEM";
      
      public static var ACCEPT_JOB_SUCC:String = "ACCEPT_JOB_SUCC";
      
      public static var ACCEPT_JOB_ERROR:String = "ACCEPT_JOB_ERROR";
      
      public static var OVER_JOB_SUCC:String = "OVER_JOB_SUCC";
      
      public static var OVER_JOB_ERROR:String = "OVER_JOB_ERROR";
      
      public static var currentJobID:uint = 0;
      
      public static var currentJobDataArr:Array = [];
      
      public static var NPCJobStatusList:Array = [0,0,0];
      
      private var jobItemArray:Array;
      
      private var hasItemArray:Array;
      
      private var checkItemIndex:uint;
      
      public function NPCJobLogic()
      {
         super();
      }
      
      public static function getNpcJobLogic() : NPCJobLogic
      {
         if(npcJobLogic == null)
         {
            npcJobLogic = new NPCJobLogic();
         }
         return npcJobLogic;
      }
      
      public function getJobData(jobID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_JOB,this.getJobDataBack);
         NpcJobSocket.askNpcJob(jobID);
      }
      
      private function getJobDataBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.GET_JOB,this.getJobDataBack);
         var obj:Object = evt.EventObj;
         npcJobList[obj.jobID] = obj;
         GV.onlineSocket.dispatchEvent(new EventTaomee(GET_JOB,obj));
      }
      
      public function acceptJob(jobID:uint) : void
      {
         var obj:Object = conSMC.npcJobList_arr[jobID];
         if(obj.isVip == "1")
         {
            if(!LocalUserInfo.isVIP())
            {
               Alert.showAlert(MainManager.getAppLevel(),"有超級拉姆的小摩爾才能做這個任務哦！","",6,"E");
               return;
            }
         }
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.ACCEPT_JOB,this.acceptJobSucc);
         BC.addEvent(this,GV.onlineSocket,"npcJob_errorID",this.acceptJobError);
         NpcJobSocket.acceptNpcJob(jobID);
      }
      
      private function acceptJobSucc(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.ACCEPT_JOB,this.acceptJobSucc);
         BC.removeEvent(this,GV.onlineSocket,"npcJob_errorID",this.acceptJobError);
         this.updateTransportJob(evt.EventObj);
         this.updateBuildJob(evt.EventObj);
         GV.onlineSocket.dispatchEvent(new EventTaomee(ACCEPT_JOB_SUCC,evt.EventObj));
      }
      
      private function acceptJobError(evt:EventTaomee = null) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.ACCEPT_JOB,this.acceptJobSucc);
         BC.removeEvent(this,GV.onlineSocket,"npcJob_errorID",this.acceptJobError);
         var errorID:int = int(evt.EventObj.id);
         switch(errorID)
         {
            case -12590:
               msg = "你的好感度還不夠哦！";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"D");
               break;
            case -12587:
               msg = "這個任務你已經接了很多次了哦！";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"D");
               break;
            case -12588:
               msg = "這個任務你還沒有做好呢！";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",6,"D");
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(ACCEPT_JOB_ERROR,{"id":errorID}));
      }
      
      public function overJob(jobID:uint, selectID:uint = 0) : void
      {
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.OVER_JOB,this.overJobSucc);
         BC.addEvent(this,GV.onlineSocket,"npcJob_errorID",this.overJobError);
         NpcJobSocket.overNpcJob(jobID,selectID);
      }
      
      private function overJobSucc(evt:EventTaomee = null) : void
      {
         var msg:String = null;
         var item:Object = null;
         var itemName:String = null;
         var task101State:uint = 0;
         var names:String = null;
         var url:String = null;
         var address:String = null;
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.OVER_JOB,this.overJobSucc);
         BC.removeEvent(this,GV.onlineSocket,"npcJob_errorID",this.overJobError);
         GV.onlineSocket.dispatchEvent(new EventTaomee(OVER_JOB_SUCC));
         var obj:Object = evt.EventObj;
         var itemObj:Object = obj.itemArray[0];
         if(obj.jobID == 12 || obj.jobID == 13 || obj.jobID == 14)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 100);
            msg = "    謝謝你的幫忙，100個摩爾豆和1張勞動證明已經放入你的百寶箱中。";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 15 || obj.jobID == 16 || obj.jobID == 17 || obj.jobID == 19)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 200);
            msg = "    謝謝你的幫忙，200個摩爾豆和1張勞動證明已經放入你的百寶箱中。";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 20 || obj.jobID == 21 || obj.jobID == 22 || obj.jobID == 23)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 300);
            msg = "    謝謝你的幫忙，300個摩爾豆和1張勞動證明已經放入你的百寶箱中。";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 24 || obj.jobID == 25)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 100);
            msg = "    謝謝你的幫忙，你得到了100個摩爾豆、25點建築師經驗！";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 26 || obj.jobID == 29)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 200);
            msg = "    謝謝你的幫忙，你得到了200個摩爾豆、1個香樟樹樹苗、40點建築師經驗！";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 27 || obj.jobID == 28)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 100);
            msg = "    謝謝你的幫忙，你得到了100個摩爾豆、1個香樟樹樹苗、30點建築師經驗！";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 30)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 100);
            msg = "    謝謝你的幫忙，你得到了100摩爾豆、2個香樟樹苗、30點建築師經驗!";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 31)
         {
            LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + 200);
            msg = "    謝謝你的幫忙，你得到了200摩爾豆、4個香樟樹苗、40點建築師經驗!";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(obj.jobID == 43)
         {
            item = obj.itemArray[1];
            itemName = GoodsInfo.getItemNameByID(item.itemID);
            msg = "    恭喜你獲得了一隻" + itemName + "、300摩爾經驗！";
            Alert.getIconByID_Alart(item.itemID,msg);
         }
         else if(obj.jobID == 32)
         {
            msg = "    謝謝你的幫忙，你得到了10毛毛豆!";
            GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
         }
         else if(itemObj.itemID == 0)
         {
            task101State = TaskManager.getTaskState(101);
            if(obj.jobID == 10 && task101State != 2)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemObj.itemCount);
               msg = "    謝謝你的幫忙，" + itemObj.itemCount + "個摩爾豆已經放入你的百寶箱中。快去告訴大衛你已經把夢送給湯米啦！";
               GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
            }
            else if(obj.jobID == 41)
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemObj.itemCount);
               msg = "    謝謝你的幫忙，你獲得800點摩爾經驗、800摩爾豆！明天再來幫忙吧！";
               GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
            }
            else
            {
               LocalUserInfo.setYXQ(LocalUserInfo.getYXQ() + itemObj.itemCount);
               msg = "    謝謝你的幫忙，" + itemObj.itemCount + "個摩爾豆已經放入你的百寶箱中。明天再來幫忙吧！";
               GF.showAlert(MainManager.getAppLevel(),msg,"",6,"E");
            }
         }
         else if(itemObj.itemID == 190601)
         {
            Alert.smileAlart("    恭喜你獲得" + itemObj.itemCount + "個金元寶，快去神秘湖找漢青兌換禮物吧！");
         }
         else if(GV.itemID != -1)
         {
            names = GoodsInfo.getItemNameByID(itemObj.itemID);
            if(itemObj.itemID > 1220000 && itemObj.itemID < 1240000)
            {
               address = "家園倉庫";
            }
            else if(itemObj.itemID > 1270000 && itemObj.itemID < 1280000)
            {
               address = "牧場倉庫";
            }
            else if(itemObj.itemID > 160000 && itemObj.itemID < 170000)
            {
               address = "小屋倉庫";
            }
            else
            {
               address = "百寶箱";
            }
            msg = "    " + itemObj.itemCount + "個" + names + "已經放入你的" + address + "中。";
            Alert.getIconByID_Alart(itemObj.itemID,msg);
         }
         this.updateTransportJob(obj);
         this.updateBuildJob(obj);
      }
      
      private function overJobError(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.OVER_JOB,this.overJobSucc);
         BC.removeEvent(this,GV.onlineSocket,"npcJob_errorID",this.overJobError);
         Alert.showAlert(MainManager.getAppLevel()," 快去接任務吧!","",6,"E");
      }
      
      public function checkJobItem(jobID:uint) : void
      {
         var jobObj:Object = conSMC.npcJobList_arr[jobID];
         this.jobItemArray = jobObj.goods.split(";");
         this.checkItemIndex = 0;
         this.hasItemArray = [];
         this.checkItem(this.checkItemIndex);
      }
      
      private function checkItem(index:uint) : void
      {
         var itemID:uint = uint(this.jobItemArray[index]);
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkNextItem);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),itemID,2);
      }
      
      private function checkNextItem(evt:EventTaomee = null) : void
      {
         var obj:Object = evt.EventObj.obj;
         if(obj.Count <= 0)
         {
            this.hasItemArray.push(0);
         }
         else
         {
            this.hasItemArray.push(1);
         }
         ++this.checkItemIndex;
         if(this.checkItemIndex >= this.jobItemArray.length)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee(CHECK_JOB_ITEM,{"arr":this.hasItemArray}));
            BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkNextItem);
         }
         else
         {
            this.checkItem(this.checkItemIndex);
         }
      }
      
      private function makeLocalJob() : void
      {
         var obj:Object = null;
         transportJobList = new Array();
         for(var i:uint = 0; i < XMLInfo.transportJobListXML.length; i++)
         {
            obj = new Object();
            obj.jobID = XMLInfo.transportJobListXML[i].JobID;
            obj.jobStatus = 0;
            obj.jobNum = 0;
            obj.maxJobNum = 1;
            transportJobList.push(obj);
         }
      }
      
      public function getTransportLocalData(jobID:uint) : Object
      {
         var obj:Object = new Object();
         for(var i:uint = 0; i < XMLInfo.transportJobListXML.length; i++)
         {
            if(XMLInfo.transportJobListXML[i].JobID == jobID)
            {
               obj = XMLInfo.transportJobListXML[i];
            }
         }
         return obj;
      }
      
      public function askTransportJobList() : void
      {
         this.makeLocalJob();
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_NPC_JOB,this.getNpc7JobBack);
         NpcJobSocket.askAllNpcJob(7);
      }
      
      private function getNpc7JobBack(evt:EventTaomee = null) : void
      {
         var obj:Object = null;
         var j:uint = 0;
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.GET_NPC_JOB,this.getNpc7JobBack);
         var arr:Array = evt.EventObj.jobArr;
         for(var i:uint = 0; i < arr.length; i++)
         {
            obj = arr[i];
            for(j = 0; j < transportJobList.length; j++)
            {
               if(transportJobList[j].jobID == obj.jobID)
               {
                  transportJobList[j] = obj;
               }
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("ask_transportJob_ok"));
      }
      
      public function cancelAllTransportJob() : void
      {
         var jobObj:Object = null;
         var p:PeopleManageView = null;
         var hasRightCar:Boolean = false;
         var isHasJob:Boolean = false;
         for(var i:int = 0; i < transportJobList.length; i++)
         {
            jobObj = transportJobList[i];
            if(jobObj.jobStatus == 1)
            {
               isHasJob = true;
               p = PeopleManageView(GV.MAN_PEOPLE);
               hasRightCar = false;
               if(p.hasCar)
               {
                  if(p.car.carInfo.ItemID != this.getTransportLocalData(jobObj.jobID).JobCar)
                  {
                     BC.addEvent(this,GV.onlineSocket,NpcJobSocket.CANCEL_JOB,this.cancelTJobBack);
                     NpcJobSocket.giveupNpcJob(jobObj.jobID);
                  }
                  else
                  {
                     hasRightCar = true;
                  }
               }
               else
               {
                  BC.addEvent(this,GV.onlineSocket,NpcJobSocket.CANCEL_JOB,this.cancelTJobBack);
                  NpcJobSocket.giveupNpcJob(jobObj.jobID);
               }
               if(hasRightCar)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("cancel_transportjob_ok"));
                  return;
               }
            }
         }
         if(!isHasJob)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("cancel_transportjob_ok"));
         }
      }
      
      private function cancelTJobBack(evt:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.CANCEL_JOB,this.cancelTJobBack);
         var jobID:uint = uint(evt.EventObj.jobID);
         for(var i:uint = 0; i < transportJobList.length; i++)
         {
            if(transportJobList[i].jobID == jobID)
            {
               transportJobList[i].jobStatus = 0;
               --transportJobList[i].jobNum;
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("cancel_transportjob_ok"));
      }
      
      private function updateTransportJob(obj:Object) : void
      {
         if(!transportJobList)
         {
            return;
         }
         for(var i:uint = 0; i < transportJobList.length; i++)
         {
            if(transportJobList[i].jobID == obj.jobID)
            {
               transportJobList[i] = obj;
            }
         }
      }
      
      private function makeLocalBuildJob() : void
      {
         var obj:Object = null;
         buildJobList = new Array();
         for(var i:uint = 0; i < XMLInfo.buildJobListXML.length; i++)
         {
            obj = new Object();
            obj.jobID = XMLInfo.buildJobListXML[i].JobID;
            obj.jobStatus = 0;
            obj.jobNum = 0;
            obj.maxJobNum = 1;
            buildJobList.push(obj);
         }
      }
      
      public function getBuildLocalData(jobID:uint) : Object
      {
         var obj:Object = new Object();
         for(var i:uint = 0; i < XMLInfo.buildJobListXML.length; i++)
         {
            if(XMLInfo.buildJobListXML[i].JobID == jobID)
            {
               obj = XMLInfo.buildJobListXML[i];
            }
         }
         return obj;
      }
      
      public function askBuildJobList() : void
      {
         this.makeLocalBuildJob();
         BC.addEvent(this,GV.onlineSocket,NpcJobSocket.GET_NPC_JOB,this.getNpc12JobBack);
         NpcJobSocket.askAllNpcJob(8);
      }
      
      private function getNpc12JobBack(evt:EventTaomee = null) : void
      {
         var j:uint = 0;
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,NpcJobSocket.GET_NPC_JOB,this.getNpc12JobBack);
         var arr:Array = evt.EventObj.jobArr;
         for(var i:uint = 0; i < buildJobList.length; i++)
         {
            for(j = 0; j < arr.length; j++)
            {
               obj = arr[j];
               if(obj.jobID == buildJobList[i].jobID)
               {
                  buildJobList[i] = obj;
               }
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee("ask_buildJob_ok"));
      }
      
      private function updateBuildJob(obj:Object) : void
      {
         if(!buildJobList)
         {
            return;
         }
         for(var i:uint = 0; i < buildJobList.length; i++)
         {
            if(buildJobList[i].jobID == obj.jobID)
            {
               buildJobList[i] = obj;
            }
         }
      }
   }
}

