package com.module.throwThing
{
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.event.ThrowEvent;
   import com.logic.randomItemDrawLogic.randomItemDrawLogic;
   import com.logic.socket.moleAction.moleActionReq;
   import com.view.mapView.activity.TryMoleClothes;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.*;
   import flash.net.SharedObject;
   
   public class throwHitTest
   {
      
      public static var throwObj:EventDispatcher = new EventDispatcher();
      
      public static var testArr:Array = new Array();
      
      public static var moleAction:moleActionReq = new moleActionReq();
      
      public static var HITTEST_SUC:String = "hittest_suc";
      
      public static var HITTEST_SUC_FIRE:String = "hittest_suc_fire";
      
      public static var HITTEST_SUC_FLOWER:String = "hittest_suc_flower";
      
      public static var HITTEST_FAIL_FIRE:String = "hittest_fail_fire";
      
      public function throwHitTest()
      {
         super();
      }
      
      public static function HitTestPeople() : void
      {
         BC.addEvent(throwHitTest,throwObj,"hitTest",hitTestPeopleHandler);
         BC.addEvent(throwHitTest,GV.onlineSocket,"MOLE_SLIDE",doAction);
      }
      
      public static function HitTestMC(... TestMC_Arr) : void
      {
         if(testArr.length > 0)
         {
            BC.removeEvent(throwHitTest,throwObj,"hitTest",hitTestFun);
         }
         testArr = TestMC_Arr;
         BC.addEvent(throwHitTest,throwObj,"hitTest",hitTestFun);
      }
      
      private static function hitTestFun(E:*) : void
      {
         var fra:* = undefined;
         for(var i:uint = 0; i < testArr.length; i++)
         {
            if(Boolean(testArr[i].btn) && Boolean(testArr[i].btn.hitTestPoint(E.EventObj.po.x,E.EventObj.po.y,true)) && testArr[i].id == "swf" + E.EventObj.id)
            {
               fra = testArr[i].mc.currentFrame;
               testArr[i].mc.userID = E.EventObj.userID;
               testArr[i].mc.Point = new Point(E.EventObj.po.x,E.EventObj.po.y);
               testArr[i].mc.ThrowID = E.EventObj.id;
               if(Boolean(testArr[i].fre))
               {
                  testArr[i].mc.gotoAndPlay(testArr[i].fre);
               }
               if(Boolean(testArr[i].hide) && Boolean(E.EventObj.mc.parent))
               {
                  E.EventObj.mc.parent.removeChild(E.EventObj.mc);
               }
               if(Boolean(testArr[i].stop))
               {
                  testArr[i].mc.gotoAndStop(testArr[i].fre);
               }
               if(E.EventObj.userID == LocalUserInfo.getUserID())
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee(HITTEST_SUC_FIRE,{
                     "mc":testArr[i].mc,
                     "btn":testArr[i].btn
                  }));
               }
               GV.onlineSocket.dispatchEvent(new ThrowEvent(HITTEST_SUC_FLOWER,{
                  "mc":testArr[i].mc,
                  "btn":testArr[i].btn
               }));
               GV.onlineSocket.dispatchEvent(new Event(HITTEST_SUC));
               if(E.EventObj.userID == LocalUserInfo.getUserID() && LocalUserInfo.getMapID() == 19)
               {
                  randomItemDrawLogic.getRWAction(testArr[i].mc);
               }
               break;
            }
         }
         if(i == testArr.length && testArr[i - 1].id == "swf" + E.EventObj.id)
         {
            testArr[i - 1].mc.userID = E.EventObj.userID;
            testArr[i - 1].mc.ThrowID = E.EventObj.id;
            GV.onlineSocket.dispatchEvent(new EventTaomee(HITTEST_FAIL_FIRE,{
               "mc":testArr[i - 1].mc,
               "btn":testArr[i - 1].btn
            }));
         }
      }
      
      private static function hitTestPeopleHandler(E:*) : void
      {
         var peopleMC:* = undefined;
         var tempMC:MovieClip = null;
         var j:int = 0;
         if(GV.isSwitchMap)
         {
            return;
         }
         for(var i:int = 0; i < GV.peopleTouchArray.length; i++)
         {
            peopleMC = GV.peopleTouchArray[i];
            if(Boolean(peopleMC.avatarMC.pet_mc.hitTestPoint(E.EventObj.po.x,E.EventObj.po.y,true)) && (E.EventObj.id == 150001 || E.EventObj.id == 150002))
            {
               E.EventObj.mc.parent.removeChild(E.EventObj.mc);
               if(peopleMC.id == GV.MyInfo_userID)
               {
                  moleAction.sendAction(E.EventObj.id - 140000);
                  return;
               }
               peopleMC.avatarClass.ResetAndDisposeBmp();
               return;
            }
            if(Boolean(peopleMC.avatarMC.Visualize_mc.hitTestPoint(E.EventObj.po.x,E.EventObj.po.y,true)) && E.EventObj.id == 150002)
            {
               E.EventObj.mc.parent.removeChild(E.EventObj.mc);
               tempMC = peopleMC.avatarMC.tomatoMC;
               if(tempMC.currentFrame == 17 || tempMC.currentFrame == 2)
               {
                  tempMC.gotoAndPlay(3);
               }
               break;
            }
            if(Boolean(peopleMC.avatarMC.tomatoMC.hitTestPoint(E.EventObj.po.x,E.EventObj.po.y,true)) && E.EventObj.id == 150003)
            {
               if(E.EventObj.userID == LocalUserInfo.getUserID())
               {
                  return;
               }
               for(j = 0; j < peopleMC.clothsArray.length; j++)
               {
                  if(peopleMC.clothsArray[j].id == 12110)
                  {
                     if(peopleMC.id == LocalUserInfo.getUserID())
                     {
                        GF.deleteItemAction();
                     }
                  }
               }
               break;
            }
            if(Boolean(peopleMC.avatarMC.tomatoMC.hitTestPoint(E.EventObj.po.x,E.EventObj.po.y,true)) && E.EventObj.id == 150001)
            {
               if(E.EventObj.userID == GV.MyInfo_userID)
               {
                  TryMoleClothes.getInstance().init(peopleMC);
               }
               peopleMC.addEffect("english_mc");
               break;
            }
         }
      }
      
      private static function doAction(evt:EventTaomee) : void
      {
         var mc:* = undefined;
         var i:int = 0;
         var shareObj:SharedObject = null;
         var userID:* = evt.EventObj.UserID;
         var action:* = evt.EventObj.Action;
         if(action == 2)
         {
            mc = GF.getPeopleByID(userID);
            if(mc.avatarMC.tomatoMC.airBall.currentFrame == 2)
            {
               mc.avatarMC.tomatoMC.airBall.gotoAndPlay(3);
            }
            for(i = 0; i < mc.clothsArray.length; i++)
            {
               if(mc.clothsArray[i].id == 12110)
               {
                  mc.clothsArray.splice(i,1);
                  break;
               }
            }
            if(userID == LocalUserInfo.getUserID())
            {
               randomItemDrawLogic.randomItem();
               LocalUserInfo.setClothItem(mc.clothsArray);
               shareObj = MainManager.getGlobalObject();
               shareObj.data.clothArray = LocalUserInfo.getClothItem();
               shareObj.flush();
            }
            GF.revertPeople(userID);
         }
      }
      
      public static function removeHitTest() : void
      {
         BC.removeEvent(throwHitTest,throwObj,"hitTest",hitTestFun);
      }
      
      public function havePetFollow(id:*) : Boolean
      {
         var petObj:Object = GV.GF.getPeopleObj(id);
         if(petObj != null && Boolean(petObj.PetID))
         {
            return true;
         }
         return false;
      }
   }
}

