import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../data/questions_data.dart';
import '../providers/answer_provider.dart';
import '../widgets/swipe_card.dart';
import 'result_screen.dart';

class QuestionScreen extends HookConsumerWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => AppinioSwiperController());
    final currentIndex = useState(0);
    final isCompleted = useState(false);

    // プログレス計算
    final progress = (currentIndex.value / questions.length) * 100;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade600,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: isCompleted.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '全ての質問に\n回答しました!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ResultScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                        child: const Text(
                          '結果を見る',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // プログレスバー
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 8,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Q${currentIndex.value + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                '${questions.length}問',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // スワイプエリア
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 380,
                          child: AppinioSwiper(
                            controller: controller,
                            cardCount: questions.length,
                            onSwipeEnd: (previousIndex, targetIndex, activity) {
                              final question = questions[previousIndex];
                              final answers = ref.read(answersProvider.notifier);

                              if (activity.direction == AxisDirection.right) {
                                answers.update((state) => {
                                      ...state,
                                      question.id: 1,
                                    });
                              } else if (activity.direction == AxisDirection.left) {
                                answers.update((state) => {
                                      ...state,
                                      question.id: 0,
                                    });
                              }

                              if (previousIndex == questions.length - 1) {
                                isCompleted.value = true;
                              } else if (targetIndex != null) {
                                currentIndex.value = targetIndex;
                              }
                            },
                            cardBuilder: (context, index) {
                              return SwipeCard(
                                question: questions[index].text,
                                questionNumber: index + 1,
                                totalQuestions: questions.length,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // ヒントテキスト
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        '直感でスワイプしてください',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}