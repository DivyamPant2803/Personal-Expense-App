import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:personalexpense/widgets/new_transactions.dart';
import 'package:personalexpense/widgets/transaction_list.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main(){
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{

  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransaction = [

  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions{
    return _userTransaction.where((tx){
      return tx.date.isAfter(
          DateTime.now().subtract(
              Duration(days: 7)
          ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return NewTransaction(_addNewTransaction);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(      // builder method
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget
      ){
    return [
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show Chart', style: Theme.of(context).textTheme.title,),
        Switch.adaptive(    // adaptive will change the look of the switch in android and ios
          value: _showChart,
          activeColor: Theme.of(context).accentColor,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },)
      ],
    ),
      _showChart ? Container(
          height: (mediaQuery.size.height -
              appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
          child: Chart(_recentTransactions)
      ) :
      txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget){
    return [Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height - mediaQuery.padding.top) * 0.25,
        child: Chart(_recentTransactions)
    ),txListWidget];
  }

  Widget _buildAppBar(){
    return Platform.isIOS
        ? CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    )
        : AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            _startAddNewTransaction(context);
          },
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandsacape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();

    final txListWidget = Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height - mediaQuery.padding.top) * 0.6,
        child: TransactionList(_userTransaction,_deleteTransaction)
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
      child:Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, //stretches the width of all the child widgets
          children: <Widget>[
            if(isLandsacape)
              ..._buildLandscapeContent(  // Here ... is a spread operator, which is used to convert [1,2[3.4]] to [1,2,3,4]
                  mediaQuery,
                  appBar,
                  txListWidget,
              ),
            if(!isLandsacape)
              ..._buildPortraitContent(
                  mediaQuery,
                  appBar,
                  txListWidget,
              ),
            //if(!isLandsacape) txListWidget,
            /*if(isLandsacape)_showChart ? Container(
                height: (mediaQuery.size.height -
                    appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
                child: Chart(_recentTransactions)
            ) :
            txListWidget,*/
          ],
        ),
      ),
    )
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
    )
        : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}