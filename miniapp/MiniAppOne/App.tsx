import React from 'react';
import {
  Text,
  SafeAreaView,
  StyleSheet,
  TouchableOpacity,
  NativeModules,
  ScrollView,
  View,
} from 'react-native';
import MapView, {Callout, Marker, PROVIDER_GOOGLE} from 'react-native-maps';
import AppInfo from './app.json';

const {ConnectNativeModule} = NativeModules;
const App = (props: any): JSX.Element => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View>
          <MapView
            provider={PROVIDER_GOOGLE}
            zoomControlEnabled={true}
            zoomEnabled={true}
            style={styles.mapContainer}
            region={{
              latitude: 16.069560532577032,
              longitude: 108.23408695899637,
              latitudeDelta: 0.015,
              longitudeDelta: 0.0121,
            }}>
            <Marker
              coordinate={{
                latitude: 16.069560532577032,
                longitude: 108.23408695899637,
              }}>
              <Callout>
                <Text>Address</Text>
              </Callout>
            </Marker>
          </MapView>
        </View>
        <Text style={styles.title}>App One</Text>
        <Text style={styles.content}>
          Here props from super app: {JSON.stringify(props)}
        </Text>
      </ScrollView>
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
  mapContainer: {
    height: 500,
  },
});

export default App;
