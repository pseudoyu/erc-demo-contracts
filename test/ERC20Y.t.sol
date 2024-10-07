// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {InvisibeGardebTokenY} from "../src/ERC20Y.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20YTest is Test {
    InvisibeGardebTokenY public token;
    address public alice = address(0x1);
    address public bob = address(0x2);
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10 ** 18;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        token = new InvisibeGardebTokenY(INITIAL_SUPPLY);
        // Transfer initial supply to alice
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), alice, INITIAL_SUPPLY);
        token.transfer(alice, INITIAL_SUPPLY);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
        assertEq(token.balanceOf(alice), INITIAL_SUPPLY);
    }

    function testTransfer() public {
        uint256 amount = 1000 * 10 ** 18;
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, bob, amount);
        bool success = token.transfer(bob, amount);
        assertTrue(success);
        assertEq(token.balanceOf(alice), INITIAL_SUPPLY - amount);
        assertEq(token.balanceOf(bob), amount);
    }

    function testApproveAndTransferFrom() public {
        uint256 amount = 1000 * 10 ** 18;
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Approval(alice, bob, amount);
        bool success = token.approve(bob, amount);
        assertTrue(success);
        assertEq(token.allowance(alice, bob), amount);

        vm.prank(bob);
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, bob, amount);
        success = token.transferFrom(alice, bob, amount);
        assertTrue(success);
        assertEq(token.balanceOf(alice), INITIAL_SUPPLY - amount);
        assertEq(token.balanceOf(bob), amount);
        assertEq(token.allowance(alice, bob), 0);
    }

    function testNameAndSymbol() public view {
        assertEq(token.name(), "InvisibeGardebTokenY");
        assertEq(token.symbol(), "IGTY");
    }

    function testDecimals() public view {
        assertEq(token.decimals(), 18);
    }

    function testFailTransferInsufficientBalance() public {
        uint256 amount = INITIAL_SUPPLY + 1;
        vm.prank(alice);
        token.transfer(bob, amount);
    }

    function testFailTransferFromInsufficientAllowance() public {
        uint256 amount = 1000 * 10 ** 18;
        vm.prank(alice);
        token.approve(bob, amount - 1);

        vm.prank(bob);
        token.transferFrom(alice, bob, amount);
    }

    function testApprovalEvent() public {
        uint256 amount = 1000 * 10 ** 18;
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Approval(alice, bob, amount);
        token.approve(bob, amount);
    }

    function testTransferEvent() public {
        uint256 amount = 1000 * 10 ** 18;
        vm.prank(alice);
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, bob, amount);
        token.transfer(bob, amount);
    }
}
