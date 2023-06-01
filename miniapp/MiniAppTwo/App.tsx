import React from 'react';
import {Text, SafeAreaView, StyleSheet} from 'react-native';

const App = (props: any): JSX.Element => {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>App Two</Text>
      <Text style={styles.content}>
        Here props from super app: {JSON.stringify(props)}
      </Text>
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
});

export default App;
