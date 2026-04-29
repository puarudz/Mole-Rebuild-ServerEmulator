package com.view.JobView.ChildNPCJob
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   
   public class kevinNPC extends simpleNPC
   {
      
      private var teacherday:*;
      
      public function kevinNPC(box:MovieClip, btn:*, mc:MovieClip, ID:int)
      {
         super(box,btn,mc,ID);
      }
      
      override internal function npcTitFun() : void
      {
         this.showKevinAltUI();
      }
      
      private function showKevinAltUI(event:* = null) : void
      {
         this.teacherday = null;
         botton_mc.visible = false;
         var url:String = npc_url;
         var msg:String = npc_obj.npcTip;
         var myAlert:* = Alert.showAlert(GV.MC_AppLever,url,msg,Alert.CHANG_ALERT,"otherJob_konw",true,true,"npcUI","424,336");
         BC.addEvent(this,myAlert,"CLOSED",showNpcBtn);
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

