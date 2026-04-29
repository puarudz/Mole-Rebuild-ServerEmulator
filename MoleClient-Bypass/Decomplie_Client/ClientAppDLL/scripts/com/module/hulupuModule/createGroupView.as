package com.module.hulupuModule
{
   import com.common.comboBox.ComboBox;
   import com.common.util.TextFieldAstrict;
   import com.core.MainManager;
   import com.core.manager.AssetsManage;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.huluGroup.createGroup;
   import com.module.friendList.friendView.GView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class createGroupView extends EventDispatcher
   {
      
      private static var owner:createGroupView;
      
      public var groupID:uint;
      
      public var groupName:String;
      
      public var targetMC:MovieClip;
      
      private var groupName_txt:TextField;
      
      private var groupInfo_txt:TextField;
      
      private var groupNameLimit:TextFieldAstrict;
      
      private var comboBoxClass:ComboBox;
      
      public function createGroupView()
      {
         super();
         this.groupID = 0;
         this.groupName = "";
         this.targetMC = UIManager.getMovieClip("createGroup_panel");
         this.targetMC.x = 960 / 2 - this.targetMC.width / 2;
         this.targetMC.y = 560 / 2 - this.targetMC.height / 2;
         this.groupName_txt = this.targetMC.groupName_txt;
         this.groupInfo_txt = this.targetMC.groupInfo_txt;
         BC.addEvent(this,this.targetMC.close_btn,MouseEvent.CLICK,this.closePan);
         BC.addEvent(this,this.targetMC.continue_btn,MouseEvent.CLICK,this.continueFun);
         new TextFieldAstrict(this.groupName_txt,18,TextFieldAstrict.TYPE_BYTES,TextFieldAstrict.CHARSET_UTF_8);
         new TextFieldAstrict(this.groupInfo_txt,121,TextFieldAstrict.TYPE_BYTES,TextFieldAstrict.CHARSET_UTF_8);
         this.comboBoxClass = new ComboBox(null,169,30,10,["同學","興趣","其他"],[0,1,2]);
         this.comboBoxClass.targetMC.x = 42;
         this.comboBoxClass.targetMC.y = 143;
         this.targetMC.addChild(this.comboBoxClass.targetMC);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_DOWN,this.dragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_UP,this.stopdragAlert);
         BC.addEvent(this,this.targetMC.drag_mc,MouseEvent.MOUSE_MOVE,this.movedragAlert);
         BC.addEvent(this,this.targetMC,MouseEvent.MOUSE_DOWN,this.sendDepthToTop);
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_" + CommandID.GROUP_CREATEGROUP,this.clearClass);
         MainManager.getAppLevel().addChild(this.targetMC);
      }
      
      public static function getInstance() : createGroupView
      {
         if(Boolean(owner))
         {
            owner.clearClass();
         }
         owner = new createGroupView();
         return owner;
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
         BC.addEvent(GView,GV.onlineSocket,"CMD_" + CommandID.GROUP_CREATEGROUP,this.getGroup);
         new createGroup().doAction(this.groupName_txt.text,this.comboBoxClass.selectedItem.data,this.groupInfo_txt.text);
         if(!GView.lib.getLoader())
         {
            BC.addEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
            GView.getLib();
         }
      }
      
      private function loadLibcomplete(E:Event) : void
      {
         BC.removeEvent(this,GView.lib,AssetsManage.ON_COMPLETE,this.loadLibcomplete);
         this.checkHasResourceAndGroup();
      }
      
      private function getGroup(E:EventTaomee) : void
      {
         this.groupID = E.EventObj as uint;
         this.checkHasResourceAndGroup();
      }
      
      private function checkHasResourceAndGroup() : void
      {
         if(this.groupID > 0 && Boolean(GView.lib.getLoader()))
         {
            dispatchEvent(new Event(Event.COMPLETE));
            this.clearClass();
         }
      }
      
      private function closePan(E:MouseEvent) : void
      {
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

