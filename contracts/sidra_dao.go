package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/stub"
)

type SidraDAO struct {
}

func (c *SidraDAO) Init(stub shim.ChaincodeStubInterface) []byte {
	return nil
}

func (c *SidraDAO) Invoke(stub shim.ChaincodeStubInterface) ([]byte, error) {
	fmt.Println("Received invoke request")

	// Get the function and args from the stub
	fmt.Println("Getting function and args")
	fcn, args := stub.GetFunctionAndParameters()

	// Handle different functions
	switch fcn {
	case "proposeProposal":
		return c.proposeProposal(stub, args)
	case "voteOnProposal":
		return c.voteOnProposal(stub, args)
	case "executeProposal":
		return c.executeProposal(stub, args)
	default:
		return nil, fmt.Errorf("Received unknown function invocation: %s", fcn)
	}
}

func (c *SidraDAO) proposeProposal(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: proposalID, proposalData")
	}

	// Propose a new proposal
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return []byte("Proposal proposed successfully"), nil
}

func (c *SidraDAO) voteOnProposal(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 2 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 2: proposalID, vote")
	}

	// Vote on a proposal
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return nil, err
	}

	return []byte("Vote cast successfully"), nil
}

func (c *SidraDAO) executeProposal(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	// Check the number of arguments
	if len(args) != 1 {
		return nil, fmt.Errorf("Incorrect number of arguments. Expecting 1: proposalID")
	}

	// Execute a proposal
	err := stub.PutState(args[0], []byte("executed"))
	if err != nil {
		return nil, err
	}

	return []byte("Proposal executed successfully"), nil
}

func main() {
	err := shim.Start(new(SidraDAO))
	if err != nil {
		fmt.Printf("Error starting SidraDAO chaincode: %s", err)
	}
}
