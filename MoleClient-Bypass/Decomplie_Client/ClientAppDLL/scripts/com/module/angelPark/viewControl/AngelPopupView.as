package com.module.angelPark.viewControl
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.common.tip.tip;
   import com.core.MainManager;
   import com.core.info.LocalUserInfo;
   import com.logic.socket.angelPark.valueObj.GrowingAngelVO;
   import com.module.angelPark.AngelParkView;
   import com.module.popupMsg.PopupMsgCtl;
   import com.view.MapManageView.MapButtonView;
   import com.view.baseViewCtl.ProgressbarControler;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class AngelPopupView
   {
      
      private static var _instance:AngelPopupView;
      
      private static var _canotNew:Boolean = true;
      
      private static const StateName:Array = ["休眠","舒適"];
      
      private var _container:Sprite;
      
      public var _showAngelBtnIndex:int;
      
      private var _tipUI:MovieClip;
      
      private var _randomtalkList:Array;
      
      public function AngelPopupView()
      {
         super();
         if(_canotNew)
         {
            throw new Error("AngelPopupView不能直接new , 用靜態方法 instance()!");
         }
      }
      
      public static function get instance() : AngelPopupView
      {
         if(!_instance)
         {
            _canotNew = false;
            _instance = new AngelPopupView();
            _canotNew = true;
         }
         return _instance;
      }
      
      public function ShowControlBtns(index:int, mc:MovieClip) : void
      {
         var startX:Number = NaN;
         var btns:MovieClip = null;
         this.CloseAngelTip();
         this.CloseControlBtns();
         var data:GrowingAngelVO = AngelParkView.instance.parkDataCtl.GetGrowingAngelInfoByIndex(index);
         if(Boolean(data))
         {
            this._showAngelBtnIndex = index;
            this._container = new Sprite();
            startX = 0;
            btns = GV.Lib_Map.getMovieClip("ctl_btns") as MovieClip;
            tip.tipTailDisPlayObject(btns.letGo_btn,"放生");
            BC.addEvent(this._container,btns.letGo_btn,MouseEvent.MOUSE_DOWN,this.LetGoHandler);
            tip.tipTailDisPlayObject(btns.useItem_btn,"使用道具");
            tip.tipTailDisPlayObject(btns.madeChange_btn,"建立契約");
            if(data.isGorwUp && data.madeChanging == false)
            {
               BC.addEvent(this._container,btns.madeChange_btn,MouseEvent.MOUSE_DOWN,this.MakeChangeHandler);
               btns.useItem_btn.buttonMode = false;
               btns.useItem_btn.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
            }
            else
            {
               btns.madeChange_btn.buttonMode = false;
               btns.madeChange_btn.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
               BC.addEvent(this._container,btns.useItem_btn,MouseEvent.MOUSE_DOWN,this.UseItemHandler);
            }
            this._container.addChild(btns);
            MainManager.getAppLevel().addChild(this._container);
            this._container.x = mc.x;
            this._container.y = mc.y;
            BC.addEvent(this._container,MainManager.getRootMC(),MouseEvent.MOUSE_DOWN,this.CloseBtnsHandler);
         }
      }
      
      private function CloseBtnsHandler(e:MouseEvent) : void
      {
         this.CloseControlBtns();
      }
      
      private function UseItemHandler(e:MouseEvent) : void
      {
         AngelParkView.instance.parkManageToolBar.ShowFeatureToolBar();
         AngelParkView.instance.parkManageToolBar.featureToolBar.ShowWareHouseKinds(ParkWarehouseToolBar.KIND_ITEM);
      }
      
      private function MakeChangeHandler(e:MouseEvent) : void
      {
         var data:GrowingAngelVO = AngelParkView.instance.parkDataCtl.GetGrowingAngelInfoByIndex(this._showAngelBtnIndex);
         data.madeChanging = true;
         AngelParkView.instance.parkDataCtl.MadeChange(this._showAngelBtnIndex);
      }
      
      private function LetGoHandler(e:MouseEvent) : void
      {
         var angelIndex:int = 0;
         var _temp_2:* = Alert;
         var _temp_1:* = "    你確定要將這個天使放生嗎？放生後就再也找不回來了。";
         with({})
         {
            _temp_2.smileAlart(_temp_1,function handler(e:Event):void
            {
               AngelParkView.instance.parkDataCtl.LetGoBeforeMadeChange(angelIndex);
            },"sure,cancel");
         }
         
         private function LetAngelGo(angelIndex:int) : void
         {
            AngelParkView.instance.parkDataCtl.LetGoBeforeMadeChange(angelIndex);
         }
         
         public function CloseControlBtns() : void
         {
            this._showAngelBtnIndex = -1;
            BC.removeEvent(this._container);
            if(Boolean(this._container) && Boolean(this._container.parent))
            {
               this._container.parent.removeChild(this._container);
            }
         }
         
         public function ShowAngelTip(index:int) : void
         {
            var bgMC:MovieClip = null;
            var containerMC:MovieClip = null;
            var nameTxt:TextField = null;
            var needTimeTxt:TextField = null;
            var stateMC:MovieClip = null;
            var starMC:MovieClip = null;
            var variateRateTxt:TextField = null;
            var grothBar:ProgressbarControler = null;
            var variateIdList:Array = null;
            var starValue:int = 0;
            var growthList:Array = null;
            var variateRateList:Array = null;
            var startY:Number = NaN;
            var i:int = 0;
            var variateInfoMC:MovieClip = null;
            this.CloseAngelTip();
            if(index == this._showAngelBtnIndex)
            {
               return;
            }
            var data:GrowingAngelVO = AngelParkView.instance.parkDataCtl.GetGrowingAngelInfoByIndex(index);
            if(Boolean(data))
            {
               if(!this._tipUI)
               {
                  this._tipUI = GV.Lib_Map.getMovieClip("angelTip_mc") as MovieClip;
               }
               bgMC = this._tipUI.bc_mc;
               containerMC = this._tipUI.container_mc;
               nameTxt = this._tipUI.name_txt;
               needTimeTxt = this._tipUI.needTime_txt;
               stateMC = this._tipUI.state_mc;
               starMC = this._tipUI.star_mc;
               variateRateTxt = this._tipUI.variateRate_txt;
               grothBar = new ProgressbarControler(this._tipUI.growthBar_mc);
               nameTxt.text = GoodsInfo.getItemNameByID(data.id);
               variateIdList = String(GoodsInfo.getInfoById(data.id).Variate).split(",");
               starValue = int(GoodsInfo.getInfoById(data.id).Star);
               if(data.variateId > 0)
               {
                  nameTxt.text = GoodsInfo.getItemNameByID(data.variateId);
                  starValue = int(GoodsInfo.getInfoById(data.variateId).Star);
                  if(variateIdList.indexOf(data.variateId.toString()) != -1)
                  {
                     nameTxt.appendText("(已變異)");
                  }
               }
               starMC.gotoAndStop(starValue + 1);
               if(data.isGorwUp)
               {
                  needTimeTxt.text = "已成年";
               }
               else
               {
                  needTimeTxt.text = "剩餘" + data.needTimeGrowUpToString;
               }
               stateMC.gotoAndStop(data.state + 1);
               growthList = String(GoodsInfo.getInfoById(data.id).LevelNum).split(",");
               grothBar.SetData(data.growth,Number(growthList[2]));
               GC.clearAllChildren(containerMC);
               variateRateList = String(GoodsInfo.getInfoById(data.id).Probability).split(",");
               if(variateIdList.length > 0)
               {
                  variateRateTxt.visible = true;
                  startY = 0;
                  for(i = 0; i < variateIdList.length; i++)
                  {
                     variateInfoMC = this.CreateVariateInfoMC(variateIdList[i],variateRateList[i],data.variateId,data.variateRate);
                     containerMC.addChild(variateInfoMC);
                     variateInfoMC.y = startY;
                     startY += variateInfoMC.height + 5;
                  }
                  bgMC.height = variateRateTxt.y + startY + 30;
               }
               else
               {
                  variateRateTxt.visible = false;
                  bgMC.height = variateRateTxt.y + 30;
               }
               MainManager.getAppLevel().addChild(this._tipUI);
               this._tipUI.x = MainManager.getAppLevel().mouseX + 10;
               this._tipUI.y = MainManager.getAppLevel().mouseY + 10;
               if(this._tipUI.x + this._tipUI.width > 960)
               {
                  this._tipUI.x = MainManager.getAppLevel().mouseX - this._tipUI.width;
               }
               if(this._tipUI.y + this._tipUI.height > 560)
               {
                  this._tipUI.y = MainManager.getAppLevel().mouseY - this._tipUI.height;
               }
            }
            else
            {
               this.CloseAngelTip();
            }
         }
         
         private function CreateVariateInfoMC(itemId:String, rate:String, variatedId:int, addVariatedRate:int) : MovieClip
         {
            var abilityMC:MovieClip = null;
            var showAbilityMC:Array = null;
            var type:String = null;
            var mc:MovieClip = GV.Lib_Map.getMovieClip("variateInfo_mc") as MovieClip;
            var id:int = int(itemId);
            var starMC:MovieClip = mc.star_mc;
            starMC.gotoAndStop(int(GoodsInfo.getInfoById(id).Star) + 1);
            var addedRate:String = "";
            if(addVariatedRate > 0)
            {
               addedRate = "+<font color=\'#ff0000\'>" + addVariatedRate + "%</font>";
            }
            TextField(mc.name_txt).htmlText = GoodsInfo.getItemNameByID(id) + "(" + rate + "%" + addedRate + ")";
            var abilityTypeCount:int = 3;
            for(var i:int = 1; i <= abilityTypeCount; i++)
            {
               abilityMC = mc["ability_" + i + "_mc"];
               if(Boolean(abilityMC))
               {
                  abilityMC.visible = false;
               }
            }
            var AbilityList:Array = String(GoodsInfo.getInfoById(id).Ability).split(",");
            showAbilityMC = new Array();
            for each(type in AbilityList)
            {
               abilityMC = mc["ability_" + type + "_mc"];
               if(Boolean(abilityMC))
               {
                  abilityMC.visible = true;
                  showAbilityMC.push(abilityMC);
               }
            }
            if(showAbilityMC.length == 1)
            {
               showAbilityMC[0].x = 156;
            }
            else if(showAbilityMC.length == 2)
            {
               showAbilityMC[0].x = 146;
               showAbilityMC[1].x = 178.8;
            }
            else if(showAbilityMC.length == 3)
            {
               showAbilityMC[0].x = 147.1;
               showAbilityMC[1].x = 158.2;
               showAbilityMC[2].x = 178.8;
            }
            return mc;
         }
         
         public function CloseAngelTip() : void
         {
            if(Boolean(this._tipUI) && Boolean(this._tipUI.parent))
            {
               BC.removeEvent(this._tipUI);
               this._tipUI.parent.removeChild(this._tipUI);
            }
         }
         
         public function ShowAngelRandomTalk(id:int, lvl:int, state:int, mc:DisplayObject) : void
         {
            if(this._randomtalkList == null || this._randomtalkList.length == 0)
            {
               this._randomtalkList = AngelParkView.instance.parkDataCtl.GetAngelRandomTalk(id,lvl,state);
               this.ShowRandomTalk(mc);
            }
         }
         
         private function ShowRandomTalk(mc:DisplayObject) : void
         {
            var str:String = null;
            var talkBox:MovieClip = null;
            if(this._randomtalkList.length == 0)
            {
               return;
            }
            str = this._randomtalkList.shift();
            talkBox = GV.Lib_Map.getMovieClip("wordBox_mc") as MovieClip;
            talkBox.visible = true;
            talkBox.x = mc.x + mc.width / 2;
            talkBox.y = mc.y - talkBox.height / 3;
            MapButtonView.getTarget().addChild(talkBox);
            var _temp_5:* = BC;
            var _temp_4:* = this._randomtalkList;
            var _temp_3:* = GV.onlineSocket;
            var _temp_2:* = "angelParkRandomTalkOverEvent";
            with({})
            {
               _temp_5.addEvent(_temp_4,_temp_3,_temp_2,function handler(e:Event):void
               {
                  BC.removeEvent(_randomtalkList);
                  ShowRandomTalk(mc);
               });
            }
            
            public function ShowLevelUpPanel(level:int) : void
            {
               var str:String = LocalUserInfo.getNickName() + "太棒了，天使園等級提升到" + level + "級啦。";
               PopupMsgCtl.PopupMsg(str);
            }
         }
      }
      
      