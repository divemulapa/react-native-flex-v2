package com.flexv2;

import com.facebook.react.bridge.*;
import com.cybersource.flex.android.CaptureContext;
import com.cybersource.flex.android.FlexService;
import com.cybersource.flex.android.TransientToken;
import org.json.JSONObject;

public class FlexV2ReactNativeModule extends ReactContextBaseJavaModule {

  public FlexV2ReactNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "ReactNativeFlexV2";
  }

  @ReactMethod
  public void createToken(ReadableMap options, Promise promise) {
    FlexService flexService = FlexService.getInstance();

    ReadableMap cardInfo = options.hasKey("cardInfo") ? options.getMap("cardInfo") : null;
    if (cardInfo == null) {
      promise.reject("INVALID_OPTIONS", "Card info is missing");
      return;
    }

    String cardNumber = cardInfo.hasKey("cardNumber") ? cardInfo.getString("cardNumber") : "";
    String cardType = cardInfo.hasKey("cardType") ? cardInfo.getString("cardType") : "";
    String cardExpirationMonth = cardInfo.hasKey("cardExpirationMonth") ? cardInfo.getString("cardExpirationMonth") : "";
    String cardExpirationYear = cardInfo.hasKey("cardExpirationYear") ? cardInfo.getString("cardExpirationYear") : "";
    String cardCVV = cardInfo.hasKey("cardCVV") ? cardInfo.getString("cardCVV") : "";
    String nameOnCard = cardInfo.hasKey("nameOnCard") ? cardInfo.getString("nameOnCard") : "";

    String kid = options.hasKey("kid") ? options.getString("kid") : "";
    ReadableMap keystore = options.hasKey("keystore") ? options.getMap("keystore") : null;
    if (keystore == null) {
      promise.reject("INVALID_OPTIONS", "Keystore is missing");
      return;
    }
    String encryptionType = options.hasKey("encryptionType") ? options.getString("encryptionType") : "rsaoaep256";

    TokenizeOptions tokenizeOptions = new TokenizeOptions();
    tokenizeOptions.setCardNumber(cardNumber);
    tokenizeOptions.setCardType(cardType);
    tokenizeOptions.setCardExpirationMonth(cardExpirationMonth);
    tokenizeOptions.setCardExpirationYear(cardExpirationYear);
    tokenizeOptions.setCardCVV(cardCVV);
    tokenizeOptions.setNameOnCard(nameOnCard);
    tokenizeOptions.setKid(kid);
    tokenizeOptions.setKeystore(convertMapToKeystore(keystore));
    tokenizeOptions.setEncryptionType(encryptionType);

    flexService.createTokenAsyncTask(
      tokenizeOptions,
      new TransientToken.CreateTokenCallback() {
        @Override
        public void onSuccess(TransientToken transientToken) {
          WritableMap resultMap = Arguments.createMap();
          resultMap.putString("token", transientToken.getToken());
          promise.resolve(resultMap);
        }

        @Override
        public void onFailure(Exception error) {
          promise.reject("CREATE_TOKEN_ERROR", error.getMessage(), error);
        }
      }
    );
  }

  private Keystore convertMapToKeystore(ReadableMap keystoreMap) {
    Keystore keystore = new Keystore();
    // Implement the conversion logic here based on your Keystore class structure
    // This is a placeholder implementation
    // For example:
    // keystore.setSomeProperty(keystoreMap.getString("someProperty"));
    return keystore;
  }

  @ReactMethod
  public void getDeviceFingerprint(String organizationId, String sessionId, Promise promise) {
    FlexService flexService = FlexService.getInstance();

    try {
      String fingerprint = flexService.getDeviceFingerprint(organizationId, sessionId);
      promise.resolve(fingerprint);
    } catch (Exception e) {
      promise.reject("FINGERPRINT_ERROR", e.getMessage(), e);
    }
  }
}
