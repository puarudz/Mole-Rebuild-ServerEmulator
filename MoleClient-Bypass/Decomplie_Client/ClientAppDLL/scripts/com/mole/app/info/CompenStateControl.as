package com.mole.app.info
{
   import com.global.staticData.XMLInfo;
   
   public class CompenStateControl
   {
      
      private static var _inst:CompenStateControl;
      
      public function CompenStateControl()
      {
         super();
      }
      
      public static function get inst() : CompenStateControl
      {
         if(!_inst)
         {
            _inst = new CompenStateControl();
         }
         return _inst;
      }
      
      public function init() : CompenStateInfo
      {
         var compenStateInfo:CompenStateInfo = null;
         var tempXML:XML = null;
         var xml:XML = XML(new XMLInfo.Compensation());
         for each(tempXML in xml.elements("buChang"))
         {
            compenStateInfo = new CompenStateInfo(tempXML);
         }
         return compenStateInfo;
      }
   }
}

