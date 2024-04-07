import * as bcrypt from 'bcrypt';
const saltRounds = 10;

async function hashPassword(password: string) {
    try {
        const salt = await bcrypt.genSalt(saltRounds);
        const hash = await bcrypt.hash(password, salt);
        return hash;
    } catch (err) {
        throw new Error(err.message);
    }
}

async function comparePassword(password: string, hash: string) {
    try {
        const res = await bcrypt
            .compare(password, hash);
        return res;
    } catch (err) {
        throw new Error(err.message);
    }
}

export {
    hashPassword,
    comparePassword
}