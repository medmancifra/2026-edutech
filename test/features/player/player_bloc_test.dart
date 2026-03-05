import 'package:animalearn/features/player/bloc/player_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerBloc', () {
    test('initial state has PlayerStatus.initial', () {
      expect(PlayerBloc().state.status, PlayerStatus.initial);
    });

    blocTest<PlayerBloc, PlayerState>(
      'loads course and enters playing state',
      build: () => PlayerBloc(),
      act: (bloc) => bloc.add(const PlayerLoadCourse(courseId: 'python-1h')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.loading),
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.playing)
            .having((s) => s.modules, 'modules', isNotEmpty)
            .having((s) => s.segments, 'segments', isNotEmpty)
            .having(
                (s) => s.currentModuleIndex, 'moduleIndex', 0)
            .having(
                (s) => s.currentSegmentIndex, 'segmentIndex', 0),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'advances segment on PlayerAdvanceSegment',
      build: () => PlayerBloc(),
      act: (bloc) async {
        bloc.add(const PlayerLoadCourse(courseId: 'python-1h'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
        bloc.add(const PlayerAdvanceSegment());
      },
      wait: const Duration(milliseconds: 700),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.loading),
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.playing)
            .having((s) => s.currentSegmentIndex, 'segmentIndex', 0),
        isA<PlayerState>()
            .having((s) => s.currentSegmentIndex, 'segmentIndex', 1),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'toggles between playing and paused',
      build: () => PlayerBloc(),
      act: (bloc) async {
        bloc.add(const PlayerLoadCourse(courseId: 'python-1h'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
        bloc.add(const PlayerTogglePlayback());
      },
      wait: const Duration(milliseconds: 700),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.loading),
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.playing),
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.paused),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'navigates to module 2 with PlayerGoToModule',
      build: () => PlayerBloc(),
      act: (bloc) async {
        bloc.add(const PlayerLoadCourse(courseId: 'python-1h'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
        bloc.add(const PlayerGoToModule(moduleIndex: 2));
      },
      wait: const Duration(milliseconds: 700),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.loading),
        isA<PlayerState>()
            .having((s) => s.currentModuleIndex, 'module', 0),
        isA<PlayerState>()
            .having((s) => s.currentModuleIndex, 'module', 2)
            .having((s) => s.currentSegmentIndex, 'segment', 0),
      ],
    );

    blocTest<PlayerBloc, PlayerState>(
      'ignores invalid module index',
      build: () => PlayerBloc(),
      act: (bloc) async {
        bloc.add(const PlayerLoadCourse(courseId: 'python-1h'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
        bloc.add(const PlayerGoToModule(moduleIndex: 999));
      },
      wait: const Duration(milliseconds: 700),
      expect: () => [
        isA<PlayerState>()
            .having((s) => s.status, 'status', PlayerStatus.loading),
        isA<PlayerState>()
            .having((s) => s.currentModuleIndex, 'module', 0),
        // No additional state change — invalid index is ignored
      ],
    );
  });
}
