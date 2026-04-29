package com.module.classModule
{
   import com.common.Alert.Alert;
   import com.common.scrollBar.ScrollBar;
   import com.core.MainManager;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineReq;
   import com.logic.socket.lookOverFriendOnline.LookOverFriendOnlineRes;
   import com.module.friendList.friendView.GView;
   import com.module.myselfTalk.selfTalk;
   import com.view.userPanelView.userPanelView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class MenberListManage extends Sprite
   {
      
      private var pan:MCLoader;
      
      private var GTalk:selfTalk;
      
      private var mainMC:Sprite;
      
      private var _listArr:Array;
      
      private var class_ID:uint;
      
      private var len:uint;
      
      private var path:String = "module/classView/tipUI/";
      
      private var Myscrollbar:ScrollBar;
      
      public var FriendStatusReq:LookOverFriendOnlineReq;
      
      public function MenberListManage()
      {
         super();
      }
      
      public static function getList(classID:uint, length:uint = 6) : MenberListManage
      {
         var owner:MenberListManage = new MenberListManage();
         owner.init(classID,length);
         return owner;
      }
      
      public function init(classID:uint, length:uint = 6) : void
      {
         this.class_ID = classID;
         this.len = length;
         this.mainMC = new Sprite();
         addChild(this.mainMC);
         this.GTalk = new selfTalk();
         this.pan = new MCLoader(this.path + "classAmendTips.swf",GV.MC_AppLever,1,"p1_mc,等待創建班級...");
         BC.addEvent(this,this.pan,MCLoadEvent.ON_SUCCESS,this.onPan1_Loaded);
         LoaderList.getInstance().addItem(this.pan,null,LoaderList.HIGH,true);
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.clearClass);
         this.FriendStatusReq = new LookOverFriendOnlineReq();
      }
      
      public function refresh() : void
      {
         classSocket.class_getMenberList(this.class_ID);
      }
      
      private function onPan1_Loaded(E:*) : void
      {
         classSocket.class_getMenberList(this.class_ID);
         BC.addEvent(this,GV.onlineSocket,"read_" + 5018,this.showMenberList);
         this.Myscrollbar = new ScrollBar(null,this.mainMC,{
            "length":36 * this.len + 2,
            "x":175,
            "y":this.mainMC.y
         },ScrollBar.ENABLE_ABATE,ScrollBar.DIRECTION_VERTICAL,36);
      }
      
      private function showMenberList(E:EventTaomee = null) : void
      {
         var ld:Loader;
         var index_:int;
         var l:int;
         var i:int;
         var memberArr:Array = null;
         var itemClass:Class = null;
         var mcObj:Object = null;
         var thisObj:* = undefined;
         var tm:MovieClip = null;
         var tmObj:Object = null;
         if(!this.mainMC.stage)
         {
            if(Boolean(this.Myscrollbar))
            {
               this.Myscrollbar.clearClass();
            }
            return;
         }
         if(Boolean(E))
         {
            BC.removeEvent(this,GV.onlineSocket,"read_" + 5018,this.showMenberList);
            memberArr = E.EventObj.memberArr;
            this.listArr = memberArr;
            BC.addEvent(this,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,this.getOnlineInfo);
            this.FriendStatusReq.lookOverFriendOnline(0,this.listArr.length,this.listArr);
         }
         else
         {
            memberArr = this.listArr;
         }
         ld = this.pan.getLoader();
         index_ = 0;
         index_ = memberArr.indexOf(GV.MyInfo_userID);
         if(index_ > -1)
         {
            memberArr.unshift(memberArr.splice(index_,1)[0]);
         }
         index_ = memberArr.indexOf(this.class_ID);
         if(index_ > -1)
         {
            memberArr.unshift(memberArr.splice(index_,1)[0]);
         }
         if(GV.MyInfo_userID == this.class_ID)
         {
            itemClass = ld.contentLoaderInfo.applicationDomain.getDefinition("item_mc") as Class;
         }
         else
         {
            itemClass = ld.contentLoaderInfo.applicationDomain.getDefinition("item1_mc") as Class;
         }
         while(Boolean(this.mainMC.numChildren))
         {
            this.mainMC.removeChildAt(0);
         }
         l = int(memberArr.length);
         l = l < this.len ? int(this.len) : l;
         mcObj = {};
         thisObj = this;
         for(i = 0; i < l; i++)
         {
            tm = new itemClass();
            if(i < memberArr.length)
            {
               tm.id = memberArr[i];
               tm.UserID = memberArr[i];
               tm.name = "mc_" + memberArr[i];
               mcObj[memberArr[i]] = tm;
               tmObj = new Object();
               tmObj.f = function(E:*):void
               {
                  var obj:Object = E.EventObj;
                  GView.friendsInfo[obj.UserID] = obj;
                  BC.removeEvent(tmObj);
                  if(!mainMC.stage)
                  {
                     return;
                  }
                  var mc:MovieClip = mcObj[obj.UserID];
                  if(!mc)
                  {
                     return;
                  }
                  mc.name_txt.text = obj.Nick;
                  mc.Nick = obj.Nick;
                  var co:Object = GF.getRGBColor(obj.Color);
                  var clt:ColorTransform = new ColorTransform(co.red / 255,co.green / 255,co.blue / 255);
                  mc.prev_pet.visible = false;
                  mc.prev_pet.pv_color.visible = false;
                  mc.prev_mc.pv_color.pv_color.transform.colorTransform = clt;
                  BC.addEvent(thisObj,mc.chat_btn,MouseEvent.CLICK,chatHandel);
                  BC.addEvent(thisObj,mc.del_btn,MouseEvent.CLICK,deluserHandel);
               };
               if(Boolean(GView.friendsInfo[tm.id]))
               {
                  tmObj.f({"EventObj":GView.friendsInfo[tm.id]});
               }
               else
               {
                  GF.getUserInfoByID(tm.id,tmObj,tmObj.f);
               }
            }
            else
            {
               tm.id = 0;
               tm.prev_mc.visible = false;
               tm.prev_pet.visible = false;
               tm.tt_mc.visible = false;
               tm.mouseChildren = false;
               tm.mouseEnabled = false;
               tm.del_btn.visible = false;
               tm.chat_btn.visible = false;
            }
            if(tm.id == GV.MyInfo_userID)
            {
               tm.del_btn.alpha = 0.5;
               tm.chat_btn.alpha = 0.5;
            }
            tm.y = i * 36;
            BC.addEvent(this,tm.hit_btn,MouseEvent.CLICK,this.showUserInfoPan);
            this.mainMC.addChild(tm);
         }
         if(Boolean(this.Myscrollbar))
         {
            this.Myscrollbar.doChange();
         }
      }
      
      private function chatHandel(E:MouseEvent) : void
      {
         var UserID:uint = uint(E.currentTarget.parent.UserID);
         if(UserID == GV.MyInfo_userID)
         {
            return;
         }
         trace("和成員私聊",UserID);
         this.GTalk.showTalkUImy({
            "UserID":UserID,
            "Nick":E.currentTarget.parent.Nick,
            "Color":1
         });
      }
      
      public function get listArr() : Array
      {
         return this._listArr;
      }
      
      public function set listArr(arr:Array) : void
      {
         this._listArr = arr;
      }
      
      private function deluserHandel(E:MouseEvent) : void
      {
         var Content:String;
         var UserID:uint = 0;
         var outAlert:* = undefined;
         var thisObj:* = undefined;
         var item:MovieClip = E.currentTarget.parent as MovieClip;
         UserID = uint(E.currentTarget.parent.UserID);
         if(UserID == GV.MyInfo_userID)
         {
            return;
         }
         trace("刪除成員",UserID);
         Content = "　　你確定要把 " + item.name_txt.text + " 從班級中刪除嗎？";
         outAlert = Alert.showAlert(MainManager.getAppLevel(),Content,"",Alert.CHANG_ALERT,"sure,cancel",true,false,"D");
         thisObj = this;
         BC.addEvent(thisObj,outAlert,"CLICK" + 1,function(E:Event):void
         {
            classSocket.class_delMenber(UserID);
            BC.addEvent(thisObj,GV.onlineSocket,"read_" + 5007,function(E:Event):void
            {
               trace("刪除成員成功!");
               refresh();
            });
            BC.removeEvent(thisObj,outAlert);
         });
      }
      
      private function showUserInfoPan(E:MouseEvent) : void
      {
         var UserID:uint = uint(E.currentTarget.parent.UserID);
         trace("顯示用戶資料面板",UserID);
         userPanelView.showUserPanel(UserID);
      }
      
      public function getOnlineInfo(E:EventTaomee) : void
      {
         var userID:* = undefined;
         var sort1Array:Array = null;
         var obj:Object = null;
         var tm:MovieClip = null;
         var onlineObj:Object = E.EventObj.onlineObj;
         var sortArray:Array = new Array();
         for each(userID in this.listArr)
         {
            sortArray.push({
               "id":userID,
               "ol":Boolean(onlineObj[userID])
            });
         }
         sortArray.sortOn("ol",Array.NUMERIC);
         sortArray = sortArray.reverse();
         sort1Array = new Array();
         for each(obj in sortArray)
         {
            sort1Array.push(obj.id);
         }
         this.listArr = sort1Array;
         this.showMenberList();
         for each(obj in sortArray)
         {
            sort1Array.push(obj.id);
            tm = this.mainMC.getChildByName("mc_" + obj.id) as MovieClip;
            if(Boolean(tm))
            {
               tm.prev_mc.pv_color.visible = Boolean(obj.ol);
            }
         }
         BC.removeEvent(this,GV.onlineSocket,LookOverFriendOnlineRes.LOOK_OVER_ONLINE_FRIEND,this.getOnlineInfo);
      }
      
      private function clearClass(E:* = null) : void
      {
         BC.removeEvent(this);
      }
   }
}

