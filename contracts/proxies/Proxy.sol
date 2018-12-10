pragma solidity ^0.5.0;

/**
  @title Proxy - Generic proxy contract.
*/
contract Proxy {
    
    /** 
      @dev Constructor function sets address of marmo instance contract.
      @param _instance marmo instance address.
    */
    constructor(address _instance) public {
        require(_instance != address(0), "Invalid marmo instance address provided");
        assembly {
            // keccak256('rcn.marmo.proxy')
            sstore(0x3d9b1ee906add9fda2547fb4cd1c5758e541fe5481baf32e98bbd15d09a0c406, _instance)
        }
    }

    function () external payable {
        assembly {
            // keccak256('rcn.marmo.proxy')
            let instance := sload(0x3d9b1ee906add9fda2547fb4cd1c5758e541fe5481baf32e98bbd15d09a0c406)
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize)
            
            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas, instance, 0, calldatasize, 0, 0)
            
            // Copy the returned data.
            returndatacopy(0, 0, returndatasize)
            
            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize) }
            default { return(0, returndatasize) }
        }
    }
}