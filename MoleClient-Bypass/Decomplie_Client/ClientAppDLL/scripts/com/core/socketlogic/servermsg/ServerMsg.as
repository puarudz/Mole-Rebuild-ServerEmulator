package com.core.socketlogic.servermsg
{
   import com.common.Alert.Alert;
   import com.core.MainManager;
   import com.event.EventTaomee;
   import com.mole.debug.DebugManager;
   
   public class ServerMsg
   {
      
      public static var GAMESOCRE_SUBMISSION:String = "gamesocer_submission";
      
      public static var REPORTER:String = "reporter";
      
      public static var errorBool:Boolean = false;
      
      public function ServerMsg()
      {
         super();
      }
      
      public static function MsgForserver(type:Number) : void
      {
         var singGameObj:Object = null;
         var msg:String = "";
         switch(type)
         {
            case -10009:
               msg = "系统繁忙";
               break;
            case -10015:
               GV.onlineSocket.dispatchEvent(new EventTaomee("sameEvent"));
               if(GV.itemID == 1)
               {
                  msg = "非常感谢你的慷慨捐助";
                  Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
                  GV.itemID = 0;
                  return;
               }
               if(GV.itemID == 2)
               {
                  msg = "你不能拥有过多的此宝贝";
               }
               else if(GV.itemID == 3)
               {
                  msg = "你已经有了这个宝贝啦！";
               }
               else if(GV.itemID == 4)
               {
                  msg = "兑换已经到达了上限啦!";
               }
               else if(GV.itemID == 5)
               {
                  msg = "每个小摩尔只能领取一个保险箱哦！快去你的小屋仓库看看吧！";
               }
               else if(GV.itemID == 6)
               {
                  msg = "这支队旗你已经领过喽！";
               }
               else if(GV.itemID > 1000)
               {
                  msg = GV.ErrorMSG;
                  if(msg == null)
                  {
                     return;
                  }
               }
               else
               {
                  msg = "你已经有了这件宝贝啦！\n再看看其他的吧！";
               }
               break;
            case -10016:
               msg = "没有你要找的投稿编号,请重新输入";
               GV.onlineSocket.dispatchEvent(new EventTaomee(REPORTER,{"mess":msg}));
               return;
            case -10017:
               msg = "    你已经收到今天的舞会邀请卡咯";
               Alert.showAlert(MainManager.getAppLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"E");
               break;
            case -10018:
               GV.onlineSocket.dispatchEvent(new EventTaomee("partyCancel"));
               break;
            case -10019:
               msg = "你的好友已经到达上限";
               break;
            case -10020:
               msg = "发送失败\n你发送的好友离线消息已经到达上限";
               break;
            case -10021:
               singGameObj = new Object();
               singGameObj.GameID = 10000;
               singGameObj.Session = null;
               singGameObj.Score = 0;
               singGameObj.Exp = 0;
               singGameObj.Strong = 0;
               singGameObj.IQ = 0;
               singGameObj.Lovely = 0;
               singGameObj.gameRMB = 0;
               singGameObj.itemArr = [];
               GV.onlineSocket.dispatchEvent(new EventTaomee(GAMESOCRE_SUBMISSION,singGameObj));
               GV.onlineSocket.dispatchEvent(new EventTaomee("GET_MOLE_PLAY_TIME",{"Time":2}));
               msg = "亲爱的小摩尔,你每天只能赚10000摩尔豆,你今天赚的已经够多了,赶快休息一下吧";
               GF.showAlert(MainManager.getGameLevel(),"",msg,8,"D");
               return;
            case -12101:
               msg = "神奇密码箱开启失败！";
               GV.onlineSocket.dispatchEvent(new EventTaomee("AladdinPWD_SUCC",{
                  "count":0,
                  "Msg":msg
               }));
               return;
            case -12102:
               msg = "神奇密码已经被使用过了！";
               GV.onlineSocket.dispatchEvent(new EventTaomee("AladdinPWD_SUCC",{
                  "count":0,
                  "Msg":msg
               }));
               return;
            case -10022:
               msg = "你已经拥有了该物品,此密码可以用在其他米米号上！";
               GV.onlineSocket.dispatchEvent(new EventTaomee("AladdinPWD_SUCC",{
                  "count":0,
                  "Msg":msg
               }));
               return;
            case -13001:
               msg = "系统繁忙，提交失败";
               break;
            case -11105:
               msg = "这个摩尔不存在!";
               break;
            case -11150:
               msg = "这个咕噜噗不存在!";
               break;
            case -11152:
               msg = "你不是管理员，没有该权限哦!";
               break;
            case -11153:
               msg = "对方加入的咕噜噗太多啦!";
               break;
            case -11154:
               msg = "你最多只能建3个咕噜噗哦！";
               break;
            case -11155:
               msg = "这个咕噜噗已经满啦！";
               break;
            case -11156:
               msg = "这个摩尔好像不在群中哦!";
               break;
            case -11157:
               msg = "这个摩尔已经在咕噜噗中啦!";
               break;
            case -11202:
               msg = "该作物还没成熟，暂时不能收获哦！";
               break;
            case -11203:
               msg = "该作物数量已经达到上限咯~快去卖掉一些吧！";
               break;
            case -11204:
               msg = "因为太久没有收获果实，已经腐烂掉了！";
               break;
            case -12654:
               msg = "今天你已经拿了太多咯，留给其他小摩尔一些，明天再来吧！";
               break;
            case -12655:
               msg = "你的美誉值不够哦，多拿些美食去足球场分享吧！";
               break;
            case -12667:
               msg = "你的拉姆今天已经得到太多大自然徽章啦，休息一下，明天再来吧！";
               break;
            case -100132:
               msg = "你没有带拉姆，不能领取奖励哦！";
               break;
            case -100197:
               msg = "你已经拿了太多这个东西啦！明天再来拿这个东西吧！";
               break;
            case -12574:
               msg = "你今天已经拿了太多东西啦，要给他留一点的哦！";
               break;
            case -100198:
               msg = "你的火焰纹章数量不够哦，每人每天最多能获得200个火焰纹章！参加火神杯赛事能得到火焰纹章！";
               break;
            case -12694:
               msg = "宝盒里的物品个数不足!";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -12695:
               msg = "你今天已经领过5次礼品了，明天再来领取吧。";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -12697:
               msg = "物品已经到达上限了!";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -12696:
               msg = "你今天已经在这里领取过一次物品了，去其他好友家里看看吧。";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFull"));
               break;
            case -12692:
               msg = "友谊宝盒已装满!";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -100201:
               msg = "物品不允许放入友谊宝盒!";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -100213:
               msg = "达到当天挂袜子的上限";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -12757:
               msg = "天使挑战次数已达上限！";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
               break;
            case -100214:
               msg = "请先领取奖励物品";
               GV.onlineSocket.dispatchEvent(new EventTaomee("GetFriendBoxFail"));
         }
         if(DebugManager.DEBUG)
         {
            Alert.showAlert(MainManager.getAlertLevel(),msg,"",Alert.CHANG_ALERT,"iknow",true,false,"D");
         }
      }
   }
}

