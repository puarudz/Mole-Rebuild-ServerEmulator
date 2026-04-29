package com.global.staticData.database.npc_JCX_Task
{
   import flash.utils.Dictionary;
   
   public class InfotransportJobListXML
   {
      
      public static const transportJobListXML:Array = [];
      
      public static const transportJobLib:Dictionary = new Dictionary(true);
      
      transportJobListXML[0] = {
         "JobID":3,
         "JobType":0,
         "JobName":"尤尤的訂單",
         "JobDesc":"尤尤的小豬小鴨每天都要吃好多飼料喲！小小駕駛員們，趕快來幫忙駕車送貨給尤尤啦！",
         "JobStartAd1":"梅森小屋",
         "JobStartAd2":"找梅森",
         "JobItem":"精緻雞飼料",
         "ItemID":190472,
         "Timer":300,
         "JobEndAd1":"陽光草舍",
         "JobEndAd2":"交給尤尤",
         "JobCar":1300005,
         "JobAward":"200個摩爾豆",
         "JobLimitTime":"5分鐘",
         "tips":"飼料任務：把梅森的飼料送給尤尤"
      };
      transportJobLib["3"] = transportJobListXML[0];
      transportJobListXML[1] = {
         "JobID":4,
         "JobType":0,
         "JobName":"西索的訂單",
         "JobDesc":"西索製作新衣服可是需要大量的原材料呀！快去陽光草舍把羊毛送給西索吧！",
         "JobStartAd1":"陽光草舍",
         "JobStartAd2":"找尤尤",
         "JobItem":"羊毛",
         "ItemID":190474,
         "Timer":600,
         "JobEndAd1":"服裝店",
         "JobEndAd2":"交給西索",
         "JobCar":1300005,
         "JobAward":"250個摩爾豆",
         "JobLimitTime":"10分鐘",
         "tips":"羊毛任務：幫尤尤把羊毛送給西索"
      };
      transportJobLib["4"] = transportJobListXML[1];
      
      public function InfotransportJobListXML()
      {
         super();
      }
   }
}

