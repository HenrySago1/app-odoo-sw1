import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Para texto a voz
import 'package:http/http.dart' as http; // Para realizar peticiones HTTP
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Para reconocimiento de voz

class HablaTuIdiomaPage extends StatefulWidget {
  @override
  _HablaTuIdiomaPageState createState() => _HablaTuIdiomaPageState();
}

class _HablaTuIdiomaPageState extends State<HablaTuIdiomaPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _recognizedText = '';
  String _translatedText = '';

  final Map<String, String> languages = {
    'English': 'en',
    'Español': 'es',
    'Francés': 'fr',
    'Alemán': 'de',
    'Italiano': 'it',
  };

  String _targetLanguage = 'es'; // Idioma de destino predeterminado

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    // Configuraciones iniciales del TTS
    _flutterTts.setLanguage("es-ES");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      });
    }
  }

  Future<void> _stopListening() async {
    _speech.stop();
    setState(() => _isListening = false);

    if (_recognizedText.isNotEmpty) {
      await _translateAndSpeak();
    }
  }

  Future<void> _translateAndSpeak() async {
    if (_recognizedText.isEmpty) return;

    // Traduce el texto reconocido
    final apiKey =
        "AIzaSyBrJGvX57y08_t0Nm_N68qgIVwoM3kCFCA"; // Reemplaza con tu clave de API
    final url =
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'q': _recognizedText,
        'target': _targetLanguage,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _translatedText = data['data']['translations'][0]['translatedText'];
      });

      // Leer en voz alta el texto traducido
      await _speak(_translatedText);
    } else {
      setState(() {
        _translatedText = 'Error en la traducción';
      });
    }
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts
          .setLanguage(_targetLanguage); // Configura el idioma del TTS
      await _flutterTts.speak(text);
    }
  }

  Future<void> _speakTranslation() async {
    if (_translatedText.isNotEmpty) {
      await _flutterTts.setLanguage(_targetLanguage); // Idioma del TTS
      await _flutterTts.setPitch(1.0); // Tono
      await _flutterTts.setSpeechRate(0.5); // Velocidad de habla
      await _flutterTts.speak(_translatedText); // Leer texto traducido
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No hay texto traducido para leer.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200, // Color del AppBar
        title: Text('Habla Tu Idioma'), // Título del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a la página anterior
          },
        ),
      ),
      backgroundColor: Colors.purple[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menú de selección de idioma
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Translate to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: _targetLanguage,
                  items: languages.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(
                              entry.key,
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _targetLanguage = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            // Botón de micrófono / detener
            GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 40),
            // Texto de traducción y original
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Translation',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _translatedText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Original',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _recognizedText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Botones de traducir y escuchar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _speakTranslation,
                  icon: Icon(Icons.volume_up),
                  label: Text('Leer Traducción'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
