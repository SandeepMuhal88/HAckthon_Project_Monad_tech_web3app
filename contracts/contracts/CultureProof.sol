// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CultureProof is ERC721, Ownable {
    uint256 public tokenIdCounter;

    constructor()
        ERC721("Culture Proof", "POC")
        Ownable(msg.sender)
    {}

    function mint(address to) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter++;

        _safeMint(to, tokenId);
    }

    /**
     * @dev Override OpenZeppelin v5 transfer hook
     * Blocks all transfers except minting
     */
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override returns (address) {
        address from = _ownerOf(tokenId);

        // Allow minting only
        if (from != address(0)) {
            revert("Soulbound: transfer blocked");
        }

        return super._update(to, tokenId, auth);
    }
}
