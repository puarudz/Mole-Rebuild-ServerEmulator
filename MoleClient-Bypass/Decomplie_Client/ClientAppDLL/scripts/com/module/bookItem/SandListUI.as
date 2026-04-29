package com.module.bookItem
{
   import com.event.EventTaomee;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class SandListUI extends EventDispatcher
   {
      
      public static var GET_INFO:String = "GET_INFO_BOOKLIST";
      
      public static var GET_INFO_TWO:String = "GET_INFO_BOOKLIST_2";
      
      private var Info_arr:Array = [];
      
      private var Info_msg:String = "";
      
      private var targetMC:MovieClip;
      
      private var List_MC:MovieClip;
      
      private var lgh:uint = 0;
      
      public function SandListUI()
      {
         super();
      }
      
      public function beginFun(mc:*, nums:uint) : void
      {
         this.targetMC = mc;
         this.List_MC = this.targetMC.MC;
         this.lgh = nums;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeAll);
         BC.addEvent(this,this.List_MC.enter_btn,MouseEvent.CLICK,this.sandFun);
         this.setInfoUI();
      }
      
      private function setInfoUI() : void
      {
         var Box_MC:MovieClip = null;
         var ap_arr:Array = [];
         for(var p:uint = 1; p < this.lgh; p++)
         {
            ap_arr.push(0);
            Box_MC = this.List_MC["mc_" + p];
            Box_MC.box.gotoAndStop(1);
            if(p % 2 == 0)
            {
               Box_MC.friend = this.List_MC["mc_" + (p - 1)];
            }
            if(p % 2 == 1)
            {
               Box_MC.friend = this.List_MC["mc_" + (p + 1)];
            }
            Box_MC.ID = p - 1;
            BC.addEvent(this,Box_MC.btn,MouseEvent.CLICK,this.setOneBoxInfo);
         }
         this.List_MC.arr = ap_arr;
      }
      
      private function setOneBoxInfo(event:MouseEvent) : void
      {
         var Box_MC:MovieClip = event.target.parent;
         if(Box_MC.box.currentFrame == 1)
         {
            Box_MC.box.gotoAndStop(2);
            this.List_MC.arr[Box_MC.ID] = 1;
            Box_MC.friend.box.gotoAndStop(1);
            this.List_MC.arr[Box_MC.friend.ID] = 0;
         }
         else
         {
            Box_MC.box.gotoAndStop(1);
            this.List_MC.arr[Box_MC.ID] = 0;
         }
      }
      
      private function sandFun(event:MouseEvent) : void
      {
         dispatchEvent(new EventTaomee(GET_INFO,{"info":this.List_MC.arr}));
         this.rePlayFun();
      }
      
      public function rePlayFun() : void
      {
         for(var p:uint = 1; p < this.lgh; p++)
         {
            this.List_MC["mc_" + p].box.gotoAndStop(1);
         }
         this.List_MC.arr = [0,0,0,0];
      }
      
      public function removeAll(event:* = null) : void
      {
         this.lgh = 0;
         BC.removeEvent(this);
         this.List_MC = null;
         this.targetMC = null;
      }
   }
}

