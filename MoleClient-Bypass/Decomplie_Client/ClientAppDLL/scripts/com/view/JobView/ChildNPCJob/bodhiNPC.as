package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class bodhiNPC extends simpleNPC
   {
      
      private var teacherday:*;
      
      public function bodhiNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
      }
      
      override internal function trySetOtherJob() : void
      {
         this.tryFun();
      }
      
      private function showAddTip() : void
      {
         botton_mc.visible = false;
         var url:String = "resource/allJob/AlertPic/bodhi.swf";
         var msg:String = "    嚯嚯嚯嚯，莊園一週年慶典啦！咱們拉姆學院也放假一週，小摩爾們帶著自己的小拉姆好好放松一下吧！rr    放假時間：4月24日 —— 4月30日rr    想要報名學習的小拉姆5月1號以後再來吧！";
         var myAlert:* = Alert.showAlert(MainManager.getAppLevel(),url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,false,"SMCUI");
         BC.addEvent(this,myAlert,Alert.CLICK_ + "1",showNpcBtn,false,0,true);
      }
      
      private function tryFun(event:* = null) : void
      {
         var mapMC:MovieClip = null;
         var tempMC:MCLoader = null;
         if(!GV.MC_AppLever.getChildByName("petJobUI"))
         {
            botton_mc.visible = false;
            mapMC = new MovieClip();
            mapMC.name = "petJobUI";
            GV.MC_AppLever.addChild(mapMC);
            tempMC = new MCLoader("module/external/BodhiNPCJob.swf",mapMC);
            tempMC.addEventListener(MCLoadEvent.ON_SUCCESS,this.tryOk);
            tempMC.doLoad();
         }
      }
      
      private function tryOk(evt:MCLoadEvent) : void
      {
         var mainMC:DisplayObjectContainer = evt.getParent();
         var childMC:* = evt.getLoader();
         mainMC.addChild(childMC);
         mainMC.x = 0;
         mainMC.y = 0;
         BC.addEvent(this,GV.onlineSocket,"petover_learnModule",this.removePetUI);
         var mcloader:MCLoader = evt.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.ON_SUCCESS,this.tryOk);
         mcloader.clear();
      }
      
      private function removePetUI(event:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"petover_learnModule",this.removePetUI);
         var temp:* = GV.MC_AppLever.getChildByName("petJobUI");
         GC.stopAllMC(temp);
         GC.clearAllChildren(temp);
         GV.MC_AppLever.removeChild(temp);
         temp = null;
         showNpcBtn();
         this.teacherday = null;
      }
      
      override internal function haveNotJob() : void
      {
      }
      
      override internal function justOverJob() : void
      {
      }
      
      override internal function showOverJobAlert(e:EventTaomee) : void
      {
      }
      
      override internal function showGetM(e:*) : void
      {
      }
   }
}

