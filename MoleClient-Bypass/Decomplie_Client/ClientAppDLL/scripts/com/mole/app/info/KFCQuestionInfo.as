package com.mole.app.info
{
   public class KFCQuestionInfo
   {
      
      public var id:uint;
      
      public var content:String;
      
      public var optionVec:Vector.<String>;
      
      public var answer:uint;
      
      public function KFCQuestionInfo(xml:XML)
      {
         super();
         this.id = uint(xml.@ID);
         this.content = String(xml.@Content);
         this.optionVec = new Vector.<String>();
         this.optionVec.push(String(xml.@OptionA));
         this.optionVec.push(String(xml.@OptionB));
         this.optionVec.push(String(xml.@OptionC));
         if(String(xml.@OptionD) != "")
         {
            this.optionVec.push(String(xml.@OptionD));
         }
         this.answer = uint(xml.@Answer);
      }
   }
}

