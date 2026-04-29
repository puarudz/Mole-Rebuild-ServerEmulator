package com.view.mapView.activity.Task83
{
   import com.common.Alert.Alert;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.module.angelPark.AngelParkView;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   
   public class SwitchMapToAngelPark
   {
      
      private static var _instance:SwitchMapToAngelPark;
      
      private var ldr:Loader;
      
      private var _hostId:Number;
      
      private var _needHideMC:DisplayObject;
      
      public function SwitchMapToAngelPark()
      {
         super();
      }
      
      public static function get instance() : SwitchMapToAngelPark
      {
         if(!_instance)
         {
            _instance = new SwitchMapToAngelPark();
         }
         return _instance;
      }
      
      public function loadSwitchMV(hostId:Number, needHideMC:DisplayObject = null) : void
      {
         this._hostId = hostId;
         this._needHideMC = needHideMC;
         this.checkSuperLamu();
      }
      
      private function loadMV() : void
      {
         if(Boolean(this._needHideMC))
         {
            this._needHideMC.visible = false;
         }
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
         if(Boolean(GV.MAN_PEOPLE.avatarClass))
         {
            GV.MAN_PEOPLE.avatarClass.stopToHere();
         }
         MoveTo.CanMove = false;
         this.ldr = new Loader();
         BC.addEvent(this,GV.onlineSocket,"gotoAngleParkMVPlayOver",this.switchToAngelPark);
         BC.addEvent(this,GV.onlineSocket,"gotoMapAngelPark",this.HideMoleFun);
         BC.addEvent(this,this.ldr.contentLoaderInfo,Event.COMPLETE,this.loadAngleMVOkFun);
         this.ldr.load(VL.getURLRequest("resource/ui/switchToAngelParkMV.swf"));
      }
      
      private function checkSuperLamu() : void
      {
         this.loadMV();
      }
      
      private function onIsVipFun(evt:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"get_scene_info",this.onIsVipFun);
         var vip:Boolean = Boolean(evt.EventObj.Vip >> 0 & 1);
         if(vip)
         {
            this.loadMV();
         }
         else
         {
            Alert.smileAlart("   你的好友還不是超級拉姆，天使園還沒有修建好不能進入！");
         }
      }
      
      private function HideMoleFun(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"gotoMapAngelPark",this.HideMoleFun);
         GV.MAN_PEOPLE.visible = false;
      }
      
      private function loadAngleMVOkFun(e:Event) : void
      {
         BC.removeEvent(this,this.ldr.contentLoaderInfo,Event.COMPLETE,this.loadAngleMVOkFun);
         this.ldr.content["mc1"].x = GV.MAN_PEOPLE.x;
         this.ldr.content["mc1"].y = GV.MAN_PEOPLE.y;
         this.ldr.content["mc2"].x = GV.MAN_PEOPLE.x;
         this.ldr.content["mc2"].y = GV.MAN_PEOPLE.y;
         GV.MC_mapFrame["depth_mc"].addChild(this.ldr.content["mc1"]);
         GV.MC_mapFrame["depth_mc"].addChildAt(this.ldr.content["mc2"],0);
      }
      
      private function switchToAngelPark(e:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"gotoAngleParkMVPlayOver",this.switchToAngelPark);
         if(this.ldr != null)
         {
            GV.MC_mapFrame["depth_mc"].removeChild(this.ldr.content["mc1"]);
            GV.MC_mapFrame["depth_mc"].removeChild(this.ldr.content["mc2"]);
            this.ldr = null;
         }
         GF.switchMap(this._hostId,false,37);
         MoveTo.CanMove = true;
         GV.MAN_PEOPLE.visible = true;
      }
      
      private function removeEventHandler(e:Event) : void
      {
         BC.removeEvent(this);
         if(this.ldr != null)
         {
            GV.MC_mapFrame["depth_mc"].removeChild(this.ldr.content["mc1"]);
            GV.MC_mapFrame["depth_mc"].removeChild(this.ldr.content["mc2"]);
            this.ldr = null;
         }
      }
      
      public function gotoAngelFun() : void
      {
         if(!AngelParkView.isInMyPark)
         {
            GF.switchMap(LocalUserInfo.getUserID(),false,37);
         }
      }
      
      public function gotoAngelMvFun() : void
      {
         if(!AngelParkView.isInMyPark)
         {
            this._hostId = LocalUserInfo.getUserID();
            if(Boolean(GV.MAN_PEOPLE.avatarClass))
            {
               GV.MAN_PEOPLE.avatarClass.stopToHere();
            }
            MoveTo.CanMove = false;
            this.ldr = new Loader();
            BC.addEvent(this,GV.onlineSocket,"gotoAngleParkMVPlayOver",this.switchToAngelPark);
            BC.addEvent(this,GV.onlineSocket,"gotoMapAngelPark",this.HideMoleFun);
            BC.addEvent(this,this.ldr.contentLoaderInfo,Event.COMPLETE,this.loadAngleMVOkFun);
            this.ldr.load(VL.getURLRequest("resource/ui/switchToAngelParkMV.swf"));
         }
      }
   }
}

