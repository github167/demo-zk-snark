const compile = require("circom");
const fs_1 = require("fs");
const main = async () => {
    try {
        const circuitDef = await compile("../mastermind/circuits/mastermind.circom");
        fs_1.writeFileSync("mastermind.json", JSON.stringify(circuitDef), 'utf8');
    }
    catch (e) {
        console.error(e);
    }
}
main();
