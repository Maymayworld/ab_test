import 'package:hooks_riverpod/hooks_riverpod.dart';

// ユーザーの回答を管理するStateProvider
final answersProvider = StateProvider<Map<String, int>>((ref) => {});

// 現在の質問インデックスを管理するStateProvider
final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);