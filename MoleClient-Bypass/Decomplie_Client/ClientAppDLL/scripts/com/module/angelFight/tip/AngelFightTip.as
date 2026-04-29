package com.module.angelFight.tip
{
   import com.common.data.goodsInfo.GoodsInfo;
   import com.core.MainManager;
   import com.global.staticData.XMLInfo;
   import com.module.angelFight.AngelFightMain;
   import com.module.angelFight.valueObject.AngelFightSkillVO;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   
   public class AngelFightTip
   {
      
      private static const Max_Width:Number = 960;
      
      private static const Max_Height:Number = 560;
      
      public static const Add_Value_Item_Flag_Name:Array = ["","大力","智慧","靈活","強壯","主動經驗","被動經驗"];
      
      public static const Recover_Value_Item_Flag_Name:Array = ["","能量","活力"];
      
      public static const Card_Add_Value_Name:Array = ["","大力","智慧","靈活","強壯","能量上限","活力上限"];
      
      public static const Right_Down:int = 1;
      
      public static const Right_Up:int = 2;
      
      public static const Left_Down:int = 3;
      
      public static const Left_Up:int = 4;
      
      private static var _tipObj:Dictionary = new Dictionary();
      
      public function AngelFightTip()
      {
         super();
      }
      
      public static function AddDisplayTip(obj:*, tip:DisplayObject) : void
      {
         if(obj is DisplayObject)
         {
            if(_tipObj[obj] != null)
            {
               ClearTip(obj);
            }
            _tipObj[obj] = CreateTip(tip);
            DisplayObject(obj).addEventListener(MouseEvent.ROLL_OVER,MouseOverHandler);
            DisplayObject(obj).addEventListener(MouseEvent.ROLL_OUT,MouseOutHandler);
         }
      }
      
      public static function AddTxtTip(obj:*, tip:String, isHtml:Boolean = true) : void
      {
         var text:TextField = null;
         if(obj is DisplayObject)
         {
            if(_tipObj[obj] != null)
            {
               ClearTip(obj);
            }
            text = new TextField();
            text.autoSize = TextFieldAutoSize.LEFT;
            text.selectable = false;
            if(isHtml)
            {
               text.htmlText = tip;
            }
            else
            {
               text.text = tip;
            }
            text.defaultTextFormat = new TextFormat(null,14);
            text.height = text.textHeight;
            text.width = text.textWidth;
            _tipObj[obj] = CreateTip(text);
            _tipObj[obj].text = tip;
            DisplayObject(obj).addEventListener(MouseEvent.ROLL_OVER,MouseOverHandler);
            DisplayObject(obj).addEventListener(MouseEvent.ROLL_OUT,MouseOutHandler);
         }
      }
      
      public static function AppendTipInfo(obj:*, tip:String, changeLine:Boolean = true) : void
      {
         var mc:MovieClip = null;
         var oldText:String = null;
         var text:TextField = null;
         if(obj is DisplayObject)
         {
            if(_tipObj[obj] != null)
            {
               try
               {
                  mc = _tipObj[obj];
                  oldText = mc.text;
                  if(changeLine)
                  {
                     oldText += "\n" + tip;
                  }
                  else
                  {
                     oldText += tip;
                  }
                  text = new TextField();
                  text.autoSize = TextFieldAutoSize.LEFT;
                  text.selectable = false;
                  text.htmlText = oldText;
                  text.defaultTextFormat = new TextFormat(null,14);
                  text.height = text.textHeight;
                  text.width = text.textWidth;
                  _tipObj[obj] = CreateTip(text);
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      public static function ClearTip(obj:*) : void
      {
         GC.clearAll(_tipObj[obj]);
         _tipObj[obj] = null;
         DisplayObject(obj).removeEventListener(MouseEvent.ROLL_OVER,MouseOverHandler);
         DisplayObject(obj).removeEventListener(MouseEvent.ROLL_OUT,MouseOutHandler);
      }
      
      private static function MouseOutHandler(e:MouseEvent) : void
      {
         var tipMC:MovieClip = null;
         var timer:Timer = null;
         try
         {
            tipMC = _tipObj[e.currentTarget];
            timer = new Timer(50,1);
            var _temp_4:* = BC;
            var _temp_3:* = timer;
            var _temp_2:* = timer;
            var _temp_1:* = TimerEvent.TIMER_COMPLETE;
            with({})
            {
               
               _temp_4.addOnceEvent(_temp_3,_temp_2,_temp_1,function h(e:TimerEvent):void
               {
                  try
                  {
                     BC.removeEvent(timer);
                     timer.stop();
                     tipMC.timeOutHand = null;
                     tipMC.visible = false;
                     MainManager.getAlertLevel().removeChild(tipMC);
                  }
                  catch(e:Error)
                  {
                  }
               });
               timer.start();
            }
            catch(e:Error)
            {
            }
         }
         
         private static function MouseOverHandler(e:MouseEvent) : void
         {
            var targetMC:DisplayObject = null;
            var targetPos:Point = null;
            var tipMC:MovieClip = null;
            var tipDirMC:MovieClip = null;
            var tipContainerMC:MovieClip = null;
            var i:int = 0;
            var bgMC:MovieClip = null;
            var leftDownFun:Function = null;
            var leftUpFun:Function = null;
            var rightDownFun:Function = null;
            var rightUpFun:Function = null;
            var offset:int = 0;
            var tipBG:MovieClip = null;
            targetMC = e.currentTarget as DisplayObject;
            targetPos = targetMC.parent.localToGlobal(new Point(targetMC.x,targetMC.y));
            tipMC = _tipObj[e.currentTarget];
            if(Boolean(tipMC.timeOutHand))
            {
               BC.removeEvent(tipMC.timeOutHand);
               Timer(tipMC.timeOutHand).stop();
               tipMC.timeOutHand = null;
            }
            clearTimeout(tipMC.timeOutHand);
            if(Boolean(tipMC.parent))
            {
               return;
            }
            if(Boolean(tipMC))
            {
               tipDirMC = tipMC.tip_dir;
               tipDirMC.visible = false;
               tipContainerMC = tipMC.container_mc;
               for(i = 1; i <= 4; i++)
               {
                  tipBG = tipMC["bg_mc_" + i];
                  tipBG.visible = false;
               }
               bgMC = tipMC["bg_mc_1"];
               leftDownFun = function():void
               {
                  bgMC = tipMC["bg_mc_" + Left_Down];
                  tipDirMC.gotoAndStop(2);
                  tipDirMC.visible = true;
                  tipDirMC.x = bgMC.width - tipDirMC.width;
                  tipMC.x = targetPos.x - bgMC.width + targetMC.width / 3;
                  tipMC.y = targetPos.y + targetMC.height / 3 * 2 + tipDirMC.height;
               };
               leftUpFun = function():void
               {
                  bgMC = tipMC["bg_mc_" + Left_Up];
                  tipMC.x = targetPos.x - bgMC.width + targetMC.width / 3;
                  tipMC.y = targetPos.y - bgMC.height + targetMC.height / 3;
               };
               rightDownFun = function():void
               {
                  bgMC = tipMC["bg_mc_" + Right_Down];
                  tipDirMC.gotoAndStop(1);
                  tipDirMC.visible = true;
                  tipMC.x = targetPos.x + targetMC.width / 3;
                  tipMC.y = targetPos.y + targetMC.height / 3 * 2 + tipDirMC.height;
               };
               rightUpFun = function():void
               {
                  bgMC = tipMC["bg_mc_" + Right_Up];
                  tipMC.x = targetPos.x + targetMC.width / 3;
                  tipMC.y = targetPos.y - bgMC.height + targetMC.height / 3;
               };
               offset = 20;
               if(bgMC.width + targetPos.x > Max_Width)
               {
                  if(bgMC.height + offset < targetPos.y + targetMC.height / 3)
                  {
                     leftUpFun();
                  }
                  else
                  {
                     leftDownFun();
                  }
               }
               else if(bgMC.height + offset < targetPos.y + targetMC.height / 3)
               {
                  rightUpFun();
               }
               else
               {
                  rightDownFun();
               }
               tipMC.visible = true;
               tipMC.mouseChildren = false;
               tipMC.mouseEnabled = false;
               bgMC.visible = true;
               MainManager.getAlertLevel().addChild(tipMC);
            }
         }
         
         private static function CreateTip(tip:DisplayObject) : MovieClip
         {
            var tipContainerMC:MovieClip = null;
            var i:int = 0;
            var tipBG:MovieClip = null;
            var tipMC:MovieClip = AngelFightMain.instance.GetMovieClip("tip_mc");
            if(Boolean(tipMC))
            {
               tipMC.mouseEnabled = false;
               tipMC.mouseChildren = false;
               tipContainerMC = tipMC.container_mc;
               tip.name = "tipMC";
               tipContainerMC.addChild(tip);
               for(i = 1; i <= 4; i++)
               {
                  tipBG = tipMC["bg_mc_" + i];
                  tipBG.visible = false;
                  tipBG.width = tipContainerMC.width + tipBG.width - tipBG.scale9Grid.width;
                  tipBG.height = tipContainerMC.height + tipBG.height - tipBG.scale9Grid.height;
               }
               return tipMC;
            }
            return null;
         }
         
         public static function AddSkillTip(obj:DisplayObject, skillId:int, skillLevel:int) : void
         {
            var addState:String = null;
            var addEffect:String = null;
            var nextAddState:String = null;
            var nextAddEffect:String = null;
            var nextaddState:String = null;
            var skillVO:AngelFightSkillVO = AngelFightMain.instance.GetSkillVO(skillId,skillLevel);
            if(skillVO == null || skillVO.hasLevel == false)
            {
               return;
            }
            var str:String = skillVO.Name + " \t等級：<font color=\'#ff0000\'>" + skillLevel + "</font>\n";
            if(skillVO.Skill_type == 0)
            {
               str += "\n技能類型：<font color=\'#ff0000\'>" + (skillVO.Hurt > 0 ? "攻擊型" : "防禦型") + "</font>";
               if(skillVO.UseMp > 0)
               {
                  str += "\n法力消耗：<font color=\'#ff0000\'>" + skillVO.UseMp + "</font>";
               }
               if(skillVO.Hurt > 0)
               {
                  str += "\n技能傷害：<font color=\'#ff0000\'>" + skillVO.Hurt + "</font>";
               }
               addState = GetSkillLevelAddStateString(skillVO);
               if(addState != "")
               {
                  str += "\n附加效果：" + addState;
               }
            }
            else
            {
               str += "\n技能類型：被動觸發";
               addEffect = GetSkillLevelAddEffectString(skillVO);
               addState = GetSkillLevelAddStateString(skillVO);
               if(addEffect != "" || addState != "")
               {
                  str += "\n附加效果：";
               }
               if(addEffect != "")
               {
                  str += addEffect;
               }
               if(addState != "")
               {
                  str += addState;
               }
            }
            if(skillVO.AddState != "")
            {
               str += "\n附加狀態：<font color=\'#ff0000\'>" + skillVO.AddState + "</font>";
            }
            var nextLvlSkillVO:AngelFightSkillVO = AngelFightMain.instance.GetSkillVO(skillId,skillLevel + 1);
            if(Boolean(nextLvlSkillVO) && nextLvlSkillVO.hasLevel)
            {
               str += "\n";
               if(nextLvlSkillVO.Skill_type == 0)
               {
                  if(nextLvlSkillVO.Hurt > 0)
                  {
                     str += "\n下一等級技能傷害：<font color=\'#ff0000\'>" + nextLvlSkillVO.Hurt + "</font>";
                  }
                  nextAddState = GetSkillLevelAddStateString(nextLvlSkillVO);
                  if(addState != "")
                  {
                     str += "\n下一等級附加效果：" + nextAddState;
                  }
               }
               else
               {
                  nextAddEffect = GetSkillLevelAddEffectString(nextLvlSkillVO);
                  nextaddState = GetSkillLevelAddStateString(nextLvlSkillVO);
                  if(nextAddEffect != "" || nextaddState != "")
                  {
                     str += "\n下一級附加效果：";
                  }
                  if(nextAddEffect != "")
                  {
                     str += nextAddEffect;
                  }
                  if(nextaddState != "")
                  {
                     str += nextaddState;
                  }
               }
            }
            AddTxtTip(obj,str);
         }
         
         public static function AddAngelTip(obj:DisplayObject, angelId:int, level:int) : void
         {
            var nextLvlSkillVO:AngelFightSkillVO = null;
            var addEffect:String = null;
            var nextAddEffect:String = null;
            var skillVO:AngelFightSkillVO = AngelFightMain.instance.GetSkillVO(angelId,level);
            if(skillVO == null || skillVO.hasLevel == false)
            {
               return;
            }
            var data:Object = GoodsInfo.getInfoById(angelId);
            var str:String = data.Name + " \t等級：<font color=\'#ff0000\'>" + level + "</font>\n";
            if(Boolean(skillVO))
            {
               if(skillVO.Skill_type == 0)
               {
                  addEffect = GetSkillLevelAddEffectString(skillVO);
                  if(addEffect != "")
                  {
                     str += "\n附加效果：" + addEffect;
                  }
                  str += "\n\n擁有技能：<font color=\'#ff0000\'>" + skillVO.Name + "</font>";
                  str += "\n技能類型：<font color=\'#ff0000\'>" + (skillVO.Hurt > 0 ? "攻擊型" : "防禦型") + "</font>";
                  if(skillVO.UseMp > 0)
                  {
                     str += "\n法力消耗：<font color=\'#ff0000\'>" + skillVO.UseMp + "</font>";
                  }
                  if(skillVO.Hurt > 0)
                  {
                     str += "\n技能傷害：<font color=\'#ff0000\'>" + skillVO.Hurt + "</font>";
                  }
               }
               if(skillVO.AddState != "")
               {
                  str += "\n附加狀態：<font color=\'#ff0000\'>" + skillVO.AddState + "</font>";
               }
               if(skillVO.Desc != "")
               {
                  str += "\n    " + skillVO.Desc;
               }
               nextLvlSkillVO = AngelFightMain.instance.GetSkillVO(angelId,level + 1);
               if(Boolean(nextLvlSkillVO) && nextLvlSkillVO.hasLevel)
               {
                  str += "\n";
                  if(nextLvlSkillVO.Skill_type == 0)
                  {
                     nextAddEffect = GetSkillLevelAddEffectString(nextLvlSkillVO);
                     if(nextAddEffect != "")
                     {
                        str += "\n下一等級附加效果：" + nextAddEffect;
                     }
                     if(nextLvlSkillVO.Hurt > 0)
                     {
                        str += "\n下一等級技能傷害：<font color=\'#ff0000\'>" + nextLvlSkillVO.Hurt + "</font>";
                     }
                  }
               }
            }
            AddTxtTip(obj,str);
         }
         
         private static function GetSkillLevelAddEffectString(skillVO:AngelFightSkillVO) : String
         {
            var addEffect:String = null;
            if(Boolean(skillVO))
            {
               addEffect = "";
               if(skillVO.Str > 0)
               {
                  addEffect += "\n\t大力+<font color=\'#ff0000\'>" + skillVO.Str + "</font>";
               }
               if(skillVO.Int > 0)
               {
                  addEffect += "\n\t智慧+<font color=\'#ff0000\'>" + skillVO.Int + "</font>";
               }
               if(skillVO.Hab > 0)
               {
                  addEffect += "\n\t強壯+<font color=\'#ff0000\'>" + skillVO.Hab + "</font>";
               }
               if(skillVO.Ali > 0)
               {
                  addEffect += "\n\t靈活+<font color=\'#ff0000\'>" + skillVO.Ali + "</font>";
               }
               if(skillVO.Hp > 0)
               {
                  addEffect += "\n\tHP+<font color=\'#ff0000\'>" + skillVO.Hp + "</font>";
               }
               return addEffect;
            }
            return "";
         }
         
         private static function GetSkillLevelAddStateString(skillVO:AngelFightSkillVO) : String
         {
            var addState:String = null;
            if(Boolean(skillVO))
            {
               addState = "";
               if(skillVO.Atk > 0)
               {
                  addState += "\n\t攻擊+<font color=\'#ff0000\'>" + skillVO.Atk + "</font>";
               }
               if(skillVO.Aspd > 0)
               {
                  addState += "\n\t行動速度+<font color=\'#ff0000\'>" + skillVO.Aspd + "</font>";
               }
               if(skillVO.Evad > 0)
               {
                  addState += "\n\t免疫率+<font color=\'#ff0000\'>" + skillVO.Evad + "</font>";
               }
               if(skillVO.Block > 0)
               {
                  addState += "\n\t抵抗率+<font color=\'#ff0000\'>" + skillVO.Block + "</font>";
               }
               if(skillVO.Combo > 0)
               {
                  addState += "\n\t連擊率+<font color=\'#ff0000\'>" + skillVO.Combo + "</font>";
               }
               if(skillVO.Crit > 0)
               {
                  addState += "\n\t暴擊率+<font color=\'#ff0000\'>" + skillVO.Crit + "</font>";
               }
               if(skillVO.Hit > 0)
               {
                  addState += "\n\t命中率+<font color=\'#ff0000\'>" + skillVO.Hit + "</font>";
               }
               if(skillVO.Def > 0)
               {
                  addState += "\n\t防禦力+<font color=\'#ff0000\'>" + skillVO.Def + "</font>";
               }
               return addState;
            }
            return "";
         }
         
         public static function AddCollectPiectTip(obj:DisplayObject, collectPieceId:int) : void
         {
            var desc:String = null;
            var data:Object = GoodsInfo.getInfoById(collectPieceId);
            var str:String = "";
            var collectId:int = AngelFightMain.instance.GetCollectIdByPieceId(collectPieceId);
            if(Boolean(XMLInfo.itemTips[collectPieceId]))
            {
               desc = XMLInfo.itemTips[collectPieceId];
               str += desc;
            }
            if(collectId != -1)
            {
               if(str != "")
               {
                  str += "\n";
               }
               str += "這是合成“<font color=\'#ff0000\'>" + GoodsInfo.getItemNameByID(collectId) + "</font>”必須收集品";
            }
            str += "\n許願後，通過<font color=\'#ff0000\'>" + data.Wishing_cnt + "</font>個好友的祝福獲得。";
            AddTxtTip(obj,str);
         }
         
         public static function AddCardTip(obj:DisplayObject, cardId:int, addStr:String = "") : void
         {
            var data:Object = null;
            var desc:String = null;
            var skillVO:AngelFightSkillVO = null;
            data = GoodsInfo.getInfoById(cardId);
            var str:String = data.Name + "\n";
            if(Boolean(XMLInfo.itemTips[cardId]))
            {
               desc = XMLInfo.itemTips[cardId];
               str += desc;
            }
            str += "\n等級需求：<font color=\'#ff0000\'>" + data.Level + "</font>";
            switch(data.Card_type)
            {
               case 1:
                  str += "\n首次解封後獲得摩摩怪：<font color=\'#ff0000\'>" + GoodsInfo.getItemNameByID(data.Mapitem_id) + "</font>";
                  skillVO = AngelFightMain.instance.GetSkillVO(data.Mapitem_id);
                  str += "\n摩摩怪擁有技能：<font color=\'#ff0000\'>" + skillVO.Name + "</font>";
                  break;
               case 2:
                  break;
               case 3:
                  str += "\n首次解封後獲得天賦：<font color=\'#ff0000\'>" + GoodsInfo.getItemNameByID(data.Mapitem_id) + "</font>";
                  break;
               case 4:
               case 5:
                  break;
               case 6:
                  str += "\n首次解封後獲得裝扮：<font color=\'#ff0000\'>" + GoodsInfo.getItemNameByID(data.Mapitem_id) + "</font>";
            }
            if(data.Add_val > 0)
            {
               str += "\n首次收集後角色：<font color=\'#ff0000\'>" + Card_Add_Value_Name[data.Add_type] + "+" + data.Add_val + "</font>";
            }
            if(data.Card_type != 6)
            {
               str += "\n每次收集都將獲得收集點數<font color=\'#ff0000\'>" + data.Point + "</font>點";
            }
            str += "\n最大收集次數<font color=\'#ff0000\'>" + data.Max_collect + "</font>次";
            str += addStr;
            AddTxtTip(obj,str);
         }
         
         public static function AddItemTip(obj:DisplayObject, itemId:int) : void
         {
            var desc:String = null;
            if(GoodsInfo.getType(itemId) == 32)
            {
               AddCardTip(obj,itemId);
               return;
            }
            var data:Object = GoodsInfo.getInfoById(itemId);
            var str:String = data.Name + "\n";
            str += "\n使用等級：<font color=\'#ff0000\'>" + data.Limit_lvl + "</font>";
            switch(data.Item_type)
            {
               case 1:
                  str += "\n使用之後恢復<font color=\'#ff0000\'>" + Recover_Value_Item_Flag_Name[data.Item_flag] + "</font>值<font color=\'#ff0000\'>" + data.Add_cnt + "</font>點";
                  break;
               case 2:
                  str += "\n使用後<font color=\'#ff0000\'>" + Add_Value_Item_Flag_Name[data.Item_flag] + "</font>增加<font color=\'#ff0000\'>" + data.Add_cnt + "</font>點，持續<font color=\'#ff0000\'>" + data.Round + "</font>場戰鬥";
                  break;
               case 3:
            }
            if(Boolean(XMLInfo.itemTips[itemId]))
            {
               desc = XMLInfo.itemTips[itemId];
               str += "\n" + desc;
            }
            AddTxtTip(obj,str);
         }
         
         public static function AddEquipTip(obj:DisplayObject, equipId:int) : void
         {
            var desc:String = null;
            var data:Object = GoodsInfo.getInfoById(equipId);
            var str:String = data.Name + "\n";
            if(Boolean(XMLInfo.itemTips[equipId]))
            {
               desc = XMLInfo.itemTips[equipId];
               str += desc;
            }
            str += "\n附加效果：";
            if(data.hasOwnProperty("Str") && data.Str != 0)
            {
               str += "\n<font color=\'#ff0000\'>大力+" + data.Str + "</font>";
            }
            if(data.hasOwnProperty("Int") && data.Int != 0)
            {
               str += "\n<font color=\'#ff0000\'>智慧+" + data.Int + "</font>";
            }
            if(data.hasOwnProperty("Hab") && data.Hab != 0)
            {
               str += "\n<font color=\'#ff0000\'>強壯+" + data.Hab + "</font>";
            }
            if(data.hasOwnProperty("Ali") && data.Ali != 0)
            {
               str += "\n<font color=\'#ff0000\'>靈活+" + data.Ali + "</font>";
            }
            AddTxtTip(obj,str);
         }
         
         public static function AddTip(obj:DisplayObject, id:int) : void
         {
            var type:int = int(GoodsInfo.getType(id));
            switch(type)
            {
               case 22:
                  AddItemTip(obj,id);
                  break;
               case 32:
                  AddCardTip(obj,id);
                  break;
               case 34:
                  AddEquipTip(obj,id);
                  break;
               case 35:
                  AddCollectPiectTip(obj,id);
            }
         }
      }
   }
   
   