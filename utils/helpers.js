// utils/helpers.js

/**
 * Converts a number to a fixed-point string representation.
 * @param {number} value - The number to convert.
 * @param {number} decimals - The number of decimal places.
 * @returns {string} - The fixed-point string representation.
 */
function toFixedPoint(value, decimals) {
    return (value * 10 ** decimals).toString();
}

/**
 * Checks if an address is a valid Ethereum address.
 * @param {string} address - The address to validate.
 * @returns {boolean} - True if valid, false otherwise.
 */
function isValidAddress(address) {
    return /^0x[a-fA-F0-9]{40}$/.test(address);
}

/**
 * Generates a unique identifier for a transaction or event.
 * @returns {string} - A unique identifier.
 */
function generateUniqueId() {
    return 'id-' + Math.random().toString(36).substr(2, 16);
}

/**
 * Formats a timestamp into a human-readable date string.
 * @param {number} timestamp - The timestamp to format.
 * @returns {string} - The formatted date string.
 */
function formatTimestamp(timestamp) {
    const date = new Date(timestamp * 1000);
    return date.toISOString();
}

module.exports = {
    toFixedPoint,
    isValidAddress,
    generateUniqueId,
    formatTimestamp,
};
