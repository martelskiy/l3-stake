//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {StakeERC20} from "../../../contracts/StakeERC20.sol";
import {Token} from "../helpers/Token.sol";
import {Users} from "../helpers/Users.sol";
import {MAINNET_NETWORK, Network} from "../../constants/Network.sol";

abstract contract StakeBase is Test, Token, Network {
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);

    /*//////////////////////////////////////////////////////////////////////////
                                   TEST CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/
    StakeERC20 internal stake;

    /*//////////////////////////////////////////////////////////////////////////
                                   HELPERS CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/
    Users internal testUsers;
    /*//////////////////////////////////////////////////////////////////////////
                                   VARIABLES
    //////////////////////////////////////////////////////////////////////////*/
    uint256 internal constant TOKEN_USER_HOLDINGS = 1_000_000e18;

    address internal deployer = makeAddr("Deployer");

    constructor() Token(MAINNET_NETWORK) {}

    function setUp() public {
        _initFork();
        vm.startPrank(deployer);

        testUsers = Users({
            alice: _createUser("Alice", address(token), TOKEN_USER_HOLDINGS),
            bob: _createUser("Bob", address(token), TOKEN_USER_HOLDINGS)
        });

        stake = new StakeERC20(address(token));
    }

    function _createUser(
        string memory name,
        address token,
        uint256 amount
    ) internal returns (address) {
        address user = makeAddr(name);
        deal({token: token, to: user, give: amount});
        return user;
    }

    function _initFork() private {
        uint256 fork = vm.createSelectFork(
            vm.rpcUrl(MAINNET_NETWORK),
            networkConfiguration[MAINNET_NETWORK].blockHeight
        );
        assertEq(vm.activeFork(), fork);
    }
}
