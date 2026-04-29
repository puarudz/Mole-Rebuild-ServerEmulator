package com.module.npc.disposition
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class DispositionManage implements I_DispositionManage
   {
      
      private var disNameArray:Array = [];
      
      private var disInstanceArray:Array = [];
      
      private var disInstanceLib:Dictionary = new Dictionary(true);
      
      private var _info:Object;
      
      private var _npcName:String;
      
      public function DispositionManage(npcName:String, info:Object)
      {
         super();
         this._npcName = npcName;
         this._info = info;
      }
      
      public function upData() : void
      {
         if(!this._info || !this._info.list)
         {
            return;
         }
         this.disNameArray = String(this._info.list).split(",");
         this.disNameArray.every(function(name:String, index:int, arr:Array):void
         {
            var cl:Class = null;
            var dis:I_Disposition = null;
            try
            {
               cl = getDefinitionByName("com.module.npc.disposition." + _npcName + "::" + name) as Class;
               if(Boolean(cl))
               {
                  dis = new cl();
                  disInstanceArray.push(dis);
                  disInstanceLib[name] = dis;
               }
            }
            catch(E:*)
            {
               trace("警告:\n",E);
            }
         });
      }
      
      public function get dispositionNameList() : Array
      {
         return this.disNameArray;
      }
      
      public function get dispositionInstanceList() : Array
      {
         return this.disInstanceArray;
      }
      
      public function getDispositionInstance(dispositionName:String) : I_Disposition
      {
         return this.disInstanceLib[dispositionName];
      }
      
      public function destroy(E:* = null) : void
      {
         this.dispositionInstanceList.every(function(dis:I_Disposition, index:int, arr:Array):void
         {
            dis.destroy();
         });
      }
   }
}

