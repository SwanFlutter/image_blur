// Simple Semaphore implementation for controlling concurrent operations
import 'dart:async';
import 'dart:collection';

/// A semaphore implementation for controlling concurrent operations.
///
/// This class provides a way to limit the number of concurrent operations
/// that can be performed at any given time. It's useful for:
/// - Rate limiting API calls
/// - Controlling concurrent image loading
/// - Managing resource-intensive operations
///
/// Example usage:
/// ```dart
/// final semaphore = Semaphore(maxCount: 3);
///
/// Future<void> loadImage(String url) async {
///   await semaphore.acquire();
///   try {
///     // Load image...
///   } finally {
///     semaphore.release();
///   }
/// }
/// ```
class Semaphore {
  /// The maximum number of concurrent operations allowed.
  final int maxCount;

  int _currentCount = 0;
  final Queue<Completer<void>> _queue = Queue<Completer<void>>();

  /// Creates a new Semaphore with the specified maximum count.
  ///
  /// [maxCount] must be greater than 0.
  Semaphore({required this.maxCount})
    : assert(maxCount > 0, 'maxCount must be greater than 0');

  /// Returns the current number of active operations.
  int get currentCount => _currentCount;

  /// Returns the number of operations waiting to acquire.
  int get waitingCount => _queue.length;

  /// Returns true if no operations are currently active or waiting.
  bool get isIdle => _currentCount == 0 && _queue.isEmpty;

  /// Acquires the semaphore.
  ///
  /// If the current count is less than [maxCount], increments the count
  /// and returns immediately. Otherwise, waits until a slot becomes available.
  Future<void> acquire() async {
    if (_currentCount < maxCount) {
      _currentCount++;
      return;
    }

    final completer = Completer<void>();
    _queue.add(completer);
    await completer.future;
  }

  /// Releases the semaphore.
  ///
  /// If there are waiting operations, allows the next one to proceed.
  /// Otherwise, decrements the current count.
  ///
  /// Throws [StateError] if release is called more times than acquire.
  void release() {
    if (_currentCount <= 0 && _queue.isEmpty) {
      throw StateError('Cannot release: semaphore count is already 0');
    }

    if (_queue.isEmpty) {
      _currentCount--;
    } else {
      final completer = _queue.removeFirst();
      completer.complete();
    }
  }

  /// Executes [action] with the semaphore acquired.
  ///
  /// Automatically releases the semaphore when the action completes,
  /// even if an error occurs.
  Future<T> run<T>(Future<T> Function() action) async {
    await acquire();
    try {
      return await action();
    } finally {
      release();
    }
  }
}
