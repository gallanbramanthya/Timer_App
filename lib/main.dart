import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _inputTime;
  late Duration _duration;
  late Timer _timer;
  bool _isPaused = false;
  bool _isTimeUp = false; // Variable untuk menunjukkan apakah waktu sudah habis
  bool _isStarted = false; // Variable untuk menunjukkan apakah countdown sudah dimulai

  @override
  void initState() {
    super.initState();
    _inputTime = 0;
    _duration = Duration(seconds: 0);
  }

  void _startCountdown() {
    if (_inputTime > 0) {
      _duration = Duration(seconds: _inputTime);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (!_isPaused) {
          setState(() {
            if (_duration.inSeconds > 0) {
              _duration -= Duration(seconds: 1);
            } else {
              _timer.cancel();
              _isTimeUp = true; // Mengatur waktu habis ketika countdown selesai
            }
          });
        }
      });
      _isStarted = true; // Set countdown sudah dimulai setelah tombol "Start" ditekan
    }
  }

  void _pauseCountdown() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeCountdown() {
    setState(() {
      _isPaused = false;
    });
  }

  void _resetCountdown() {
    _timer.cancel();
    setState(() {
      _duration = Duration(seconds: 0);
      _isPaused = false;
      _isTimeUp = false; // Reset variabel waktu habis saat mereset countdown
      _isStarted = false; // Reset variabel countdown sudah dimulai saat mereset countdown
    });
  }

  void _restartCountdown() {
    setState(() {
      _inputTime = 0;
      _duration = Duration(seconds: 0);
      _isPaused = false;
      _isTimeUp = false;
      _isStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Countdown Timer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold, // Memberikan tebal pada judul
            letterSpacing: 1.5,
            color: Color.fromARGB(255, 255, 255, 255),
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Nama : Gallan Damarrio A. B.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Align text to center
                    ),
                    SizedBox(height: 8),
                    Text(
                      'NIM : 222410102009',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center, // Align text to center
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40), // Tambahkan jarak yang cukup jauh
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter time (seconds)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _inputTime = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isStarted ? null : _startCountdown,
              child: Text('Start'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _isTimeUp
                          ? 'Waktu Anda habis!'
                          : '${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: _isTimeUp ? 20 : 48,
                        color: _isTimeUp ? Colors.red : Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isTimeUp)
                      ElevatedButton(
                        onPressed: _restartCountdown,
                        child: Text('Mulai Ulang'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _isPaused ? _resumeCountdown : _pauseCountdown,
                            child: Text(_isPaused ? 'Resume' : 'Pause'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _resetCountdown,
                            child: Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
