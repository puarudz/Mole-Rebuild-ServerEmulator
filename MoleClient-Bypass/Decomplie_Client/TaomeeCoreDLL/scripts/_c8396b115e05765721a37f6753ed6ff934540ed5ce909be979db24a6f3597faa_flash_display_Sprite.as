package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _c8396b115e05765721a37f6753ed6ff934540ed5ce909be979db24a6f3597faa_flash_display_Sprite extends Sprite
   {
      
      public function _c8396b115e05765721a37f6753ed6ff934540ed5ce909be979db24a6f3597faa_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

