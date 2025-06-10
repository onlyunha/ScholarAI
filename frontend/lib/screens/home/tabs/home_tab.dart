/// =============================================================
/// File : home_tab.dart
/// Desc : 기본 메인 탭
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-04-19
/// Updt : 2025-06-08
/// =============================================================
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholarai/constants/app_colors.dart';
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
                // TipCard(
                //   imagePath: AppImages.homeCard3,
                //   link: AppUrls.homeCard3,
                // ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Text(
                  '더 알아보기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
          ),
          // 2️⃣ 아래 2/3 구간
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _WideBanner(
                  title: '튜토리얼 바로가기',
                  subtitle: '앱 사용법을 처음부터 알려드려요',
                  icon: (Icons.school),
                  onTap: () => context.push('/onboarding'),
                ),
                const SizedBox(height: 5),
                _WideBanner(
                  title: '학교별 장학금',
                  subtitle: '내 학교 맞춤 장학금 정보 확인',
                  icon: Icons.account_balance,
                  onTap: () async {
                    final url = Uri.parse(AppUrls.homeCard3);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      ); // 🔗 외부 브라우저
                    } else {
                      debugPrint('❌ 링크 열기 실패: $url');
                    }
                  },
                ),
              ],
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

class _WideBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _WideBanner({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: kPrimaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
