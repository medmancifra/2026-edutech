/**
 * register — Supabase Edge Function (Deno)
 *
 * Handles fast-registration for the demo:
 *   POST { email: string, password: string }
 *   → Creates a Supabase auth user and inserts a row in `users`.
 *
 * The Supabase auth.signUp call is done via the Admin client to bypass
 * email confirmation for the demo flow.
 */
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  // Handle CORS pre-flight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { email, password } = await req.json();

    if (!email || !password) {
      return new Response(
        JSON.stringify({ error: "email and password are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    // Create auth user (skip email confirmation for demo)
    const { data: authData, error: authError } =
      await supabaseAdmin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
      });

    if (authError) {
      // If user already exists, return 409 so the Flutter client can fall back
      // to sign-in
      if (authError.message.includes("already registered")) {
        return new Response(
          JSON.stringify({ error: "user_exists", detail: authError.message }),
          { status: 409, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
      throw authError;
    }

    const userId = authData.user?.id;

    // Insert a row in the public `users` table (profile)
    await supabaseAdmin.from("users").insert({
      id: userId,
      email,
      role: "learner",
      created_at: new Date().toISOString(),
    });

    return new Response(
      JSON.stringify({ user_id: userId }),
      { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err) {
    console.error("register error:", err);
    return new Response(
      JSON.stringify({ error: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
