package com.module.acclimationSMC.socket
{
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.global.staticData.XMLInfo;
   import com.logic.socket.GetLimitStatus;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class AcclimationSMC_GiftInfo extends EventDispatcher
   {
      
      private static var _inst:AcclimationSMC_GiftInfo;
      
      public static var GET_JOBOVER_FLAG:String = "get_job_overInfo";
      
      public static var GET_BAGGIFT_FLAG:String = "get_bag_overInfo";
      
      public function AcclimationSMC_GiftInfo(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function getInstance() : AcclimationSMC_GiftInfo
      {
         if(_inst == null)
         {
            _inst = new AcclimationSMC_GiftInfo();
         }
         return _inst;
      }
      
      public function chartJobOverFlag() : void
      {
         GV.onlineSocket.addEventListener("SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.back11009);
         GetLimitStatus.send([10050,10051,10052,10053,10054,10055]);
      }
      
      private function back11009(e:*) : void
      {
         var _over:Array;
         var _arr:Array;
         var _numArr:Array;
         var p:uint;
         var parr:Array;
         var i:uint;
         var xml:XML;
         var flag:uint = 0;
         var _gxml:XML = null;
         GV.onlineSocket.removeEventListener("SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.back11009);
         _over = [];
         _arr = [0,1,3,4];
         _numArr = e.bodyInfo.getInfo as Array;
         p = uint(_numArr[5]);
         parr = [];
         i = 0;
         for(i = 0; i < 5; i++)
         {
            flag = uint(Boolean(p >> i & 1));
            parr.push(flag);
            _over.push(-1);
         }
         _numArr[5] = parr;
         xml = XML(new XMLInfo.mole_beast_task());
         for(i = 0; i < 4; i++)
         {
            _gxml = XML(xml.task.(@id == _arr[i]));
            if(_numArr[_arr[i]] >= _gxml.@num)
            {
               if(_numArr[5][_arr[i]] == 0)
               {
                  _over[_arr[i]] = 0;
               }
               else
               {
                  _over[_arr[i]] = 1;
               }
            }
         }
         dispatchEvent(new EventTaomee(GET_JOBOVER_FLAG,{
            "numArr":_numArr,
            "overArr":_over
         }));
      }
      
      public function chartBagOverFlag() : void
      {
         BC.addEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.onGetInfo);
         GetLimitStatus.send([10049]);
      }
      
      private function onGetInfo(e:*) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"SocketEvent_Data" + CommandID.cli_proto_get_limit_info,this.onGetInfo);
         var arr:Array = e.bodyInfo.getInfo as Array;
         dispatchEvent(new EventTaomee(GET_BAGGIFT_FLAG,{"gameNum":arr[0]}));
      }
   }
}

