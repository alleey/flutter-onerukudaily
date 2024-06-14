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
"flutter_bootstrap.js": "c85e9cd693a00ea498b8b71e95f8e2bb",
"version.json": "b54622d82960b8ec8b1555cfde7dc758",
"index.html": "0d7f2e5b86f4635f2f982d23268d0e4b",
"/": "0d7f2e5b86f4635f2f982d23268d0e4b",
"main.dart.js": "634f34fdd3f0d05c038fd6480dcfbdd9",
"assets/AssetManifest.json": "1d1f689ec11ffda237f2beb542856f77",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "dcce215079e3c24254498e45096f2a42",
"assets/fonts/MaterialIcons-Regular.otf": "6af91c9ce90c791a3a83e534887658fa",
"assets/assets/data/q-simple/r471.json": "957810eca9b8c5ebab0ffb1609d05159",
"assets/assets/data/q-simple/r155.json": "f24f337a2ccee0e5efc7d5e8f7c6bf09",
"assets/assets/data/q-simple/r40.json": "ded0e53afb256706d622e1a413fa7d08",
"assets/assets/data/q-simple/r369.json": "408c5123831c4afd6614c1345658bf35",
"assets/assets/data/q-simple/r12.json": "a687566daab6551c7c2084396faa6776",
"assets/assets/data/q-simple/r408.json": "28efeee0f3c37283e30c2ee52d43955e",
"assets/assets/data/q-simple/r343.json": "b992e7780c915a0402f2f3fbea27535f",
"assets/assets/data/q-simple/r225.json": "0e7858ea6e17d32ae34885c0fdf95cb6",
"assets/assets/data/q-simple/r415.json": "148537472ae6c5d964dca959780c33b9",
"assets/assets/data/q-simple/r147.json": "9a81779587134a2a97239480d83bba4c",
"assets/assets/data/q-simple/r46.json": "42655126aab5730ce102fbab1850fb68",
"assets/assets/data/q-simple/r13.json": "41518594f86799069e195dddbf592686",
"assets/assets/data/q-simple/r85.json": "5c445267fc865b8048e10a6688be9e2e",
"assets/assets/data/q-simple/r493.json": "da4b310c58f8afeb723e1de80ef2575d",
"assets/assets/data/q-simple/r60.json": "31f3bf544f03941f3af99ebc96bb158a",
"assets/assets/data/q-simple/r279.json": "b6b59b608aad5ed99ba621373342d388",
"assets/assets/data/q-simple/r216.json": "6b1041291b3d270bf8a8f60cb3aa9271",
"assets/assets/data/q-simple/r167.json": "fd7e62fff719cc9788eff7257db39cf9",
"assets/assets/data/q-simple/r248.json": "04f1ca9cb6cdbb14333b2e85b57f8d40",
"assets/assets/data/q-simple/r399.json": "150c058153f3cba6467ccdf4c4f7cb90",
"assets/assets/data/q-simple/r342.json": "77f502689d8290ebc1c9338c8d2cc640",
"assets/assets/data/q-simple/r406.json": "c3404ea044e48536c21f78457a373a31",
"assets/assets/data/q-simple/r357.json": "fb365688836e02e6bd15abfbe784cdf7",
"assets/assets/data/q-simple/r123.json": "d4d6df0e690fcb1f4bdfd2e49e3c216f",
"assets/assets/data/q-simple/r431.json": "af5ce06dbb2ad8488cb560936b19b1b3",
"assets/assets/data/q-simple/r218.json": "1f2c797c00205b155536e412439ba6a1",
"assets/assets/data/q-simple/r456.json": "4e949b7b25c1b0ab1aa300ddabf2c326",
"assets/assets/data/q-simple/r440.json": "5efeca5db707ea6eabd4dce6e92d22ee",
"assets/assets/data/q-simple/r477.json": "b09a70ec7d07a5a71dc941f93a2bf6e5",
"assets/assets/data/q-simple/r207.json": "3e6b72706ba74da84b78d2c3997250e6",
"assets/assets/data/q-simple/r111.json": "1b840001c0fe94e304237d6311870283",
"assets/assets/data/q-simple/r262.json": "06532c82a9888bfef8f819f0e690cf86",
"assets/assets/data/q-simple/r73.json": "adc8d7bf9ba6b542955d47f74d65dca7",
"assets/assets/data/q-simple/r556.json": "a27cf6f2077a20f355f893823e96708a",
"assets/assets/data/q-simple/r334.json": "dc701ae973f82d606d51caf2c13f2578",
"assets/assets/data/q-simple/r272.json": "acf5b49b044d837c3ae24975df17aab0",
"assets/assets/data/q-simple/r10.json": "0cda5debff1766d500186e19648e77ca",
"assets/assets/data/q-simple/r136.json": "d4bd7750bcd1b2ddc89347c56dedf2db",
"assets/assets/data/q-simple/r41.json": "a1ea420aee844cf6f2e6b692f58bb69e",
"assets/assets/data/q-simple/r166.json": "582f523bfa6f33599a0e95fbcfd600d3",
"assets/assets/data/q-simple/r411.json": "72a61ed59026478d69b3f2e3ff2c2fc3",
"assets/assets/data/q-simple/r132.json": "d579021d7a03e2944ddbdab3be1acf42",
"assets/assets/data/q-simple/r204.json": "70b19f9a8d1f84ed97086312e2f4892d",
"assets/assets/data/q-simple/r509.json": "6966786390355be624bd93a196758890",
"assets/assets/data/q-simple/r474.json": "c516e5dbea32dce5f32be58d555a182f",
"assets/assets/data/q-simple/r38.json": "b4cae1de817a67de567c9424eef364ab",
"assets/assets/data/q-simple/r234.json": "ebe8f7165ce19d5304192a99d8314b41",
"assets/assets/data/q-simple/r25.json": "0f316f8f34367fd36f778f9828c41767",
"assets/assets/data/q-simple/r517.json": "ed8d35ebb5b163ec0d3a9eb1607a2e70",
"assets/assets/data/q-simple/r63.json": "41b97dfe6e3473fe8be06308597ec0e7",
"assets/assets/data/q-simple/r51.json": "9fbf9e0df0c1b1eb3e80738e9937da38",
"assets/assets/data/q-simple/r467.json": "5ba1b5e825e4b48caec1e9f35b132bf4",
"assets/assets/data/q-simple/r421.json": "ad45d6c3fe92cc8bd813bfba43f530e1",
"assets/assets/data/q-simple/r246.json": "cab751a6a586fba47bc33334d9c8fb02",
"assets/assets/data/q-simple/r426.json": "2a74f2b49b994fcaef9b740eb33fe70c",
"assets/assets/data/q-simple/r466.json": "779de6ee50b91b83822e1c717a4a5a7d",
"assets/assets/data/q-simple/r374.json": "4cdf6e01186c862dc30b989cc197829e",
"assets/assets/data/q-simple/r149.json": "9f975619cb1c3a082f67d5b84cc21612",
"assets/assets/data/q-simple/r64.json": "b05d5b082eb50a09e1f79aef70d7e0b7",
"assets/assets/data/q-simple/r540.json": "d4e07d701fd1d61c5c9a279a2b9a2a00",
"assets/assets/data/q-simple/r1.json": "64ecbcf3a6d9c64345386f0c9591bcea",
"assets/assets/data/q-simple/r463.json": "1a9f81534c44f2bbefd087b1460be343",
"assets/assets/data/q-simple/r487.json": "3ea94695ded0cb92f25a9fc8635e487b",
"assets/assets/data/q-simple/r289.json": "e456b912899899490fe7f8243c006f6f",
"assets/assets/data/q-simple/r455.json": "6f842ea5606ba3822597b84836eb6e07",
"assets/assets/data/q-simple/r378.json": "020153bfa4dbd7319dffe450ef1f076d",
"assets/assets/data/q-simple/r22.json": "0867cce2ab6e04fe7dbb2c8d133b5aa1",
"assets/assets/data/q-simple/r65.json": "8391735cec6924cd8da8240fe452424e",
"assets/assets/data/q-simple/r506.json": "984f72c57be2abf293212386c41f8c71",
"assets/assets/data/q-simple/r145.json": "07259ff8c1d7b700a985ad71c8140136",
"assets/assets/data/q-simple/r366.json": "64ea3b8a382ef8b763c35867b94484ec",
"assets/assets/data/q-simple/r230.json": "843ca452ae9f5a617ecf5e93ec3232ac",
"assets/assets/data/q-simple/r328.json": "da2354d93a5d556885d6a11e46dc0b63",
"assets/assets/data/q-simple/r521.json": "04c125e7fe3555711dec159ff7ba70bf",
"assets/assets/data/q-simple/r101.json": "4a1dcb6b389e23a35e36abfe0d23cae3",
"assets/assets/data/q-simple/r18.json": "d0aa439b0dd90b1a82e54807b963608b",
"assets/assets/data/q-simple/r168.json": "ea2071406831034abac8b6f64f56a481",
"assets/assets/data/q-simple/r298.json": "34aefb475ec948e8bc2a4e5ac4ea6f1b",
"assets/assets/data/q-simple/r316.json": "71139cc9a739cff40015da4b9ea15264",
"assets/assets/data/q-simple/r321.json": "cdb5648dc199b545f61b2d030978407d",
"assets/assets/data/q-simple/r199.json": "205249dbc5fdb0648509f2b40ec837f4",
"assets/assets/data/q-simple/r278.json": "975d7a77c95df544e406fa9238db1f74",
"assets/assets/data/q-simple/r345.json": "9646ae9a4b5645d1b9b4d1734fd0def5",
"assets/assets/data/q-simple/r102.json": "a34cdf667da82aa2d747a33d2065fb70",
"assets/assets/data/q-simple/r129.json": "ef9b7a28be34b519e37607ed5f289ff1",
"assets/assets/data/q-simple/r338.json": "4957397130dc6c95f2663cbc35f258a6",
"assets/assets/data/q-simple/r291.json": "d9fba9ec6052ecc234c2ad08a6d45a7b",
"assets/assets/data/q-simple/r49.json": "1aa13b2faf7f3652b508437b282afd6b",
"assets/assets/data/q-simple/r66.json": "c42895dacee2ed4e34d2f976b8c575cf",
"assets/assets/data/q-simple/r222.json": "96f509fbf9fca82fae3c892aa0dda827",
"assets/assets/data/q-simple/r82.json": "80b523d7063955fc357f01c11b824a34",
"assets/assets/data/q-simple/r54.json": "f30293e1f78d31abf65c5e3f92cabc13",
"assets/assets/data/q-simple/r214.json": "dff11f16f39851408570cc6df906a23b",
"assets/assets/data/q-simple/r457.json": "c3c77d82e2201e51392fb4a5e4d805c7",
"assets/assets/data/q-simple/r542.json": "3ba3ecaa5c4ea4239d4a78d8dc8c502a",
"assets/assets/data/q-simple/r151.json": "0c7619e7382136163d51d1b9617e0e13",
"assets/assets/data/q-simple/r180.json": "442adc12f83eda11d86f7d8f4db5f92c",
"assets/assets/data/q-simple/r134.json": "5c84ad470dfc7157c2bdca2947d4d792",
"assets/assets/data/q-simple/r419.json": "0a8c7f4d35e8aa263ce5f433a71ab61f",
"assets/assets/data/q-simple/r21.json": "56b003fb2b74958dc04db38a90b2b17f",
"assets/assets/data/q-simple/r143.json": "4e5bbaeabbb0081696949119e9ee5892",
"assets/assets/data/q-simple/r479.json": "b024b2165923213d9d195b9e8c185750",
"assets/assets/data/q-simple/r137.json": "bdde51a00a8bd8ae30b726058dab103e",
"assets/assets/data/q-simple/r488.json": "58f97e91958519d8c8837a2c8dd3c19a",
"assets/assets/data/q-simple/r270.json": "827dc870633cef8915b148331ae0dc7b",
"assets/assets/data/q-simple/r407.json": "acd5e0ab3bd414e226c6ed25c066d3dd",
"assets/assets/data/q-simple/r523.json": "8469997b17dfc86ce32883376c1cedaa",
"assets/assets/data/q-simple/r340.json": "637c8015306a6fc849259cadcd32e66a",
"assets/assets/data/q-simple/r297.json": "ab543b678cfdbb27d26f3f5a14054997",
"assets/assets/data/q-simple/r188.json": "035f7990c2b9a13e7e86fb067e9cabb0",
"assets/assets/data/q-simple/r171.json": "74ece1300e863263536b1d3858ce2fbc",
"assets/assets/data/q-simple/r383.json": "ede66a679b215d6933f3ff2e4fa499ff",
"assets/assets/data/q-simple/r221.json": "da626435a0b0347fd3d170bf61c352c7",
"assets/assets/data/q-simple/r413.json": "c2bebe3bc77acc950c13826ad3270ffb",
"assets/assets/data/q-simple/r238.json": "cfbb186f0330f386d4a8aa127651138e",
"assets/assets/data/q-simple/r197.json": "229866913a9e5ff39edea9d053a56d13",
"assets/assets/data/q-simple/r86.json": "2aa477a7367f960f75121a666c94bb7e",
"assets/assets/data/q-simple/r548.json": "6ee0381b21b21103c028ca3be0209982",
"assets/assets/data/q-simple/r361.json": "3047f4c4bb53531164f094a245c31a96",
"assets/assets/data/q-simple/r84.json": "5cb14554368d750f6597824155ba1883",
"assets/assets/data/q-simple/r133.json": "7737e1d56de2e0fb76bbf71eb67c2dce",
"assets/assets/data/q-simple/r80.json": "2c7c1a5596a6f7312f1da20aa81ffa27",
"assets/assets/data/q-simple/r451.json": "c76d433417c9d44b802dffc9617b3745",
"assets/assets/data/q-simple/r195.json": "93a1fea2a14c068e9254898d6c8cdf50",
"assets/assets/data/q-simple/r469.json": "12588002f100b123b0d42327b37c9e66",
"assets/assets/data/q-simple/r88.json": "5115e2631f284cc0ebf97bd43e0c43fa",
"assets/assets/data/q-simple/r117.json": "46395e94e3f936c928f64120bea8bc5f",
"assets/assets/data/q-simple/r402.json": "e52806e9a8783cdfe7c22d146ded52bf",
"assets/assets/data/q-simple/r442.json": "6115aa23eba23c5e24023d694f831c19",
"assets/assets/data/q-simple/r190.json": "ce04d55029590e6294d33fafae085e43",
"assets/assets/data/q-simple/r511.json": "40530cbb71b75d2b9dfaa25a69633b66",
"assets/assets/data/q-simple/r105.json": "552d928a717d34723ff8397f8956825b",
"assets/assets/data/q-simple/r304.json": "2fa5b622b56ca09fde4049203af4b28b",
"assets/assets/data/q-simple/r104.json": "ef8473d15095afe82350f1e6aaa6ffb7",
"assets/assets/data/q-simple/r249.json": "ab101c9653da7cbb091be319e5afa342",
"assets/assets/data/q-simple/r481.json": "7bb978c0c7e008ab49cebdbbcc5fb057",
"assets/assets/data/q-simple/r245.json": "47cc2133c34b8ffb0df51093ff0c4ca2",
"assets/assets/data/q-simple/r445.json": "c703d76a77635d0277e0afb71337674b",
"assets/assets/data/q-simple/r287.json": "642fa9883181e25d5f7e62feb4d3c1c2",
"assets/assets/data/q-simple/r336.json": "f9596c17ae24619b3ed1f29eb23eab43",
"assets/assets/data/q-simple/r50.json": "5248f1dea34c2d38c47c6c76acb19e16",
"assets/assets/data/q-simple/r42.json": "566d7f1ce49ca681858db9770479839c",
"assets/assets/data/q-simple/r380.json": "5e55c34bc71c61f3331c9fb6ffae2d21",
"assets/assets/data/q-simple/r159.json": "908d04ff58fd7cbca49e37b731a93af7",
"assets/assets/data/q-simple/r303.json": "0662541a5754adb80f412df2e330287b",
"assets/assets/data/q-simple/r386.json": "4dbb39f9483cf5d849df3ac07f1fdc35",
"assets/assets/data/q-simple/r74.json": "aa89983d33387b81a41ffb2a2786fcfa",
"assets/assets/data/q-simple/r23.json": "1b763ded55358e3252e745d3c7085ed1",
"assets/assets/data/q-simple/r95.json": "37a6c9dc19fc860e90a2410b8fbb335b",
"assets/assets/data/q-simple/r122.json": "2d0894ea4276631c616834e6128a1b1f",
"assets/assets/data/q-simple/r16.json": "6265cd921fb734de98b8d3003ad9489d",
"assets/assets/data/q-simple/r185.json": "0f6751c77dcad3e3b14419d1699e946d",
"assets/assets/data/q-simple/r172.json": "573520256448e54f4e4d2b6db720aec8",
"assets/assets/data/q-simple/r263.json": "f275cae1f8eab01860f37fb0fd716655",
"assets/assets/data/q-simple/r358.json": "478c4feade22bb1116c1b1372b8c4355",
"assets/assets/data/q-simple/r183.json": "53b5b4f628158605a774e09092a3c0c2",
"assets/assets/data/q-simple/r368.json": "98f97982b68f013fdddf79e0f1dab9ce",
"assets/assets/data/q-simple/r459.json": "32d93ca5aab57264fb0339f5d06d1560",
"assets/assets/data/q-simple/r381.json": "ff72df7348bc2f6d50b6e19753775a22",
"assets/assets/data/q-simple/r27.json": "1fe46a6a166acf3fdaf8cc977620f7b0",
"assets/assets/data/q-simple/r176.json": "3c5825afa8aaaec030a7b4ed3bd0d0e5",
"assets/assets/data/q-simple/r490.json": "a6eaa0ef580e01bf81e0e184fb589abe",
"assets/assets/data/q-simple/r152.json": "05f44e47c4a47965210e2a6917cb382b",
"assets/assets/data/q-simple/r115.json": "6deca353299a1cc353eacad98f54d72e",
"assets/assets/data/q-simple/r37.json": "71fb4057cc063e039529558ef7edf11c",
"assets/assets/data/q-simple/r70.json": "dd5fd7f93a79cd5af24fcd84ed5b8043",
"assets/assets/data/q-simple/r387.json": "49d8c0c9e066b86d860690d4ce6a0f93",
"assets/assets/data/q-simple/r496.json": "e9b5fc4c418b5f032eda949345bc3ffc",
"assets/assets/data/q-simple/r310.json": "fcf86681f8b8cf9d532b51df66ea2933",
"assets/assets/data/q-simple/r28.json": "305407cca03fa9cf4ae280035797fac4",
"assets/assets/data/q-simple/r275.json": "809627558e7bb2357168e962552137b8",
"assets/assets/data/q-simple/r482.json": "dbe5623729b7c181a2414fe06eeed464",
"assets/assets/data/q-simple/r549.json": "11fc61e46bd7e032745c2f90dc22738a",
"assets/assets/data/q-simple/r470.json": "205a126bcaf85268ae03a024d92ffd24",
"assets/assets/data/q-simple/r554.json": "2f7276026ff8681f616b7569b78f7183",
"assets/assets/data/q-simple/r217.json": "2a708e80d805ff7212da44c0f1377410",
"assets/assets/data/q-simple/r252.json": "bb3e72ec2ede79949a8893e742621080",
"assets/assets/data/q-simple/r162.json": "08c92bd4236f8d20811f02658451d571",
"assets/assets/data/q-simple/r228.json": "2f642d6aebfeda65277af3167649f951",
"assets/assets/data/q-simple/r555.json": "83f8dcf3513ad9588798b26cb95d82ca",
"assets/assets/data/q-simple/r240.json": "8ef74139927ac123803a87b4c35e6fab",
"assets/assets/data/q-simple/r118.json": "34905e3c051c097ec31c4df9bfc4c390",
"assets/assets/data/q-simple/r346.json": "60753da96d1a2f76bb6df467b68346b2",
"assets/assets/data/q-simple/r233.json": "886db8ea9b15d774423ca8b9c2b34fc9",
"assets/assets/data/q-simple/r382.json": "88326d1292a6eae58c5c56c90592bde4",
"assets/assets/data/q-simple/r281.json": "5c6abb8babca9afb234d40a5f096b4d0",
"assets/assets/data/q-simple/r376.json": "73691fa2ad69d8b17980438ac9d871fb",
"assets/assets/data/q-simple/r87.json": "b8e7f51b3241f6730c930e8855cd8753",
"assets/assets/data/q-simple/r324.json": "cea0a82d4c0b90d89a25581689512369",
"assets/assets/data/q-simple/r20.json": "4b4583cde0a3a9384c72ba740144c679",
"assets/assets/data/q-simple/r153.json": "72612da2ab04266dd81aa56dca2cfe64",
"assets/assets/data/q-simple/r516.json": "742efadda4896c9801b8a6560f429c94",
"assets/assets/data/q-simple/r418.json": "ddcac06d454e995166f46f542cb3c5bf",
"assets/assets/data/q-simple/r121.json": "ba0df6b869b68e77258325579b865825",
"assets/assets/data/q-simple/r356.json": "0ae426d6605c033c560ec22e50b9148b",
"assets/assets/data/q-simple/r267.json": "b00cb92bf39892ee82155e6e3b617fcb",
"assets/assets/data/q-simple/r497.json": "722fad8c1d7b7d6b5606881fe82fe714",
"assets/assets/data/q-simple/r89.json": "5bf826af32dfc378f3d81577f5b41474",
"assets/assets/data/q-simple/r352.json": "4e0b83d245f61f2ccca9973677b698ad",
"assets/assets/data/q-simple/r215.json": "43667659594a96c6c3222076ef47560b",
"assets/assets/data/q-simple/r44.json": "efc1056842c3d3be4bbc3577d6bfc54c",
"assets/assets/data/q-simple/r294.json": "46aff5066ae294c6132340a53864fc8c",
"assets/assets/data/q-simple/r483.json": "3eb6d22b93ccbafdf9463a8ae126c0ed",
"assets/assets/data/q-simple/r247.json": "2c156ca80c3cd938af4d972234799c37",
"assets/assets/data/q-simple/r242.json": "302a6a37742ef9139ac6381cf475e729",
"assets/assets/data/q-simple/r388.json": "b76f6a14715f4735133c671ed70513ef",
"assets/assets/data/q-simple/r5.json": "a0caf8fb2cd9cf41342499f8a2a624f8",
"assets/assets/data/q-simple/r520.json": "92937e3f6ba9bfc96d84d2b642bb4ff8",
"assets/assets/data/q-simple/r305.json": "c5d0bf6d0124b4d101ffc1e09d8af317",
"assets/assets/data/q-simple/r186.json": "612d7169c6aa9f43f6e4cb94811bcb9e",
"assets/assets/data/q-simple/r71.json": "8a665f0ee295a022a4c839c14e4c642d",
"assets/assets/data/q-simple/r420.json": "cfb6b7b71c76058050286f69b11800bc",
"assets/assets/data/q-simple/r391.json": "85947b6f63ddcf7ec1d4ecbc25ca3d3d",
"assets/assets/data/q-simple/r320.json": "0ef1cff3882803e5121b20d7beea14af",
"assets/assets/data/q-simple/r299.json": "0b4be47353580daa27536d2790da8695",
"assets/assets/data/q-simple/r158.json": "4ca007fce1dda78a70c0018ad0160f60",
"assets/assets/data/q-simple/r533.json": "6e073a85aa07ae980478a016fcd2b934",
"assets/assets/data/q-simple/r454.json": "a70343bb95055f80ede5b8a03695f6d3",
"assets/assets/data/q-simple/r100.json": "b49b391bf2459e46aff297c92ec39862",
"assets/assets/data/q-simple/r6.json": "e139689eaf0e22892e856f1ace266b23",
"assets/assets/data/q-simple/r403.json": "969b1940553bec0cf40d1c1b57bb33bc",
"assets/assets/data/q-simple/r43.json": "930a931353b3d14d318a8fc91ff4f7ea",
"assets/assets/data/q-simple/r507.json": "dcd3cb3eb9b6dac12c4a23011768093c",
"assets/assets/data/q-simple/r535.json": "d3f2259c5426e3c51d9d09aaefa8e5b8",
"assets/assets/data/q-simple/r7.json": "ec633e89f6fb1149ec16de987da8847a",
"assets/assets/data/q-simple/r250.json": "ca8ad35aa0978cf437bc38751ceb0d89",
"assets/assets/data/q-simple/r194.json": "7b404e37ef7cbd219c38aed542610fee",
"assets/assets/data/q-simple/r271.json": "c33f71d349b3ce641b7b0525cc9e8406",
"assets/assets/data/q-simple/r312.json": "9af8e01698081bca166831fd9314ad20",
"assets/assets/data/q-simple/r501.json": "8228a91c251e6e49c181d9959d2d0621",
"assets/assets/data/q-simple/r269.json": "913235e701197acdf8653cfdd2f125fa",
"assets/assets/data/q-simple/r524.json": "b905d75cbfef1cce9e28dccd6d47981a",
"assets/assets/data/q-simple/r379.json": "5a315649b540e378f1a54b3192cca647",
"assets/assets/data/q-simple/r97.json": "302438aef40bb99c96bda6559827c5b3",
"assets/assets/data/q-simple/r499.json": "b28051b436cac16b2c085df3867cbfb4",
"assets/assets/data/q-simple/r257.json": "040eeaf29e779c830e662c18250de36b",
"assets/assets/data/q-simple/r58.json": "2fd04c261a55753e9a532d19997b036e",
"assets/assets/data/q-simple/r518.json": "5c5d6ac960ece00970634a2cee2757f9",
"assets/assets/data/q-simple/r96.json": "c27e14d1037fb3ad2d8d7b15dd395da8",
"assets/assets/data/q-simple/r458.json": "0317718b163eb12511f9d5bc79ad0059",
"assets/assets/data/q-simple/r253.json": "4cf73d0304b8be005bb5b715b259ef06",
"assets/assets/data/q-simple/r364.json": "cfdcb2e9b8fb46dddf9c068646a87273",
"assets/assets/data/q-simple/r541.json": "8948d2c8e651cb1d6e70c9074366cdc8",
"assets/assets/data/q-simple/r327.json": "6a14e611d6f9435fecc2a41851d972cf",
"assets/assets/data/q-simple/r468.json": "f36f31a18af788cf4467ad1d414e82a4",
"assets/assets/data/q-simple/r300.json": "4bf725dd44806b2c3f89d2277dd6408d",
"assets/assets/data/q-simple/r452.json": "581150b992e53c79adeec743e9f59b9a",
"assets/assets/data/q-simple/r128.json": "bb459c2218a322ac827dd241b298ae17",
"assets/assets/data/q-simple/r119.json": "fc0ebe90a79aba6af520869a700eb648",
"assets/assets/data/q-simple/r515.json": "0cf7c95e199e9ed0c454e3f61394c4a0",
"assets/assets/data/q-simple/r179.json": "100e06c95e1b458331d62633aa1d6625",
"assets/assets/data/q-simple/r514.json": "1062a995e70a20cc3efb33aba76c4b5b",
"assets/assets/data/q-simple/r57.json": "7afcfbd634f52a32c4a540639d435d48",
"assets/assets/data/q-simple/r251.json": "3ed77658d8aa39bc88604cd5f16400ff",
"assets/assets/data/q-simple/r61.json": "0cfdd694b5babf0d57b5dff952fc7f7d",
"assets/assets/data/q-simple/r432.json": "243c2ecb71450e01102b370dd6300abf",
"assets/assets/data/q-simple/r160.json": "eb3a46cd297487a97e85b57e5f4b3075",
"assets/assets/data/q-simple/r232.json": "0da39edb09d223ce5a670cef6525103b",
"assets/assets/data/q-simple/r284.json": "cc7f746ddcb6532457f2e81fbd2d9b68",
"assets/assets/data/q-simple/r103.json": "9ecc4a2ef11ff12b8af1bc8356ea4034",
"assets/assets/data/q-simple/r94.json": "1c1f10dec638f8117a7c9a5c51f37752",
"assets/assets/data/q-simple/r453.json": "0b54908b4662b0f0655ba2e15f818097",
"assets/assets/data/q-simple/r277.json": "e623241384dc326f5378292820c022ba",
"assets/assets/data/q-simple/r534.json": "b112aa7b8a47a95222e918332db60dae",
"assets/assets/data/q-simple/r423.json": "571f3376460b3d3faf66bd5da9fda86b",
"assets/assets/data/q-simple/r437.json": "4079d3b4569da97c8282d873aab441a1",
"assets/assets/data/q-simple/r192.json": "93bf9e6cf1b4c6f4192cd706b0d58415",
"assets/assets/data/q-simple/r53.json": "440e24fd33ba9e3c137a704dfa04bad4",
"assets/assets/data/q-simple/r48.json": "c234b89dbce268724e062d7d67c6e9ae",
"assets/assets/data/q-simple/r365.json": "f4dd94d5a26aead90f52fcd524a6af95",
"assets/assets/data/q-simple/r142.json": "ce7c8c91b25e8f59233a519b38e6dbeb",
"assets/assets/data/q-simple/r239.json": "64513b1c70cc623cae86dfcdc5143c7f",
"assets/assets/data/q-simple/r120.json": "2b64410eed3ceba6983c3922266291b7",
"assets/assets/data/q-simple/r182.json": "0c8fb977603264b90ad834f9e1fb703b",
"assets/assets/data/q-simple/r163.json": "051bb4ec39c41bf97274b3847d7e730b",
"assets/assets/data/q-simple/r264.json": "ecaa21d334b887d427f7463b1e98932d",
"assets/assets/data/q-simple/r108.json": "0a9aad65adb42af295462879c5e3aced",
"assets/assets/data/q-simple/r360.json": "d583f45ee8ea2c8dad6c6b2b91550ea7",
"assets/assets/data/q-simple/r465.json": "00b419043061b349a4b1f0f6fc15aa36",
"assets/assets/data/q-simple/r243.json": "8170ae33a92295b2e2dc184a70c0a5f1",
"assets/assets/data/q-simple/r394.json": "a2c2c5d183ce55e8f8de51a03db379df",
"assets/assets/data/q-simple/r202.json": "3c39cac3d8358c080e5c62596d3b9def",
"assets/assets/data/q-simple/r494.json": "b8be61509d07a7969339e88d5856d4eb",
"assets/assets/data/q-simple/r339.json": "08fc20582b7ea800a7dd5c3ae2b422d0",
"assets/assets/data/q-simple/r184.json": "1664d5b9e58f85cc54387ee090744c95",
"assets/assets/data/q-simple/r196.json": "9f66e14a942f1cd63ed773b4f1e12c19",
"assets/assets/data/q-simple/r266.json": "5a6d02d954ae0ea2f941a58b10be6988",
"assets/assets/data/q-simple/r208.json": "9bc72ee8ba6dabd08f4eed1fcd3f6836",
"assets/assets/data/q-simple/r93.json": "ffdcda7664125564e780f917572288ef",
"assets/assets/data/q-simple/r526.json": "b0b90eb992798990433bc2173e6ba83d",
"assets/assets/data/q-simple/r330.json": "0c4a3892333d2e873f706b664b4ca56f",
"assets/assets/data/q-simple/r130.json": "d8ca20ec8955abbec4424940ccc250a3",
"assets/assets/data/q-simple/r397.json": "3eb4dae0974e49045d5f24fbc4f6be04",
"assets/assets/data/q-simple/r527.json": "88a24a11b4c1f8c80ef920f0fa60d334",
"assets/assets/data/q-simple/r68.json": "6b10d15813803be0604b1d451b753517",
"assets/assets/data/q-simple/r56.json": "1aa8ab496ab416398326d50e5344d0ca",
"assets/assets/data/q-simple/r539.json": "6e644c4179cfc68f79695b6dba5cbb32",
"assets/assets/data/q-simple/r400.json": "4d4b2ec7d9765af51ab1e887b792f1e8",
"assets/assets/data/q-simple/r311.json": "06e25b7c56933b2f253ed53f5ec254fc",
"assets/assets/data/q-simple/r377.json": "8d428c11cb86d57a70162d0e1d9a8699",
"assets/assets/data/q-simple/r268.json": "29c2718ca42dc4e4e2d091c72e86a305",
"assets/assets/data/q-simple/r395.json": "4d3bc3d34eb9ddfde876a0354974b80f",
"assets/assets/data/q-simple/r125.json": "06ce0d2a6384163386484d0d44644aba",
"assets/assets/data/q-simple/r69.json": "61a92be0e43154eb4e5f9e3b467e39cc",
"assets/assets/data/q-simple/r169.json": "d774a0b713533cac2d2a3cd4b168eccb",
"assets/assets/data/q-simple/r545.json": "2dff8741808134d793a6eec11327ae07",
"assets/assets/data/q-simple/r301.json": "d97af7ec6f46054e3128831d6bdbe81b",
"assets/assets/data/q-simple/r72.json": "79bec04b5a57dcacdb13c1ea6727418c",
"assets/assets/data/q-simple/r326.json": "0b8eb17e68a7eb045c21f2aae7320477",
"assets/assets/data/q-simple/r254.json": "1d1497e3bda282dd64181c8ac570c32a",
"assets/assets/data/q-simple/r484.json": "84ff31ce1850d053c6e7e728e178129d",
"assets/assets/data/q-simple/r384.json": "03ee169d970482228911614a6f93a4a7",
"assets/assets/data/q-simple/r353.json": "25d2f50fd603145dfa4ce7f28e69493d",
"assets/assets/data/q-simple/r306.json": "2f91b4bf14a82c8f84ba1e5e9bbcf865",
"assets/assets/data/q-simple/r283.json": "524c5954f14e622ef8218e1a3a1c78dd",
"assets/assets/data/q-simple/r189.json": "d5660f127b77c34748ca65ea6511bc30",
"assets/assets/data/q-simple/r302.json": "5a640a1649c769633a9f21acaff3f8a5",
"assets/assets/data/q-simple/r513.json": "e2d3fce2a2278da4e7be74882e14eff9",
"assets/assets/data/q-simple/r390.json": "05c5449a536c337c09acb648947d8cf8",
"assets/assets/data/q-simple/r244.json": "7c48f07ab1c18634e8c0db0404f3348e",
"assets/assets/data/q-simple/r341.json": "3f67a00768a443108aaefbb836eba760",
"assets/assets/data/q-simple/r77.json": "660aff73a545ea004834ce9a434b5ee4",
"assets/assets/data/q-simple/r258.json": "5bd25096971295a51bf925f9b6cae861",
"assets/assets/data/q-simple/r505.json": "e63822602d40070f809f0bed6c84759f",
"assets/assets/data/q-simple/r296.json": "14de1dfc572413a48e10ba38472c163c",
"assets/assets/data/q-simple/r424.json": "8a1fff946b0ae01bbdca214cef444ccd",
"assets/assets/data/q-simple/r375.json": "5a561259142ee617a0c345df10c7de61",
"assets/assets/data/q-simple/r67.json": "28bc2d7a87a6f537a186cb058b160bfe",
"assets/assets/data/q-simple/r83.json": "4d5863652b887fe0a77cdc04d5c9d65e",
"assets/assets/data/q-simple/r543.json": "ead382e656b97db0ab18c98d201b88bb",
"assets/assets/data/q-simple/r318.json": "65294da9b4c483c0b2ffcacdf94e81b3",
"assets/assets/data/q-simple/r528.json": "6faf0ed9f9b8a03c4ee9e68881c44c03",
"assets/assets/data/q-simple/r116.json": "e9b0f3359564511082af0e1a098ac1b1",
"assets/assets/data/q-simple/r475.json": "6e3865712521e414a13e0baacee46212",
"assets/assets/data/q-simple/r174.json": "b7c3f437b240da65efc504597fbde766",
"assets/assets/data/q-simple/r414.json": "8dce41ca63fa9ae75470815451371835",
"assets/assets/data/q-simple/r373.json": "616e9ca8a0c99b6cc62d3669a179deb9",
"assets/assets/data/q-simple/r98.json": "881080bfa2ec52c702e235c610f355b9",
"assets/assets/data/q-simple/r430.json": "bf8dbbcf94d0ae3292c68b316ece32e9",
"assets/assets/data/q-simple/r157.json": "586ffd14bf5eec4fa7c98478a344e6aa",
"assets/assets/data/q-simple/r282.json": "cb79e4ba085571114a1b581326ae159a",
"assets/assets/data/q-simple/r126.json": "6fc8997d1ba022cf6fd7d4f1be75e7f4",
"assets/assets/data/q-simple/r146.json": "8dc096e98716704e1ccd47b26ba3f57b",
"assets/assets/data/q-simple/r519.json": "7a66ad64854f6ab1e715fbc189795548",
"assets/assets/data/q-simple/r295.json": "4e3697f55afcc4ba1e0ff181be895393",
"assets/assets/data/q-simple/r235.json": "6346faaaaffe217c2dd1c33041d335f3",
"assets/assets/data/q-simple/r206.json": "d613152839763bb348589a8dff1b8947",
"assets/assets/data/q-simple/r461.json": "1b00b052060872c7bfec48b09363aad6",
"assets/assets/data/q-simple/r55.json": "b9f64f7e121b028c78ebb959af03ef90",
"assets/assets/data/q-simple/r9.json": "a2f30a54eab26e73d9eb1fd7b400561a",
"assets/assets/data/q-simple/r237.json": "b05dc7d6354ce4535c85330203ddce4a",
"assets/assets/data/q-simple/r170.json": "990af6c7e03572f26b3e41cf18fad700",
"assets/assets/data/q-simple/r337.json": "0996b1d88fb71cde358128b90e99a0bb",
"assets/assets/data/q-simple/r350.json": "4dba5635cc1776f0dd951f273892f3b4",
"assets/assets/data/q-simple/r231.json": "448b5764f7c466d58b938dbf3543f87e",
"assets/assets/data/q-simple/r31.json": "5b4cafa17db867471a361d5001b5514a",
"assets/assets/data/q-simple/r401.json": "2adb2acbfa522982fd587951d5e0ec66",
"assets/assets/data/q-simple/r226.json": "f53b0fc705ae3e3e764d468cf6d15840",
"assets/assets/data/q-simple/r510.json": "d158c156b352f7d2d2fc79b28ad53e8a",
"assets/assets/data/q-simple/r211.json": "35398e7b7a8cb7eeb7bb0fd272d575ca",
"assets/assets/data/q-simple/r323.json": "fc1821d8c21f06354184559df4527c77",
"assets/assets/data/q-simple/r47.json": "d4019a35a4cde70d702dbd8684aa49e5",
"assets/assets/data/q-simple/r347.json": "9736be6ac95c53d162718a2d8bc0654d",
"assets/assets/data/q-simple/r261.json": "03e464ae82ba58dee72438f2d23ec581",
"assets/assets/data/q-simple/r138.json": "28e966071824b2ac114adbb89eb2372d",
"assets/assets/data/q-simple/r109.json": "e1cf2cdd79dce7be60e25da08121ccc7",
"assets/assets/data/q-simple/r486.json": "abae1976f55fc39aaa3b3fd277acc91d",
"assets/assets/data/q-simple/r141.json": "2fafbcd4c7869eec4fcf60fdbcb8e579",
"assets/assets/data/q-simple/r292.json": "752caaaf0be072ea1cea4783bbdeb6fa",
"assets/assets/data/q-simple/r256.json": "e05ca97763550558698243532898875a",
"assets/assets/data/q-simple/r332.json": "edb43581da3f7ef8cf2ced959e5d55c4",
"assets/assets/data/q-simple/r191.json": "cdc55b78d2c4c01c72aabd70f739941b",
"assets/assets/data/q-simple/r91.json": "09b9e12f52cdeb82b5249f19063da65b",
"assets/assets/data/q-simple/r14.json": "98412913e8dd3c34aeb76cf43b484511",
"assets/assets/data/q-simple/r363.json": "1ec8a603e6d8e4b6605b3c0d6d6b500a",
"assets/assets/data/q-simple/r2.json": "0dd131e380a416deb44073fb93ab0715",
"assets/assets/data/q-simple/r370.json": "0a01a3503f8facb562f2fce3ad08075a",
"assets/assets/data/q-simple/r422.json": "858089d864272109e41baa3ebeb07069",
"assets/assets/data/q-simple/r473.json": "8571c6a8d6184a51e6f5550e1596f94c",
"assets/assets/data/q-simple/r112.json": "964c464d90146f8a06357f6864366443",
"assets/assets/data/q-simple/r139.json": "83931095d9244d62c73fd5ffebb998c4",
"assets/assets/data/q-simple/r491.json": "888a91464ebe2d20cbada87eafef76a4",
"assets/assets/data/q-simple/r348.json": "16e936b60c9fc090217736be7aee5e10",
"assets/assets/data/q-simple/r148.json": "cbe53edfe73f24cf8183a36647cb2092",
"assets/assets/data/q-simple/r530.json": "32b398e14d3199ca9133e70a734b9c41",
"assets/assets/data/q-simple/r224.json": "da37d64302fe25f239d60e9a146bafe0",
"assets/assets/data/q-simple/r154.json": "87c78ba558f44a9da7a4fd91bb317f1b",
"assets/assets/data/q-simple/r209.json": "d56fb136b107497edd60c747333e5e72",
"assets/assets/data/q-simple/r446.json": "bad0fe7122a8b6d49237df932d686b6f",
"assets/assets/data/q-simple/r512.json": "3b7ce8e5525044ee3c80dcb852ded73e",
"assets/assets/data/q-simple/r551.json": "4b975443df575d0d68acb7b78512233f",
"assets/assets/data/q-simple/r229.json": "f98741d389e668e1d821ffc8ebd6a95c",
"assets/assets/data/q-simple/r90.json": "f5dbe388dc82b30c118ee1635a18f030",
"assets/assets/data/q-simple/r405.json": "b3c5a59fc90f2a60cd7dc344efb89aca",
"assets/assets/data/q-simple/r75.json": "5065446f0d15ba996a4c7ecf0ee02385",
"assets/assets/data/q-simple/r165.json": "754c8c9af35297f3d21e84a1e691ff4e",
"assets/assets/data/q-simple/r11.json": "6bd30db61d385c4f8d27530fd7da6245",
"assets/assets/data/q-simple/r205.json": "2d9bf02b6b4de052d5eaf0cf3e6ae798",
"assets/assets/data/q-simple/r113.json": "b9dae31e185850667b5a77ed55cb5d89",
"assets/assets/data/q-simple/r529.json": "97b0d46d665d4425e0a69bb1195bf5b4",
"assets/assets/data/q-simple/r173.json": "e802bd48d23b93144e9b541b4067fc4b",
"assets/assets/data/q-simple/r444.json": "4492bdffe9c1021156cc2abaf1076edf",
"assets/assets/data/q-simple/r449.json": "79705cf36928604325ece7ded397b241",
"assets/assets/data/q-simple/r78.json": "2d0ca6954d6eb5ad90d1f8b73571971e",
"assets/assets/data/q-simple/r29.json": "038725f4c8c061fb47e12e80536b13a9",
"assets/assets/data/q-simple/r508.json": "e3b83857f83077c4f3789edb34105793",
"assets/assets/data/q-simple/r203.json": "92d2d3a5fc411472dd5f449142c60c81",
"assets/assets/data/q-simple/r495.json": "c3a7ac6b46f03cdb8d6cd1163323a255",
"assets/assets/data/q-simple/r329.json": "6ab3a2a64ac096ce8b3b1c45872622e7",
"assets/assets/data/q-simple/r127.json": "0756602bffd7e97b532713d9be626280",
"assets/assets/data/q-simple/r443.json": "b7de5de32ed4bf6ecd8ed7968edcf3d0",
"assets/assets/data/q-simple/r4.json": "c93cbaa81ad0554f8149ded5a36a5c67",
"assets/assets/data/q-simple/r288.json": "7d13f53ecd50f690d5cfef8a8792a4e4",
"assets/assets/data/q-simple/r319.json": "c80c871297bb054c4e657704d8618174",
"assets/assets/data/q-simple/r546.json": "16f0821634649efb863f605df769cbf7",
"assets/assets/data/q-simple/r522.json": "5af5d4d7dbfd36e4250e548c9f512a91",
"assets/assets/data/q-simple/r33.json": "f0af8f68fb23d5b40a8dbc54f06481ac",
"assets/assets/data/q-simple/r285.json": "b2e411c5411ee422b8279e050705387b",
"assets/assets/data/q-simple/r385.json": "15682d69c4fc96672047ca981258f967",
"assets/assets/data/q-simple/r290.json": "67ace46cd829b5bf0a0cf83551830395",
"assets/assets/data/q-simple/r331.json": "71ff3fa741b88e38596a076988653185",
"assets/assets/data/q-simple/r485.json": "038c90226be147e4a814a9dbaa46b9c8",
"assets/assets/data/q-simple/r15.json": "3da56f3fc5c7e15a159eb9cf44b0d544",
"assets/assets/data/q-simple/r393.json": "6454c5c7d29bbfc8b50763209b26b33d",
"assets/assets/data/q-simple/r260.json": "b08e632e693a76d7a9904407071c9137",
"assets/assets/data/q-simple/r435.json": "482b7e02d1d7f1896473172414507e0c",
"assets/assets/data/q-simple/r276.json": "c52d08d2ab1c540dcfebf4805baff530",
"assets/assets/data/q-simple/r498.json": "5feeede1e2f27b21cf2d8d96cc13284a",
"assets/assets/data/q-simple/r409.json": "2d59d93e7921527fdcd7def1dec1dd83",
"assets/assets/data/q-simple/r344.json": "6c2e8402267ed9f02d9eac5a6803cb84",
"assets/assets/data/q-simple/r3.json": "ae43f16753bcf7c7da0f26467e4bc099",
"assets/assets/data/q-simple/r547.json": "055b602fe586d861a71145ee9b2542ee",
"assets/assets/data/q-simple/r32.json": "47689986dfb3953c6414eed31979ec36",
"assets/assets/data/q-simple/r280.json": "f137fd39a1a0e4c3c361ffbdd1277ac0",
"assets/assets/data/q-simple/r156.json": "997efb60fb424072bd016c931c6aad49",
"assets/assets/data/q-simple/r193.json": "4d6170382f2ced8d3e818c43474c3615",
"assets/assets/data/q-simple/r223.json": "e42d4bf17748cffaa0cf1fd06316158a",
"assets/assets/data/q-simple/r212.json": "0794fbcd23b147f82838109f36ba9aef",
"assets/assets/data/q-simple/r76.json": "e32c33b561d7e41f90fbbfd185e9ef2c",
"assets/assets/data/q-simple/r274.json": "9edd4806d15ff046fa8aa4dc5e43cd41",
"assets/assets/data/q-simple/r372.json": "5bc8806d7811df4dd82f56f7751657f2",
"assets/assets/data/q-simple/r313.json": "19380df3028bd693ee883789006a4a4e",
"assets/assets/data/q-simple/r417.json": "2c42a54fd8b35d0a753204c956d19fbe",
"assets/assets/data/q-simple/r107.json": "b91fbbf93fb423369860b060ea5bdb0b",
"assets/assets/data/q-simple/r99.json": "1da5a9bef792ad8794e0894105c13c37",
"assets/assets/data/q-simple/r434.json": "ec3991e1b4455b5e2f42876abc06c904",
"assets/assets/data/q-simple/r429.json": "9ed9aacde5e335321b156c4805bd4afc",
"assets/assets/data/q-simple/r472.json": "0328fcc9f4c1d9393fd3559e4d3a322f",
"assets/assets/data/q-simple/r59.json": "9897ab03d3be08d785db0fafe45d2f4a",
"assets/assets/data/q-simple/r325.json": "9706a5919ee529d9335ba86ae15f19b3",
"assets/assets/data/q-simple/r532.json": "4e8da3feaf00ccdc9ee245a41fa588c4",
"assets/assets/data/q-simple/r19.json": "89f2d5a8c27d560464f08a372dd96999",
"assets/assets/data/q-simple/r427.json": "239c0c79b1943237d171aca7eb9a5916",
"assets/assets/data/q-simple/r478.json": "b5edb7a36695446f17254cca569ec2af",
"assets/assets/data/q-simple/r124.json": "0f93c05efebbb478a8b08edb24d0b7c7",
"assets/assets/data/q-simple/r355.json": "05b183019a829f18a6b7b7c04d2f273c",
"assets/assets/data/q-simple/r135.json": "5e09708abd5452920b56827b1174429c",
"assets/assets/data/q-simple/r464.json": "2839eb97f76b47844b5757d79ff872a7",
"assets/assets/data/q-simple/r544.json": "04311b59be7cc8e1f1b24deae6438a26",
"assets/assets/data/q-simple/r92.json": "c630ed77af1ef0af84c6a5d8c119bd78",
"assets/assets/data/q-simple/r241.json": "06711bb0ad877cce12b33530fd584ad2",
"assets/assets/data/q-simple/r314.json": "521ee97ea73f2b611a4750232014779b",
"assets/assets/data/q-simple/r500.json": "45dcf7a416d2d5a3f37058e26daec087",
"assets/assets/data/q-simple/r26.json": "0699e2cbbcc28657df8e17a78dba308e",
"assets/assets/data/q-simple/r504.json": "b8cc6afbdd3d48a8f7ac7326df4c529b",
"assets/assets/data/q-simple/r273.json": "fcf28d24801795659c0f0a2a6ddfb54b",
"assets/assets/data/q-simple/r106.json": "8a2c6c7e3378484c4234125583f28ca8",
"assets/assets/data/q-simple/r537.json": "6b514118e31d0c5a89351840a1ecadeb",
"assets/assets/data/q-simple/r362.json": "54cf6ed2845496e287e4b4fde44515af",
"assets/assets/data/q-simple/r410.json": "105114feb3dc7fe641f930ece9873e70",
"assets/assets/data/q-simple/r439.json": "e7f4b45a4def350b0a54a6625fc55d80",
"assets/assets/data/q-simple/r265.json": "8fcdb16267186af6bbeb1635b77b003b",
"assets/assets/data/q-simple/r389.json": "cb4e9b379e9500565ae143a311c7a174",
"assets/assets/data/q-simple/r161.json": "69feed42fda56e1add6c24caad216e04",
"assets/assets/data/q-simple/r351.json": "ed39249b02f0329aeeba2c06f5680edb",
"assets/assets/data/q-simple/r448.json": "e1ad67ca86f97eb0fb9d9509077e11a0",
"assets/assets/data/q-simple/r286.json": "317c39ffd7e0e28454e5b495ff20c73e",
"assets/assets/data/q-simple/r359.json": "e860ca1b32b1ca0ee195d4e8e460ca2b",
"assets/assets/data/q-simple/r259.json": "cc2714176c999bd914cc89c928781456",
"assets/assets/data/q-simple/r438.json": "4a078f7f7ca8ab58871f8e3b4e848c89",
"assets/assets/data/q-simple/r164.json": "5754d23cf59ed4a1fbd7c4568f300c4c",
"assets/assets/data/q-simple/r35.json": "151ef44991bcc146a579c6fcf1a8c935",
"assets/assets/data/q-simple/r335.json": "9d2cba7865d37c56005b824c7abed9cc",
"assets/assets/data/q-simple/r553.json": "2463b867774afca318f56896f1aa0690",
"assets/assets/data/q-simple/r201.json": "093761d5c2fe050255850b5cc2f4315d",
"assets/assets/data/q-simple/r416.json": "36bd4ba2216dbd377af02155f5392f72",
"assets/assets/data/q-simple/r144.json": "06ab7524c37868a884165429eb255b89",
"assets/assets/data/q-simple/r425.json": "0d73e5a9c524cbb7548c5a1cde7fbd22",
"assets/assets/data/q-simple/r187.json": "db12bd9032eee258b8f7528c7eb2c448",
"assets/assets/data/q-simple/r131.json": "bb81a0bee07213d281c127d861fbb384",
"assets/assets/data/q-simple/r30.json": "44e8af14813e8756143efc48acc31d22",
"assets/assets/data/q-simple/r213.json": "60aaa820efc420914df1fe38bf9d9fd9",
"assets/assets/data/q-simple/r412.json": "9f3fb003ffc5b036f855748fccd4604a",
"assets/assets/data/q-simple/r531.json": "99bc705210b02be20c72513d3d1f8a68",
"assets/assets/data/q-simple/r24.json": "c8935dc19e8059102b478871e6b93f9d",
"assets/assets/data/q-simple/r480.json": "651f93b78e98aeadd81f25afad59371f",
"assets/assets/data/q-simple/r307.json": "d0fcfa6a9b7551a8adea0a6e0ab66cd7",
"assets/assets/data/q-simple/r150.json": "6acae43bc71588f843d9d9abd0ad0723",
"assets/assets/data/q-simple/r198.json": "5f4102ae5afa1e09faf78b693abb5b6e",
"assets/assets/data/q-simple/r79.json": "f08d1901d96b481b57fe1d006789edce",
"assets/assets/data/q-simple/r447.json": "779c5a824ac858efeb3cbb479beb03ae",
"assets/assets/data/q-simple/r140.json": "1d9ea6837474b1b51461795f7518eca7",
"assets/assets/data/q-simple/r525.json": "7bfaf4a8cb800ff1b544551605ebdf0f",
"assets/assets/data/q-simple/r450.json": "6c19f7e2bb7136074cf3f02c156693e8",
"assets/assets/data/q-simple/r315.json": "ee22699e8bcc73ed4abbc6baf1439c10",
"assets/assets/data/q-simple/r433.json": "5954133b84c54730237c94a60d807792",
"assets/assets/data/q-simple/r39.json": "e9475941d30698ea956c814298540980",
"assets/assets/data/q-simple/r536.json": "b4cf554fa154e90946923f51158b3b39",
"assets/assets/data/q-simple/r178.json": "b284cc33c5f6f85798289538c6622cb7",
"assets/assets/data/q-simple/r175.json": "89d13b543f93661fb757d4476677b5bf",
"assets/assets/data/q-simple/r200.json": "e410901513a95249e3e016f69c8764d7",
"assets/assets/data/q-simple/r492.json": "de08ec0854396337b62255228f96baf9",
"assets/assets/data/q-simple/r462.json": "b65be75562e75f27432d1a5b76a56d66",
"assets/assets/data/q-simple/r81.json": "85ceebc62d11d6093b9e4a27a5ea311d",
"assets/assets/data/q-simple/r293.json": "49d1a1f9706b28546bacc2c49d3c8e21",
"assets/assets/data/q-simple/r181.json": "09bbdfd090a3fc5d2c21d0f208bacde2",
"assets/assets/data/q-simple/r392.json": "a1950c8c2818d6ee2330fc1a6b8a5bf2",
"assets/assets/data/q-simple/r398.json": "c4c965b0e4cc82a423f47ba574ccd4c1",
"assets/assets/data/q-simple/r476.json": "5f6f791ad60d27d10c9d754f860325d2",
"assets/assets/data/q-simple/r34.json": "e32503417bf22a0b599a0f512b6327f0",
"assets/assets/data/q-simple/r219.json": "a9cf66e60f18664979500e53146c19c0",
"assets/assets/data/q-simple/r177.json": "0842ec1e2f0072551341065ac279e96b",
"assets/assets/data/q-simple/r210.json": "8ec3376fe830a653516b5c472651802a",
"assets/assets/data/q-simple/r503.json": "afdabf867913e90aa88df6029df371f8",
"assets/assets/data/q-simple/r255.json": "b2a28f8c0c124fa71f936c2d38999009",
"assets/assets/data/q-simple/r110.json": "e1b257e1fb56ec5715aa3934449d182f",
"assets/assets/data/q-simple/r489.json": "089cdab2a0ad33734eb4e1fa2003e3c0",
"assets/assets/data/q-simple/r45.json": "2c9601a3da172822a69271cae8215d3f",
"assets/assets/data/q-simple/r220.json": "b838d2a69238bd9c4d40aa001243a5f6",
"assets/assets/data/q-simple/r404.json": "830ec553dbb8e629795f919f21c31af1",
"assets/assets/data/q-simple/r538.json": "4702551562dcbf6502c32dd85ca2c919",
"assets/assets/data/q-simple/r17.json": "ad0911f365148591370e10bbaff1cc8e",
"assets/assets/data/q-simple/r428.json": "0fa36fb042a5d6c9d54e4851c2072ce5",
"assets/assets/data/q-simple/r460.json": "1195773f15ddb91a50e459023f594eb0",
"assets/assets/data/q-simple/r349.json": "b2a9359ccbbe295e947492937a6bde1a",
"assets/assets/data/q-simple/r52.json": "48a62bf226c14b06543107cd48575809",
"assets/assets/data/q-simple/r436.json": "9c512f4399c09ab951f90ac169794299",
"assets/assets/data/q-simple/r36.json": "ee3faf48dbb15d821140f3c60cd0f69a",
"assets/assets/data/q-simple/r114.json": "62fa7119105dfd893ebaf7ef8e7151f0",
"assets/assets/data/q-simple/r227.json": "2fd9c77687a36d7d5fa212ea8e8db2e7",
"assets/assets/data/q-simple/r322.json": "937567e7d3a9833915b05d2e5a778fbf",
"assets/assets/data/q-simple/r308.json": "70a773507eb57978405af27008f129dd",
"assets/assets/data/q-simple/r317.json": "f0e4314bd57d9232d16b426902848e10",
"assets/assets/data/q-simple/r236.json": "2bf72c86597a00e024f18b35b46bae3f",
"assets/assets/data/q-simple/r354.json": "a16b3822aabefe50826d492db6a8057c",
"assets/assets/data/q-simple/r367.json": "7af9e330c0b612e527556f7087ed52ae",
"assets/assets/data/q-simple/r62.json": "30a6079028ad76b405a6fe1524c345fe",
"assets/assets/data/q-simple/r550.json": "ab9dfb9ca0cda0251212d5f63303bc85",
"assets/assets/data/q-simple/r371.json": "098b82992eca4f0b4953dec832310213",
"assets/assets/data/q-simple/r309.json": "84161d0a16e5f1cff5ce947f7361b337",
"assets/assets/data/q-simple/r333.json": "2cbde2913d4d7c5479a81851b786f158",
"assets/assets/data/q-simple/r441.json": "442c1f68ff14591a7d93d66da52f324c",
"assets/assets/data/q-simple/r502.json": "4ae65234190bb395ca1574d9ab169cc5",
"assets/assets/data/q-simple/r8.json": "034bd693200ae779b2d39a378b711f8f",
"assets/assets/data/q-simple/r396.json": "61450bf09f407a5ad2f6bd9fe1da0cea",
"assets/assets/data/q-simple/r552.json": "9fda96d24e1ac65bed9a518b0c19dd90",
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
"assets/assets/l10n/app_en.arb": "4eddcbea837fdaaa318e23b4c53e1a02",
"assets/NOTICES": "801428afa617838d0e6b84a7926db8b0",
"assets/AssetManifest.bin": "4cac625cc7b2b4494cf965b2331af19c",
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
