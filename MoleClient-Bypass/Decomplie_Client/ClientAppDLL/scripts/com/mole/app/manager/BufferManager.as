package com.mole.app.manager
{
   import com.common.data.HashMap;
   import com.event.EventTaomee;
   import com.global.staticData.CommandID;
   import com.logic.socket.buffer.BufferGetProtocol;
   import com.mole.net.events.SocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BufferManager
   {
      
      private static var _eventDispatcher:EventDispatcher;
      
      private static const BUFFER_CHANGE:String = "BufferChange";
      
      public static const EAT_GLUE_PUDDING:uint = 100;
      
      public static const ATOM_GAME_LEVEL:uint = 101;
      
      public static const SEARCH_BTN_TIMES:uint = 102;
      
      public static const GET_PRESENT_TIMES:uint = 0;
      
      public static const CATCH_GHOST_TIMES:uint = 0;
      
      public static const FIVEYEAR_BOOKMOVED:uint = 103;
      
      public static const TOMMY_SPREKED:uint = 104;
      
      public static const ENTER_CLOTH_VIEW:uint = 105;
      
      public static const KFCTASKFIVE:uint = 106;
      
      public static const KFCINVITED:uint = 107;
      
      public static const KFCWATCHED:uint = 108;
      
      public static const OPENTART:uint = 109;
      
      public static const TARTINVITED:uint = 110;
      
      public static const JEWELBOX_SL:uint = 111;
      
      public static const KFCMAKEHANBAO:uint = 112;
      
      public static const SUPKARMAS_SL:uint = 113;
      
      public static const KFCFOODSTORE_SELL:uint = 114;
      
      public static const KFCFOODSTORE_MAKE:uint = 115;
      
      public static const KFCFOODSTORE_NUT:uint = 116;
      
      public static const KFCFOODSTORE_SPE:uint = 117;
      
      public static const ELEMENT_KNIGHT_GODDESS:uint = 118;
      
      public static const KFC_SPY_NECK_STEP:uint = 119;
      
      public static const TASK_382_OVER_BOX:uint = 120;
      
      public static const KFC_JEWEL_BOX_SWAP:uint = 121;
      
      public static const TOTEM_TASK_STEP:uint = 122;
      
      public static const KFC_SPY_SMALL_CLERK_STEP:uint = 123;
      
      public static const KFC_DISAPPLE_NOISE_STEP:uint = 124;
      
      public static const JIANGLI_RR_GETED:uint = 125;
      
      public static const KFC_MAGIC_DETECT_STEP:uint = 126;
      
      public static const FIRE_VULCAN_CUP:uint = 127;
      
      public static const MOLE_RABBIT:uint = 128;
      
      public static const SMALL_FIRE_HORSE:uint = 129;
      
      public static const MOLIYA_BOOK:uint = 130;
      
      public static const KFC_TEACHERDAY_ACT:uint = 131;
      
      public static const ASTROLOGY_OR_GOSSIP_ACT:uint = 132;
      
      public static const TIME_MACHINE:uint = 133;
      
      public static const POLICE_DELEGATE:uint = 134;
      
      public static const KFC_MAGIC_CHRISTMAS_HAT:uint = 135;
      
      public static const CHECK_ITEM_INDEX:uint = 136;
      
      public static const MEMOIRS_JANUARY_STATE:uint = 137;
      
      public static const MEMOIRS_FEBRUARY_STATE:uint = 138;
      
      public static const MEMOIRS_March_STATE:uint = 139;
      
      public static const MEMOIRS_April_STATE:uint = 140;
      
      public static const MEMOIRS_MAY_STATE:uint = 141;
      
      public static const MEMOIRS_JUNE_STATE:uint = 142;
      
      public static const MEMOIRS_JULE_STATE:uint = 143;
      
      public static const MEMOIRS_AUGUST_STATE:uint = 144;
      
      public static const MEMOIRS_SEPTEMBER_STATE:uint = 145;
      
      public static const MEMOIRS_OCT_STATE:uint = 146;
      
      public static const MEMOIRS_NOV_STATE:uint = 147;
      
      public static const MEMOIRS_DEC_STATE:uint = 148;
      
      public static const MEMOIRS_MEME_SHARE:uint = 149;
      
      public static const TASK_627_STATE:uint = 150;
      
      public static const TASK_PLAY_CARTOON_ONCE:uint = 151;
      
      public static const LAMU_DRIVE_PIG_ONCE:uint = 152;
      
      public static const LAMU_NIENIE_DOUGH_GAME:uint = 153;
      
      public static const STAR_DEVELOP_INFO:uint = 154;
      
      public static const STAR_DEVELOP_TIME:uint = 155;
      
      public static const FATHERSDAY_TALK_DATE:uint = 157;
      
      public static const FATHERSDAY_TALK_INFO:uint = 158;
      
      public static const YINHUA_LAMU_STATE:uint = 156;
      
      public static const TASK_382_201408_1:uint = 159;
      
      public static const TASK_382_201408_2:uint = 160;
      
      public static var _buffer:HashMap = new HashMap();
      
      public function BufferManager()
      {
         super();
      }
      
      public static function getBuffer(id:uint) : void
      {
         if(_buffer.containsKey(id))
         {
            dataChange(id,_buffer.getValue(id));
            return;
         }
         _buffer.add(id,0);
         OnlineManager.addCmdListener(CommandID.BUFFER_GET,onBufferGet);
         OnlineManager.send(CommandID.BUFFER_GET,id);
      }
      
      private static function onBufferGet(e:SocketEvent) : void
      {
         OnlineManager.removeCmdListener(CommandID.BUFFER_GET,onBufferGet);
         var bufferProtocol:BufferGetProtocol = e.bodyInfo;
         _buffer.add(bufferProtocol.type,bufferProtocol.data);
         dataChange(bufferProtocol.type,bufferProtocol.data);
      }
      
      private static function dataChange(id:uint, data:uint) : void
      {
         dispatchEvent(new EventTaomee(BUFFER_CHANGE + id,data));
      }
      
      public static function setBuffer(id:uint, data:uint) : void
      {
         OnlineManager.send(CommandID.BUFFER_SET,id,data);
         _buffer.add(id,data);
      }
      
      public static function addBufferEvent(id:uint, backFun:Function) : void
      {
         addEventListener(BUFFER_CHANGE + id,backFun);
      }
      
      public static function removeBufferEvent(id:uint, backFun:Function) : void
      {
         removeEventListener(BUFFER_CHANGE + id,backFun);
      }
      
      private static function getEventDispathcer() : EventDispatcher
      {
         if(_eventDispatcher == null)
         {
            _eventDispatcher = new EventDispatcher();
         }
         return _eventDispatcher;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getEventDispathcer().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getEventDispathcer().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         getEventDispathcer().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getEventDispathcer().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getEventDispathcer().willTrigger(type);
      }
   }
}

