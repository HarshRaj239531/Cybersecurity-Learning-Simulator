import { AuthRepository } from './auth.repository';
import { hashPassword, comparePassword } from '../../core/utils/password';
import { signToken } from '../../core/utils/jwt';

const authRepository = new AuthRepository();

export class AuthService {
    async register(data: any) {
        // Check if email exists
        const existingEmail = await authRepository.findByEmail(data.email);
        if (existingEmail) throw new Error('Email already registered');

        // Check if username exists
        const existingUsername = await authRepository.findByUsername(data.username);
        if (existingUsername) throw new Error('Username already taken');

        const hashedPassword = await hashPassword(data.password);
        const user = await authRepository.createUser({
            ...data,
            password: hashedPassword,
        });
        const token = signToken({ id: user.id });
        return { user, token };
    }

    async login(data: any) {
        const user = await authRepository.findByEmail(data.email);
        if (!user) throw new Error('User not found');

        const isMatch = await comparePassword(data.password, user.password);
        if (!isMatch) throw new Error('Invalid credentials');

        const token = signToken({ id: user.id });
        return { user, token };
    }
}
