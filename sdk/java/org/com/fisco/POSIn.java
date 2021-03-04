package org.com.fisco;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.fisco.bcos.sdk.abi.TypeReference;
import org.fisco.bcos.sdk.abi.datatypes.Address;
import org.fisco.bcos.sdk.abi.datatypes.Event;
import org.fisco.bcos.sdk.abi.datatypes.Function;
import org.fisco.bcos.sdk.abi.datatypes.Type;
import org.fisco.bcos.sdk.abi.datatypes.Utf8String;
import org.fisco.bcos.sdk.abi.datatypes.generated.Int256;
import org.fisco.bcos.sdk.abi.datatypes.generated.Uint256;
import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.eventsub.EventCallback;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.model.TransactionReceipt;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSIn extends Contract {
    public static final String[] BINARY_ARRAY = {"608060405234801561001057600080fd5b5033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16600073ffffffffffffffffffffffffffffffffffffffff167f342827c97908e5e2f71151c08502a66d44b6f758e3ac2f1de95f02eb95f0a73560405160405180910390a3600080819055506100ed6100f2640100000000026401000000009004565b6102bc565b600061100190508073ffffffffffffffffffffffffffffffffffffffff166356004b6a6040518163ffffffff167c010000000000000000000000000000000000000000000000000000000002815260040180806020018060200180602001848103845260068152602001807f706f735f696e0000000000000000000000000000000000000000000000000000815250602001848103835260038152602001807f6c6f630000000000000000000000000000000000000000000000000000000000815250602001848103825260658152602001807f62657274685f69642c696e6465782c696e5f74696d652c696e5f74696d655f7481526020017f7970652c696e5f747970652c706c6174655f69642c7072657061795f6c656e2c81526020017f7072657061795f6d6f6e65792c76656869636c655f747970652c696e5f70696381526020017f5f686173680000000000000000000000000000000000000000000000000000008152506080019350505050602060405180830381600087803b15801561027d57600080fd5b505af1158015610291573d6000803e3d6000fd5b505050506040513d60208110156102a757600080fd5b81019080805190602001909291905050505050565b610129806102cb6000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806381045ead14604e578063893d20e8146076575b600080fd5b348015605957600080fd5b50606060ca565b6040518082815260200191505060405180910390f35b348015608157600080fd5b50608860d3565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a72305820e7a4b956bb9a0bcb78002f0da25da61520e44c929ae3b531313c846f6d4b47fd0029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"608060405234801561001057600080fd5b5033600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16600073ffffffffffffffffffffffffffffffffffffffff167fd2929388db7b1707269690886fe71e50184a289bc15d26fb3e4bf1b17e337da560405160405180910390a3600080819055506100ed6100f2640100000000026401000000009004565b6102bc565b600061100190508073ffffffffffffffffffffffffffffffffffffffff1663c92a78016040518163ffffffff167c010000000000000000000000000000000000000000000000000000000002815260040180806020018060200180602001848103845260068152602001807f706f735f696e0000000000000000000000000000000000000000000000000000815250602001848103835260038152602001807f6c6f630000000000000000000000000000000000000000000000000000000000815250602001848103825260658152602001807f62657274685f69642c696e6465782c696e5f74696d652c696e5f74696d655f7481526020017f7970652c696e5f747970652c706c6174655f69642c7072657061795f6c656e2c81526020017f7072657061795f6d6f6e65792c76656869636c655f747970652c696e5f70696381526020017f5f686173680000000000000000000000000000000000000000000000000000008152506080019350505050602060405180830381600087803b15801561027d57600080fd5b505af1158015610291573d6000803e3d6000fd5b505050506040513d60208110156102a757600080fd5b81019080805190602001909291905050505050565b610129806102cb6000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063b3433d3014604e578063c624d534146076575b600080fd5b348015605957600080fd5b50606060ca565b6040518082815260200191505060405180910390f35b348015608157600080fd5b50608860d3565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60008054905090565b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050905600a165627a7a72305820a3de5a608d50f17c806da8795676c32596c34bca7520debb668e5948312a66980029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[{\"constant\":true,\"inputs\":[],\"name\":\"getIndex\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"oldOwner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnerSet\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"ret\",\"type\":\"int256\"},{\"indexed\":false,\"name\":\"info\",\"type\":\"string\"}],\"name\":\"InsertEvent\",\"type\":\"event\"}]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    public static final String FUNC_GETINDEX = "getIndex";

    public static final String FUNC_GETOWNER = "getOwner";

    public static final Event OWNERSET_EVENT = new Event("OwnerSet", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Address>(true) {}, new TypeReference<Address>(true) {}));
    ;

    public static final Event INSERTEVENT_EVENT = new Event("InsertEvent", 
            Arrays.<TypeReference<?>>asList(new TypeReference<Int256>() {}, new TypeReference<Utf8String>() {}));
    ;

    protected POSIn(String contractAddress, Client client, CryptoKeyPair credential) {
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

    public String getOwner() throws ContractException {
        final Function function = new Function(FUNC_GETOWNER, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Address>() {}));
        return executeCallWithSingleValueReturn(function, String.class);
    }

    public List<OwnerSetEventResponse> getOwnerSetEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(OWNERSET_EVENT, transactionReceipt);
        ArrayList<OwnerSetEventResponse> responses = new ArrayList<OwnerSetEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            OwnerSetEventResponse typedResponse = new OwnerSetEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.oldOwner = (String) eventValues.getIndexedValues().get(0).getValue();
            typedResponse.newOwner = (String) eventValues.getIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void subscribeOwnerSetEvent(String fromBlock, String toBlock, List<String> otherTopics, EventCallback callback) {
        String topic0 = eventEncoder.encode(OWNERSET_EVENT);
        subscribeEvent(ABI,BINARY,topic0,fromBlock,toBlock,otherTopics,callback);
    }

    public void subscribeOwnerSetEvent(EventCallback callback) {
        String topic0 = eventEncoder.encode(OWNERSET_EVENT);
        subscribeEvent(ABI,BINARY,topic0,callback);
    }

    public List<InsertEventEventResponse> getInsertEventEvents(TransactionReceipt transactionReceipt) {
        List<Contract.EventValuesWithLog> valueList = extractEventParametersWithLog(INSERTEVENT_EVENT, transactionReceipt);
        ArrayList<InsertEventEventResponse> responses = new ArrayList<InsertEventEventResponse>(valueList.size());
        for (Contract.EventValuesWithLog eventValues : valueList) {
            InsertEventEventResponse typedResponse = new InsertEventEventResponse();
            typedResponse.log = eventValues.getLog();
            typedResponse.ret = (BigInteger) eventValues.getNonIndexedValues().get(0).getValue();
            typedResponse.info = (String) eventValues.getNonIndexedValues().get(1).getValue();
            responses.add(typedResponse);
        }
        return responses;
    }

    public void subscribeInsertEventEvent(String fromBlock, String toBlock, List<String> otherTopics, EventCallback callback) {
        String topic0 = eventEncoder.encode(INSERTEVENT_EVENT);
        subscribeEvent(ABI,BINARY,topic0,fromBlock,toBlock,otherTopics,callback);
    }

    public void subscribeInsertEventEvent(EventCallback callback) {
        String topic0 = eventEncoder.encode(INSERTEVENT_EVENT);
        subscribeEvent(ABI,BINARY,topic0,callback);
    }

    public static POSIn load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new POSIn(contractAddress, client, credential);
    }

    public static POSIn deploy(Client client, CryptoKeyPair credential) throws ContractException {
        return deploy(POSIn.class, client, credential, getBinary(client.getCryptoSuite()), "");
    }

    public static class OwnerSetEventResponse {
        public TransactionReceipt.Logs log;

        public String oldOwner;

        public String newOwner;
    }

    public static class InsertEventEventResponse {
        public TransactionReceipt.Logs log;

        public BigInteger ret;

        public String info;
    }
}
