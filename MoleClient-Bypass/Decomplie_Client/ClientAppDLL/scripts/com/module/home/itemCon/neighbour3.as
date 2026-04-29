package com.module.home.itemCon
{
   import com.common.Alert.*;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.logic.socket.home.GetHomeInfoReq;
   import com.logic.socket.home.GetHomeInfoRes;
   import com.logic.switchMapLogic.switchMapLogic;
   import com.module.home.HomeEditView;
   import com.module.home.HomeView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class neighbour3
   {
      
      private static var tPan:*;
      
      private var neighbourClass:Class;
      
      private var targetMC:MovieClip;
      
      public function neighbour3(_targetMC:MovieClip)
      {
         super();
         this.targetMC = _targetMC;
         this.targetMC.mc2.tt_txt.text = this.targetMC.Other;
         if(HomeView.ismyhome)
         {
            BC.addEvent(this,this.targetMC.btn,MouseEvent.MOUSE_OVER,this.showEditBtn);
            BC.addEvent(this,this.targetMC.hit_btn,MouseEvent.MOUSE_OUT,this.hideEditBtn);
            BC.addEvent(this,this.targetMC.hit_btn,MouseEvent.MOUSE_OVER,this.hideEditBtn);
            BC.addEvent(this,this.targetMC.edit_btn,MouseEvent.CLICK,this.openEditPan);
         }
         BC.addEvent(this,this.targetMC.btn,MouseEvent.CLICK,this.gotoNeighbour);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      private function showEditBtn(E:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            this.targetMC.edit_btn.visible = true;
            this.targetMC.edit_btn.alpha = 1;
         }
      }
      
      private function hideEditBtn(E:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            this.targetMC.edit_btn.visible = false;
         }
      }
      
      private function openEditPan(E:MouseEvent) : void
      {
         var neighbourClass:Class = null;
         if(!HomeEditView.Editable)
         {
            if(!tPan)
            {
               neighbourClass = GV.Lib_Map.getClass("neighbour_mc");
               tPan = new neighbourClass();
               tPan.x = 288;
               tPan.y = 22;
               tPan.num_txt.text = E.currentTarget.parent.mc2.tt_txt.text;
               BC.addEvent(this,tPan.yes_btn,MouseEvent.CLICK,this.sureHandle);
               BC.addEvent(this,tPan.close_btn,MouseEvent.CLICK,this.closeHandle);
               MainManager.getAppLevel().addChild(tPan);
            }
            else
            {
               tPan.num_txt.text = E.currentTarget.parent.mc2.tt_txt.text;
            }
         }
      }
      
      private function sureHandle(E:MouseEvent) : void
      {
         if(!HomeEditView.Editable)
         {
            if(isNaN(tPan.num_txt.text))
            {
               trace("非數字");
            }
            else
            {
               GetHomeInfoReq.isUserExist(uint(tPan.num_txt.text));
               BC.addEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_EXIST_SUCC,this.UserExist);
               this.targetMC.mc2.tt_txt.text = tPan.num_txt.text;
            }
         }
      }
      
      private function UserExist(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetHomeInfoRes.USER_EXIST_SUCC,this.UserExist);
         if(Boolean(e.EventObj.Bool))
         {
            BC.removeEvent(this,null,MouseEvent.CLICK,this.sureHandle);
            BC.removeEvent(this,null,MouseEvent.CLICK,this.closeHandle);
            GC.clearAll(tPan);
            tPan = null;
            HomeEditView.getInstance().homeItemArr[this.targetMC.num].Other = this.targetMC.mc2.tt_txt.text;
            HomeEditView.getInstance().SaveUsedGood();
         }
         else
         {
            Alert.showAlert(MainManager.getAppLevel(),"","這個小摩爾沒有生活在莊園裡哦，請重新輸入米米號。",Alert.IKNOW_ALERT);
            this.targetMC.mc2.tt_txt.text = "";
         }
      }
      
      private function closeHandle(E:MouseEvent) : void
      {
         BC.removeEvent(this,null,MouseEvent.CLICK,this.sureHandle);
         BC.removeEvent(this,null,MouseEvent.CLICK,this.closeHandle);
         GC.clearAll(tPan);
         tPan = null;
      }
      
      private function gotoNeighbour(E:MouseEvent) : void
      {
         var gotoNei:* = undefined;
         var nerghborid:Number = NaN;
         if(!HomeEditView.Editable)
         {
            gotoNei = E.currentTarget.parent;
            trace("切換家園");
            nerghborid = Number(gotoNei.mc2.tt_txt.text);
            if(nerghborid > 10000)
            {
               if(GV.MapInfo_mapID != nerghborid + GV.TwentyBillion)
               {
                  GV.Room_DefaultRoomID = nerghborid + GV.TwentyBillion;
                  switchMapLogic.switchMapLogicHandler(nerghborid + GV.TwentyBillion);
               }
            }
         }
      }
      
      private function removeEventHandler(E:Event) : void
      {
         BC.removeEvent(this);
      }
   }
}

