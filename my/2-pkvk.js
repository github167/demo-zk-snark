const snarkjs = require("snarkjs");
const fs_1 = require("fs");
const utils_1 = require("../build/mastermind/src/utils");
const main = async function () {
    const provingKeyOutput = "pk.json";
    const verifyingKeyOutput = "vk.json";
    const circuitFile = "mastermind.json";

    try {
        // Load the circuit
    const circuitDef = JSON.parse(fs_1.readFileSync(circuitFile, 'utf8'));
        const circuit = new snarkjs.Circuit(circuitDef);
        // Perform the setup
        const setup = snarkjs.groth.setup(circuit);
        // Save the keys
        const provingKey = setup.vk_proof;
        const verifyingKey = setup.vk_verifier;
        fs_1.writeFileSync(provingKeyOutput, JSON.stringify(utils_1.stringifyBigInts(provingKey)), 'utf8');
        fs_1.writeFileSync(verifyingKeyOutput, JSON.stringify(utils_1.stringifyBigInts(verifyingKey)), 'utf8');
    }
    catch (e) {
            console.error(e);
    }
}

main();
