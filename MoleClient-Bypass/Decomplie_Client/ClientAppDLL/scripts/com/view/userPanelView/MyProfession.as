package com.view.userPanelView
{
   import com.common.scrollBar.ScrollBar;
   import com.common.tip.tip;
   import com.common.util.MovieClipUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.myProfession.MyProfessionReq;
   import com.logic.socket.myProfession.MyProfessionRes;
   import com.logic.socket.smc.smcStatus.StatusReq;
   import com.mole.app.task.TaskManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class MyProfession
   {
      
      public var MC:MovieClip;
      
      public var Arr:Array;
      
      private var checkTimer:Timer;
      
      private var currentID:int;
      
      private var space:int = 28;
      
      private var userID:uint;
      
      private var mcArr:Array;
      
      public function MyProfession(mc:MovieClip, id:uint)
      {
         super();
         this.MC = mc;
         GV.onlineSocket.addEventListener(MyProfessionRes.GET_MY_PROFESSION,this.getMyProfession1);
         MyProfessionReq.req(id);
         this.userID = id;
      }
      
      public function getMyProfession1(e:EventTaomee) : void
      {
         var count:uint = 0;
         var num:int = 0;
         GV.onlineSocket.removeEventListener(MyProfessionRes.GET_MY_PROFESSION,this.getMyProfession1);
         this.Arr = e.EventObj.arr;
         var t1:int = int(this.Arr[3]);
         this.Arr[3] = this.Arr[4];
         this.Arr[4] = t1;
         this.mcArr = [];
         this.Arr.splice(5,0,0);
         var slqs:int = int(this.Arr.splice(9,1)[0]);
         if(Boolean(this.Arr[12]))
         {
            this.Arr[0] = this.Arr[12] + 1;
         }
         this.getMyProfession(new EventTaomee("",{"flag":slqs}));
         if(this.userID == LocalUserInfo.getUserID())
         {
            if((LocalUserInfo.getVip() >> 2 & 1) == 0)
            {
               count = 0;
               for each(num in this.Arr)
               {
                  count += num;
               }
               if(count > 0)
               {
                  new StatusReq().status(3,1);
               }
            }
         }
      }
      
      public function getMyProfession(e:EventTaomee) : void
      {
         var i:int;
         var myScrollBar:ScrollBar;
         var mc:MovieClip = null;
         var level:int = 0;
         if(Boolean(e.EventObj.flag))
         {
            this.Arr[5] = 1;
         }
         GV.onlineSocket.removeEventListener(MyProfessionRes.GET_MY_PROFESSION + 2,this.getMyProfession);
         for(i = 0; i < XMLInfo.ProfessionArr.length - 1; i++)
         {
            mc = UIManager.getMovieClip("UI003_professionbtn_mc") as MovieClip;
            mc.id = i >= 5 ? i - 1 : i;
            mc.x = this.space * i;
            if(!(i == 12 || i == 13))
            {
               MovieClipUtil.playAppointFrameAndFunc(mc,i + 1,function(frame:uint):void
               {
                  var sub_mc:MovieClip = mc.getChildAt(0) as MovieClip;
                  if(Boolean(sub_mc))
                  {
                     sub_mc.gotoAndStop(frame + 1);
                  }
               },[this.Arr[i]]);
               level = int(this.Arr[i]);
               if(this.userID == GV.MyInfo_userID)
               {
                  BC.addEvent(this,mc,MouseEvent.CLICK,this.showSMC_Pan);
                  if(Boolean(XMLInfo.ProfessionArr[i][level]))
                  {
                     tip.tipTailDisPlayObject(mc,XMLInfo.ProfessionArr[i][level]);
                  }
                  mc.buttonMode = true;
                  this.MC.buttonMode = true;
               }
               else
               {
                  if(Boolean(XMLInfo.ProfessionArr[i][level]))
                  {
                     tip.tipTailDisPlayObject(mc,XMLInfo.otherProfessionArr[i][level]);
                  }
                  mc.buttonMode = false;
                  this.MC.buttonMode = false;
               }
               this.MC.addChild(mc);
               this.mcArr.push(mc);
            }
         }
         this.sornMC();
         myScrollBar = new ScrollBar(null,this.MC,{
            "size":this.space,
            "length":6 * this.space,
            "x":40,
            "y":300
         },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_HORIZONTAL,this.space,3);
         myScrollBar.AdddownBtn_proxy(this.MC.parent["up_btn"]);
         myScrollBar.AddupBtn_proxy(this.MC.parent["down_btn"]);
         myScrollBar.visible = false;
         this.MC.parent["up_btn"].alpha = 1;
         this.MC.parent["down_btn"].alpha = 1;
         setTimeout(myScrollBar.doChange,100);
      }
      
      private function sornMC() : void
      {
         var mc:MovieClip = null;
         this.mcArr = this.mcArr.sortOn("tag",16);
         this.mcArr = this.mcArr.reverse();
         for(var i:int = 0; i < this.mcArr.length; i++)
         {
            mc = this.mcArr[i] as MovieClip;
            mc.x = this.space * i;
         }
      }
      
      private function showSMC_Pan(e:MouseEvent) : void
      {
         if(Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()]) && Boolean(MapsConfig.MapsInfo[LocalUserInfo.getMapID()].isNewUserMap))
         {
            return;
         }
         if(TaskManager.getTaskState(300) == 1)
         {
            return;
         }
         this.currentID = int(e.currentTarget["id"]) + 1;
         GC.clearGInterval(this.checkTimer);
         this.checkTimer = GC.setGInterval(this.checkhaspan,20);
         var taskMC:Sprite = MainManager.getToolLevel().getChildByName("notice_mc") as Sprite;
         if(Boolean(taskMC))
         {
            taskMC["SMC_btn"].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function checkhaspan() : void
      {
         var listMC:MovieClip = null;
         var smcMC:MovieClip = MainManager.getAppLevel().getChildByName("smcListMC") as MovieClip;
         if(Boolean(smcMC))
         {
            listMC = smcMC.getChildByName("List_mc") as MovieClip;
            if(Boolean(listMC))
            {
               if(Boolean(listMC.btnMC) && Boolean(listMC.btnMC["MC_" + this.currentID]))
               {
                  listMC.btnMC["MC_" + this.currentID].btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  GC.clearGInterval(this.checkTimer);
               }
            }
         }
      }
      
      private function removeEventHandler(E:*) : void
      {
         GC.clearGInterval(this.checkTimer);
         this.Arr = [];
         this.mcArr = [];
      }
   }
}

