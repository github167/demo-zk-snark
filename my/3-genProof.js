const snarkjs = require("snarkjs");
const fs_1 = require("fs");
const utils_1 = require("../build/mastermind/src/utils");
const pedersen_1 = require("../build/mastermind/src/pedersen");
const main = async function () {
    const provingKeyInput = "pk.json";
    const verifyingKeyInput = "vk.json";
    const circuitFile = "mastermind.json";
    const proofOutput = "proof.json";
    const publicSignalsOutput = "pubSignal.json";
    const testCase = {
        "guess": [1, 2, 2, 1],
        "soln": [2, 2, 1, 2],
        "whitePegs": 2,
        "blackPegs": 1,
    };
    const soln = utils_1.genSolnInput(testCase.soln);
    const saltedSoln = soln.add(utils_1.genSalt());
    const hashedSoln = pedersen_1.pedersenHash(saltedSoln);
    const testInput = {
        pubNumBlacks: testCase.blackPegs.toString(),
        pubNumWhites: testCase.whitePegs.toString(),
        pubSolnHash: hashedSoln.encodedHash.toString(),
        privSaltedSoln: saltedSoln.toString(),
        pubGuessA: testCase.guess[0],
        pubGuessB: testCase.guess[1],
        pubGuessC: testCase.guess[2],
        pubGuessD: testCase.guess[3],
        privSolnA: testCase.soln[0],
        privSolnB: testCase.soln[1],
        privSolnC: testCase.soln[2],
        privSolnD: testCase.soln[3],
    };
    const provingKey = utils_1.unstringifyBigInts(JSON.parse(fs_1.readFileSync(provingKeyInput, "utf8")));
    const verifyingKey = utils_1.unstringifyBigInts(JSON.parse(fs_1.readFileSync(verifyingKeyInput, "utf8")));
    const circuitDef = JSON.parse(fs_1.readFileSync(circuitFile, "utf8"));
    console.log(new Date(), 'Loading circuit');
    const circuit = new snarkjs.Circuit(circuitDef);
    console.log(new Date(), 'Calculating witness');
    const witness = circuit.calculateWitness(testInput);
    console.log('Hash calculated by JS     :', testInput.pubSolnHash);
    console.log('Hash calculated by circuit:', witness[circuit.getSignalIdx('main.solnHashOut')]);
    console.log(new Date(), 'Generating proof');
    const { proof, publicSignals } = snarkjs.groth.genProof(provingKey, witness);
    fs_1.writeFileSync(proofOutput, JSON.stringify(utils_1.stringifyBigInts(proof)), 'utf8');
    fs_1.writeFileSync(publicSignalsOutput, JSON.stringify(utils_1.stringifyBigInts(publicSignals)), 'utf8');
};
main();

