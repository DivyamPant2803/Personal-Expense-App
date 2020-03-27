import 'package:flutter/material.dart';
import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget{

  final List<Transaction> transaction;
  final Function delelteTx;

  TransactionList(this.transaction, this.delelteTx);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          child: transaction.isEmpty
              ? LayoutBuilder(builder: (ctx,constraints){
                return Column(       // Ternary operator
                  children: <Widget>[
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    const SizedBox(
                      height: 20,   // 20px space between Text and Container
                    ),
                    Container(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,  // BoxFit takes the height of Image's direct parent, ie 200px
                        )
                    ),
                  ],
                );
          },) :
        ListView.builder(  // Column + SingleChildScrollView
            itemBuilder: (ctx, index){
              return TransactionItem(transaction: transaction[index], delelteTx: delelteTx);
            },
            itemCount: transaction.length,
        ),
    );
  }
}

