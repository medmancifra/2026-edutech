import 'package:animalearn/features/player/models/emotion_script_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmotionScriptParser', () {
    test('parses a single emotion tag', () {
      const script = '[EMOTION:excited]';
      final segments = EmotionScriptParser.parse(script);
      expect(segments, hasLength(1));
      expect(segments[0], isA<EmotionSegment>());
      expect((segments[0] as EmotionSegment).emotion, 'excited');
    });

    test('parses emotion tag followed by narration', () {
      const script = '[EMOTION:happy] Hello world!';
      final segments = EmotionScriptParser.parse(script);

      expect(segments, hasLength(2));
      expect((segments[0] as EmotionSegment).emotion, 'happy');
      expect((segments[1] as NarrationSegment).text, 'Hello world!');
    });

    test('parses a code block', () {
      const script = '[CODE:python]\nprint("hi")\n[/CODE]';
      final segments = EmotionScriptParser.parse(script);

      expect(segments, hasLength(1));
      expect(segments[0], isA<CodeSegment>());
      final code = segments[0] as CodeSegment;
      expect(code.language, 'python');
      expect(code.code, 'print("hi")');
    });

    test('parses interleaved emotions, narrations and code blocks', () {
      const script = '''
[EMOTION:excited] Привет!
[CODE:python]
x = 42
[/CODE]
[EMOTION:happy] Отлично!
''';
      final segments = EmotionScriptParser.parse(script);

      // We expect: EmotionSegment, NarrationSegment, CodeSegment, EmotionSegment, NarrationSegment
      expect(segments.whereType<EmotionSegment>().length, greaterThanOrEqualTo(2));
      expect(segments.whereType<CodeSegment>().length, 1);
      final code = segments.whereType<CodeSegment>().first;
      expect(code.language, 'python');
      expect(code.code, 'x = 42');
    });

    test('emotion names are lowercased', () {
      const script = '[EMOTION:EXCITED]';
      final segments = EmotionScriptParser.parse(script);
      expect((segments[0] as EmotionSegment).emotion, 'excited');
    });

    test('parses plain narration with no tags', () {
      const script = 'Just plain text here.';
      final segments = EmotionScriptParser.parse(script);
      expect(segments, hasLength(1));
      expect((segments[0] as NarrationSegment).text, 'Just plain text here.');
    });

    test('returns empty list for empty script', () {
      final segments = EmotionScriptParser.parse('');
      expect(segments, isEmpty);
    });

    test('parses full module 1 script without crashing', () {
      const script = '''
[EMOTION:excited] Привет! Я Пайтоша — твой проводник в мир Python.
[EMOTION:curious] Python — это язык, который читается почти как обычный текст.
[EMOTION:happy] Давай напишем твою первую программу!
[CODE:python]
print("Привет, мир!")
[/CODE]
[EMOTION:proud] Отлично! Ты только что написал первую программу на Python!
''';
      final segments = EmotionScriptParser.parse(script);
      expect(segments, isNotEmpty);
      expect(segments.whereType<EmotionSegment>().length, 4);
      expect(segments.whereType<CodeSegment>().length, 1);
    });
  });
}
