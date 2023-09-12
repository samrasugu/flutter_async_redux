import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';

late Store<int> store;

void main() {
  store = Store<int>(initialState: 0);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => StoreProvider<int>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Async Redux',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePageConnector(),
        ),
      );
}

// action to increment count by [amount]
class IncrementAction extends ReduxAction<int> {
  final int amount;

  IncrementAction({required this.amount});

  @override
  int reduce() => state + amount;
}

// connector widget -> connects the store to the dumb widget(MyHomePage)
class MyHomePageConnector extends StatelessWidget {
  const MyHomePageConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<int, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => MyHomePage(
        counter: vm.counter,
        onIncrement: vm.onIncrement,
      ),
    );
  }
}

// factory that creates a view model for the store connector
class Factory extends VmFactory<int, MyHomePageConnector, ViewModel> {
  Factory(connector) : super(connector);

  @override
  ViewModel fromStore() => ViewModel(
      counter: state, onIncrement: () => dispatch(IncrementAction(amount: 1)));
}

// view model -> helper to store connector:: holds part of store state that the dumb widget needs
class ViewModel extends Vm {
  final int counter;
  final VoidCallback onIncrement;

  ViewModel({
    required this.counter,
    required this.onIncrement,
  }) : super(equals: [counter]);
}

// the dumb widget -> UI
class MyHomePage extends StatelessWidget {
  final int? counter;
  final VoidCallback? onIncrement;
  const MyHomePage({
    super.key,
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Async Redux Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times'),
            Text(
              '$counter',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onIncrement,
        child: const Icon(Icons.add),
      ),
    );
  }
}
