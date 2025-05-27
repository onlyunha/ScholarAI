/// =============================================================
/// File : home_tab.dart
/// Desc : 기본 메인 탭
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-05-07
/// =============================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_urls.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // 1️⃣ 장학금 꿀팁 배너 - PageView 방식
          SizedBox(
            height: 270,
            child: PageView(
              controller: PageController(viewportFraction: 0.85),
              children: const [
                TipCard(
                  imagePath: AppImages.homeCard1,
                  link: AppUrls.homeCard1,
                ),
                TipCard(
                  imagePath: AppImages.homeCard2,
                  link: AppUrls.homeCard2,
                ),
                TipCard(
                  imagePath: AppImages.homeCard3,
                  link: AppUrls.homeCard3,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2️⃣ 아래 2/3 구간
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // 튜토리얼 바로가기 (왼쪽)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🎓 튜토리얼 바로가기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 마감 임박 장학금 (오른쪽)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '⏰ 마감 임박 장학금',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// 💡 장학금 꿀팁 카드
class TipCard extends StatelessWidget {
  final String imagePath;
  final String? link;

  const TipCard({super.key, required this.imagePath, this.link});

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child:
            link != null
                ? GestureDetector(
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(link!))) {
                      await launchUrl(Uri.parse(link!));
                    }
                  },
                  child: card,
                )
                : card,
      ),
    );
  }
}
