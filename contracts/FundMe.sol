// SPDX-License-Identifier: MIT
// Pragma
pragma solidity ^0.8.7;
// Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";
// Error Codes
error FundMe__NotOwner();

//Interfaces, Libraries, Contracts
/** @title A contract for crowd funding
 *  @author BeastDevMoney
 *  @notice This contract is to demo a samle funding contract
 *  @dev This implements price feeds as our library
 */
contract FundMe {
    //Type Declarations
    using PriceConverter for uint256;

    //State Variables

    uint256 public constant minimumUSD = 50 * 1e18; //constant variables are cheaper when it is called than normal variables
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable owner;
    AggregatorV3Interface public priceFeed;

    modifier onlyOwner() {
        //require(msg.sender == owner);
        if (msg.sender != owner) revert FundMe__NotOwner();
        _;
    }

    //Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure

    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    /**
     *  @notice This function funds this contract
     *  @dev This implements price feeds as our library
    here you can put "paramaters" and "returns" if it has the function
     */
    function fund() public payable {
        require( //the first parameter it goint to be msg.value and the second paramater it's going to be priceFeed
            msg.value.getConversionRate(priceFeed) >= minimumUSD,
            "Didn't send enough!"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        //transfer
        //msg.sender = address
        //payable(msg.sender) = payable address
        //call
        (bool callSucces, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucces, "Call failed");
        //this it refers to the hole contract
    }
}
