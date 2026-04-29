package com.logic.StageActionLogic
{
   import com.common.LibLogic.LibLogic;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.socket.action.*;
   import com.logic.socket.useUserDItem.UseUserItemRigRes;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.activity.Task83.StatisticsClass;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import org.taomee.bean.BaseBean;
   
   public class StageActionLogic extends BaseBean
   {
      
      private static var actionReq:ActionReq;
      
      private static var clothsChangeReq:UseUserItemRigRes;
      
      private static var oldTimer:uint = 0;
      
      private static var myEventDispatcher:EventDispatcher = new EventDispatcher();
      
      public static var dispatchEvent:Function = myEventDispatcher.dispatchEvent;
      
      public static var addEventListener:Function = myEventDispatcher.addEventListener;
      
      public static var removeEventListener:Function = myEventDispatcher.removeEventListener;
      
      public function StageActionLogic()
      {
         super();
      }
      
      public static function msgAction(people:PeopleManageView, UserID:uint, msg:String, tag:String, data:String) : void
      {
         dispatchEvent(new EventTaomee(tag,{
            "p":people,
            "d":data
         }));
      }
      
      private static function checkKeyAction(E:KeyboardEvent) : void
      {
         var peopleView:PeopleManageView = GV.MAN_PEOPLE;
         if(Boolean(!(MainManager.getStage().focus is TextField) && peopleView && peopleView.address != "17003") && Boolean(peopleView.address != "120000") && !GV.isChangeMap)
         {
            switch(E.keyCode)
            {
               case 68:
                  if(Boolean(peopleView.avatarClass) && peopleView.dance())
                  {
                  }
                  break;
               case 87:
                  if(Boolean(peopleView.avatarClass) && peopleView.wave())
                  {
                  }
                  break;
               case 83:
                  if(Boolean(peopleView.avatarClass) && peopleView.sitDown(peopleView.avatarClass.DirectionNum))
                  {
                  }
            }
            MainManager.getStage().removeEventListener(KeyboardEvent.KEY_DOWN,checkKeyAction);
            GC.setGTimeout(function():void
            {
               MainManager.getStage().addEventListener(KeyboardEvent.KEY_DOWN,checkKeyAction);
            },500);
         }
      }
      
      private static function showGetItemsFun(E:EventTaomee) : void
      {
         var url:String;
         var obj:Object = null;
         var effloader:Loader = null;
         var f:Function = null;
         if(LocalUserInfo.getMapID() == 137)
         {
            return;
         }
         obj = E.EventObj;
         if(!obj.itemsArr.length)
         {
            return;
         }
         url = "resource/ui/getItemEffect.swf";
         effloader = new Loader();
         LibLogic.addLibEvent_getIcon(effloader,"showIcon",obj.itemsArr[0].ItemID);
         f = function(E:Event):void
         {
            var p:PeopleManageView = GF.getPeopleByID(obj.UserID) as PeopleManageView;
            if(Boolean(p))
            {
               p.addEffect(effloader);
            }
            effloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,f);
         };
         effloader.contentLoaderInfo.addEventListener(Event.COMPLETE,f);
         effloader.load(VL.getURLRequest(url));
      }
      
      private static function requestAction(E:*) : void
      {
         var tempObj:Object = E.EventObj.obj;
         doActionByID(tempObj.UserID,tempObj.Action,tempObj.Direction,tempObj.type);
      }
      
      private static function clothsChange(E:*) : void
      {
         var userMC:Object = null;
         var tempArray:Array = null;
         var i:uint = 0;
         try
         {
            userMC = GF.getPeopleByID(E.EventObj.UserID);
            if(E.EventObj.UserID != LocalUserInfo.getUserID())
            {
               tempArray = E.EventObj.userArr;
               for(i = 0; i < tempArray.length; i++)
               {
                  if(tempArray[i].Flag == 1)
                  {
                     userMC.avatarClass.clothClass.putOn(tempArray[i]);
                  }
                  else
                  {
                     userMC.avatarClass.clothClass.getOff(tempArray[i]);
                  }
               }
            }
            userMC.avatarClass.clothClass.refurbishCloths();
         }
         catch(Err:Error)
         {
            trace(E.EventObj.UserID,"衣服不存在",Err);
         }
      }
      
      private static function lamuAction(E:EventTaomee) : void
      {
         var action:int = 0;
         var type:int = 0;
         var t:int = 0;
         var p:PeopleManageView = GF.getPeopleByID(E.EventObj.userID);
         if(E.EventObj.userID != GV.MyInfo_userID)
         {
            if(Boolean(p) && Boolean(p.lamuinfo) && E.EventObj.petID == p.lamuinfo.PetID)
            {
               action = int(E.EventObj.action) - 1;
               type = action % 3 + 1;
               t = 1208000 + int(action / 3) * 3 + type - 1;
               p.lamuinfo.isUserSKill = t;
               p.lamu.boneManaage.showAction("skill_" + t);
               p.lamu["refurbish"]();
            }
         }
      }
      
      private static function dellamuAction(E:EventTaomee) : void
      {
         var p:PeopleManageView = GF.getPeopleByID(E.EventObj.userID);
         if(Boolean(p) && p.hasLamu)
         {
            p.lamuinfo.isUserSKill = 0;
            p.lamu["refurbish"]();
            if(p.id == GV.MyInfo_userID)
            {
               MoveTo.CanAutoFind = true;
               if(Boolean(LocalUserInfo.lamuinfo))
               {
                  LocalUserInfo.lamuinfo.isUserSKill = 0;
               }
            }
         }
      }
      
      public static function doActionByID(id:Number, str:Object, direction:int, type:Object) : void
      {
         var my:PeopleManageView = null;
         if(!GV.MAN_PEOPLE || GV.isChangeMap)
         {
            return;
         }
         if(id != GV.MyInfo_userID)
         {
            my = GF.getPeopleByID(id);
            if(Boolean(type) && Boolean(my))
            {
               if(str == 0)
               {
                  my.closeBook(false);
               }
               else if(str == 1)
               {
                  my.openBook(false);
               }
            }
            else if(str == 1)
            {
               my.dance();
            }
            else if(str == 2)
            {
               my.wave();
            }
            else if(str == 3)
            {
               my.sitDown(direction);
            }
            else if(str == 4)
            {
               my.paopao();
            }
            else if(str == 5)
            {
               GF.showLeverUp(my);
            }
            else if(str == 6)
            {
               GF.showLeverUp(my,int(direction));
            }
         }
      }
      
      override public function start() : void
      {
         GV.onlineSocket.addEventListener("read_" + 1212,lamuAction);
         GV.onlineSocket.addEventListener("read_" + 1214,dellamuAction);
         GV.onlineSocket.addEventListener("read_" + 2009,showGetItemsFun);
         GV.onlineSocket.addEventListener("GET_PETFOOD_SUCC",this.updatePetData);
         if(actionReq == null)
         {
            actionReq = new ActionReq();
            GV.onlineSocket.addEventListener("action",requestAction);
         }
         if(clothsChangeReq == null)
         {
            clothsChangeReq = new UseUserItemRigRes();
            GV.onlineSocket.addEventListener(UseUserItemRigRes.USE_USER_ITEM_RIG,clothsChange);
         }
         MainManager.getStage().addEventListener(KeyboardEvent.KEY_DOWN,checkKeyAction);
         finish();
      }
      
      private function updatePetData(e:EventTaomee) : void
      {
         var obj:Object = e.EventObj;
         var p:PeopleManageView = GF.getPeopleByID(obj.UserID);
         if(Boolean(p) && Boolean(p.hasLamu) && p.lamuinfo.PetID == obj.SpriteID)
         {
            this.petAction(p.lamu,obj.Action);
            if(obj.Action == 180097)
            {
               StatisticsClass.getInstance().init(67744852,"http://view.admaster.com.cn/show_v.php?a=1344&b=10004&c=1215&i=100&h=");
            }
         }
      }
      
      public function petAction(mc:*, i:uint) : void
      {
         var obj:Object = GoodsInfo.getInfoById(i);
         if(Boolean(obj.EatType))
         {
            mc.showIconAction(obj.EatType,i);
         }
         else
         {
            trace("特殊物品!!!");
         }
      }
   }
}

