const { assert, expect } = require("chai")
const { deployments, ethers, getNamedAccounts } = require("hardhat")

describe("FundMe", async function () {
    let fundMe
    let deployer
    let mockV3Aggregator
    const sendValue = ethers.utils.parseEther("1") // that converts the 1 to the amount of ether

    beforeEach(async () => {
        // deploy our fundMe contract
        // using Hardhat-deploy
        // const accounts = await ethers.getSigners()
        // const accountZero = accounts[0]
        deployer = (await getNamedAccounts()).deployer //this catch the deployer object and signed on deployer
        await deployments.fixture(["all"]) //fixture from hardhat allows us to acces all tags of the folders and files
        fundMe = await ethers.getContract("FundMe", deployer) //now, fundMe variable would be equal to the contract FundMe
        mockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })

    describe("constructor", async function () {
        it("sets the aggregator addresses correctly", async function () {
            const response = await fundMe.getPriceFeed() //this will run locally the priceFeed variable of the smartcontract
            assert.equal(response, mockV3Aggregator.address)
        })
    })

    describe("fund", async function () {
        it("Didn't send enough", async function () {
            await expect(fundMe.fund()).to.be.revertedWith(
                "Didn't send enough!"
            )
        })
    })
})
