package sample.MEncrypt.vfs
{
   import flash.utils.ByteArray;
   
   public interface IBackingStore
   {
      
      function addFile(param1:String, param2:ByteArray) : void;
      
      function deleteFile(param1:String) : void;
      
      function getPaths() : Vector.<String>;
      
      function getFile(param1:String) : ByteArray;
      
      function pathExists(param1:String) : Boolean;
      
      function isDirectory(param1:String) : Boolean;
      
      function flush() : void;
      
      function get readOnly() : Boolean;
   }
}

const §1§:*;

§__force_ordering_ns_c0fb5340-e53f-433b-8dba-280c9401591d§;

