import { Core } from "@strapi/strapi";
import { Context } from "koa";

interface StrapiUser {
  id: number;
  roles: Array<{
    id: number;
    name: string;
  }>;
}

interface Product {
  id: number;
  seller?: {
    id: number;
  };
}

interface StrapiContext extends Context {
  state: {
    user?: StrapiUser;
    product?: Product;
  };
  params: {
    id?: string;
  };
}

const productOwnership = (config: any, { strapi }: { strapi: Core.Strapi }) => {
  return async (
    ctx: StrapiContext,
    next: () => Promise<void>
  ): Promise<void> => {
    // Only apply to product endpoints
    if (!ctx.path.startsWith("/api/products")) {
      return next();
    }

    const { method, params, state } = ctx;

    // Only check ownership for UPDATE and DELETE operations
    if (!["PUT", "DELETE", "PATCH"].includes(method)) {
      return next();
    }
    console.log(state)

    // Ensure user is authenticated
    if (!state.user) {
      ctx.unauthorized("You must be logged in");
      return;
    }

    try {
      // Extract product ID from URL
      const productId: string | undefined = params.id || ctx.params.id;

      if (!productId) {
        ctx.badRequest("Product ID is required");
        return;
      }

      // Fetch the product
      const product = (await strapi
        .service("api::product.product")
        .findOne(productId, {
          populate: ["seller"],
        })) as Product | null;

      if (!product) {
        ctx.notFound("Product not found");
        return;
      }

      // Check if the logged-in user is the seller
      const isOwner: boolean = product.seller?.id === state.user.id;

      // Check if user has admin role
      const isAdmin: boolean = state.user.roles.some(
        (role) => role.name === "Administrator"
      );

      if (!isOwner && !isAdmin) {
        ctx.forbidden("You are not authorized to modify this product");
        return;
      }

      // Attach product to context for potential future use
      ctx.state.product = product;

      return next();
    } catch (err) {
      strapi.log.error(err);
      ctx.internalServerError("An error occurred");
    }
  };
};

export default productOwnership;
