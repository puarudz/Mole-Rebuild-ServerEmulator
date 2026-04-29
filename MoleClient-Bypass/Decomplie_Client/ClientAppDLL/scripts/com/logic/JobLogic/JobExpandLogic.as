package com.logic.JobLogic
{
   import com.event.EventTaomee;
   import com.logic.socket.getServerTimer.getServerTimerReq;
   import com.logic.socket.smc.expandItem.GetLoopJobRes;
   import com.logic.socket.smc.expandItem.RemoveLoopJobReq;
   import com.logic.socket.smc.expandItem.RemoveLoopJobRes;
   import com.logic.socket.smc.expandItem.SetLoopJobReq;
   import com.logic.socket.smc.expandItem.SetLoopJobRes;
   import com.logic.socket.task.TaskGetBufferProtocol;
   import com.module.deal.Deal;
   import com.module.deal.SwapItem;
   import flash.display.Sprite;
   
   public class JobExpandLogic extends Sprite
   {
      
      private static var _inst:JobExpandLogic;
      
      public static var ONEJOBINFO:String = "onejob_info";
      
      public static var REMOVEJOBINFO:String = "remjob_info";
      
      public static var NOWTIMES:String = "nowtime_info";
      
      private var AllJob_Info:Array = new Array();
      
      public var nowTime:Number = 0;
      
      public function JobExpandLogic()
      {
         super();
      }
      
      public static function getJobExpand() : JobExpandLogic
      {
         if(_inst == null)
         {
            _inst = new JobExpandLogic();
         }
         return _inst;
      }
      
      public function getAllJobInfo() : Array
      {
         return this.AllJob_Info;
      }
      
      public function makeAllJobInfo(obj:*, bln:Boolean) : void
      {
         if(bln)
         {
            this.AllJob_Info[obj.job] = obj;
         }
         else
         {
            this.AllJob_Info[obj.job] = null;
         }
      }
      
      public function getServerTime() : void
      {
         getServerTimerReq.getServerTimer(this,"getServerTimer");
      }
      
      public function getServerTimer(eve:Date) : void
      {
         var nowDate:Date = eve;
         this.nowTime = nowDate.getTime();
         dispatchEvent(new EventTaomee(NOWTIMES,{"obj":this.nowTime}));
      }
      
      public function getOneJob(ID:uint) : void
      {
         if(this.AllJob_Info[ID] == null)
         {
            BC.addEvent(this,GV.onlineSocket,GetLoopJobRes.GET_BACK,this.backJobInfo);
            TaskGetBufferProtocol.send(ID);
         }
         else
         {
            dispatchEvent(new EventTaomee(ONEJOBINFO,{"obj":this.AllJob_Info[ID]}));
         }
      }
      
      public function backJobInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetLoopJobRes.GET_BACK,this.backJobInfo);
         this.makeAllJobInfo(event.EventObj.obj,true);
         dispatchEvent(new EventTaomee(ONEJOBINFO,{"obj":event.EventObj.obj}));
      }
      
      public function NewGetJobInfo(ID:uint) : void
      {
         if(this.AllJob_Info[ID] == null)
         {
            BC.addEvent(this,GV.onlineSocket,GetLoopJobRes.GET_BACK + "_" + ID,this.NewBackJobInfoHandler);
            TaskGetBufferProtocol.send(ID);
         }
         else
         {
            dispatchEvent(new EventTaomee(ONEJOBINFO + "_" + ID,{"obj":this.AllJob_Info[ID]}));
         }
      }
      
      private function NewBackJobInfoHandler(e:EventTaomee) : void
      {
         var jobId:int = int(e.EventObj.obj.job);
         BC.removeEvent(this,GV.onlineSocket,GetLoopJobRes.GET_BACK + "_" + jobId,this.NewBackJobInfoHandler);
         this.makeAllJobInfo(e.EventObj.obj,true);
         dispatchEvent(new EventTaomee(ONEJOBINFO + "_" + jobId,{"obj":e.EventObj.obj}));
      }
      
      public function setOneJob(ID:uint, Obj:Object) : void
      {
         BC.addEvent(this,GV.onlineSocket,SetLoopJobRes.GET_BACK,this.backSetJobInfo);
         SetLoopJobReq.SetInfo(ID,Obj);
      }
      
      private function backSetJobInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,SetLoopJobRes.GET_BACK,this.backSetJobInfo);
         this.makeAllJobInfo(event.EventObj.obj,true);
         this.checkJobInfo(event.EventObj.obj);
         dispatchEvent(new EventTaomee(ONEJOBINFO,{"obj":event.EventObj.obj}));
      }
      
      public function NewSetJobInfo(ID:uint, Obj:Object) : void
      {
         BC.addEvent(this,GV.onlineSocket,SetLoopJobRes.GET_BACK + "_" + ID,this.backSetJobInfoHandler);
         SetLoopJobReq.SetInfo(ID,Obj);
      }
      
      private function backSetJobInfoHandler(e:EventTaomee) : void
      {
         var jobId:int = int(e.EventObj.obj.job);
         BC.removeEvent(this,GV.onlineSocket,SetLoopJobRes.GET_BACK + "_" + jobId,this.backSetJobInfoHandler);
         this.makeAllJobInfo(e.EventObj.obj,true);
         this.checkJobInfo(e.EventObj.obj);
         dispatchEvent(new EventTaomee(ONEJOBINFO + "_" + jobId,{"obj":e.EventObj.obj}));
      }
      
      public function removeOneJob(ID:uint) : void
      {
         BC.addEvent(this,GV.onlineSocket,RemoveLoopJobRes.GET_BACK,this.removeJobInfo);
         RemoveLoopJobReq.RemoveInfo(ID);
      }
      
      public function removeJobInfo(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,RemoveLoopJobRes.GET_BACK,this.removeJobInfo);
         this.makeAllJobInfo(event.EventObj.obj,false);
         dispatchEvent(new EventTaomee(REMOVEJOBINFO,{"obj":event.EventObj.obj}));
      }
      
      public function chartOneJob(ID:uint) : uint
      {
         var Obj:Object = this.AllJob_Info[ID];
         return Obj.Flag;
      }
      
      public function chartSomeJob(ID:uint) : Object
      {
         return this.AllJob_Info[ID];
      }
      
      private function checkJobInfo(obj:Object) : void
      {
         switch(obj.job)
         {
            case 79:
               if(obj.flag1 != 0 && obj.flag2 != 0 && obj.flag3 != 0 && obj.flag4 != 0 && obj.flag5 != 0)
               {
                  GV.JobViews.showJob(79);
               }
               break;
            case 80:
               if(obj.flag1 != 0 || obj.flag2 != 0 || obj.flag3 != 0)
               {
                  GV.JobViews.showJob(80);
               }
               break;
            case 90:
               if(obj.sockFlag == 1 && obj.treeFlag == 1 && obj.gunFlag == 1)
               {
                  GV.JobViews.showJob(90);
               }
               break;
            case 91:
               if(obj.redFlag1 == 2 && obj.redFlag2 == 2 && obj.redFlag3 == 2 && obj.orangeFlag == 2 && obj.pinkFlag == 2 && obj.carFlag == 1)
               {
                  GV.JobViews.showJob(91);
               }
               if(obj.redFlag1 == 1 || obj.redFlag2 == 1 || obj.redFlag3 == 1)
               {
                  JobLogic.rescueStatus = 1;
               }
               else if(obj.orangeFlag == 1)
               {
                  JobLogic.rescueStatus = 2;
               }
               else if(obj.pinkFlag == 1)
               {
                  JobLogic.rescueStatus = 3;
               }
               else
               {
                  JobLogic.rescueStatus = 0;
               }
               break;
            case 92:
               if(obj.flag1 == 1 && obj.flag2 == 1 && obj.flag3 == 1 && obj.flag4 == 1 && obj.flag5 == 1 && obj.flag6 == 1)
               {
                  GV.JobViews.showJob(92);
               }
               break;
            case 92:
               if(obj.isSearch == 1 && obj.flag1 == 1 && obj.flag2 == 1 && obj.flag3 == 1 && obj.flag4 == 1)
               {
                  GV.JobViews.showJob(93);
               }
               break;
            case 95:
               if(obj.flag == 1 || obj.flag == 2)
               {
                  GV.JobViews.showJob(94);
               }
               break;
            case 96:
               if(obj.flag == 1 || obj.flag == 2)
               {
                  GV.JobViews.showJob(94);
               }
               break;
            case 97:
               if(obj.flag == 1)
               {
                  GV.JobViews.showJob(94);
               }
               break;
            case 103:
               if(obj.flag == 2)
               {
                  Deal.DelItem([new SwapItem(190635,1)]);
               }
               break;
            case 104:
               if(obj.flag == 1)
               {
                  Deal.DelItem([new SwapItem(190637,1)]);
               }
         }
      }
   }
}

