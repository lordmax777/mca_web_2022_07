'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "7fab6da096fd3c24cb62b70511fa7519",
"index.html": "6c6b7c538aab8c48959dac0bae38994b",
"/": "6c6b7c538aab8c48959dac0bae38994b",
"styles.css": "67e810bc9214d7c3eaba5f0efed1a74e",
"main.dart.js": "ada1a32b4eec1fc96a1ab46d6e6ffe7c",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "70eab52c4ee4da7a19fab0f1b09bbbcf",
"assets/AssetManifest.json": "1646e5638338406fa73527f44cc28f68",
"assets/NOTICES": "3d6a06813335f8a966e2898af0194a33",
"assets/FontManifest.json": "e76b3893245a91cd148e7093dd0282f0",
"assets/packages/timezone/data/2020a.tzf": "84285f1f81b999f1de349a723574b3e5",
"assets/packages/simpleicons/assets/icons/underline.svg": "dfae841f54052e9207a8e889d5c5ca58",
"assets/packages/simpleicons/assets/icons/heart-circle.svg": "9bf5a2454863d2a7d4356cb59b92f7e5",
"assets/packages/simpleicons/assets/icons/triangle.svg": "244d432d90df33aec6f95eddf705d193",
"assets/packages/simpleicons/assets/icons/sim.svg": "2b3acfccf53c29c06641fc8bdc2ed9af",
"assets/packages/simpleicons/assets/icons/ms-word.svg": "d8d8db37d6f8cbee164cb0d9d695ce6e",
"assets/packages/simpleicons/assets/icons/search.svg": "83ce70a47f92ef7e3b0f7ea371d9607f",
"assets/packages/simpleicons/assets/icons/volume-2.svg": "b6941e6510e59a58a7394caf6b03ea81",
"assets/packages/simpleicons/assets/icons/contact.svg": "b7ef61430c8b3237ed9b8c4dd2a56a7b",
"assets/packages/simpleicons/assets/icons/clipboard-plus.svg": "f8033b13d1095578f3e8ef65712068ce",
"assets/packages/simpleicons/assets/icons/rewind-circle.svg": "e793c30d3836736592efb42129c83a6f",
"assets/packages/simpleicons/assets/icons/briefcase-alt.svg": "30bc2879223dd9b9d95b5e8eb5936067",
"assets/packages/simpleicons/assets/icons/arrow-up-circle.svg": "22bfb31faaec98a146fd57d8438f661e",
"assets/packages/simpleicons/assets/icons/receipt.svg": "ba217a655a7217d3de737229f9475d57",
"assets/packages/simpleicons/assets/icons/bed-single.svg": "ea263752ebe8832979bcd2508f1ffd4c",
"assets/packages/simpleicons/assets/icons/pause-circle.svg": "e0dcea466611c9cba2bb07226ca85ffd",
"assets/packages/simpleicons/assets/icons/paintbucket.svg": "9ccb086c9e9ef583059bc9eabfe98697",
"assets/packages/simpleicons/assets/icons/arrow-down.svg": "1ea1661e5575c7ee8b9311be5bbf914d",
"assets/packages/simpleicons/assets/icons/sign.svg": "dd8a135f4c1ae70e5fc9f018c9ab3150",
"assets/packages/simpleicons/assets/icons/caret-vertical-circle.svg": "92cb6298947bbaa7503ffbb64cda8201",
"assets/packages/simpleicons/assets/icons/basket-plus.svg": "0d4e7bce34b80320c83bd870fb267b35",
"assets/packages/simpleicons/assets/icons/house.svg": "9539b6755be97275bc6dd1a363b8f53f",
"assets/packages/simpleicons/assets/icons/up-small.svg": "f51d5e3679ba335897e9617cc7f202e0",
"assets/packages/simpleicons/assets/icons/subscript.svg": "2845d552b91beb8cda1a0774f4b65a8b",
"assets/packages/simpleicons/assets/icons/flip-vertical.svg": "7da60f1672ce3142b7067fcad33a0419",
"assets/packages/simpleicons/assets/icons/left-circle.svg": "eb31b998f3d257ce0057be60624e9c0c",
"assets/packages/simpleicons/assets/icons/target.svg": "9401e98f0063e41ab8fcc340b4065777",
"assets/packages/simpleicons/assets/icons/cog.svg": "ac7a6eacd710e5b341e1b08fac61cde0",
"assets/packages/simpleicons/assets/icons/play-circle.svg": "2f370b60de8b1b71131447b84e3f2429",
"assets/packages/simpleicons/assets/icons/volume-3.svg": "578307d439c37d464a5bee34fc931460",
"assets/packages/simpleicons/assets/icons/border-outer.svg": "04198fad6d4b75d1d81818181f7533eb",
"assets/packages/simpleicons/assets/icons/airplay.svg": "78e56fe06e9fb4db2a0224d312987749",
"assets/packages/simpleicons/assets/icons/paws.svg": "44caa18571deaead26b979e5884f0e69",
"assets/packages/simpleicons/assets/icons/ripple.svg": "855c6817d3a00b2f2889015cae2500d5",
"assets/packages/simpleicons/assets/icons/next-small.svg": "539fe6d90a4409e15aee4ab63558fd23",
"assets/packages/simpleicons/assets/icons/hourglass.svg": "6aa7a1bddbfbaff568962d4e3e67ec09",
"assets/packages/simpleicons/assets/icons/volume-1.svg": "a6e654ef43be335a6e03d9c30f7bbdf8",
"assets/packages/simpleicons/assets/icons/dropper.svg": "6c25ef1128b1ed93b718aa4ac8d113fc",
"assets/packages/simpleicons/assets/icons/ngc.svg": "59ca1aa59d22f04ac9cd45c8372ef76e",
"assets/packages/simpleicons/assets/icons/thumb-up.svg": "14f09ee2d47df7d0b334f5c468424ea4",
"assets/packages/simpleicons/assets/icons/area-chart-alt.svg": "36943671929acbc90e48342b771ccb38",
"assets/packages/simpleicons/assets/icons/align-text-justify.svg": "1467a8e4289fdc12fa027309998de820",
"assets/packages/simpleicons/assets/icons/user.svg": "35084da21f00bb73a18eddef24aa99ba",
"assets/packages/simpleicons/assets/icons/view-grid.svg": "f8dac25391cb7ddde373e97ed78c6987",
"assets/packages/simpleicons/assets/icons/double-caret-up-small.svg": "cf5b3f66e09c58000585ef3f8586f69e",
"assets/packages/simpleicons/assets/icons/cart-plus.svg": "cc60708ea969cba7d2079468bce52a70",
"assets/packages/simpleicons/assets/icons/arrow.svg": "f6626d9eb3fd0debdf2296e40111af3c",
"assets/packages/simpleicons/assets/icons/file-minus.svg": "6a27f0dfa833c7d6abfea1041daa738f",
"assets/packages/simpleicons/assets/icons/x-circle.svg": "ca8cd4e7fbecb9dbbc59fb271be7cf3f",
"assets/packages/simpleicons/assets/icons/rupee.svg": "9c586937e73ecd76e6780a65ed47f918",
"assets/packages/simpleicons/assets/icons/send-left.svg": "3b272feb3dab79dc8ee52be4ea2c97aa",
"assets/packages/simpleicons/assets/icons/info-small.svg": "ea1dd3a8fa1a47e27d3ca46fcb4fa64c",
"assets/packages/simpleicons/assets/icons/pool.svg": "32e8f01a86b415c949908cf994cfadb9",
"assets/packages/simpleicons/assets/icons/battery-charge.svg": "7b1af2372ff1744674433c8d79e89450",
"assets/packages/simpleicons/assets/icons/roller.svg": "a346a37388d4db4f37977640d9f09d56",
"assets/packages/simpleicons/assets/icons/dollar.svg": "1b8f60b59457458a9763584504cb90ff",
"assets/packages/simpleicons/assets/icons/ethereum.svg": "6ff70d2fd8495384bcf833ebcf75e4a5",
"assets/packages/simpleicons/assets/icons/minimise-alt.svg": "80a7beef8ff520301b3f3e394100554f",
"assets/packages/simpleicons/assets/icons/bag-plus.svg": "767bd19615c8431f31f511db77cc43a0",
"assets/packages/simpleicons/assets/icons/circle.svg": "c73f7912fe4708d6e677df9df0e48d5d",
"assets/packages/simpleicons/assets/icons/clipboard-tick.svg": "a38e54e430a9a9b7a0f8753bf52e63ab",
"assets/packages/simpleicons/assets/icons/home.svg": "60cbb76213ea9ff0b52f57d498f7510e",
"assets/packages/simpleicons/assets/icons/shop.svg": "b627a39a91230bd416ad13d6eddc35fe",
"assets/packages/simpleicons/assets/icons/omega.svg": "716a2199dafc37f9f363ec2fd4b198e3",
"assets/packages/simpleicons/assets/icons/safe.svg": "5a6602dcbc044f9421c63de33af96dfd",
"assets/packages/simpleicons/assets/icons/more-horizontal.svg": "727de5869ab36df44f30395d8ead1497",
"assets/packages/simpleicons/assets/icons/otp.svg": "42610524dc6ab931fae7ffd183a6ad85",
"assets/packages/simpleicons/assets/icons/stop-small.svg": "02d520098b0f9fcf7fe836e5cdacafdd",
"assets/packages/simpleicons/assets/icons/send-right.svg": "2d8414d2318b143d80fcb7dafd0e7d2c",
"assets/packages/simpleicons/assets/icons/sound-on.svg": "e03f413c41778258fb9319b9bb8ba2b9",
"assets/packages/simpleicons/assets/icons/logout.svg": "699951cf03ac2e3a0cc5c35e0e8e9837",
"assets/packages/simpleicons/assets/icons/hexagon.svg": "6adf964ca37d262a7525a98bff086fb7",
"assets/packages/simpleicons/assets/icons/strikethrough.svg": "713b453e9af8aa140ccb2d33ee316c87",
"assets/packages/simpleicons/assets/icons/rewind-small.svg": "bcb35036a443806f6c238e776f784f79",
"assets/packages/simpleicons/assets/icons/clipboard-no-access.svg": "3870842dca6ca72a9282acd36f6842c7",
"assets/packages/simpleicons/assets/icons/text-document-alt.svg": "eace9c93dc3d0e44998773a8684eb70f",
"assets/packages/simpleicons/assets/icons/gbc.svg": "055f7bff8017f640737ec9ba64b787b1",
"assets/packages/simpleicons/assets/icons/down.svg": "45cd4059a313be1c151ce3cfa455b0cb",
"assets/packages/simpleicons/assets/icons/church.svg": "61d0ad67bdbda1b06aa46a535a7aa25f",
"assets/packages/simpleicons/assets/icons/crop.svg": "2fb2391a9e17e8aaa28fc562100b1637",
"assets/packages/simpleicons/assets/icons/pie-chart-alt.svg": "f41a298d31dfe548212c8aa7992ddc9b",
"assets/packages/simpleicons/assets/icons/tag.svg": "9dcfbbddcf2c03db51a32117f210f4e6",
"assets/packages/simpleicons/assets/icons/briefcase.svg": "830b8401cb184eaf4f86f49edb17d2e8",
"assets/packages/simpleicons/assets/icons/align-bottom.svg": "751ba3b48ca687e4573f007b0c6cca9c",
"assets/packages/simpleicons/assets/icons/distribute-horizontal.svg": "c3b982b8320e7369dd563ca8e9058846",
"assets/packages/simpleicons/assets/icons/headset.svg": "6aba9621e364178131ee9f0f3d40e258",
"assets/packages/simpleicons/assets/icons/inbox.svg": "6e87fb9b494cd65dd34a338a2454bce3",
"assets/packages/simpleicons/assets/icons/forward-circle.svg": "1f3061950ba894659a46aff0a7e9b415",
"assets/packages/simpleicons/assets/icons/power.svg": "8c283a37b786fe3e4fd9b5ed02ade784",
"assets/packages/simpleicons/assets/icons/microphone.svg": "9e715f40cab3245f7ba42dff6e54c6a1",
"assets/packages/simpleicons/assets/icons/drag.svg": "119378b7522457d989a58e384aead596",
"assets/packages/simpleicons/assets/icons/elbow-connector.svg": "51e24d63a6f4acc7b97fa1407d8288f8",
"assets/packages/simpleicons/assets/icons/sort-low-to-high.svg": "9ac61514e3a881e3ddd24c55e35446a6",
"assets/packages/simpleicons/assets/icons/page-number.svg": "3a0f67f5788373a4332dc4fda74171d0",
"assets/packages/simpleicons/assets/icons/adjust-horizontal.svg": "b1251513b804378ea286951e2cfff8c4",
"assets/packages/simpleicons/assets/icons/float-center.svg": "83731b7ba6fb74a08882a181aa54f6cd",
"assets/packages/simpleicons/assets/icons/depth-chart.svg": "186a3557d082156e53448b43c2996230",
"assets/packages/simpleicons/assets/icons/double-caret-up-circle.svg": "6e73461d74c0675480a8e23abe0857f7",
"assets/packages/simpleicons/assets/icons/airpods.svg": "55f1329c15531f41a9b54445e7c41646",
"assets/packages/simpleicons/assets/icons/user-square.svg": "50adc6a1a9adfc66a8f4455b470d2894",
"assets/packages/simpleicons/assets/icons/file.svg": "9e0cc54a77c7c7319d57154ab4ad7565",
"assets/packages/simpleicons/assets/icons/edit-circle.svg": "27a5d50f6e1ad34c91d166c0bfee4de2",
"assets/packages/simpleicons/assets/icons/paw.svg": "fc3a237ad0c8b9a30e9c80e72a2a105a",
"assets/packages/simpleicons/assets/icons/adjust-horizontal-alt.svg": "ee406544d9340a4df478870e22482ad5",
"assets/packages/simpleicons/assets/icons/gba.svg": "b6f086bfb33af084c0236f3760ad4e72",
"assets/packages/simpleicons/assets/icons/rand.svg": "016fdea6a044534f1ebac2d9b46e5ede",
"assets/packages/simpleicons/assets/icons/shield-tick.svg": "523d8db3ca47940763718a81d2ed9415",
"assets/packages/simpleicons/assets/icons/double-caret-left.svg": "66abde5d0879f69f1b8bf49a0281e022",
"assets/packages/simpleicons/assets/icons/spreadsheet.svg": "f9370ec1a6fa61226d31d7c3565fdae9",
"assets/packages/simpleicons/assets/icons/keyboard.svg": "56868c4fa42c778b7a13fa0def8e4ebb",
"assets/packages/simpleicons/assets/icons/x.svg": "ae292638e5c1090efd366e836f160dd4",
"assets/packages/simpleicons/assets/icons/home-alt.svg": "9d273ca80fd5d27a447d88e4da7ee3bd",
"assets/packages/simpleicons/assets/icons/joystick.svg": "640143839829bb4f404aee142aa2be50",
"assets/packages/simpleicons/assets/icons/bath.svg": "9ea615d4f9729f9c7b5e369d0db909cd",
"assets/packages/simpleicons/assets/icons/bar-chart.svg": "7fc5e58ec96cbc5b0a3b5529b0420772",
"assets/packages/simpleicons/assets/icons/qr-code.svg": "ae6b351a01e0344c027de56420220d21",
"assets/packages/simpleicons/assets/icons/up.svg": "501bc5e1516e333d90319c0879d0a97e",
"assets/packages/simpleicons/assets/icons/question-circle.svg": "f6043c96c70f5222e376b6c7e81f9f12",
"assets/packages/simpleicons/assets/icons/doc.svg": "3f5b91839f6b2b7a845fafdf9bbdb6e4",
"assets/packages/simpleicons/assets/icons/layers-subtract.svg": "60b8c020e444bce3981d415ac121e5f2",
"assets/packages/simpleicons/assets/icons/h360.svg": "ca5df9665c4aeb915fad657649c7972f",
"assets/packages/simpleicons/assets/icons/bottom-left.svg": "8edf39655174ea895cd98cddc346fe24",
"assets/packages/simpleicons/assets/icons/question.svg": "4a90cd3387a2e54d7f6cec6d146cd704",
"assets/packages/simpleicons/assets/icons/eye-closed.svg": "7b350d15aaa1e1f589c1bfd75117a58e",
"assets/packages/simpleicons/assets/icons/zip.svg": "c56a33b9562c89a431924c5324d9aae7",
"assets/packages/simpleicons/assets/icons/lock.svg": "71b966da40116a739a032efa394585db",
"assets/packages/simpleicons/assets/icons/google-streetview.svg": "717d8563d9669dde13810d258c0ad933",
"assets/packages/simpleicons/assets/icons/chat-typing.svg": "25b5bb60fcc6e2735339eed79806c3d6",
"assets/packages/simpleicons/assets/icons/sd-card.svg": "26d1042d2bea0b13ac628d57b4f09acc",
"assets/packages/simpleicons/assets/icons/distribute-vertical.svg": "73cff12ff5d2cc0629b6c844efbcaff1",
"assets/packages/simpleicons/assets/icons/pen.svg": "59cbb7359b8b978d3a76707a4edf744a",
"assets/packages/simpleicons/assets/icons/discount.svg": "35c943ddbedb84ab9411e3680c5e03b0",
"assets/packages/simpleicons/assets/icons/anti-clockwise.svg": "3a761370ed7430d4868b55c47cb66ce3",
"assets/packages/simpleicons/assets/icons/clipboard.svg": "0cd29aa4007ff85038c9e3c9d02591e8",
"assets/packages/simpleicons/assets/icons/message-x.svg": "339068edabb89d598347487a277d98c7",
"assets/packages/simpleicons/assets/icons/double-caret-left-small.svg": "62b928da80a485a016a7be5606e008bb",
"assets/packages/simpleicons/assets/icons/euro.svg": "70188cc650a3a632b0406b07cd695ac9",
"assets/packages/simpleicons/assets/icons/link.svg": "51e3dbde3a8bf0a119c4c9fbcdfb30c4",
"assets/packages/simpleicons/assets/icons/certificate.svg": "d3ddd862ab287f6e2395e63578fbf0e1",
"assets/packages/simpleicons/assets/icons/key.svg": "8f42114a44d9dff38e4516b6d0b30ddc",
"assets/packages/simpleicons/assets/icons/arrow-right.svg": "19a1bee29af2926855b752af5e15c9e8",
"assets/packages/simpleicons/assets/icons/calendar-plus.svg": "185384e6fd22f9ac629fbeda767617cf",
"assets/packages/simpleicons/assets/icons/brush.svg": "c55597a2dbd85476a8891071e75daf19",
"assets/packages/simpleicons/assets/icons/at.svg": "8073b006ffaafeaff2df5c43dfab3c13",
"assets/packages/simpleicons/assets/icons/magsafe.svg": "dc19498357e314a0f1418d5babd75196",
"assets/packages/simpleicons/assets/icons/stop-circle.svg": "15d64c0daf1b77e7982f3e0d91d03b70",
"assets/packages/simpleicons/assets/icons/arrow-left-circle.svg": "bbbf0194507397acec6c1403e19df885",
"assets/packages/simpleicons/assets/icons/star-small.svg": "036d7975dd07a36a404d386f879418ac",
"assets/packages/simpleicons/assets/icons/adjust-vertical.svg": "1ddd78fd73c2678eeb25295f448f82c9",
"assets/packages/simpleicons/assets/icons/calendar-tick.svg": "3b8dc3ea00066ecb0cd86fd6920677bd",
"assets/packages/simpleicons/assets/icons/stopwatch.svg": "f0c8d1b6cd2c670fd14b7db885f1f11e",
"assets/packages/simpleicons/assets/icons/border-all.svg": "ac8d93a5e3f8acfb1387bf084a6e4a4b",
"assets/packages/simpleicons/assets/icons/cart.svg": "862c13dcf6d0ae611929af4bf4e41017",
"assets/packages/simpleicons/assets/icons/envelope.svg": "480daa9c3f549b15c30b8e9af5db2454",
"assets/packages/simpleicons/assets/icons/border-inner.svg": "23f121c59180963fee51895f1c8ed33c",
"assets/packages/simpleicons/assets/icons/battery-5.svg": "b7341491a22248dc3d2d18e41b954210",
"assets/packages/simpleicons/assets/icons/image-alt.svg": "e0c683f2330ccd638f024a6da002dd6e",
"assets/packages/simpleicons/assets/icons/archive.svg": "6f172f96b6124fa8869f76047666d041",
"assets/packages/simpleicons/assets/icons/add-small.svg": "6abb75684519b80eca817d68fb1e311e",
"assets/packages/simpleicons/assets/icons/question-small.svg": "27482085507ae44cb7781ea40d77fbd5",
"assets/packages/simpleicons/assets/icons/school.svg": "afc4b6d0c896475a5b72a54580df4071",
"assets/packages/simpleicons/assets/icons/shield.svg": "7a4b2d13f0f91baf8f2f8d37825b0423",
"assets/packages/simpleicons/assets/icons/download.svg": "783016b4fe0e146aeb3fe98ba917903e",
"assets/packages/simpleicons/assets/icons/game-controller.svg": "7c9babd8d3941013cadd4e23c515a5fe",
"assets/packages/simpleicons/assets/icons/double-caret-down-circle.svg": "535fca0fef0509f2c2297e11682011dc",
"assets/packages/simpleicons/assets/icons/bracket.svg": "5624af2cba1bd687d18684b3ae7740ac",
"assets/packages/simpleicons/assets/icons/kanban.svg": "f2a7d85333d46cb99fa26d4668596dd2",
"assets/packages/simpleicons/assets/icons/expand.svg": "ca97ba8c579ddfe737c553f2d4a6daf2",
"assets/packages/simpleicons/assets/icons/grid-layout.svg": "88d4a8541bd2a522e693565313ddebbf",
"assets/packages/simpleicons/assets/icons/n64.svg": "a3d3c4c389abdcb7e3f83f1905176df4",
"assets/packages/simpleicons/assets/icons/note.svg": "f6144f1e97e95a5aca549a22b7475203",
"assets/packages/simpleicons/assets/icons/pin.svg": "a9d5a8851321230f85ded4d2f1269533",
"assets/packages/simpleicons/assets/icons/battery-4.svg": "b65465f11274e4720a846909c77c67ea",
"assets/packages/simpleicons/assets/icons/usb-cable.svg": "a264c1ab0eeae7adc98b4c5949572511",
"assets/packages/simpleicons/assets/icons/phonecall-blocked.svg": "576caba25dffba8e995191ac0738bb41",
"assets/packages/simpleicons/assets/icons/area-chart.svg": "c832d6dc52cded1cc09bf9b521d8ff70",
"assets/packages/simpleicons/assets/icons/tv.svg": "cb7190f4db2dbcb731c66ed5359261ce",
"assets/packages/simpleicons/assets/icons/pound.svg": "385584fa082f7a293eb29b03cbf8ac60",
"assets/packages/simpleicons/assets/icons/play-small.svg": "30922145c9590c336ad9cc0756b189cd",
"assets/packages/simpleicons/assets/icons/user-plus.svg": "55f38113c4ed8256c3384c27b1545c53",
"assets/packages/simpleicons/assets/icons/drag-vertical.svg": "be2fde12866bd39ba4f11bc55e068a66",
"assets/packages/simpleicons/assets/icons/folders.svg": "9180bb87a4bff73106b9bc04c5a97b9a",
"assets/packages/simpleicons/assets/icons/double-caret-right-circle.svg": "c5e12adb4e52cc88ee0a61dd5a0cd749",
"assets/packages/simpleicons/assets/icons/screen-alt.svg": "92ce65f7b16ccc89ef51e3f526974b1c",
"assets/packages/simpleicons/assets/icons/layers.svg": "8e998265c5eafd119fa038ebc51c526b",
"assets/packages/simpleicons/assets/icons/align-center-vertical.svg": "e25c2c0db0e6c692c78175a1d921c451",
"assets/packages/simpleicons/assets/icons/book.svg": "b1f465ecfb43354bc7f3d11ec448a214",
"assets/packages/simpleicons/assets/icons/next-circle.svg": "8ce17092ff11bf285ef83d9c2502a9d0",
"assets/packages/simpleicons/assets/icons/bitcoin.svg": "6f9b3a7acf2fa5ab8c2ea67ab1d432fd",
"assets/packages/simpleicons/assets/icons/litecoin.svg": "ecea6787339f1fe6be2200c3eb1a947e",
"assets/packages/simpleicons/assets/icons/paragraph.svg": "225ffb28be730fec463fe0ffd6332cd1",
"assets/packages/simpleicons/assets/icons/plug.svg": "1de4dc38d264d55f7958de7c5437b933",
"assets/packages/simpleicons/assets/icons/shield-x.svg": "98344b05deee034f641d508039114333",
"assets/packages/simpleicons/assets/icons/battery-0.svg": "144674a9c339f6b869bcac5b8d0e753c",
"assets/packages/simpleicons/assets/icons/user-minus.svg": "44aab2cc91d96d4bed4a0b9b7c84bdb5",
"assets/packages/simpleicons/assets/icons/wallet.svg": "41b34722ac73c03bc21d8b42adada662",
"assets/packages/simpleicons/assets/icons/flag-alt.svg": "7b2431d4adf9efd89c24206b32d0c34a",
"assets/packages/simpleicons/assets/icons/bell.svg": "547c26622281fc9f4bee5e7608fa4c5a",
"assets/packages/simpleicons/assets/icons/code.svg": "6803a521688dd84b2303fcf3e50e69bf",
"assets/packages/simpleicons/assets/icons/snes.svg": "280b2c7ca7cbdb46eb261cf536d93027",
"assets/packages/simpleicons/assets/icons/plant.svg": "397f27966a3220a3c671e5eb94b446fb",
"assets/packages/simpleicons/assets/icons/tick.svg": "b68f7d445cd3c870a04814cfb490b553",
"assets/packages/simpleicons/assets/icons/align-text-right.svg": "7203b2cbdf989e528cec56fd115fe826",
"assets/packages/simpleicons/assets/icons/wallet-alt.svg": "264a262904078a4c371d1596b99cb979",
"assets/packages/simpleicons/assets/icons/gif.svg": "cbe9b95584d541b82d993e638109059f",
"assets/packages/simpleicons/assets/icons/sound-off.svg": "c6433373523e5d544b687d9b6d97fc72",
"assets/packages/simpleicons/assets/icons/flag.svg": "d9cd82fea4af538e5ea72cf22fb07cd0",
"assets/packages/simpleicons/assets/icons/battery-1.svg": "caad5bb50c64869de5c446383a7d0ba1",
"assets/packages/simpleicons/assets/icons/refresh-alt.svg": "f650bdd996fb6a7224c228d457f27904",
"assets/packages/simpleicons/assets/icons/stop.svg": "afc1aeefcf8b7340db0d016d1495bcea",
"assets/packages/simpleicons/assets/icons/right-circle.svg": "893aae0f376b497d620b4a9c23dd5c4f",
"assets/packages/simpleicons/assets/icons/border-vertical.svg": "2f22ae91576d643c22dd2f691e8b0a52",
"assets/packages/simpleicons/assets/icons/message-tick.svg": "b74071e17d67b65d84289a93b00b79e8",
"assets/packages/simpleicons/assets/icons/folder-x.svg": "a4af4cbe79fd41d37d4b1c7d59a5c23d",
"assets/packages/simpleicons/assets/icons/list-ordered.svg": "b8e30164d19a3b9068730c45c91b6771",
"assets/packages/simpleicons/assets/icons/bold.svg": "53553c8368566628d1d1046cb96016f7",
"assets/packages/simpleicons/assets/icons/message-plus.svg": "9eba2963011af12b9143a359b475624e",
"assets/packages/simpleicons/assets/icons/direction.svg": "e4223971b6afc0e39140a37175ec7817",
"assets/packages/simpleicons/assets/icons/scribble.svg": "7f478260eb3d5e2da53da57c116516a4",
"assets/packages/simpleicons/assets/icons/envelope-open.svg": "c83f38d5b3c68d3bc49cf1b1ae534076",
"assets/packages/simpleicons/assets/icons/wifi-low.svg": "a8e1ac7fe4e638e8825286e62eec0cc1",
"assets/packages/simpleicons/assets/icons/trophy.svg": "2423c632693fb03853f107555c9cfcb1",
"assets/packages/simpleicons/assets/icons/lightning-cable.svg": "f5fc2c0535fd513a23e1f80b07d84614",
"assets/packages/simpleicons/assets/icons/clipboard-minus.svg": "56c1fff8470ae70b0f4cd5aa79f3d65b",
"assets/packages/simpleicons/assets/icons/check.svg": "8c76db58071b0c463d35a817805cca2a",
"assets/packages/simpleicons/assets/icons/battery-3.svg": "206bd739bd274639d2232e07ada38d74",
"assets/packages/simpleicons/assets/icons/trend-up.svg": "a63f74394fa92c5681683d531d174993",
"assets/packages/simpleicons/assets/icons/folder-no-access.svg": "f28e2a91a3d4b90b62ea3fe683fe6c4c",
"assets/packages/simpleicons/assets/icons/eps.svg": "8fdb34ff6e8419f6f80eb53cf83fcc41",
"assets/packages/simpleicons/assets/icons/hospital.svg": "9df3c3afb6e22c9f7ca2eb5d795bc4be",
"assets/packages/simpleicons/assets/icons/minus-small.svg": "268410e6e12b923aa5f99672d0ec0f94",
"assets/packages/simpleicons/assets/icons/bluetooth.svg": "b798bd1abce232559d967ce850a094d5",
"assets/packages/simpleicons/assets/icons/layers-intersect.svg": "c83232dbd233c49e83c6844483464800",
"assets/packages/simpleicons/assets/icons/pie-chart.svg": "ebd6c830486b9c184d1e400ac0f025c2",
"assets/packages/simpleicons/assets/icons/double-caret-right-small.svg": "9cf05db66fc3b9912256c55acb7c9dc3",
"assets/packages/simpleicons/assets/icons/headphones.svg": "745e3ec6fe3f71b75e01fd43a2c4117b",
"assets/packages/simpleicons/assets/icons/double-caret-down-small.svg": "21051069c68132fbcfb7e624393713b2",
"assets/packages/simpleicons/assets/icons/screen-alt-2.svg": "ab4175be19c06e486b8f31eab4e1507f",
"assets/packages/simpleicons/assets/icons/search-small.svg": "49e9deccd56d1e1db67d30f2ee8a053e",
"assets/packages/simpleicons/assets/icons/floorplan.svg": "95091fa776e4c4d820a42567cca2d051",
"assets/packages/simpleicons/assets/icons/watch.svg": "b9f85ed714b1648f9bf7926abaae28c3",
"assets/packages/simpleicons/assets/icons/drag-horizontal.svg": "b21da2530d39c9e27c1856eb0c9db547",
"assets/packages/simpleicons/assets/icons/battery-2.svg": "6f4ee9dc52020abecb63a627e2f8bb78",
"assets/packages/simpleicons/assets/icons/info.svg": "a1289180ebb430f73bf100a5ea032799",
"assets/packages/simpleicons/assets/icons/pin-alt.svg": "ecee619f3d79f18cbe8527012766f114",
"assets/packages/simpleicons/assets/icons/ms-excel.svg": "232b077b62d6051c86cdacb9713d08b0",
"assets/packages/simpleicons/assets/icons/loader.svg": "3420c5a9449f65607ece0d2b507c50ac",
"assets/packages/simpleicons/assets/icons/add.svg": "035bed5c0c02874d30c00c3175313cc2",
"assets/packages/simpleicons/assets/icons/sort-high-to-low.svg": "5aaa0520f290cd59c7423048343bd49a",
"assets/packages/simpleicons/assets/icons/info-circle.svg": "4099bf6440461149a5e5edddbbe1fdba",
"assets/packages/simpleicons/assets/icons/file-x.svg": "e38f82819bb77875b247d4d69442cb2e",
"assets/packages/simpleicons/assets/icons/folder-plus.svg": "08a0e2eafe42645a4f486ebc82b6bdf5",
"assets/packages/simpleicons/assets/icons/adjust-vertical-alt.svg": "b5b91edc3b66c53a3771223082c30850",
"assets/packages/simpleicons/assets/icons/toggle.svg": "39b0405da8032ae3d3de8caea2c053f7",
"assets/packages/simpleicons/assets/icons/button.svg": "e6a4304087710023ebd09a4b7a0e02b6",
"assets/packages/simpleicons/assets/icons/zoom-in.svg": "0506af2db5ee7b00ecb396b8c73b6402",
"assets/packages/simpleicons/assets/icons/bag.svg": "7b630fd7893b06c322cf119d10459c08",
"assets/packages/simpleicons/assets/icons/message-text-alt.svg": "8cdb0fb9520b7827c87bb9f528820fab",
"assets/packages/simpleicons/assets/icons/border-right.svg": "f3950c8daba9f5949261140091fb5e9e",
"assets/packages/simpleicons/assets/icons/venn-diagram.svg": "bc00a9f332da495373ec37a5fdf5ad66",
"assets/packages/simpleicons/assets/icons/garage.svg": "540a8a69d3e636f9b46d56f950a3347d",
"assets/packages/simpleicons/assets/icons/refresh.svg": "9961439d2342bf30c61a5f94cbdde737",
"assets/packages/simpleicons/assets/icons/right-small.svg": "e94a429bc2b98d5b3b60ef10eaecf064",
"assets/packages/simpleicons/assets/icons/arrow-right-circle.svg": "11ce0a1143ea6770e9ea6d38c7f63004",
"assets/packages/simpleicons/assets/icons/text.svg": "f0d21e417ec600509fda22064dba14ec",
"assets/packages/simpleicons/assets/icons/tick-small.svg": "496ed54b630f26b72bebcac829dcb49e",
"assets/packages/simpleicons/assets/icons/align-right.svg": "8d4b73f335e01499bc66db8169e18043",
"assets/packages/simpleicons/assets/icons/image.svg": "d39b9ad453041df92475c86c419197f3",
"assets/packages/simpleicons/assets/icons/heart-small.svg": "f96c08d977f420471b2d176efe7c071f",
"assets/packages/simpleicons/assets/icons/in-ear-headphones.svg": "3103fb79688e6028fcf33b85a8aa27eb",
"assets/packages/simpleicons/assets/icons/thumb-down.svg": "427d5e7aa4bcd51c02cdf9f6988b09fc",
"assets/packages/simpleicons/assets/icons/candle-chart.svg": "b3892c69ebff158cbf71cb8e78a2b336",
"assets/packages/simpleicons/assets/icons/save.svg": "4968c2593e53460ab481853c30467683",
"assets/packages/simpleicons/assets/icons/scan.svg": "7a5186632ae4a2fc4a228c5ff58e9c23",
"assets/packages/simpleicons/assets/icons/right.svg": "7cf2bdcce8247ef1e6b4e18dd69186d0",
"assets/packages/simpleicons/assets/icons/money-stack.svg": "e023cf38f20e8484e366bfa8926ee332",
"assets/packages/simpleicons/assets/icons/message-text.svg": "6e200a11fe65e5abb844fb2a7b7e1319",
"assets/packages/simpleicons/assets/icons/csv.svg": "ff0d220751668eb275cbb123ff48b594",
"assets/packages/simpleicons/assets/icons/text-document.svg": "bf0b333a7bc0d8857c96f3720f5b6e3d",
"assets/packages/simpleicons/assets/icons/mp4.svg": "ef21ed0f2fd9a5272743ef13afd21306",
"assets/packages/simpleicons/assets/icons/link-remove.svg": "bbdf2d519ed64067dbeca1d973194f94",
"assets/packages/simpleicons/assets/icons/message.svg": "132992e5a12819b74786596b5fe9f220",
"assets/packages/simpleicons/assets/icons/zoom-out.svg": "c1a620e14c4a5fdeb2e1d378239339f1",
"assets/packages/simpleicons/assets/icons/box.svg": "a80b9dda2102463eb244c79951bb416a",
"assets/packages/simpleicons/assets/icons/superscript.svg": "ac28b3db5d42ac19a017455d9e0c897e",
"assets/packages/simpleicons/assets/icons/denied.svg": "086a2d8fa44c9f12c9bc79d737fb5c79",
"assets/packages/simpleicons/assets/icons/contract.svg": "433ca3262d1b2ac67c40cf42c8d34bcb",
"assets/packages/simpleicons/assets/icons/percent.svg": "21c3258cf9ada1b635f14ff19b6ca834",
"assets/packages/simpleicons/assets/icons/square.svg": "0fbda8696c027529b040f845aaff7d01",
"assets/packages/simpleicons/assets/icons/play.svg": "2c280fd734d34083db416ca7df963fd5",
"assets/packages/simpleicons/assets/icons/chat.svg": "e9fdf2a425550cbae6efc94647512012",
"assets/packages/simpleicons/assets/icons/paypal.svg": "cadede27e67832278fffad72117b933d",
"assets/packages/simpleicons/assets/icons/page-break.svg": "37e7cc723a1b96289a5e4e15a1979427",
"assets/packages/simpleicons/assets/icons/table.svg": "1ad6ffeaeff82ccbd7ad6c8966a89eee",
"assets/packages/simpleicons/assets/icons/send.svg": "48adffa72c681e5d65a4894b54aee687",
"assets/packages/simpleicons/assets/icons/barcode.svg": "8a4d36ad5a1588a035ce44950e3a4c87",
"assets/packages/simpleicons/assets/icons/thumbtack.svg": "ff1308e70688d900a3d604a08f4540c7",
"assets/packages/simpleicons/assets/icons/tick-circle.svg": "8211f1962a2fb4f91cc7559c919963a8",
"assets/packages/simpleicons/assets/icons/search-property.svg": "84a70fdb10295b4260cc7d86a06bdfcb",
"assets/packages/simpleicons/assets/icons/nintendo-switch.svg": "ae4fdab984f3fc558b1c791f732a7d08",
"assets/packages/simpleicons/assets/icons/send-up.svg": "b043d392f6822ddf40e020d6ea822cc8",
"assets/packages/simpleicons/assets/icons/camera.svg": "1b121dfb2082aa5a0d52eb52a90989e5",
"assets/packages/simpleicons/assets/icons/folder-tick.svg": "b8323df0ad5c8ac57cf638ab6b9294c0",
"assets/packages/simpleicons/assets/icons/svg.svg": "36995f313ef3467c1efd627c3d803148",
"assets/packages/simpleicons/assets/icons/border-top.svg": "55e0fc3f71606bb4251ab8ec22e0d0b0",
"assets/packages/simpleicons/assets/icons/folder-minus.svg": "e32da59711200df3fb66ccf049d96e14",
"assets/packages/simpleicons/assets/icons/vector-document.svg": "087a205fcc8bfaaecf94fc76760bc5f6",
"assets/packages/simpleicons/assets/icons/audio-document.svg": "6bc540b2ef785eb9a3e28a6309d01407",
"assets/packages/simpleicons/assets/icons/loop.svg": "2973905ed4ad48fa059264ef96df7571",
"assets/packages/simpleicons/assets/icons/ms-powerpoint.svg": "c038fd96b2afc7d42d0dd22d8ccc5988",
"assets/packages/simpleicons/assets/icons/line.svg": "29de3f6abfc92ce5354d52e1d2ee93fe",
"assets/packages/simpleicons/assets/icons/up-circle.svg": "24033f93df62b3133c772ab482690660",
"assets/packages/simpleicons/assets/icons/exclamation-circle.svg": "71f2e02115d147ca0eab31aab71bdf5f",
"assets/packages/simpleicons/assets/icons/signin.svg": "08a1a1aa6bb605388fec9540bbb5882f",
"assets/packages/simpleicons/assets/icons/arrow-up-small.svg": "dcede1644156b1f5b2385f6aa7c9dbf4",
"assets/packages/simpleicons/assets/icons/curved-connector.svg": "20bc765b1eb337e9dd2a251098ebdc8b",
"assets/packages/simpleicons/assets/icons/align-text-center.svg": "0a6066aa1fac7589bd7899b265a0db2a",
"assets/packages/simpleicons/assets/icons/wan.svg": "cc025eac2cc25d4e8721c6edfd756912",
"assets/packages/simpleicons/assets/icons/down-circle.svg": "5c0732a7c432a8f509e350d4a7f69455",
"assets/packages/simpleicons/assets/icons/attachment.svg": "bb891f6ee08a6fa56a3be95e33cf32f4",
"assets/packages/simpleicons/assets/icons/edit-small.svg": "6952aba45d94c9327a0c537bb75c77ff",
"assets/packages/simpleicons/assets/icons/imac.svg": "15178ba5a054d95afd3a2dd40836e4f8",
"assets/packages/simpleicons/assets/icons/address-book.svg": "45bac4087a0b3b9d545360d469b3d6fd",
"assets/packages/simpleicons/assets/icons/bag-alt.svg": "a297266018fca38778b9feebf009fb9e",
"assets/packages/simpleicons/assets/icons/sort-alphabetically.svg": "bf86d6291266cbb2049455693b873050",
"assets/packages/simpleicons/assets/icons/hashtag.svg": "e33bc3e439b77678020c0a20eb10c34d",
"assets/packages/simpleicons/assets/icons/star.svg": "7a692a8b59818933dbd546ceb40f8eb0",
"assets/packages/simpleicons/assets/icons/face-id.svg": "1930aebd5f09c60f878a7ed2ad1a1d42",
"assets/packages/simpleicons/assets/icons/double-caret-up.svg": "3a4d7d99d38d4da94041deb6d882e617",
"assets/packages/simpleicons/assets/icons/sun.svg": "aab0ab5e5b4ac8127d104553d4416de2",
"assets/packages/simpleicons/assets/icons/appointments.svg": "a701633e080122f982ee63682383733e",
"assets/packages/simpleicons/assets/icons/bag-minus.svg": "9b16bec6562aa022a68f009937d862ec",
"assets/packages/simpleicons/assets/icons/file-no-access.svg": "d4ba18fec233986c7bb2c656e715e0c8",
"assets/packages/simpleicons/assets/icons/edit.svg": "308f532fa19195292ffc34b3e862b605",
"assets/packages/simpleicons/assets/icons/next.svg": "1f446d5404bc3b6eb6d2ad8f3f6aac12",
"assets/packages/simpleicons/assets/icons/anchor.svg": "925da5bcd0825949aa0ebdeb27c5c6c7",
"assets/packages/simpleicons/assets/icons/float-right.svg": "eedb5f88423fd47e16f93fce82f325d9",
"assets/packages/simpleicons/assets/icons/bulb-off.svg": "f9262a986dd0bbb1d35c486d35d06ba3",
"assets/packages/simpleicons/assets/icons/top-right.svg": "6a5aaa0a899d9a16af027f67cd05d9c5",
"assets/packages/simpleicons/assets/icons/lifebuoy.svg": "04179afc67d36e05fe86d1bdbd3d0189",
"assets/packages/simpleicons/assets/icons/search-circle.svg": "361020870f3841259a8c86a1c519c5cf",
"assets/packages/simpleicons/assets/icons/pdf.svg": "2e7cced3f90fef5fecff087472793a9d",
"assets/packages/simpleicons/assets/icons/unlock.svg": "5ac5349509d7c0105bbfefa632c9581c",
"assets/packages/simpleicons/assets/icons/double-caret-right.svg": "0eeda77e7b029b83d4a9247d9d0efa20",
"assets/packages/simpleicons/assets/icons/border-left.svg": "7ff9c30084752bb3b413b508a45ba8cc",
"assets/packages/simpleicons/assets/icons/compass.svg": "ef9031e5f8af8dd851aea591f8f92940",
"assets/packages/simpleicons/assets/icons/plus-circle.svg": "b36c40583891e663b151dad4c02b74ee",
"assets/packages/simpleicons/assets/icons/exclamation-small.svg": "b958031d4aeed87d8e32d27788ceb9a3",
"assets/packages/simpleicons/assets/icons/ppt.svg": "8b48a1d9a56bd56ffa8cc5b831ccfb5c",
"assets/packages/simpleicons/assets/icons/unlock-small.svg": "f7a351358a7a5923ba801664f800d779",
"assets/packages/simpleicons/assets/icons/bank.svg": "cf7efa5d2cb6c7d674c91dcb647e3ac8",
"assets/packages/simpleicons/assets/icons/frame.svg": "515b699923753c3f94031858276ab6c3",
"assets/packages/simpleicons/assets/icons/credit-card.svg": "b571604f7027f4858b33739af2caa633",
"assets/packages/simpleicons/assets/icons/user-circle.svg": "dc27b7ce5f2f49db5b4faf41ff0fb2d3",
"assets/packages/simpleicons/assets/icons/computer.svg": "1527ce5bcad39b906bb97a19571036af",
"assets/packages/simpleicons/assets/icons/mp3.svg": "43e87863856438cda6bf845b2bc0bcfd",
"assets/packages/simpleicons/assets/icons/section-add.svg": "4aac9fbe5eb290e3040630ada8da8930",
"assets/packages/simpleicons/assets/icons/send-down.svg": "b6702a68d2eb6bb8048e86280c1486e1",
"assets/packages/simpleicons/assets/icons/phonecall.svg": "f1d3a8460c75b2a9f23c86d17389b20c",
"assets/packages/simpleicons/assets/icons/clockwise.svg": "c9da24d60bfa242e22acfc661497a4dd",
"assets/packages/simpleicons/assets/icons/file-plus.svg": "a7acc0f2615422687c6e4755629ee100",
"assets/packages/simpleicons/assets/icons/gantt-chart.svg": "63e012069886370ac00efd9404fb1685",
"assets/packages/simpleicons/assets/icons/divider-line.svg": "16fb348a68681695d8802261c4e7ccf6",
"assets/packages/simpleicons/assets/icons/diamond.svg": "4afb33a2c6bed48dc7feeb9d372d4e70",
"assets/packages/simpleicons/assets/icons/align-center-horizontal.svg": "f215f8b04ce161a6b7a61cf8a89d74f9",
"assets/packages/simpleicons/assets/icons/clock.svg": "c3cedf7fbfab3caedc90de40a086cd64",
"assets/packages/simpleicons/assets/icons/router.svg": "dc15f58b8c6e34c910a78ce30184ffdd",
"assets/packages/simpleicons/assets/icons/phone.svg": "c689e33af11582084660dcfa84fb7c1e",
"assets/packages/simpleicons/assets/icons/section-remove.svg": "76be1526a825385ed6f16ad279c50ff1",
"assets/packages/simpleicons/assets/icons/eye.svg": "1f51b2d41e01f5fded506b1edd58462f",
"assets/packages/simpleicons/assets/icons/mobile.svg": "61dcbbc900c4d4fa8d683a425e4ff82b",
"assets/packages/simpleicons/assets/icons/indent-increase.svg": "b7ec4bdc90b98255c42a47fe80fe0b91",
"assets/packages/simpleicons/assets/icons/down-small.svg": "430a517306374ee08497f49ccce38904",
"assets/packages/simpleicons/assets/icons/location.svg": "34a1eeae049066038696438fac79b3f6",
"assets/packages/simpleicons/assets/icons/arrow-right-small.svg": "05b6680659fa005cbbeafd332218ba45",
"assets/packages/simpleicons/assets/icons/border-radius.svg": "115509aa26b1e3999b3d7fde909ead3d",
"assets/packages/simpleicons/assets/icons/bin.svg": "702f1576a8bff2c3c4ebaf249d6f88fd",
"assets/packages/simpleicons/assets/icons/gift.svg": "b071f0441bb88f079f7014acf7ceecec",
"assets/packages/simpleicons/assets/icons/mov.svg": "d54735b94f74154e1b9bdcc5ba5227e9",
"assets/packages/simpleicons/assets/icons/wand.svg": "aa351287f7293e07fc0654d9ab72c7bb",
"assets/packages/simpleicons/assets/icons/car.svg": "0704f0d0d011d7df37cb9dccdfcc6fdc",
"assets/packages/simpleicons/assets/icons/hdmi-cable.svg": "40906c3ed4267360f9fb633ea21e2dc1",
"assets/packages/simpleicons/assets/icons/more-vertical.svg": "97e4762288adb7bfce2355546cf34cb7",
"assets/packages/simpleicons/assets/icons/share.svg": "01dd695f294f4a7c79e34dd7efdb41a2",
"assets/packages/simpleicons/assets/icons/pause-small.svg": "8c80b7ebd3779e48146d87ffe3a9057e",
"assets/packages/simpleicons/assets/icons/border-bottom.svg": "0118af50fb513d44cefed236eab4f4da",
"assets/packages/simpleicons/assets/icons/message-no-access.svg": "e5b22aac5252611162ee6dc8ae5a49e1",
"assets/packages/simpleicons/assets/icons/arrow-up.svg": "82e69d8008223c8742c533b04923fc66",
"assets/packages/simpleicons/assets/icons/money.svg": "d4060774e79d2cd0c3ec9e76485388bf",
"assets/packages/simpleicons/assets/icons/jpg.svg": "4ef3f35d90ea3ae218b88b60466e6f36",
"assets/packages/simpleicons/assets/icons/wifi-full.svg": "f1392605911955562d15da7c8877ed1c",
"assets/packages/simpleicons/assets/icons/calendar-minus.svg": "beb1cbe2c0ae99de1164f6c88247bfed",
"assets/packages/simpleicons/assets/icons/attach.svg": "e01cad2860238009a74d37505ae52bd3",
"assets/packages/simpleicons/assets/icons/lock-small.svg": "bf18328db7d10c8e0be3a1e114c8373c",
"assets/packages/simpleicons/assets/icons/filter.svg": "e850127efd1972fbf86643159c2492a8",
"assets/packages/simpleicons/assets/icons/basket-minus.svg": "f0176972b80588c869bd5f4b46f67d71",
"assets/packages/simpleicons/assets/icons/italic.svg": "d9beb50ef0ad02557ff60d5e92d3c20e",
"assets/packages/simpleicons/assets/icons/globe-americas.svg": "4defeeb30eac960c51540c32e1e89db5",
"assets/packages/simpleicons/assets/icons/image-document.svg": "f8909cbf86e81a39e16e244984be0325",
"assets/packages/simpleicons/assets/icons/game-controller-retro.svg": "7604883203950424bd0c90e015c48ff0",
"assets/packages/simpleicons/assets/icons/google-ad.svg": "5b541b7213d221116ed1ab6ba229dbf1",
"assets/packages/simpleicons/assets/icons/calendar-no-access.svg": "11fc4fd4fd0e8bd327821a658141efe0",
"assets/packages/simpleicons/assets/icons/calendar.svg": "be267c05509964706069e62860b1ae56",
"assets/packages/simpleicons/assets/icons/globe.svg": "effd68ccf8ed89862492173d241fc6c0",
"assets/packages/simpleicons/assets/icons/arrow-left.svg": "5a37e44cb7eb6a6363886f2d7880d1b8",
"assets/packages/simpleicons/assets/icons/paintbrush.svg": "07344cb3a5d47da42ad15a68a1eed68f",
"assets/packages/simpleicons/assets/icons/yen.svg": "9de83481f0408c0344a6479dbd3d3ac4",
"assets/packages/simpleicons/assets/icons/bulb-on.svg": "d0b7abfbcea1ff314f60cfd97a87b02e",
"assets/packages/simpleicons/assets/icons/layers-union.svg": "ebbde94f5b7774fdc2bfacc1f0d2194b",
"assets/packages/simpleicons/assets/icons/minus-circle.svg": "8825b1122cd8ec133fc108400a326147",
"assets/packages/simpleicons/assets/icons/border-horizontal.svg": "f4d66e9aea81ebaf84aefea0ae9908ae",
"assets/packages/simpleicons/assets/icons/laptop.svg": "4ff87efb9038ae1679559126848a1638",
"assets/packages/simpleicons/assets/icons/list-layout.svg": "b8653fcd55291d850ad24d5cc5f20eaf",
"assets/packages/simpleicons/assets/icons/arrow-down-small.svg": "c1b2ddabe9b62268c39b04633cf424d9",
"assets/packages/simpleicons/assets/icons/clipboard-x.svg": "9b318e3ef2a2a87f8c698b2b8f0160e2",
"assets/packages/simpleicons/assets/icons/message-minus.svg": "aa954ad572e1178853d32edef8680e3e",
"assets/packages/simpleicons/assets/icons/artboard.svg": "b0375909521a8a975daeb20aacac1b39",
"assets/packages/simpleicons/assets/icons/list-unordered.svg": "7af5357d4abb991618910a82029debec",
"assets/packages/simpleicons/assets/icons/file-tick.svg": "79b66dd232ace4550c96e1ace2e5c6ee",
"assets/packages/simpleicons/assets/icons/cost-estimate.svg": "134b2ada2fb390b0711c9112e4e2c0a9",
"assets/packages/simpleicons/assets/icons/bottom-right.svg": "7b85f239a065f3c657e11618b817b642",
"assets/packages/simpleicons/assets/icons/donut-chart.svg": "75f843bfd419b541d22ea2b37717aa76",
"assets/packages/simpleicons/assets/icons/double-caret-down.svg": "5db31b42bd376bdf84043b52052dc068",
"assets/packages/simpleicons/assets/icons/quote.svg": "5d384ffadc4f0a2f300e29a510b3a7a5",
"assets/packages/simpleicons/assets/icons/cup.svg": "639c24a8a8818ac06d9e9661463cb5f8",
"assets/packages/simpleicons/assets/icons/invoice.svg": "401ab3702bd97cf5de6d219c551d68f0",
"assets/packages/simpleicons/assets/icons/rewind.svg": "cfbc24ad81eb591335c1c053d49fcd98",
"assets/packages/simpleicons/assets/icons/caret-vertical.svg": "19c5b886110bab3eab4ef0286b74b3a3",
"assets/packages/simpleicons/assets/icons/upload.svg": "aa195b603cb71cabff30dbf9336d3cc0",
"assets/packages/simpleicons/assets/icons/align-text-left.svg": "a60825dcfe957a18221812a10a862479",
"assets/packages/simpleicons/assets/icons/calendar-x.svg": "b356770373f48300d831c7b0d6f1a519",
"assets/packages/simpleicons/assets/icons/wifi-none.svg": "48e9da3c63d1b6b7e941b05753011f44",
"assets/packages/simpleicons/assets/icons/minimise.svg": "982b5bd0c376dd0e1b2249f77efb6550",
"assets/packages/simpleicons/assets/icons/pause.svg": "892f996a7c5d59efcc1fbb4053ef9f09",
"assets/packages/simpleicons/assets/icons/audio-cable.svg": "74ca2be98fb16633078d261a88a22a90",
"assets/packages/simpleicons/assets/icons/arrow-down-circle.svg": "9cf3d4619fdb48338931a570c902e534",
"assets/packages/simpleicons/assets/icons/forward.svg": "fa0655651b4a116d658d9e221a459a2b",
"assets/packages/simpleicons/assets/icons/indent-decrease.svg": "92d8a512a24cee4492a1a3e3cbd0c88d",
"assets/packages/simpleicons/assets/icons/star-circle.svg": "b735c259e989b2a84a0b28eaa3386116",
"assets/packages/simpleicons/assets/icons/layers-difference.svg": "3e5aa551df1cb7605a8154a96f2e1934",
"assets/packages/simpleicons/assets/icons/bookmark.svg": "89c3e79c4fbec18484c8618713753641",
"assets/packages/simpleicons/assets/icons/chat-typing-alt.svg": "78fbd691cc2748d1cce29ecc73f79a52",
"assets/packages/simpleicons/assets/icons/float-left.svg": "c89cec325b51bb52b536ebb6174b7946",
"assets/packages/simpleicons/assets/icons/caret-vertical-small.svg": "9b980846379f844b7e95c2cd15a20160",
"assets/packages/simpleicons/assets/icons/tablet.svg": "07338ffe684d585cb9b487266b9c105f",
"assets/packages/simpleicons/assets/icons/screen.svg": "29dacd66d6deb544fe9c5a0237729504",
"assets/packages/simpleicons/assets/icons/lock-circle.svg": "73179dde7bfae7bcbaf5bc6697c2720c",
"assets/packages/simpleicons/assets/icons/sort-reverse-alphabetically.svg": "1e39c8f3bad699de0832de148ec7872d",
"assets/packages/simpleicons/assets/icons/phonecall-receive.svg": "8fc9cbbf06020f42f929129fa49635ed",
"assets/packages/simpleicons/assets/icons/micro-sd-card.svg": "92a3588d16d116496fce4906232150ef",
"assets/packages/simpleicons/assets/icons/trend-down.svg": "a4ecac9b8530590936c01046014592b3",
"assets/packages/simpleicons/assets/icons/drop.svg": "d52208b9dcb8945259cd486840900a10",
"assets/packages/simpleicons/assets/icons/menu.svg": "b69e56d5767820f6cd4aef79cc98927b",
"assets/packages/simpleicons/assets/icons/desklamp.svg": "2579808be89e96038ab4e1350f593c14",
"assets/packages/simpleicons/assets/icons/globe-africa.svg": "c8c98bc8a28efe22973a50196a9f88b0",
"assets/packages/simpleicons/assets/icons/backspace.svg": "520d2c156b191a061f98bb54885c179a",
"assets/packages/simpleicons/assets/icons/arrow-left-small.svg": "cc6345b4ab18e754315b6b9b7243e153",
"assets/packages/simpleicons/assets/icons/xls.svg": "0a0df3151316ae8d69686ade1c868b86",
"assets/packages/simpleicons/assets/icons/password.svg": "96ee4f1cb01062d02e3ade0bfb825afc",
"assets/packages/simpleicons/assets/icons/id.svg": "6e90559b75f0e66e9c0895ead1e5f9f2",
"assets/packages/simpleicons/assets/icons/sort-down.svg": "263449544a9d6a3b7d1058ad5fdf495f",
"assets/packages/simpleicons/assets/icons/calculator.svg": "4f79a9826477f684697692ace9724a83",
"assets/packages/simpleicons/assets/icons/align-top.svg": "afc799d9862b0b8889de983379fe2060",
"assets/packages/simpleicons/assets/icons/mouse.svg": "f4f4be7c69cddbc42918e776b96e2d30",
"assets/packages/simpleicons/assets/icons/lan-cable.svg": "b503e1a01f2597efef2d8dde18ab6004",
"assets/packages/simpleicons/assets/icons/top-left.svg": "35db71e99941ce7c74048e07fa226e53",
"assets/packages/simpleicons/assets/icons/double-caret-left-circle.svg": "f258a825fe02bacedd2916259fb8a5af",
"assets/packages/simpleicons/assets/icons/cart-minus.svg": "b97cc39201a65ce66f809a5e85423b5c",
"assets/packages/simpleicons/assets/icons/building.svg": "3d68247d83083857c330fd896f05a4ee",
"assets/packages/simpleicons/assets/icons/history.svg": "07e4f5c975075db84ac11afa3fd3ce73",
"assets/packages/simpleicons/assets/icons/folder.svg": "dbff001a50dead80ff3055ea77649682",
"assets/packages/simpleicons/assets/icons/alarm.svg": "53e7481489f752f230ee983c16ec8fae",
"assets/packages/simpleicons/assets/icons/basket.svg": "e3587ffc753732857c0a8466916517fe",
"assets/packages/simpleicons/assets/icons/users.svg": "5d1d5d01db9fc9469acdab7602ad954d",
"assets/packages/simpleicons/assets/icons/nes.svg": "b494d2ce9454eb6b67ef90aa27db9035",
"assets/packages/simpleicons/assets/icons/png.svg": "7a3db78370fd81b0179d53d2c688c86c",
"assets/packages/simpleicons/assets/icons/fingerprint.svg": "b8c5d16d2ca27cba7866a939b1a4f382",
"assets/packages/simpleicons/assets/icons/left.svg": "c73a6f8d559edd3a323377865e955b3d",
"assets/packages/simpleicons/assets/icons/x-small.svg": "292d0630b9452fd8ed7aa25778cfd3c9",
"assets/packages/simpleicons/assets/icons/forward-small.svg": "1c2aa081e7ec0d78924eca89cfce6c43",
"assets/packages/simpleicons/assets/icons/minus.svg": "6c4fbf7144109f0a1639217fb986b1a5",
"assets/packages/simpleicons/assets/icons/documents.svg": "ae69e40f2118511275b5de585c42cbf5",
"assets/packages/simpleicons/assets/icons/bed-double.svg": "6c526ecc58b141966c3607d39bcecfc1",
"assets/packages/simpleicons/assets/icons/print.svg": "1a44c7881afd358d5001be807ce92aef",
"assets/packages/simpleicons/assets/icons/moon.svg": "963315bb6b91d7166d11c485b9684992",
"assets/packages/simpleicons/assets/icons/view-column.svg": "12945e62d9686877d0d3b7bbdd6268ed",
"assets/packages/simpleicons/assets/icons/exclamation.svg": "0e2cfee1e190e2d77fead3f3ee505480",
"assets/packages/simpleicons/assets/icons/left-small.svg": "e7129cda7d175cfe8a24a602b13d0179",
"assets/packages/simpleicons/assets/icons/expand-alt.svg": "5299b9a4cb309e6d357fcb8c066bff04",
"assets/packages/simpleicons/assets/icons/border-none.svg": "20d42151e99219997b300ecbe33f3db9",
"assets/packages/simpleicons/assets/icons/hd-screen.svg": "ccfe889162fca6b56201f4c02e5ff581",
"assets/packages/simpleicons/assets/icons/flip-horizontal.svg": "3a2b470902ff6c21e55e6b400dc97629",
"assets/packages/simpleicons/assets/icons/stamp.svg": "b0b9f9310c1f71ed7ce8d5dcbe9acbe8",
"assets/packages/simpleicons/assets/icons/vr-headset.svg": "b40f7788fac8e0cca07e642e784fd8a8",
"assets/packages/simpleicons/assets/icons/sort-up.svg": "d78e64aa4b56477675a85f958c54e00e",
"assets/packages/simpleicons/assets/icons/align-left.svg": "3b2c481454b3b4e235fc3d8e6d9a23ac",
"assets/packages/simpleicons/assets/icons/unlock-circle.svg": "68016f0d9d28b1520ca7400307857fb1",
"assets/packages/simpleicons/assets/icons/heart.svg": "f73cf2f34c3d39100baa3f4cd6074b97",
"assets/shaders/ink_sparkle.frag": "7dd199bdd5907c86acd33f0ff157080c",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/assets/images/widget_temp_mca.jpg": "ee2bd344257350c21f9d9c4fac2c37a5",
"assets/assets/images/mca-logo.png": "15bd29ed2c77624a7827e415ca7baaf8",
"assets/assets/images/illustration-1.png": "5ad69c7624875b76c84eebb06806ff46",
"assets/assets/images/illustration-2.png": "9f8a806312ecfe03313dabe5cf70a63f",
"assets/assets/fonts/NunitoSans-Light.ttf": "3b696c5e8c55321863bfbf03ef0c0ff3",
"assets/assets/fonts/NunitoSans-Regular.ttf": "4dac705158fb1ca226d583b3829f82a0",
"assets/assets/fonts/NunitoSans-Bold.ttf": "ac72fe0f27dd514aa3215e8424842062",
"assets/assets/fonts/NunitoSans-SemiBold.ttf": "2836528ad13278d88bcc509dc3f8102b",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
