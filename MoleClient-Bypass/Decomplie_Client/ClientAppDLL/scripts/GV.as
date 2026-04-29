package
{
   import com.common.LibLogic.LibLogic;
   import com.common.soundControl.soundControl;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.core.socketlogic.baseSocket.ProxySocket;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class GV
   {
      
      public static var loadBagMC:Loader;
      
      public static var MAN_PEOPLE:*;
      
      public static var soundAssets:*;
      
      public static var soundCon:soundControl;
      
      public static var MC_AppLever:Sprite;
      
      public static var MC_TopLever:Sprite;
      
      public static var MC_mapFrame:MovieClip;
      
      public static var MC_Depth:MovieClip;
      
      public static var MC_Space:MovieClip;
      
      public static var MC_mapTop:MovieClip;
      
      public static var MC_Type:MovieClip;
      
      public static var MC_ToolView:MovieClip;
      
      public static var map_ManagerChange:*;
      
      public static var onlineSocket:ProxySocket;
      
      public static var onlineClass:ClientOnLineSerSocket;
      
      public static var GameSocket:Socket;
      
      public static var MoveTo_Class:*;
      
      public static var GF:*;
      
      public static var xd_msg:Array;
      
      public static var Activity:ByteArray;
      
      public static var GroupID:Number;
      
      public static var ErrorMSG:String;
      
      public static var peopleTouchArray:Array;
      
      public static var friendList:Array;
      
      public static var serverArrs:Array;
      
      public static var backup_mapID:uint;
      
      public static var MapInfo_mapClass:Class;
      
      public static var MapInfo_name:String;
      
      public static var MapInfo_smallMapURL:String;
      
      public static var MapInfo_center:*;
      
      public static var Lib_Map:LibLogic;
      
      public static var dllArrayByte:ByteArray;
      
      public static var throwThingClass:*;
      
      public static var PeopleCount:*;
      
      public static var FindPath:*;
      
      public static var paopaoView:*;
      
      public static var JobLogics:*;
      
      public static var JobViews:*;
      
      public static var PetJobLogics:*;
      
      public static var petColor:int;
      
      public static var stageWidth:uint = 960;
      
      public static var stageHeight:uint = 560;
      
      public static var userIDLimit:uint = 2000000000;
      
      public static var usrinfoBool:Boolean = false;
      
      public static var apply_array:Array = [usrinfoBool];
      
      public static var ClothID:int = 12001;
      
      public static var ActionHistory:Array = new Array();
      
      public static var expressionArray:Array = new Array();
      
      public static var MyInfo_ParentID:Number = 0;
      
      public static var MyInfo_childCount:Number = 0;
      
      public static var MyInfo_userID:Number = 1234;
      
      public static var MyInfo_nickName:String = "遊客";
      
      public static var lamuLive:int = 16;
      
      public static var fightLive:int = 20;
      
      public static var MyInfo_PetName:String = "";
      
      public static var MyInfo_Pet:uint = 0;
      
      public static var MyInfo_PetObj:Object = {
         "Skill":0,
         "Name":"",
         "SpriteID":uint,
         "Level":uint,
         "Color":uint,
         "Status":uint,
         "Hungry":uint,
         "Thirsty":uint,
         "Dirty":uint,
         "Spirit":uint,
         "Cloth":uint,
         "Honor":uint,
         "Job":Array
      };
      
      public static var MyInfo_PrevMap:uint = 1;
      
      public static var myInfo_Color:Object = {
         "red":255,
         "green":0,
         "blue":0
      };
      
      public static var myInfo_newsPage:String = "13";
      
      public static var myInfo_noticeArr:Array = new Array();
      
      public static var itemID:Number = 0;
      
      public static var isGameShowTip:Boolean = false;
      
      public static var isJoinGame:Boolean = false;
      
      public static var isSitDown:Boolean = false;
      
      public static var isDefault:Boolean = false;
      
      public static var hasNewLever:Boolean = false;
      
      public static var hasNewMadel:uint = 0;
      
      public static var hasActive:Boolean = false;
      
      public static var GetPetNum:int = 100;
      
      public static const Map_DefaultMapID:uint = 0;
      
      public static var currentMapID:uint = 0;
      
      public static var currentMapName:uint = 0;
      
      public static var Room_ID:String = "85";
      
      public static var Room_Name:String = "";
      
      public static var Room_DefaultRoomID:uint = 10000;
      
      public static var serverID:uint = 0;
      
      public static var MapInfo_mapID:uint = 1;
      
      public static const TwentyBillion:uint = 2000000000;
      
      public static var MapInfo_mapVersion:String = "1224";
      
      public static var MapInfo_MapURL:String = "resource/map/city001.swf";
      
      public static var MapInfo_birthPosXY:String = "400:400";
      
      public static var MapInfo_isHouse:Boolean = false;
      
      public static var isSwitchMap:Boolean = false;
      
      public static var isChangeMap:Boolean = false;
      
      public static var nowJob_Arr:Array = [];
      
      public static var otherPetObj:Object = {};
      
      public static var otherPetArr:Array = [];
      
      public static var Throw_selected:String = "banger";
      
      public static var OnLineArray:Array = [];
      
      public static var SpecialArr:Array = [];
      
      public static var Colors:Array = ["0x009F47","0xF77C26","0x3FA5CD","0xB624DB","0xD42B14","0xBF832D","0xFA4BA0","0x6E6E6E","0xFFFF00","0x000000"];
      
      public static var isInMap:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      public static var petColor_1:Array = [1,1,1,1,255,-199,-250,0,"紅色"];
      
      public static var petColor_2:Array = [1,1,1,1,0,-21,-255,0,"黃色"];
      
      public static var petColor_3:Array = [1,1,1,1,-215,-57,31,0,"天藍色"];
      
      public static var petColor_4:Array = [1,1,1,1,51,-148,0,0,"粉紅色"];
      
      public static var petColor_5:Array = [1,1,1,1,102,-118,-255,0,"橘黃色"];
      
      public static var petColor_6:Array = [1,1,1,1,-150,-150,-150,0,"灰色"];
      
      public static var petColor_7:Array = [1,1,1,1,-215,-210,-215,0,"黑色"];
      
      public static var petColor_8:Array = [1,1,1,1,-82,-194,112,0,"紫色"];
      
      public static var petColor_9:Array = [1,1,1,1,-87,-148,-199,0,"土色"];
      
      public static var petColor_10:Array = [1,1,1,1,-189,-41,-189,0,"綠色"];
      
      public static var BlackWhiteColorArr:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
      
      expressionArray[0] = "wx";
      expressionArray[1] = "dx";
      expressionArray[2] = "hc";
      expressionArray[3] = "hk";
      expressionArray[4] = "bl";
      expressionArray[5] = "dk";
      expressionArray[6] = "fh";
      expressionArray[7] = "zk";
      expressionArray[8] = "am";
      expressionArray[9] = "ax";
      expressionArray[10] = "ok";
      expressionArray[11] = "cg";
      expressionArray[12] = "kk";
      expressionArray[13] = "fd";
      expressionArray[14] = "hx";
      expressionArray[15] = "ku";
      expressionArray[16] = "dd";
      expressionArray[17] = "ot";
      expressionArray[18] = "ha";
      expressionArray[19] = "bz";
      expressionArray[20] = "bq";
      expressionArray[21] = "st";
      expressionArray[22] = "jd";
      expressionArray[23] = "bu";
      expressionArray[24] = "ta";
      expressionArray[25] = "tg";
      expressionArray[28] = "hp";
      BlackWhiteColorArr[0] = (1 - 0) * 0.3086 + 0;
      BlackWhiteColorArr[1] = (1 - 0) * 0.6094;
      BlackWhiteColorArr[2] = (1 - 0) * 0.082;
      BlackWhiteColorArr[5] = (1 - 0) * 0.3086;
      BlackWhiteColorArr[6] = (1 - 0) * 0.6094 + 0;
      BlackWhiteColorArr[7] = (1 - 0) * 0.082;
      BlackWhiteColorArr[10] = (1 - 0) * 0.3086;
      BlackWhiteColorArr[11] = (1 - 0) * 0.6094;
      BlackWhiteColorArr[12] = (1 - 0) * 0.082 + 0;
      BlackWhiteColorArr[18] = 1;
      
      public function GV()
      {
         super();
      }
      
      public static function get isSMC() : Boolean
      {
         return true;
      }
   }
}

