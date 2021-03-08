package org.com.fisco;

import java.math.BigInteger;
import java.util.Arrays;
import org.fisco.bcos.sdk.abi.FunctionEncoder;
import org.fisco.bcos.sdk.abi.TypeReference;
import org.fisco.bcos.sdk.abi.datatypes.Address;
import org.fisco.bcos.sdk.abi.datatypes.Function;
import org.fisco.bcos.sdk.abi.datatypes.Type;
import org.fisco.bcos.sdk.abi.datatypes.Utf8String;
import org.fisco.bcos.sdk.abi.datatypes.generated.Uint256;
import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class DianIn extends Contract {
    public static final String[] BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516105e33803806105e3833981018060405281019080805182019291905050508033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000808190555080600290805190602001906100929291906102c0565b50506100ac816100b2640100000000026401000000009004565b50610365565b6100c96102b6640100000000026401000000009004565b73ffffffffffffffffffffffffffffffffffffffff166356004b6a6040805190810160405280600681526020017f706f735f696e0000000000000000000000000000000000000000000000000000815250836040518363ffffffff167c010000000000000000000000000000000000000000000000000000000002815260040180806020018060200180602001848103845286818151815260200191508051906020019080838360005b8381101561018e578082015181840152602081019050610173565b50505050905090810190601f1680156101bb5780820380516001836020036101000a031916815260200191505b50848103835285818151815260200191508051906020019080838360005b838110156101f45780820151818401526020810190506101d9565b50505050905090810190601f1680156102215780820380516001836020036101000a031916815260200191505b508481038252600e8152602001807f62657274685f69642c696e64657800000000000000000000000000000000000081525060200195505050505050602060405180830381600087803b15801561027757600080fd5b505af115801561028b573d6000803e3d6000fd5b505050506040513d60208110156102a157600080fd5b81019080805190602001909291905050505050565b6000611001905090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061030157805160ff191683800117855561032f565b8280016001018555821561032f579182015b8281111561032e578251825591602001919060010190610313565b5b50905061033c9190610340565b5090565b61036291905b8082111561035e576000816000905550600101610346565b5090565b90565b61026f806103746000396000f300608060405260043610610057576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806381045ead1461005c57806388eb462814610087578063893d20e814610117575b600080fd5b34801561006857600080fd5b5061007161016e565b6040518082815260200191505060405180910390f35b34801561009357600080fd5b5061009c610177565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100dc5780820151818401526020810190506100c1565b50505050905090810190601f1680156101095780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561012357600080fd5b5061012c610219565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b606060028054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561020f5780601f106101e45761010080835404028352916020019161020f565b820191906000526020600020905b8154815290600101906020018083116101f257829003601f168201915b5050505050905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a723058201a097adfff99c9af4f3896e56a40854a68db6fbe9b02f95c6aea08f475c4e1aa0029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516105e33803806105e3833981018060405281019080805182019291905050508033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506000808190555080600290805190602001906100929291906102c0565b50506100ac816100b2640100000000026401000000009004565b50610365565b6100c96102b6640100000000026401000000009004565b73ffffffffffffffffffffffffffffffffffffffff1663c92a78016040805190810160405280600681526020017f706f735f696e0000000000000000000000000000000000000000000000000000815250836040518363ffffffff167c010000000000000000000000000000000000000000000000000000000002815260040180806020018060200180602001848103845286818151815260200191508051906020019080838360005b8381101561018e578082015181840152602081019050610173565b50505050905090810190601f1680156101bb5780820380516001836020036101000a031916815260200191505b50848103835285818151815260200191508051906020019080838360005b838110156101f45780820151818401526020810190506101d9565b50505050905090810190601f1680156102215780820380516001836020036101000a031916815260200191505b508481038252600e8152602001807f62657274685f69642c696e64657800000000000000000000000000000000000081525060200195505050505050602060405180830381600087803b15801561027757600080fd5b505af115801561028b573d6000803e3d6000fd5b505050506040513d60208110156102a157600080fd5b81019080805190602001909291905050505050565b6000611001905090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061030157805160ff191683800117855561032f565b8280016001018555821561032f579182015b8281111561032e578251825591602001919060010190610313565b5b50905061033c9190610340565b5090565b61036291905b8082111561035e576000816000905550600101610346565b5090565b90565b61026f806103746000396000f300608060405260043610610057576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063b3433d301461005c578063c624d53414610087578063d4c46ced146100de575b600080fd5b34801561006857600080fd5b5061007161016e565b6040518082815260200191505060405180910390f35b34801561009357600080fd5b5061009c610177565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156100ea57600080fd5b506100f36101a1565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610133578082015181840152602081019050610118565b50505050905090810190601f1680156101605780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b606060028054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156102395780601f1061020e57610100808354040283529160200191610239565b820191906000526020600020905b81548152906001019060200180831161021c57829003601f168201915b50505050509050905600a165627a7a72305820b2a62289e622c3256bb4344c48a8f9f720afea87fd216d72f1e2da0e72094b8f0029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[{\"constant\":true,\"inputs\":[],\"name\":\"getIndex\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getLoc\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"loc\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"}]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    public static final String FUNC_GETINDEX = "getIndex";

    public static final String FUNC_GETLOC = "getLoc";

    public static final String FUNC_GETOWNER = "getOwner";

    protected DianIn(String contractAddress, Client client, CryptoKeyPair credential) {
        super(getBinary(client.getCryptoSuite()), contractAddress, client, credential);
    }

    public static String getBinary(CryptoSuite cryptoSuite) {
        return (cryptoSuite.getCryptoTypeConfig() == CryptoType.ECDSA_TYPE ? BINARY : SM_BINARY);
    }

    public BigInteger getIndex() throws ContractException {
        final Function function = new Function(FUNC_GETINDEX, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeCallWithSingleValueReturn(function, BigInteger.class);
    }

    public String getLoc() throws ContractException {
        final Function function = new Function(FUNC_GETLOC, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Utf8String>() {}));
        return executeCallWithSingleValueReturn(function, String.class);
    }

    public String getOwner() throws ContractException {
        final Function function = new Function(FUNC_GETOWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeCallWithSingleValueReturn(function, String.class);
    }

    public static DianIn load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new DianIn(contractAddress, client, credential);
    }

    public static DianIn deploy(Client client, CryptoKeyPair credential, String loc) throws ContractException {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new org.fisco.bcos.sdk.abi.datatypes.Utf8String(loc)));
        return deploy(DianIn.class, client, credential, getBinary(client.getCryptoSuite()), encodedConstructor);
    }
}
