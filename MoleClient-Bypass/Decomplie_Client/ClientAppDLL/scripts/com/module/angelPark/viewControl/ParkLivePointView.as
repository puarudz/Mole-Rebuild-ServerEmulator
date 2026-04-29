package com.module.angelPark.viewControl
{
   import com.common.Tween.TweenLite;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.angelPark.valueObj.GrowingAngelVO;
   import com.module.LocusWork.NumSprite;
   import com.module.angelPark.AngelParkView;
   import com.module.angelPark.ParkDragCtl;
   import com.module.angelPark.data.AngelParkDataCtl;
   import com.module.popupMsg.PopupMsgCtl;
   import com.view.PeopleView.PeopleManageView;
   import fl.transitions.easing.Bounce;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ParkLivePointView
   {
      
      private static const GrowUpAndVariated:int = 3;
      
      private static const GrowUp:int = 2;
      
      private static const Growing:int = 1;
      
      private var _angelData:GrowingAngelVO;
      
      private var _angelMC:MovieClip;
      
      protected var _angelParkData:AngelParkDataCtl = AngelParkView.instance.parkDataCtl;
      
      private var _angelStateMC:MovieClip;
      
      private var _btn:Sprite;
      
      private var _lockMC:MovieClip;
      
      private var _locked:Boolean = false;
      
      private var _moving:Boolean = false;
      
      private var _posId:int;
      
      private var _ui:MovieClip;
      
      private var _useSeedLock:Boolean = false;
      
      private var _useItemLock:Boolean = false;
      
      public function ParkLivePointView(ui:MovieClip, posId:int)
      {
         super();
         this._ui = ui;
         this._ui.buttonMode = true;
         this._ui.mouseEnabled = true;
         this._ui.mouseChildren = true;
         this._posId = posId;
         this._btn = new Sprite();
         this._ui.graphics.beginFill(0,0);
         this._ui.graphics.drawRect(0,0,this._ui.width,this._ui.height);
         this._ui.graphics.endFill();
         this._ui.container_mc.addChild(this._btn);
      }
      
      public function Clear() : void
      {
         BC.removeEvent(this);
         this._angelData = null;
      }
      
      public function UpdateAngel() : void
      {
         var loader:Loader = null;
         var id:String = null;
         var path:String = null;
         var angelData:GrowingAngelVO = this._angelParkData.GetGrowingAngelInfoByPosId(this._posId);
         if(Boolean(this._angelData && angelData) && Boolean(angelData.index == this._angelData.index) && angelData.variateId == this._angelData.variateId)
         {
            this._angelData = angelData;
            this.UpdateAngelData();
         }
         else
         {
            this._angelData = angelData;
            BC.removeEvent(this);
            GC.clearAllChildren(this._btn);
            this._angelMC = null;
            if(this.hasAngel)
            {
               loader = new Loader();
               id = this._angelData.id.toString();
               if(angelData.variateId > 0)
               {
                  id = angelData.variateId + "_1";
               }
               path = "resource/angelPark/items/swf/" + id + ".swf";
               loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.AngelMCLoadOk);
               loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.AngelMCLoadError);
               loader.load(VL.getURLRequest(path));
            }
            else
            {
               this.AddEvent();
               if(this._angelParkData.angelParkVO.exp == 0)
               {
                  this._ui.gotoAndStop(GrowUpAndVariated);
               }
               else
               {
                  this._ui.gotoAndStop(Growing);
               }
            }
         }
      }
      
      public function get hasAngel() : Boolean
      {
         return Boolean(this._angelData) ? true : false;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(value:Boolean) : void
      {
         this._locked = value;
         if(this._locked)
         {
            this.visible = true;
            this._lockMC = GV.Lib_Map.getMovieClip("lock_mc") as MovieClip;
            this._ui.addChild(this._lockMC);
            this._ui.gotoAndStop(1);
         }
         else if(Boolean(this._lockMC))
         {
            this._lockMC.visible = false;
            this._lockMC.parent.removeChild(this._lockMC);
            this._lockMC = null;
         }
      }
      
      public function get ui() : MovieClip
      {
         return this._ui;
      }
      
      public function get visible() : Boolean
      {
         return this._ui.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._ui.visible = value;
         if(value)
         {
            this.AddEvent();
         }
         else
         {
            this.RemoveEvent();
         }
      }
      
      private function AddEvent() : void
      {
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.LET_ANGEL_GO_EVENT,this.LetAngelGoHandler);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.USE_ITEM_EFFECT_EVENT,this.UseItemHandler);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.UPDATE_ANGEL_EFFECT_EVENT,this.UpdateAngelEffect);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.ANGEL_MADE_CHANGE_EVENT,this.AngelMadeChangeHandler);
         BC.addEvent(this,this._angelParkData,AngelParkDataCtl.ANGEL_RANDOM_MOVE_EFFECT_EVENT,this.AngelRandomMoveHandler);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OVER,this.OnMouseOver);
         BC.addEvent(this,this._ui,MouseEvent.MOUSE_OUT,this.OnMouseOut);
         BC.addEvent(this,this._ui,MouseEvent.CLICK,this.OnMouseClick);
         if(Boolean(this._angelMC))
         {
            BC.addEvent(this,this._angelMC,"angel_mc_event",this.AngelMCChangeHandler);
         }
      }
      
      private function UseItemHandler(e:EventTaomee) : void
      {
         var useItemEffect:MovieClip = null;
         var mc:Sprite = null;
         var index:int = int(e.EventObj.index);
         var itemId:int = int(e.EventObj.itemId);
         if(this.hasAngel && this._angelData.index == index)
         {
            useItemEffect = this.GetItemEffectMC(itemId);
            mc = new Sprite();
            GV.MC_mapTop.addChild(mc);
            mc.x = this._ui.x;
            mc.y = this._ui.y;
            mc.addChild(useItemEffect);
            with({})
            {
               
               setTimeout(function fun():void
               {
                  GC.clearAll(mc);
                  UpdateAngel();
               },1500);
            }
         }
         
         private function GetItemEffectMC(itemId:int) : MovieClip
         {
            var numMC:NumSprite = null;
            var jianMC:MovieClip = null;
            var jiaMC:MovieClip = null;
            var effectInfo:Object = XMLInfo.angelItemEffectTip[itemId];
            var effectValue:int = int(effectInfo.value);
            var useType:int = int(effectInfo.type);
            var useItemEffect:MovieClip = null;
            if(useType == 1)
            {
               useItemEffect = GV.Lib_Map.getMovieClip("useItem_effect") as MovieClip;
               numMC = new NumSprite(useItemEffect.tip_mc.tipNum_mc,effectValue,false);
               jianMC = MovieClip(numMC.content).jian_mc;
               if(effectValue < 100)
               {
                  if(effectValue < 10)
                  {
                     jianMC.x += 125 * 2;
                  }
                  else
                  {
                     jianMC.x += 125;
                  }
               }
               return useItemEffect;
            }
            if(useType == 2)
            {
               if(effectValue == 100)
               {
                  useItemEffect = GV.Lib_Map.getMovieClip("variateRateFull_effect") as MovieClip;
               }
               else
               {
                  useItemEffect = GV.Lib_Map.getMovieClip("variateRate_effect") as MovieClip;
                  numMC = new NumSprite(useItemEffect.tip_mc.tipNum_mc,effectValue,false);
                  jiaMC = MovieClip(numMC.content).jia_mc;
                  if(effectValue < 100)
                  {
                     if(effectValue < 10)
                     {
                        jiaMC.x += 125 * 2;
                     }
                     else
                     {
                        jiaMC.x += 125;
                     }
                  }
               }
               return useItemEffect;
            }
            throw new Error(itemId + "的useType" + useType + "值不正確");
         }
         
         private function AngelMCChangeHandler(e:EventTaomee) : void
         {
            this._angelStateMC = e.EventObj as MovieClip;
            if(this._angelData.state == 0)
            {
               this.angelStateMC.gotoAndStop(3);
            }
            else if(this._angelData.state == 1)
            {
               this.angelStateMC.gotoAndStop(1);
            }
         }
         
         private function AngelMCLoadError(e:IOErrorEvent) : void
         {
            var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
            loaderInfo.removeEventListener(Event.COMPLETE,this.AngelMCLoadOk);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.AngelMCLoadError);
            throw new Error("天使素材加載錯誤:" + this._angelData.id);
         }
         
         private function AngelMCLoadOk(e:Event) : void
         {
            var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
            loaderInfo.removeEventListener(Event.COMPLETE,this.AngelMCLoadOk);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.AngelMCLoadError);
            this._angelMC = loaderInfo.content as MovieClip;
            this._angelMC = this._angelMC.getChildAt(0) as MovieClip;
            this._angelMC.scaleX = 0.5;
            this._angelMC.scaleY = 0.5;
            this._btn.addChild(this._angelMC);
            loaderInfo = null;
            this.AddEvent();
            this.UpdateAngelData();
         }
         
         private function AngelMadeChangeHandler(e:EventTaomee) : void
         {
            var name:String = null;
            var madeChangeEffect:MovieClip = null;
            var mc:Sprite = null;
            var addExpMC:MovieClip = null;
            var mainPeople:PeopleManageView = null;
            var index:int = int(e.EventObj.index);
            var exp:int = int(e.EventObj.exp);
            if(this.hasAngel && this._angelData.index == index)
            {
               name = GoodsInfo.getItemNameByID(this._angelData.id);
               if(this._angelData.variateId > 0)
               {
                  name = GoodsInfo.getItemNameByID(this._angelData.variateId);
               }
               madeChangeEffect = GV.Lib_Map.getMovieClip("madeChange_effect") as MovieClip;
               mc = new Sprite();
               GV.MC_mapTop.addChild(mc);
               mc.x = this._ui.x;
               mc.y = this._ui.y;
               mc.addChild(madeChangeEffect);
               addExpMC = GV.Lib_Map.getMovieClip("addExp_mc") as MovieClip;
               addExpMC.tipsTxt.value_txt.text = int(e.EventObj.exp) - this._angelParkData.angelParkVO.exp;
               mainPeople = PeopleManageView(GV.MAN_PEOPLE);
               GV.MC_mapTop.addChild(addExpMC);
               addExpMC.x = mainPeople.x;
               addExpMC.y = mainPeople.y;
               AngelPopupView.instance.CloseAngelTip();
               with({})
               {
                  
                  setTimeout(function fun():void
                  {
                     PopupMsgCtl.PopupMsg("成功建立契約，一個" + name + "進入天使聖殿了");
                     GC.clearAll(mc);
                     GC.clearAll(addExpMC);
                     UpdateAngel();
                  },1000);
               }
            }
            
            private function AngelRandomMoveHandler(e:EventTaomee) : void
            {
               var index:int = int(e.EventObj);
               if(this.hasAngel && this._angelData.index == index)
               {
                  this.RandomMove();
               }
            }
            
            private function LetAngelGoHandler(e:EventTaomee) : void
            {
               var letGoEffect:MovieClip = null;
               var mc:Sprite = null;
               var index:int = int(e.EventObj);
               if(this.hasAngel && this._angelData.index == index)
               {
                  letGoEffect = GV.Lib_Map.getMovieClip("letGo_effect") as MovieClip;
                  mc = new Sprite();
                  GV.MC_mapTop.addChild(mc);
                  mc.x = this._ui.x;
                  mc.y = this._ui.y;
                  mc.addChild(letGoEffect);
                  with({})
                  {
                     
                     setTimeout(function fun():void
                     {
                        GC.clearAll(mc);
                        UpdateAngel();
                     },500);
                  }
               }
               
               private function OnMouseClick(e:MouseEvent) : void
               {
                  if(!this._angelParkData.isMyPark)
                  {
                     return;
                  }
                  if(this._locked)
                  {
                     return;
                  }
                  if(ParkDragCtl.dragType == ParkDragCtl.Type_NULL)
                  {
                     if(this.hasAngel)
                     {
                        AngelPopupView.instance.ShowControlBtns(this._angelData.index,this._ui);
                     }
                     else
                     {
                        AngelParkView.instance.parkManageToolBar.ShowFeatureToolBar();
                        AngelParkView.instance.parkManageToolBar.featureToolBar.ShowWareHouseBar();
                     }
                     return;
                  }
                  if(ParkDragCtl.dragType == ParkDragCtl.Type_Seed)
                  {
                     if(!this.hasAngel && this._useSeedLock == false)
                     {
                        this._useSeedLock = true;
                        with({})
                        {
                           
                           setTimeout(function handler():void
                           {
                              _useSeedLock = false;
                           },1000);
                        }
                        return;
                     }
                     if(ParkDragCtl.dragType == ParkDragCtl.Type_Item)
                     {
                        if(this.hasAngel && this._useItemLock == false)
                        {
                           this._useItemLock = true;
                           with({})
                           {
                              
                              setTimeout(function handler():void
                              {
                                 _useItemLock = false;
                              },1000);
                           }
                           return;
                        }
                     }
                     
                     private function OnMouseOut(e:MouseEvent) : void
                     {
                        if(this._locked)
                        {
                           GF.clearTip();
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_NULL)
                        {
                           if(this.hasAngel)
                           {
                              AngelPopupView.instance.CloseAngelTip();
                           }
                           else
                           {
                              GF.clearTip();
                           }
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_Seed)
                        {
                           ParkDragCtl.ShowBanIcon();
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_Item)
                        {
                           ParkDragCtl.ShowBanIcon();
                           return;
                        }
                     }
                     
                     protected function OnMouseOver(e:MouseEvent) : void
                     {
                        var unlockAngelCountInfo:Object = null;
                        this.RandomMove();
                        if(this._locked)
                        {
                           unlockAngelCountInfo = this._angelParkData.angelParkVO.UnLockAngelCountInfo;
                           GF.showTip(unlockAngelCountInfo.level + "級後解鎖");
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_NULL)
                        {
                           if(this.hasAngel)
                           {
                              AngelPopupView.instance.ShowAngelTip(this._angelData.index);
                           }
                           else
                           {
                              GF.showTip("可以培育天使");
                           }
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_Seed)
                        {
                           if(this.hasAngel)
                           {
                              ParkDragCtl.ShowBanIcon();
                           }
                           else
                           {
                              ParkDragCtl.HideBanIcon();
                           }
                           return;
                        }
                        if(ParkDragCtl.dragType == ParkDragCtl.Type_Item)
                        {
                           if(this.hasAngel)
                           {
                              ParkDragCtl.HideBanIcon();
                           }
                           else
                           {
                              ParkDragCtl.ShowBanIcon();
                           }
                           return;
                        }
                     }
                     
                     private function RandomMove() : void
                     {
                        if(this._moving)
                        {
                           return;
                        }
                        this._moving = true;
                        TweenLite.to(this._ui,2,{
                           "y":this._ui.y + 10,
                           "onComplete":this.MoveBack,
                           "easeOut":Bounce.easeIn
                        });
                     }
                     
                     private function MoveBack() : void
                     {
                        if(this._moving)
                        {
                           TweenLite.to(this._ui,2,{
                              "y":this._ui.y - 10,
                              "onComplete":this.MoveStop,
                              "easeOut":Bounce.easeIn
                           });
                        }
                     }
                     
                     private function MoveStop() : void
                     {
                        this._moving = false;
                     }
                     
                     private function RemoveEvent() : void
                     {
                        BC.removeEvent(this);
                     }
                     
                     private function UpdateAngelData() : void
                     {
                        if(this.hasAngel)
                        {
                           if(this._angelMC.currentFrame != this._angelData.growLevel)
                           {
                              this._angelMC.gotoAndStop(this._angelData.growLevel);
                           }
                           if(this._angelData.isGorwUp)
                           {
                              if(this._angelData.variateId > 0)
                              {
                                 this._ui.gotoAndStop(GrowUpAndVariated);
                              }
                              else
                              {
                                 this._ui.gotoAndStop(GrowUp);
                              }
                           }
                           else
                           {
                              this._ui.gotoAndStop(Growing);
                           }
                        }
                     }
                     
                     private function UpdateAngelEffect(e:EventTaomee) : void
                     {
                        var randomValue:Number = NaN;
                        var randomTalkLimit:Number = NaN;
                        var index:int = int(e.EventObj);
                        if(this.hasAngel)
                        {
                           if(this._angelData.index == index)
                           {
                              randomValue = Math.random();
                              randomTalkLimit = 0.4;
                              if(randomValue < randomTalkLimit)
                              {
                                 if(this._angelData.variateId > 0)
                                 {
                                    AngelPopupView.instance.ShowAngelRandomTalk(this._angelData.variateId,this._angelData.growLevel,this._angelData.state,this._ui);
                                 }
                                 else
                                 {
                                    AngelPopupView.instance.ShowAngelRandomTalk(this._angelData.id,this._angelData.growLevel,this._angelData.state,this._ui);
                                 }
                                 if(this._angelData.state == 1)
                                 {
                                    this.angelStateMC.gotoAndStop(2);
                                 }
                                 this.UpdateAngel();
                              }
                           }
                           else if(this._angelData.state == 0)
                           {
                              this.angelStateMC.gotoAndStop(3);
                           }
                           else if(this._angelData.state == 1)
                           {
                              this.angelStateMC.gotoAndStop(1);
                           }
                        }
                     }
                     
                     private function get angelStateMC() : MovieClip
                     {
                        if(Boolean(this._angelStateMC))
                        {
                           return this._angelStateMC;
                        }
                        return new MovieClip();
                     }
                  }
               }
               
               