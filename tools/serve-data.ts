import { serve } from "https://deno.land/std@0.147.0/http/server.ts";

const raw = await Deno.readTextFile("resources/ukr-mod-data.csv");
const deltas = await Deno.readTextFile("resources/ukr-mod-deltas.csv");

function handler( req: Request ): Response {
    console.log(req.url);
    const content = req.url.includes( "/deltas" )? deltas : raw;
    return new Response( content, { headers: { "content-type": "text/csv" } });
}

serve( handler, { port: 31415} );
