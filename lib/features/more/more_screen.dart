import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class _MoreItem {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  const _MoreItem({
    required this.imagePath,
    required this.label,
    this.onTap,
  });
}

class MoreBody extends StatelessWidget {
  const MoreBody({super.key});

  static final _items = [
    _MoreItem(
      imagePath: 'assets/MoreAssets/medical-records 1.png',
      label: 'My Health Records',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/life-insurance 1.png',
      label: 'Insurance Information',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/experiment-results 1.png',
      label: 'Lab Results',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/allergies 1.png',
      label: 'Allergies & Conditions',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/apple 1.png',
      label: 'Diet&Lifestyle Guides',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/book (1) 1.png',
      label: 'Educational Resources',
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/stack 1.png',
      label: "Tools & Integration's",
    ),
    _MoreItem(
      imagePath: 'assets/MoreAssets/support 1.png',
      label: 'Support & Legal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Center(
            child: Text(
              'More',
              style: AppTextStyles.h6SB.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 198 / 111,
              ),
              itemBuilder: (_, i) => _MoreCard(item: _items[i]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _MoreCard extends StatelessWidget {
  final _MoreItem item;
  const _MoreCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        height: 111,
        width: 198,
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.surfaceBorder.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 33,
              height: 33,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              item.label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight(500),
                  letterSpacing: -0.32,
                  color: Color(0xFFF3F3F3)),
              maxLines: 1,
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
