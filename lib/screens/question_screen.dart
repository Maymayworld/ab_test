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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
              : Center(
                  child: SizedBox(
                    height: 380, // カード高さ300 + マージン80
                    child: AppinioSwiper(
                      controller: controller,
                      cardCount: questions.length,
                      onSwipeEnd: (previousIndex, targetIndex, activity) {
                        final question = questions[previousIndex];
                        final answers = ref.read(answersProvider.notifier);

                        if (activity.direction == AxisDirection.right) {
                          // 右スワイプ = はい (1)
                          answers.update((state) => {
                                ...state,
                                question.id: 1,
                              });
                        } else if (activity.direction == AxisDirection.left) {
                          // 左スワイプ = いいえ (0)
                          answers.update((state) => {
                                ...state,
                                question.id: 0,
                              });
                        }
                        // 上下のスワイプはスキップ(何も記録しない)

                        // 最後の質問をスワイプした場合
                        if (previousIndex == questions.length - 1) {
                          // 全ての質問が終了
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
      ),
    );
  }
}