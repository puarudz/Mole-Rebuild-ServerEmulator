package com.module.hulupuModule
{
   import com.common.comboBox.ComboBox;
   import com.common.util.TextFieldAstrict;
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.getGroupBaseInfo;
   import com.logic.socket.huluGroup.modMyGroupInfo;
   import com.module.friendList.friendView.GView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class editGroupView extends EventDispatcher
   {
      
      private static var owner:editGroupView;
      
      public var groupID:uint;
      
      public var groupName:String;
      
      public var noticeMsg:String;
      
      public var groupType:uint;
      
      public var targetMC:MovieClip;
      
      private var groupName_txt:TextField;
      
      private var groupInfo_txt:TextField;
      
      private var groupNameLimit:TextFieldAstrict;
      
      private var comboBoxClass:ComboBox;
      
      public function editGroupView(_groupID:uint, _groupName:String, _groupType:uint, _noticeMsg:String)
      {
         super();
         this.groupID = _groupID;
         this.groupName = _groupName;
         this.noticeMsg = _noticeMsg;
         this.groupType = _groupType;
         this.targetMC = UIManager.getMovieClip("createGroup_panel");
         this.targetMC.x = 960 / 2 - this.targetMC.width / 2;
         this.targetMC.y = 560 / 2 - this.targetMC.height / 2;
         this.targetMC.title_mc.gotoAndStop("edit");
         this.groupName_txt = this.targetMC.groupName_txt;
         this.groupInfo_txt = this.targetMC.groupInfo_txt;
         this.groupName_txt.text = this.groupName;
         this.groupInfo_txt.text = this.noticeMsg;
         BC.addEvent(this,this.targetMC.close_btn,MouseEvent.CLICK,this.closePan);
         BC.addEvent(this,this.targetMC.continue_btn,MouseEvent.CLICK,this.continueFun);
         new TextFieldAstrict(this.groupName_txt,25,TextFieldAstrict.TYPE_BYTES,TextFieldAstrict.CHARSET_UTF_8);
         new TextFieldAstrict(this.groupInfo_txt,121,TextFieldAstrict.TYPE_BYTES,TextFieldAstrict.CHARSET_UTF_8);
         this.comboBoxClass = new ComboBox(null,169,30,10,["同學","興趣","其他"],[0,1,2]);
         this.comboBoxClass.targetMC.x = 42;
         this.comboBoxClass.targetMC.y = 143;
         this.comboBoxClass.setIndex(this.groupType);
         this.targetMC.addChild(this.comboBoxClass.targetMC);
         this.comboBoxClass.targetMC.mouseChildren = false;
         this.comboBoxClass.targetMC.mouseEnabled = false;
         this.comboBoxClass.targetMC.alpha = 0.5;
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert);
         BC.addEvent(this,this.targetMC,MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + CommandID.GROUP_MODMYGROUPINFO,this.closePan);
         MainManager.getAppLevel().addChild(this.targetMC);
      }
      
      public static function inStage() : Boolean
      {
         if(Boolean(owner.targetMC) && Boolean(owner.targetMC.parent))
         {
            return true;
         }
         return false;
      }
      
      private function continueFun(E:MouseEvent) : void
      {
         this.targetMC.continue_btn.enabled = false;
         this.targetMC.continue_btn.mouseEnabled = false;
         this.groupName = this.groupName_txt.text;
         this.noticeMsg = this.groupInfo_txt.text;
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_MODMYGROUPINFO,this.getGroup);
         new modMyGroupInfo().doAction(this.groupID,this.groupName,this.groupInfo_txt.text);
         if(!GView.lib.getLoader())
         {
            BC.addEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
            GView.getLib();
         }
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
      }
      
      private function getGroup(E:EventTaomee) : void
      {
         new getGroupBaseInfo().doAction(this.groupID);
         try
         {
            GView.refresh();
         }
         catch(E:*)
         {
         }
         dispatchEvent(new Event(Event.COMPLETE));
         if(Boolean(this.targetMC) && Boolean(this.targetMC.parent))
         {
            this.targetMC.parent.removeChild(this.targetMC);
         }
         this.targetMC = null;
         this.clearClass();
      }
      
      private function closePan(E:* = null) : void
      {
         if(Boolean(this.targetMC) && Boolean(this.targetMC.parent))
         {
            this.targetMC.parent.removeChild(this.targetMC);
         }
         this.targetMC = null;
         this.clearClass();
      }
      
      private function clearClass(E:* = null) : void
      {
         BC.removeEvent(this);
         if(Boolean(this.comboBoxClass))
         {
            this.comboBoxClass.clearClass();
         }
         if(Boolean(this.targetMC) && Boolean(this.targetMC.parent))
         {
            this.targetMC.parent.removeChild(this.targetMC);
         }
         this.targetMC = null;
         owner = null;
         this.groupName_txt = null;
         this.groupInfo_txt = null;
         this.comboBoxClass = null;
      }
      
      private function dragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.startDrag();
      }
      
      private function movedragAlert(event:MouseEvent) : void
      {
         event.updateAfterEvent();
      }
      
      private function stopdragAlert(event:MouseEvent) : void
      {
         event.currentTarget.parent.parent.stopDrag();
      }
      
      public function sendDepthToTop(event:MouseEvent) : void
      {
         var topPosition:uint = event.currentTarget.parent.numChildren - 1;
         event.currentTarget.parent.setChildIndex(event.currentTarget,topPosition);
      }
   }
}

