import type { Request, Response, NextFunction } from "express";

const Authorization = {
    ADMIN: (req: Request, res: Response, next: NextFunction) => {
        if (req.user.role !== "ADMIN") {
            throw { status: 401, message: "[어드민] 권한이 없습니다." };
        }
        next();
    },
    USER: (req: Request, res: Response, next: NextFunction) => {
        if (!req.user) {
            throw { status: 401, message: "[유저] 권한이 없습니다." };
        }
        next();
    },
    SYSTEM: (req: Request, res: Response, next: NextFunction) => {
        if (req.user.role !== "SYSTEM") {
            throw { status: 401, message: "[시스템] 권한이 없습니다." };
        }
        next();
    },
};

export default Authorization;