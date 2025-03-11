package com.flexv2;

import androidx.annotation.NonNull;
import com.cybersource.flex.android.CaptureContext;
import com.cybersource.flex.android.FlexException;
import com.cybersource.flex.android.FlexService;
import com.cybersource.flex.android.TransientToken;
import com.cybersource.flex.android.TransientTokenCreationCallback;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.Map;

public class FlexV2Module extends ReactContextBaseJavaModule {
  private final ReactApplicationContext reactContext;

  public FlexV2Module(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @NonNull
  @Override
  public String getName() {
    return "FlexV2Module";
  }

  @ReactMethod
  public void createToken(ReadableMap options, Callback callBack) {
    try {
      FlexService flexService = FlexService.getInstance();

      // Extract jwt and cardInfo from options
      String serverJWT = options.getString("jwt");
      ReadableMap cardInfo = options.getMap("cardInfo");

      // Build payload with nested structure
      Map<String, Object> payload = this.getPayloadData(cardInfo);

      // Get capture context from the jwt(MBS service)
      CaptureContext cc = CaptureContext.fromJwt(serverJWT);

      flexService.createTokenAsyncTask(cc, payload, new TransientTokenCreationCallback() {
        @Override
        public void onSuccess(TransientToken tokenResponse) {
          String token = tokenResponse.getEncoded();
          callBack.invoke(null, token);
        }

        @Override
        public void onFailure(FlexException error) {
          callBack.invoke("TOKENIZATION_FAILED", error.getMessage());
        }
      });

    } catch (Exception e) {
      callBack.invoke("TOKENIZATION_FAILED", e.getMessage());
    }
  }

  private Map<String, Object> getPayloadData(ReadableMap cardInfo) {
    // Extract card details from cardInfo map
    String cardNumber = cardInfo.getString("number");
    String expiryMonth = cardInfo.getString("expiryMonth");
    String expiryYear = cardInfo.getString("expiryYear");
    String cvv = cardInfo.getString("cvv");

    // Build payload with nested structure
    Map<String, Object> payload = new HashMap<>();
    payload.put("number", cardNumber);
    payload.put("securityCode", cvv);
    payload.put("expirationMonth", expiryMonth);
    payload.put("expirationYear", expiryYear);

    return payload;
  }

}
