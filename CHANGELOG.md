# Changelog

## 1.1.0

* **NEW:** Persistent Isolate for faster BlurHash generation (no more spawning new isolate per image)
* **NEW:** BlurHash caching system to avoid redundant computations
* **NEW:** `ImageHashManager.clearCache()` - Clear all cached BlurHash values
* **NEW:** `ImageHashManager.setMaxCacheSize()` - Configure cache size
* **NEW:** `ImageHashManager.preloadHashes()` - Preload BlurHash for multiple images
* **NEW:** `ImageHashManager.dispose()` - Dispose the persistent Isolate
* **NEW:** Configurable delays in `OptimizedImageHashPreview` (`hashLoadDelay`, `imageShowDelay`)
* **NEW:** `errorBuilder` parameter for custom error widgets
* **NEW:** `decodingWidth`, `decodingHeight`, `filterQuality` parameters
* **FIX:** `blurValue` state bug in `ImageBlur` - blur effect now updates correctly during loading
* **FIX:** `blurValue` state bug in `ImageBlurGetPalletteColor`
* **FIX:** Race condition in Isolate initialization
* **FIX:** Duplicate requests for same image now share the result
* **IMPROVED:** `Semaphore` class with better documentation and `run()` helper method
* **IMPROVED:** `GetImage` class with palette caching
* **IMPROVED:** Better error handling throughout the package
* **IMPROVED:** Updated README with comprehensive examples

## 1.0.90

* Fix Pub Point.
* Update package
* Update SDK

## 1.0.82

* Fix bug.
* Add two feature imageHashGetPaletteColor AND imageBlurGetPalletteColor.
* These two widgets were added because the app crashed when it received the value of the Blair list and the hash.

## 1.0.81

* Fix bug.

## 1.0.8

* Fix bug.

## 1.0.7

* Update And Support Web.

## 1.0.6

* Fix And Update Property onPaletteReceived.

## 1.0.5

* Fix Bug.
* Add Property onPaletteReceived.

## 1.0.4

* Fix Pub Point.

## 1.0.3

* Fixed the problem of the app freezing when loading images.

## 1.0.2

* Fix Pub Point.

## 0.0.1

* Initial release.
