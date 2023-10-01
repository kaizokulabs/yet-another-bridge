// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/YABToken.sol";

contract YABTokenTest is Test {
    YABToken public yt;

    function setUp() public {
        yt = new YABToken();
    }

    function testMint() public {
        yt.mint(address(this), 1000);
        assertEq(yt.balanceOf(address(this)), 1000);
    }

    function testBurn() public {
        yt.mint(address(this), 1000);
        yt.burn(address(this), 500);
        assertEq(yt.balanceOf(address(this)), 500);
        yt.burn(address(this), 500);
        assertEq(yt.balanceOf(address(this)), 0);
    }
}
