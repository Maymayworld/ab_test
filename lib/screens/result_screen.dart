import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/companies_data.dart';
import '../models/company.dart';
import '../providers/answer_provider.dart';
import 'home_screen.dart';

class ResultScreen extends HookConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTags = ref.watch(userTagsProvider);

    // タグ名の日本語マップ
    final tagNameMap = {
  // WorkStyle
  'remote_high': 'リモート推奨',
  'hybrid': 'ハイブリッド',
  'on_site': '現場重視',
  'flex_free': 'フルフレックス',
  'coretime': 'コアタイム有',
  'structured': '構造化された環境',
  
  // Value
  'work_priority': '仕事優先',
  'worklife_balance': 'ワークライフバランス',
  'growth_priority': '成長重視',
  'speed': 'スピード重視',
  'calm': '落ち着いた環境',
  
  // Compensation
  'high': '高給与',
  'mid': '平均給与',
  'passion': 'やりがい重視',
  'income_priority': '収入重視',
  'benefits_strong': '福利厚生充実',
  'minimal_benefits': '最低限の福利厚生',
  
  // Phase
  'growth': '急成長',
  'stability': '安定',
  'challenge': '挑戦',
  'early': '創業期',
  'public': '上場企業',
  
  // Culture
  'innovative': '革新的',
  'conservative': '保守的',
  'flat': 'フラット組織',
  'hierarchy': '階層型組織',
  'teamwork': 'チームワーク',
  'individual': '個人主義',
  'merit_based': '実力主義',
  'casual': 'カジュアル',
  'formal': 'フォーマル',
  'customer_first': '顧客第一',
  'product_first': 'プロダクト第一',
  
  // Size
  'large': '大企業',
  'small': 'ベンチャー',
  'brand': 'ブランド重視',
  'nonbrand': 'ブランド不問',
  
  // Global
  'global': 'グローバル',
  'domestic_only': '国内のみ',
  
  // Mission
  'social_impact': '社会貢献',
  'business_focus': 'ビジネス重視',
  
  // Function
  'product': 'プロダクト開発',
  'sales': '営業・対人',
  'creative': 'クリエイティブ',
  'nonproduct': '非開発',
  'nonsales': '非営業',
  'noncreative': '非クリエイティブ',
};

    // 類似度を計算してソート
    final rankedCompanies = companies.map((company) {
      final similarity = company.calculateSimilarity(userTags);
      final topTags = company.getTopMatchTags(userTags, 2);
      return MapEntry(company, {'similarity': similarity, 'topTags': topTags});
    }).toList()
      ..sort((a, b) => (b.value['similarity'] as double)
          .compareTo(a.value['similarity'] as double));

    final topMatch = rankedCompanies.first;
    final topCompany = topMatch.key;
    final topSimilarity = topMatch.value['similarity'] as double;
    final topMatchTags = topMatch.value['topTags'] as List<String>;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ヘッダー
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'あなたへのレコメンド',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ref.read(answersProvider.notifier).state = {};
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text(
                        'やり直す',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // トップマッチカード
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // No.1バッジ
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade400,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'No.1 Match',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          topCompany.industry,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        topCompany.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${(topSimilarity * 100).round()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              topCompany.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // マッチ理由
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MATCH REASON',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    topMatchTags.length >= 2
                                        ? '「${tagNameMap[topMatchTags[0]]}」と「${tagNameMap[topMatchTags[1]]}」を重視するあなたに最適です。'
                                        : topMatchTags.isNotEmpty
                                            ? '「${tagNameMap[topMatchTags[0]]}」を重視するあなたに最適です。'
                                            : 'あなたの価値観に合った企業です。',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade900,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // タグ表示
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: topCompany.tags.entries
                                  .where((e) => e.value >= 4)
                                  .take(4)
                                  .map((e) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '#${tagNameMap[e.key] ?? e.key}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // その他の候補
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'その他の候補',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),

            // その他の企業リスト
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry = rankedCompanies[index + 1];
                  final company = entry.key;
                  final similarity = entry.value['similarity'] as double;
                  final percentage = (similarity * 100).round();

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 2}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    company.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'マッチ度 $percentage%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                      Text(
                                        ' | ${company.industry}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade300,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: rankedCompanies.length > 5 ? 4 : rankedCompanies.length - 1,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}