package com.view.mapView.source.map51
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.LevelManager;
   import com.core.newloader.BaseMCLoader;
   import com.event.EventTaomee;
   import com.event.MCLoadEvent;
   import com.logic.socket.cottonSocket;
   import com.logic.socket.finishSomething.finishSomethingReq;
   import com.logic.socket.finishSomething.finishSomethingRes;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.SystemEventManager;
   import com.view.PeopleView.PeopleManageView;
   import com.view.mapView.AirMapView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Map51Activity
   {
      
      private var _airMap:AirMapView;
      
      private var _loadURL:String;
      
      private var needFlowerID:int = 0;
      
      private var isZhi:Boolean = false;
      
      private var isZhongzi:Boolean = false;
      
      public function Map51Activity(airMap:AirMapView)
      {
         super();
         this._airMap = airMap;
         SystemEventManager.addEventListener("blower_initCotton",this.onInitCotton);
         SystemEventManager.addEventListener("blower_playCotton",this.onPlayCotton);
         SystemEventManager.addEventListener("blower_getCotton",this.onGetCotton);
         SystemEventManager.addEventListener("flower_flowerFun",this.initFlower);
      }
      
      private function onPlayCotton(e:SystemEvent) : void
      {
         var tempMC:Sprite = null;
         var mcloader:BaseMCLoader = null;
         if(LevelManager.topLevel.getChildByName("Cottongame") == null)
         {
            tempMC = new Sprite();
            tempMC.name = "Cottongame";
            MainManager.getGameLevel().addChild(tempMC);
            this._loadURL = "module/external/Cottongame.swf";
            mcloader = new BaseMCLoader(this._loadURL,tempMC);
            mcloader.addEventListener(MCLoadEvent.ON_SUCCESS,this.gameHandler);
            mcloader.doLoad();
         }
      }
      
      public function gameHandler(event:MCLoadEvent) : void
      {
         event.currentTarget.addEventListener(MCLoadEvent.ON_SUCCESS,this.gameHandler);
         var content:DisplayObject = event.getContent();
         var mc:Sprite = event.getParent() as Sprite;
         mc.addChild(content);
         BaseMCLoader(event.currentTarget).clear();
         switch(this._loadURL)
         {
            case "module/external/Cottongame.swf":
               GV.onlineSocket.addEventListener("game_over",this.gameoverFun);
         }
      }
      
      public function gameoverFun(e:Event) : void
      {
         var type:int = 0;
         GV.onlineSocket.removeEventListener("game_over",this.gameoverFun);
         switch(this._loadURL)
         {
            case "module/external/Cottongame.swf":
               if(Boolean((e as EventTaomee).EventObj.flag))
               {
                  type = int((e as EventTaomee).EventObj.type);
                  this._airMap.mapSay(int(2 + type) + 100);
               }
               else
               {
                  this._airMap.mapSay(102);
               }
         }
      }
      
      private function onGetCotton(e:SystemEvent) : void
      {
         var id:int = e.data;
         GV.onlineSocket.addEventListener("read_" + 5700,this.getCottonBack);
         cottonSocket.getCotton(id);
      }
      
      private function getCottonBack(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener("read_" + 5700,this.getCottonBack);
         var itemID:int = int(e.EventObj.ItemID);
         var str:String = "";
         if(itemID == 180089)
         {
            str = "      1個草莓棉花糖已經放進你的拉姆背包！";
         }
         else if(itemID == 180088)
         {
            str = "      1個香蕉棉花糖已經放進你的拉姆背包！";
         }
         else if(itemID == 180087)
         {
            str = "      1個奶油棉花糖已經放進你的拉姆背包！";
         }
         else if(itemID == 180086)
         {
            str = "      1罐七色花汁已經放入你的拉姆背包！";
         }
         else if(itemID == 1230045)
         {
            str = "      1個七色花種子已經放進你的農場倉庫,讓朋友們一塊分享吧！";
         }
         if(Boolean(e.EventObj.ItemEX))
         {
            if(itemID == 180089)
            {
               str = "草莓棉花糖和它的寶貴種子都送你了，要好好栽培哦！";
            }
            else if(itemID == 180088)
            {
               str = "香蕉棉花糖和它的寶貴種子都送你了，要好好栽培哦！";
            }
            else if(itemID == 180087)
            {
               str = "奶油棉花糖和它的寶貴種子都送你了，要好好栽培哦！";
            }
         }
         Alert.getIconByID_Alart(itemID,str);
      }
      
      private function onInitCotton(e:SystemEvent) : void
      {
         this.initCotton();
      }
      
      public function initCotton() : void
      {
         GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack1);
         finishSomethingReq.sendReq(165);
      }
      
      public function initFlower(e:SystemEvent) : void
      {
         var p:PeopleManageView = null;
         var num:Number = NaN;
         var id:int = e.data;
         if(id == 1)
         {
            p = GV.MAN_PEOPLE as PeopleManageView;
            if(this.needFlowerID == 0)
            {
               if(Boolean(p.lamuinfo) && p.lamuinfo.Petlevel == 101)
               {
                  if(this.isZhi && this.isZhongzi)
                  {
                     this.needFlowerID = 9;
                     this._airMap.mapSay(209);
                  }
                  else if(this.isZhi || this.isZhongzi)
                  {
                     this._airMap.mapSay(202);
                  }
                  else
                  {
                     GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack);
                     finishSomethingReq.sendReq(166);
                  }
               }
               else
               {
                  this._airMap.mapSay(201);
               }
            }
            else
            {
               this._airMap.mapSay(this.needFlowerID + 200);
            }
         }
         else if(id == 2)
         {
            num = Math.random();
            GV.onlineSocket.addEventListener("read_" + 1212,this.useSkill);
            if(num < 0.5)
            {
               this.needFlowerID = 3;
               this._airMap.mapSay(203);
            }
            else if(num < 0.8)
            {
               if(this.isZhi)
               {
                  this.needFlowerID = 3;
                  this._airMap.mapSay(203);
               }
               else
               {
                  this.needFlowerID = 5;
                  this._airMap.mapSay(205);
               }
            }
            else if(this.isZhongzi)
            {
               this.needFlowerID = 3;
               this._airMap.mapSay(203);
            }
            else
            {
               this.needFlowerID = 7;
               this._airMap.mapSay(207);
            }
         }
         else if(this.needFlowerID == 10)
         {
            this._airMap.mapSay(204);
         }
         else if(id == 4)
         {
            this.needFlowerID = 10;
         }
         else if(id == 6)
         {
            this.needFlowerID = 10;
            GV.onlineSocket.addEventListener("read_" + 5700,this.getCottonBack);
            cottonSocket.getCotton(4);
         }
         else if(id == 8)
         {
            this.needFlowerID = 10;
            GV.onlineSocket.addEventListener("read_" + 5700,this.getCottonBack);
            cottonSocket.getCotton(5);
         }
         else if(id == 3 || id == 5 || id == 7)
         {
            this._airMap.mapSay(200 + id);
         }
      }
      
      public function finishBack(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack);
         var type:int = int(e.EventObj.Type);
         var num:int = int(e.EventObj.Done);
         switch(type)
         {
            case 165:
               if(num >= 5)
               {
                  this._airMap.mapSay(206);
               }
               else
               {
                  this._airMap.mapSay(201);
               }
               break;
            case 166:
               if(num >= 5)
               {
                  this.isZhi = true;
                  GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack);
                  finishSomethingReq.sendReq(167);
               }
               else
               {
                  this._airMap.mapSay(202);
               }
               break;
            case 167:
               if(num >= 2)
               {
                  this.isZhongzi = true;
                  this.needFlowerID = 9;
                  this._airMap.mapSay(209);
               }
               else
               {
                  this._airMap.mapSay(202);
               }
         }
      }
      
      private function useSkill(e:EventTaomee) : void
      {
         var userID:int = int(e.EventObj.userID);
         var action:int = int(e.EventObj.action);
         if(userID == LocalUserInfo.getUserID())
         {
            if(this.needFlowerID == 3)
            {
               if(action % 3 == 2)
               {
                  this._airMap.mapSay(204);
               }
            }
            else if(this.needFlowerID == 5)
            {
               if(action % 3 == 1)
               {
                  this._airMap.mapSay(206);
               }
            }
            else if(this.needFlowerID == 7)
            {
               if(action % 3 == 0)
               {
                  this._airMap.mapSay(208);
               }
            }
         }
      }
      
      private function finishBack1(e:EventTaomee) : void
      {
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack1);
         var type:int = int(e.EventObj.Type);
         var num:int = int(e.EventObj.Done);
         switch(type)
         {
            case 165:
               if(num >= 5)
               {
                  this._airMap.mapSay(106);
               }
               else
               {
                  this._airMap.mapSay(101);
               }
               break;
            case 166:
               if(num >= 5)
               {
                  GV.onlineSocket.addEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack1);
                  finishSomethingReq.sendReq(167);
               }
               else
               {
                  this._airMap.mapSay(102);
               }
               break;
            case 167:
               if(num >= 2)
               {
                  this._airMap.mapSay(109);
               }
               else
               {
                  this._airMap.mapSay(102);
               }
         }
      }
      
      public function destroy() : void
      {
         SystemEventManager.removeEventListener("blower_initCotton",this.onInitCotton);
         SystemEventManager.removeEventListener("blower_playCotton",this.onPlayCotton);
         SystemEventManager.removeEventListener("blower_getCotton",this.onGetCotton);
         SystemEventManager.removeEventListener("flower_flowerFun",this.initFlower);
         GV.onlineSocket.removeEventListener("read_" + 1212,this.useSkill);
         GV.onlineSocket.removeEventListener("read_" + 5700,this.getCottonBack);
         GV.onlineSocket.removeEventListener(finishSomethingRes.FINISH_SOMETHING_SUCC,this.finishBack1);
      }
   }
}

