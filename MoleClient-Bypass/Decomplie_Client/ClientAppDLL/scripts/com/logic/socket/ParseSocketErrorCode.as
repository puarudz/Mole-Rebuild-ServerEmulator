package com.logic.socket
{
   import com.common.msgHead.MsgHead;
   import com.core.info.LocalUserInfo;
   import com.core.socketlogic.ClientOnLineSerSocket;
   import com.core.socketlogic.noticeExit.NoticeExitRes;
   import com.core.socketlogic.servermsg.ServerMsg;
   import com.event.EventTaomee;
   import com.global.staticData.MapsConfig;
   import com.module.messageTips.MT;
   import flash.events.Event;
   
   public class ParseSocketErrorCode
   {
      
      private static var onlineSerSocket:ClientOnLineSerSocket;
      
      public static var ERROR_CMD_:String = "ERROR_CMD_";
      
      private static var mapdoctor_arr:Array = [-100013,-100014,-100015,-100016,-100017,-100018];
      
      public static var isError:Boolean = false;
      
      public function ParseSocketErrorCode()
      {
         super();
      }
      
      public static function setSocketInstance(i:ClientOnLineSerSocket) : void
      {
         onlineSerSocket = i;
      }
      
      public static function parse(errorID:Number) : void
      {
         var mapid:int = 0;
         var obj:Object = null;
         if(errorID == -11119)
         {
            mapid = LocalUserInfo.getMapID();
            if(Boolean(MapsConfig.MapsInfo[mapid]) && mapid != 56)
            {
               MT.pop(errorID);
            }
            else
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_dididou",errorID));
            }
         }
         else if(errorID == -100207)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_dididou",errorID));
         }
         else if(errorID == -12734)
         {
            GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_dididou",errorID));
         }
         else if(GV.itemID > -1)
         {
            obj = {};
            MT.pop(errorID);
            if(errorID == -10001)
            {
               obj.Error = "-10001";
               GV.onlineSocket.dispatchEvent(new EventTaomee("notice_exit",obj));
            }
            else if(errorID == -10025)
            {
               isError = true;
            }
            else if(errorID == -10003)
            {
               obj.error = -10003;
               GV.onlineSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.OFF_LINE,obj));
            }
            else if(errorID == -10006)
            {
               obj.error = -10006;
               obj.msg = "您的級別不夠，過陣子再來試試？";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.NOTENOUGH_LEVEl,obj));
            }
            else if(errorID == -10007)
            {
               obj.error = -10007;
               obj.msg = "抱歉這個位置已經有人\n換別的位置試試？";
               GV.onlineSocket.dispatchEvent(new EventTaomee("error_game_momo"));
               GV.onlineSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.ERROR_GAME,obj));
            }
            else if(errorID == -10008)
            {
               obj.error = -10008;
               obj.msg = "房間或伺服器人數已滿";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.ROOM_SERVER_FULL,obj));
            }
            else if(errorID == -10009)
            {
               obj.error = -10009;
               obj.msg = "****正繁忙，請耐心等待";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.SYSTEM_BUSY,obj));
            }
            else if(errorID == -10010)
            {
               obj.error = -10010;
               obj.msg = "您的米米號******在別處登陸！";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.OTHER_SPACE_LOGIN,obj));
            }
            else if(errorID == -1002)
            {
               obj.error = -1002;
               obj.msg = "系統出錯！";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.OTHER_SPACE_LOGIN,obj));
            }
            else if(errorID == -10011)
            {
               obj.error = -10011;
               obj.msg = "已經在用戶列表中！";
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.ALREADY_ONLIST,obj));
            }
            else if(errorID == -10012)
            {
               obj.error = -10012;
               GV.onlineSocket.dispatchEvent(new EventTaomee("dirty_word"));
            }
            else if(errorID == -10024)
            {
               GV.isDefault = true;
               GV.onlineClass.dispatchEvent(new EventTaomee(NoticeExitRes.NOTICE_EXIT,{"Error":"2"}));
            }
            else if(errorID == -14001)
            {
               onlineSerSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.ERROR_GETCANDY_MOMO));
               GV.onlineSocket.dispatchEvent(new EventTaomee(ClientOnLineSerSocket.ERROR_GETCANDY_MOMO));
            }
            else if(errorID == -11132)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("petFreak_error"));
            }
            else if(errorID == -10015)
            {
               GV.onlineSocket.dispatchEvent(new EventTaomee("petAward"));
               GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_dididou",errorID));
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10016)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10017)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10018)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10020)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10021)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12692)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12694)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12695)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12696)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12697)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12101)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12655)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12102)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -10022)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -13001)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -13001)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12654)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11150)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11152)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11153)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11154)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11155)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11156)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11202)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11203)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11204)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -11157)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12667)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -100132)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -100198)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -100213)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -100214)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12574)
            {
               ServerMsg.MsgForserver(errorID);
            }
            else if(errorID == -12757)
            {
               if(ServerMsg.errorBool)
               {
                  ServerMsg.errorBool = false;
               }
               else
               {
                  ServerMsg.MsgForserver(errorID);
               }
            }
            else if(errorID == -50012)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50013)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50015)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50105)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50023)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50016)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50107)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50017)
            {
               disCoinEvent(errorID);
            }
            else if(errorID == -50019)
            {
               disCoinEvent(errorID);
            }
            else if(errorID != -100317)
            {
               if(errorID == -11134)
               {
                  GV.onlineSocket.dispatchEvent(new Event("WATERALREADY"));
               }
               else if(errorID == -11140)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("petAward"));
               }
               else if(errorID == -100004)
               {
                  GV.onlineSocket.dispatchEvent(new Event("SMCMONEY_ERROR"));
               }
               else if(errorID == -12524)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("vip_lamu_flag",{"flag":errorID}));
               }
               else if(errorID == -12525)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("vip_lamu_flag",{"flag":errorID}));
               }
               else if(errorID == -12529)
               {
                  GV.onlineSocket.dispatchEvent(new EventTaomee("vip_lamu_flag",{"flag":errorID}));
               }
               else if(errorID != -12528)
               {
                  if(errorID == -12532)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_jjlex_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12533)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_jjlex_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12534)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_jjlex_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -100008)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_jjlex_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12553)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("petclass_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12554)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("petclass_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12555)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("petclass_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12556)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("petclass_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -100040)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("ex_brave_errorID",{"ID":errorID}));
                  }
                  else if(mapdoctor_arr.indexOf(errorID) != -1)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_mapdoc_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -12558)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("dis_ClothHouseBox_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -100050)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("race_sport_errorID",{"ID":errorID}));
                  }
                  else if(errorID == -100058)
                  {
                     GV.onlineSocket.dispatchEvent(new EventTaomee("back_100058_errorID",{"ID":errorID}));
                  }
                  else if(errorID != -100084)
                  {
                     if(errorID == -100093)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("momoJob_errorID",{"id":errorID}));
                     }
                     else if(errorID == -12590 || errorID == -12587 || errorID == -12588 || errorID == -12589)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("npcJob_errorID",{
                           "id":errorID,
                           "cmd":MsgHead.Command
                        }));
                     }
                     else if(errorID == -100103)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_-100103",{
                           "id":errorID,
                           "cmd":MsgHead.Command
                        }));
                     }
                     else if(errorID == -12627)
                     {
                        GV.onlineSocket.dispatchEvent(new Event("ERROR_CMD_-12621"));
                     }
                     else if(errorID == -100141 || errorID == -100142)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("getFemaleTiger_error",{"errorID":errorID}));
                     }
                     else if(errorID == -100153)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("haveGotPtop_error",{"errorID":errorID}));
                     }
                     else if(errorID == -12698)
                     {
                        GV.onlineSocket.dispatchEvent(new EventTaomee("getHotCupAwardsError",{"errorID":errorID}));
                     }
                  }
               }
            }
         }
         else if(GV.itemID == -1)
         {
            trace("\n\n\n警告：務必將GV.itemID設置回0.\n\n");
         }
         var cmd:String = String(MsgHead.Command);
         GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_" + cmd,errorID));
         GV.onlineSocket.dispatchEvent(new EventTaomee("ERROR_CMD_" + errorID,cmd));
      }
      
      private static function disCoinEvent(num:int) : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("dis_coin_errorID",{"ID":num}));
      }
   }
}

