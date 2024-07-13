// unit
// integrations
// forked
// staging <- ryn tests on ACTUAL maintes ot testned not a forked one

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {RaffleDeployer} from "../../script/RaffleDeployer.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {SubscriptionCreater, SubscriptionFunder} from "../../script/Interactions.s.sol";
import {LinkToken} from "../mocks/LinkToken.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract RaffleTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;
    SubscriptionCreater subscriptionCreater = new SubscriptionCreater();
    SubscriptionFunder subscriptionFunder = new SubscriptionFunder();

    address public PLAYER1 = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint32 callbackGasLimit;

    /* Events */
    event RaffleEntered(address indexed palyer);

    function setUp() external {
        RaffleDeployer deployer = new RaffleDeployer();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory networkConfig = helperConfig.getConfig();

        entranceFee = networkConfig.entranceFee;
        interval = networkConfig.interval;
        vrfCoordinator = networkConfig.vrfCoordinator;
        gasLane = networkConfig.gasLane;
        callbackGasLimit = networkConfig.callbackGasLimit;

        vm.deal(PLAYER1, STARTING_PLAYER_BALANCE);
    }

    function testCreatingSubscription() public {
        uint256 subIdBefore = helperConfig.getConfig().subscriptionId;

        (uint256 subIdAfter,) = subscriptionCreater.createSubscriptionUsingConfig();

        assertEq(subIdBefore, 0);
        assert(subIdAfter != 0);
    }

    function testFundSubscription() public {
        (uint256 subscriptionId,) = subscriptionCreater.createSubscription(vrfCoordinator, PLAYER1);
        address linkToken = helperConfig.getConfig().link;

        LinkToken(linkToken).mint(PLAYER1, 10000);

        uint256 initialPlayerBalance = LinkToken(linkToken).balanceOf(PLAYER1);

        subscriptionFunder.fundSubscription(vrfCoordinator, subscriptionId, linkToken, PLAYER1);

        uint256 afterPLayerBalance = LinkToken(linkToken).balanceOf(PLAYER1);

        assert(initialPlayerBalance > afterPLayerBalance);
    }
}
