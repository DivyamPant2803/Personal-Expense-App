import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.delelteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function delelteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text('\u20B9${transaction.amount}'
                )
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
          textColor: Theme.of(context).errorColor,
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),    // yaha const ka matlab hai, ki agar dobara build() chalega toh Text widget phir se nhi bnega, kyunki iski value hamesha ek jaisi hi hai
          onPressed: () => delelteTx(transaction.id),
        )
            : IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => delelteTx(transaction.id),
        ),
      ),
    );
  }
}