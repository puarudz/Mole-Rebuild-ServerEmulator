package com.module.specialTool
{
   import com.common.data.PageListData;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.util.DisplayUtil;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.core.manager.IndexManager;
   import com.core.manager.UIManager;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.FindPathLogic.MoveTo;
   import com.logic.lamuMantraLogic.LamuMantra;
   import com.logic.socket.becomeCorpse.BecomeCorpseSocket;
   import com.logic.socket.becomeCorpse.BecomeHatSocket;
   import com.logic.socket.throwItem.RemovEffectReq;
   import com.logic.socket.throwItem.RemovEffectRes;
   import com.logic.socket.throwItem.ThrowEffectItemRes;
   import com.logic.socket.throwItem.ThrowItemReq;
   import com.logic.socket.throwItem.ThrowItemRes;
   import com.logic.socket.waterTub.WaterTubOverTimeRes;
   import com.logic.socket.waterTub.WaterTupRes;
   import com.module.throwThing.throwThing;
   import com.mole.app.ui.BagTip;
   import com.view.PeopleView.ChildPeople.BoyAvatar;
   import com.view.PeopleView.HitConditional;
   import com.view.PeopleView.PeopleManageView;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import flash.ui.Mouse;
   import flash.utils.setTimeout;
   
   public class specialView extends MovieClip
   {
      
      public static var Collimation:MovieClip;
      
      public static var magicWand:MovieClip;
      
      public static var magicPeopelID:Number;
      
      public static var owner:specialView;
      
      public static var onlyOne:int;
      
      private static const PAGE_COUNT:int = 25;
      
      public static var status:Boolean = false;
      
      private var tempArrLen:uint;
      
      private var thisMC:MovieClip;
      
      private var thingMC:MovieClip;
      
      private var throwThingClass:throwThing;
      
      private var throwItemReq:ThrowItemReq;
      
      private var removEffectReq:RemovEffectReq;
      
      private var _itemPageData:PageListData;
      
      public function specialView(obj:MovieClip)
      {
         super();
         owner = this;
         this.thisMC = obj;
         var tempmation:Class = UIManager.getClass("CollimationMC");
         var tempMagic:Class = UIManager.getClass("magicWand");
         Collimation = new tempmation();
         magicWand = new tempMagic();
         this.throwThingClass = new throwThing();
         BagTip.tip_Class = UIManager.getClass("Tip_mc");
         GV.throwThingClass = this.throwThingClass;
         BC.addEvent(this,GV.onlineSocket,RemovEffectRes.REMOVE_EFFECT_SUCC,this.removeEffectResetPeople);
         BC.addEvent(this,GV.onlineSocket,ThrowItemRes.THROW_ITEM,this.throwThingStart);
         BC.addEvent(this,GV.onlineSocket,ThrowEffectItemRes.EFFECT_ITEM,this.effectChangePeople);
         BC.addEvent(this,GV.onlineSocket,ThrowEffectItemRes.EFFECT_TIME,this.effectResetPeople);
         BC.addEvent(this,GV.onlineSocket,BecomeCorpseSocket.CORPSE_MOLE_CHAGE,this.ChangePeopleStockpot);
         BC.addEvent(this,GV.onlineSocket,BecomeCorpseSocket.CORPSE_MOLE_RENEW,this.ResetPeopleStockpot);
         BC.addEvent(this,GV.onlineSocket,WaterTupRes.WATERTUB,this.ChangePeopleStockpot);
         BC.addEvent(this,GV.onlineSocket,WaterTubOverTimeRes.OVER_TIME,this.ResetPeopleStockpot);
         BC.addEvent(this,GV.onlineSocket,BecomeCorpseSocket.CORPSE_LAHM_CHAGE,this.ChangeLamuStockpot);
         BC.addEvent(this,GV.onlineSocket,BecomeCorpseSocket.CORPSE_LAHM_RENEW,this.ResetLamuStockpot);
         BC.addEvent(this,GV.onlineSocket,BecomeHatSocket.HAT_LAHM_CHANGE,this.ChangeLamuStockpot);
         BC.addEvent(this,GV.onlineSocket,BecomeHatSocket.HAT_LAHM_RENEW,this.ResetLamuStockpot);
         BC.addEvent(this,GV.onlineSocket,"CMD_" + CommandID.GET_BIRTHDAY_CLOTH,this.ChangePeopleStockpot);
         BC.addEvent(this,GV.onlineSocket,"CMD_" + CommandID.DEL_BIRTHDAY_CLOTH,this.ResetPeopleStockpot);
         BC.addEvent(this,this.thisMC.pre_btn,MouseEvent.CLICK,this.PrePage);
         BC.addEvent(this,this.thisMC.next_btn,MouseEvent.CLICK,this.NextPage);
      }
      
      public static function showTip(name:String, str:String = "", obj:* = null) : void
      {
         var tip_mc:BagTip = new BagTip();
         tip_mc.message = str;
         tip_mc.txtName(name);
         tip_mc.addBGY = 20;
         tip_mc.name_txtY = 3;
         var tf:TextFormat = new TextFormat();
         tf.bold = false;
         tf.font = "宋體";
         tf.size = 12;
         tip_mc.txtNameFormat(tf);
         tip_mc.data = obj;
         MainManager.getRootMC().addChild(tip_mc);
      }
      
      public static function clearTip() : void
      {
         BagTip.hideTip();
      }
      
      public static function playMC() : void
      {
         magicWand.gotoAndStop(2);
      }
      
      public static function stopMC() : void
      {
         magicWand.gotoAndStop(1);
      }
      
      public static function changePeople(UserID:uint) : void
      {
         var tempMagic_mc:MovieClip = null;
         var tempPeopleMC2:PeopleManageView = GF.getPeopleByID(UserID) as PeopleManageView;
         if(Boolean(tempPeopleMC2))
         {
            tempPeopleMC2.avatarMC.shadow_mc.visible = false;
            tempMagic_mc = IndexManager.getInstance().getMovieClip("magic_mc") as MovieClip;
            tempMagic_mc.name = "Magic_mc";
            tempPeopleMC2.avatarMC.addChildAt(tempMagic_mc,0);
            tempPeopleMC2.avatarClass.ResetAndDisposeBmp();
         }
      }
      
      public function PrePage(e:MouseEvent) : Boolean
      {
         if(this._itemPageData.prev())
         {
            this.showSpecial();
            return true;
         }
         return false;
      }
      
      public function NextPage(e:MouseEvent) : Boolean
      {
         if(this._itemPageData.next())
         {
            this.showSpecial();
            return true;
         }
         return false;
      }
      
      private function onButtonMouseOver(E:EventTaomee) : void
      {
         var tempObj:Object = E.EventObj;
         if(tempObj.Type == HitConditional.MAGIC_BAR)
         {
            magicPeopelID = tempObj.People.id;
            playMC();
            MoveTo.CanMove = false;
         }
      }
      
      private function onButtonMouseOot(E:EventTaomee) : void
      {
         var tempObj:Object = E.EventObj;
         if(tempObj.Type == HitConditional.MAGIC_BAR)
         {
            magicPeopelID = 0;
            stopMC();
            MoveTo.CanMove = true;
         }
      }
      
      public function binding() : void
      {
         this._itemPageData = new PageListData(GV.SpecialArr,PAGE_COUNT);
         this.showSpecial();
      }
      
      private function showSpecial() : void
      {
         var itemInfo:Object = null;
         var itemMC:MovieClip = null;
         var itemIconMC:MovieClip = null;
         var iconLoader:Loader = null;
         this.thisMC.page_txt.text = this._itemPageData.curPage + "/" + this._itemPageData.totalPage;
         var curPageList:Array = this._itemPageData.getCurrentPageData();
         for(var i:uint = 0; i < PAGE_COUNT; i++)
         {
            itemInfo = curPageList[i];
            itemMC = this.thisMC["mc" + i];
            itemIconMC = itemMC.icon_mc;
            GC.clearAllChildren(itemIconMC);
            if(Boolean(itemInfo))
            {
               if(itemInfo.id == "17036")
               {
                  if(Boolean(itemMC) && Boolean(itemMC.btn))
                  {
                     BC.removeEvent(this,itemMC.btn,MouseEvent.CLICK,this.showAimer);
                     BC.removeEvent(this,itemMC.btn,MouseEvent.MOUSE_OVER,this.mouseFun);
                     BC.removeEvent(this,itemMC.btn,MouseEvent.MOUSE_OUT,this.mouseFun);
                     itemMC.btn.enabled = false;
                  }
                  itemMC.num_txt.text = "";
               }
               else
               {
                  itemMC.num_txt.text = itemInfo.itemCount;
                  itemMC.id = itemInfo.id;
                  itemMC.itemName = GoodsInfo.getItemNameByID(itemInfo.id);
                  iconLoader = new Loader();
                  iconLoader.load(VL.getURLRequest(GoodsInfo.GetFullURLByItemId(itemInfo.id)));
                  itemIconMC.addChild(iconLoader);
                  if(itemInfo.id == "150015" || itemInfo.id == "150016" || itemInfo.id == "150012" || itemInfo.id == "150001" || itemInfo.id == "17009" || itemInfo.id == "150018")
                  {
                     itemMC.num_txt.visible = false;
                  }
                  else
                  {
                     itemMC.num_txt.visible = true;
                  }
                  itemMC.i = i;
                  BC.addEvent(this,itemMC.btn,MouseEvent.CLICK,this.showAimer);
                  BC.addEvent(this,itemMC.btn,MouseEvent.MOUSE_OVER,this.mouseFun);
                  BC.addEvent(this,itemMC.btn,MouseEvent.MOUSE_OUT,this.mouseFun);
                  itemMC.btn.enabled = true;
               }
            }
            else
            {
               if(Boolean(itemMC) && Boolean(itemMC.btn))
               {
                  BC.removeEvent(this,itemMC.btn,MouseEvent.CLICK,this.showAimer);
                  BC.removeEvent(this,itemMC.btn,MouseEvent.MOUSE_OVER,this.mouseFun);
                  BC.removeEvent(this,itemMC.btn,MouseEvent.MOUSE_OUT,this.mouseFun);
                  itemMC.btn.enabled = false;
               }
               itemMC.num_txt.text = "";
            }
         }
      }
      
      private function mouseFun(e:MouseEvent) : void
      {
         var mc:Sprite = e.currentTarget["parent"] as Sprite;
         var itemName:String = mc["itemName"];
         var tempPoint:Point = (e.currentTarget as SimpleButton).localToGlobal(new Point(e.currentTarget.x + 35,e.currentTarget.y + 35));
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            showTip(itemName,"",{
               "noDelay":true,
               "x":tempPoint.x,
               "y":tempPoint.y,
               "isHtml":true
            });
         }
         else
         {
            clearTip();
         }
      }
      
      private function showAimer(e:MouseEvent) : void
      {
         if(onlyOne == 0)
         {
            this.thisMC.x = 1500;
            this.thingMC = e.target.parent;
            this.showCollimation();
         }
         else if(onlyOne == e.target.parent.id)
         {
            this.thisMC.x = 1500;
            this.thingMC = e.target.parent;
            this.showCollimation();
         }
      }
      
      public function showCollimation() : void
      {
         if(this.thingMC.id > 17000 && this.thingMC.id < 150001)
         {
            HitConditional.HitType = HitConditional.MAGIC_BAR;
            MainManager.getAppLevel().parent.addChild(magicWand);
            magicWand.mouseEnabled = false;
            magicWand.mouseChildren = false;
            GV.MC_mapFrame["control_mc"].mouseEnabled = false;
            GV.MC_mapFrame["control_mc"].mouseChildren = false;
            magicWand.startDrag(true);
            BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN,this.showMagicReq);
            BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.moveThrow);
            BC.addEvent(this,HitConditional,MouseEvent.MOUSE_OVER,this.onButtonMouseOver);
            BC.addEvent(this,HitConditional,MouseEvent.MOUSE_OUT,this.onButtonMouseOot);
            status = true;
         }
         else
         {
            MainManager.getTopLevel().addChild(Collimation);
            GV.MC_mapFrame.mouseEnabled = false;
            GV.MC_mapFrame.mouseChildren = false;
            Collimation.mouseEnabled = false;
            Collimation.mouseChildren = false;
            Collimation.startDrag(true);
            BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN,this.throwThingReq);
            BC.addEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.Collimationmove);
         }
         MoveTo.CanMove = false;
         Mouse.hide();
      }
      
      public function throwThingReq(e:MouseEvent) : void
      {
         MoveTo.CanMove = false;
         if(!this.throwItemReq)
         {
            this.throwItemReq = new ThrowItemReq();
         }
         if((!GV.isSitDown || GV.MapInfo_mapID == 17 || GV.MapInfo_mapID == 15) && !GV.isGameShowTip)
         {
            setTimeout(function():void
            {
               MoveTo.CanMove = true;
            },50);
         }
         this.throwItemReq.throwItem(this.thingMC.id,e.stageX + Math.floor(Math.random() * 10) - 5,e.stageY + Math.floor(Math.random() * 10) - 5);
         GV.MC_mapFrame.mouseEnabled = true;
         GV.MC_mapFrame.mouseChildren = true;
      }
      
      public function throwThingStart(E:EventTaomee) : void
      {
         var tmpPeopleView:PeopleManageView = GF.getPeopleByID(E.EventObj.UserID);
         if(Boolean(tmpPeopleView))
         {
            tmpPeopleView.Throw_selected = E.EventObj.ItemID;
            tmpPeopleView.avatarClass.throwThing({
               "X":E.EventObj.EndX,
               "Y":E.EventObj.EndY
            });
            if(E.EventObj.UserID == LocalUserInfo.getUserID())
            {
               this.throwThingFun();
            }
         }
      }
      
      public function throwThingFun() : void
      {
         Mouse.show();
         Collimation.stopDrag();
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN,this.throwThingReq);
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.Collimationmove);
         setTimeout(function():void
         {
            if(!GV.isSitDown && !GV.isGameShowTip)
            {
               MoveTo.CanMove = true;
            }
            DisplayUtil.removeForParent(Collimation,false);
         },200);
      }
      
      private function Collimationmove(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      private function moveThrow(evt:MouseEvent) : void
      {
         evt.updateAfterEvent();
      }
      
      public function clearMS() : void
      {
         GV.MC_mapFrame["control_mc"].mouseEnabled = true;
         GV.MC_mapFrame["control_mc"].mouseChildren = true;
         GV.MC_mapFrame.mouseEnabled = true;
         GV.MC_mapFrame.mouseChildren = true;
         Mouse.show();
         status = false;
         magicPeopelID = 0;
         this.stopDrag();
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN);
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE);
         if(!GV.isSitDown && !GV.isGameShowTip)
         {
            MoveTo.CanMove = true;
         }
         DisplayUtil.removeForParent(Collimation,false);
         magicWand.gotoAndStop(1);
         DisplayUtil.removeForParent(magicWand,false);
      }
      
      private function showMagicReq(evt:MouseEvent) : void
      {
         HitConditional.HitType = HitConditional.USER_PAN;
         GV.MC_mapFrame["control_mc"].mouseEnabled = true;
         GV.MC_mapFrame["control_mc"].mouseChildren = true;
         Mouse.show();
         magicWand.stopDrag();
         magicWand.gotoAndStop(1);
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_DOWN,this.showMagicReq);
         BC.removeEvent(this,MainManager.getStage(),MouseEvent.MOUSE_MOVE,this.moveThrow);
         BC.removeEvent(this,HitConditional);
         if(magicPeopelID != 0 && LamuMantra.currentMagic != "xingchenshouhu")
         {
            if(this.thingMC.id == 17009)
            {
               if(!this.removEffectReq)
               {
                  this.removEffectReq = new RemovEffectReq();
               }
               this.removEffectReq.removeffect(magicPeopelID,this.thingMC.id);
            }
            else
            {
               if(!this.throwItemReq)
               {
                  this.throwItemReq = new ThrowItemReq();
               }
               this.throwItemReq.throwEffectItem(this.thingMC.id,magicPeopelID);
            }
         }
         magicPeopelID = 0;
         if(!GV.isSitDown && !GV.isGameShowTip)
         {
            MoveTo.CanMove = true;
         }
         setTimeout(function():void
         {
            status = false;
            try
            {
               magicWand.parent.removeChild(magicWand);
            }
            catch(E:Error)
            {
            }
         },200);
      }
      
      private function effectChangePeople(evt:EventTaomee) : void
      {
         var tempObj:Object = null;
         var tempPeopleMC:PeopleManageView = null;
         var tac:* = undefined;
         try
         {
            tempObj = evt.EventObj;
            this.setShine(tempObj);
            if(tempObj.OtherID == 0)
            {
               return;
            }
            tempPeopleMC = GF.getPeopleByID(tempObj.OtherID) as PeopleManageView;
            tempPeopleMC.avatarMC.addChild(IndexManager.getInstance().getMovieClip("yanwu_mc"));
            if(Boolean(tempPeopleMC))
            {
               if(tempObj.OtherID == 0)
               {
                  return;
               }
               tac = tempPeopleMC.avatarClass;
               if(tempPeopleMC.address == "17003" || tempPeopleMC.address == "120000")
               {
                  tempPeopleMC.Action = 0;
                  tempPeopleMC.avatarMC.Visualize_mc.scaleX = tempPeopleMC.avatarMC.Visualize_mc.scaleY = 1;
               }
               tempPeopleMC.Action = tempObj.ItemID;
               tempPeopleMC.getVisualize(tempPeopleMC,1,tempObj.ItemID);
               if(tempObj.UserID != 0)
               {
                  changePeople(tempObj.UserID);
               }
            }
         }
         catch(E:*)
         {
         }
      }
      
      private function removeEffectResetPeople(evt:EventTaomee) : void
      {
         var tempPeopleMC:PeopleManageView = null;
         var tac:* = undefined;
         var tempObj:* = evt.EventObj;
         tempObj.FlashTag = 2;
         var my:* = GF.getPeopleByID(evt.EventObj.ChangeID);
         if(Boolean(my))
         {
            this.setShine(tempObj);
            GF.showRemoveEffect(my);
            tempPeopleMC = GF.getPeopleByID(tempObj.UserID) as PeopleManageView;
            if(Boolean(tempPeopleMC))
            {
               tac = tempPeopleMC.avatarClass;
               if(tempPeopleMC.address == "17003" || tempPeopleMC.address == "120000")
               {
                  tempPeopleMC.Action = 0;
                  tempPeopleMC.scaleBody(1);
                  tempPeopleMC.getVisualize(tempPeopleMC,1,1);
                  tempPeopleMC.stopAction();
               }
               else if(!(tac as BoyAvatar))
               {
                  tempPeopleMC.Action = 0;
                  tempPeopleMC.getVisualize(tempPeopleMC,1,1);
                  tempPeopleMC.stopAction();
               }
            }
         }
      }
      
      private function effectResetPeople(evt:EventTaomee) : void
      {
         var tac:* = undefined;
         var tempObj:* = evt.EventObj;
         var tempPeopleMC:PeopleManageView = GF.getPeopleByID(tempObj.UserID) as PeopleManageView;
         if(Boolean(tempPeopleMC))
         {
            tac = tempPeopleMC.avatarClass;
            if(tempPeopleMC.address == "17003" || tempPeopleMC.address == "120000")
            {
               tempPeopleMC.Action = 0;
               tempPeopleMC.scaleBody(1);
               tempPeopleMC.getVisualize(tempPeopleMC,1,1);
               tempPeopleMC.stopAction();
            }
            else if(!(tac as BoyAvatar))
            {
               tempPeopleMC.Action = 0;
               tempPeopleMC.getVisualize(tempPeopleMC,1,1);
               tempPeopleMC.stopAction();
            }
         }
      }
      
      private function ChangePeopleStockpot(E:EventTaomee) : void
      {
         this.effectChangePeople(E);
      }
      
      private function ResetPeopleStockpot(E:EventTaomee) : void
      {
         this.effectResetPeople(E);
      }
      
      private function ChangeLamuStockpot(E:EventTaomee) : void
      {
         var tempObj:* = E.EventObj;
         var tempPeopleMC:PeopleManageView = GF.getPeopleByID(tempObj.UserID) as PeopleManageView;
         if(Boolean(tempPeopleMC))
         {
            tempPeopleMC.avatarMC.addChild(IndexManager.getInstance().getMovieClip("yanwu_mc"));
            tempPeopleMC.changeBat();
         }
      }
      
      private function ResetLamuStockpot(E:EventTaomee) : void
      {
         var tempObj:* = E.EventObj;
         var tempPeopleMC:PeopleManageView = GF.getPeopleByID(tempObj.UserID) as PeopleManageView;
         if(Boolean(tempPeopleMC))
         {
            tempPeopleMC.changeSuperPet();
         }
      }
      
      private function setShine(tempObj:Object) : void
      {
         var type:int = int(tempObj.FlashTag);
         if(type == 0)
         {
            return;
         }
         switch(type)
         {
            case 1:
               this.shineMcHandler(tempObj.ChangeID);
               break;
            case 2:
               this.shineMcHandler(tempObj.UserID);
               break;
            case 3:
               this.shineMcHandler(tempObj.ChangeID);
               this.shineMcHandler(tempObj.UserID);
         }
      }
      
      private function shineMcHandler(id:int) : void
      {
         var ShineMC:MovieClip = IndexManager.getInstance().getMovieClip("ShineMC");
         var mc:MovieClip = GF.getPeopleByID(id);
         mc.avatarMC.addChild(ShineMC);
      }
   }
}

