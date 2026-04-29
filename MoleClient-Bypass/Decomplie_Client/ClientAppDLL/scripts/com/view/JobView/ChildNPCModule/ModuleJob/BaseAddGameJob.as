package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.loadExtentPanel.LoadGame;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.events.Event;
   
   public class BaseAddGameJob extends BaseNPCModule
   {
      
      public var Game_Info:Object;
      
      public function BaseAddGameJob()
      {
         super();
      }
      
      public function makeInfo(NPC_ID:String) : void
      {
         var obj:Object = XMLInfo.npcXML[NPC_ID];
         setInfo(obj);
      }
      
      public function setGameInfo(obj:Object) : void
      {
         this.Game_Info = obj;
      }
      
      override public function npcClientFun(a:* = null) : void
      {
         var ID:uint = uint(npc_obj.jobid);
         var nowmode:* = GV.JobLogics.findJobTaskStatus(ID);
         if(nowmode == 0)
         {
            this.showTipFun(0);
         }
         else if(nowmode == 1)
         {
            GV.JobLogics.chartNowJobArr(ID);
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         }
         else if(nowmode >= 2)
         {
            if(npc_obj.msg4 != "no")
            {
               this.showTipFun(4);
            }
         }
      }
      
      override public function removeEventFun() : void
      {
         BC.removeEvent(this);
      }
      
      public function showJobOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHARTNOWJOBARR,this.showJobOver);
         var get_arr:Array = e.EventObj.arr;
         if(get_arr.indexOf(0) != -1)
         {
            this.showTipFun(1);
         }
         else
         {
            this.justOverJob();
         }
      }
      
      public function justOverJob() : void
      {
         this.showTipFun(2);
      }
      
      public function showAddGame(event:Event) : void
      {
         BC.addEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME",this.closeGameUI);
         BC.addEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME_OK",this.overAddGame);
         var loadGame:LoadGame = new LoadGame(this.Game_Info.url,this.Game_Info.msg,MainManager.getGameLevel());
         loadGame = null;
         this.showNpcBtn();
      }
      
      private function closeGameUI(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME",this.closeGameUI);
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME_OK",this.overAddGame);
      }
      
      private function overAddGame(event:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME",this.closeGameUI);
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "CLOSE_GAME_OK",this.overAddGame);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         TaskOverProtocol.send(npc_obj.jobid);
      }
      
      public function showOverJobAlert(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         this.showTipFun(3);
      }
      
      public function showGetM(e:*) : void
      {
         this.showTipFun(5);
      }
      
      public function sandJobFun(e:*) : void
      {
         GV.JobLogics.changJobList(npc_obj.jobid,1);
         BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
      }
      
      public function showBtnFun(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showBtnFun);
         var job_id:int = int(npc_obj.jobid);
         GV.JobViews.showJob(job_id);
         this.showNpcBtn();
      }
      
      public function showNpcBtn(e:* = null) : void
      {
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      public function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var names:String = null;
         var msg:String = "";
         switch(type)
         {
            case 0:
               url = npc_obj.url0;
               msg = npc_obj.msg0;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"Job_begin,nextCome",true,false,"SMCUI");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.sandJobFun,false,0,true);
               BC.addEvent(this,myAlert,Alert.CLICK_ + "2",this.showNpcBtn,false,0,true);
               break;
            case 1:
               url = npc_obj.url1;
               msg = npc_obj.msg1;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 2:
               url = npc_obj.url2;
               msg = npc_obj.msg2;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showAddGame);
               break;
            case 3:
               url = npc_obj.url3;
               msg = npc_obj.msg3;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showGetM);
               break;
            case 4:
               url = npc_obj.url4;
               msg = npc_obj.msg4;
               myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI","424,336");
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 5:
               if(npc_obj.goodsID == "no")
               {
                  this.showNpcBtn();
               }
               else
               {
                  if(GF.getItemName(npc_obj.goodsID).@Name == null)
                  {
                     url = String(GF.getItemName(npc_obj.goodsID).@typeObject.path) + npc_obj.goodsID + ".swf";
                     names = String(GF.getItemName(npc_obj.goodsID).@Name);
                  }
                  else
                  {
                     url = String(GoodsInfo.getInfoById(npc_obj.goodsID).typeObject.path) + npc_obj.goodsID + ".swf";
                     names = GoodsInfo.getItemNameByID(npc_obj.goodsID);
                  }
                  msg = "  " + names + "已經放入你的百寶箱中。";
                  myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
                  BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               }
         }
      }
   }
}

