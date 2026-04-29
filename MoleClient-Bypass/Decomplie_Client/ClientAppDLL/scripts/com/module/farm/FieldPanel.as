package com.module.farm
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.global.staticData.XMLInfo;
   import com.module.lamuPkSys.animalSkill.AnimalSkillConfigParser;
   import com.module.lamuPkSys.animalSkill.AnimalSkillTool;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class FieldPanel
   {
      
      public var Panel:MovieClip;
      
      public var Info:Object;
      
      public var NUM:uint = 18;
      
      public var TotalPage:uint;
      
      public var currentPage:int;
      
      public var URL:String = "";
      
      public var classLink:String = "";
      
      public var SendGood:Array;
      
      public var CanGiveGood:Array;
      
      public function FieldPanel()
      {
         var i:String = null;
         var itemObj:Object = null;
         this.SendGood = [];
         this.CanGiveGood = [];
         super();
         var farmArr:Array = [];
         var sendArr:Array = [];
         var px:XMLList = XMLInfo.PresentXML..@Path;
         var px1:XMLList = XMLInfo.PresentXML..@NeedID;
         var px2:XMLList = XMLInfo.PresentXML..@ID;
         for(i in px1)
         {
            itemObj = new Object();
            itemObj = GV.GF.getPropData(px1[i]);
            if(Boolean(itemObj.AgriculturalType))
            {
               sendArr.push(uint(px2[i]));
               farmArr.push(String(px1[i]));
            }
         }
         this.SendGood = sendArr;
         this.CanGiveGood = farmArr;
      }
      
      public function showPanel(info:Object) : void
      {
         var pC:Class = null;
         this.Info = info;
         this.currentPage = 1;
         var p:Number = this.Info.length / this.NUM;
         this.TotalPage = int(p) == p ? uint(p) : uint(int(p) + 1);
         if(!this.Panel)
         {
            BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
            pC = GV.Lib_Map.getClass(this.classLink);
            this.Panel = new pC();
            MainManager.getAppLevel().addChild(this.Panel);
            this.Panel.x = 170;
            this.Panel.y = 40;
            BC.addEvent(this,this.Panel.close_btn,MouseEvent.CLICK,this.ClosePanel);
            BC.addEvent(this,this.Panel.prev_btn,MouseEvent.CLICK,this.prevPage);
            BC.addEvent(this,this.Panel.next_btn,MouseEvent.CLICK,this.nextPage);
         }
         else
         {
            this.Panel.y = 40;
         }
         this.showGoods(1);
      }
      
      private function removeEventHandler(E:Event) : void
      {
         this.Panel = null;
         BC.removeEvent(this);
      }
      
      private function showGoods(pagenum:uint) : void
      {
         var temp:Object = null;
         var tempLoader:Loader = null;
         var url:String = null;
         var level:uint = 0;
         var bfb:uint = 0;
         var parh:String = null;
         this.currentPage = pagenum;
         this.Panel.page_txt.text = this.currentPage + "/" + this.TotalPage;
         try
         {
            this.clearItems();
         }
         catch(e:Error)
         {
         }
         for(var i:int = (this.currentPage - 1) * this.NUM; i < this.currentPage * this.NUM; i++)
         {
            temp = this.Panel["I" + (i - (this.currentPage - 1) * this.NUM)];
            if(Boolean(temp))
            {
               BC.removeEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
            }
            if(this.Info[i] != null)
            {
               temp.visible = true;
               temp.num = i;
               temp.ID = this.Info[i].ID;
               try
               {
                  temp.num_txt.text = this.Info[i].Count;
               }
               catch(e:Error)
               {
               }
               temp.obj = this.Info[i];
               temp.ItemObj = GoodsInfo.getInfoById(temp.ID);
               temp.Name = GoodsInfo.getItemNameByID(temp.ID);
               temp.Count = this.Info[i].Count;
               temp.btn.visible = true;
               if(this.CanGiveGood.indexOf(temp.ID) != -1)
               {
                  if(Boolean(temp.send_btn))
                  {
                     temp.send_btn.visible = true;
                  }
               }
               else if(Boolean(temp.send_btn))
               {
                  temp.send_btn.visible = false;
               }
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OVER,this.onBtnOver);
               BC.addEvent(this,temp.btn,MouseEvent.MOUSE_OUT,this.onBtnOut);
               BC.addEvent(this,temp.btn,MouseEvent.CLICK,this.userPorp);
               tempLoader = new Loader();
               if(this.URL == "resource/allJob/iconBtn/")
               {
                  this.URL = "resource/allJob/icon/";
               }
               if(this.Panel.farm2_btn != null)
               {
                  if(this.Panel.farm2_btn.currentFrame == 2 || this.Panel.farm3_btn.currentFrame == 2 || this.Panel.farm4_btn.currentFrame == 2)
                  {
                     temp.send_btn.visible = true;
                     temp.send_btn.gotoAndStop(2);
                  }
                  else if(!temp.tip_mc)
                  {
                     if(Boolean(this.Info[i].Count))
                     {
                        temp.filters = [];
                     }
                     else
                     {
                        temp.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
                     }
                  }
               }
               else if(!temp.tip_mc)
               {
                  if(Boolean(this.Info[i].Count))
                  {
                     temp.filters = [];
                  }
                  else
                  {
                     temp.filters = new Array(new ColorMatrixFilter(GV.BlackWhiteColorArr));
                  }
               }
               url = this.URL + this.Info[i].ID + ".swf";
               if(Boolean(temp.tip_mc))
               {
                  level = this.ValueStatus(this.Info[i].Value,temp.ItemObj.LevelArray);
                  url = this.URL + "fish" + level + "/" + this.Info[i].ID + ".swf";
                  temp.tip_mc.hungry.gotoAndStop(temp.obj.Flag);
                  temp.tip_mc.value_txt.text = this.Info[i].Value + "/" + temp.ItemObj.LevelArray[level - 1];
                  bfb = this.ValuePercent(this.Info[i].Value,temp.ItemObj.LevelArray);
                  temp.tip_mc.bfb.gotoAndStop(bfb);
               }
               if(this.Panel.farm2_btn != null)
               {
                  if(this.Panel.farm2_btn.currentFrame == 2 || this.Panel.farm3_btn.currentFrame == 2 || this.Panel.farm4_btn.currentFrame == 2)
                  {
                     parh = GoodsInfo.GetAnimalIconPath(this.Info[i].ID,this.Info[i].starLevel);
                     tempLoader.load(VL.getURLRequest(parh));
                  }
                  else
                  {
                     tempLoader.load(VL.getURLRequest(url));
                  }
               }
               else
               {
                  tempLoader.load(VL.getURLRequest(url));
               }
               temp.loadimg.addChild(tempLoader);
            }
            else
            {
               temp.btn.enabled = false;
            }
            if(Boolean(temp["checknow"]))
            {
               temp.checknow();
            }
         }
      }
      
      private function ValueStatus(v:int, levelarr:Array) : uint
      {
         if(v < levelarr[0])
         {
            return 1;
         }
         if(v >= levelarr[0] && v < levelarr[1])
         {
            return 2;
         }
         return 3;
      }
      
      private function ValuePercent(v:int, levelarr:Array) : uint
      {
         if(v < levelarr[0])
         {
            return int(v / levelarr[0] * 100);
         }
         if(v >= levelarr[0] && v < levelarr[1])
         {
            return int(v / levelarr[1] * 100);
         }
         return int(v / levelarr[2] * 100);
      }
      
      public function userPorp(e:MouseEvent) : void
      {
      }
      
      private function prevPage(E:MouseEvent) : void
      {
         if(this.currentPage > 1)
         {
            this.showGoods(--this.currentPage);
         }
      }
      
      private function nextPage(E:MouseEvent) : void
      {
         if(this.Info.length > this.currentPage * this.NUM)
         {
            this.showGoods(++this.currentPage);
         }
      }
      
      public function onBtnOver(e:MouseEvent) : void
      {
         var skillXml:XML = null;
         var skillCount:int = 0;
         var skillInfo:XML = null;
         var usingSkill:int = 0;
         var skillNum:int = 0;
         e.target.parent.gotoAndStop(2);
         var goods:Object = e.currentTarget.parent;
         var msg:String = goods.Name;
         if(this.Panel.farm2_btn != null)
         {
            if(this.Panel.farm2_btn.currentFrame == 2 || this.Panel.farm3_btn.currentFrame == 2 || this.Panel.farm4_btn.currentFrame == 2)
            {
               msg = msg + "\n" + this.changeStatLevel(goods.obj.starLevel) + "聖光獸\n";
               skillXml = AnimalSkillConfigParser.GetAnimalInfoWithStarLvl(goods.obj.sID,goods.obj.starLevel,4);
               skillCount = skillXml.children().length();
               for each(skillInfo in skillXml.children())
               {
                  usingSkill = AnimalSkillTool.hasSkill(skillInfo.@skill_id,goods.obj.skillArr);
                  skillNum = int(skillInfo.@max_time);
                  if(usingSkill != -1)
                  {
                     skillNum = int(skillInfo.@max_time) - usingSkill;
                  }
                  msg = msg + "可用" + skillInfo.@name + "技能次數：" + skillNum + "\n";
               }
            }
         }
         GF.showTip(msg,{
            "noDelay":true,
            "x":goods.x + 200,
            "y":goods.y + 40
         });
      }
      
      private function changeStatLevel(starLevel:int) : String
      {
         var ret:String = "";
         if(starLevel == 1)
         {
            ret = "普通";
         }
         else if(starLevel == 2)
         {
            ret = "高級";
         }
         else if(starLevel == 3)
         {
            ret = "極品";
         }
         return ret;
      }
      
      public function onBtnOut(E:MouseEvent) : void
      {
         GF.clearTip();
         E.target.parent.gotoAndStop(1);
      }
      
      public function clearItems() : void
      {
         var temp:Object = null;
         for(var i:uint = 0; i < this.NUM; i++)
         {
            temp = this.Panel["I" + i];
            temp.visible = false;
            if(temp.num != null)
            {
               temp.loadimg.removeChildAt(0);
               temp.num = null;
               temp.type = null;
               try
               {
                  temp.send_btn.visible = false;
                  temp.send_btn.gotoAndStop(1);
               }
               catch(e:Error)
               {
               }
               temp.btn.visible = false;
               temp.num_txt.text = "";
            }
         }
      }
      
      public function ClosePanel(e:MouseEvent) : void
      {
         if(this.Panel.farm2_btn != null)
         {
            this.Panel.plant_btn.gotoAndStop(1);
            this.Panel.farm_btn.gotoAndStop(2);
            this.Panel.farm2_btn.gotoAndStop(1);
            this.Panel.farm3_btn.gotoAndStop(1);
            this.Panel.farm4_btn.gotoAndStop(1);
         }
         this.clearItems();
         this.Panel.y = -1000;
      }
   }
}

