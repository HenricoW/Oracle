const CoinGecko = require("coingecko-api");
const Oracle = artifacts.require('Oracle.sol');

const CYCLE_TIME = 5000;
const CoinGeckoClient = new CoinGecko();

module.exports = async callback => {
    const [_, reporter] = await web3.eth.getAccounts();
    const oracle = await Oracle.deployed();

    while (true) {
        // get data from coingecko
        const repsonse = await CoinGeckoClient.coins.fetch('bitcoin', {});
        let currentPrice = repsonse.data.market_data.current_price.usd;     // '32540.79879'
        currentPrice = parseFloat(currentPrice);                            // 32540.79879
        currentPrice = parseInt(currentPrice * 100);                        // 3254079

        // push data to Oracle contract
        const key = web3.utils.sha3('BTC/USD');
        await oracle.storeData(key, currentPrice, { from: reporter })

        // log out the action
        console.log(`Oracle with BTC/USD price at ${currentPrice} updated on-chain`);

        // wait for interval before next cycle
        await new Promise((resolve, _) => setTimeout(resolve, CYCLE_TIME));
    }

    callback();
}