package com.mole.app.utils
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class XMLTool
   {
      
      public function XMLTool()
      {
         super();
      }
      
      public static function loadAndHandleXML(path:String, obj:Object, complete:Function = null, completeParams:Array = null, errorFunc:Function = null, ignoreVertion:Boolean = false) : void
      {
         var l:URLLoader = null;
         var r:URLRequest = null;
         var loadOver:Function = null;
         var onError:Function = null;
         l = new URLLoader();
         if(!ignoreVertion)
         {
            r = VL.getURLRequest(path);
         }
         else
         {
            r = new URLRequest(path);
         }
         loadOver = function(e:Event):void
         {
            l.removeEventListener(Event.COMPLETE,loadOver);
            l.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            var xml:XML = new XML(e.currentTarget.data);
            handleXML2(xml,obj);
            if(complete != null)
            {
               complete.apply(null,completeParams);
            }
         };
         onError = function(e:Event):void
         {
            l.removeEventListener(Event.COMPLETE,loadOver);
            l.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            if(errorFunc != null)
            {
               errorFunc.apply();
            }
         };
         l.addEventListener(Event.COMPLETE,loadOver,false,0,true);
         l.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
         l.load(r);
      }
      
      public static function handleXML2(xml:XML, obj:Object) : void
      {
         getChild(xml,obj);
      }
      
      public static function handleXML(xml:XML) : Object
      {
         var finalObj:Object = {};
         getChild(xml,finalObj);
         return finalObj;
      }
      
      private static function getChild(xmlList:*, obj:Object) : void
      {
         var child:* = undefined;
         var name:String = null;
         var attrNa:String = null;
         var childArr:Array = null;
         var cc:* = undefined;
         var childObj:Object = null;
         var childName:Array = [];
         for each(child in xmlList.children())
         {
            name = child.name();
            if(name == null)
            {
               trace(child);
            }
            attrNa = toLower(name);
            if(childName.indexOf(name) == -1)
            {
               childArr = [];
               for each(cc in xmlList.child(name))
               {
                  childObj = getAtt(cc);
                  childArr.push(childObj);
                  getChild(cc,childObj);
               }
               childName.push(name);
               if(xmlList.child(name).length() == 1)
               {
                  obj[attrNa] = childArr[0];
               }
               else
               {
                  obj[attrNa] = childArr;
               }
            }
         }
      }
      
      private static function getAtt(xmlList:*) : Object
      {
         var att:* = undefined;
         var o:Object = {};
         for each(att in xmlList.attributes())
         {
            if(Tool.isNum(String(att)))
            {
               o[toLower(att.name())] = int(att);
            }
            else
            {
               o[toLower(att.name())] = String(att);
            }
         }
         return o;
      }
      
      private static function toLower(str:String) : String
      {
         return str.substr(0,2).toLowerCase() + str.substr(2);
      }
   }
}

