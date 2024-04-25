//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {MAINNET_NETWORK, UnsupportedNetwork} from "../../constants/Network.sol";

abstract contract Token {
    IERC20Metadata internal token;

    constructor(string memory network) {
        address USDC;
        if (Strings.equal(network, MAINNET_NETWORK)) {
            USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
            token = IERC20Metadata(USDC);
        } else {
            revert UnsupportedNetwork(network);
        }
    }
}
