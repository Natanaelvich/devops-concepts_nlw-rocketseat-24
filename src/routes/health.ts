import { FastifyInstance } from "fastify";
import { ZodTypeProvider } from "fastify-type-provider-zod";

export async function health(app: FastifyInstance) {
  app.withTypeProvider<ZodTypeProvider>().get("/helthz", async (_, reply) => {
    return reply.send("OK");
  });
}
