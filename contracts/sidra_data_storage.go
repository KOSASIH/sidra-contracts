package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/stub"
)

type SidraDataStorage struct {
}

func (c *SidraDataStorage) Init(stub shim.ChaincodeStubInterface) []byte {
	return nil
}

func (c *SidraDataStorage) Invoke(stub shim.ChaincodeStubInterface) ([]byte, error) {
	fmt.Println("Received invoke request")

	// Get the function and args from the stub
	fmt.Println("Getting function and args")
	fcn, args := stub.GetFunctionAndParameters()

	// Handle different functions
	switch fcn {
	case "storeData":
		return c.storeData(stub, args)
	case "retrieveData":
		return c.retrieveData(stub, args)
	default:
		return nil, fmt.Errorf("Received unknown function invocation: %s", fcn)
	}
}

func (c *SidraDataStorage) storeData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: key, value")
	}

	// Store the data
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return []byte("Data stored successfully"), nil
}

func (c *SidraDataStorage) retrieveData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 1 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 1: key")
	}

	// Retrieve the data
	data, err := stub.GetState(args[0])
	if err != nil {
		return nil, err
	}

	return data, nil
}

func main() {
	err := shim.Start(new(SidraDataStorage))
	if err != nil {
		fmt.Printf("Error starting SidraDataStorage chaincode: %s", err)
	}
}
