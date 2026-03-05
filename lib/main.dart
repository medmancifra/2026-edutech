import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/showcase/bloc/showcase_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const AnimaLearnApp());
}

class AnimaLearnApp extends StatelessWidget {
  const AnimaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(repository: const AuthRepository()),
        ),
        BlocProvider(
          create: (_) => ShowcaseBloc()..add(const ShowcaseLoadCourses()),
        ),
      ],
      child: MaterialApp(
        title: 'AnimaLearn',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: AppRoutes.registration,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
