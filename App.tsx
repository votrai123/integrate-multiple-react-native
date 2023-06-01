/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useCallback, useState} from 'react';
import {
  Keyboard,
  KeyboardAvoidingView,
  NativeModules,
  Platform,
  SafeAreaView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  TouchableWithoutFeedback,
  View,
} from 'react-native';

const {ConnectNativeModule} = NativeModules;

interface App {
  bundleId: string;
  appName: string;
}

function App(): JSX.Element {
  const [input, setInput] = useState<string>('');
  const LIST_APPS: Array<App> = [
    {
      bundleId: `index.${Platform.OS}-1.bundle`,
      appName: 'MiniAppOne',
    },
    {
      appName: 'MiniAppTwo',
      bundleId: `index.${Platform.OS}-2.bundle`,
    },
  ];

  const goToNextApp = useCallback(
    async (item: App) => {
      ConnectNativeModule?.openApp(
        item.appName,
        item.bundleId,
        {
          text: input,
        },
        false,
        () => {},
      );

      const result = await ConnectNativeModule?.getBundleNames();
      return result;
    },
    [input],
  );

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      style={styles.container}
      keyboardVerticalOffset={64}>
      <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
        <SafeAreaView style={styles.container}>
          <Text style={styles.title}>Input send to miniapp</Text>
          <TextInput
            value={input}
            placeholder="please input here"
            onChangeText={text => setInput(text)}
            style={styles.input}
          />
          <View style={styles.content}>
            {LIST_APPS.map(app => (
              <TouchableOpacity
                key={app?.bundleId}
                style={styles.btnApp}
                onPress={() => goToNextApp(app)}>
                <Text style={styles.appName}>{app?.appName}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </SafeAreaView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
  },
  appName: {
    fontWeight: 'bold',
    fontSize: 24,
    color: '#fff',
  },
  btnApp: {
    borderWidth: 1,
    backgroundColor: '#999',
    padding: 16,
    borderRadius: 60,
  },
  input: {
    borderRadius: 4,
    borderWidth: StyleSheet.hairlineWidth,
    marginHorizontal: 16,
    marginVertical: 10,
  },
  title: {
    fontWeight: 'bold',
    fontSize: 20,
    padding: 20,
  },
});

export default App;
