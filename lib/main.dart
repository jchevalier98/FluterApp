import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/expenses_bloc.dart';
import 'features/expense_list/data/model/expenses_repository.dart';
import 'features/expense_list/presentation/pages/add_page.dart';
import 'features/expense_list/presentation/pages/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white
      ),
      home: BlocProvider(
        create: (context) => ExpensesBloc(repository: FirebaseExpensesRepository()),
        child: Home(),
      ),
      routes: {
        '/add' : (BuildContext context) => AddPage(),
      }
    );
  }
}
