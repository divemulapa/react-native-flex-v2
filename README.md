# react-native-flex-v2

This library is a React Native bridge for integrating CyberSource's Flex API and Microform functionality into mobile applications. It provides a way to securely capture and tokenize sensitive payment information on both iOS and Android platforms. Key features of the library include:
1. Support for tokenizing card information using Flex API v2.

The library aims to simplify the implementation of PCI-compliant payment flows in React Native apps by leveraging CyberSource's secure tokenization and microform technologies. It handles the complexities of communicating with CyberSource's backend services and provides a JavaScript interface for React Native developers to work with.

## Installation

```sh
npm install react-native-flex-v2
```

## Usage


```js
import { FlexV2Module } from 'react-native-flex-v2';
import { Platform } from 'react-native';

// Determine the current platform
const isAndroid = Platform.OS === 'android';

// Define your request payload according to CyberSource's Flex API requirements
const requestPayload = {
  // ... your payload configuration here
};

new Promise((resolve, reject) => {
  FlexV2Module.createToken(requestPayload, (error: Error | null, tokenResponse: string) => {
    if (error) {
      console.error("Token creation failed:", error);
      reject(error);
    } else {
      // For iOS, the token is wrapped in a JSON string, while Android returns it directly
      const flexToken = isAndroid ? tokenResponse : JSON.parse(tokenResponse).token;
      resolve({ token: flexToken });
    }
  });
})
  .then(result => {
    console.log("Token created successfully:", result.token);
    // Continue with your token handling logic...
  })
  .catch(error => {
    console.error("Error during token creation:", error);
    // Handle error accordingly...
  });
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
