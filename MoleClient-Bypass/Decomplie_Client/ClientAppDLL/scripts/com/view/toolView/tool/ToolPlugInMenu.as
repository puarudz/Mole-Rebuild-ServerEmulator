package com.view.toolView.tool
{
   import com.common.Alert.Alert;
   import com.common.tip.tip;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.lahmClassRoomSocket.lahmClassRoomSocket;
   import com.logic.task.TaskDiceCurse;
   import com.module.classModule.classManage;
   import com.module.lahmClassRoom.lahmClassRoomBeen;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.map.MapManager;
   import com.view.MapManageView.MapManageView;
   import com.view.mapView.activity.Task83.SwitchMapToAngelPark;
   import com.view.toolView.toolView;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import org.taomee.net.SocketEvent;
   
   public class ToolPlugInMenu extends ToolMenuBase
   {
      
      private var _sea_btn:SimpleButton;
      
      private var _pig_btn:SimpleButton;
      
      private var _angel_btn:SimpleButton;
      
      private var _restaurant_btn:SimpleButton;
      
      private var _class_btn:SimpleButton;
      
      private var farmBtn:SimpleButton;
      
      private var _elementKnight_btn:SimpleButton;
      
      private var joinMap:int;
      
      private var alertObj:Object;
      
      public function ToolPlugInMenu(btn:SimpleButton, menuCon:Sprite)
      {
         super(btn,menuCon);
         this._sea_btn = _menuCon["sea_btn"];
         this._pig_btn = _menuCon["pig_btn"];
         this._angel_btn = _menuCon["angel_btn"];
         this._restaurant_btn = _menuCon["restaurant_btn"];
         this._class_btn = _menuCon["class_btn"];
         this.farmBtn = _menuCon["farm_btn"];
         this._elementKnight_btn = _menuCon["elementKnight_btn"];
         this._sea_btn.addEventListener(MouseEvent.CLICK,this.onEnterSea);
         this._pig_btn.addEventListener(MouseEvent.CLICK,this.onEnterPig);
         this._angel_btn.addEventListener(MouseEvent.CLICK,this.onEnterAngel);
         this._restaurant_btn.addEventListener(MouseEvent.CLICK,this.onEnterRestaurant);
         this._class_btn.addEventListener(MouseEvent.CLICK,this.onEnterClass);
         this.farmBtn.addEventListener(MouseEvent.CLICK,this.onEnterFarm);
         this._elementKnight_btn.addEventListener(MouseEvent.CLICK,this.onOpenElementKnight);
         tip.tipTailDisPlayObject(this.farmBtn,"我的牧場");
         tip.tipTailDisPlayObject(this._angel_btn,"我的天使園");
         tip.tipTailDisPlayObject(this._pig_btn,"我的肥肥館");
         tip.tipTailDisPlayObject(this._sea_btn,"我的海妖館");
         tip.tipTailDisPlayObject(this._restaurant_btn,"我的餐廳");
         tip.tipTailDisPlayObject(this._class_btn,"我的班級");
         tip.tipTailDisPlayObject(this._elementKnight_btn,"元素騎士");
      }
      
      private static function openEKOPanel(e:Event) : void
      {
         ModuleManager.openPanel("ElementKnightTransferPanel");
      }
      
      private function onOpenElementKnight(evt:MouseEvent = null) : void
      {
         hide();
         GV.onlineSocket.addCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,this.getKnightTransferState);
         GF.sendSocket(CommandID.GET_KNIGHT_TRANSFER_STATE);
      }
      
      private function getKnightTransferState(evt:SocketEvent) : void
      {
         GV.onlineSocket.removeCmdListener(CommandID.GET_KNIGHT_TRANSFER_STATE,this.getKnightTransferState);
         var recData:ByteArray = evt.data as ByteArray;
         var typeIndex:uint = recData.readUnsignedInt();
         if(typeIndex > 0)
         {
            ModuleManager.openPanel("ElementKnightInfoPanel");
         }
         else
         {
            Alert.smileAlart("你還沒有就職成元素騎士哦，是否前往就職？",openEKOPanel);
         }
      }
      
      private function onEnterFarm(e:MouseEvent) : void
      {
         GF.switchMap(LocalUserInfo.getUserID(),false,2);
      }
      
      private function onEnterSea(e:MouseEvent) : void
      {
         hide();
         TaskDiceCurse.inst.openSystem();
      }
      
      private function onEnterPig(e:MouseEvent) : void
      {
         hide();
         MapManager.enterMap(34,3);
      }
      
      private function onEnterAngel(e:MouseEvent) : void
      {
         hide();
         SwitchMapToAngelPark.instance.gotoAngelMvFun();
      }
      
      private function onEnterRestaurant(e:MouseEvent) : void
      {
         hide();
         MapManageView.inst.gotoRestaurant();
      }
      
      private function onEnterClassroom(evt:MouseEvent) : void
      {
         hide();
         if(toolView.hasClassroomBool && !lahmClassRoomBeen.getInstance().isMyLahmClassRoom())
         {
            GF.switchMap(LocalUserInfo.getUserID(),false,32);
         }
         else
         {
            this.gotoClassroomEvent();
         }
      }
      
      public function gotoClassroomEvent() : void
      {
         if(!lahmClassRoomBeen.getInstance().isMyLahmClassRoom())
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + 1294,this.getLamuHasClassroomHandler);
            lahmClassRoomSocket.queryhaveClass(LocalUserInfo.getUserID());
         }
      }
      
      private function getLamuHasClassroomHandler(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1294,this.getLamuHasClassroomHandler);
         if(e.EventObj.userId == LocalUserInfo.getUserID() && e.EventObj.ishaveClass == 1)
         {
            BC.addEvent(this,GV.onlineSocket,"read_" + lahmClassRoomSocket.GetStudentArchiveCommand,this.getLahmClassroomDataOK);
            lahmClassRoomSocket.queryStudentArchive(LocalUserInfo.getUserID());
         }
         else
         {
            msg = "    你現在還沒有自己的教室，要在我這裡通過拉姆小導師的入職考試後，才能擁有自己的教室哦。";
            this.gotoPutiMap53Alert(msg);
         }
      }
      
      private function getLahmClassroomDataOK(e:EventTaomee) : void
      {
         var msg:String = null;
         BC.removeEvent(this,GV.onlineSocket,"read_" + lahmClassRoomSocket.GetStudentArchiveCommand,this.getLahmClassroomDataOK);
         var studentCount:int = int(e.EventObj.StudentCound);
         if(studentCount <= 0)
         {
            msg = "    你現在還沒有招收學生哦，快來拉姆學院教導處吧，我這裡有不少又聰明又聽話的小拉姆哦。";
            this.gotoPutiMap53Alert(msg);
         }
         else
         {
            toolView.hasClassroomBool = true;
            GF.switchMap(LocalUserInfo.getUserID(),false,32);
         }
      }
      
      private function gotoPutiMap53Alert(msg:String) : void
      {
         var myAlert:*;
         var url:String = "resource/allJob/AlertPic/putiTeacher.swf";
         var _temp_2:* = myAlert;
         var _temp_1:* = Alert.CLICK_ + "1";
         with({})
         {
            _temp_2.addEventListener(_temp_1,function handler():void
            {
               MapManager.enterMap(53);
            },false,0,true);
         }
         
         private function onEnterClass(e:MouseEvent) : void
         {
            hide();
            classManage.getInstance().showList();
         }
         
         override public function destroy() : void
         {
            this._elementKnight_btn.removeEventListener(MouseEvent.CLICK,this.onOpenElementKnight);
            this._sea_btn.removeEventListener(MouseEvent.CLICK,this.onEnterSea);
            this._pig_btn.removeEventListener(MouseEvent.CLICK,this.onEnterPig);
            this._angel_btn.removeEventListener(MouseEvent.CLICK,this.onEnterAngel);
            this._restaurant_btn.removeEventListener(MouseEvent.CLICK,this.onEnterRestaurant);
            this._class_btn.removeEventListener(MouseEvent.CLICK,this.onEnterClass);
            super.destroy();
         }
      }
   }
   
   