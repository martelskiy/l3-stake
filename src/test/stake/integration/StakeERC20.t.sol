//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {StakeBase} from "./StakeBase.t.sol";

contract StakeTest is StakeBase {
    function testGivenWhenThen() public {
        uint8 foo = 10;
        uint8 bar = 10;
        assertTrue(foo == bar);
    }
}
