import React from 'react';
import {
  Text,
  SafeAreaView,
  StyleSheet,
  TouchableOpacity,
  NativeModules,
} from 'react-native';
import AppInfo from './app.json';

const {ConnectNativeModule} = NativeModules;
const App = (props: any): JSX.Element => {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>App One</Text>
      <Text style={styles.content}>
        Here props from super app: {JSON.stringify(props)}
      </Text>
      <TouchableOpacity
        style={styles.button}
        onPress={() => {
          ConnectNativeModule?.closeApp(AppInfo.name);
        }}>
        <Text style={styles.content}>Close App</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#ffffff',
    flex: 1,
  },
  title: {
    fontSize: 24,
    color: 'red',
    fontWeight: 'bold',
  },
  content: {
    fontSize: 16,
    color: 'blue',
  },
  button: {
    borderRadius: 4,
    backgroundColor: 'green',
    borderWidth: StyleSheet.hairlineWidth,
    padding: 20,
    margin: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default App;
