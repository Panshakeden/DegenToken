// SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract DegenToken is ERC20 {

    address public owner;
    mapping (address => bool)  DegenKnives;
    mapping (address => bool)  getDegenGun;
    mapping (address => bool)  gameDegenMap;
    mapping (address => bool)  extraBlood;
    mapping (address => bool)  startGame;

    error InvalidInput();
   


    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender;
    }

  
    function onlyOwner() private view {
        require(msg.sender==owner,"you are not the owner");
    }

    function hasEnoughDegenTokens(uint256 _value) private view {
            require(balanceOf(msg.sender) >= _value, "you don't have enough token");
    }

    function mintDegenTokens(address _player, uint256 _amount) public {
        onlyOwner();
        _mint(_player, _amount);
    }

    function burnDegenTokens(uint256 amount) public {
        hasEnoughDegenTokens(amount);
        _burn(msg.sender, amount);
    }

    function transferDegenToken(address to, uint256 amount)
        public
        returns (bool)
    {
        hasEnoughDegenTokens(amount);
        _transfer(msg.sender, to, amount);
        return true;
    }

    function getDegenTokenBalance(address _playerAddr) public view returns (uint256) {
        return super.balanceOf(_playerAddr);
    }

    function viewMarketplace() external pure returns (string memory) {
        return "Marketplace: 1. DegenKnives - 10DGN, 2. getDegenGun - 20DGN, 3. gameDegenMap - 30DGN 4.extraBlood - 40DGN ";
    }

    function degenMarketPlaceItem(uint256 _itemToBuy) external returns (bool) {

        if (_itemToBuy == 1) {

            require(this.balanceOf(msg.sender)>= 10,"No enought funds to buy");
            
            approve(msg.sender, 10);
            
            transferFrom(msg.sender, owner, 10);
            
            DegenKnives[msg.sender] = true;
            
            return true;
        
        } else if (_itemToBuy == 2) {
            
            require(DegenKnives[msg.sender], "buy knives proof first");

            require(this.balanceOf(msg.sender)>=20,"No enough balance");
            
            approve(msg.sender, 20);
            
            transferFrom(msg.sender, owner, 20);
            
            getDegenGun[msg.sender] = true;
            
            return true;

        } else if (_itemToBuy == 3) {

            require(!getDegenGun[msg.sender],"You must buy gun first"); 
            require(this.balanceOf(msg.sender) >= 30,"No enough balance");
            
            approve(msg.sender, 30);
            
            transferFrom(msg.sender, owner, 30);
            
            gameDegenMap[msg.sender] = true;

            startGame[msg.sender] = true;
                        
            return true;

        }else if (_itemToBuy == 4) {

            require(this.balanceOf(msg.sender) > 30,"No enough balance");
            
            approve(msg.sender, 40);
            
            transferFrom(msg.sender, owner, 40);
            
            extraBlood[msg.sender] = true;

            startGame[msg.sender] = true;
                        
            return true;

        }
        
        
         else {

            revert InvalidInput();
        
        }
    }

    function playerPlay() external view  returns (bool) {
        return startGame[msg.sender];
    }
}