package com.mole.app.map.info
{
   import com.mole.app.info.NPCDialogInfo;
   import com.mole.app.info.NPCDialogOptionInfo;
   import com.mole.app.task.TaskManager;
   import com.mole.config.info.Config;
   
   public class MapTalkInfo
   {
      
      private var _npcDialogInfo:NPCDialogInfo;
      
      private var _id:uint;
      
      private var _isShowTask:Boolean;
      
      public function MapTalkInfo()
      {
         super();
      }
      
      public function initXml(talkInfo:XML) : void
      {
         var optionInfo:NPCDialogOptionInfo = null;
         this._id = uint(talkInfo.@ID);
         this._isShowTask = uint(talkInfo.@AddTaskOption) == 1;
         var optionList:Array = String(talkInfo.@Option).split(Config.SEPARATOR);
         var cmdList:Array = String(talkInfo.@Cmd).split(Config.SEPARATOR);
         var paramList:Array = String(talkInfo.@Param).split(Config.SEPARATOR);
         var dataList:Array = String(talkInfo.@Data).split(Config.SEPARATOR);
         var npcOptionList:Array = new Array();
         for(var i:uint = 0; i < optionList.length; i++)
         {
            optionInfo = new NPCDialogOptionInfo(optionList[i],cmdList[i],paramList[i],i == optionList.length - 1,dataList[i]);
            npcOptionList.push(optionInfo);
         }
         this._npcDialogInfo = new NPCDialogInfo(talkInfo.@NpcID,talkInfo.@Face,talkInfo.@Msg,npcOptionList,uint(talkInfo.@IsHideClose) == 1);
      }
      
      public function get npcDialogInfo() : NPCDialogInfo
      {
         var optionList:Array = this._npcDialogInfo.optionList;
         if(this._isShowTask)
         {
            optionList = TaskManager.clickNpc(this._npcDialogInfo.id).concat(optionList);
         }
         return new NPCDialogInfo(this._npcDialogInfo.id,this._npcDialogInfo.face,this._npcDialogInfo.msg,optionList,this._npcDialogInfo.isHideClose);
      }
      
      public function get npcDialogInfoForMachine() : NPCDialogInfo
      {
         var optionList:Array = this._npcDialogInfo.optionList;
         return new NPCDialogInfo(this._npcDialogInfo.id,this._npcDialogInfo.face,this._npcDialogInfo.msg,optionList,this._npcDialogInfo.isHideClose);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
   }
}

