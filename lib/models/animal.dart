class Animal {
  final String name;
  final String emoji;
  final String description;
  final Map<String, int> attributes;

  const Animal({
    required this.name,
    required this.emoji,
    required this.description,
    required this.attributes,
  });

  // Jaccard係数を使った類似度計算
  double calculateSimilarity(Map<String, int> userAnswers) {
    double minSum = 0;
    double maxSum = 0;

    for (final entry in userAnswers.entries) {
      final questionId = entry.key;
      final userValue = entry.value;
      final animalValue = attributes[questionId] ?? 0;

      minSum += (userValue < animalValue) ? userValue : animalValue;
      maxSum += (userValue > animalValue) ? userValue : animalValue;
    }

    return maxSum == 0 ? 0 : minSum / maxSum;
  }
}