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
public class TstBaseV2 extends Contract {
    public static final String[] BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516103bb3803806103bb8339810180604052810190808051820192919050505033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600080819055508060029080519060200190610091929190610098565b505061013d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100d957805160ff1916838001178555610107565b82800160010185558215610107579182015b828111156101065782518255916020019190600101906100eb565b5b5090506101149190610118565b5090565b61013a91905b8082111561013657600081600090555060010161011e565b5090565b90565b61026f8061014c6000396000f300608060405260043610610057576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806381045ead1461005c57806388eb462814610087578063893d20e814610117575b600080fd5b34801561006857600080fd5b5061007161016e565b6040518082815260200191505060405180910390f35b34801561009357600080fd5b5061009c610177565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100dc5780820151818401526020810190506100c1565b50505050905090810190601f1680156101095780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561012357600080fd5b5061012c610219565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b606060028054600181600116156101000203166002900480601f01602080910402602001604051908101604052809291908181526020018280546001816001161561010002031660029004801561020f5780601f106101e45761010080835404028352916020019161020f565b820191906000526020600020905b8154815290600101906020018083116101f257829003601f168201915b5050505050905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a723058203ab6c6caa7be6b9878544e150992e633805790a9503f47a79984096389d345e10029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516103bb3803806103bb8339810180604052810190808051820192919050505033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600080819055508060029080519060200190610091929190610098565b505061013d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100d957805160ff1916838001178555610107565b82800160010185558215610107579182015b828111156101065782518255916020019190600101906100eb565b5b5090506101149190610118565b5090565b61013a91905b8082111561013657600081600090555060010161011e565b5090565b90565b61026f8061014c6000396000f300608060405260043610610057576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063b3433d301461005c578063c624d53414610087578063d4c46ced146100de575b600080fd5b34801561006857600080fd5b5061007161016e565b6040518082815260200191505060405180910390f35b34801561009357600080fd5b5061009c610177565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156100ea57600080fd5b506100f36101a1565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610133578082015181840152602081019050610118565b50505050905090810190601f1680156101605780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b606060028054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156102395780601f1061020e57610100808354040283529160200191610239565b820191906000526020600020905b81548152906001019060200180831161021c57829003601f168201915b50505050509050905600a165627a7a723058202e903ca06ec493faab01430f7f40d0a2adfef2038227717871c657bd4a3b48880029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[{\"constant\":true,\"inputs\":[],\"name\":\"getIndex\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getLoc\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"loc\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"}]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    public static final String FUNC_GETINDEX = "getIndex";

    public static final String FUNC_GETLOC = "getLoc";

    public static final String FUNC_GETOWNER = "getOwner";

    protected TstBaseV2(String contractAddress, Client client, CryptoKeyPair credential) {
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

    public static TstBaseV2 load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new TstBaseV2(contractAddress, client, credential);
    }

    public static TstBaseV2 deploy(Client client, CryptoKeyPair credential, String loc) throws ContractException {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new org.fisco.bcos.sdk.abi.datatypes.Utf8String(loc)));
        return deploy(TstBaseV2.class, client, credential, getBinary(client.getCryptoSuite()), encodedConstructor);
    }
}
