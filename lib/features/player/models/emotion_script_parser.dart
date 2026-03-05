/// Parses the emotion-script format into a list of [ScriptSegment]s.
///
/// Emotion-script syntax:
///   [EMOTION:name] — triggers a named emotion/animation state
///   [CODE:lang] ... [/CODE] — a code block in the given language
///   Plain text — narration text
///
/// Example:
///   [EMOTION:excited] Hello! I'm PythonSnake.
///   [CODE:python]
///   print("Hello!")
///   [/CODE]
///   [EMOTION:happy] You just wrote Python!
class EmotionScriptParser {
  static final _emotionTag = RegExp(r'\[EMOTION:(\w+)\]');
  static final _codeBlock = RegExp(r'\[CODE:(\w+)\]([\s\S]*?)\[/CODE\]');

  /// Parses [script] into a flat list of segments.
  static List<ScriptSegment> parse(String script) {
    final segments = <ScriptSegment>[];
    var remaining = script.trim();

    while (remaining.isNotEmpty) {
      // Try code block first (greedy)
      final codeMatch = _codeBlock.firstMatch(remaining);
      final emotionMatch = _emotionTag.firstMatch(remaining);

      // Determine which comes first
      final codeStart = codeMatch?.start ?? remaining.length;
      final emotionStart = emotionMatch?.start ?? remaining.length;

      if (codeStart == remaining.length && emotionStart == remaining.length) {
        // Only plain text left
        final text = remaining.trim();
        if (text.isNotEmpty) {
          segments.add(NarrationSegment(text: text));
        }
        break;
      }

      if (codeStart < emotionStart) {
        // Text before code block
        if (codeStart > 0) {
          final pre = remaining.substring(0, codeStart).trim();
          if (pre.isNotEmpty) segments.add(NarrationSegment(text: pre));
        }
        segments.add(CodeSegment(
          language: codeMatch!.group(1)!,
          code: codeMatch.group(2)!.trim(),
        ));
        remaining = remaining.substring(codeMatch.end);
      } else {
        // Text before emotion tag
        if (emotionStart > 0) {
          final pre = remaining.substring(0, emotionStart).trim();
          if (pre.isNotEmpty) segments.add(NarrationSegment(text: pre));
        }
        final emotionName = emotionMatch!.group(1)!.toLowerCase();
        segments.add(EmotionSegment(emotion: emotionName));
        remaining = remaining.substring(emotionMatch.end);

        // The text that directly follows the emotion tag (until next tag)
        final nextMatch = RegExp(r'\[(?:EMOTION:|CODE:)')
            .firstMatch(remaining);
        final textEnd = nextMatch?.start ?? remaining.length;
        final text = remaining.substring(0, textEnd).trim();
        if (text.isNotEmpty) {
          segments.add(NarrationSegment(text: text));
        }
        remaining = remaining.substring(textEnd);
      }
    }

    return segments;
  }
}

/// Base class for all script segments.
sealed class ScriptSegment {
  const ScriptSegment();
}

/// A named emotion/animation trigger.
class EmotionSegment extends ScriptSegment {
  const EmotionSegment({required this.emotion});

  final String emotion; // e.g. "excited", "curious", "happy"

  @override
  String toString() => '[EmotionSegment: $emotion]';
}

/// Narration text to display as subtitle/card.
class NarrationSegment extends ScriptSegment {
  const NarrationSegment({required this.text});

  final String text;

  @override
  String toString() => '[NarrationSegment: "$text"]';
}

/// A syntax-highlighted code block.
class CodeSegment extends ScriptSegment {
  const CodeSegment({required this.language, required this.code});

  final String language;
  final String code;

  @override
  String toString() => '[CodeSegment: $language "${code.split('\n').first}..."]';
}
