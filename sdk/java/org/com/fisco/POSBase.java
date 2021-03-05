package org.com.fisco;

import java.math.BigInteger;
import java.util.Arrays;
import org.fisco.bcos.sdk.abi.FunctionEncoder;
import org.fisco.bcos.sdk.abi.TypeReference;
import org.fisco.bcos.sdk.abi.datatypes.Address;
import org.fisco.bcos.sdk.abi.datatypes.Function;
import org.fisco.bcos.sdk.abi.datatypes.Type;
import org.fisco.bcos.sdk.abi.datatypes.generated.Uint256;
import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSBase extends Contract {
    public static final String[] BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516102753803806102758339810180604052810190808051820192919050505033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600080819055508060029080519060200190610091929190610098565b505061013d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100d957805160ff1916838001178555610107565b82800160010185558215610107579182015b828111156101065782518255916020019190600101906100eb565b5b5090506101149190610118565b5090565b61013a91905b8082111561013657600081600090555060010161011e565b5090565b90565b6101298061014c6000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806363a4085214604e578063893d20e8146076575b600080fd5b348015605957600080fd5b50606060ca565b6040518082815260200191505060405180910390f35b348015608157600080fd5b50608860d3565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a72305820552eac99fcb2fc67839e8c6aea1660b60f2b3e0a366315dd7b0157a43471b9570029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"608060405234801561001057600080fd5b506040516102753803806102758339810180604052810190808051820192919050505033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600080819055508060029080519060200190610091929190610098565b505061013d565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106100d957805160ff1916838001178555610107565b82800160010185558215610107579182015b828111156101065782518255916020019190600101906100eb565b5b5090506101149190610118565b5090565b61013a91905b8082111561013657600081600090555060010161011e565b5090565b90565b6101298061014c6000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806375bfac0214604e578063c624d534146076575b600080fd5b348015605957600080fd5b50606060ca565b6040518082815260200191505060405180910390f35b348015608157600080fd5b50608860d3565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a72305820ae73dc777d3a2dff8e8d80e8c58f754eb380d75f826eb58490d5b798336e92d70029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[{\"constant\":true,\"inputs\":[],\"name\":\"getInex\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"loc\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"}]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    public static final String FUNC_GETINEX = "getInex";

    public static final String FUNC_GETOWNER = "getOwner";

    protected POSBase(String contractAddress, Client client, CryptoKeyPair credential) {
        super(getBinary(client.getCryptoSuite()), contractAddress, client, credential);
    }

    public static String getBinary(CryptoSuite cryptoSuite) {
        return (cryptoSuite.getCryptoTypeConfig() == CryptoType.ECDSA_TYPE ? BINARY : SM_BINARY);
    }

    public BigInteger getInex() throws ContractException {
        final Function function = new Function(FUNC_GETINEX, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Uint256>() {}));
        return executeCallWithSingleValueReturn(function, BigInteger.class);
    }

    public String getOwner() throws ContractException {
        final Function function = new Function(FUNC_GETOWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeCallWithSingleValueReturn(function, String.class);
    }

    public static POSBase load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new POSBase(contractAddress, client, credential);
    }

    public static POSBase deploy(Client client, CryptoKeyPair credential, String loc) throws ContractException {
        String encodedConstructor = FunctionEncoder.encodeConstructor(Arrays.<Type>asList(new org.fisco.bcos.sdk.abi.datatypes.Utf8String(loc)));
        return deploy(POSBase.class, client, credential, getBinary(client.getCryptoSuite()), encodedConstructor);
    }
}
