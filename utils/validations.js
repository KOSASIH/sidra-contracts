// utils/validations.js

const { isValidAddress } = require('./helpers');

/**
 * Validates the input for a token transfer.
 * @param {string} from - The sender's address.
 * @param {string} to - The recipient's address.
 * @param {number} amount - The amount to transfer.
 * @throws Will throw an error if validation fails.
 */
function validateTokenTransfer(from, to, amount) {
    if (!isValidAddress(from)) {
        throw new Error("Invalid sender address.");
    }
    if (!isValidAddress(to)) {
        throw new Error("Invalid recipient address.");
    }
    if (amount <= 0) {
        throw new Error("Transfer amount must be greater than zero.");
    }
}

/**
 * Validates the input for minting tokens.
 * @param {string} to - The recipient's address.
 * @param {number} amount - The amount to mint.
 * @throws Will throw an error if validation fails.
 */
function validateMinting(to, amount) {
    if (!isValidAddress(to)) {
        throw new Error("Invalid recipient address for minting.");
    }
    if (amount <= 0) {
        throw new Error("Minting amount must be greater than zero.");
    }
}

module.exports = {
    validateTokenTransfer,
    validateMinting,
};
