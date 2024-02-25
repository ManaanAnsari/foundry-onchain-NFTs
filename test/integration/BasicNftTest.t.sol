// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import {BasicNft} from "../../src/BasicNft.sol";
import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNfttest is Test {
    BasicNft public basicNft;
    address public USER;
    uint256 public STARTING_BALANCE = 10 ether;
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        DeployBasicNft deployBasicNft = new DeployBasicNft();
        basicNft = deployBasicNft.run();
        USER = makeAddr("player");
        deal(USER, STARTING_BALANCE);
    }

    function testNameisCorrect() public view {
        string memory expected_name = "Dogie";
        string memory name = basicNft.name();
        // assertEq(name, expected_name); //this works
        // assert(name==expected_name); //this wont work
        //  other way is to hash it and then compare
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked(expected_name))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        uint256 balance = basicNft.balanceOf(USER);
        assertEq(balance, 1);
        // assertEq(basicNft.tokenURI(0), PUG_URI);
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG_URI))
        );
    }
}
