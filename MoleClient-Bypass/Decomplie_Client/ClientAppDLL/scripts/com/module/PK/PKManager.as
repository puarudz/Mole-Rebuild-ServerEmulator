package com.module.PK
{
   import com.event.EventTaomee;
   import com.logic.socket.PKsocket.GameKingSocket;
   import flash.events.MouseEvent;
   
   public class PKManager
   {
      
      public static var PKName:String;
      
      public static var PKUID:uint;
      
      public static var PKGID:uint;
      
      public static var KingLevelName:Array = ["火心勇士","火光勇士","火焰勇士","火岩勇士","火翼勇士","火神勇士"];
      
      public static var PKGameArr:Array = [{
         "id":1,
         "name":"開心大廚 ",
         "minscore":500,
         "mapid":17
      },{
         "id":9,
         "name":"冰上總動員",
         "minscore":600,
         "mapid":5
      },{
         "id":8,
         "name":"釣魚",
         "minscore":1000,
         "mapid":8
      },{
         "id":14,
         "name":"拼圖",
         "minscore":3000,
         "mapid":16
      },{
         "id":19,
         "name":"摩爾小農夫",
         "minscore":800,
         "mapid":10
      },{
         "id":20,
         "name":"摘果實",
         "minscore":300,
         "mapid":41
      },{
         "id":24,
         "name":"抓螢火蟲",
         "minscore":1000,
         "mapid":41
      },{
         "id":25,
         "name":"豬豬快跑",
         "minscore":900,
         "mapid":9
      },{
         "id":27,
         "name":"跳水",
         "minscore":200,
         "mapid":7
      },{
         "id":26,
         "name":"警室射擊",
         "minscore":250,
         "mapid":44
      },{
         "id":35,
         "name":"R4機器人",
         "minscore":300,
         "mapid":56
      },{
         "id":36,
         "name":"連連看",
         "minscore":2000,
         "mapid":22
      },{
         "id":18,
         "name":"救人質訓練",
         "minscore":15000,
         "mapid":44
      },{
         "id":41,
         "name":"找茬",
         "minscore":2400,
         "mapid":22
      },{
         "id":46,
         "name":"零用錢大戰",
         "minscore":600,
         "mapid":69
      },{
         "id":47,
         "name":"冰淇淋小屋",
         "minscore":150,
         "mapid":1
      },{
         "id":48,
         "name":"金牌消防員",
         "minscore":3000,
         "mapid":75
      },{
         "id":49,
         "name":"快樂拼盤",
         "minscore":100,
         "mapid":6
      },{
         "id":55,
         "name":"陽光搬運工",
         "minscore":100,
         "mapid":79
      },{
         "id":56,
         "name":"救治小拉姆",
         "minscore":300,
         "mapid":70
      },{
         "id":59,
         "name":"摩爾愛跳舞",
         "minscore":100,
         "mapid":7
      }];
      
      private static var instance:PKManager = null;
      
      public function PKManager()
      {
         super();
      }
      
      public static function getKingLevelName(score:int) : String
      {
         if(score >= 400)
         {
            if(int((score - 400) / 2000) > 5)
            {
               return KingLevelName[5];
            }
            return KingLevelName[int((score - 400) / 2000)];
         }
         return "火點勇士";
      }
      
      public static function kingLevel(num:int) : uint
      {
         if(num >= 400)
         {
            return int((num - 400) / 2000) + 2;
         }
         return 1;
      }
      
      public static function getInstance() : PKManager
      {
         return instance = instance || new PKManager();
      }
      
      public static function getGameName(gameid:uint) : Object
      {
         for(var i:uint = 0; i < PKGameArr.length; i++)
         {
            if(PKGameArr[i].id == gameid)
            {
               return PKGameArr[i];
            }
         }
         return {
            "id":1,
            "name":"開心大廚",
            "minscore":500,
            "mapid":1
         };
      }
      
      public function init(pkbtn:*, pkuserid:uint, username:String) : void
      {
         PKName = username;
         PKUID = pkuserid;
         BC.addEvent(this,pkbtn,MouseEvent.CLICK,this.openUserGameList);
      }
      
      public function openUserGameList(e:MouseEvent) : void
      {
         GV.onlineSocket.addEventListener("read_" + 1462,this.ShowUserGame);
         GameKingSocket.usergamelist(PKUID);
      }
      
      public function ShowUserGame(e:EventTaomee) : void
      {
         var obj:Object = null;
         var j:uint = 0;
         GV.onlineSocket.removeEventListener("read_" + 1462,this.ShowUserGame);
         var serverarr:Array = e.EventObj.arr;
         var arr:Array = new Array();
         for(var i:uint = 0; i < PKGameArr.length; i++)
         {
            obj = new Object();
            obj.GameID = PKGameArr[i].id;
            obj.GameScore = 0;
            obj.GameFlag = 0;
            for(j = 0; j < serverarr.length; j++)
            {
               if(serverarr[j].GameID == obj.GameID)
               {
                  obj.GameScore = serverarr[j].GameScore;
                  obj.GameFlag = serverarr[j].GameFlag;
                  break;
               }
            }
            arr.push(obj);
         }
         PKHePanel.init(arr,PKUID,PKName);
      }
   }
}

