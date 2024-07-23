package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/stub"
)

type DecentralizedDataStorage struct {
}

func (c *DecentralizedDataStorage) Init(stub shim.ChaincodeStubInterface) []byte {
	return nil
}

func (c *DecentralizedDataStorage) Invoke(stub shim.ChaincodeStubInterface) ([]byte, error) {
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
	case "updateData":
		return c.updateData(stub, args)
	case "deleteData":
		return c.deleteData(stub, args)
	default:
		return nil, fmt.Errorf("Received unknown function invocation: %s", fcn)
	}
}

func (c *DecentralizedDataStorage) storeData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: key, value")
	}

	// Store the data
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return []byte("Datastored successfully"), nil
}

func (c *DecentralizedDataStorage) retrieveData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
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

func (c *DecentralizedDataStorage) updateData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: key, newValue")
	}

	// Update the data
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return []byte("Data updated successfully"), nil
}

func (c *DecentralizedDataStorage) deleteData(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 1 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 1: key")
	}

	// Delete the data
	err := stub.DelState(args[0])
	if err != nil {
		return nil, err
	}

	return []byte("Data deleted successfully"), nil
}

func main() {
	err := shim.Start(new(DecentralizedDataStorage))
	if err != nil {
		fmt.Printf("Error starting DecentralizedDataStorage chaincode: %s", err)
	}
}
