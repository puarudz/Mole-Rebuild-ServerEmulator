package com.logic.toolLogic
{
   import com.core.MainManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.logic.socket.modUserColor.ModUserColorRes;
   import com.logic.socket.onlineNotice.FriendsNoticeRes;
   import com.taomee.component.MComponentManager;
   import com.view.ChatView.ChatView;
   import com.view.activetyView.SuperPetPanel;
   import com.view.toolView.toolView;
   import flash.display.MovieClip;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   import org.taomee.bean.BaseBean;
   
   public class toolLogic extends BaseBean
   {
      
      public static const TOOL_Y:uint = 339;
      
      private var target_mc:MovieClip;
      
      public function toolLogic()
      {
         super();
      }
      
      override public function start() : void
      {
         MComponentManager.intRoot(MainManager.getAppLevel(),14);
         if(!MainManager.getToolLevel().getChildByName("tool_mc"))
         {
            this.target_mc = UIManager.getMovieClip("UI_ToolBarPanel");
            this.target_mc.name = "tool_mc";
            MainManager.getToolLevel().addChild(this.target_mc);
            this.target_mc.y = TOOL_Y;
            this.init();
         }
         finish();
      }
      
      private function init() : void
      {
         var serverArr:Array = [];
         var serID:int = int(GV.serverID);
         var bool:Boolean = false;
         var leg:int = int(serverArr.length);
         for(var j:int = 0; j < leg; j++)
         {
            if(serverArr[j] == serID)
            {
               bool = true;
               break;
            }
         }
         if(bool)
         {
            this.target_mc.chat_up.visible = false;
            this.target_mc.msg_txt.visible = false;
            this.target_mc.msg_txt.visible = false;
            this.target_mc.enter_btn.visible = false;
         }
         var tempChatViewClass:ChatView = new ChatView(this.target_mc);
         toolView.getInstance().init(this.target_mc);
         GV.onlineSocket.addEventListener(ModUserColorRes.MOD_USER_COLOR,this.changeColor);
         GV.onlineSocket.addEventListener(FriendsNoticeRes.FRIENDS_NOTICE,this.friendShowHandler);
         SuperPetPanel.getInstance().init(this.target_mc);
      }
      
      private function changeColor(evt:*) : void
      {
         var id:int = 0;
         var color:uint = 0;
         var my:* = undefined;
         try
         {
            id = int(evt.EventObj.UserID);
            color = uint(evt.EventObj.Color);
            my = GF.getPeopleByID(id);
            my.Family = color;
            my.getColor();
            my.colorObj = GF.getRGBColor(color);
            my.changeColor();
            my.avatarClass.stopAction();
         }
         catch(E:*)
         {
         }
      }
      
      private function friendShowHandler(evt:EventTaomee) : void
      {
         setTimeout(this.showFridendsTip,5000,evt.EventObj.ID);
      }
      
      private function showFridendsTip(userID:int) : void
      {
         var nickName:String = "";
         var tempShardObj:SharedObject = MainManager.getGlobalObject();
         var tempArr:Array = tempShardObj.data.FriendsList;
         if(tempArr.length <= 0)
         {
            return;
         }
         for(var i:int = 0; i < tempArr.length; i++)
         {
            if(userID == tempArr[i].UserID)
            {
               nickName = tempArr[i].Nick;
            }
         }
         if(nickName != "")
         {
            GF.showTip("你的好友" + nickName + "來了",{
               "x":698,
               "y":500
            });
         }
      }
   }
}

