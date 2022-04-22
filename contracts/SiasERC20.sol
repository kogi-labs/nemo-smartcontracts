// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20SnapshotUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

/**
 * @title SIA Coin
 * @author SIAS Inc
 */

contract SiasERC20 is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    ERC20PausableUpgradeable,
    ERC20SnapshotUpgradeable,
    ERC20PermitUpgradeable,
    AccessControlEnumerableUpgradeable
{
    using SafeMathUpgradeable for uint256;

    bytes32 public constant MINTER_ROLE     = keccak256("MINTER_ROLE");
    bytes32 public constant FREEZE_ROLE     = keccak256("FREEZE_ROLE");
    uint256 private _maxSupply;
    uint256 private _supply;

    function initialize(string memory name, string memory symbol, uint256 maxSupply) public virtual initializer {        
        __ERC20_init(name, symbol);
        __Ownable_init();
        __ERC20Permit_init(name);
        
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _maxSupply = maxSupply;
        _supply = 0;
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(_supply.add(amount) <= _maxSupply, "Over maxSupply");
        _supply = _supply.add(amount);
        super._mint(account, amount);
    }

    ////////////////// ADMIN /////////////////
    function createSnapshot() public virtual returns (uint256) {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to snapshot");
        return _snapshot();
    }

        //admin view
    function mintFrom(address account, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
        _mint(account, amount);        
    }

    function mint(uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to mint");
        _mint(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to burnFrom");
        _burn(account, amount);
    }

    function addMinter(address account) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to addMinter");
        grantRole(MINTER_ROLE, account);
    }

    function removeMinter(address account) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to removeMinter");
        revokeRole(MINTER_ROLE, account);
    }

    function pause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to pause");
        _pause();
    }

    function unpause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Must have admin role to unpause");
        _unpause();
    }

    ////////////////// MINTER /////////////////
    function freeze(address account) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to freeze");
        grantRole(FREEZE_ROLE, account);
    }

    function unfreeze(address account) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "Must have minter role to unfreeze");
        revokeRole(FREEZE_ROLE, account);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Upgradeable, ERC20PausableUpgradeable, ERC20SnapshotUpgradeable) {
        require(!hasRole(FREEZE_ROLE, from), "Account temporarily unavailable.");
        super._beforeTokenTransfer(from, to, amount);
    }

    ////////////////// ANON /////////////////
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }
    
    function maxSupply() public view virtual returns (uint256) {
        return _maxSupply;
    }

    function version() public view virtual returns (uint256) {
        return 202201141;
    }
}