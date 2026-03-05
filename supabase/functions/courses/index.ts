/**
 * courses — Supabase Edge Function (Deno)
 *
 * GET  /courses          → list published courses
 * GET  /courses/:id      → single course with modules
 *
 * Query params:
 *   ?q=<search>     full-text search
 *   ?limit=12       page size (default 12)
 *   ?offset=0       pagination offset
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

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    { auth: { autoRefreshToken: false, persistSession: false } }
  );

  try {
    const url = new URL(req.url);
    const q = url.searchParams.get("q");
    const limit = parseInt(url.searchParams.get("limit") ?? "12", 10);
    const offset = parseInt(url.searchParams.get("offset") ?? "0", 10);

    let query = supabase
      .from("courses")
      .select(
        `id, title, description, author_id, rating, total_ratings,
         duration_minutes, module_count, level, tags, thumbnail_url,
         users:author_id ( full_name )`
      )
      .eq("published", true)
      .range(offset, offset + limit - 1)
      .order("rating", { ascending: false });

    if (q) {
      query = query.textSearch("fts", q, { type: "websearch" });
    }

    const { data, error } = await query;
    if (error) throw error;

    return new Response(JSON.stringify({ courses: data }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("courses error:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
