import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CountMatchScreen extends StatefulWidget {
  final String englishQuestion;
  final String spanishQuestion;
  final String imageAsset;
  final String englishOption1;
  final String spanishOption1;
  final Widget nextPage1;
  final String englishOption2;
  final String spanishOption2;
  final Widget nextPage2;

  const CountMatchScreen({
    super.key,
    required this.englishQuestion,
    required this.spanishQuestion,
    required this.imageAsset,
    required this.englishOption1,
    required this.spanishOption1,
    required this.nextPage1,
    required this.englishOption2,
    required this.spanishOption2,
    required this.nextPage2,
  });

  @override
  State<CountMatchScreen> createState() => _CountMatchScreenState();
}

class _CountMatchScreenState extends State<CountMatchScreen> {
  bool showSpanish = false;
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Count and Match')),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset('assets/p9.gif', fit: BoxFit.cover),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Text(
                  showSpanish ? widget.spanishQuestion : widget.englishQuestion,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final text = showSpanish
                      ? widget.spanishQuestion
                      : widget.englishQuestion;
                  await flutterTts.setLanguage(showSpanish ? 'es-ES' : 'en-US');
                  await flutterTts.speak(text);
                },
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak', style: TextStyle(fontSize: 20.0)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: 330,
                height: 186,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 246, 242, 247),
                      width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(widget.imageAsset),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => widget.nextPage1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Optional: rounded look
                      ),
                    ),
                    child: Text(
                      showSpanish
                          ? widget.spanishOption1
                          : widget.englishOption1,
                      style:
                          const TextStyle(fontSize: 30.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => widget.nextPage2),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Optional: rounded look
                      ),
                    ),
                    child: Text(
                      showSpanish
                          ? widget.spanishOption2
                          : widget.englishOption2,
                      style:
                          const TextStyle(fontSize: 30.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSpanish = !showSpanish;
                  });
                },
                child: Text(
                  showSpanish ? 'English' : 'Español',
                  style: const TextStyle(fontSize: 23),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
