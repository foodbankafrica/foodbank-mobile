import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';

class ReleaseNotesContentPage extends StatelessWidget {
  static String name = 'release-notes-content';
  static String route = '/release-notes-content';
  const ReleaseNotesContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Release Notes',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s New',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Wallets',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 215,
                    width: double.infinity,
                    color: const Color(0xFFFFECE5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 21, vertical: 48),
                    child: Container(
                      height: 119,
                      width: 316,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFFFFFFF),
                      ),
                      child: Column(
                        children: [
                          Text('Available Balance',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF000000))),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: '₦10,000',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            color: const Color(0xFF98A2B3)),
                                    children: [
                                      TextSpan(
                                          text: '.00',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontSize: 20,
                                                  color:
                                                      const Color(0xFF98A2B3))),
                                    ]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 24,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF101928)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xFF98A2B3),
                                  size: 18,
                                ),
                                Text(
                                  ' Fund Wallet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontSize: 12,
                                          color: const Color(0xFF98A2B3)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Praesent vel velit eget urna tincidunt semper. Suspendisse lacus tellus, fringilla a euismod et, fringilla quis eros. Maecenas ultricies ac libero nec hendrerit. Integer sit amet neque a lorem ullamcorper dignissim vitae eu velit. Mauris et volutpat arcu. In commodo libero ut lectus porta, et semper tortor feugiat. Sed sit amet sagittis eros. Maecenas eleifend commodo tortor. Integer accumsan, ex varius pharetra vulputate, quam dolor congue justo, sit amet aliquet magna urna et sapien. Morbi consequat laoreet eros, vitae rhoncus ligula feugiat et. Aliquam tortor odio, tincidunt vitae hendrerit id, mattis ac elit. Nunc pharetra auctor augue. Cras eget est sit amet lacus pellentesque laoreet. Sed et interdum nisl, quis tristique libero. Vivamus id quam vitae est blandit dignissim sed feugiat eros. Donec quis lorem finibus, semper arcu eget, fringilla ligula. Fusce fermentum et ipsum sed tristique. Pellentesque augue ante, faucibus at pellentesque sit amet, consequat eu nisi. Nullam vulputate erat in bibendum malesuada. Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse turpis velit, suscipit sed eros sed, venenatis pellentesque elit. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam facilisis magna nec sapien sagittis aliquet. Aliquam felis est, posuere eu sem et, suscipit placerat sapien. In tristique urna risus, in ornare magna dictum in. Donec facilisis risus non erat sagittis faucibus. In dolor libero, ultrices vel venenatis nec, sollicitudin non est. In lobortis sem ut velit laoreet facilisis in vitae leo. Cras ultrices tellus sollicitudin arcu rhoncus, at facilisis tortor molestie. Vivamus leo erat, ultrices ut mattis quis, bibendum nec nisi. Etiam tempor tortor eget metus rutrum, sit amet bibendum magna pulvinar. Donec non fringilla dui, vitae dapibus tortor. Vestibulum vehicula id tortor a pellentesque. Donec cursus tincidunt tortor vitae mollis. Donec dui ligula, efficitur convallis justo non, rutrum auctor justo. Donec ac sem at ipsum lobortis gravida quis id ex. Ut a mauris luctus, porta nisl eget, scelerisque enim. Praesent quis dolor eu augue porta hendrerit eget at est. Pellentesque est nunc, tempor non vestibulum sit amet, varius vel ex. Praesent pharetra, lectus quis finibus iaculis, velit orci convallis nibh, ac molestie quam sem ac massa. Nullam efficitur odio quis risus elementum finibus. Nullam tristique eleifend convallis. Sed ullamcorper accumsan libero ac tempus. Nulla placerat faucibus diam, a dictum massa.  Fusce sed aliquet leo. Ut viverra luctus purus sed posuere.',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
