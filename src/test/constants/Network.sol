//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

string constant MAINNET_NETWORK = "mainnet";

error UnsupportedNetwork(string names);

abstract contract Network {
    struct Configuration {
        uint32 blockHeight;
    }

    mapping(string => Configuration) internal networkConfiguration;

    constructor() {
        networkConfiguration[MAINNET_NETWORK] = Configuration(19114807);
    }
}
