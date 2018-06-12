pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------------
// A Sample Token which adheres to the ERC20 token standard.
// This is not a real token, its purpose is to exercise the the ERC20 standard
// implemented in the TemplateERC20 contract
// Dat Nguyen - 2017
// ----------------------------------------------------------------------------------


import "../installed/TemplateERC20.sol";

contract Billboard is TemplateERC20 {

    using SafeMath for uint;

    address owner;
    uint maxSpaces;

    struct Adspace {
        uint id;
        address owner;
        bool onSale;
        uint salePrice;
        bool leaseAvailable;
        uint leasePrice;
    }

    struct Lease {
        address lessor;
        uint leaseStartTime;
        uint leaseEndTime;
        uint salePrice;
    }

    struct Ad {
        string title;
        string text;
    }

    Adspace[] adSpaces;
    Ad[] ads;
    Leases[] leases;

    modifier validId(uint _id) {
        require(_id >= 0 && _id <tokenSupply);
        _;
    }

    modifier validOwner(uint _id, address sender) {
        require(adSpaces[_id].owner == sender);
        _;
    }

    constructor (uint _maxSpaces) public {
        tokenSupply = _maxSpaces;
        tokenName = "Billboard";
        tokenSymbol = "BB";
        tokenDecimals = 0;
        maxSpaces = _maxSpaces;

        //set the token owner
        owner = msg.sender;

        //Give all the tokens to creator initially
        balances[owner] = tokenSupply;

        for (uint i=0; i<tokenSupply; i++)
        {
            adSpaces.push(Adspace(i, owner, true, 0, false, 0));
            ads.push(Ad("On Sale/Lease","This Ad For Sale/Lease"));
        }
    }

    function updateAd(uint _id, string _title, string _text) public validId(_id) validOwner(_id, msg.sender) returns (bool _updated) {
        ads[_id].title = _title;
        ads[_id].text = _text;

        emit logAdUpdated(_id, ads[_id].title, ads[_id].text);

        return true;
    }

    function getAd(uint _id) public validId(_id) view returns (uint _returnId, string title, string text) {
        return (_id, ads[_id].title, ads[_id].text);
    }

    function getAdSpace(uint _id) public validId(_id) view returns (uint _returnId, address _owner, bool _onSale, uint _salePrice) {
        return (_id, adSpaces[_id].owner, adSpaces[_id].onSale, adSpaces[_id].salePrice);
    }

    function sellAdspace(uint _id, uint _salePrice) public validId(_id) validOwner(_id, msg.sender) returns (bool _onSale) {
        adSpaces[_id].onSale = true;
        adSpaces[_id].salePrice = _salePrice;

        emit logAdSpaceForSale(_id, _salePrice, msg.sender);

        return true;
    }

    function transferSpace(uint _id, address _to) public validId(_id) validOwner(_id, msg.sender) returns (bool _transferred) {
        adSpaces[_id].owner = _to;

        emit logAdSpaceTransferred(_id, msg.sender, _to);

        return transfer(_to, 1);
    }

    function buySpace(uint _id) public payable returns (bool sold) {
        require(adSpaces[_id].onSale == true && msg.value >= adSpaces[_id].salePrice);
        adSpaces[_id].owner.transfer(msg.value);
        _transfer(adSpaces[_id].owner, msg.sender, 1);

        emit logAdSpacePurchased(_id, msg.value, adSpaces[_id].owner, msg.sender);

        adSpaces[_id].onSale = false;
        adSpaces[_id].salePrice = 0;
        adSpaces[_id].owner = msg.sender;

        return true;
    }

    function buySpace(uint _id, string _title, string _text) public payable returns (bool sold) {
        require(adSpaces[_id].onSale == true && msg.value >= adSpaces[_id].salePrice);
        buySpace(_id);
        updateAd(_id, _title, _text);
        return true;
    }

    event logAdSpaceForSale(uint id, uint salePrice, address seller);
    event logAdSpacePurchased(uint id, uint salePrice, address seller, address buyer);
    event logAdSpaceTransferred(uint id, address from, address to);
    event logAdUpdated(uint id, string title, string text);
}
