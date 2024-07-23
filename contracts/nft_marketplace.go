package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/stub"
)

type NFTMarketplace struct {
}

func (c *NFTMarketplace) Init(stub shim.ChaincodeStubInterface) []byte {
	return nil
}

func (c *NFTMarketplace) Invoke(stub shim.ChaincodeStubInterface) ([]byte, error){
	fmt.Println("Received invoke request")

	// Get the function and args from the stub
	fmt.Println("Getting function and args")
	fcn, args := stub.GetFunctionAndParameters()

	// Handle different functions
	switch fcn {
	case "createNFT":
		return c.createNFT(stub, args)
	case "transferNFT":
		return c.transferNFT(stub, args)
	case "getNFT":
		return c.getNFT(stub, args)
	case "listNFT":
		return c.listNFT(stub, args)
	case "buyNFT":
		return c.buyNFT(stub, args)
	default:
		return nil, fmt.Errorf("Received unknown function invocation: %s", fcn)
	}
}

func (c *NFTMarketplace) createNFT(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 3 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 3: owner, name, description")
	}

	// Create the NFT
	nftID := fmt.Sprintf("%s-%s", args[1], args[2])
	err := stub.PutState(nftID, []byte(args[0]))
	if err != nil {
		return nil, err
	}

	return []byte(fmt.Sprintf("Successfully created NFT with ID %s", nftID)), nil
}

func (c *NFTMarketplace) transferNFT(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: ID, newOwner")
	}

	// Transfer the NFT
	nftBytes, err := stub.GetState(args[0])
	if err != nil {
		return nil, err
	}

	err = stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return nftBytes, nil
}

func (c *NFTMarketplace) getNFT(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 1 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 1: ID")
	}

	// Get the NFT
	nftBytes, err := stub.GetState(args[0])
	if err != nil {
		return nil, err
	}

	return nftBytes, nil
}

func (c *NFTMarketplace) listNFT(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Get all NFTs
	nfts, err := stub.GetStateByRange("", "")
	if err != nil {
		return nil, err
	}

	// Format the response
	response := "List of NFTs:\n"
	for nftID, nftBytes := range nfts {
		response += fmt.Sprintf("ID: %s, Owner: %s\n", nftID, string(nftBytes))
	}

	return []byte(response), nil
}

func (c *NFTMarketplace) buyNFT(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: ID, newOwner")
	}

	// Transfer the NFT
	nftBytes, err := stub.GetState(args[0])
	if err != nil {
		return nil, err
	}

	err = stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	// Transfer the payment
	payment := 100000000 // 1 ETH
	err = stub.TransferAsset(args[1], "ethereum", payment)
	if err != nil {
		return nil, err
	}

	return nftBytes, nil
}

func main() {
	err := shim.Start(new(NFTMarketplace))
	if err != nil {
		fmt.Printf("Error starting NFTMarketplace chaincode: %s", err)
	}
}
