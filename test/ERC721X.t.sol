// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {InvisibeGardebNFTX} from "../src/ERC721X.sol";
import {IERC721} from "../src/interfaces/IERC721.sol";

contract ERC721XTest is Test {
    InvisibeGardebNFTX public nft;
    address public alice = address(0x1);
    address public bob = address(0x2);
    uint256 public constant INITIAL_TOKEN_ID = 0;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function setUp() public {
        nft = new InvisibeGardebNFTX("Invisibe Gardeb NFTX", "IGNFTX");
        // Mint initial token to alice
        vm.prank(address(this));
        nft.mint(alice);
    }

    function testInitialOwnership() public view {
        assertEq(nft.ownerOf(INITIAL_TOKEN_ID), alice);
        assertEq(nft.balanceOf(alice), 1);
    }

    function testTransfer() public {
        vm.prank(alice);
        vm.expectEmit(true, true, true, false);
        emit Transfer(alice, bob, INITIAL_TOKEN_ID);
        nft.transferFrom(alice, bob, INITIAL_TOKEN_ID);
        assertEq(nft.ownerOf(INITIAL_TOKEN_ID), bob);
        assertEq(nft.balanceOf(alice), 0);
        assertEq(nft.balanceOf(bob), 1);
    }

    function testMint() public {
        uint256 newTokenId = nft.mint(bob);
        assertEq(nft.ownerOf(newTokenId), bob);
        assertEq(nft.balanceOf(bob), 1);
    }

    function testBurn() public {
        vm.prank(alice);
        nft.burn(INITIAL_TOKEN_ID);
        vm.expectRevert("ERC721: invalid token ID");
        nft.ownerOf(INITIAL_TOKEN_ID);
        assertEq(nft.balanceOf(alice), 0);
    }

    function testFailBurnUnauthorized() public {
        vm.prank(bob);
        nft.burn(INITIAL_TOKEN_ID);
    }
}
