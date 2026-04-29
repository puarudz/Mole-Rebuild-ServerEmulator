package com.mole.app.task.action
{
   import com.event.EventTaomee;
   import com.mole.app.map.MapLevel;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.debug.DebugManager;
   import com.view.MapManageView.MapManageView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class TaskSetAttributeAction extends TaskActionBase
   {
      
      private var _attribute:Object;
      
      private var _level:String;
      
      private var _resName:String;
      
      public function TaskSetAttributeAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._level = String(actionXml.@Level);
         this._resName = String(actionXml.@ResName);
         this._attribute = new Object();
         this._attribute.visible = uint(actionXml.@Visible) == 1;
      }
      
      override public function execute() : void
      {
         var attName:String = null;
         var mapLevel:MapLevel = MapManageView.inst.mapLevel;
         var levelObj:DisplayObjectContainer = mapLevel[this._level];
         var disObj:DisplayObject = levelObj.getChildByName(this._resName);
         if(Boolean(disObj) && Boolean(this._attribute))
         {
            for(attName in this._attribute)
            {
               if(disObj.hasOwnProperty(attName))
               {
                  disObj[attName] = this._attribute[attName];
                  GV.onlineSocket.dispatchEvent(new EventTaomee("MapObjectDisappear",[this._resName,this._level,attName,this._attribute[attName]]));
               }
               else
               {
                  DebugManager.traceMsg("地圖：" + this._level + "層元件-->" + this._resName + "沒有屬性-->" + attName);
               }
            }
         }
         else
         {
            DebugManager.traceMsg("地圖：" + this._level + "層找不到元件-->" + this._resName);
         }
         nextAction();
      }
   }
}

