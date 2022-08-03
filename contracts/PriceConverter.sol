//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint256)
    {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        //Eth in terms of USD
        //to convert the variable int256 price to uint256 price, we have to write the sintax like the underline.Also, we have to avilitate the function to make changes on the state
        return uint256(price * 1e10);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        return priceFeed.version();
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; //we have to make that divison, because its a multiplication and the compiler will display 21 zeros
        return ethAmountInUsd;
    }
}
