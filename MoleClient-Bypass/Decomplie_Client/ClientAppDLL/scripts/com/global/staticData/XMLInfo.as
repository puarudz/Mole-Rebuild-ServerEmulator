package com.global.staticData
{
   import com.global.staticData.database.InfoAltXMLData;
   import com.global.staticData.database.InfoDonateXML;
   import com.global.staticData.database.InfoDragonDataObj;
   import com.global.staticData.database.InfoJJLCardXML;
   import com.global.staticData.database.InfoLahmMovieEvent;
   import com.global.staticData.database.InfoNPCTalkXML;
   import com.global.staticData.database.InfoRestaurantEventObj;
   import com.global.staticData.database.InfoRestaurantGuestObj;
   import com.global.staticData.database.InfoRestaurantMenuObj;
   import com.global.staticData.database.InfoRestaurantNPCEveryDayTaskObj;
   import com.global.staticData.database.InfoRestaurantRandomSayObj;
   import com.global.staticData.database.InfoRestaurantStyleObj;
   import com.global.staticData.database.InfoRestaurantUIObj;
   import com.global.staticData.database.InfoTDDataXML;
   import com.global.staticData.database.InfoVip_levelArray;
   import com.global.staticData.database.InfoWeeklyUpdateXML;
   import com.global.staticData.database.InfoWorldMapXML;
   import com.global.staticData.database.InfoWorldMapXML_DigTreasure;
   import com.global.staticData.database.InfoWorldMapXML_HSL;
   import com.global.staticData.database.InfoWorldMapXML_MLD;
   import com.global.staticData.database.InfoWorldMapXML_OldHSL;
   import com.global.staticData.database.InfoWorldMapXML_YS;
   import com.global.staticData.database.InfoXmasSALEObj;
   import com.global.staticData.database.InfoabcArray;
   import com.global.staticData.database.InfobgMusicXmlData;
   import com.global.staticData.database.InfofriendBoxXML;
   import com.global.staticData.database.InfogiftModuleXML;
   import com.global.staticData.database.InfojobListXML;
   import com.global.staticData.database.InfojoinBlackForestAnimal;
   import com.global.staticData.database.InfolahmClassRoom;
   import com.global.staticData.database.InfolahmClassRoomClassing;
   import com.global.staticData.database.InfolahmClassRoomClassingChat;
   import com.global.staticData.database.InfolahmClassRoomQuestion;
   import com.global.staticData.database.InfolahmClassRoomStyleObj;
   import com.global.staticData.database.InfolahmClassRoomTeachingMemory;
   import com.global.staticData.database.InfolahmClassRoomToolTips;
   import com.global.staticData.database.InfolahmClassRoomUnClass;
   import com.global.staticData.database.InfolahmClassRoomUnClassChat;
   import com.global.staticData.database.InfonpcXMLData;
   import com.global.staticData.database.InfooutputGameTips_XML;
   import com.global.staticData.database.InfosocketXmlData;
   import com.global.staticData.database.SL.InfoSLGoodsXmlData;
   import com.global.staticData.database.SL.InfoSLOnlyItems;
   import com.global.staticData.database.SL.InfoSLVipMAXMonthArr;
   import com.global.staticData.database.SL.InfoSLVipMonthArr;
   import com.global.staticData.database.angelPark.InfoAngelCommonData;
   import com.global.staticData.database.angelPark.InfoangelParkMeun;
   import com.global.staticData.database.architectTask.InfobuildJobListXML;
   import com.global.staticData.database.cloths.InfoClothBuyHint;
   import com.global.staticData.database.cloths.InfoSuit;
   import com.global.staticData.database.field.InfoFoodSourcesInfo;
   import com.global.staticData.database.item.InfoitemTips;
   import com.global.staticData.database.lamuPKSys.InfoanimalSwitchXml;
   import com.global.staticData.database.lamuSkill.InfoLamuWorldConvertXML;
   import com.global.staticData.database.lamuSkill.InfopetSkillListXML;
   import com.global.staticData.database.lamuSkill.InfoskillCanGeocaching;
   import com.global.staticData.database.magic.InfoMantraArray;
   import com.global.staticData.database.npcJob.InfonpcJobListXML;
   import com.global.staticData.database.npc_JCX_Task.InfoTransportArr;
   import com.global.staticData.database.npc_JCX_Task.InfotransportJobListXML;
   import com.global.staticData.database.post.InfopostListXML;
   import com.global.staticData.database.present.InfoPresentXML;
   import com.global.staticData.database.profession.InfoProfessionArr;
   import com.global.staticData.database.tips.InfoAlertErrorObj;
   import com.global.staticData.database.tips.InfoAlertErrorTypeObj;
   import com.global.staticData.database.tips.InfoAlertObj;
   import com.global.staticData.database.tips.InfoAlertTypeObj;
   import com.global.staticData.database.willAgicalGoods.InfoWillAgicalGoods;
   import com.global.staticData.database.wish.InfowishGivenItemArray;
   import com.global.staticData.database.wish.InfowishItemArray;
   import com.global.staticData.database.worldMapXML.InfoworldMapTips;
   
   public class XMLInfo
   {
      
      public static const VERSION:int = 65;
      
      public static const mole_beast_guide:Class = XMLInfo_mole_beast_guide;
      
      public static const mole_beast_achievement:Class = XMLInfo_mole_beast_achievement;
      
      public static const mole_beast_swap:Class = XMLInfo_mole_beast_swap;
      
      public static const mole_beast_task:Class = XMLInfo_mole_beast_task;
      
      public static const mole_beast_strategy:Class = XMLInfo_mole_beast_strategy;
      
      public static const mole_beast_mount_compose:Class = XMLInfo_mole_beast_mount_compose;
      
      public static const mole_beast_lottery:Class = XMLInfo_mole_beast_lottery;
      
      public static const mole_beast_exp:Class = XMLInfo_mole_beast_exp;
      
      public static const mole_beast_docile:Class = XMLInfo_mole_beast_docile;
      
      public static const wordMapTipConfig:Class = XMLInfo_wordMapTipConfig;
      
      public static const newHouseShopConfig:Class = XMLInfo_newHouseShopConfig;
      
      public static const _angelShopConfig:Class = XMLInfo__angelShopConfig;
      
      public static const _childDayGiftConfig:Class = XMLInfo__childDayGiftConfig;
      
      public static const ZillionaireBoxlist:Class = XMLInfo_ZillionaireBoxlist;
      
      public static const _eggRainConfig:Class = XMLInfo__eggRainConfig;
      
      public static const _animalSkillConfig:Class = XMLInfo__animalSkillConfig;
      
      public static const _animalSkillClassMapConfig:Class = XMLInfo__animalSkillClassMapConfig;
      
      public static const itemXmlData:Class = XMLInfo_itemXmlData;
      
      public static const GameConfigCls:Class = XMLInfo_GameConfigCls;
      
      public static const _angelIntrCls:Class = XMLInfo__angelIntrCls;
      
      public static const newAngelTollgateCls:Class = XMLInfo_newAngelTollgateCls;
      
      public static const newAngelMonsterCls:Class = XMLInfo_newAngelMonsterCls;
      
      public static const newAngelTowerCls:Class = XMLInfo_newAngelTowerCls;
      
      public static const newAngelSkillCls:Class = XMLInfo_newAngelSkillCls;
      
      public static const newAngelMapCls:Class = XMLInfo_newAngelMapCls;
      
      public static const angelStore:Class = XMLInfo_angelStore;
      
      public static const angelFusion:Class = XMLInfo_angelFusion;
      
      public static const elementKnightCardPVEStageCls:Class = XMLInfo_elementKnightCardPVEStageCls;
      
      public static const elementKnightTalnetCls:Class = XMLInfo_elementKnightTalnetCls;
      
      public static const elementKnightEnemyCardCls:Class = XMLInfo_elementKnightEnemyCardCls;
      
      public static const elementKnightCardAdvanceCls:Class = XMLInfo_elementKnightCardAdvanceCls;
      
      public static const elementKnightSkillCls:Class = XMLInfo_elementKnightSkillCls;
      
      public static const elementKnightExploitClothes:Class = XMLInfo_elementKnightExploitClothes;
      
      public static const elementKnightIllustrationsConfig:Class = XMLInfo_elementKnightIllustrationsConfig;
      
      public static const elementShopConfig:Class = XMLInfo_elementShopConfig;
      
      public static const elementShopConfigTwo:Class = XMLInfo_elementShopConfigTwo;
      
      public static const gameKingConfig:Class = XMLInfo_gameKingConfig;
      
      public static const kfcQuestion:Class = XMLInfo_kfcQuestion;
      
      public static const Compensation:Class = XMLInfo_Compensation;
      
      public static const lionDanceReward:Class = XMLInfo_lionDanceReward;
      
      public static const moduleTimeClass:Class = XMLInfo_moduleTimeClass;
      
      public static const wakeUpMoleClass:Class = XMLInfo_wakeUpMoleClass;
      
      public static const magicSpiritLevel:Class = XMLInfo_magicSpiritLevel;
      
      public static const magicSpiritRewardChange:Class = XMLInfo_magicSpiritRewardChange;
      
      public static const magicSpiritMonster:Class = XMLInfo_magicSpiritMonster;
      
      public static const magicSpiritAdvance:Class = XMLInfo_magicSpiritAdvance;
      
      public static const magicSpiritSkill:Class = XMLInfo_magicSpiritSkill;
      
      public static const magicSpiritGuide:Class = XMLInfo_magicSpiritGuide;
      
      public static const magicSpiritAchievement:Class = XMLInfo_magicSpiritAchievement;
      
      public static const magicSpiritShop:Class = XMLInfo_magicSpiritShop;
      
      public static const temporaryItems:Class = XMLInfo_temporaryItems;
      
      public static const halloweenAsk:Class = XMLInfo_halloweenAsk;
      
      public static var socketXmlData:* = InfosocketXmlData.socketXmlData;
      
      public static var itemTipsDef:* = InfoitemTips.itemTipsDef;
      
      public static var itemTips:* = InfoitemTips.itemTips;
      
      public static var pigTips:* = InfoitemTips.pigTips;
      
      public static var jobListXML:* = InfojobListXML.jobListXML;
      
      public static var npcJobListXML:* = InfonpcJobListXML.npcJobListXML;
      
      public static var postListXML:* = InfopostListXML.postListXML;
      
      public static var SLGoodsXmlData:* = InfoSLGoodsXmlData.SLGoodsXmlData;
      
      public static var ClothHint:* = InfoClothBuyHint.ClothHint;
      
      public static var SuitXmlData:* = InfoSuit.SuitXmlData;
      
      public static var npcXML:* = InfonpcXMLData.npcXML;
      
      public static var PresentXML:* = InfoPresentXML.PresentXML;
      
      public static var JJLCardXML:* = InfoJJLCardXML.JJLCardXML;
      
      public static var AltXML:* = InfoAltXMLData.AltXML;
      
      public static var gameTips_XML:* = InfooutputGameTips_XML.gameTips_XML;
      
      public static var wishItemArray:* = InfowishItemArray.wishItemArray;
      
      public static var wishGivenItemArray:* = InfowishGivenItemArray.wishGivenItemArray;
      
      public static var MantraArray1:* = InfoMantraArray.MantraArray1;
      
      public static var MantraArray2:* = InfoMantraArray.MantraArray2;
      
      public static var DemandLamuArray:* = InfoMantraArray.DemandLamuArray;
      
      public static var DurationArray:* = InfoMantraArray.DurationArray;
      
      public static var abcArray:* = InfoWeeklyUpdateXML.abcArray;
      
      public static var CharityPartySendMsgCount:* = InfoabcArray.CharityPartySendMsgCount;
      
      public static var joinBlackForestAnimal:* = InfojoinBlackForestAnimal.joinBlackForestAnimal;
      
      public static var Vip_levelArray:* = InfoVip_levelArray.Vip_levelArray;
      
      public static var transportArr:* = InfoTransportArr.transportArr;
      
      public static var transportJobListXML:* = InfotransportJobListXML.transportJobListXML;
      
      public static var transportJobLib:* = InfotransportJobListXML.transportJobLib;
      
      public static var xd_msg:* = InfoWeeklyUpdateXML.xd_msg;
      
      public static var NPCTalkXML:* = InfoNPCTalkXML.NPCTalkXML;
      
      public static var giftModuleXML:* = InfogiftModuleXML.giftModuleXML;
      
      public static var SLOnlyItems:* = InfoSLOnlyItems.SLOnlyItems;
      
      public static var SLVipMonthArr:* = InfoSLVipMonthArr.SLVipMonthArr;
      
      public static var SLVipMAXMonthArr:* = InfoSLVipMAXMonthArr.SLVipMAXMonthArr;
      
      public static var LamuWorldConvertXML:* = InfoLamuWorldConvertXML.LamuWorldConvertXML;
      
      public static var petSkillListXML:* = InfopetSkillListXML.petSkillListXML;
      
      public static var skill_Can_Geocaching:* = InfoskillCanGeocaching.skill_Can_Geocaching;
      
      public static var buildJobListXML:* = InfobuildJobListXML.buildJobListXML;
      
      public static var WorldMapXML:* = InfoWorldMapXML.WorldMapXML;
      
      public static var WorldMapXML_HSL:* = InfoWorldMapXML_HSL.WorldMapXML_HSL;
      
      public static var WorldMapXML_YS:* = InfoWorldMapXML_YS.WorldMapXML_YS;
      
      public static var WorldMapXML_MLD:* = InfoWorldMapXML_MLD.WorldMapXML_MLD;
      
      public static var WorldMapXML_DigTreasure:* = InfoWorldMapXML_DigTreasure.WorldMapXML_DigTreasure;
      
      public static var WorldMapXML_OldHSL:* = InfoWorldMapXML_OldHSL.WorldMapXML_OldHSL;
      
      public static var AlertObj:* = InfoAlertObj.AlertObj;
      
      public static var AlertTypeObj:* = InfoAlertTypeObj.AlertTypeObj;
      
      public static var AlertErrorObj:* = InfoAlertErrorObj.AlertErrorObj;
      
      public static var AlertErrorTypeObj:* = InfoAlertErrorTypeObj.AlertErrorTypeObj;
      
      public static var ProfessionArr:* = InfoProfessionArr.ProfessionArr;
      
      public static var otherProfessionArr:* = InfoProfessionArr.otherProfessionArr;
      
      public static var HonorArr:* = InfoProfessionArr.HonorArr;
      
      public static var otherHonorArr:* = InfoProfessionArr.otherHonorArr;
      
      public static var baseinfoArr:* = InfoProfessionArr.baseinfoArr;
      
      public static var otherbaseinfoArr:* = InfoProfessionArr.otherbaseinfoArr;
      
      public static var WeeklyUpdateXML:* = InfoWeeklyUpdateXML.WeeklyUpdateXML;
      
      public static var RestaurantMenuObj:* = InfoRestaurantMenuObj.RestaurantMenuObj;
      
      public static var RestaurantStyleObj:* = InfoRestaurantStyleObj.RestaurantStyleObj;
      
      public static var RestaurantGuestObj:* = InfoRestaurantGuestObj.RestaurantGuestObj;
      
      public static var RestaurantUIObj:* = InfoRestaurantUIObj.RestaurantUIObj;
      
      public static var RestaurantEventObj:* = InfoRestaurantEventObj.RestaurantEventObj;
      
      public static var RestaurantNPCEveryDayTaskObj:* = InfoRestaurantNPCEveryDayTaskObj.RestaurantNPCEveryDayTaskObj;
      
      public static var RestaurantRandomSayObj:* = InfoRestaurantRandomSayObj.RestaurantRandomSayObj;
      
      public static var lostItemList:* = InfoWeeklyUpdateXML.lostItemList;
      
      public static var FoodSourcesInfo:* = InfoFoodSourcesInfo.FoodSourcesInfo;
      
      public static var WillAgicalGoods:* = InfoWillAgicalGoods.WillAgicalGoods;
      
      public static var DragonDataObj:* = InfoDragonDataObj.DragonDataObj;
      
      public static var mapInfo_hsl:* = InfoworldMapTips.mapInfo_hsl;
      
      public static var mapInfo_ys:* = InfoworldMapTips.mapInfo_ys;
      
      public static var friendBoxXML:* = InfofriendBoxXML.friendBoxXML;
      
      public static var SystermMsgTip:* = InfoWeeklyUpdateXML.SystermMsgTip;
      
      public static var lahmClassRoom:* = InfolahmClassRoom.lahmClassRoom;
      
      public static var lahmClassRoomToolTips:* = InfolahmClassRoomToolTips.lahmClassRoomToolTips;
      
      public static var lahmClassRoomClassing:* = InfolahmClassRoomClassing.lahmClassRoomClassing;
      
      public static var lahmClassRoomUnClass:* = InfolahmClassRoomUnClass.lahmClassRoomUnClass;
      
      public static var lahmClassRoomClassingChat:* = InfolahmClassRoomClassingChat.lahmClassRoomClassingChat;
      
      public static var lahmClassRoomUnClassChat:* = InfolahmClassRoomUnClassChat.lahmClassRoomUnClassChat;
      
      public static var lahmClassRoomTeachingMemory:* = InfolahmClassRoomTeachingMemory.lahmClassRoomTeachingMemory;
      
      public static var lahmClassRoomTeacherHoner:* = InfolahmClassRoomTeachingMemory.lahmClassRoomTeacherHoner;
      
      public static var LahmMovieEvent:* = InfoLahmMovieEvent.LahmMovieEvent;
      
      public static var lahmClassRoomQuestion:* = InfolahmClassRoomQuestion.lahmClassRoomQuestion;
      
      public static var lahmClassRoomStyleObj:* = InfolahmClassRoomStyleObj.lahmClassRoomStyleObj;
      
      public static var DonateXML:* = InfoDonateXML.DonateXML;
      
      public static var bgMusicXml:* = InfobgMusicXmlData.bgMusicXmlData;
      
      public static var TDDataXML:* = InfoTDDataXML.TDDataXML;
      
      public static var XmasSALEObj:* = InfoXmasSALEObj.XmasSALEObj;
      
      public static var angelTypeBtnTips:* = InfoangelParkMeun.angelTypeBtnTips;
      
      public static var addAuraGoodsArr:* = InfoangelParkMeun.addAuraGoodsArr;
      
      public static var angelSeedMeun:* = InfoangelParkMeun.angelSeedMeun;
      
      public static var angelParkMeun:* = InfoangelParkMeun.angelParkMeun;
      
      public static var angelCountList:* = InfoAngelCommonData.angelCountList;
      
      public static var angelItemEffectTip:* = InfoAngelCommonData.angelItemEffectTip;
      
      public static var conllectionAngels:* = InfoAngelCommonData.conllectionAngels;
      
      public static var agenlHoners:* = InfoAngelCommonData.agenlHoners;
      
      public static var animalSsitchXml:* = InfoanimalSwitchXml.animalSsitchXml;
      
      public static var longEggAllArr:Array = [190681,190690,190708,190709,190710,190711,190712,190713,190714,190715,190716,190717,190718,190719,190720,190721,190722,191023,191046,191086,191087,1350128,191215,191234];
      
      public static var woolIDArr:Array = [1270006,1270007,1270138];
      
      public function XMLInfo()
      {
         super();
      }
   }
}

