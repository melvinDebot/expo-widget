
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import MyModule from "./modules/my-module/src/MyModule";
import { useEffect, useState } from "react";

export default function App() {
  const [value, setValue] = useState(0);

  useEffect(() => {
    setValue(MyModule.getValue());
  }, []);

  return (
    <View style={styles.container}>
      <Text>Open up App.tsx to start working on your app!</Text>
      <TouchableOpacity onPress={() => setValue(MyModule.saveValue())}>
        <Text>Update</Text>
      </TouchableOpacity>
      <Text>Value: {value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
