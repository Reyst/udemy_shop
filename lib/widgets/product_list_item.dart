import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final Function(Product) onDeleteAction;
  final Function(Product) onEditAction;

  const ProductListItem({
    Key key,
    @required this.product,
    this.onDeleteAction,
    this.onEditAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
          title: Text(product.title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => onEditAction?.call(product)),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () => onDeleteAction?.call(product)),
            ],
          ),
        ),
        Divider(
          indent: 4,
          endIndent: 4,
        )
      ],
    );
  }
}
