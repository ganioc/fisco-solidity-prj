package org.com.fisco;

import org.fisco.bcos.sdk.client.Client;
import org.fisco.bcos.sdk.contract.Contract;
import org.fisco.bcos.sdk.crypto.CryptoSuite;
import org.fisco.bcos.sdk.crypto.keypair.CryptoKeyPair;
import org.fisco.bcos.sdk.model.CryptoType;
import org.fisco.bcos.sdk.transaction.model.exception.ContractException;

@SuppressWarnings("unchecked")
public class POSOut extends Contract {
    public static final String[] BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a72305820b018f94a67b106643b4203c91af3b1050a0b7ad46b81a54dcb58af196ae40f670029"};

    public static final String BINARY = String.join("", BINARY_ARRAY);

    public static final String[] SM_BINARY_ARRAY = {"6080604052348015600f57600080fd5b50603580601d6000396000f3006080604052600080fd00a165627a7a7230582000d0d8907ac3a905bfbb0f1f524de3d8a39078190a5cef1d9ad3d69a512eba1d0029"};

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
