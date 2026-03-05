/**
 * reviews — Supabase Edge Function (Deno)
 *
 * POST { course_id: string, rating: number, text?: string }
 *   → Inserts a review row and recalculates the course average rating.
 *
 * Requires: Authorization: Bearer <user-jwt>
 */
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const authHeader = req.headers.get("Authorization");

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    {
      auth: { autoRefreshToken: false, persistSession: false },
      global: { headers: { Authorization: authHeader ?? "" } },
    }
  );

  try {
    // Verify authenticated user
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { course_id, rating, text } = await req.json();

    if (!course_id || !rating || rating < 1 || rating > 5) {
      return new Response(
        JSON.stringify({ error: "course_id and rating (1-5) are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Upsert review (one review per user per course)
    const { error: insertError } = await supabase
      .from("reviews")
      .upsert({
        user_id: user.id,
        course_id,
        rating,
        text: text ?? null,
        updated_at: new Date().toISOString(),
      }, { onConflict: "user_id,course_id" });

    if (insertError) throw insertError;

    // Recalculate average rating on the courses table
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    const { data: stats } = await supabaseAdmin
      .from("reviews")
      .select("rating")
      .eq("course_id", course_id);

    if (stats && stats.length > 0) {
      const avg =
        stats.reduce((sum: number, r: { rating: number }) => sum + r.rating, 0) /
        stats.length;

      await supabaseAdmin
        .from("courses")
        .update({
          rating: Math.round(avg * 10) / 10,
          total_ratings: stats.length,
        })
        .eq("id", course_id);
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 201,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("reviews error:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
