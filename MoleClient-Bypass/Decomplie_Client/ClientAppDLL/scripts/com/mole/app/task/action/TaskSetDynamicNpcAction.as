package com.mole.app.task.action
{
   import com.module.npc.NPC;
   import com.module.npc.npcInstance.MoleNPC;
   import com.mole.app.task.trigger.TaskTriggerBase;
   import com.mole.debug.DebugManager;
   
   public class TaskSetDynamicNpcAction extends TaskActionBase
   {
      
      private var _attribute:Object;
      
      private var _npcID:uint;
      
      public function TaskSetDynamicNpcAction(actionXml:XML, parent:TaskTriggerBase)
      {
         super(actionXml,parent);
         this._npcID = uint(actionXml.@NPCID);
         this._attribute = new Object();
         this._attribute.visible = uint(actionXml.@Visible) == 1;
      }
      
      override public function execute() : void
      {
         var attName:String = null;
         var npc:MoleNPC = NPC.getNPCInstance(1);
         if(Boolean(npc))
         {
            for(attName in this._attribute)
            {
               if(npc.hasOwnProperty(attName))
               {
                  npc[attName] = this._attribute[attName];
               }
            }
         }
         else
         {
            DebugManager.traceMsg("地圖中找不到NPC:" + this._npcID);
         }
         nextAction();
      }
   }
}

