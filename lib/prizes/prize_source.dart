abstract class PrizeSource {
  Future<List<PrizeSourceItem>> fetchItems();
}

class PrizeSourceItem {
  const PrizeSourceItem({
    required this.title,
    required this.workTitle,
    required this.characterName,
    required this.seriesName,
    required this.maker,
    required this.releaseText,
    this.releaseYear,
    this.releaseMonth,
    this.sourceUrl,
    this.imageUrl,
  });

  final String title;
  final String workTitle;
  final String characterName;
  final String seriesName;
  final String maker;
  final String releaseText;
  final int? releaseYear;
  final int? releaseMonth;
  final String? sourceUrl;
  final String? imageUrl;
}

class SamplePrizeSource implements PrizeSource {
  const SamplePrizeSource();

  @override
  Future<List<PrizeSourceItem>> fetchItems() async {
    return const [
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Aqua Float Girls \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{30e9}\u{30e9}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e9}\u{30e9}',
        seriesName: 'Aqua Float Girls',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}5\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 5,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0452036800',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/bfdd698a-de04-475a-b4c7-0510ded9e3c8_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{30e2}\u{30e2}\u{ff5e}\u{30eb}\u{30fc}\u{30e0}\u{30a6}\u{30a7}\u{30a2}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e2}\u{30e2}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}5\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 5,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0452036900',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/1607416d-b053-4d17-91cd-7d94e64d250a_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} BiCute Bunnies Figure\u{30fc}\u{30e2}\u{30e2}\u{30fb}\u{30d9}\u{30ea}\u{30a2}\u{30fb}\u{30c7}\u{30d3}\u{30eb}\u{30fc}\u{30af}white ver.\u{30fc}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e2}\u{30e2}',
        seriesName: 'BiCute Bunnies',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}5\u{6708} \u{7b2c}4\u{9031}',
        releaseYear: 2026,
        releaseMonth: 5,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=16028',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/18461_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{91d1}\u{8272}\u{306e}\u{95c7}\u{ff5e}\u{30c1}\u{30e3}\u{30a4}\u{30ca}\u{30c9}\u{30ec}\u{30b9}ver.\u{ff5e}Renewal',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{91d1}\u{8272}\u{306e}\u{95c7}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}4\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 4,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0452027900',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/03c54252-dd66-4fb6-a57b-47f3a0283989_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} BiCute Bunnies Figure\u{2015}\u{91d1}\u{8272}\u{306e}\u{95c7}\u{2015}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{91d1}\u{8272}\u{306e}\u{95c7}',
        seriesName: 'BiCute Bunnies',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}4\u{6708} \u{7b2c}2\u{9031}',
        releaseYear: 2026,
        releaseMonth: 4,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15815',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/18140_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Trio-Try-iT Figure\u{30fc}\u{7d50}\u{57ce}\u{7f8e}\u{67d1}\u{30fc}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{7d50}\u{57ce}\u{7f8e}\u{67d1}',
        seriesName: 'Trio-Try-iT',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}4\u{6708} \u{7b2c}2\u{9031}',
        releaseYear: 2026,
        releaseMonth: 4,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15814',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/18139_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{897f}\u{9023}\u{5bfa}\u{6625}\u{83dc}\u{ff5e}\u{30c1}\u{30e3}\u{30a4}\u{30ca}\u{30c9}\u{30ec}\u{30b9}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{897f}\u{9023}\u{5bfa}\u{6625}\u{83dc}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}3\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 3,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0452014500',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/2a38ce37-2aaa-4ebe-bf4f-c80d027e0a98_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Aqua Float Girls \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{30e2}\u{30e2}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e2}\u{30e2}',
        seriesName: 'Aqua Float Girls',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}3\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 3,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0452014400',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/6699f430-3673-4da5-87f2-e1ec294ef8d8_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Trio-Try-iT Figure\u{2015}\u{30e2}\u{30e2}\u{30fb}\u{30d9}\u{30ea}\u{30a2}\u{30fb}\u{30c7}\u{30d3}\u{30eb}\u{30fc}\u{30af}\u{2015}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e2}\u{30e2}',
        seriesName: 'Trio-Try-iT',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}3\u{6708} \u{7b2c}3\u{9031}',
        releaseYear: 2026,
        releaseMonth: 3,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15681',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/17970_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{53e4}\u{624b}\u{5ddd}\u{552f}\u{ff5e}\u{30eb}\u{30fc}\u{30e0}\u{30a6}\u{30a7}\u{30a2}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{53e4}\u{624b}\u{5ddd}\u{552f}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}2\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 2,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451997100',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/488c6437-883d-4f52-bfd5-ab7531b36874_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Trio-Try-iT Figure\u{2015}\u{30e9}\u{30e9}\u{30fb}\u{30b5}\u{30bf}\u{30ea}\u{30f3}\u{30fb}\u{30c7}\u{30d3}\u{30eb}\u{30fc}\u{30af}\u{2015}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e9}\u{30e9}',
        seriesName: 'Trio-Try-iT',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}2\u{6708} \u{7b2c}3\u{9031}',
        releaseYear: 2026,
        releaseMonth: 2,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15517',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/17697_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Trio-Try-iT Figure\u{2015}\u{53e4}\u{624b}\u{5ddd}\u{552f}\u{2015}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{53e4}\u{624b}\u{5ddd}\u{552f}',
        seriesName: 'Trio-Try-iT',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2026\u{5e74}2\u{6708} \u{7b2c}3\u{9031}',
        releaseYear: 2026,
        releaseMonth: 2,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15516',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/17696_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Aqua Float Girls \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{7d50}\u{57ce}\u{7f8e}\u{67d1}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{7d50}\u{57ce}\u{7f8e}\u{67d1}',
        seriesName: 'Aqua Float Girls',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}1\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 1,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451992700',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/ba25c024-ae95-4691-b7ac-aa60d81ba974_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{30ca}\u{30ca}\u{ff5e}\u{30c1}\u{30e3}\u{30a4}\u{30ca}\u{30c9}\u{30ec}\u{30b9}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30ca}\u{30ca}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2026\u{5e74}1\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2026,
        releaseMonth: 1,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451993200',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/23cfc56b-2d83-42d1-99ff-bdd85ba2da68_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{30e9}\u{30e9}\u{ff5e}\u{30eb}\u{30fc}\u{30e0}\u{30a6}\u{30a7}\u{30a2}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e9}\u{30e9}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2025\u{5e74}12\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2025,
        releaseMonth: 12,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451971500',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/a2f82b2f-c752-4c46-8207-d0e3b2bd8262_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} BiCute Bunnies Figure\u{30fc}\u{30e2}\u{30e2}\u{30fb}\u{30d9}\u{30ea}\u{30a2}\u{30fb}\u{30c7}\u{30d3}\u{30eb}\u{30fc}\u{30af}\u{30fc}',
        workTitle:
            'To LOVE\u{308b}\u{ff0d}\u{3068}\u{3089}\u{3076}\u{308b}\u{ff0d}\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{30e2}\u{30e2}',
        seriesName: 'BiCute Bunnies',
        maker: '\u{30d5}\u{30ea}\u{30e5}\u{30fc}',
        releaseText: '2025\u{5e74}12\u{6708} \u{7b2c}3\u{9031}',
        releaseYear: 2025,
        releaseMonth: 12,
        sourceUrl: 'https://charahiroba.com/prize/item/detail?id=15153',
        imageUrl:
            'https://file.charahiroba.com/img/trans/contents/18460_p_thu.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{91d1}\u{8272}\u{306e}\u{95c7}\u{ff5e}\u{30eb}\u{30fc}\u{30e0}\u{30a6}\u{30a7}\u{30a2}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{91d1}\u{8272}\u{306e}\u{95c7}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2025\u{5e74}11\u{6708}\u{4e0b}\u{65ec}',
        releaseYear: 2025,
        releaseMonth: 11,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451955000',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/726d90df-87a2-4cd7-8da5-90049aefba35_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{7d50}\u{57ce}\u{7f8e}\u{67d1}\u{ff5e}\u{30c1}\u{30e3}\u{30a4}\u{30ca}\u{30c9}\u{30ec}\u{30b9}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{7d50}\u{57ce}\u{7f8e}\u{67d1}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2025\u{5e74}10\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2025,
        releaseMonth: 10,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451947500',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/845df675-3cf4-4f86-a747-319fb1ae13d9_p_01_ja.jpg',
      ),
      PrizeSourceItem(
        title:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9} Desktop Cute \u{30d5}\u{30a3}\u{30ae}\u{30e5}\u{30a2} \u{53e4}\u{624b}\u{5ddd}\u{552f}\u{ff5e}\u{30c1}\u{30e3}\u{30a4}\u{30ca}\u{30c9}\u{30ec}\u{30b9}ver.\u{ff5e}',
        workTitle:
            'To LOVE\u{308b}-\u{3068}\u{3089}\u{3076}\u{308b}-\u{30c0}\u{30fc}\u{30af}\u{30cd}\u{30b9}',
        characterName: '\u{53e4}\u{624b}\u{5ddd}\u{552f}',
        seriesName: 'Desktop Cute',
        maker: '\u{30bf}\u{30a4}\u{30c8}\u{30fc}',
        releaseText: '2025\u{5e74}7\u{6708}\u{4e2d}\u{65ec}',
        releaseYear: 2025,
        releaseMonth: 7,
        sourceUrl: 'https://www.taito.co.jp/taito-prize/0451904800',
        imageUrl:
            'https://www.taito.co.jp/Content/images/zone/2/item/201407/c76cea0a-43a5-48ba-acc8-fb8d518ab72b_p_01_ja.jpg',
      ),
    ];
  }
}
