package com.mole.app.manager
{
   import com.global.staticData.XMLInfo;
   import com.mole.app.info.KFCQuestionInfo;
   import org.taomee.ds.HashMap;
   
   public class KFCQuestionManager
   {
      
      private static var questionMap:HashMap;
      
      private static var questionCount:uint;
      
      setup();
      
      public function KFCQuestionManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var questionInfo:KFCQuestionInfo = null;
         var tempXml:XML = null;
         questionMap = new HashMap();
         var questionXml:XML = XML(new XMLInfo.kfcQuestion());
         for each(tempXml in questionXml.descendants("Question"))
         {
            questionInfo = new KFCQuestionInfo(tempXml);
            questionMap.add(questionInfo.id,questionInfo);
         }
         questionCount = questionMap.getValues().length;
      }
      
      public static function getQuestionInfo(questionId:uint) : KFCQuestionInfo
      {
         return questionMap.getValue(questionId);
      }
      
      public static function randomOneQuestion() : KFCQuestionInfo
      {
         var questionId:uint = uint(Math.random() * questionCount);
         var questionInfo:KFCQuestionInfo = getQuestionInfo(questionId);
         while(!questionInfo)
         {
            questionId = uint(Math.random() * questionCount);
            questionInfo = getQuestionInfo(questionId);
         }
         return questionInfo;
      }
   }
}

