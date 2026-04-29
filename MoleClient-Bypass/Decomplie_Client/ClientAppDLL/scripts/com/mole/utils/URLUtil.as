package com.mole.utils
{
   import com.common.data.goodsInfo.GoodsInfo;
   
   public class URLUtil
   {
      
      private static var _resURL:String;
      
      private static var _rootURL:String;
      
      public static const POSTFIX_XML:String = ".xml";
      
      public static const POSTFIX_SWF:String = ".swf";
      
      public static const POSTFIX_MP3:String = ".mp3";
      
      public static const POSTFIX_JPG:String = ".jpg";
      
      public static const POSTFIX_PNG:String = ".png";
      
      setup("");
      
      public function URLUtil()
      {
         super();
      }
      
      public static function setup(rootURL:String) : void
      {
         _rootURL = rootURL;
         _resURL = rootURL + "resource/";
      }
      
      public static function getFileName(url:String) : String
      {
         var sindex:int = url.indexOf("?");
         if(sindex == -1)
         {
            sindex = int.MAX_VALUE;
         }
         var index1:int = url.lastIndexOf(".",sindex);
         var index2:int = url.lastIndexOf("/") + 1;
         return url.substring(index2,index1);
      }
      
      public static function getClothSwf(equipId:uint, actionIndex:uint = 1001) : String
      {
         var url:String = _resURL + "cloth/bmpswf/" + actionIndex + "/" + equipId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getClothShowSwf(clothId:uint) : String
      {
         var url:String = _resURL + "cloth/prevIcon/" + clothId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getSpecialActSwf(actStr:String, jobStr:String, boneStr:String) : String
      {
         var url:String = _resURL + "body/" + actStr + "/" + jobStr + "/" + boneStr + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getGameRes(animationName:String) : String
      {
         var url:String = _resURL + "game/" + animationName + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getOldClothSwf(itemId:uint) : String
      {
         var url:String = _resURL + "cloth/swf/" + itemId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getDragonSwf(dragStr:String) : String
      {
         var url:String = _resURL + "dragon/bmpswf/" + dragStr + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getTransfigurationSwf(transfId:String) : String
      {
         var url:String = _resURL + "body/transfiguration/" + transfId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getNewAngelIco(angelId:uint) : String
      {
         var icoId:uint = GoodsInfo.getAngelInfoById(angelId).icon;
         if(icoId == 0)
         {
            icoId = angelId;
         }
         var url:String = _resURL + "newAngel/icon/" + icoId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getNewAngelShow(angelId:uint) : String
      {
         var icoId:uint = GoodsInfo.getAngelInfoById(angelId).icon;
         if(icoId == 0)
         {
            icoId = angelId;
         }
         var url:String = _resURL + "newAngel/show/" + icoId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getNewAngelSwf(angelId:uint) : String
      {
         var icoId:uint = GoodsInfo.getAngelInfoById(angelId).icon;
         if(icoId == 0)
         {
            icoId = angelId;
         }
         var url:String = _resURL + "newAngel/swf/" + icoId + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getNewAngelSkillIco(skillID:uint) : String
      {
         var url:String = _resURL + "newAngel/skillico/" + skillID + POSTFIX_SWF;
         return getVersionUrl(url);
      }
      
      public static function getMoleHeadURL() : String
      {
         var url:String = _rootURL + "module/external/MoleTime/MoleTimeFace.swf";
         return getVersionUrl(url);
      }
      
      public static function getNPCURL(npcId:uint) : String
      {
         var url:String = _resURL + "NPC/new_NPC/" + npcId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getTaskFlagURL(flagID:int) : String
      {
         var url:String = _resURL + "NPC/taskFlag/taskFlag_" + flagID + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getSearchSomethingUrl(activityId:uint) : String
      {
         var url:String = _resURL + "searchsomething/" + activityId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getElementCardIcoUrl(cardId:uint) : String
      {
         var url:String = _resURL + "elementCard/icon/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getElementCardShowUrl(cardId:uint) : String
      {
         var url:String = _resURL + "elementCard/show/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getDivineCardShowUrl(cardId:uint) : String
      {
         var url:String = _resURL + "divine/show/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getMagicSpiritIcoUrl(cardId:uint) : String
      {
         var url:String = _resURL + "magicSpirit/icon/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getMagicSpiritShowUrl(cardId:uint) : String
      {
         var url:String = _resURL + "magicSpirit/show/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getMagicSpiritStageBtnUrl(cardId:uint) : String
      {
         var url:String = _resURL + "magicSpirit/stagebtn/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getMagicSpiritStageBgUrl(cardId:uint) : String
      {
         var url:String = _resURL + "magicSpirit/stagebg/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getMagicSpiritShopIcoUrl(cardId:uint) : String
      {
         var url:String = _resURL + "magicSpirit/shop/" + cardId + ".swf";
         return getVersionUrl(url);
      }
      
      public static function getVersionUrl(url:String) : String
      {
         return VL.getURL(url);
      }
   }
}

