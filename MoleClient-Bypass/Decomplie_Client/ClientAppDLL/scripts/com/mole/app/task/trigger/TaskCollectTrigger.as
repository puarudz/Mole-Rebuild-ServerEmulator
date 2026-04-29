package com.mole.app.task.trigger
{
   import com.common.Alert.Alert;
   import com.common.data.goodsInfo.GoodsInfo;
   import com.event.EventTaomee;
   import com.logic.socket.CollectRrandomItemLoginc.CollectRrandomItemRes;
   import com.mole.app.task.TaskStep;
   
   public class TaskCollectTrigger extends TaskTriggerBase
   {
      
      private var _goodsID:uint;
      
      private var _goodsAmount:uint;
      
      private var _currentGoodsAmount:uint;
      
      public function TaskCollectTrigger(triggerXml:XML, step:TaskStep)
      {
         super(triggerXml,step);
         this._goodsID = uint(triggerXml.@ID);
         this._goodsAmount = uint(triggerXml.@Amount);
         _mapID = uint(triggerXml.@MapID);
         if(_mapID == 0)
         {
            _mapID = step.mapID;
         }
      }
      
      override public function check(data:Object) : Object
      {
         var actionFlag:Boolean = false;
         var curMapID:uint = data as uint;
         if(_mapID == curMapID && isBit && isNoBit)
         {
            GV.onlineSocket.addEventListener(CollectRrandomItemRes.COLLECT_GOODS,this.collectGoods);
            actionFlag = true;
         }
         return actionFlag;
      }
      
      private function collectGoods(evt:EventTaomee) : void
      {
         var itemID:uint = uint(evt.EventObj.goodsID);
         var count:uint = uint(evt.EventObj.goodsCount);
         if(itemID != this._goodsID)
         {
            return;
         }
         this._currentGoodsAmount += count;
         if(this._currentGoodsAmount == this._goodsAmount)
         {
            Alert.smileAlart("恭喜已成功收集到了" + this._goodsAmount + "个" + GoodsInfo.getItemNameByID(this._goodsID),function():void
            {
               startAction();
            });
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         GV.onlineSocket.removeEventListener(CollectRrandomItemRes.COLLECT_GOODS,this.collectGoods);
      }
   }
}

