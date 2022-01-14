import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../screens/product_details_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
                  arguments: product.id);
            },
            splashColor: Colors.black45,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            leading: Consumer<Product>(
              builder: (context, product, child) {
                return IconButton(
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                );
              },
            ),
            title: Text(product.title),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ),
      ),
    );
  }
}
