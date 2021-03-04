package org.com.fisco;

import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSPay extends Contract {
    public static final String[] BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a723058208087471203ba8213f341f65ed3ec9970d09d49beb6744fc457f82b5fc61ed5e00029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820e1913962ef135edb2afd5fd03b61842c289ab1b21bfc2514de6f12ee00f9a92b0029"};

    public static final String SM_BINARY = String.join("", SM_BINARY_ARRAY);

    public static final String[] ABI_ARRAY = {"[]"};

    public static final String ABI = String.join("", ABI_ARRAY);

    protected POSPay(String contractAddress, Client client, CryptoKeyPair credential) {
        super(getBinary(client.getCryptoSuite()), contractAddress, client, credential);
    }

    public static String getBinary(CryptoSuite cryptoSuite) {
        return (cryptoSuite.getCryptoTypeConfig() == CryptoType.ECDSA_TYPE ? BINARY : SM_BINARY);
    }

    public static POSPay load(String contractAddress, Client client, CryptoKeyPair credential) {
        return new POSPay(contractAddress, client, credential);
    }

    public static POSPay deploy(Client client, CryptoKeyPair credential) throws ContractException {
        return deploy(POSPay.class, client, credential, getBinary(client.getCryptoSuite()), "");
    }
}
