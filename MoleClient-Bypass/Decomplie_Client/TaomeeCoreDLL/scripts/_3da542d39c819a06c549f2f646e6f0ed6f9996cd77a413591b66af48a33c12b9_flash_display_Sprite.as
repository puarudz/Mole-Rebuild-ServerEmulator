package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _3da542d39c819a06c549f2f646e6f0ed6f9996cd77a413591b66af48a33c12b9_flash_display_Sprite extends Sprite
   {
      
      public function _3da542d39c819a06c549f2f646e6f0ed6f9996cd77a413591b66af48a33c12b9_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}

