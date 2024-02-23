## Installation
```
flutter pub global activate cyfl_oem_app
```

## Usage

### run
```
fl_oem run -t android -d com.xxx.xx1
fl_oem run -t ios -d com.xxx.xx1
```

### create
create lib/oem_info.dart in project
```
class OemInfo {
    static String APP_ID = "com.xxx.xx1";
    static String APP_NAME_CN = "xxx";
    static String APP_NAME_EN = "xxx";
    static String APP_VERSION = "1.0.0";
    static String KEY_ALIAS = "xxx";
    static String KEY_PASSWORD = "xxxxxx";
    static String STORE_PASSWORD = "xxxxxx";
    static String SHA1 = "xxxxxx";
    static String EXPIRATION_TIME = "Tue Dec 13 15:03:16 CST 2050";
    static String GOOGLE_GEO_API_KEY = "";
    static String GAODE_GEO_ANDROID_API_KEY = "";
    static String GAODE_GEO_IOS_API_KEY = "";
    static String TENANT_CODE = "xxx";
}
```

## oem-datum
### structure
```
oem-info
├─ com.xxx.xx1
│  └─ logo
└─ com.xxx.xx2
   └─ singature
   │  └─ upload-keystore.jks
   ├─ config.ini
   └─ logo
      ├─ 20x20.png
      ├─ 29x29.png
      ├─ 40x40.png
      ├─ 48x48.png
      ├─ 58x58.png
      ├─ 60x60.png
      ├─ 72x72.png
      ├─ 76x76.png
      ├─ 80x80.png
      ├─ 87x87.png
      ├─ 96x96.png
      ├─ 120x120.png
      ├─ 144x144.png
      ├─ 152x125.png
      ├─ 167x167.png
      ├─ 180x180.png
      ├─ 192x192.png
      └─ 1024x1024.png
```

### config.ini
```
APP_ID=com.xxx
/// 中文名称
APP_NAME_ZH=xxx
/// 英文名称
APP_NAME_EN=xxx
APP_VERSION=1.0.0

/// 安卓签名配置
KEY_ALIAS=xxx
KEY_PASSWORD=xxx
STORE_PASSWORD=xxx

/// 谷歌地图API_KEY
GOOGLE_GEO_API_KEY=xxx

/// 高德地图API_KEY
GAODE_GEO_ANDROID_API_KEY=xxx
GAODE_GEO_IOS_API_KEY=xxx

/// other
TENAN_CODE=xxx
```


