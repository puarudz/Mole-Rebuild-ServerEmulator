package com.view.JobView.ChildNPCModule.ModuleJob
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.JobLogic.JobExpandLogic;
   import com.logic.JobLogic.JobLogic;
   import com.logic.socket.petSocket.adoptPet.petClothReq;
   import com.logic.socket.petSocket.adoptPet.petClothRes;
   import com.logic.socket.shopItem.BuyItemReq;
   import com.logic.socket.task.TaskOverProtocol;
   import com.module.loadExtentPanel.LoadGame;
   import com.mole.app.task.TaskManager;
   import com.view.JobView.ChildNPCModule.BaseNPCModule;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseEXInfoMapUIGame extends BaseNPCModule
   {
      
      public var Game_Info:Object;
      
      private var BuyItemReqs:BuyItemReq;
      
      private var BuyItem_JobID:Array = [77];
      
      public function BaseEXInfoMapUIGame()
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
         if(!GV.JobLogics.havePetFollow())
         {
            Alert.showAlert(GV.MC_AppLever,"帶著小拉姆再來看看吧！","",Alert.ICO_ALERT2,"D");
            return;
         }
         var ID:uint = uint(npc_obj.jobid);
         var nowmode:* = GV.JobLogics.findJobTaskStatus(ID);
         if(nowmode == 0)
         {
            this.showTipFun(0);
         }
         else if(nowmode == 1)
         {
            BC.addEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.showJobOver);
            JobExpandLogic.getJobExpand().getOneJob(ID);
         }
         else if(nowmode >= 2)
         {
            if(this.BuyItem_JobID.indexOf(ID) != -1)
            {
               this.justOverJob();
            }
            else if(npc_obj.msg2 != "no")
            {
               this.showTipFun(2);
            }
         }
      }
      
      override public function removeEventFun() : void
      {
         BC.removeEvent(this);
      }
      
      public function showJobOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.showJobOver);
         var get_arr:Array = e.EventObj.obj.arr;
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
         this.showAddGame();
      }
      
      public function showAddGame(event:Event = null) : void
      {
         BC.addEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME",this.closeGameUI);
         BC.addEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME_OK",this.overAddGame);
         var loadGame:LoadGame = new LoadGame(this.Game_Info.url,this.Game_Info.msg,MainManager.getGameLevel());
         loadGame = null;
         this.showNpcBtn();
      }
      
      private function closeGameUI(event:EventTaomee) : void
      {
         var temp:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME",this.closeGameUI);
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME_OK",this.overAddGame);
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
      }
      
      private function overAddGame(event:EventTaomee = null) : void
      {
         var temp:* = undefined;
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME",this.closeGameUI);
         BC.removeEvent(this,GV.onlineSocket,this.Game_Info.name + "_CLOSE_GAME_OK",this.overAddGame);
         if(Boolean(MainManager.getGameLevel().getChildByName("panle")))
         {
            temp = MainManager.getGameLevel().getChildByName("panle");
            MainManager.getGameLevel().removeChildAt(temp);
            temp = null;
         }
         BC.addEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         petClothReq.petItemReq(LocalUserInfo.getUserID(),GV.MyInfo_PetObj.SpriteID,npc_obj.goodsID,uint(npc_obj.goodsID) + 1,2);
      }
      
      private function getPetOtherEvent(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_GET_ITEM_SUCC,this.getPetOtherEvent);
         var task77State:uint = TaskManager.getTaskState(77);
         if(task77State > 1)
         {
            if(this.BuyItem_JobID.indexOf(uint(npc_obj.jobid)) != -1)
            {
               if(eve.EventObj.Count == 0)
               {
                  BC.addEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.getJobItemAlert);
                  petClothReq.buyItem(GV.MAN_PEOPLE.PetID,npc_obj.goodsID,1);
               }
               else
               {
                  Alert.showAlert(GV.MC_AppLever,"你的拉姆已經擁有魔法袍了哦！","",Alert.ICO_ALERT2,"E");
               }
            }
            else
            {
               this.showTipFun(3);
            }
         }
         else if(eve.EventObj.Count == 0)
         {
            BC.addEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
            TaskOverProtocol.send(npc_obj.jobid);
         }
         else
         {
            Alert.showAlert(GV.MC_AppLever,"你的拉姆已經擁有魔法袍了哦！","",Alert.ICO_ALERT2,"E");
         }
      }
      
      public function showOverJobAlert(e:EventTaomee = null) : void
      {
         BC.removeEvent(this,GV.onlineSocket,JobLogic.CHANGlISTOVER,this.showOverJobAlert);
         if(this.BuyItem_JobID.indexOf(uint(npc_obj.jobid)) != -1)
         {
            BC.addEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.getJobItemAlert);
            petClothReq.buyItem(GV.MAN_PEOPLE.PetID,npc_obj.goodsID,1);
         }
         else
         {
            this.showTipFun(3);
         }
      }
      
      public function getJobItemAlert(eve:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,petClothRes.PET_BUY_ITEM_SUCC,this.getJobItemAlert);
         this.showTipFun(3);
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
         var temp:* = undefined;
         if(Boolean(MainManager.getAppLevel().getChildByName("Job_map_UI")))
         {
            temp = MainManager.getAppLevel().getChildByName("Job_map_UI");
            MainManager.getAppLevel().removeChild(temp);
            temp = null;
         }
         this.dispatchEvent(new Event(SHOWNPCBTN));
      }
      
      public function showTipFun(type:uint) : void
      {
         var myAlert:* = undefined;
         var url:String = null;
         var cla:Class = null;
         var JobMC:MovieClip = null;
         var names:String = null;
         var msg:String = "";
         switch(type)
         {
            case 0:
               cla = GV.Lib_Map.getClass("Job_UI") as Class;
               JobMC = new cla();
               JobMC.name = "Job_map_UI";
               MainManager.getAppLevel().addChild(JobMC);
               MainManager.centerObj(JobMC);
               BC.addEvent(this,JobMC.begin_btn,MouseEvent.CLICK,this.sandJobFun);
               BC.addEvent(this,JobMC.del_btn,MouseEvent.CLICK,this.showNpcBtn);
               BC.addEvent(this,JobMC.close_btn,MouseEvent.CLICK,this.showNpcBtn);
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
               BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               break;
            case 3:
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
                  if(npc_obj.goodsID > 1200000)
                  {
                     msg = "  " + names + "已經放入你的拉姆背包中。";
                  }
                  else
                  {
                     msg = "  " + names + "已經放入你的百寶箱中。";
                  }
                  myAlert = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"EMP_BUY");
                  BC.addEvent(this,myAlert,Alert.CLICK_ + "1",this.showNpcBtn);
               }
         }
      }
   }
}

