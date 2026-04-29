package com.logic.TempFunctionLogic
{
   import com.common.Alert.Alert;
   import com.event.EventTaomee;
   import com.logic.JobLogic.JobExpandLogic;
   import com.module.restaurant.RestaurantBeen;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.setTimeout;
   
   public class TempFunctionLogic
   {
      
      private var layer:MovieClip;
      
      private var xPos:Number;
      
      private var yPos:Number;
      
      private var houseUserId:uint;
      
      private var l_obj:Loader;
      
      private var temp_obj:Object;
      
      private var myAlert:*;
      
      private var table_mc:DisplayObject;
      
      public function TempFunctionLogic(layer:MovieClip, xPos:Number = 0, yPos:Number = 0)
      {
         super();
         this.houseUserId = RestaurantBeen.getInstance().getRestaurantInfo().houseInfo.houseUserId;
      }
      
      private function getTaskListHandler(e:EventTaomee) : void
      {
         BC.removeEvent(this,JobExpandLogic.getJobExpand(),JobExpandLogic.ONEJOBINFO,this.getTaskListHandler);
         if(Boolean(e.EventObj))
         {
            this.temp_obj = e.EventObj.obj;
            if(this.temp_obj.flag < 5)
            {
               this.init();
            }
            else
            {
               this.layer = null;
            }
         }
      }
      
      private function init() : void
      {
         GV.onlineSocket.addEventListener("removeMapEvent",this.removeEventHandler);
         var url:String = "resource/allJob/other/temp_table.swf";
         this.l_obj = new Loader();
         BC.addEvent(this,this.l_obj.contentLoaderInfo,Event.COMPLETE,this.onLoadComplete);
         this.l_obj.load(new URLRequest(url));
      }
      
      private function onLoadComplete(e:Event) : void
      {
         BC.removeEvent(this,this.l_obj.contentLoaderInfo,Event.COMPLETE,this.onLoadComplete);
         this.table_mc = this.l_obj.content;
         this.l_obj = null;
         this.table_mc.x = this.xPos;
         this.table_mc.y = this.yPos;
         this.layer.addChild(this.table_mc);
         MovieClip(this.table_mc).buttonMode = true;
         BC.addEvent(this,this.table_mc,MouseEvent.CLICK,this.onMcClickHandler);
      }
      
      private function onMcClickHandler(e:MouseEvent) : void
      {
         this.myAlert = Alert.smileAlart("    你確定要把麼麼公主的玫瑰香蒸塔塔蘇給米米號為" + this.houseUserId + "的店主嘗嘗嗎？",null,"sure,cancel");
         BC.addEvent(this,this.myAlert,Alert.CLICK_ + "1",this.confirmHander);
      }
      
      private function confirmHander(e:Event) : void
      {
         BC.removeEvent(this,this.table_mc,MouseEvent.CLICK,this.onMcClickHandler);
         MovieClip(this.table_mc).gotoAndStop(2);
         ++this.temp_obj.flag;
         JobExpandLogic.getJobExpand().setOneJob(113,this.temp_obj);
         setTimeout(this.timeOutFun,2000);
      }
      
      private function timeOutFun() : void
      {
         GV.JobViews.showJob(113);
         this.removeEventHandler();
      }
      
      private function removeEventHandler(e:EventTaomee = null) : void
      {
         GV.onlineSocket.removeEventListener("removeMapEvent",this.removeEventHandler);
         BC.removeEvent(this);
         this.layer.removeChild(this.table_mc);
         GC.stopAllMC(this.table_mc);
         GC.clearAllChildren(this.table_mc);
         this.table_mc = null;
      }
   }
}

