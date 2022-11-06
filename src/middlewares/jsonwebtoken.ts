import { type ExpressController, Jsonwebtoken } from "@fuseble.inc/node";
import config from "config";
import database from "database";
// import database from "database";

const jsonwebtoken = new Jsonwebtoken(config.JWT_KEY);

export type JWTPayload = {
    id?: string;
    name?: string;
};

const jsonWebTokenMiddleware: ExpressController = async (req, res, next) => {
    if (!req.headers["authorization"]) return next();

    const splitted = req.headers["authorization"].split(" ");
    if (splitted.length !== 2) return next();

    const token = splitted[1];
    if (!token) return next();

    const decoded = jsonwebtoken.verifyJwt<JWTPayload>(token);

    if (decoded?.name === "JsonWebTokenError") {
        return next({ status: 400, message: decoded.name });
    }

    if (decoded?.name === "TokenExpiredError") {
        if (req.path === "/auth/refresh") {
            return next();
        } else {
            return next({ status: 401, message: decoded.name });
        }
    }

    if (decoded?.id) {
        const user = await database.user.findUnique({
            where: { id: decoded.id },
            select: {
                id: true,
                email: true,
                createdAt: true,
                updatedAt: true,
            },
        });

        if (!user) {
            return next({ status: 401, message: "User not found" });
        }
        req.user = user;
    }

    next();
};

export default jsonWebTokenMiddleware;