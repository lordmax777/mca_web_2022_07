'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "db26fe7f9e11f695eb15e1762aeccb5e",
"assets/assets/fonts/NunitoSans-Bold.ttf": "ac72fe0f27dd514aa3215e8424842062",
"assets/assets/fonts/NunitoSans-Light.ttf": "3b696c5e8c55321863bfbf03ef0c0ff3",
"assets/assets/fonts/NunitoSans-Regular.ttf": "4dac705158fb1ca226d583b3829f82a0",
"assets/assets/fonts/NunitoSans-SemiBold.ttf": "2836528ad13278d88bcc509dc3f8102b",
"assets/assets/images/illustration-1.png": "5ad69c7624875b76c84eebb06806ff46",
"assets/assets/images/illustration-2.png": "9f8a806312ecfe03313dabe5cf70a63f",
"assets/assets/images/mca-logo.png": "15bd29ed2c77624a7827e415ca7baaf8",
"assets/assets/images/robot.svg": "2bd40d4488358c90eecc2baccc1e2a03",
"assets/assets/images/widget_temp_mca.jpg": "ee2bd344257350c21f9d9c4fac2c37a5",
"assets/FontManifest.json": "e76b3893245a91cd148e7093dd0282f0",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "4a530f8f272d7aad935b3c877ddac318",
"assets/packages/simpleicons/assets/icons/add-small.svg": "6dc1ca923b5b6a9c1ba58e7dbdcee798",
"assets/packages/simpleicons/assets/icons/add.svg": "51b782dc35448aa6e081d1b62099c1af",
"assets/packages/simpleicons/assets/icons/address-book.svg": "731d21086b1855f844218c0ce1eb4d28",
"assets/packages/simpleicons/assets/icons/adjust-horizontal-alt.svg": "3b5bb4ffcd8a0868db649ac9dafc3698",
"assets/packages/simpleicons/assets/icons/adjust-horizontal.svg": "3774ae7f6de9cf4213050c16731c63eb",
"assets/packages/simpleicons/assets/icons/adjust-vertical-alt.svg": "6e38269a8d6f69fa78b696daf8e19fec",
"assets/packages/simpleicons/assets/icons/adjust-vertical.svg": "6f9cf4f4727ac6833a01647221acb0e2",
"assets/packages/simpleicons/assets/icons/airplay.svg": "ccc0dba4e45e954e974055c4c8d31b27",
"assets/packages/simpleicons/assets/icons/airpods.svg": "ef0645f82a601ab0e2d4f4c12353a527",
"assets/packages/simpleicons/assets/icons/alarm.svg": "b347e7080f8b0f65406911b15b8f0b4c",
"assets/packages/simpleicons/assets/icons/align-bottom.svg": "794fbd10b4e8f1aa67b278c2d1b5f279",
"assets/packages/simpleicons/assets/icons/align-center-horizontal.svg": "9390196ae4795754856f396271200967",
"assets/packages/simpleicons/assets/icons/align-center-vertical.svg": "2ec7db0d4893cbcddcb36cecfded504e",
"assets/packages/simpleicons/assets/icons/align-left.svg": "9605b78d5b78222782e2f9250f67f13c",
"assets/packages/simpleicons/assets/icons/align-right.svg": "900715440d2ab64ad32b49c22bc26fbb",
"assets/packages/simpleicons/assets/icons/align-text-center.svg": "697fc4b5002b7dbd2408368d5a3d4b2b",
"assets/packages/simpleicons/assets/icons/align-text-justify.svg": "75d436f1e40951797ca0b131bee160d7",
"assets/packages/simpleicons/assets/icons/align-text-left.svg": "419e7c1961d3932e67c57b5bfed53570",
"assets/packages/simpleicons/assets/icons/align-text-right.svg": "775a2a7913c527d507d6d3d4b2912348",
"assets/packages/simpleicons/assets/icons/align-top.svg": "b2ddcfa026fe393e858bbdca1189bfb3",
"assets/packages/simpleicons/assets/icons/anchor.svg": "330905fc1bea072f769452ee4b515103",
"assets/packages/simpleicons/assets/icons/anti-clockwise.svg": "56ff16d2ddcea3daca4984ebe648011b",
"assets/packages/simpleicons/assets/icons/appointments.svg": "c7680407d1c13ba2c5c70b4e9ab9f7d7",
"assets/packages/simpleicons/assets/icons/archive.svg": "261832c821e0c8c8d4da19a8936ebcbd",
"assets/packages/simpleicons/assets/icons/area-chart-alt.svg": "5cf1551d3724469caacd7c7743fd177c",
"assets/packages/simpleicons/assets/icons/area-chart.svg": "3c7c05144857d68b70a02f9636720e4b",
"assets/packages/simpleicons/assets/icons/arrow-down-circle.svg": "7d1efe52acb2c03bf303680495f55dd3",
"assets/packages/simpleicons/assets/icons/arrow-down-small.svg": "dbd81cc598a8a791825ba0666e8bf1fb",
"assets/packages/simpleicons/assets/icons/arrow-down.svg": "365b75a7bfb90bbc62d6eec24d63415b",
"assets/packages/simpleicons/assets/icons/arrow-left-circle.svg": "c4f4048a878f12640bbc55389ffe9d79",
"assets/packages/simpleicons/assets/icons/arrow-left-small.svg": "500ebcf85abf68cbb19023d7072c0bfc",
"assets/packages/simpleicons/assets/icons/arrow-left.svg": "fd9e571ed4907e5a1314e52a3f9c3599",
"assets/packages/simpleicons/assets/icons/arrow-right-circle.svg": "8769a5a3d63293e26da969f5c961c214",
"assets/packages/simpleicons/assets/icons/arrow-right-small.svg": "b690e31134e8eae24f7fec709db6c36e",
"assets/packages/simpleicons/assets/icons/arrow-right.svg": "d436db2be87f34d240c912419c026dd6",
"assets/packages/simpleicons/assets/icons/arrow-up-circle.svg": "74cc93c869c597c4787eec88f59a34b9",
"assets/packages/simpleicons/assets/icons/arrow-up-small.svg": "d153662e71c6fc7363950dd45bf18733",
"assets/packages/simpleicons/assets/icons/arrow-up.svg": "e75083185b4c15f97c4425e7955ccef6",
"assets/packages/simpleicons/assets/icons/arrow.svg": "488fe44cf0e9b82fb7bbbed9e85fa261",
"assets/packages/simpleicons/assets/icons/artboard.svg": "b8b77fbeb010ba6daa33c614069d3d63",
"assets/packages/simpleicons/assets/icons/at.svg": "1062560399f545b4e2bee01a971b5723",
"assets/packages/simpleicons/assets/icons/attach.svg": "9564681b1886168db865627bfc521233",
"assets/packages/simpleicons/assets/icons/attachment.svg": "471ee547bb50eb212ba36cda4f2c5a10",
"assets/packages/simpleicons/assets/icons/audio-cable.svg": "ce3338c20ca66d16828907c5dc61d31f",
"assets/packages/simpleicons/assets/icons/audio-document.svg": "8dba157953f43adf7f13254af12cb9ec",
"assets/packages/simpleicons/assets/icons/backspace.svg": "bc9620511520df56d2e101ba482b0166",
"assets/packages/simpleicons/assets/icons/bag-alt.svg": "8f6361cf87cb0fa84193ae797224efe4",
"assets/packages/simpleicons/assets/icons/bag-minus.svg": "0831a42637632c2811fa8a58f07f58fd",
"assets/packages/simpleicons/assets/icons/bag-plus.svg": "d0dd0c299eef8fec335e7cd69f19bd76",
"assets/packages/simpleicons/assets/icons/bag.svg": "9341f775f27bf492c6777c2470a52807",
"assets/packages/simpleicons/assets/icons/bank.svg": "bfa2f0a6d7d761b46bedc7f496060674",
"assets/packages/simpleicons/assets/icons/bar-chart.svg": "42546b5ae6e9d2a7660e274084bdf50e",
"assets/packages/simpleicons/assets/icons/barcode.svg": "e24cef1221f3f51de1a540e9bef015ae",
"assets/packages/simpleicons/assets/icons/basket-minus.svg": "9b203b909d80a0cb3183b2ba45ac33c7",
"assets/packages/simpleicons/assets/icons/basket-plus.svg": "2300743f324fe77ef99a678ee0509225",
"assets/packages/simpleicons/assets/icons/basket.svg": "31c6ff84ea2f55ded887faa6157ffc3b",
"assets/packages/simpleicons/assets/icons/bath.svg": "720c5fe91985eb2696b9a0bbff2ecec6",
"assets/packages/simpleicons/assets/icons/battery-0.svg": "f5e33171fb7ff9407d9c250bf41c466e",
"assets/packages/simpleicons/assets/icons/battery-1.svg": "5c6b2d80eb1f19c68ba5b832c1f16028",
"assets/packages/simpleicons/assets/icons/battery-2.svg": "496631089f590b38b5da517f1390796e",
"assets/packages/simpleicons/assets/icons/battery-3.svg": "a2b3479a163b06e224c93eccc93bcb5a",
"assets/packages/simpleicons/assets/icons/battery-4.svg": "b3b87c5e2d632bacb0cf31bdab4bbf5c",
"assets/packages/simpleicons/assets/icons/battery-5.svg": "271d1125395aded33f8d2bc9650e6e11",
"assets/packages/simpleicons/assets/icons/battery-charge.svg": "a2aee378ee3aefe61c0a48300739e65d",
"assets/packages/simpleicons/assets/icons/bed-double.svg": "82a40196edbf7a2e20070ede09a52323",
"assets/packages/simpleicons/assets/icons/bed-single.svg": "7ba66681aca997c3233a2010500d2144",
"assets/packages/simpleicons/assets/icons/bell.svg": "2347c62466b357515649c853b94fc18f",
"assets/packages/simpleicons/assets/icons/bin.svg": "40b1e291d2bd8f3273a6f5156fd14227",
"assets/packages/simpleicons/assets/icons/bitcoin.svg": "18e60cc716deea2fccad86e2890a754b",
"assets/packages/simpleicons/assets/icons/bluetooth.svg": "b7a686bf0ff13c9a1a703da0b20aabaf",
"assets/packages/simpleicons/assets/icons/bold.svg": "968771c82169b4c9c0c689643eed0fc2",
"assets/packages/simpleicons/assets/icons/book.svg": "48ff0180b665c1225214b92cee81fe5a",
"assets/packages/simpleicons/assets/icons/bookmark.svg": "4dac087e0f1e6f321adff39f930a8241",
"assets/packages/simpleicons/assets/icons/border-all.svg": "3f9eb0a5a098e9d7699a1bd4b6b0ba77",
"assets/packages/simpleicons/assets/icons/border-bottom.svg": "946868bcdabf9259a232e4f0d38ab4cb",
"assets/packages/simpleicons/assets/icons/border-horizontal.svg": "bd87073023a3e9a285e885fb4536ff37",
"assets/packages/simpleicons/assets/icons/border-inner.svg": "bff62aa12b5705f935e9242b06149785",
"assets/packages/simpleicons/assets/icons/border-left.svg": "eb28d55dda15f40f1cd880106a34f43b",
"assets/packages/simpleicons/assets/icons/border-none.svg": "0a00b4a5689ca5e9257405dc3a160d94",
"assets/packages/simpleicons/assets/icons/border-outer.svg": "b3b942b3e20c8e4e84fd29eb7c5bd750",
"assets/packages/simpleicons/assets/icons/border-radius.svg": "fa456ac231c1dbfe58c1af016620e3ce",
"assets/packages/simpleicons/assets/icons/border-right.svg": "a8812bbe4806983ab305cf887bcd65f9",
"assets/packages/simpleicons/assets/icons/border-top.svg": "f50f8806479ad853dfdca4ee7dff44fe",
"assets/packages/simpleicons/assets/icons/border-vertical.svg": "9de98209f2279060b14dee8545740685",
"assets/packages/simpleicons/assets/icons/bottom-left.svg": "ffe7e178da9315c61bd0743795cef949",
"assets/packages/simpleicons/assets/icons/bottom-right.svg": "3df030cbfd6505acc7017a7f729071ce",
"assets/packages/simpleicons/assets/icons/box.svg": "bc551548289fa2b3cce35769fb2a5926",
"assets/packages/simpleicons/assets/icons/bracket.svg": "319c89d4a68f98a6eb50f3bf9bd6756a",
"assets/packages/simpleicons/assets/icons/briefcase-alt.svg": "c7bd12e3fb29aff6b2e7726138a19aa7",
"assets/packages/simpleicons/assets/icons/briefcase.svg": "6e8564e8ce139a832d74d4ecfe013e3e",
"assets/packages/simpleicons/assets/icons/brush.svg": "bf0cd83759dc6f928487ce01255becf2",
"assets/packages/simpleicons/assets/icons/building.svg": "84c966c760a74a6e26ab11dfa6be311a",
"assets/packages/simpleicons/assets/icons/bulb-off.svg": "ec3cf7d506222e87f472862c844633fc",
"assets/packages/simpleicons/assets/icons/bulb-on.svg": "7307283384b46dce136c57e8067d89c4",
"assets/packages/simpleicons/assets/icons/button.svg": "43e7dbc109761bef1a38382c2749a1a9",
"assets/packages/simpleicons/assets/icons/calculator.svg": "be4df93d786f8643f74eefa63e78f668",
"assets/packages/simpleicons/assets/icons/calendar-minus.svg": "3721c8f6eacb914053f1154e8290abf5",
"assets/packages/simpleicons/assets/icons/calendar-no-access.svg": "4c7d6e7a6bfafbb73451f51219be9722",
"assets/packages/simpleicons/assets/icons/calendar-plus.svg": "955870cd2685066259dacc954f8f86c4",
"assets/packages/simpleicons/assets/icons/calendar-tick.svg": "c65b5c6321801ce6d57e4870d72f54c8",
"assets/packages/simpleicons/assets/icons/calendar-x.svg": "b1c05264ee7f3d3a0143983d616b880c",
"assets/packages/simpleicons/assets/icons/calendar.svg": "878df04a153bcad7296cf8787461ab03",
"assets/packages/simpleicons/assets/icons/camera.svg": "8d770984b83678f5513abddf474cd72f",
"assets/packages/simpleicons/assets/icons/candle-chart.svg": "0a84cd6125760f8a3646abca8d5642c7",
"assets/packages/simpleicons/assets/icons/car.svg": "07bebfc4f29b64f348e736dc2119613d",
"assets/packages/simpleicons/assets/icons/caret-vertical-circle.svg": "31414d720e61323775b81433236aa786",
"assets/packages/simpleicons/assets/icons/caret-vertical-small.svg": "9bb05ce6fbe4262413560dfdde0b9fec",
"assets/packages/simpleicons/assets/icons/caret-vertical.svg": "19d3509e6a5b387b622e42ab1e7a4480",
"assets/packages/simpleicons/assets/icons/cart-minus.svg": "f01e672f9dcac55a34b10e899ac3bd2d",
"assets/packages/simpleicons/assets/icons/cart-plus.svg": "94fe716fbb28b93b4b9951b44a3fad47",
"assets/packages/simpleicons/assets/icons/cart.svg": "48f7fd464a02c29d3ee0972546aa882a",
"assets/packages/simpleicons/assets/icons/certificate.svg": "37093808e6ee35f9eb4bb5328219c132",
"assets/packages/simpleicons/assets/icons/chat-typing-alt.svg": "aea6cd15de36ca9406bcdfb81258984a",
"assets/packages/simpleicons/assets/icons/chat-typing.svg": "ed0760084a7959c47874e11074a1aa75",
"assets/packages/simpleicons/assets/icons/chat.svg": "676079e8afe60de3d810b05aa8cd4224",
"assets/packages/simpleicons/assets/icons/check.svg": "f20469bb4756a78be64e082a49bbed46",
"assets/packages/simpleicons/assets/icons/church.svg": "207d301aa79d8ccd329a898063432fca",
"assets/packages/simpleicons/assets/icons/circle.svg": "db161d3e0051dd1177179db1866b6564",
"assets/packages/simpleicons/assets/icons/clipboard-minus.svg": "3d2bf0cec71cdfa5efc6c6674b0df093",
"assets/packages/simpleicons/assets/icons/clipboard-no-access.svg": "00f085865e8c479a862a5460da10645a",
"assets/packages/simpleicons/assets/icons/clipboard-plus.svg": "17f49f6efbb6ba50737b86ee09856504",
"assets/packages/simpleicons/assets/icons/clipboard-tick.svg": "bbc9247919cc64ecec331e0ef2f393d4",
"assets/packages/simpleicons/assets/icons/clipboard-x.svg": "148c47d23f2fbc5696f501ac7f1a88f1",
"assets/packages/simpleicons/assets/icons/clipboard.svg": "2517f01bfc4df774a1476e0a2e72e088",
"assets/packages/simpleicons/assets/icons/clock.svg": "e1d457d87152afdc6fb288e4b219c2b2",
"assets/packages/simpleicons/assets/icons/clockwise.svg": "05bd027d97de49d6205f23093204ed22",
"assets/packages/simpleicons/assets/icons/code.svg": "f36540b084cd334bae9a886f1a933ae5",
"assets/packages/simpleicons/assets/icons/cog.svg": "6d2a0292d2f267e85d0c104979ada149",
"assets/packages/simpleicons/assets/icons/compass.svg": "0ecf1c8f00c013d617aac725fafdb3fe",
"assets/packages/simpleicons/assets/icons/computer.svg": "54babfed4b6e7caa9987d971a35d8cb6",
"assets/packages/simpleicons/assets/icons/contact.svg": "286912a7e6f90fe4f9fc1a410424284f",
"assets/packages/simpleicons/assets/icons/contract.svg": "3ec1b2ada20f5eaf89aabf260fbbeb27",
"assets/packages/simpleicons/assets/icons/cost-estimate.svg": "6099959e543e6ab29fb5473b14e2803d",
"assets/packages/simpleicons/assets/icons/credit-card.svg": "dfb410fb86fc993451b9be77afef8ee5",
"assets/packages/simpleicons/assets/icons/crop.svg": "c89f8d7f04848af0db34e57c08716db6",
"assets/packages/simpleicons/assets/icons/csv.svg": "db1218d255f2b7f823c79064aba66947",
"assets/packages/simpleicons/assets/icons/cup.svg": "fbecee0ddb6fc4563bc0021807d2720c",
"assets/packages/simpleicons/assets/icons/curved-connector.svg": "a432e52df32922909cea9cf1a4271099",
"assets/packages/simpleicons/assets/icons/denied.svg": "0a5af2038404e8a380836d728247e160",
"assets/packages/simpleicons/assets/icons/depth-chart.svg": "25675774eb9b07c3ea8917659f3a66cb",
"assets/packages/simpleicons/assets/icons/desklamp.svg": "b01ed2e7266db431ed5664940427626f",
"assets/packages/simpleicons/assets/icons/diamond.svg": "a2f2eb3f1f5bf340ff418eda30aadfff",
"assets/packages/simpleicons/assets/icons/direction.svg": "fd3b7ef52b6710974f7bd746de55b3e1",
"assets/packages/simpleicons/assets/icons/discount.svg": "8b12f802b5f3a9625c9a06f00be77c1e",
"assets/packages/simpleicons/assets/icons/distribute-horizontal.svg": "627e12e0015d6b721060a72508964af9",
"assets/packages/simpleicons/assets/icons/distribute-vertical.svg": "c405511f6a64d17985b6e02e30263b05",
"assets/packages/simpleicons/assets/icons/divider-line.svg": "944f3523c3f27cdbaeb52ccf042975b5",
"assets/packages/simpleicons/assets/icons/doc.svg": "1c3ab468a91227fb9929317cdd24047e",
"assets/packages/simpleicons/assets/icons/documents.svg": "f4ac455f2b941f1b44a89eb74eb5c2f4",
"assets/packages/simpleicons/assets/icons/dollar.svg": "c34976734576b5c53bc392a8644b77b8",
"assets/packages/simpleicons/assets/icons/donut-chart.svg": "3176f2afbd6f87b6a6debc62ac480f49",
"assets/packages/simpleicons/assets/icons/double-caret-down-circle.svg": "0c107149c68a08d8b4c789234ae8fe42",
"assets/packages/simpleicons/assets/icons/double-caret-down-small.svg": "d528a7229022d88a821c7828baae6626",
"assets/packages/simpleicons/assets/icons/double-caret-down.svg": "e1985c802129a6d3ca0ae2fb014f57e1",
"assets/packages/simpleicons/assets/icons/double-caret-left-circle.svg": "dd66c8b19ae769239fa6fd618342d2e0",
"assets/packages/simpleicons/assets/icons/double-caret-left-small.svg": "83dbdddb8488b963bb429c7797263d91",
"assets/packages/simpleicons/assets/icons/double-caret-left.svg": "d4f455942848fb97643bc1e0ef135bea",
"assets/packages/simpleicons/assets/icons/double-caret-right-circle.svg": "e2fa1443e49f1b5b7ddf556dfa32fbc2",
"assets/packages/simpleicons/assets/icons/double-caret-right-small.svg": "136c999de909174503106ea7d0b0f15a",
"assets/packages/simpleicons/assets/icons/double-caret-right.svg": "20c94a76097d71721c2076d348d1bd82",
"assets/packages/simpleicons/assets/icons/double-caret-up-circle.svg": "32647e9a8ffc143b23262925578de982",
"assets/packages/simpleicons/assets/icons/double-caret-up-small.svg": "2e98ddc96b7d6c82a079213c1c4ab73f",
"assets/packages/simpleicons/assets/icons/double-caret-up.svg": "7aa78aed912b0553c2f6e5f8522dabe1",
"assets/packages/simpleicons/assets/icons/down-circle.svg": "a97b73bbe65f2995e4a463eabb01c56a",
"assets/packages/simpleicons/assets/icons/down-small.svg": "7eaad4103ec9052256cd2f59634cad33",
"assets/packages/simpleicons/assets/icons/down.svg": "07f63c4e7bddf0c3a2455b1b5fcf006b",
"assets/packages/simpleicons/assets/icons/download.svg": "5dea063456854b05b1d04344d3aecb40",
"assets/packages/simpleicons/assets/icons/drag-horizontal.svg": "f13711314f64774f71d07ae68e3922fa",
"assets/packages/simpleicons/assets/icons/drag-vertical.svg": "585e29c37521d107ab67a84f5afc82ce",
"assets/packages/simpleicons/assets/icons/drag.svg": "fb5ae568742291de35a12a939291e3ae",
"assets/packages/simpleicons/assets/icons/drop.svg": "25ba9b79455b8d1ea96757e0796e1bfc",
"assets/packages/simpleicons/assets/icons/dropper.svg": "653c22d3f4e05cb53a9b3473e27707c3",
"assets/packages/simpleicons/assets/icons/edit-circle.svg": "eb3c768051b974d44539e0cecb61f0df",
"assets/packages/simpleicons/assets/icons/edit-small.svg": "906469af09da84aa7e07f0eee85950d3",
"assets/packages/simpleicons/assets/icons/edit.svg": "2e49b99cf8934ca193b20c0901d7e68e",
"assets/packages/simpleicons/assets/icons/elbow-connector.svg": "4def8d5ceb793e828b74e77bdb349ba8",
"assets/packages/simpleicons/assets/icons/envelope-open.svg": "f9736b94b9418e3722ab300c0b429bf6",
"assets/packages/simpleicons/assets/icons/envelope.svg": "553961c1eaf492cfc8dd5a05f47febff",
"assets/packages/simpleicons/assets/icons/eps.svg": "ce2472c50a0ff4b2c5c4d9c8a772f159",
"assets/packages/simpleicons/assets/icons/ethereum.svg": "54bdab94313aa95bf0fd6974c51448f1",
"assets/packages/simpleicons/assets/icons/euro.svg": "8ee22cdaaf8642798e111a9dc8ac0d5e",
"assets/packages/simpleicons/assets/icons/exclamation-circle.svg": "67c1f249878295786bcd2de54dab19c5",
"assets/packages/simpleicons/assets/icons/exclamation-small.svg": "394cc93cc847fea4178909b195450ad6",
"assets/packages/simpleicons/assets/icons/exclamation.svg": "bf3803c3ad201dc7720201b228a1f56e",
"assets/packages/simpleicons/assets/icons/expand-alt.svg": "7db0baba93fd4a7c9d51eb6cef71f855",
"assets/packages/simpleicons/assets/icons/expand.svg": "496769c10d012aec490dad88127fc0a8",
"assets/packages/simpleicons/assets/icons/eye-closed.svg": "d16f3d856eabeac37749c278f971996e",
"assets/packages/simpleicons/assets/icons/eye.svg": "824e72c99a79afd6bd04fcfcb726f4bc",
"assets/packages/simpleicons/assets/icons/face-id.svg": "193a859781e70a2fbc7f9819e06c69a5",
"assets/packages/simpleicons/assets/icons/file-minus.svg": "28af0de6e6a76ab596b58c443d3822d0",
"assets/packages/simpleicons/assets/icons/file-no-access.svg": "e8a55d8d60c9162ef2022b40226d8902",
"assets/packages/simpleicons/assets/icons/file-plus.svg": "8592e74c2b771c638a5ce74535f7dbf5",
"assets/packages/simpleicons/assets/icons/file-tick.svg": "e28a39f56be8d4aee82a1be8a9a9ec25",
"assets/packages/simpleicons/assets/icons/file-x.svg": "2ecc9cbbf21367be13a5dcfd0c5eaedc",
"assets/packages/simpleicons/assets/icons/file.svg": "536e51a0ab76c65cd120e61fb60962c7",
"assets/packages/simpleicons/assets/icons/filter.svg": "d8791d964f64ec35fce1d214507ce3e5",
"assets/packages/simpleicons/assets/icons/fingerprint.svg": "48ac61ccb5619153181d660175809aee",
"assets/packages/simpleicons/assets/icons/flag-alt.svg": "29bb858d7ffbb967b168d3f19b09f6dc",
"assets/packages/simpleicons/assets/icons/flag.svg": "3e3301ffca2d5a93c7244259fed0a96e",
"assets/packages/simpleicons/assets/icons/flip-horizontal.svg": "ee46fd278c6a527670aed0064c937f7a",
"assets/packages/simpleicons/assets/icons/flip-vertical.svg": "c6ac7c30e531980084e97fd982f00982",
"assets/packages/simpleicons/assets/icons/float-center.svg": "269ec17b593a2bfbb37fabf280c920fc",
"assets/packages/simpleicons/assets/icons/float-left.svg": "ece477d6a459b14e67e63cf9513e9d4b",
"assets/packages/simpleicons/assets/icons/float-right.svg": "27751b0a5d69520dbd906891e29d126a",
"assets/packages/simpleicons/assets/icons/floorplan.svg": "5ad9c6d07b851ecd2273c6b1f43954da",
"assets/packages/simpleicons/assets/icons/folder-minus.svg": "10bd2b0c68825d3100b2e1db2582ad32",
"assets/packages/simpleicons/assets/icons/folder-no-access.svg": "6b4e786321775daeac7d354061e4c67c",
"assets/packages/simpleicons/assets/icons/folder-plus.svg": "3754d4167f30583d662696ac4be54692",
"assets/packages/simpleicons/assets/icons/folder-tick.svg": "8082c110a7d98d8d1185cfbba29bfcb4",
"assets/packages/simpleicons/assets/icons/folder-x.svg": "05e06d00e9c329727b0203512e8cd331",
"assets/packages/simpleicons/assets/icons/folder.svg": "6abc8c0f4770c1f4daa5ac688d0a70d3",
"assets/packages/simpleicons/assets/icons/folders.svg": "4f4aaeb3b6546ce04535d0589c1a40cd",
"assets/packages/simpleicons/assets/icons/forward-circle.svg": "a2c359bc18c79f3b92a4850725c1b06d",
"assets/packages/simpleicons/assets/icons/forward-small.svg": "43e74323071e478e5d6685c1ab398669",
"assets/packages/simpleicons/assets/icons/forward.svg": "2d202d493b8da08cce511c009e0be697",
"assets/packages/simpleicons/assets/icons/frame.svg": "de462cd9aad46f9141a38aef83ce0d0b",
"assets/packages/simpleicons/assets/icons/game-controller-retro.svg": "6c67a30c366febc01effdb17be7b8a00",
"assets/packages/simpleicons/assets/icons/game-controller.svg": "571227df63973643d3506a29e119a5c8",
"assets/packages/simpleicons/assets/icons/gantt-chart.svg": "38dd356bf610c980af988ce682c7fce9",
"assets/packages/simpleicons/assets/icons/garage.svg": "9ede141cdcdf52bb47d3769a4d6eab3d",
"assets/packages/simpleicons/assets/icons/gba.svg": "bed33287b9202b427ba775ad147d85db",
"assets/packages/simpleicons/assets/icons/gbc.svg": "798baa8534ec7dbda406cfd97557a1f9",
"assets/packages/simpleicons/assets/icons/gif.svg": "0fc92580db8ac638935144bbaf0caee8",
"assets/packages/simpleicons/assets/icons/gift.svg": "b503bb965f1bcdeb7cf306d0a34a1e73",
"assets/packages/simpleicons/assets/icons/globe-africa.svg": "4333a221ed25f3cdc75e7bb9e3e802ef",
"assets/packages/simpleicons/assets/icons/globe-americas.svg": "b6c637463628b05ff9b3e4dff4474fef",
"assets/packages/simpleicons/assets/icons/globe.svg": "5a8ad6c5f36d4a83ef3381bf2e1fe4b3",
"assets/packages/simpleicons/assets/icons/google-ad.svg": "84f3b9aed789f235226cde13902306c1",
"assets/packages/simpleicons/assets/icons/google-streetview.svg": "7497c7b9ed6b3588e67aa17dcfc7501f",
"assets/packages/simpleicons/assets/icons/grid-layout.svg": "1a0f49bb56938c4fe365fd357cf77ba6",
"assets/packages/simpleicons/assets/icons/h360.svg": "eafda63df7b68c6259491df0c68ea121",
"assets/packages/simpleicons/assets/icons/hashtag.svg": "cc539a596fb687b6379cc03179e5c965",
"assets/packages/simpleicons/assets/icons/hd-screen.svg": "3a98f53bea3968c585df53bae58259cb",
"assets/packages/simpleicons/assets/icons/hdmi-cable.svg": "2af93dd5d9d8636adf2226b2cb0fb7bf",
"assets/packages/simpleicons/assets/icons/headphones.svg": "9bff126a84fa74a44eb5749193bc2ecc",
"assets/packages/simpleicons/assets/icons/headset.svg": "38324b908f4a2c93110cec7a9a02517b",
"assets/packages/simpleicons/assets/icons/heart-circle.svg": "1d1fdac185800bd086e01299e61406b3",
"assets/packages/simpleicons/assets/icons/heart-small.svg": "35f4819dea1460f3119be75c7fa163ec",
"assets/packages/simpleicons/assets/icons/heart.svg": "9bf377d9476d402ca18a0d3e4ba4458c",
"assets/packages/simpleicons/assets/icons/hexagon.svg": "f54b7546644247d7eaf9eef72d361498",
"assets/packages/simpleicons/assets/icons/history.svg": "55520f39df3bfa747dae986936722883",
"assets/packages/simpleicons/assets/icons/home-alt.svg": "e826265afad4a88c71bafe234573e831",
"assets/packages/simpleicons/assets/icons/home.svg": "e5eb2d074373349296be309f0a2825e8",
"assets/packages/simpleicons/assets/icons/hospital.svg": "0669b12bd13c80262c794f47466d999f",
"assets/packages/simpleicons/assets/icons/hourglass.svg": "978db2c515417cd94f1ef3ab1178e5d8",
"assets/packages/simpleicons/assets/icons/house.svg": "d0a62373c40d46b841c02f2dae17a486",
"assets/packages/simpleicons/assets/icons/id.svg": "220ab68d19379d0f8f2ea9bd466defa3",
"assets/packages/simpleicons/assets/icons/imac.svg": "b14d7c629b1c55e57b3cf4d63c57fd95",
"assets/packages/simpleicons/assets/icons/image-alt.svg": "b21bb59a45e57094986c3fd217a0061e",
"assets/packages/simpleicons/assets/icons/image-document.svg": "ac9d7dae649dc057ef1bf3937f7e999b",
"assets/packages/simpleicons/assets/icons/image.svg": "35fda10a9f97a3c24e0e8a4173732e60",
"assets/packages/simpleicons/assets/icons/in-ear-headphones.svg": "fd2b39b820fc3ee1981d52a32e9309fc",
"assets/packages/simpleicons/assets/icons/inbox.svg": "7f67fd3d3ba629baaf28355aae883c60",
"assets/packages/simpleicons/assets/icons/indent-decrease.svg": "085996da00cd2b61615aed0759b2c736",
"assets/packages/simpleicons/assets/icons/indent-increase.svg": "06e06252a6d9b6301b8bea11043203e5",
"assets/packages/simpleicons/assets/icons/info-circle.svg": "5b656f4ec2036da5cc7005c1a1fee6e8",
"assets/packages/simpleicons/assets/icons/info-small.svg": "16241e3bd079a70211ada0fc898654bd",
"assets/packages/simpleicons/assets/icons/info.svg": "21732e13905d9eb7ff8efed7611cc068",
"assets/packages/simpleicons/assets/icons/invoice.svg": "b3d6b1a243c58b6ff26d10ba57806c6a",
"assets/packages/simpleicons/assets/icons/italic.svg": "e786fc5e57da42a71c9c1a15bf2551c2",
"assets/packages/simpleicons/assets/icons/joystick.svg": "c0ec768a989001adcdbc127c028b0700",
"assets/packages/simpleicons/assets/icons/jpg.svg": "abfefcc552a3dcb4f16ef608249ab535",
"assets/packages/simpleicons/assets/icons/kanban.svg": "6756d2a9fd8196d17be1ca5f757b80ce",
"assets/packages/simpleicons/assets/icons/key.svg": "53e83b5c3924b4ff7c8f911b10abeae6",
"assets/packages/simpleicons/assets/icons/keyboard.svg": "861ed082fb4bf0c1d6e1d387f0660350",
"assets/packages/simpleicons/assets/icons/lan-cable.svg": "f747ebbe48b98a12eaa66cbaeb9ec231",
"assets/packages/simpleicons/assets/icons/laptop.svg": "330143ef6a96f198c6552dfe45ffe455",
"assets/packages/simpleicons/assets/icons/layers-difference.svg": "cf574902bc669820bfe763fe718fb2dc",
"assets/packages/simpleicons/assets/icons/layers-intersect.svg": "fb1b7ac346e37ec05259c7d6c4d33665",
"assets/packages/simpleicons/assets/icons/layers-subtract.svg": "632b43435f254613e7578590a5d51ba8",
"assets/packages/simpleicons/assets/icons/layers-union.svg": "3f8beda693ec61932ec6290b170efd69",
"assets/packages/simpleicons/assets/icons/layers.svg": "29441e3d328c80238c1b7bc24e94e358",
"assets/packages/simpleicons/assets/icons/left-circle.svg": "1270afe63684dd3a9be1fce53b0b311e",
"assets/packages/simpleicons/assets/icons/left-small.svg": "cf7e0370a194a3e9b5aa4a353fe56712",
"assets/packages/simpleicons/assets/icons/left.svg": "b23feb18f86e307010410f641998e8a2",
"assets/packages/simpleicons/assets/icons/lifebuoy.svg": "fa5e91dd9e4ee3b6132711847eaf22cf",
"assets/packages/simpleicons/assets/icons/lightning-cable.svg": "bfc34ac4ec677c632ed0b873823b861d",
"assets/packages/simpleicons/assets/icons/line.svg": "55d43ecd171b03ebcfed67d8e80e0307",
"assets/packages/simpleicons/assets/icons/link-remove.svg": "13d46cecb4a6fe19d25bb90550920f62",
"assets/packages/simpleicons/assets/icons/link.svg": "e0e235c8ca35abd64ae19a5a8f2b5590",
"assets/packages/simpleicons/assets/icons/list-layout.svg": "fb7f99c9a83bb64e51fbf92a298c8c61",
"assets/packages/simpleicons/assets/icons/list-ordered.svg": "b200686dfae7fc94278bf5cceae799f3",
"assets/packages/simpleicons/assets/icons/list-unordered.svg": "0c47a66f271dd4f0a32e7d09928cb6ad",
"assets/packages/simpleicons/assets/icons/litecoin.svg": "54ee5dbd2e9e522e6e70194b054c0b24",
"assets/packages/simpleicons/assets/icons/loader.svg": "e2d16a79c35d2c1d423cfd3103a6381e",
"assets/packages/simpleicons/assets/icons/location.svg": "5c1a0e83ce844fa70a08414cb3dff3b5",
"assets/packages/simpleicons/assets/icons/lock-circle.svg": "a03279253584d5ffe7b04347e662df2d",
"assets/packages/simpleicons/assets/icons/lock-small.svg": "5901338a9aeaed43b7e231fc0dfbc685",
"assets/packages/simpleicons/assets/icons/lock.svg": "1f4e84d01615f1ea1b6011338f9e493e",
"assets/packages/simpleicons/assets/icons/logout.svg": "425f6e4707564e0177182b8f7569ed0e",
"assets/packages/simpleicons/assets/icons/loop.svg": "0ab34a98067dec7bd908c106aeba488a",
"assets/packages/simpleicons/assets/icons/magsafe.svg": "04c412b5bfcf06fda76f0740d8c474fe",
"assets/packages/simpleicons/assets/icons/menu.svg": "4f12ea97a1bf3c9bf6265efe063681f8",
"assets/packages/simpleicons/assets/icons/message-minus.svg": "f52cfac127f75bca86ae7cafe6adcd33",
"assets/packages/simpleicons/assets/icons/message-no-access.svg": "d9070e29740c01291d5ea26bd2402171",
"assets/packages/simpleicons/assets/icons/message-plus.svg": "48730d2197322fc54b1d655a5cd073a3",
"assets/packages/simpleicons/assets/icons/message-text-alt.svg": "a0f479aad966836827f2421add7b6200",
"assets/packages/simpleicons/assets/icons/message-text.svg": "046580e8fa71351c4a1291b34b4648ee",
"assets/packages/simpleicons/assets/icons/message-tick.svg": "41f94d220b7b8cf1076c5eb1f47961cd",
"assets/packages/simpleicons/assets/icons/message-x.svg": "f82d64d531b1f9433b45865a8d5e0f81",
"assets/packages/simpleicons/assets/icons/message.svg": "0d039f1a455c6a0276c74a1bdf4caed9",
"assets/packages/simpleicons/assets/icons/micro-sd-card.svg": "f61ae5fffe1a0304a2c56381e330ab29",
"assets/packages/simpleicons/assets/icons/microphone.svg": "cea1a1102fa53311ba524401e97383d6",
"assets/packages/simpleicons/assets/icons/minimise-alt.svg": "7f68e137c583283827f5855bea119073",
"assets/packages/simpleicons/assets/icons/minimise.svg": "3b9b1d901677353b486d14a9d2186ec4",
"assets/packages/simpleicons/assets/icons/minus-circle.svg": "9f0db151fef008c440ea916518d6c2c5",
"assets/packages/simpleicons/assets/icons/minus-small.svg": "2247ca2b360951a900c122c12fd4db29",
"assets/packages/simpleicons/assets/icons/minus.svg": "6832d2d987b3a9a5112022e40e4de044",
"assets/packages/simpleicons/assets/icons/mobile.svg": "c1872587215b2c34cda39d2dd06b786c",
"assets/packages/simpleicons/assets/icons/money-stack.svg": "ee287dbb4408b20fcb1e1591f8790f06",
"assets/packages/simpleicons/assets/icons/money.svg": "1eddc7d4033fbd7cff2221d8b07e1831",
"assets/packages/simpleicons/assets/icons/moon.svg": "36a76f8faab430f7131c259e63ad8929",
"assets/packages/simpleicons/assets/icons/more-horizontal.svg": "b2abd7a50383193cd062d2d54efdf362",
"assets/packages/simpleicons/assets/icons/more-vertical.svg": "43ddd4c771ba38e829668dc06e9cd340",
"assets/packages/simpleicons/assets/icons/mouse.svg": "9756e89542444423859d5a634ff61441",
"assets/packages/simpleicons/assets/icons/mov.svg": "b2a853c85a3b0c4ad3186c9c2538ca2e",
"assets/packages/simpleicons/assets/icons/mp3.svg": "b35393da64717a626872c17f5357bf5f",
"assets/packages/simpleicons/assets/icons/mp4.svg": "f3a34d2297fe2460d7166be1cb862a27",
"assets/packages/simpleicons/assets/icons/ms-excel.svg": "c2abee4efbc7f3f8f77f351cd880c40a",
"assets/packages/simpleicons/assets/icons/ms-powerpoint.svg": "237e61d25d7320382b720b84ae73912f",
"assets/packages/simpleicons/assets/icons/ms-word.svg": "61b5147158f88baca90d6573c056a797",
"assets/packages/simpleicons/assets/icons/n64.svg": "77e6a08f82dd9e5280d46c59fd5ca8a5",
"assets/packages/simpleicons/assets/icons/nes.svg": "2f818dd34779a65c84e1ac681c5aeb11",
"assets/packages/simpleicons/assets/icons/next-circle.svg": "48d10bb3709bec1ffd35740b1384fc05",
"assets/packages/simpleicons/assets/icons/next-small.svg": "09bb0c3e22d3163b7a4d2aaff0116382",
"assets/packages/simpleicons/assets/icons/next.svg": "60e49b0ef3bf0263a377891654818ed3",
"assets/packages/simpleicons/assets/icons/ngc.svg": "99bda001f792315188a675245a592516",
"assets/packages/simpleicons/assets/icons/nintendo-switch.svg": "65045f89fed480b0a1947e3b4517f8e1",
"assets/packages/simpleicons/assets/icons/note.svg": "8e5fd95344b2f02d86f854ca2c1b9331",
"assets/packages/simpleicons/assets/icons/omega.svg": "0ea1504d50b91be7f4dd4ab512de02d9",
"assets/packages/simpleicons/assets/icons/otp.svg": "12373bbe0ac6a1aa146c9bd111d651d5",
"assets/packages/simpleicons/assets/icons/page-break.svg": "d12c46bdf6f8d229d3f65142bc940aa8",
"assets/packages/simpleicons/assets/icons/page-number.svg": "61fed2734eee39a51cea40a373b1a770",
"assets/packages/simpleicons/assets/icons/paintbrush.svg": "ae8649d88966585de1004e769e592a00",
"assets/packages/simpleicons/assets/icons/paintbucket.svg": "4c01440ce07ae6264b9555b567c52571",
"assets/packages/simpleicons/assets/icons/paragraph.svg": "f13e783d4b08c309382c2f64ca8a6e84",
"assets/packages/simpleicons/assets/icons/password.svg": "ace3088c93766fc1b0c34c6a1d8bd34f",
"assets/packages/simpleicons/assets/icons/pause-circle.svg": "956382bebf0a75908614f903753543ae",
"assets/packages/simpleicons/assets/icons/pause-small.svg": "21c1cd52b2c5e9374ef2bc30d3c1798e",
"assets/packages/simpleicons/assets/icons/pause.svg": "3688c2553bf8600336eed0d3f0ed252d",
"assets/packages/simpleicons/assets/icons/paw.svg": "0d61e6ddd359d1e2575c88d8a71a28d5",
"assets/packages/simpleicons/assets/icons/paws.svg": "fe35ef7ee1b84f5fb0a4c09de2f67c40",
"assets/packages/simpleicons/assets/icons/paypal.svg": "fc549207ad833b398ea6a39c9df28af7",
"assets/packages/simpleicons/assets/icons/pdf.svg": "06d84547509fd0b0b6953aa80f5e146a",
"assets/packages/simpleicons/assets/icons/pen.svg": "9aeceaf518db320320c8512148ff65d2",
"assets/packages/simpleicons/assets/icons/percent.svg": "a4d566b678c19118212c79f51bda18a2",
"assets/packages/simpleicons/assets/icons/phone.svg": "098236f20f59b8f8be5cfa6bb070b577",
"assets/packages/simpleicons/assets/icons/phonecall-blocked.svg": "659bce76fbc6d4c42bd23ac09c2ad83e",
"assets/packages/simpleicons/assets/icons/phonecall-receive.svg": "75e8ee7ca2656289a258b9dee64e80b3",
"assets/packages/simpleicons/assets/icons/phonecall.svg": "6ce36e10373d7f4a658122ba33aadaa9",
"assets/packages/simpleicons/assets/icons/pie-chart-alt.svg": "c925ce71ba8c87ed9c4c4d80c73eda92",
"assets/packages/simpleicons/assets/icons/pie-chart.svg": "4c0b49ed31965bdbe18ce0cc06da4289",
"assets/packages/simpleicons/assets/icons/pin-alt.svg": "80c9bb073639837a0ecff70d7078772a",
"assets/packages/simpleicons/assets/icons/pin.svg": "64feb1cc5c2b6fd84e23d0c68497bfb1",
"assets/packages/simpleicons/assets/icons/plant.svg": "f4b3f740755c9c457aa3314bd2847ecf",
"assets/packages/simpleicons/assets/icons/play-circle.svg": "85c3b71835a5c6f4bb5cfda55dd0be2f",
"assets/packages/simpleicons/assets/icons/play-small.svg": "f675c4279f861c86afd8992a5a648c8b",
"assets/packages/simpleicons/assets/icons/play.svg": "f8f08d0f5eec4a04c0b169712f91b0e1",
"assets/packages/simpleicons/assets/icons/plug.svg": "ce0cf9a1f1dcfa9b523a92b75824c100",
"assets/packages/simpleicons/assets/icons/plus-circle.svg": "a18b0b4cf3e0c2b19543cd2a39c19bc4",
"assets/packages/simpleicons/assets/icons/png.svg": "57462b1381927579885b16a8a4dfdd2a",
"assets/packages/simpleicons/assets/icons/pool.svg": "705484921137042ec7708bef9aaba53f",
"assets/packages/simpleicons/assets/icons/pound.svg": "932a9074caff477c32fb48b8f0f23ec9",
"assets/packages/simpleicons/assets/icons/power.svg": "c8370c1416d38331df2c67f8c95f84b0",
"assets/packages/simpleicons/assets/icons/ppt.svg": "97ced67b1271c194b8acf905fde7a0f7",
"assets/packages/simpleicons/assets/icons/print.svg": "152688ac007c2beb15b6797f37b3b217",
"assets/packages/simpleicons/assets/icons/qr-code.svg": "5daee74023101f308be8dfac8849883a",
"assets/packages/simpleicons/assets/icons/question-circle.svg": "f620878e1b010b8779d77b07cd5b626a",
"assets/packages/simpleicons/assets/icons/question-small.svg": "d98f8a24c90bf0e16c654dc06bac99a3",
"assets/packages/simpleicons/assets/icons/question.svg": "1a748537161d2e4bbc31727345e3e11c",
"assets/packages/simpleicons/assets/icons/quote.svg": "c9d9eb4c78a494af2398b80eed786c3f",
"assets/packages/simpleicons/assets/icons/rand.svg": "b4aeb2ed4a4d37fad4730671191b4a80",
"assets/packages/simpleicons/assets/icons/receipt.svg": "a6fb2b7aa2fd6157c8132f1129623ae0",
"assets/packages/simpleicons/assets/icons/refresh-alt.svg": "07a849fdf2a79ad9641056242eba3210",
"assets/packages/simpleicons/assets/icons/refresh.svg": "639fa411572fb183f97dd36dd1bf9fa5",
"assets/packages/simpleicons/assets/icons/rewind-circle.svg": "dcd874317acf32d5038d9adfab7adab7",
"assets/packages/simpleicons/assets/icons/rewind-small.svg": "801525ee331e037d32a71b5eaed548bb",
"assets/packages/simpleicons/assets/icons/rewind.svg": "2c7d66a158c0d2ace1d3bfefb01ca277",
"assets/packages/simpleicons/assets/icons/right-circle.svg": "ddb011698d509d95a8fbe30952e6a2d8",
"assets/packages/simpleicons/assets/icons/right-small.svg": "dda4d1660c897e5424f320540e860899",
"assets/packages/simpleicons/assets/icons/right.svg": "f9337462e30b002bc8a30e7aa62d7c1d",
"assets/packages/simpleicons/assets/icons/ripple.svg": "fa539e79e2203df116f883cd850cdad3",
"assets/packages/simpleicons/assets/icons/roller.svg": "66249685431f66574e351cb872ee6d84",
"assets/packages/simpleicons/assets/icons/router.svg": "c2e56083e1ab73587389938ba4a6bb9d",
"assets/packages/simpleicons/assets/icons/rupee.svg": "1d1eb05d079223000911c45976846f8c",
"assets/packages/simpleicons/assets/icons/safe.svg": "c8d2d72a9cb323f05e545ac0dae0a877",
"assets/packages/simpleicons/assets/icons/save.svg": "9b6296ee2f99a05729883d24d2a3b010",
"assets/packages/simpleicons/assets/icons/scan.svg": "9854179d1fb8ef8dc1f82b203ad5cb60",
"assets/packages/simpleicons/assets/icons/school.svg": "1b41b87bb9e5492b2c00db6f53757215",
"assets/packages/simpleicons/assets/icons/screen-alt-2.svg": "3bc2076ca9f327ba1cd65a71a888de33",
"assets/packages/simpleicons/assets/icons/screen-alt.svg": "4d2dcdc868013b6e28b791ff46a8aab7",
"assets/packages/simpleicons/assets/icons/screen.svg": "f759d1d85bf6e0bf819a982b82f913f3",
"assets/packages/simpleicons/assets/icons/scribble.svg": "6602aff9737ed78a4c4a94cc9788cf35",
"assets/packages/simpleicons/assets/icons/sd-card.svg": "95b4fd988867ed137c4fdf95e96cc694",
"assets/packages/simpleicons/assets/icons/search-circle.svg": "336b5e279387320f3db1883ccf9b478d",
"assets/packages/simpleicons/assets/icons/search-property.svg": "b3b4add944e7f728ff7848b7bbf1f07a",
"assets/packages/simpleicons/assets/icons/search-small.svg": "1ec26e3458eac4c8f99d958e2a0096df",
"assets/packages/simpleicons/assets/icons/search.svg": "98b8803c2bc0eee4e2068e6ae90f7f69",
"assets/packages/simpleicons/assets/icons/section-add.svg": "d3470add2897886ee01aaf334d79808b",
"assets/packages/simpleicons/assets/icons/section-remove.svg": "350a22486fd7f27ce3727976c4d23155",
"assets/packages/simpleicons/assets/icons/send-down.svg": "11307b8c290e3a886fe2a0e906b99921",
"assets/packages/simpleicons/assets/icons/send-left.svg": "9ea4cfd01d22f4443f4d211bb35330d6",
"assets/packages/simpleicons/assets/icons/send-right.svg": "544243f26c0fb93aac4cfb9136a50eb1",
"assets/packages/simpleicons/assets/icons/send-up.svg": "a81305f93c21d751c5e6820c19e3457f",
"assets/packages/simpleicons/assets/icons/send.svg": "042df8166fe95f5769b3cfba97fa0ccb",
"assets/packages/simpleicons/assets/icons/share.svg": "fa834b8b5b155b06ac3f2c3e6674ae8d",
"assets/packages/simpleicons/assets/icons/shield-tick.svg": "f25025447a248176704c1b504064a577",
"assets/packages/simpleicons/assets/icons/shield-x.svg": "ebee445bbe8bc5e45fe1a9a2a8f1546c",
"assets/packages/simpleicons/assets/icons/shield.svg": "17856f01641e303b3079c456b66c3c67",
"assets/packages/simpleicons/assets/icons/shop.svg": "cc38f13517ec992c1e56c07163935678",
"assets/packages/simpleicons/assets/icons/sign.svg": "8eb53497a80b9d2bbb9acd6bf7b62f64",
"assets/packages/simpleicons/assets/icons/signin.svg": "7a8caf8c777e11d59cfcffe35e7ccacc",
"assets/packages/simpleicons/assets/icons/sim.svg": "5f84660ced139baad0d9abcf69d3f7bf",
"assets/packages/simpleicons/assets/icons/snes.svg": "c04a23e40aab6aa1136e30e10e9e5a7d",
"assets/packages/simpleicons/assets/icons/sort-alphabetically.svg": "0cd744e120cb89ae2e6fb908f76c75d5",
"assets/packages/simpleicons/assets/icons/sort-down.svg": "1b85c4e6eebc083f107e392cab144a0a",
"assets/packages/simpleicons/assets/icons/sort-high-to-low.svg": "18621ce64f0164f410ed961e1e2faec3",
"assets/packages/simpleicons/assets/icons/sort-low-to-high.svg": "12c9e11abc066ed3517e4c15cdac8407",
"assets/packages/simpleicons/assets/icons/sort-reverse-alphabetically.svg": "80c935156a4d2e4f8310bba622c6306b",
"assets/packages/simpleicons/assets/icons/sort-up.svg": "0ea7f7532f4078e843a2c4c881733f37",
"assets/packages/simpleicons/assets/icons/sound-off.svg": "e1b261a25834a765ebf9ac08465f1461",
"assets/packages/simpleicons/assets/icons/sound-on.svg": "63c8f2debad9a98aa4367b606c794eaa",
"assets/packages/simpleicons/assets/icons/spreadsheet.svg": "7ec7f80123cf72bb1ce52057d8f1e054",
"assets/packages/simpleicons/assets/icons/square.svg": "e154103362d00987f18d84a3258059ce",
"assets/packages/simpleicons/assets/icons/stamp.svg": "02bc8e2ed78749456a4e4bb96c7f49be",
"assets/packages/simpleicons/assets/icons/star-circle.svg": "e1590da9ee9411b0e5af2fc6735a03a7",
"assets/packages/simpleicons/assets/icons/star-small.svg": "384b3a8b77ef44db68830c87099e6a81",
"assets/packages/simpleicons/assets/icons/star.svg": "ec43fd47beaeb215e2c9f136ed485865",
"assets/packages/simpleicons/assets/icons/stop-circle.svg": "e5cba68265bda1026e5461198e2247b8",
"assets/packages/simpleicons/assets/icons/stop-small.svg": "4b66b35543a0acabb999ed6c81940a5b",
"assets/packages/simpleicons/assets/icons/stop.svg": "bdd968a435c671de0a1c09de6011e323",
"assets/packages/simpleicons/assets/icons/stopwatch.svg": "b8eb06e1b9a077f28c7d080d724e1161",
"assets/packages/simpleicons/assets/icons/strikethrough.svg": "10f48d75b3c3f3fe0901a6fa89f2946c",
"assets/packages/simpleicons/assets/icons/subscript.svg": "d0b0be20ad5e9df968921f709d5830b9",
"assets/packages/simpleicons/assets/icons/sun.svg": "7f001a46c761c426b348b487b613e1be",
"assets/packages/simpleicons/assets/icons/superscript.svg": "48e625fd31d192e6d87b82e534e49024",
"assets/packages/simpleicons/assets/icons/svg.svg": "b6131a43ec7d81da16a9679573e8567f",
"assets/packages/simpleicons/assets/icons/table.svg": "df9e3d2ab83ad7ee3bf593cb8c8d494c",
"assets/packages/simpleicons/assets/icons/tablet.svg": "d7310596a8424004033adc855b866c15",
"assets/packages/simpleicons/assets/icons/tag.svg": "2e475daddfdb302442ff874b0c1e0fe9",
"assets/packages/simpleicons/assets/icons/target.svg": "725bffb3c67c7ba34caf580e48391cf0",
"assets/packages/simpleicons/assets/icons/text-document-alt.svg": "9e41c279931e0326e86eafba3f602471",
"assets/packages/simpleicons/assets/icons/text-document.svg": "4e70f37c62e45daeaf221db6be2c5c43",
"assets/packages/simpleicons/assets/icons/text.svg": "892fd8be472f2aa263e5c91d096bd64b",
"assets/packages/simpleicons/assets/icons/thumb-down.svg": "13927d0c0816873656fd765196fa14f2",
"assets/packages/simpleicons/assets/icons/thumb-up.svg": "e4084a7f883908e4432a997acd432fad",
"assets/packages/simpleicons/assets/icons/thumbtack.svg": "acbaacdbce2a9492e3d932f3932b00be",
"assets/packages/simpleicons/assets/icons/tick-circle.svg": "c6f074730c58dcd008355828b537ff34",
"assets/packages/simpleicons/assets/icons/tick-small.svg": "3b29858ede08e2f3b77c2bdfd5dc9e0a",
"assets/packages/simpleicons/assets/icons/tick.svg": "9c3a5e4a50f3a1e52efa3861a84b9dec",
"assets/packages/simpleicons/assets/icons/toggle.svg": "65433036fe31d1e73436f49cd0edb160",
"assets/packages/simpleicons/assets/icons/top-left.svg": "9510d11a75b20d1d5ec08a3ad99f1dc7",
"assets/packages/simpleicons/assets/icons/top-right.svg": "20f5e69420abd05ac0d41425c2a23317",
"assets/packages/simpleicons/assets/icons/trend-down.svg": "55d9acf5a986eb4debc144496e48067d",
"assets/packages/simpleicons/assets/icons/trend-up.svg": "a5c206b8caeba49dd7a863c0a0e8d485",
"assets/packages/simpleicons/assets/icons/triangle.svg": "acf71ba661d516b4fa3805c4806f3557",
"assets/packages/simpleicons/assets/icons/trophy.svg": "f7e4c2ffc33310094ddf0609e3c4396c",
"assets/packages/simpleicons/assets/icons/tv.svg": "7963942bd9d157f87b57a4865d25fdce",
"assets/packages/simpleicons/assets/icons/underline.svg": "099d1fbffe77ddb19a8fad525e34f473",
"assets/packages/simpleicons/assets/icons/unlock-circle.svg": "ba37c0ad3afacc112cd3be4f26aed25c",
"assets/packages/simpleicons/assets/icons/unlock-small.svg": "48bef284167bcba211c2474712741ffa",
"assets/packages/simpleicons/assets/icons/unlock.svg": "eb5a92c6eff725d6bf754ff55ebac701",
"assets/packages/simpleicons/assets/icons/up-circle.svg": "80aa927bcb751ede109b67a77babb47a",
"assets/packages/simpleicons/assets/icons/up-small.svg": "0383c4b8bc5f5c048e65c6723146c159",
"assets/packages/simpleicons/assets/icons/up.svg": "502dd99f0bc1642a18900a19928502cd",
"assets/packages/simpleicons/assets/icons/upload.svg": "e272551899833f1982f281dd0694e0f6",
"assets/packages/simpleicons/assets/icons/usb-cable.svg": "37f2b996644e2712a21fa038ee2b258e",
"assets/packages/simpleicons/assets/icons/user-circle.svg": "7da903fda8501604efe55874fa1139b9",
"assets/packages/simpleicons/assets/icons/user-minus.svg": "194bddaf2345e758dc823b1ae57f8a67",
"assets/packages/simpleicons/assets/icons/user-plus.svg": "36e4dce0c35b1b50225c885dba424fa2",
"assets/packages/simpleicons/assets/icons/user-square.svg": "5df896a25d6ffbde56018e73b24562c8",
"assets/packages/simpleicons/assets/icons/user.svg": "891159e14baf848f6cd488607031a8f6",
"assets/packages/simpleicons/assets/icons/users.svg": "57c728c45f859df53d2a23c9360aa4de",
"assets/packages/simpleicons/assets/icons/vector-document.svg": "35dbb5e345608e4b38dbcfcff983750a",
"assets/packages/simpleicons/assets/icons/venn-diagram.svg": "e152dc927c0e0b23aaa7d9e7797c3121",
"assets/packages/simpleicons/assets/icons/view-column.svg": "7a9b2be406a85df369e01b81488280bd",
"assets/packages/simpleicons/assets/icons/view-grid.svg": "df87cf30dab60b9b558ad61abcdae00a",
"assets/packages/simpleicons/assets/icons/volume-1.svg": "bf23afc865217aeb841e5864a28cea0b",
"assets/packages/simpleicons/assets/icons/volume-2.svg": "4cc54b10e6db2584131d7cbebe16b0d8",
"assets/packages/simpleicons/assets/icons/volume-3.svg": "49a4eb76245e8187ef742b48b83f6e0b",
"assets/packages/simpleicons/assets/icons/vr-headset.svg": "c10332757095eb41c671b22f155a0ccc",
"assets/packages/simpleicons/assets/icons/wallet-alt.svg": "cc952caa82b1c17aef5563e901d86534",
"assets/packages/simpleicons/assets/icons/wallet.svg": "6a74ab734b05d581fe9729e23c4ae4f2",
"assets/packages/simpleicons/assets/icons/wan.svg": "e2136fca098fbabd80375ac35b8e5d4e",
"assets/packages/simpleicons/assets/icons/wand.svg": "2df6cef5ac90f4290a8274fdb2a09b2a",
"assets/packages/simpleicons/assets/icons/watch.svg": "6bb9d013302fef2c3a5c5ebcfc30e37c",
"assets/packages/simpleicons/assets/icons/wifi-full.svg": "6e1a804dacc57f53c3e95b4ca31cec4b",
"assets/packages/simpleicons/assets/icons/wifi-low.svg": "6c49d830681475443a64f9f4a4e0ed5c",
"assets/packages/simpleicons/assets/icons/wifi-none.svg": "f53aeb16e8cb90219e6a9c384013fdd5",
"assets/packages/simpleicons/assets/icons/x-circle.svg": "6fd6af66f5990f0fb0eb322a7757337f",
"assets/packages/simpleicons/assets/icons/x-small.svg": "f8ce0c0e80639fd66b88e5cb55642b4e",
"assets/packages/simpleicons/assets/icons/x.svg": "346b04264e14dcf97ed39ef803c4189b",
"assets/packages/simpleicons/assets/icons/xls.svg": "77fdbe9024d682dfb6e4061c3dd97103",
"assets/packages/simpleicons/assets/icons/yen.svg": "83b6a2b1a7640591ff6b8d77c78ca8fb",
"assets/packages/simpleicons/assets/icons/zip.svg": "d53fed4d68476ae9cf5d6ea52d2020fd",
"assets/packages/simpleicons/assets/icons/zoom-in.svg": "81063db3f75934ef371b48ac8c2b28ea",
"assets/packages/simpleicons/assets/icons/zoom-out.svg": "00720bc89309afbabddeee95cacfb7a5",
"assets/packages/timezone/data/2020a.tzf": "84285f1f81b999f1de349a723574b3e5",
"assets/shaders/ink_sparkle.frag": "06c291077e90cfcaad24d1c17056f53d",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "03e94416d18be33d3c440e73b6d8adf0",
"/": "03e94416d18be33d3c440e73b6d8adf0",
"main.dart.js": "dec68ac374412e2b9bc0a007741e56e2",
"manifest.json": "ae6b44f605b9c04a6e90180a8ad956b0",
"styles.css": "37387c589b05828439fb1417dc7a02bb",
"version.json": "7fab6da096fd3c24cb62b70511fa7519"
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
