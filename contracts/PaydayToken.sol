// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Pausable} from "@openzeppelin/contracts/security/Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Payday Token
/// @notice Research-grade ERC-20 token for Sepolia testnet analysis.
/// @dev Includes standard features: minting, burning, pause, ownership.
contract PaydayToken is ERC20, ERC20Burnable, Pausable, Ownable {
    uint256 public constant MAX_SUPPLY = 1_800_000_000 ether;
    uint256 public constant INITIAL_SUPPLY = 100_000_000 ether;

    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event TokensPaused();
    event TokensUnpaused();

    constructor() ERC20("Payday Token", "PAYDAY") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
        emit TokensMinted(msg.sender, INITIAL_SUPPLY);
    }

    /// @notice Mint new tokens (owner only).
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    /// @notice Pause all transfers.
    function pause() external onlyOwner {
        _pause();
        emit TokensPaused();
    }

    /// @notice Resume all transfers.
    function unpause() external onlyOwner {
        _unpause();
        emit TokensUnpaused();
    }

    /// @notice Burn tokens from caller's balance.
    function burn(uint256 amount) public override {
        super.burn(amount);
        emit TokensBurned(msg.sender, amount);
    }

    /// @notice Burn tokens from a specific address (requires approval).
    function burnFrom(address account, uint256 amount) public override {
        super.burnFrom(account, amount);
        emit TokensBurned(account, amount);
    }

    /// @notice Internal hook to enforce pause state on transfers.
    function _update(address from, address to, uint256 amount) internal override whenNotPaused {
        super._update(from, to, amount);
    }
}
