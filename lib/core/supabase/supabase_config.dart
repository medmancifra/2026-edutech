/// Supabase configuration constants.
/// Replace [supabaseUrl] and [supabaseAnonKey] with your actual project values
/// from the Supabase dashboard (Settings → API).
class SupabaseConfig {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-ref.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // Edge Function base path
  static const functionsBase = '$supabaseUrl/functions/v1';

  // Edge Function endpoints
  static const registerFn = '$functionsBase/register';
  static const coursesFn = '$functionsBase/courses';
  static const reviewsFn = '$functionsBase/reviews';
}
