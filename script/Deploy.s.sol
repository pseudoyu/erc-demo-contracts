// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/ERC20Y.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        uint256 initialSupply = 1000000 * 10 ** 18; // 1 million tokens with 18 decimals
        MonadTestnetTokenY token = new MonadTestnetTokenY(initialSupply);

        vm.stopBroadcast();

        console.log("MonadTestnetTokenY deployed at:", address(token));
    }
}
