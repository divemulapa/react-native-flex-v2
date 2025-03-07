# react-native-flex-v2

This library is a React Native bridge for integrating CyberSource's Flex API and Microform functionality into mobile applications. It provides a way to securely capture and tokenize sensitive payment information on both iOS and Android platforms.Key features of the library include:1. Configuration of the CyberSource SDK with organization ID and server URL.2. Ability to make profile requests with custom attributes.3. Generation of capture contexts for initializing Microform fields.4. Support for tokenizing card information using Flex API v2.5. Integration with CyberSource's fingerprinting methods for fraud prevention.The library aims to simplify the implementation of PCI-compliant payment flows in React Native apps by leveraging CyberSource's secure tokenization and microform technologies. It handles the complexities of communicating with CyberSource's backend services and provides a JavaScript interface for React Native developers to work with.

## Installation

```sh
npm install react-native-flex-v2
```

## Usage


```js
import { multiply } from 'react-native-flex-v2';

// ...

const result = await multiply(3, 7);
```


## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
