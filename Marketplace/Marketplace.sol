// DESCRIPTION: A simple Marketplace to add and buy items without funds transfer

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract MarketPlace {
    struct Item {
        string name;
        uint256 price;
        bool sold;
    }

    Item[] public listOfItems;

    // Event to log when an item is purchased
    event ItemPurchased(uint256 indexed itemId);

    // Function to add an item to the list
    function addItem(string memory _name, uint256 _price) public {
        listOfItems.push(Item({
            name: _name,
            price: _price,
            sold: false
        }));
    }

    // Function to buy an item
    function buyItem(uint256 _itemId) public {
        // Check that the item exists
        require(_itemId < listOfItems.length, "Item does not exist");

        // Get the item from the list
        Item storage item = listOfItems[_itemId];

        // Ensure the item is not already sold
        require(!item.sold, "Item is already sold");

        // Mark the item as sold
        item.sold = true;

        // Event to log the purchase
        emit ItemPurchased(_itemId);
    }

    // Function to get the total number of items
    function getItemCount() public view returns (uint256) {
        return listOfItems.length;
    }

}
