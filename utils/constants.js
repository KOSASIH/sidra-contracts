// utils/constants.js

// Commonly used error messages
const ERROR_MESSAGES = {
    NOT_OWNER: "Caller is not the owner.",
    INSUFFICIENT_BALANCE: "Insufficient balance.",
    INVALID_ADDRESS: "Invalid address provided.",
    NOT_AUTHORIZED: "Caller is not authorized.",
};

// Roles for Access Control
const ROLES = {
    ADMIN: "0x0000000000000000000000000000000000000001",
    MINTER: "0x0000000000000000000000000000000000000002",
    BURNER: "0x0000000000000000000000000000000000000003",
};

// Token Constants
const TOKEN_DECIMALS = 18;
const INITIAL_SUPPLY = 1000000 * 10 ** TOKEN_DECIMALS; // 1 million tokens

module.exports = {
    ERROR_MESSAGES,
    ROLES,
    TOKEN_DECIMALS,
    INITIAL_SUPPLY,
};
