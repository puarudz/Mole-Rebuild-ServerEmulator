package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _d4971c169b4c1ddd080798be99fb1e036653ab7342d7c6dbebad5295b38df829_flash_display_Sprite extends Sprite
   {
      
      public function _d4971c169b4c1ddd080798be99fb1e036653ab7342d7c6dbebad5295b38df829_flash_display_Sprite()
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

