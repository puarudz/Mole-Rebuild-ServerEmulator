package com.module.pig
{
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.utils.Dictionary;
   
   public class PigConfig
   {
      
      private static var _instance:PigConfig;
      
      public static const Pig_Type_Fat:int = 0;
      
      public static const Pig_Type_Beauty:int = 1;
      
      public static const Pig_Type_Strong:int = 2;
      
      public static const Init_OK_Event:String = "PigConfig_Init_OK";
      
      public static const Teams:Dictionary = new Dictionary();
      
      Teams["1"] = [new Point(253,279),new Point(337,279),new Point(421,279),new Point(505,279),new Point(588,279),new Point(671,279),new Point(253,341),new Point(337,341),new Point(421,341),new Point(505,341),new Point(588,341),new Point(671,341),new Point(253,404),new Point(337,404),new Point(421,404),new Point(505,404),new Point(588,404),new Point(671,404),new Point(253,467),new Point(337,467),new Point(421,467),new Point(505,467),new Point(588,467),new Point(671,467),new Point(253,500),new Point(337,500),new Point(419,500),new Point(503,500),new Point(586,500),new Point(669,500)];
      Teams["2_9"] = [new Point(376,306),new Point(460,306),new Point(543,306),new Point(376,390),new Point(460,390),new Point(543,390),new Point(376,482),new Point(460,482),new Point(543,482)];
      Teams["2_16"] = [new Point(334,275),new Point(418,275),new Point(502,275),new Point(585,275),new Point(334,349),new Point(418,349),new Point(502,349),new Point(585,349),new Point(334,431),new Point(418,431),new Point(502,431),new Point(585,431),new Point(334,521),new Point(418,521),new Point(502,521),new Point(585,521)];
      Teams["2_25"] = [new Point(292,240),new Point(376,240),new Point(460,240),new Point(544,240),new Point(627,240),new Point(292,300),new Point(376,300),new Point(460,300),new Point(544,300),new Point(627,300),new Point(292,368),new Point(376,368),new Point(460,368),new Point(544,368),new Point(627,368),new Point(292,444),new Point(376,444),new Point(460,444),new Point(544,444),new Point(627,444),new Point(292,529),new Point(376,529),new Point(458,529),new Point(542,529),new Point(625,529)];
      Teams["3_11"] = [new Point(292,334),new Point(376,334),new Point(460,334),new Point(627,334),new Point(292,410),new Point(460,410),new Point(627,410),new Point(292,495),new Point(458,495),new Point(542,495),new Point(625,495)];
      Teams["3_16"] = [new Point(213,300),new Point(296,300),new Point(380,300),new Point(213,367),new Point(213,434),new Point(213,508),new Point(460,300),new Point(460,367),new Point(460,434),new Point(460,508),new Point(539,508),new Point(623,508),new Point(703,508),new Point(703,308),new Point(703,375),new Point(703,442)];
      Teams["4_2"] = [new Point(424,489),new Point(508,489)];
      Teams["4_4"] = [new Point(342,426),new Point(593,426),new Point(424,489),new Point(508,489)];
      Teams["4_6"] = [new Point(258,363),new Point(676,363),new Point(342,426),new Point(593,426),new Point(424,489),new Point(508,489)];
      Teams["4_8"] = [new Point(258,363),new Point(676,363),new Point(342,426),new Point(593,426),new Point(424,489),new Point(508,489),new Point(180,300),new Point(755,300)];
      Teams["5_8"] = [new Point(378,279),new Point(544,279),new Point(324,342),new Point(459,306),new Point(595,341),new Point(378,408),new Point(544,408),new Point(461,467)];
      Teams["5_10"] = [new Point(376,279),new Point(544,279),new Point(292,341),new Point(460,341),new Point(627,341),new Point(324,405),new Point(598,405),new Point(376,467),new Point(544,467),new Point(458,530)];
      Teams["5_12"] = [new Point(387,249),new Point(548,249),new Point(252,336),new Point(451,299),new Point(667,336),new Point(288,410),new Point(639,410),new Point(364,474),new Point(549,474),new Point(451,530),new Point(297,266),new Point(631,266)];
      
      private var _isInitOK:Boolean = false;
      
      private var _taskConfig:XML;
      
      public function PigConfig()
      {
         super();
      }
      
      public static function get instance() : PigConfig
      {
         if(_instance == null)
         {
            _instance = new PigConfig();
         }
         return _instance;
      }
      
      public function get taskConfig() : XML
      {
         return this._taskConfig.copy();
      }
      
      public function Init() : void
      {
         var urlLoader:URLLoader = null;
         if(this._isInitOK == false)
         {
            urlLoader = new URLLoader();
            BC.addOnceEvent(this,urlLoader,Event.COMPLETE,this.TaskConfigLoaderHandler);
            urlLoader.load(VL.getURLRequest("resource/xml/pig/cp_task_info.xml"));
         }
         else
         {
            PigEvent.instance.dispatchEvent(new Event(Init_OK_Event));
         }
      }
      
      private function TaskConfigLoaderHandler(e:Event) : void
      {
         this._isInitOK = true;
         this._taskConfig = new XML(e.target.data);
         PigEvent.instance.dispatchEvent(new Event(Init_OK_Event));
      }
      
      public function get isInitOK() : Boolean
      {
         return this._isInitOK;
      }
   }
}

