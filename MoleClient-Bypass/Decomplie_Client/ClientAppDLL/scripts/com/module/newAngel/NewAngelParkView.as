package com.module.newAngel
{
   import com.core.MainManager;
   import com.core.music.TopicMusicManager;
   import com.event.EventTaomee;
   import com.module.newAngel.info.AngelInfo;
   import com.view.MapManageView.MapManageView;
   import com.view.PeopleView.NewAngelModel;
   import com.view.player.PlayerActionConstant;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class NewAngelParkView
   {
      
      private static var _instance:NewAngelParkView;
      
      public static var alertClassRef:Class;
      
      public static var NEW_ANGEL_PARK_MAP_INIT_OVER:String = "new_angel_park_map_init_over";
      
      private var _ed:EventDispatcher;
      
      private var _ui:MovieClip;
      
      private var _uiControl:NewAngelParkUIControl;
      
      private var _inParkAngel:Vector.<NewAngelModel>;
      
      private var parkAnimatManager:NewAngelParkAnimatManager;
      
      private var angelCountTxt:TextField;
      
      public function NewAngelParkView()
      {
         super();
      }
      
      public static function get instance() : NewAngelParkView
      {
         if(!_instance)
         {
            _instance = new NewAngelParkView();
         }
         return _instance;
      }
      
      public function setView(ui:MovieClip) : void
      {
         this._inParkAngel = new Vector.<NewAngelModel>();
         this.parkAnimatManager = new NewAngelParkAnimatManager();
         this._ui = ui;
         MainManager.getToolLevel().visible = false;
         this._uiControl = new NewAngelParkUIControl(this._ui.getChildByName("ui_mc") as MovieClip);
         this.angelCountTxt = MovieClip(this._ui["ui_mc"])["angel_txt"] as TextField;
         this.ed.dispatchEvent(new Event(NEW_ANGEL_PARK_MAP_INIT_OVER));
         GV.onlineSocket.addEventListener("removeMapEvent",this.destroy);
         MapManageView.inst.addEventListener(Event.INIT,this.initParkAngel);
         NewAngelManager.instance.addEventListener(NewAngelManager.NEW_ANGEL_IN_PARK_CHANGE,this.inParkChangeHandler);
         this._ui["depth_mc"].mouseChildren = this._ui["depth_mc"].mouseEnabled = true;
         SimpleButton(MovieClip(this._ui["depth_mc"])["goOldPark_btn"]).addEventListener(MouseEvent.CLICK,this.gotoOldPark);
         SimpleButton(MovieClip(this._ui["depth_mc"])["goHome_btn"]).addEventListener(MouseEvent.CLICK,this.goHomePark);
      }
      
      private function gotoOldPark(evt:MouseEvent) : void
      {
         GF.switchMap(GV.MyInfo_userID,false,300);
      }
      
      private function goHomePark(evt:MouseEvent) : void
      {
         GV.Room_DefaultRoomID = GV.MyInfo_userID + GV.TwentyBillion;
         GF.switchMap(GV.MyInfo_userID + GV.TwentyBillion);
      }
      
      private function initParkAngel(evt:Event) : void
      {
         MapManageView.inst.removeEventListener(Event.INIT,this.initParkAngel);
         for(var ix:int = 0; ix < NewAngelManager.instance.inParkAngel.length; ix++)
         {
            this.addAngelView(NewAngelManager.instance.inParkAngel[ix]);
         }
         this.parkAnimatManager.initNewAngel(this._inParkAngel);
         NewAngelTipsManager.inst.init(this._inParkAngel);
         this.angelCountTxt.text = NewAngelManager.instance.inParkAngel.length + "/" + NewAngelManager.instance.parkMaxAngelCount;
         TopicMusicManager.instance.playSound(10002);
      }
      
      private function addAngelView(angelInfo:AngelInfo) : NewAngelModel
      {
         var angelPlayer:NewAngelModel = new NewAngelModel(angelInfo);
         angelPlayer.doAction(PlayerActionConstant.ACTION_STAND,0);
         this._inParkAngel.push(angelPlayer);
         MapManageView.inst.mapLevel.depthLevel.addChild(angelPlayer);
         return angelPlayer;
      }
      
      private function inParkChangeHandler(evt:EventTaomee) : void
      {
         var angelPlayer:NewAngelModel = null;
         var type:String = evt.EventObj.type;
         var angelInfo:AngelInfo = evt.EventObj.angelInfo;
         if(type == "add")
         {
            angelPlayer = this.addAngelView(angelInfo);
            this.parkAnimatManager.addAngel(angelPlayer);
         }
         else
         {
            this.parkAnimatManager.removeAngel(angelInfo.id);
         }
         this.angelCountTxt.text = NewAngelManager.instance.inParkAngel.length + "/" + NewAngelManager.instance.parkMaxAngelCount;
      }
      
      public function get ed() : EventDispatcher
      {
         if(!this._ed)
         {
            this._ed = new EventDispatcher();
         }
         return this._ed;
      }
      
      public function destroy(evt:EventTaomee) : void
      {
         var play:NewAngelModel = null;
         SimpleButton(MovieClip(this._ui["depth_mc"])["goOldPark_btn"]).removeEventListener(MouseEvent.CLICK,this.gotoOldPark);
         SimpleButton(MovieClip(this._ui["depth_mc"])["goHome_btn"]).removeEventListener(MouseEvent.CLICK,this.goHomePark);
         MapManageView.inst.removeEventListener(Event.INIT,this.initParkAngel);
         GV.onlineSocket.removeEventListener("removeMapEvent",this.destroy);
         NewAngelManager.instance.removeEventListener(NewAngelManager.NEW_ANGEL_IN_PARK_CHANGE,this.inParkChangeHandler);
         for each(play in this._inParkAngel)
         {
            play.dispose();
         }
         this.parkAnimatManager.destroy();
         this._inParkAngel = null;
         MainManager.getToolLevel().visible = true;
         this._uiControl.destroy();
         this._uiControl = null;
         this._ui = null;
         NewAngelTipsManager.inst.destroy();
      }
   }
}

