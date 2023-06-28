// barcode scanner skipped during testing
import 'package:flutter/foundation.dart';

const skipBarcodeScan = kDebugMode ? true : false;
// const skipBarcodeScan = false;

const urlDataGoKr = 'https://data.go.kr';
const urlNedrugMfdsGoKr = 'https://nedrug.mfds.go.kr';
const urlDrugSafeOrKr = 'https://drugsafe.or.kr';
const urlDurInfo = urlDurNedrug;
const urlDurNedrug = 'https://nedrug.mfds.go.kr/pbp/CCBBJ01';
const urlDurHira =
    'https://www.hira.or.kr/rg/dur/form.do?pgmid=HIRAA030033000000';
const urlDurHealth = 'https://www.health.kr/searchDrug/search_DUR.asp';
const urlAdverseEffectReport =
    'https://nedrug.mfds.go.kr/CCCBA03F010/getReport';
const urlWikipedia = 'https://ko.wikipedia.org';
const urlPrivacyPolicy = 'https://innomatica.github.io/smkrdata/site/privacy/';
const urlDisclaimer = 'https://innomatica.github.io/smkrdata/site/disclaimer/';
const phoneAdverseEffectReport = '1644 6223';

const urlMedicineIcons = 'https://www.flaticon.com/free-icons/medicine';
const urlBackgroundImage = 'https://unsplash.com/@anshu18';
// some barcode samples
const barcodeTylenol500 = '8806469007251'; // 타이레놀
const barcodeChildrenTylenol = '8806469005646'; // 어린이타이레놀
const barcodeEphedrine = '8806433032005';
const barcodeHomeopathic1 = '8806590018300';
const barcodeHomeopathic2 = '8806427038907';
const barcodeBenzoSodiumCaffein = '8806505002301';
const barcodeRecallDrug = '8806491007205';

// notification
const useInboxNotification = true;
const notificationChannelId = 'com.innomatic.smkr.schedule';
const notificationChannelName = 'SafeMed Schedule Alarm';
const notificationChannelDescription = 'SafeMed Schedule Alarm';
