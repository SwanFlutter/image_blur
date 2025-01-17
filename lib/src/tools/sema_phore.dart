// Simple Semaphore implementation for controlling concurrent operations
import 'dart:async';
import 'dart:collection';

class Semaphore {
  final int maxCount;
  int _currentCount = 0;
  final _queue = Queue<Completer>();

  Semaphore({required this.maxCount});

  Future<void> acquire() async {
    if (_currentCount < maxCount) {
      _currentCount++;
      return;
    }

    final completer = Completer();
    _queue.add(completer);
    await completer.future;
  }

  void release() {
    if (_queue.isEmpty) {
      _currentCount--;
    } else {
      final completer = _queue.removeFirst();
      completer.complete();
    }
  }
}
