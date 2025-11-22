import 'package:hooks_riverpod/hooks_riverpod.dart';

// 質問IDとYes/Noの回答を管理
final answersProvider = StateProvider<Map<String, int>>((ref) => {});

// ユーザーのタグスコアを計算するプロバイダー
final userTagsProvider = Provider<Map<String, int>>((ref) {
  final answers = ref.watch(answersProvider);
  final tags = <String, int>{};
  
  void addTag(String tag, int weight) {
    tags[tag] = (tags[tag] ?? 0) + weight;
  }
  
  // 各質問の回答に基づいてタグスコアを計算
  answers.forEach((questionId, answer) {
    switch (questionId) {
      case 'Q01': // リモート中心の働き方に魅力を感じる
        answer == 1 ? addTag('remote_high', 3) : addTag('on_site', 3);
        break;
      case 'Q02': // 自分のペースで進められる業務環境が合う
        answer == 1 ? addTag('flex_free', 3) : addTag('structured', 3);
        break;
      case 'Q03': // フルフレックス（コアタイムなし）の働き方が良い
        answer == 1 ? addTag('flex_free', 3) : addTag('coretime', 3);
        break;
      case 'Q04': // 週2〜3日の出社なら許容できる
        answer == 1 ? addTag('hybrid', 3) : addTag('remote_high', 3);
        break;
      case 'Q05': // 仕事は人生の中心にある方が良い
        answer == 1 ? addTag('work_priority', 3) : addTag('worklife_balance', 3);
        break;
      case 'Q06': // 定時退社より成長できる環境を優先したい
        answer == 1 ? addTag('growth_priority', 3) : addTag('stability', 3);
        break;
      case 'Q07': // 休日は仕事のことを忘れてリフレッシュしたい
        answer == 1 ? addTag('worklife_balance', 3) : addTag('work_priority', 3);
        break;
      case 'Q08': // 忙しい環境の方が充実感を感じる
        answer == 1 ? addTag('speed', 3) : addTag('calm', 3);
        break;
      case 'Q09': // 給与・待遇の良さを重視したい
        answer == 1 ? addTag('high', 3) : addTag('mid', 3);
        break;
      case 'Q10': // 給与が平均でも好きな仕事を選びたい
        answer == 1 ? addTag('passion', 3) : addTag('income_priority', 3);
        break;
      case 'Q11': // 福利厚生の充実を重視したい
        answer == 1 ? addTag('benefits_strong', 3) : addTag('minimal_benefits', 3);
        break;
      case 'Q12': // お金よりも仕事のやりがいがモチベーションになる
        answer == 1 ? addTag('passion', 3) : addTag('income_priority', 3);
        break;
      case 'Q13': // 急成長企業でチャレンジしたい
        answer == 1 ? addTag('growth', 3) : addTag('stability', 3);
        break;
      case 'Q14': // 安定した会社で働きたい
        answer == 1 ? addTag('stability', 3) : addTag('growth', 3);
        break;
      case 'Q15': // 変化が多い環境に魅力を感じる
        answer == 1 ? addTag('challenge', 3) : addTag('calm', 3);
        break;
      case 'Q16': // 多少リスクがあっても挑戦したい
        answer == 1 ? addTag('challenge', 3) : addTag('stability', 3);
        break;
      case 'Q17': // 革新的で変化を歓迎する社風が好き
        answer == 1 ? addTag('innovative', 3) : addTag('conservative', 3);
        break;
      case 'Q18': // フラットな組織が働きやすい
        answer == 1 ? addTag('flat', 3) : addTag('hierarchy', 3);
        break;
      case 'Q19': // チームワークを重視する組織が良い
        answer == 1 ? addTag('teamwork', 3) : addTag('individual', 3);
        break;
      case 'Q20': // 実力主義の環境の方が向いている
        answer == 1 ? addTag('merit_based', 3) : addTag('teamwork', 3);
        break;
      case 'Q21': // 自由でカジュアルな雰囲気が好き
        answer == 1 ? addTag('casual', 3) : addTag('formal', 3);
        break;
      case 'Q22': // 大企業で働きたい
        answer == 1 ? addTag('large', 3) : addTag('small', 3);
        break;
      case 'Q23': // ベンチャーの少数精鋭環境を選びたい
        answer == 1 ? addTag('small', 3) : addTag('large', 3);
        break;
      case 'Q24': // 研修が整った環境が良い
        answer == 1 ? addTag('stability', 3) : addTag('challenge', 3);
        break;
      case 'Q25': // 有名企業/大企業のネームバリューを重視したい
        answer == 1 ? addTag('brand', 3) : addTag('nonbrand', 3);
        break;
      case 'Q26': // 海外案件や駐在に興味がある
        answer == 1 ? addTag('global', 3) : addTag('domestic_only', 3);
        break;
      case 'Q27': // 社会課題の解決に関わる仕事に興味がある
        answer == 1 ? addTag('social_impact', 3) : addTag('business_focus', 3);
        break;
      case 'Q28': // 顧客に深く寄り添う仕事をしたい
        answer == 1 ? addTag('customer_first', 3) : addTag('product_first', 3);
        break;
      case 'Q29': // 裁量が大きい環境で働きたい
        answer == 1 ? addTag('early', 3) : addTag('public', 3);
        break;
      case 'Q30': // プロダクト開発/データ領域に関わりたい
        answer == 1 ? addTag('product', 3) : addTag('nonproduct', 3);
        break;
      case 'Q31': // 営業/コンサル/CSなど対人業務に強みがある
        answer == 1 ? addTag('sales', 3) : addTag('nonsales', 3);
        break;
      case 'Q32': // クリエイティブ（デザイン/編集/映像）に関わりたい
        answer == 1 ? addTag('creative', 3) : addTag('noncreative', 3);
        break;
    }
  });
  
  return tags;
});