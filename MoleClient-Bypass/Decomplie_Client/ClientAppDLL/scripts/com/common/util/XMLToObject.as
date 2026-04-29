package com.common.util
{
   public class XMLToObject
   {
      
      public function XMLToObject()
      {
         super();
      }
      
      public static function convert(_xml:XML) : Object
      {
         var _obj:Object = null;
         if(Boolean(_xml))
         {
            _obj = {};
            _xml.ignoreWhitespace = true;
            parseNode(_xml,_obj);
            return _obj;
         }
         return null;
      }
      
      private static function parseNode(node:XML, obj:Object) : void
      {
         var j:String = null;
         var n:String = node.name().toString();
         var o:Object = {};
         if(Boolean(node.attributes().length()))
         {
            for(j in node.attributes())
            {
               o[node.attributes()[j].name().toString()] = node.attributes()[j];
            }
            if(node.children().length() <= 1 && !o.value)
            {
               o.value = node.toString();
            }
         }
         else if(node.children().length() <= 1 && !node.hasComplexContent())
         {
            o = node.toString();
         }
         if(!obj[n])
         {
            obj[n] = o;
         }
         else if(obj[n] is Array)
         {
            obj[n].push(o);
         }
         else
         {
            obj[n] = [obj[n],o];
         }
         try
         {
            toObj(node,obj[n]);
         }
         catch(err:Error)
         {
         }
      }
      
      private static function toObj(_xml:XML, obj:Object) : void
      {
         var i:int = 0;
         var nl:int = 0;
         var node:XML = null;
         nl = _xml.children().length();
         for(i = 0; i < nl; i++)
         {
            node = _xml.children()[i];
            if(obj is Array)
            {
               parseNode(node,obj[obj.length - 1]);
            }
            else
            {
               parseNode(node,obj);
            }
         }
      }
   }
}

