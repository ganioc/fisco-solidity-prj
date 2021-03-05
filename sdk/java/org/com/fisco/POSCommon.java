package org.com.fisco;

import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSCommon extends Contract {
    public static final String[] BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820e9e242e7b5eae1ae78f2a8b2bcd1c26740d41b5dd805bd672b3998cece1253a60029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820553a1d27b3b98696d0e7c5e861d70350c6dba80ce39758fd472d3c2fb4f7aa240029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    protected POSCommon(String contractAddress, Client client, CryptoKeyPair credential) {
        super(getBinary(client.getCryptoSuite()), contractAddress, client, credential);
    }

    public static String getBinary(CryptoSuite cryptoSuite) {
        return (cryptoSuite.getCryptoTypeConfig() == CryptoType.ECDSA_TYPE ? BINARY : SM_BINARY);
    }

    public static POSCommon load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new POSCommon(contractAddress, client, credential);
    }

    public static POSCommon deploy(Client client, CryptoKeyPair credential) throws ContractException {
        return deploy(POSCommon.class, client, credential, getBinary(client.getCryptoSuite()), "");
    }
}
