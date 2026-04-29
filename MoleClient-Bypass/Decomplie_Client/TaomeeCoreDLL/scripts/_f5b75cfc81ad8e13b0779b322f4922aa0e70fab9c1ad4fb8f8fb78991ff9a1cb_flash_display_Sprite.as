package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _f5b75cfc81ad8e13b0779b322f4922aa0e70fab9c1ad4fb8f8fb78991ff9a1cb_flash_display_Sprite extends Sprite
   {
      
      public function _f5b75cfc81ad8e13b0779b322f4922aa0e70fab9c1ad4fb8f8fb78991ff9a1cb_flash_display_Sprite()
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

