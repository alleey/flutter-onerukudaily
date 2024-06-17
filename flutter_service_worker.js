'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "ace2314363fd42ba580509395f930352",
"icons/Icon-maskable-512.png": "e96179581bae88be10c81e4f2366785a",
"icons/Icon-512.png": "e96179581bae88be10c81e4f2366785a",
"icons/Icon-192.png": "ace2314363fd42ba580509395f930352",
"manifest.json": "5b25d269a32bf7221367f26b0fd8c48b",
"favicon.png": "82b30cc589d40efea646d941da76a9e3",
"flutter_bootstrap.js": "d143c5c4e7836ae994d9dc2397bf69d4",
"version.json": "8f92352e300754a66b274ab285d3881c",
"index.html": "0d7f2e5b86f4635f2f982d23268d0e4b",
"/": "0d7f2e5b86f4635f2f982d23268d0e4b",
"main.dart.js": "2902ccb16b1224807e3b3bc7b412e217",
"assets/AssetManifest.json": "4bb933c35bfa1e500138ea2bb160bc69",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "39006bdd161fb53b3677de49178ade5a",
"assets/fonts/MaterialIcons-Regular.otf": "c0bb75221367dc579857550897c3a169",
"assets/assets/data/q-simple/r471.json": "c892faf60ddf8d7bc7c5943d05d00b33",
"assets/assets/data/q-simple/r155.json": "c7368fd13ade46d25381724abf0ff372",
"assets/assets/data/q-simple/r40.json": "ba050bfa4dbf88fac601ef263048274a",
"assets/assets/data/q-simple/r369.json": "dcc582f24874e2ccc709562243cfb297",
"assets/assets/data/q-simple/r12.json": "8aae7538c4d1f82612503ec6069c909a",
"assets/assets/data/q-simple/r408.json": "d45fbef9b1e8e5c3b41209d9c2582a47",
"assets/assets/data/q-simple/r343.json": "f51225ef1d2c2aaef5becbcd4e0f9782",
"assets/assets/data/q-simple/r225.json": "c514189ff3be08a5e2bd4fa779ade585",
"assets/assets/data/q-simple/r415.json": "18fd48355e12b84340a5df6687361266",
"assets/assets/data/q-simple/r147.json": "51e2760c8a0c33c4c9496e1485106b8a",
"assets/assets/data/q-simple/r46.json": "8f07602b14bacc787ac77129184f8952",
"assets/assets/data/q-simple/r13.json": "f396562044466a201a017d38648bb9d3",
"assets/assets/data/q-simple/r85.json": "41f03465ecc92bb7ee696bba44000f2e",
"assets/assets/data/q-simple/r493.json": "0a0366ce3124115249f77f1f17cb2437",
"assets/assets/data/q-simple/r60.json": "41a6d4d8d44e0594a499cdb3770ccf54",
"assets/assets/data/q-simple/r279.json": "acc388e8da14164050d47df9c1b1c04d",
"assets/assets/data/q-simple/r216.json": "8f1624fc4fd99866e2e047c0892a6118",
"assets/assets/data/q-simple/r167.json": "2f9659d5c01177b72bf636d64fab7bdb",
"assets/assets/data/q-simple/r248.json": "b9d120d9be0abcbf6cdedaf125d7cb6c",
"assets/assets/data/q-simple/r399.json": "6f5a27d0f8afa06261e819af9ee8289c",
"assets/assets/data/q-simple/r342.json": "92b7c92677a9854d560b3b1538022323",
"assets/assets/data/q-simple/r406.json": "42792b9201bf0682cb419cce61cc767f",
"assets/assets/data/q-simple/r357.json": "95d3fb9cfd4001be89a5334e8281c248",
"assets/assets/data/q-simple/r123.json": "bb5c5e9f51f19c73774fe98f1d3601ce",
"assets/assets/data/q-simple/r431.json": "e3dc638309a1524d764fdf774c9be60f",
"assets/assets/data/q-simple/r218.json": "cf52ef7153cb7583221e9683ebcf1392",
"assets/assets/data/q-simple/r456.json": "60c69a56343885a54269de41d40b723f",
"assets/assets/data/q-simple/r440.json": "3878605a46252c2730c6f597a30f784d",
"assets/assets/data/q-simple/r477.json": "e6fa04b73541e4bdef79eb29c20826fc",
"assets/assets/data/q-simple/r207.json": "1c8addfbe59abf10cd4ea04bca3502df",
"assets/assets/data/q-simple/r111.json": "fdb4cfdc7234da4984f95adad06f8e74",
"assets/assets/data/q-simple/r262.json": "edfbdaac0a27efba0697928e5aedcdd3",
"assets/assets/data/q-simple/r73.json": "bc8ddadf54bcdc17da374f34ccf29fac",
"assets/assets/data/q-simple/r556.json": "7f60712b135d72ac9ff3e4021aff14f2",
"assets/assets/data/q-simple/r334.json": "44066422bb9db9cdf51c19fc07f7d932",
"assets/assets/data/q-simple/r272.json": "1db1b4044224212c94b19a6dfd4c65ca",
"assets/assets/data/q-simple/r10.json": "583372389cc3215d98ab06c8c6512369",
"assets/assets/data/q-simple/r136.json": "0d6944a9a916b07d7349ed971ec4002a",
"assets/assets/data/q-simple/r41.json": "f0d240c8322b9ae7c95ace63ff3f6dd2",
"assets/assets/data/q-simple/r166.json": "523f2d0580a5c86d12c136ee82d33f56",
"assets/assets/data/q-simple/r411.json": "994736508885f83b1764268f468a4af8",
"assets/assets/data/q-simple/r132.json": "55ba7324dcf3b35632bac6821cbf1ae2",
"assets/assets/data/q-simple/r204.json": "ba36c540387831c8e500b4c0a6ecfa16",
"assets/assets/data/q-simple/r509.json": "9cca6b5eddafd7b37b9084afbe1f677f",
"assets/assets/data/q-simple/r474.json": "cd03bef6f0f52cefc169d8d6672ce204",
"assets/assets/data/q-simple/r38.json": "dbb04762b074419906bca98f2d542212",
"assets/assets/data/q-simple/r234.json": "ca0f217e4edea806e251c125578e5ef6",
"assets/assets/data/q-simple/r25.json": "3d24aa683abae29e4fa6f66fd591ee06",
"assets/assets/data/q-simple/r517.json": "c6d2389d295c7cfc00d3ba9568830607",
"assets/assets/data/q-simple/r63.json": "7b96fa3124e46583455189725e6af253",
"assets/assets/data/q-simple/r51.json": "ced7a6f79d32807dbc3602c9e94815c2",
"assets/assets/data/q-simple/r467.json": "13452c452f5220827ee8af4a5f34cb45",
"assets/assets/data/q-simple/r421.json": "612528bc08ea29a937b66bb08ed56ad3",
"assets/assets/data/q-simple/r246.json": "29f48b59818fe52a49335b1e3b367a9c",
"assets/assets/data/q-simple/r426.json": "d56b8694fc5ebfd1873d694465647b55",
"assets/assets/data/q-simple/r466.json": "dfd85439b341a8981f6e37b642ade73d",
"assets/assets/data/q-simple/r374.json": "147440f34e8ebe0516081a7cdb33c91d",
"assets/assets/data/q-simple/r149.json": "781e8dbc12768c1f8fc3fd93f8899fa4",
"assets/assets/data/q-simple/r64.json": "fd1ce442598352978f2f1c60c0576c7f",
"assets/assets/data/q-simple/r540.json": "9883be1d1945e173c5dcb16484986ee5",
"assets/assets/data/q-simple/r1.json": "b839459a83fd6ac52cff75d3b37597e3",
"assets/assets/data/q-simple/r463.json": "96012346b0f9933f31928dd1501c44e5",
"assets/assets/data/q-simple/r487.json": "e8cd59085a2891b0cd967f84c6bb6a98",
"assets/assets/data/q-simple/r289.json": "15914f15c5c4a6ba82bf0c4cd670f748",
"assets/assets/data/q-simple/r455.json": "22dc4d1d368f0a5af642b81a4b2fa22a",
"assets/assets/data/q-simple/r378.json": "64e95ce22255008765cf35cfdeaee48c",
"assets/assets/data/q-simple/r22.json": "f40b007cb215a3ecd8975d8d35af082c",
"assets/assets/data/q-simple/r65.json": "1913d2e8083e45249b80c1c20c3eb218",
"assets/assets/data/q-simple/r506.json": "79ec04312e992de0c5ffe29f3a82688b",
"assets/assets/data/q-simple/r145.json": "e759f0dde266fb3b771b1f33ac773760",
"assets/assets/data/q-simple/r366.json": "f316f6d3fbb00edf8b133f2cbd461693",
"assets/assets/data/q-simple/r230.json": "f44a04a969cae46f57e76ab217e4f861",
"assets/assets/data/q-simple/r328.json": "157f5207ffd52b9fab9a9c5d02030777",
"assets/assets/data/q-simple/r521.json": "a10b0d24ef84f9b7aa91bc7ddfbb91cd",
"assets/assets/data/q-simple/r101.json": "0424e4bdea68f9041727ae0733e876a1",
"assets/assets/data/q-simple/r18.json": "91ffd031fc6d73239ba0b23aab264ae3",
"assets/assets/data/q-simple/r168.json": "4025ec9c6d91b7c6e8869be1fae4ca23",
"assets/assets/data/q-simple/r298.json": "47e97b4d93d0d08bdadfcfd174ee4ee3",
"assets/assets/data/q-simple/r316.json": "6833c418ef298d675ef2fe110b214d00",
"assets/assets/data/q-simple/r321.json": "5bb95efcebde34ae90928ece74e89c13",
"assets/assets/data/q-simple/r199.json": "64ffc06dbb432cf4ac92eb21ca0ff598",
"assets/assets/data/q-simple/r278.json": "087b20c96cfa5b270cb8bc5e4b9e468d",
"assets/assets/data/q-simple/r345.json": "8043e50f580d5d8e7bfed2a6b4800c72",
"assets/assets/data/q-simple/r102.json": "e6bd907f53341c654ba44bc3b2808b46",
"assets/assets/data/q-simple/r129.json": "ea2ca47359216e20fa728e6625a71f50",
"assets/assets/data/q-simple/r338.json": "dcced246b3695d1aeb2a2ab5880b228d",
"assets/assets/data/q-simple/r291.json": "301ca959d810f8bc6f85b7970ef42b35",
"assets/assets/data/q-simple/r49.json": "4587bad68acbe2420b3393ff112eb6b7",
"assets/assets/data/q-simple/r66.json": "c4f2a4e7e9912306f409ecf8f5db997f",
"assets/assets/data/q-simple/r222.json": "2af4999cee1cb9235d7a99f8e250c291",
"assets/assets/data/q-simple/r82.json": "0f1ddcb0c133194333a3dfeabd0ef50f",
"assets/assets/data/q-simple/r54.json": "dd88e0066e53e973f469c921923bfdcb",
"assets/assets/data/q-simple/r214.json": "1b94d77796bfa2b8b3b61c99c0589e48",
"assets/assets/data/q-simple/r457.json": "fcdb08d01cb1b19c4cb86803095611c4",
"assets/assets/data/q-simple/r542.json": "351571bdf2193441ced8fdd8648b6421",
"assets/assets/data/q-simple/r151.json": "0136a3a3a21a34dbc73b90aec012d7e6",
"assets/assets/data/q-simple/r180.json": "f5012a60e2b07410dc36b556f7bb5cbb",
"assets/assets/data/q-simple/r134.json": "dd5f8c3897d46caff6b71c7d60b386c0",
"assets/assets/data/q-simple/r419.json": "24a7c53707ddb0cffee855d6c9180b95",
"assets/assets/data/q-simple/r21.json": "c75366aba17758f595bace774f17629c",
"assets/assets/data/q-simple/r143.json": "142d288412ed4cded5d178783d6c1d38",
"assets/assets/data/q-simple/r479.json": "72065b43c771245690568fb5b04f324a",
"assets/assets/data/q-simple/r137.json": "deaa0bb337ed46c7da1d9a00bb2e1c46",
"assets/assets/data/q-simple/r488.json": "3de863b9e1c56561db4c0a5ec57ffc3c",
"assets/assets/data/q-simple/r270.json": "e828fe210422f209c4f4d3189157f79f",
"assets/assets/data/q-simple/r407.json": "ac21396c016bd9ffddb23f48e5b8cb7e",
"assets/assets/data/q-simple/r523.json": "d338f91620eebf979871f58afe89c740",
"assets/assets/data/q-simple/r340.json": "11f1b22c5e18627e86b043744169dbb9",
"assets/assets/data/q-simple/r297.json": "0f9cc1d9902f4974316fc572207d5e76",
"assets/assets/data/q-simple/r188.json": "40d3d451f6543f676faff9014d7165c1",
"assets/assets/data/q-simple/r171.json": "d660f54d56f2c40c67dc911739858893",
"assets/assets/data/q-simple/r383.json": "7f89669e8322fcacae2e3b70d3bb8b8b",
"assets/assets/data/q-simple/r221.json": "2d630986bc069808e6d44406abae5d00",
"assets/assets/data/q-simple/r413.json": "623976a9d6ae598605b456707558f917",
"assets/assets/data/q-simple/r238.json": "47e0de62df288a08657ca95e933c808e",
"assets/assets/data/q-simple/r197.json": "684ba28335600ebb17a6549e297c04bc",
"assets/assets/data/q-simple/r86.json": "6ea139453fba08dca6dbe687a6190920",
"assets/assets/data/q-simple/r548.json": "e29055bb2db1b043ac387a6fd9964103",
"assets/assets/data/q-simple/r361.json": "673b91d6ea1e73b805b1f3748501d7e4",
"assets/assets/data/q-simple/r84.json": "9a7b7cf15d9d76f00ef5417b60858003",
"assets/assets/data/q-simple/r133.json": "822ec87b06e721a51019ec4922d1af73",
"assets/assets/data/q-simple/r80.json": "69c1188add7ccf6a1c2f238153761f27",
"assets/assets/data/q-simple/r451.json": "f9d28eb03221bbbfe4d7f6f27ae653b5",
"assets/assets/data/q-simple/r195.json": "1458fa84a42cf64cf3d5a9dde3712739",
"assets/assets/data/q-simple/r469.json": "9fddbcad356d18a9cea28dd7fc20c3be",
"assets/assets/data/q-simple/r88.json": "17d672f1a5bd025e94e41ab3be59db60",
"assets/assets/data/q-simple/r117.json": "4cac7cf854a7f051e640f64908c241bb",
"assets/assets/data/q-simple/r402.json": "f6f48d66b13972399b69f229398b0c8d",
"assets/assets/data/q-simple/r442.json": "56c6d7917f9dcbe3a8af4d9e4888b292",
"assets/assets/data/q-simple/r190.json": "7cf70e2e39850b20ab25341527275d00",
"assets/assets/data/q-simple/r511.json": "5b2c276409b1de80ba9e47211c7b439d",
"assets/assets/data/q-simple/r105.json": "5d252e64c4d249789be1aa70d860cc68",
"assets/assets/data/q-simple/r304.json": "282be4b400fa12bfeea65ec4fcf14d62",
"assets/assets/data/q-simple/r104.json": "0873aa1dd101d17377b89b5e3bf7fb1f",
"assets/assets/data/q-simple/r249.json": "28d2480d36340df6ae45511d3fe3d47f",
"assets/assets/data/q-simple/r481.json": "856bdfc28eb2b587b4a358f9a13b6bd7",
"assets/assets/data/q-simple/r245.json": "57154187147391a43febf6552b3654ee",
"assets/assets/data/q-simple/r445.json": "b12c86642bebcb11422313eda9cdc176",
"assets/assets/data/q-simple/r287.json": "95a23795598552c788b6e061d995351d",
"assets/assets/data/q-simple/r336.json": "ea9c08d23b365194bc4e1e7967456fe3",
"assets/assets/data/q-simple/r50.json": "7c49055743791ae7205571f33d223e0d",
"assets/assets/data/q-simple/r42.json": "60afcca7f482bf408872e9fa3ce9c77b",
"assets/assets/data/q-simple/r380.json": "438120c911d406dd2c6d497d7796fcb6",
"assets/assets/data/q-simple/r159.json": "1088fa96954823eeef289db0da64805a",
"assets/assets/data/q-simple/r303.json": "3518f63ba9b836a0a31760337933e9d0",
"assets/assets/data/q-simple/r386.json": "7cfae9e5690f6aacbb3481f8bf5be06f",
"assets/assets/data/q-simple/r74.json": "3333e092ca385b5af512a66c9b6dea9d",
"assets/assets/data/q-simple/r23.json": "b1eb3c0ec594289e0a026c46808d6a4f",
"assets/assets/data/q-simple/r95.json": "d64b8b42a3715ded4aec0824036517ba",
"assets/assets/data/q-simple/r122.json": "3eb9eb4d223fd3c395ea119e159520dc",
"assets/assets/data/q-simple/r16.json": "dc2d9359cdcb847bcf74ee3a30ccc139",
"assets/assets/data/q-simple/r185.json": "889189bfdb7e76606612d580aaf526c0",
"assets/assets/data/q-simple/r172.json": "5355e62dd77b49cbcaa844728c36b3f9",
"assets/assets/data/q-simple/r263.json": "335287a06a7ecb94055e5fda907d1a1b",
"assets/assets/data/q-simple/r358.json": "4969b621f446c76e8aabc91e6f36dfb3",
"assets/assets/data/q-simple/r183.json": "ba397ec4f9c10a3061aa3cc1324c0de3",
"assets/assets/data/q-simple/r368.json": "2b0d93b8b6ab59b392101a6a098b2a8c",
"assets/assets/data/q-simple/r459.json": "752ffdd1a22dc7e0a7f183c0ce17980d",
"assets/assets/data/q-simple/r381.json": "2295f094360a5efa9b2879f77d22bc5b",
"assets/assets/data/q-simple/r27.json": "354dbc87dbb9f39d581bb933055c65c4",
"assets/assets/data/q-simple/r176.json": "90c364663ab606245313274c520cf56f",
"assets/assets/data/q-simple/r490.json": "ebe05497e334fd8298848586dc5d8c81",
"assets/assets/data/q-simple/r152.json": "1cf672ee27b57012f37109c76f56e3b0",
"assets/assets/data/q-simple/r115.json": "045f2782c7de0315a9b3db5087664ab7",
"assets/assets/data/q-simple/r37.json": "c54556a7015e082d69b76ee3dbf31327",
"assets/assets/data/q-simple/r70.json": "a0620aa3fb912682ba10ba3cf16881e7",
"assets/assets/data/q-simple/r387.json": "4f0b166a2323d929f5cbb7de4160d3f3",
"assets/assets/data/q-simple/r496.json": "9ed77f633a9b5f5e3da51f3290f0c981",
"assets/assets/data/q-simple/r310.json": "ea3f74b18d00c70e1146b60ae9cf5b72",
"assets/assets/data/q-simple/r28.json": "6562ab262f564d02c149a410b52ef0ed",
"assets/assets/data/q-simple/r275.json": "c9be648f57d205ed348f676b953de58f",
"assets/assets/data/q-simple/r482.json": "8af42bc45f27e78197c61217b1423b20",
"assets/assets/data/q-simple/r549.json": "a7c3ee1acf03786c71e84c584822c835",
"assets/assets/data/q-simple/r470.json": "aec0d56864becb20bd29f9f9acf56c8f",
"assets/assets/data/q-simple/r554.json": "cb87179e1d57e7fb243d3efd4690e1a9",
"assets/assets/data/q-simple/r217.json": "04729f0650ed94d4619621b70fb8daf4",
"assets/assets/data/q-simple/r252.json": "668c1b9638fccd7f05c515e67dbc3197",
"assets/assets/data/q-simple/r162.json": "ec2c971c09eb4951b76728df96834295",
"assets/assets/data/q-simple/r228.json": "ce0155bf6611cfefac2d3496f6ad9da7",
"assets/assets/data/q-simple/r555.json": "29ee401649804ae3c914381d962048aa",
"assets/assets/data/q-simple/r240.json": "3e536f200ce7ccc4ae82a5a648f0a556",
"assets/assets/data/q-simple/r118.json": "26c56042adde49440f5f3307588981dd",
"assets/assets/data/q-simple/r346.json": "9cbc2a692877a964d4a920b5678fe96e",
"assets/assets/data/q-simple/r233.json": "de2f6e48fd4aa8070d347c170bdd97f1",
"assets/assets/data/q-simple/r382.json": "5457174882ef552112ee7b6067de76c0",
"assets/assets/data/q-simple/r281.json": "af645bdff0fe3938a6c970ec7e79f050",
"assets/assets/data/q-simple/r376.json": "e4489eef19b106636a63f614daad4712",
"assets/assets/data/q-simple/r87.json": "d363cdadd2c80e456217d12887d0785e",
"assets/assets/data/q-simple/r324.json": "4eccdb2c5f4dc0e6a72a6980c11c4486",
"assets/assets/data/q-simple/r20.json": "a78842e69449c4be118e73825276e6a2",
"assets/assets/data/q-simple/r153.json": "7a3d70dbb21a4feeed678a4b4e82d071",
"assets/assets/data/q-simple/r516.json": "906860b6b0acfe1551970d00afaaf9e6",
"assets/assets/data/q-simple/r418.json": "ce62bfe9925449a3bb9a673f02cef860",
"assets/assets/data/q-simple/r121.json": "4192da57a3bb3ae5cea0018adc7c2638",
"assets/assets/data/q-simple/r356.json": "3bd8307ca8ee90bfe657ce0784544980",
"assets/assets/data/q-simple/r267.json": "67f46726adbd7c0f5d524c70a4820444",
"assets/assets/data/q-simple/r497.json": "6e275221e61711f4ff1fc61fd51a085e",
"assets/assets/data/q-simple/r89.json": "f8b2f63641adfb106b9fa138cb472aa7",
"assets/assets/data/q-simple/r352.json": "2c675a4c9378b7671206064cc889440d",
"assets/assets/data/q-simple/r215.json": "7a87e9093cd4e1367a1115614a885a81",
"assets/assets/data/q-simple/r44.json": "3e60bd1489fb2272e84b32bc752c419f",
"assets/assets/data/q-simple/r294.json": "b05843e9e50acd6f58a890d56d0b1231",
"assets/assets/data/q-simple/r483.json": "e9212b6776d5c87c06d4d7aedfcf8b36",
"assets/assets/data/q-simple/r247.json": "eac927ec0b53cec262ffc3a2d2dc2632",
"assets/assets/data/q-simple/r242.json": "5355c1ebb315d6a013323ee934cd4c74",
"assets/assets/data/q-simple/r388.json": "be374779d847475a309c30b993bb8eb6",
"assets/assets/data/q-simple/r5.json": "f6d9cacbc3c29612c528f0a772586688",
"assets/assets/data/q-simple/r520.json": "0883d89d2c34d9885be3a325ffc28fbd",
"assets/assets/data/q-simple/r305.json": "c10b30aeee01ddf8d6544f01cb4deaff",
"assets/assets/data/q-simple/r186.json": "6cccd02773bffad1c8a6c1e9ef1ad84a",
"assets/assets/data/q-simple/r71.json": "ad7c10d0f670d500ac5b37987272ed68",
"assets/assets/data/q-simple/r420.json": "3e627357d76a18b52252dae1b2fe6b6f",
"assets/assets/data/q-simple/r391.json": "d7ed1264f82999b6cad4fc792b83f33e",
"assets/assets/data/q-simple/r320.json": "f6d54038ac912be0501e42ec6424ea59",
"assets/assets/data/q-simple/r299.json": "6e395e945f8bb6670f5ad6688b40959d",
"assets/assets/data/q-simple/r158.json": "f1be61acfbbcbf7ea1d883635b1c9ea4",
"assets/assets/data/q-simple/r533.json": "e45b9ceea3d85f3ba1e06b48247500e6",
"assets/assets/data/q-simple/r454.json": "1537935d9625f164567fb04aa95b9774",
"assets/assets/data/q-simple/r100.json": "2c2653310c57eea1e0ca784de432279d",
"assets/assets/data/q-simple/r6.json": "bc6f92c872406eb5fe1ee037f6bcfdc7",
"assets/assets/data/q-simple/r403.json": "10ac63fe51a404d54be5d69aec0a2317",
"assets/assets/data/q-simple/r43.json": "7b34919eb1e59609d10142757df0c2bf",
"assets/assets/data/q-simple/r507.json": "af10b519e262c32d9c8a43a0dd636e9e",
"assets/assets/data/q-simple/r535.json": "e9b9211bb2e7facf43ec0f177c81250d",
"assets/assets/data/q-simple/r7.json": "1d5fa989fb8fcbaaf4db016b5b1dac26",
"assets/assets/data/q-simple/r250.json": "92325316c45c93d70b135e742111bfec",
"assets/assets/data/q-simple/r194.json": "cf5d39a55739d66b9ed8aede9d926af6",
"assets/assets/data/q-simple/r271.json": "fb78c4024701c7d887f56ed1c93b421c",
"assets/assets/data/q-simple/r312.json": "12c9da1bfec6ca34a8209cd4d9109dff",
"assets/assets/data/q-simple/r501.json": "529b49382e09dbfba4f232dfb12bd938",
"assets/assets/data/q-simple/r269.json": "f1dc7c53cec304b43618402e6b951e26",
"assets/assets/data/q-simple/r524.json": "aa1422bdfecc77363be6b0027612856f",
"assets/assets/data/q-simple/r379.json": "b0037dbb818eb120d29943fa7d41b5ad",
"assets/assets/data/q-simple/r97.json": "2688ba6ddb200a349de2034823a839b1",
"assets/assets/data/q-simple/r499.json": "4a86c75bf9220c4738781d9aed5c2a90",
"assets/assets/data/q-simple/r257.json": "42da578730a9639d24b86cf8f80f2844",
"assets/assets/data/q-simple/r58.json": "15d0a8190d9ffbd84f1ad807d7ca9f69",
"assets/assets/data/q-simple/r518.json": "5d962259236b5e1c2a353338e7e999dd",
"assets/assets/data/q-simple/r96.json": "3475ced09987b4b65b50e249ae6956cb",
"assets/assets/data/q-simple/r458.json": "e3dea1b3aeac27250fefade248c50ca2",
"assets/assets/data/q-simple/r253.json": "f65426d1ab89e1c8b27819433ed4928e",
"assets/assets/data/q-simple/r364.json": "7ad277cab017208dbefd46007f41fac8",
"assets/assets/data/q-simple/r541.json": "521e88f2793f904b81b2d41b6912948c",
"assets/assets/data/q-simple/r327.json": "7f1dfedbe38727ad604ea2c80a94fe7b",
"assets/assets/data/q-simple/r468.json": "f54a4e2ca5de5078758d77b865948f53",
"assets/assets/data/q-simple/r300.json": "d08cce547ba0bae11ae3f158f0ce2601",
"assets/assets/data/q-simple/r452.json": "98208e95d330aa95b1201a151a8e5cda",
"assets/assets/data/q-simple/r128.json": "181d72d919dadb0b5b2f2cbcefb66ff8",
"assets/assets/data/q-simple/r119.json": "e62fa89d4373ed0096d9857f5fc54a6b",
"assets/assets/data/q-simple/r515.json": "2235c5a6409a33f3b14d72cf7f98a2e5",
"assets/assets/data/q-simple/r179.json": "ca08c5e30ccd98ac73593d68488c3001",
"assets/assets/data/q-simple/r514.json": "50725fa3da5403d58ab0fa06abdc9a1e",
"assets/assets/data/q-simple/r57.json": "838e846a7854972d95006b4d3a6adfbd",
"assets/assets/data/q-simple/r251.json": "77117071027631d9d63795e2ce91c5cd",
"assets/assets/data/q-simple/r61.json": "9d3e784203875e2d5cbd23ce8fdd04c0",
"assets/assets/data/q-simple/r432.json": "cce3a1ecc1caf6f723e8b04ee11e0096",
"assets/assets/data/q-simple/r160.json": "a626e3b413d7bf13499c4e97396c5275",
"assets/assets/data/q-simple/r232.json": "3fc840e341656ca8e975400ae6fe7bfe",
"assets/assets/data/q-simple/r284.json": "2cdb3cb2368384f6eaf57b515eccdfb6",
"assets/assets/data/q-simple/r103.json": "5256f74c2f1e4f74cc2fa05331116040",
"assets/assets/data/q-simple/r94.json": "f643ad43e6900fe450ebc8b7e195886d",
"assets/assets/data/q-simple/r453.json": "aca7f17ee5ee58e925d03f22fc2bed0c",
"assets/assets/data/q-simple/r277.json": "54b6413104d4e88c7656221a8c0edd3d",
"assets/assets/data/q-simple/r534.json": "8600d6c027ecd4b2e892ca4e88623b14",
"assets/assets/data/q-simple/r423.json": "de0adbf691fbe682fdeb1f062f94f3bf",
"assets/assets/data/q-simple/r437.json": "87969325c3465e5e935cd3e666462144",
"assets/assets/data/q-simple/r192.json": "d91a6a770b11f5bbba11e356ead27c84",
"assets/assets/data/q-simple/r53.json": "1e972e7f59c1cebadca123fb1aa27803",
"assets/assets/data/q-simple/r48.json": "269037364cb60544359404081ad67165",
"assets/assets/data/q-simple/r365.json": "a0bffc25bca432865c13d5fe2704d7a8",
"assets/assets/data/q-simple/r142.json": "7372ca4f05610994fe340da0345ff186",
"assets/assets/data/q-simple/r239.json": "b7e96b386c72dda2b6f56d1b409b2741",
"assets/assets/data/q-simple/r120.json": "1c45562406d911998b68c4d14a9f93b6",
"assets/assets/data/q-simple/r182.json": "21deb8247a4eba81461c2196e7c38838",
"assets/assets/data/q-simple/r163.json": "34ec9ad8e637abfb0caabe7a0b7a5a49",
"assets/assets/data/q-simple/r264.json": "9d3dfd4fe4cc27b7cd6f4c602e604eaf",
"assets/assets/data/q-simple/r108.json": "486684895c8a248252175f2b71f3e520",
"assets/assets/data/q-simple/r360.json": "028a8a0606b1e9a048066b89a9f0d8db",
"assets/assets/data/q-simple/r465.json": "1842e63c885ef61fa11ab76a2f1de2a8",
"assets/assets/data/q-simple/r243.json": "05b1991266a681a5c098df09fee37eb7",
"assets/assets/data/q-simple/r394.json": "530522c1c148516cbd04dc2b0538b5da",
"assets/assets/data/q-simple/r202.json": "a3d5298907ea6f9a8be3b0dfdcfaa55d",
"assets/assets/data/q-simple/r494.json": "ef020de19f8a989fdef694bd8dd64379",
"assets/assets/data/q-simple/r339.json": "61ccbcc8f6a46a9bfd0e4a1b01d0ddd2",
"assets/assets/data/q-simple/r184.json": "4ce3668fa776e00916c5a646954bae14",
"assets/assets/data/q-simple/r196.json": "09796e4273a14c5b7ebf67872b35e367",
"assets/assets/data/q-simple/r266.json": "f0aa33977de2801b90f90decc47883b2",
"assets/assets/data/q-simple/r208.json": "7aae244384f44b462f6ef462f1a7eb00",
"assets/assets/data/q-simple/r93.json": "b0816ae704de77a7f801d2dacbf2cdd8",
"assets/assets/data/q-simple/r526.json": "d2361e3f7ae6bbefead7cb1edc1e6075",
"assets/assets/data/q-simple/r330.json": "4822eacb335d269d51f05594aad81c34",
"assets/assets/data/q-simple/r130.json": "3aba6fe216b1146c29f8696cf34bc7c7",
"assets/assets/data/q-simple/r397.json": "49891c87d508d46026b1509b0e142665",
"assets/assets/data/q-simple/r527.json": "641f2d35eec5d321139b1bacbdc42b1b",
"assets/assets/data/q-simple/r68.json": "f4fc6607acb19a7035d174bf0ea2b7ba",
"assets/assets/data/q-simple/r56.json": "1ff16263b5ffe602a94b00a9243d7759",
"assets/assets/data/q-simple/r539.json": "10cf9876678ebfe00dd973d41173cb88",
"assets/assets/data/q-simple/r400.json": "383849cfb6fed62c4945462eefaf9252",
"assets/assets/data/q-simple/r311.json": "1723116001591b8018800a6da79789fe",
"assets/assets/data/q-simple/r377.json": "21876cd54068e40e2425dca09229f501",
"assets/assets/data/q-simple/r268.json": "1465034f6cd71363935fd0c939d61036",
"assets/assets/data/q-simple/r395.json": "440effc3fb259f0bc25c4c8b83499f26",
"assets/assets/data/q-simple/r125.json": "f1dd48ca692aa8e499ed54936199c7d4",
"assets/assets/data/q-simple/r69.json": "6e83189b19f84f5586ab6ccaa699587b",
"assets/assets/data/q-simple/r169.json": "2dd48dbfd5b4b316b959d38fe2c38b3c",
"assets/assets/data/q-simple/r545.json": "97053db74d774c78304c2b0b3d9759ba",
"assets/assets/data/q-simple/r301.json": "b4b428e9f208d9f4695fbae429167653",
"assets/assets/data/q-simple/r72.json": "f832b6ff2dca2b288a7a709a7f046e9e",
"assets/assets/data/q-simple/r326.json": "602d8719a8406270b74227a973da1b19",
"assets/assets/data/q-simple/r254.json": "a34cc35af4e9629445a3dfa4d3ae20f5",
"assets/assets/data/q-simple/r484.json": "8c912b50aeb74bfd2171dc1be6cb58c3",
"assets/assets/data/q-simple/r384.json": "482566374a7a914d773d7144807ea1ed",
"assets/assets/data/q-simple/r353.json": "0340998e096fec5e0085260154f4bb9a",
"assets/assets/data/q-simple/r306.json": "9e2bab3d78dc1fecb1842784a8dd1fc5",
"assets/assets/data/q-simple/r283.json": "02939fd2481bc9bec528e636d25f6fd3",
"assets/assets/data/q-simple/r189.json": "e01ea05dd8566bad463ec61eb0c13d76",
"assets/assets/data/q-simple/r302.json": "e797dee45d3927cf5db7455907050ed7",
"assets/assets/data/q-simple/r513.json": "55aefe7738401e82ca96412379881dc3",
"assets/assets/data/q-simple/r390.json": "2e86fdb5c8c4c5a677e70b215752c8af",
"assets/assets/data/q-simple/r244.json": "6323afed8afd4694e47b948af7d2dc02",
"assets/assets/data/q-simple/r341.json": "b6967d0a8c7e2047d3220a99669851b8",
"assets/assets/data/q-simple/r77.json": "c467007e0193021710bf1cc4e3f1132c",
"assets/assets/data/q-simple/r258.json": "3b029cd3372632cb5b0feeb0dc3e952f",
"assets/assets/data/q-simple/r505.json": "7fb9a5976402aab9bce1eb016b716256",
"assets/assets/data/q-simple/r296.json": "31d1c38b72166f3c8fc5b2b047eb31f8",
"assets/assets/data/q-simple/r424.json": "0ef68ca441d8d30296f53e0f55ce4660",
"assets/assets/data/q-simple/r375.json": "05bf4f8df03e354da69c1a6a61ec80ee",
"assets/assets/data/q-simple/r67.json": "b477c930d3a8777c2947cda6ceab2d33",
"assets/assets/data/q-simple/r83.json": "5e4852a649982e8ab664543a8e2ab2e7",
"assets/assets/data/q-simple/r543.json": "a2950bf1b5c1176985d444549ed2e730",
"assets/assets/data/q-simple/r318.json": "bc9670d082d0e23c3562c4a4b665f64c",
"assets/assets/data/q-simple/r528.json": "52080172d510dd64fe6370e7a815bddc",
"assets/assets/data/q-simple/r116.json": "cb8ae48d73e47d9533ee25eee04016de",
"assets/assets/data/q-simple/r475.json": "5fd416f939f07f8deab0123e3528e051",
"assets/assets/data/q-simple/r174.json": "7ce085e14640f6a5868735af1c7ef9d8",
"assets/assets/data/q-simple/r414.json": "496608dff25a829a9db666dbcb0d0771",
"assets/assets/data/q-simple/r373.json": "ce17dedd1cdfd879fd0fbe9635b13967",
"assets/assets/data/q-simple/r98.json": "6e3f11f2cdcd3bd4a0575778e855dbec",
"assets/assets/data/q-simple/r430.json": "6323ba75098f5b0e84ee4c112f333d80",
"assets/assets/data/q-simple/r157.json": "8fa378d7d91ad0a416b913ecd008b7e9",
"assets/assets/data/q-simple/r282.json": "d62c35dcec21a40038a2b2fd160a4a25",
"assets/assets/data/q-simple/r126.json": "13bd5b9f91a0301212fd6253f3eccb89",
"assets/assets/data/q-simple/r146.json": "4a9aadae42305b8c96f00ad6708740ac",
"assets/assets/data/q-simple/r519.json": "ca04990a52db80324219fc0b27d340d5",
"assets/assets/data/q-simple/r295.json": "8de47bd7d144128f82bcec4ede508e8a",
"assets/assets/data/q-simple/r235.json": "03198af6365fde4dd00cafa5cbe32e3a",
"assets/assets/data/q-simple/r206.json": "2fafd1fa17f923206effee7525d596f7",
"assets/assets/data/q-simple/r461.json": "278d92808dca4c8cf9c333402f3477e1",
"assets/assets/data/q-simple/r55.json": "4dc89cb4b2fc9a82128aff14bcdb607c",
"assets/assets/data/q-simple/r9.json": "b0b4e767561eb2e965d9b9464e51e3a9",
"assets/assets/data/q-simple/r237.json": "ba716c1a9524d1f0e920ea8515c5dfd3",
"assets/assets/data/q-simple/r170.json": "d7392d4dda02046aa9311438cf9d48f2",
"assets/assets/data/q-simple/r337.json": "4f29756bd31d140c1976367080f17359",
"assets/assets/data/q-simple/r350.json": "6a463b5d87840536e0c88a77d87fee10",
"assets/assets/data/q-simple/r231.json": "814b5e82fc3562895f63f509efb1d0df",
"assets/assets/data/q-simple/r31.json": "576fd4d14ec93164e4fb37605f55a744",
"assets/assets/data/q-simple/r401.json": "c878a575a9cd97c3e89828de1360dc2c",
"assets/assets/data/q-simple/r226.json": "0b12c1b867ae3f678946bbebf560cbe8",
"assets/assets/data/q-simple/r510.json": "c34aff8267e62f0149497cf8b24a700c",
"assets/assets/data/q-simple/r211.json": "cb3edc7be44b4271224f9c1a2762947c",
"assets/assets/data/q-simple/r323.json": "4a33f455073c9cb03d4ac7c36c4c5b58",
"assets/assets/data/q-simple/r47.json": "17f282cae01bd41de4644042b4ee2d35",
"assets/assets/data/q-simple/r347.json": "55bef870675e6058a542c787fef111dc",
"assets/assets/data/q-simple/r261.json": "aef42ca1fe27704c8de1200a278a37fa",
"assets/assets/data/q-simple/r138.json": "51872ffb30573a1243470632d580d785",
"assets/assets/data/q-simple/r109.json": "b138d5fcbc2bcd146a6e7c898778c02d",
"assets/assets/data/q-simple/r486.json": "4954ad1acc4666222702a0e787a8fb5d",
"assets/assets/data/q-simple/r141.json": "628a7e88a975699b8dd05082b9e91461",
"assets/assets/data/q-simple/r292.json": "2a5b0844edce82de2887c7a360d8d71c",
"assets/assets/data/q-simple/r256.json": "383aaf8a29462386b9f464912862d7e0",
"assets/assets/data/q-simple/r332.json": "c72366596590cc6e6b1acebad4a232ae",
"assets/assets/data/q-simple/r191.json": "29a31704a17c86cc68f4c98b54bf6939",
"assets/assets/data/q-simple/r91.json": "85196524faca19f0bba734e3476a0255",
"assets/assets/data/q-simple/r14.json": "452c808079b2033401191475acac2399",
"assets/assets/data/q-simple/r363.json": "ad0d280b821d56efd430f3d5e10b9b5a",
"assets/assets/data/q-simple/r2.json": "e80c2c7aecd2e283718acb2fe9dd4ba5",
"assets/assets/data/q-simple/r370.json": "8022c32911d73f0fd1403a00f1e8a700",
"assets/assets/data/q-simple/r422.json": "ad8024b03f53b974528b4d7b2c182590",
"assets/assets/data/q-simple/r473.json": "4981a5fea1cc812117a10cdfa71d87ed",
"assets/assets/data/q-simple/r112.json": "3971dabb8608e82d8e022ca6f413cfef",
"assets/assets/data/q-simple/r139.json": "bc11e457a6c39fdab11cf92178158481",
"assets/assets/data/q-simple/r491.json": "4113dd8a16cd74f3831ab87704fc23c2",
"assets/assets/data/q-simple/r348.json": "182f2a0fa16775d7c4b9aabc4657e44d",
"assets/assets/data/q-simple/r148.json": "752d23604f4d1c5981e4b1ec68807fda",
"assets/assets/data/q-simple/r530.json": "1981d99b969b6ae03fc67312bff87cef",
"assets/assets/data/q-simple/r224.json": "cf976b4b26b42ba4f65b949f998657f3",
"assets/assets/data/q-simple/r154.json": "ecf84ed3d5d5f9b60bfac11d19383f06",
"assets/assets/data/q-simple/r209.json": "fbe2828ea308c2edcd3f1f19c1169d96",
"assets/assets/data/q-simple/r446.json": "c2671d468924b546d11e17f93454ab66",
"assets/assets/data/q-simple/r512.json": "2eb28ce53b81f46264ff62eaf1e823e0",
"assets/assets/data/q-simple/r551.json": "0dee96a36705c18530097c0369505184",
"assets/assets/data/q-simple/r229.json": "95785401593a52b3e9c61ab2b585c4b4",
"assets/assets/data/q-simple/r90.json": "f3580e409c6cb0111b66ddffc0b15384",
"assets/assets/data/q-simple/r405.json": "21c9aa32fb4f698d34b08481f19848e4",
"assets/assets/data/q-simple/r75.json": "7a86c3ea4cc5b66afb31ba28a7ae0e60",
"assets/assets/data/q-simple/r165.json": "7b686ffac56fa0d1bfb81976345c1784",
"assets/assets/data/q-simple/r11.json": "a3d6cfbb6c99969385ff2e4c360ae105",
"assets/assets/data/q-simple/r205.json": "e829fa8ba9bb205a12105824408797a5",
"assets/assets/data/q-simple/r113.json": "46cbcd5c702d873d5c48741206c0e845",
"assets/assets/data/q-simple/r529.json": "12c6af216f1c9ffa2eab204fb7fc7275",
"assets/assets/data/q-simple/r173.json": "d6c5dd38adf3f8fc26c7526fc36b02bf",
"assets/assets/data/q-simple/r444.json": "12b3df62d15c1929dc837b98973746a6",
"assets/assets/data/q-simple/r449.json": "5a2b9fd0b71aabe1054b7148c203fb1e",
"assets/assets/data/q-simple/r78.json": "af979f8323ba270838c1170790508917",
"assets/assets/data/q-simple/r29.json": "e265fe98abbf66a8ca9847f286c92482",
"assets/assets/data/q-simple/r508.json": "c5e267083317bfdce618b289fb2e7f7a",
"assets/assets/data/q-simple/r203.json": "2942b391d356e01fca1e86dec314b644",
"assets/assets/data/q-simple/r495.json": "bb2097b08249d9d6d54f980deb8fc5a7",
"assets/assets/data/q-simple/r329.json": "fa5898a5e1b05a9d35db95894ca4b426",
"assets/assets/data/q-simple/r127.json": "97fd0ead194308bf67db1b8b541a460d",
"assets/assets/data/q-simple/r443.json": "2c942d6d02edb0612637de3147924585",
"assets/assets/data/q-simple/r4.json": "6b438b3e0b40c02618545cfbad343dab",
"assets/assets/data/q-simple/r288.json": "508a94f98068a0670208256913e35bfc",
"assets/assets/data/q-simple/r319.json": "e74a17f75e1018a8fb3748cf4adb22eb",
"assets/assets/data/q-simple/r546.json": "d50bdfa8a2fa115a87e452827cbb2198",
"assets/assets/data/q-simple/r522.json": "75fba7473a346b81f525648a118647d9",
"assets/assets/data/q-simple/r33.json": "c265fcf664e46c10ca2a4f1bd641e58f",
"assets/assets/data/q-simple/r285.json": "3e0c9ea5e139c9ff932d84a2a6b0f954",
"assets/assets/data/q-simple/r385.json": "c065bc14cfd97062e66abb362a590e75",
"assets/assets/data/q-simple/r290.json": "24937a6c30272b643ea670ca11360ddc",
"assets/assets/data/q-simple/r331.json": "d4467912622e6e7b062de98141e98f02",
"assets/assets/data/q-simple/r485.json": "14f219e067562471c11eac0b7f93f42e",
"assets/assets/data/q-simple/r15.json": "02adfad0c80304ac2559761e72ed2f0e",
"assets/assets/data/q-simple/r393.json": "fcd615aa1d627f2b75e34ef8ef388324",
"assets/assets/data/q-simple/r260.json": "e26528ff5c90942550d919880e311069",
"assets/assets/data/q-simple/r435.json": "97b69e68f0e918351beac457f32a3c22",
"assets/assets/data/q-simple/r276.json": "2852003d9f5be107476966ab2f71cadc",
"assets/assets/data/q-simple/r498.json": "fc2fa5afe5460dea4fa06c66271eb06d",
"assets/assets/data/q-simple/r409.json": "27f0014e2c82e7e355ed444dcf97bdf5",
"assets/assets/data/q-simple/r344.json": "c075387e202d6ede651f030e56c3069f",
"assets/assets/data/q-simple/r3.json": "0db5db6ae58a6496546be38bbf0b6687",
"assets/assets/data/q-simple/r547.json": "2fc056902b1d4c3d1b5d8eec728d853e",
"assets/assets/data/q-simple/r32.json": "ddb2fea5c85809e6eb0e02609eea0802",
"assets/assets/data/q-simple/r280.json": "3c38dabe904f1f07472a37458ef72150",
"assets/assets/data/q-simple/r156.json": "7d4acd0786b92dd98c0133a8fdd7ac6f",
"assets/assets/data/q-simple/r193.json": "e25c87fdc0a5043c64445b01498f1d8b",
"assets/assets/data/q-simple/r223.json": "3cb8a195a71e43f9eb6f2b844794492c",
"assets/assets/data/q-simple/r212.json": "c73f83e77ecdf087814860cb369c81f9",
"assets/assets/data/q-simple/r76.json": "7b93ccc46efe7182a3f640fc0ee26074",
"assets/assets/data/q-simple/r274.json": "f83381d28c01dfcb14211f38986f64b0",
"assets/assets/data/q-simple/r372.json": "58ef4ee0fa9490d6a83d829637e3b5d5",
"assets/assets/data/q-simple/r313.json": "4a318cbeba7b7e8b3c9bfc90d07f4ac1",
"assets/assets/data/q-simple/r417.json": "6fab82671e1bf214961d996df67ad42f",
"assets/assets/data/q-simple/r107.json": "f33213367cbbadd8c422e77227755aa8",
"assets/assets/data/q-simple/r99.json": "db70ff1dc52733d38fbd359ef2a7c2a0",
"assets/assets/data/q-simple/r434.json": "93ce26f06a0f981be1b1ed3150bd0d81",
"assets/assets/data/q-simple/r429.json": "ab765f95f6d4e1eb0caa07f3f15eb7bd",
"assets/assets/data/q-simple/r472.json": "a9561fbe627046a5bb1ba417b6cfc8f8",
"assets/assets/data/q-simple/r59.json": "82a3ffeb675f0d5ed7d4710b2f3b76f8",
"assets/assets/data/q-simple/r325.json": "d91ce06fd49abfd39ac926fc38d28cf1",
"assets/assets/data/q-simple/r532.json": "be1507c424bc559d327671e5d16fa0ae",
"assets/assets/data/q-simple/r19.json": "9377adbe80571c47557a9bbd6f41a810",
"assets/assets/data/q-simple/r427.json": "7083545b86e02da60681b41fa595483b",
"assets/assets/data/q-simple/r478.json": "e638480c579da9760881eafcc41d1d7a",
"assets/assets/data/q-simple/r124.json": "75fc1afc15a7379be87cea24ae0bdafc",
"assets/assets/data/q-simple/r355.json": "4688d5d9f8d4e57d17ecf75159d54f11",
"assets/assets/data/q-simple/r135.json": "d3c0b92cd2713824eed80129df3848c2",
"assets/assets/data/q-simple/r464.json": "f96885a2cd8c6c50b3a60820c6efd79c",
"assets/assets/data/q-simple/r544.json": "1ecaa6a98206443726aa04e053600bc5",
"assets/assets/data/q-simple/r92.json": "47c0e8c0ce5bcaaf6811fb2e2f1a0989",
"assets/assets/data/q-simple/r241.json": "8ead3f6ca668711f66c8ca53f462908b",
"assets/assets/data/q-simple/r314.json": "8533caa896d03829b9464dee52778e7a",
"assets/assets/data/q-simple/r500.json": "93bcfa05c10cac752ec559125da21b8f",
"assets/assets/data/q-simple/r26.json": "bc9941e1da0c150b043764962985fe88",
"assets/assets/data/q-simple/r504.json": "0a4e4fe4490089a82038b4ea040228f4",
"assets/assets/data/q-simple/r273.json": "b70e0d88e8be93fe77cdcb189d9d307f",
"assets/assets/data/q-simple/r106.json": "a8d01fa8875eaa8258366656b9700157",
"assets/assets/data/q-simple/r537.json": "175ba6bfcb4353394a78ae20d879b026",
"assets/assets/data/q-simple/r362.json": "37940e36d7407b4cc611cf236746d2e6",
"assets/assets/data/q-simple/r410.json": "16cf02e949e9141a8e3e0635c041254f",
"assets/assets/data/q-simple/r439.json": "fd32637537af8e073a9047a76dcc44e3",
"assets/assets/data/q-simple/r265.json": "d802e71911b6136b7777b717e9c61e19",
"assets/assets/data/q-simple/r389.json": "e60841fcb2b532dac7afa39c806d0274",
"assets/assets/data/q-simple/r161.json": "7b7bd0c734ed2200c01b700b62c97528",
"assets/assets/data/q-simple/r351.json": "bccdd027ca6219dd1ffe837ce104f3b3",
"assets/assets/data/q-simple/r448.json": "39afab196cf397af8d23fcffde7561a1",
"assets/assets/data/q-simple/r286.json": "590862692c20ec6f81904d1677b48f83",
"assets/assets/data/q-simple/r359.json": "fce5064fd36880da4356fff9ad56f909",
"assets/assets/data/q-simple/r259.json": "65e5d4e3fe7e6fd8e2ad922ab57467ee",
"assets/assets/data/q-simple/r438.json": "e3b90df5b7d5c145b13cc55611c443a3",
"assets/assets/data/q-simple/r164.json": "0b3627021d9615e0c3a1744876ee722a",
"assets/assets/data/q-simple/r35.json": "9dd1c79653691c0f702967333f7ddb43",
"assets/assets/data/q-simple/r335.json": "d3893e0c87415579b89c1a08639a2b89",
"assets/assets/data/q-simple/r553.json": "429495a00e241ce2bd99725c0505ed56",
"assets/assets/data/q-simple/r201.json": "cda3617b954ecdd6f8b56486197a5972",
"assets/assets/data/q-simple/r416.json": "399e8dd9b73092c8ff3979baf0707696",
"assets/assets/data/q-simple/r144.json": "043347b2218e6b05ca47fdb725e64375",
"assets/assets/data/q-simple/r425.json": "8f3231093d03facf5f076a012cb91704",
"assets/assets/data/q-simple/r187.json": "0bdb0568626de69204fac6bde7cf4c5e",
"assets/assets/data/q-simple/r131.json": "ee3b1b17d16bcd702fc479dc361d0872",
"assets/assets/data/q-simple/r30.json": "b7b19e2c3562f088623f90e3992a8c16",
"assets/assets/data/q-simple/r213.json": "ac752e0775569166385f8e7a5c75ea1d",
"assets/assets/data/q-simple/r412.json": "3fedb6c7e016761b255ce6ce8917422c",
"assets/assets/data/q-simple/r531.json": "fe246059a287730aa4f3fdfd6b140d07",
"assets/assets/data/q-simple/r24.json": "df2f8a84a6b2b888d1a6e0dbc05a5923",
"assets/assets/data/q-simple/r480.json": "cc870b5bcf49820680a730990da30024",
"assets/assets/data/q-simple/r307.json": "b1d6ee29bdab940070d047ebda4ad286",
"assets/assets/data/q-simple/r150.json": "89f0cf145fa02bcc59bc7fc5aed07a56",
"assets/assets/data/q-simple/r198.json": "d8edc267e79f869cb16e32f30e74ecf5",
"assets/assets/data/q-simple/r79.json": "c4a84a7bda01629036fb994509d5b2ed",
"assets/assets/data/q-simple/r447.json": "a3131a8a12aff6b464b1ad7098620322",
"assets/assets/data/q-simple/r140.json": "01eeed5f84b158bafdca610a2da63ab5",
"assets/assets/data/q-simple/r525.json": "1cee12cec4159796cb0e68511916adba",
"assets/assets/data/q-simple/r450.json": "c986f881a49f085c1e2425575bcd0766",
"assets/assets/data/q-simple/r315.json": "9c4333dba081eb0ea7e85c349bcb73bb",
"assets/assets/data/q-simple/r433.json": "edee456ffc32e0ce6f2ca549055574fe",
"assets/assets/data/q-simple/r39.json": "7e90df7bee365b26946becdd0e300bdd",
"assets/assets/data/q-simple/r536.json": "60100548b21b8b817abf0142c46d0724",
"assets/assets/data/q-simple/r178.json": "b86ffa27ae50f3ca801c8b58fac2990e",
"assets/assets/data/q-simple/r175.json": "3f2360106220d7190f1796ba1a5e7b6c",
"assets/assets/data/q-simple/r200.json": "bd35b6d3d2cd2efd86c04ebeeb10fcd9",
"assets/assets/data/q-simple/r492.json": "59931595a7929abed757c3115745b79b",
"assets/assets/data/q-simple/r462.json": "1c98671adc7b8e8e4fcb89c2650cc91f",
"assets/assets/data/q-simple/r81.json": "c656176d26ee86b380bfb6602e10a1ec",
"assets/assets/data/q-simple/r293.json": "365028a927495a85a58d05e66e3c367c",
"assets/assets/data/q-simple/r181.json": "6eb156da47160616d9c09702194b7519",
"assets/assets/data/q-simple/r392.json": "d56bfd0ae700d0535308259572b9e69e",
"assets/assets/data/q-simple/r398.json": "12b3d42b74d3ff4129d192bce0c59b61",
"assets/assets/data/q-simple/r476.json": "2a4280f1bb99c27b83938358c9c79889",
"assets/assets/data/q-simple/r34.json": "4be9d21e679158ce7ff46d90070e18ff",
"assets/assets/data/q-simple/r219.json": "282b61cb9e3ac2eb05eef1d49ff3c0e6",
"assets/assets/data/q-simple/r177.json": "b81b482d5cdbd5e2949a2a6cc753bbc6",
"assets/assets/data/q-simple/r210.json": "80d45184e5594770f0478d455d467ccc",
"assets/assets/data/q-simple/r503.json": "fc82e892412837e9ad39e2d7155d5c6a",
"assets/assets/data/q-simple/r255.json": "29f9328f80b38bfa229222923778ceb8",
"assets/assets/data/q-simple/r110.json": "36f3b91f86543bd5cdb2e1b7db4452dc",
"assets/assets/data/q-simple/r489.json": "39d90ff9c2bec4e3a3208fa58c842eff",
"assets/assets/data/q-simple/r45.json": "4d03b04b5d76a6f86efb3749d4aa4fa7",
"assets/assets/data/q-simple/r220.json": "75cea3d62634206e9603056be8903d94",
"assets/assets/data/q-simple/r404.json": "bdd40f83e89eaa4565d42f74025bccbe",
"assets/assets/data/q-simple/r538.json": "84fb182c751320be19235adcf8c637ef",
"assets/assets/data/q-simple/r17.json": "8595425a0565fab2f818af71180b88a2",
"assets/assets/data/q-simple/r428.json": "7124e83cdc2db4b029f9e3217a5e386e",
"assets/assets/data/q-simple/r460.json": "a2bce756dd273bb2318d55c36a7856b0",
"assets/assets/data/q-simple/r349.json": "7c8644bd6358285508516b517cb4ea54",
"assets/assets/data/q-simple/r52.json": "d9f38302fb61546cb0761c6f667416d9",
"assets/assets/data/q-simple/r436.json": "cbdbb1d38c8a14442d607e8c8e24ec00",
"assets/assets/data/q-simple/r36.json": "bbfca964655ebb54f8bf1f368630785d",
"assets/assets/data/q-simple/r114.json": "cf5e50d1241b43f5a106d75ecc4c7bd6",
"assets/assets/data/q-simple/r227.json": "88bad3f540ea44c465d227107157b444",
"assets/assets/data/q-simple/r322.json": "c4719f76ebb75139003fd45cf273c768",
"assets/assets/data/q-simple/r308.json": "73bdebcea09cd436801901d1e4d4e1d4",
"assets/assets/data/q-simple/r317.json": "ebfb52234e322ee827227a63ab8f74b6",
"assets/assets/data/q-simple/r236.json": "ee6636d284c1e04ab01f4f631b8aae36",
"assets/assets/data/q-simple/r354.json": "16d06b45cf0111d30035d5123a54a980",
"assets/assets/data/q-simple/r367.json": "94c0652ded1f0f7cd3749a01d5469f02",
"assets/assets/data/q-simple/r62.json": "34140ba26a108277eb3b3925f8cec7cd",
"assets/assets/data/q-simple/r550.json": "18bb8b5c85c5838fb703038bea189ce3",
"assets/assets/data/q-simple/r371.json": "741254cd82056daa0f86c87864ae72f9",
"assets/assets/data/q-simple/r309.json": "2be5ef994e7f776809a11e8c547cc81e",
"assets/assets/data/q-simple/r333.json": "97f2c1f5dba5603b52dd37cfd24b5535",
"assets/assets/data/q-simple/r441.json": "e40fc25c98603ab1e337452d02d37229",
"assets/assets/data/q-simple/r502.json": "bc03a646d8a2cf25574b80b35291b5f8",
"assets/assets/data/q-simple/r8.json": "dbecbe8e35268e8d957c3672b474bff3",
"assets/assets/data/q-simple/r396.json": "dc8b2115351b63dbde7b7f92da2afe03",
"assets/assets/data/q-simple/r552.json": "93e91f2627b0cece0d366a62720ee3dc",
"assets/assets/data/sura_ruku_map.json": "95c3dff1364aed903a262c4e46ab8912",
"assets/assets/metadata.json": "6c7134af2eac025254fe85d4ae2e86c7",
"assets/assets/fonts/Baloo_Bhaijaan/BalooBhaijaan-Regular.ttf": "28190ae5cd54e8bf270404320d5e0821",
"assets/assets/fonts/El_Messiri/ElMessiri-Regular.ttf": "f987603b0ad311424b5c64c55e10d10c",
"assets/assets/fonts/Reem_Kufi/ReemKufi-Regular.ttf": "1cbfee67b7f1e63e1334e8800d5450b6",
"assets/assets/fonts/Tajawal/Tajawal-Regular.ttf": "d8304accb48d86d9361ad30569823a0d",
"assets/assets/fonts/Lalezar/Lalezar-Regular.ttf": "c07a18bb821945af6ec7de632e877731",
"assets/assets/fonts/Rakkas/Rakkas-Regular.ttf": "1197ba69414123d92777f819a43a7d27",
"assets/assets/fonts/Jomhuria/Jomhuria-Regular.ttf": "7d6b466d0e08fd984705b6190e6554a6",
"assets/assets/fonts/Lateef/LateefRegOT.ttf": "f98cf82fba21f78b335a41f343c5f0c9",
"assets/assets/fonts/Scheherazade/Scheherazade-Regular.ttf": "87ffd3a053cd6c09186452cb10d9a15a",
"assets/assets/fonts/Amiri/Amiri-Regular.ttf": "a61fbc4d3da365e17f68e1bba6415e47",
"assets/assets/fonts/Harmattan/Harmattan-Regular.ttf": "bcd87a685fc9fa2f88ae49bf9662649c",
"assets/assets/fonts/Lemonada/Lemonada-Regular.ttf": "659eae40390059a683cc91faf4df4ca9",
"assets/assets/fonts/Mada/Mada-Regular.ttf": "9b3ddca6af7328102938afab0d55bc9d",
"assets/assets/fonts/Changa/Changa-Regular.ttf": "7a53368c4704181a547f440c6273159b",
"assets/assets/fonts/Mirza/Mirza-Regular.ttf": "21fd4e3c1c6f103d8b00b8a30d211c49",
"assets/assets/fonts/Markazi_Text/MarkaziText-Regular.ttf": "367d77a763df54f70c6ebe345598f2fb",
"assets/assets/fonts/Cairo/Cairo-Regular.ttf": "8e62cfbb90ccadc00b59b977c93eb31a",
"assets/assets/fonts/Katibeh/Katibeh-Regular.ttf": "b9a90c628ecd4066bc9a44f548b67ff9",
"assets/assets/l10n/app_ur.arb": "0faa4615ac5e0278b819f1f1e8727977",
"assets/assets/l10n/app_en.arb": "60b7ef3583169d1ee4a3a9e4f2317f7f",
"assets/NOTICES": "801428afa617838d0e6b84a7926db8b0",
"assets/AssetManifest.bin": "64bc4386f893b245f138b4f717c45840",
"assets/FontManifest.json": "02a6cf41bef31c4729d894d6a263ff16",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
