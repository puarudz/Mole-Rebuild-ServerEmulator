package com.module.newAngel
{
   import com.core.download.DownLoadEvent;
   import com.core.download.DownLoadManager;
   import com.core.download.ResType;
   import com.core.info.LocalUserInfo;
   import com.core.info.ServerUpTime;
   import com.view.PeopleView.NewAngelModel;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class NewAngelTipsManager
   {
      
      private static var _inst:NewAngelTipsManager;
      
      private var _tips:Array = ["培養不滿一小時可沒有經驗哦","據說融合需要50級才可以","好期待與惡魔島的惡魔來一場大戰！","融合必須是兩隻不同性別的天使","成長值是天使成長高低的重要依據","天使的最高等級可以到達100級","每隻天使到達30級和50級都會自動進化","培養需要消耗靈氣值，天使等級越高消耗越多","靈氣值會每小時自動恢復","培養消耗的靈氣好像是等級的2倍","靈氣不足了可以點“+”號補充","每隻天使都是獨一無二的存在","目前有7個系的天使","2階天使通常來說成長會比1階高","據說有些奇怪的藥水可以改變成長","生命之果能永久增加1點生命","攻擊之果能永久增加1點攻擊","防禦之果能永久增加1點防禦","敏捷之果能永久增加1點敏捷","範圍之果能永久增加1點範圍","藍色水晶可以恢復100靈氣值","黃色水晶可以恢復200靈氣值","紅色水晶可以恢復500靈氣值","經驗果實可以直接讓我們獲得經驗","每次融合都會消耗一顆融合石","瑪瑙可以在天使商店兌換道具","培養有24小時上限vip有48小時","睡覺睡到自然醒……","讓我想想躲哪比較安全","每天收回再培養，經驗快速漲"];
      
      private var cls:Class;
      
      private var _specialTip:Array = ["經驗滿啦，收回就能獲得","培養到期，速度收回！","再不收回就浪費經驗了哦~","這麼多經驗，該能升好幾級了吧？","主人，點下收回有驚喜哦！","報告，經驗已滿！"];
      
      private var _inParkAngel:Vector.<NewAngelModel>;
      
      private var _tipsTimer:Timer;
      
      private var tTimer:Timer;
      
      public function NewAngelTipsManager()
      {
         super();
      }
      
      public static function get inst() : NewAngelTipsManager
      {
         if(_inst == null)
         {
            _inst = new NewAngelTipsManager();
         }
         return _inst;
      }
      
      public function init(inParkAngel:Vector.<NewAngelModel>) : void
      {
         this._inParkAngel = inParkAngel;
         this.addNameAndLevel();
         this.tTimer = GC.setGTimeout(function():void
         {
            GC.clearGTimeout(tTimer);
            tTimer = null;
            var resID:* = DownLoadManager.add("module/external/exeModule/newAngelWordBox.swf",ResType.DISPLAY_OBJECT);
            DownLoadManager.addEvent(resID,onLoadResOver);
         },5 * 1000);
      }
      
      private function onLoadResOver(e:DownLoadEvent) : void
      {
         var mc:MovieClip = e.data as MovieClip;
         this.cls = mc.loaderInfo.applicationDomain.getDefinition("New_Angel_Word_Box") as Class;
         this.addTips();
         if(Boolean(this._tipsTimer))
         {
            GC.clearGInterval(this._tipsTimer);
            this._tipsTimer = null;
         }
         this.showTips();
         this._tipsTimer = GC.setGInterval(this.showTips,5 * 6 * 1000);
      }
      
      private function addNameAndLevel() : void
      {
         var nameTxt:TextField = null;
         var lvTxt:TextField = null;
         var len:int = int(this._inParkAngel.length);
         for(var i:int = 0; i < len; i++)
         {
            nameTxt = new TextField();
            nameTxt.text = this._inParkAngel[i].angelInfo.angelNick;
            lvTxt = new TextField();
            lvTxt.selectable = false;
            lvTxt.autoSize = TextFieldAutoSize.CENTER;
            nameTxt.autoSize = TextFieldAutoSize.CENTER;
            nameTxt.selectable = false;
            lvTxt.text = "Lv:" + this._inParkAngel[i].angelInfo.angelLv;
            this._inParkAngel[i].addChild(nameTxt);
            this._inParkAngel[i].addChild(lvTxt);
            nameTxt.y = 25;
            lvTxt.y = 10;
            nameTxt.x = -nameTxt.width / 2;
            lvTxt.x = -lvTxt.width / 2;
            this.setTxtColor(lvTxt);
            this.setTxtColor(nameTxt);
         }
      }
      
      private function setTxtColor(txt:TextField) : void
      {
         txt.setTextFormat(new TextFormat(null,null,16776960));
         txt.filters = [new GlowFilter(16711680,1,2,2,2)];
      }
      
      private function addTips() : void
      {
         var wordBox:MovieClip = null;
         var len:int = int(this._inParkAngel.length);
         for(var i:int = 0; i < len; i++)
         {
            wordBox = new this.cls();
            wordBox.name = "wordBox";
            wordBox.showMSG_txt.autoSize = TextFieldAutoSize.LEFT;
            wordBox.showMSG_txt.wordWrap = true;
            wordBox.visible = false;
            this._inParkAngel[i].addChild(wordBox);
            if(this._inParkAngel[i].height != 0)
            {
            }
         }
      }
      
      private function showTips(e:* = null) : void
      {
         var wordBox:MovieClip = null;
         var rand:int = 0;
         var len:int = int(this._inParkAngel.length);
         for(var i:int = 0; i < len; i++)
         {
            wordBox = this._inParkAngel[i].getChildByName("wordBox") as MovieClip;
            if(wordBox != null)
            {
               if(!this.timeUp(i))
               {
                  rand = 10 * Math.random();
                  if(rand < 3)
                  {
                     this.initBox(wordBox,this._tips[int(this._tips.length * Math.random())]);
                  }
               }
               else
               {
                  this.initBox(wordBox,this._specialTip[int(this._specialTip.length * Math.random())]);
               }
            }
         }
      }
      
      private function timeUp(index:int) : Boolean
      {
         var totalTime:uint = (ServerUpTime.getInstance().serverTime / 1000 - this._inParkAngel[index].angelInfo.startTime) / 3600;
         if(LocalUserInfo.isVIP())
         {
            totalTime = Math.min(totalTime,48);
            if(totalTime == 48)
            {
               return true;
            }
            return false;
         }
         totalTime = Math.min(totalTime,24);
         if(totalTime == 24)
         {
            return true;
         }
         return false;
      }
      
      private function initBox(wordBox:MovieClip, msg:String = "") : void
      {
         var t:Timer = null;
         wordBox.visible = true;
         wordBox.showMSG_txt.setTextFormat(new TextFormat(null,14));
         msg = msg.substr(0,20);
         wordBox.visible = true;
         wordBox.showMSG_txt.text = msg;
         wordBox.BG.width = wordBox.showMSG_txt.textWidth + 20;
         wordBox.BG.height = wordBox.showMSG_txt.textHeight + 20;
         wordBox.msgjt_mc.gotoAndStop(1);
         if(wordBox.showMSG_txt.textWidth < 50)
         {
            wordBox.msgjt_mc.gotoAndStop(2);
            wordBox.BG.height = wordBox.showMSG_txt.textHeight + 16;
         }
         t = GC.setGTimeout(function():void
         {
            wordBox.visible = false;
            GC.clearGTimeout(t);
         },15000);
         wordBox.msgjt_mc.x = wordBox.BG.width / 2 + wordBox.BG.width / 10;
         wordBox.msgjt_mc.y = wordBox.BG.height;
         wordBox.x = -wordBox.BG.width / 2;
         wordBox.y = -wordBox.height - 50;
      }
      
      public function destroy() : void
      {
         if(Boolean(this._tipsTimer))
         {
            GC.clearGTimeout(this._tipsTimer);
            this._tipsTimer = null;
         }
         if(Boolean(this.tTimer))
         {
            GC.clearGTimeout(this.tTimer);
            this.tTimer = null;
         }
         this._inParkAngel = null;
         _inst = null;
      }
   }
}

