import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
class Expenses extends StatefulWidget{
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpansesState();
  }
}

class _ExpansesState extends State<Expenses>{
  final List<Expense> _registeredExpenses=[
     Expense(
         title: 'Flutter Course',
         amount: 19.99,
         date: DateTime.now(),
         category:Category.work
     ),
    Expense(
        title: 'Cinema',
        amount: 19.99,
        date: DateTime.now(),
        category:Category.leisure
    ),
  ];

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
        useSafeArea: true,   //prevents collapse with camera
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense,),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Expense deleted'),                     //displaying info message
          action: SnackBarAction(                                     //with additional undo option
            label: 'Undo',
            onPressed: (){
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
          ),
        ),);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text(
          'No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty){
      mainContent= ExpensesList(
        expenses:_registeredExpenses,
        onRemoveExpense: _removeExpense
        ,);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add))
        ],
      ),

      body: width < 600 ? Column(    //if width is less then 600
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent
            ,)
        ],                                //width < 600 ? Column(): Row()
      ): Row(children: [
        Expanded(                       //Expanded constraints the child(i.e. Chart) to only take as much width as available in the Row after sizing the other Row children.
            child: Chart(expenses: _registeredExpenses)),
        Expanded(
          child: mainContent
          ,)
      ],),
    );
  }
}