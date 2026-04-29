package com.mole.app.task.action
{
   import com.event.EventTaomee;
   import com.logic.socket.CollectRrandomItemLoginc.CollectRrandomItemRes;
   import com.mole.app.task.trigger.TaskTriggerBase;
   
   public class TaskCollectionAction extends TaskActionBase
   {
      
      private var _itemID:uint;
      
      public function TaskCollectionAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._itemID = uint(actionXml.@ItemID);
      }
      
      override public function execute() : void
      {
         GV.GF.collectRandomItem(this._itemID);
         GV.onlineSocket.addEventListener(CollectRrandomItemRes.COLLECT_GOODS,this.collectGoods);
      }
      
      private function collectGoods(evt:EventTaomee) : void
      {
         var itemID:uint = uint(evt.EventObj.goodsID);
         var count:uint = uint(evt.EventObj.goodsCount);
         if(itemID != this._itemID)
         {
            return;
         }
         nextAction();
      }
   }
}

