package com.module.classModule
{
   import com.common.Alert.Alert;
   import com.common.Alert.childAlert.customAlert;
   import com.common.util.TextFieldAstrict;
   import com.core.info.LocalUserInfo;
   import com.core.newloader.LoaderList;
   import com.core.newloader.MCLoader;
   import com.event.EventTaomee;
   import com.global.links.Links;
   import com.logic.socket.classSystem.classSocket;
   import com.logic.switchMapLogic.switchMapLogic;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class classManage
   {
      
      private static var owner:classManage;
      
      public static var classShowID:uint;
      
      public static var classList:Array = new Array();
      
      public static var ClassInfo:Dictionary = new Dictionary(true);
      
      private var path:String = "module/classView/tipUI/";
      
      private var badgeInfoArray:Array;
      
      private var classInfoArray:Array;
      
      public function classManage()
      {
         super();
         owner = this;
         BC.addEvent(owner,GV.onlineSocket,"read_" + 5014,this.getClassInfoArray);
         classSocket.class_getMyClassList();
         this.badgeInfoArray = new Array();
         this.classInfoArray = new Array();
         BC.addEvent(owner,GV.onlineSocket,"read_" + 5017,this.resClassInfo);
      }
      
      public static function getInstance() : classManage
      {
         if(Boolean(owner))
         {
            return owner;
         }
         return new classManage();
      }
      
      public function getClassInfoArray(E:EventTaomee) : void
      {
         var i:int;
         classShowID = E.EventObj.showClassID;
         classList = E.EventObj.classList;
         for(i = 0; i < classList.length; i++)
         {
            this.getClassInfo(classList[i],function(E:*):*
            {
            });
         }
      }
      
      public function showClassInfo(classID:uint) : void
      {
         var f:Function = null;
         var ef:Function = null;
         f = function(E:EventTaomee):void
         {
            var obj:Object = null;
            var f1:Function = null;
            var pan1:customAlert = null;
            obj = E.EventObj as Object;
            ClassInfo[classID] = obj;
            BC.removeEvent(owner,GV.onlineSocket,"read_" + 5017,arguments.callee);
            if(obj.classID != classID)
            {
               return;
            }
            if(classID == GV.MyInfo_userID)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p1_mc,等待創建班級...",path + "classInfoTips.swf",1);
               f1 = function(E:*):void
               {
                  BC.removeEvent(owner,E.currentTarget,null,f1);
                  showPan1Info(pan1.TARGET,classID,obj);
               };
               BC.addEvent(owner,pan1,Alert.ON_CUSTOM_LOADED,f1);
               pan1.load();
            }
            else if(classList.indexOf(classID) >= 0)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p3_mc,等待創建班級...",path + "classInfoTips.swf",1);
               f1 = function(E:*):void
               {
                  BC.removeEvent(owner,E.currentTarget,null,f1);
                  showPan3Info(pan1.TARGET,classID,obj);
               };
               BC.addEvent(owner,pan1,Alert.ON_CUSTOM_LOADED,f1);
               pan1.load();
            }
            else
            {
               pan1 = new customAlert(GV.MC_AppLever,"p2_mc,等待創建班級...",path + "classInfoTips.swf",1);
               f1 = function(E:*):void
               {
                  BC.removeEvent(owner,E.currentTarget,null,f1);
                  showPan2Info(pan1.TARGET,classID,obj);
               };
               BC.addEvent(owner,pan1,Alert.ON_CUSTOM_LOADED,f1);
               pan1.load();
            }
         };
         ef = function(E:EventTaomee):void
         {
            BC.removeEvent(owner,GV.onlineSocket,"read_" + 5017,f);
            BC.removeEvent(owner,GV.onlineSocket,"ERROR_CMD_-12503",ef);
         };
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12503",ef);
         BC.addEvent(owner,GV.onlineSocket,"read_" + 5017,f);
         classSocket.class_getClassInfo(classID);
      }
      
      private function showPan1Info(MC:MovieClip, classID:uint, obj:Object) : void
      {
         MC.name_txt.text = obj.Name;
         MC.monitor_txt.text = obj.Monitor;
         MC.id_txt.text = classID;
         MC.count_txt.text = obj.Member_cnt;
         MC.slogan_txt.text = "　　　　　　　　" + obj.Slogan;
         MC.ico_mc.addChild(medalManage.getMedal(obj.classID,80));
         this.getBadgeInfo(classID,function(obj:Object):void
         {
            BC.addEvent(owner,MC.manage_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               BC.removeEvent(owner,E.currentTarget,MouseEvent.CLICK);
               Alert.closeAlert(MC);
               amendClass(classID,obj);
            });
            BC.addEvent(owner,MC.out_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               if(classID == GV.MyInfo_userID)
               {
                  disbandClass(function():void
                  {
                     Alert.closeAlert(MC);
                  });
               }
               else
               {
                  outClass(classID,function():void
                  {
                     Alert.closeAlert(MC);
                  });
               }
            });
            BC.addEvent(owner,MC.enter_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               Alert.closeAlert(MC);
               if(LocalUserInfo.getMapID() != classID || LocalUserInfo.getMapType() != 1)
               {
                  GF.switchMap(classID,false,1);
               }
            });
         });
      }
      
      private function showPan2Info(MC:MovieClip, classID:uint, obj:Object) : void
      {
         MC.name_txt.text = obj.Name;
         MC.monitor_txt.text = obj.Monitor;
         MC.id_txt.text = classID;
         MC.count_txt.text = obj.Member_cnt;
         MC.slogan_txt.text = "　　　　　　　　" + obj.Slogan;
         MC.ico_mc.addChild(medalManage.getMedal(obj.classID,80));
         this.getBadgeInfo(classID,function(obj:Object):void
         {
            BC.addEvent(owner,MC.add_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               BC.removeEvent(owner,E.currentTarget,null,arguments.callee);
               Alert.closeAlert(MC);
               addToClass(MC,classID,obj);
            });
            BC.addEvent(owner,MC.enter_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               BC.removeEvent(owner,E.currentTarget,null,arguments.callee);
               Alert.closeAlert(MC);
               if(LocalUserInfo.getMapID() != classID || LocalUserInfo.getMapType() != 1)
               {
                  if(!obj.Visit_flag)
                  {
                     GF.switchMap(classID,false,1);
                  }
                  else
                  {
                     Alert.showAlert(GV.MC_AppLever,"    這個班級鎖門啦！","",6,"D");
                  }
               }
            });
         });
      }
      
      private function showPan3Info(MC:MovieClip, classID:uint, obj:Object) : void
      {
         MC.name_txt.text = obj.Name;
         MC.monitor_txt.text = obj.Monitor;
         MC.id_txt.text = classID;
         MC.count_txt.text = obj.Member_cnt;
         MC.slogan_txt.text = "　　　　　　　　" + obj.Slogan;
         MC.ico_mc.addChild(medalManage.getMedal(obj.classID,80));
         this.getBadgeInfo(classID,function(obj:Object):void
         {
            BC.addEvent(owner,MC.out_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               BC.removeEvent(owner,E.currentTarget,null,arguments.callee);
               if(classID == GV.MyInfo_userID)
               {
                  disbandClass(function():void
                  {
                     Alert.closeAlert(MC);
                  });
               }
               else
               {
                  outClass(classID,function():void
                  {
                     Alert.closeAlert(MC);
                  });
               }
            });
            BC.addEvent(owner,MC.enter_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               BC.removeEvent(owner,E.currentTarget,null,arguments.callee);
               Alert.closeAlert(MC);
               if(LocalUserInfo.getMapID() != classID || LocalUserInfo.getMapType() != 1)
               {
                  GF.switchMap(classID,false,1);
               }
            });
         });
      }
      
      private function addToClass(MC:MovieClip, classID:uint, obj:Object) : void
      {
         this.joinClass(classID);
      }
      
      public function joinClass(classID:uint) : void
      {
         var pan1:customAlert = null;
         BC.removeEvent(owner,GV.onlineSocket,"read_" + 5003);
         BC.addEvent(owner,GV.onlineSocket,"read_" + 5003,function(E:EventTaomee):void
         {
            var type:int;
            BC.removeEvent(owner,GV.onlineSocket,"read_" + 5003);
            type = E.EventObj as int;
            if(type == 0)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p6_mc,等待創建班級...",path + "classInfoTips.swf",1);
               pan1.load();
            }
            else if(type == 1)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p4_mc,等待創建班級...",path + "classInfoTips.swf",1);
               BC.addEvent(owner,pan1,Alert.ON_CUSTOM_LOADED,function(E:*):void
               {
                  BC.removeEvent(owner,E.currentTarget,Alert.ON_CUSTOM_LOADED);
                  new TextFieldAstrict(pan1.TARGET.add_txt,60,TextFieldAstrict.TYPE_BYTES,TextFieldAstrict.CHARSET_UTF_8);
                  BC.addEvent(owner,pan1.TARGET.yes_btn,MouseEvent.CLICK,function(E:MouseEvent):void
                  {
                     BC.removeEvent(owner,E.currentTarget,MouseEvent.CLICK);
                     classSocket.class_application(classID,pan1.TARGET.add_txt.text);
                     trace("請求已發送:",pan1.TARGET.add_txt.text);
                     Alert.showAlert(GV.MC_AppLever,"    你加入班級的申請已經發出，請耐心等待批準。","",6,"D");
                     Alert.closeAlert(pan1.TARGET);
                  });
               });
               pan1.load();
            }
            else if(type == 2)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p7_mc,等待創建班級...",path + "classInfoTips.swf",1);
               pan1.load();
            }
            else if(type == 4)
            {
               pan1 = new customAlert(GV.MC_AppLever,"p8_mc,等待創建班級...",path + "classInfoTips.swf",1);
               pan1.load();
            }
         });
         classSocket.class_requestAddToClass(classID);
      }
      
      public function getBadgeInfo(classID:uint, f:Function) : void
      {
         if(Boolean(ClassInfo[classID]))
         {
            f(ClassInfo[classID]);
         }
         else
         {
            this.classInfoArray.push(f);
            this.badgeInfoArray.push(f);
            classSocket.class_getClassInfo(classID);
         }
      }
      
      private function resBadgeInfo(E:EventTaomee) : void
      {
         var f:Function = null;
         var classID:uint = uint(E.EventObj.classID);
         ClassInfo[classID] = E.EventObj;
         while(Boolean(this.badgeInfoArray.length))
         {
            f = this.badgeInfoArray.shift();
            f(ClassInfo[classID]);
         }
      }
      
      public function getClassInfo(classID:uint, f:Function) : void
      {
         if(Boolean(ClassInfo[classID]))
         {
            f(ClassInfo[classID]);
         }
         else
         {
            classSocket.class_getClassInfo(classID);
         }
      }
      
      private function resClassInfo(E:EventTaomee) : void
      {
         var f:Function = null;
         var classID:uint = uint(E.EventObj.classID);
         ClassInfo[classID] = E.EventObj;
         while(Boolean(this.classInfoArray.length))
         {
            f = this.classInfoArray.shift();
            f(ClassInfo[classID]);
         }
      }
      
      public function outClass(classID:uint, refresh:Function = null) : void
      {
         var p:customAlert = null;
         var thisObj:* = undefined;
         thisObj = this;
         p = new customAlert(GV.MC_AppLever,"p4_mc,等待創建班級...",this.path + "classListTips.swf",1);
         BC.addEvent(this,p,Alert.ON_CUSTOM_LOADED,function(E:*):void
         {
            BC.addEvent(thisObj,p.TARGET.b1_btn,MouseEvent.CLICK,function(E:MouseEvent):void
            {
               var ff:Function = null;
               ff = function(E:*):void
               {
                  BC.removeEvent(thisObj,GV.onlineSocket,"read_" + 5004,ff);
                  trace("退出班級 成功!");
                  if(refresh != null)
                  {
                     refresh();
                  }
               };
               BC.addEvent(thisObj,GV.onlineSocket,"read_" + 5004,ff);
               classSocket.class_out(classID);
               Alert.closeAlert(p.TARGET);
               if(LocalUserInfo.getMapType() == 1 && LocalUserInfo.getMapID() == classID)
               {
                  Alert.closeAllAlert();
                  GV.Room_DefaultRoomID = 0;
                  LocalUserInfo.setMapID(0);
                  switchMapLogic.switchMapLogicHandler(1);
               }
            });
         });
         p.load();
      }
      
      public function disbandClass(refresh:Function = null) : void
      {
         var p:customAlert = null;
         var thisObj:* = undefined;
         var UserID:uint = GV.MyInfo_userID;
         thisObj = this;
         p = new customAlert(GV.MC_AppLever,"p3_mc,等待創建班級...",this.path + "classListTips.swf",1);
         BC.addEvent(this,p,Alert.ON_CUSTOM_LOADED,function(E:*):void
         {
            BC.addEvent(thisObj,p.TARGET.b1_btn,MouseEvent.CLICK,function(E:Event):void
            {
               classSocket.class_delClass();
               BC.addEvent(thisObj,GV.onlineSocket,"read_" + 5008,function(E:*):void
               {
                  BC.removeEvent(thisObj,GV.onlineSocket,"read_" + 5008);
                  trace("解散班級 成功!");
                  if(refresh != null)
                  {
                     refresh();
                  }
               });
               Alert.closeAlert(p.TARGET);
               if(LocalUserInfo.getMapType() == 1 && LocalUserInfo.getMapID() == GV.MyInfo_userID)
               {
                  Alert.closeAllAlert();
                  GV.Room_DefaultRoomID = 0;
                  LocalUserInfo.setMapID(0);
                  switchMapLogic.switchMapLogicHandler(1);
               }
            });
         });
         p.load();
      }
      
      public function amendClass(classID:uint, obj:Object) : void
      {
         var myLoader:MCLoader = new MCLoader(Links.getUrl("module/classView/amendClass.swf"),GV.MC_AppLever,1,"打開班級列表...");
         LoaderList.getInstance().addItem(myLoader,null,LoaderList.HIGH,true);
      }
      
      public function showList() : void
      {
         var myLoader:MCLoader = new MCLoader(Links.getUrl("module/classView/classList.swf"),GV.MC_AppLever,1,"打開班級列表...");
         LoaderList.getInstance().addItem(myLoader,null,LoaderList.HIGH,true);
      }
      
      public function seachClass() : void
      {
         var myLoader:MCLoader = new MCLoader(Links.getUrl("module/classView/seachClass.swf"),GV.MC_AppLever,1,"打開搜索面板...");
         LoaderList.getInstance().addItem(myLoader,null,LoaderList.HIGH,true);
      }
      
      public function createClass() : void
      {
         var myLoader:MCLoader = new MCLoader(Links.getUrl("module/classView/createPan1.swf"),GV.MC_AppLever,1,"等待創建班級...");
         LoaderList.getInstance().addItem(myLoader,null,LoaderList.HIGH,true);
      }
   }
}

