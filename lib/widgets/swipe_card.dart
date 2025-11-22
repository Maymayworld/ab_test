import 'package:flutter/material.dart';

class SwipeCard extends StatelessWidget {
  final String question;
  final int questionNumber;
  final int totalQuestions;

  const SwipeCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アイコン
            Icon(
              Icons.lightbulb_outline,
              size: 48,
              color: Colors.blue.shade200,
            ),
            const SizedBox(height: 24),
            
            // 質問テキスト
            Flexible(
              child: Center(
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Yes/Noボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Noボタン
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red.shade600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                // Yesボタン
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.shade200,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.green.shade600,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}