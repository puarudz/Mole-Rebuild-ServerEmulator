package com.module.ListSMC
{
   import com.core.newloader.XMLLoader;
   import com.event.EventTaomee;
   import com.event.XMLLoadEvent;
   import flash.display.Sprite;
   
   public class ExNPC extends Sprite
   {
      
      public static var ALLDATE:String = "allNPCJobdate";
      
      public static var ExNPC_arr:Array = new Array();
      
      private var xml:XML;
      
      private var NPC_arr:Array = new Array();
      
      public function ExNPC(url:*)
      {
         super();
         var urls:* = url;
         for(var i:uint = 0; i < 200; i++)
         {
            this.NPC_arr.push(0);
         }
         var tempversion:XMLLoader = new XMLLoader(urls);
         tempversion.addEventListener(XMLLoadEvent.ON_SUCCESS,this.XMLOverHandler);
         tempversion.addEventListener(XMLLoadEvent.ERROR,this.XMLFailHandler);
         tempversion.doLoad();
      }
      
      public function XMLOverHandler(evt:XMLLoadEvent) : void
      {
         var lg:int = 0;
         var i:uint = 0;
         var myObjss:Object = null;
         var npc_obj:Object = null;
         var nowlg:* = undefined;
         var a:uint = 0;
         var job_obj:Object = null;
         try
         {
            this.xml = evt.getXML();
            this.xml.ignoreWhitespace = true;
            lg = this.xml.child("item").length();
            for(i = 0; i < lg; i++)
            {
               npc_obj = new Object();
               npc_obj.NPCID = this.xml.item[i].@NPCID;
               npc_obj.npcName = this.xml.item[i].@NPCname;
               npc_obj.npcNameE = this.xml.item[i].@NPCnamess;
               npc_obj.nowxml = this.xml.children()[i];
               npc_obj.npcMsg = npc_obj.nowxml.npcTips.@msg;
               npc_obj.npcTip = npc_obj.nowxml.npcTips.@tips;
               npc_obj.Job = npc_obj.nowxml.npcTips.@Job;
               npc_obj.npcJob = [];
               if(npc_obj.Job != "no")
               {
                  nowlg = npc_obj.nowxml.child("JobList").length();
                  for(a = 0; a < nowlg; a++)
                  {
                     job_obj = this.getInfo(npc_obj.nowxml,a);
                     npc_obj.npcJob.push(job_obj);
                  }
               }
               this.NPC_arr[npc_obj.NPCID] = npc_obj;
            }
            myObjss = {"NPC_arr":this.NPC_arr};
            dispatchEvent(new EventTaomee(ALLDATE,myObjss));
         }
         catch(e:*)
         {
            trace("加載xml出錯：",e);
         }
      }
      
      private function getInfo(nowxml:XML, a:uint) : Object
      {
         var job_obj:Object = new Object();
         job_obj.JobID = nowxml.JobList[a].@JobID;
         job_obj.msg0 = this.chart(nowxml.JobList[a].@msg0);
         job_obj.msg1 = this.chart(nowxml.JobList[a].@msg1);
         job_obj.msg2 = this.chart(nowxml.JobList[a].@msg2);
         job_obj.msg3 = this.chart(nowxml.JobList[a].@msg3);
         job_obj.needGood = this.Arraychart(nowxml.JobList[a].@needGood);
         job_obj.getGood = this.Arraychart(nowxml.JobList[a].@getGood);
         job_obj.needGoodname = this.Arraychart(nowxml.JobList[a].@needGoodname);
         job_obj.getGoodname = this.Arraychart(nowxml.JobList[a].@getGoodname);
         return job_obj;
      }
      
      public function XMLFailHandler(evt:XMLLoadEvent) : void
      {
      }
      
      public function chart(ss:*) : String
      {
         var s_arr:* = undefined;
         var ai:String = ";";
         if(ss.indexOf(ai) != -1)
         {
            s_arr = ss.split(";");
            ss = s_arr[0] + "\r" + s_arr[1];
         }
         return ss;
      }
      
      public function Arraychart(ss:*) : Array
      {
         var ai:String = ";";
         var s_arr:Array = new Array();
         if(ss.indexOf(ai) != -1)
         {
            s_arr = ss.split(";");
         }
         else
         {
            s_arr.push(ss);
         }
         return s_arr;
      }
   }
}

