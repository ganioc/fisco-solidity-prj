package org.com.fisco;

import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSOut extends Contract {
    public static final String[] BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820058f9b02dd68f3cac14eddf2a6ecaf37eabb9fa58227acd9074fd23bd74114180029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820e594b34f940e3b31335767fd98706643dcc7fc5d49a36f96f227fa334850f8150029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    protected POSOut(String contractAddress, Client client, CryptoKeyPair credential) {
        super(getBinary(client.getCryptoSuite()), contractAddress, client, credential);
    }

    public static String getBinary(CryptoSuite cryptoSuite) {
        return (cryptoSuite.getCryptoTypeConfig() == CryptoType.ECDSA_TYPE ? BINARY : SM_BINARY);
    }

    public static POSOut load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new POSOut(contractAddress, client, credential);
    }

    public static POSOut deploy(Client client, CryptoKeyPair credential) throws ContractException {
        return deploy(POSOut.class, client, credential, getBinary(client.getCryptoSuite()), "");
    }
}
