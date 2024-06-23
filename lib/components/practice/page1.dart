import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<InventoryItem> cartItems = [];

  void addToCart(InventoryItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void removeFromCart(InventoryItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  int get totalCartItems => cartItems.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        actions: [
          if (totalCartItems > 0)
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                // Implement cart page navigation
              },
            ),
          if (totalCartItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '$totalCartItems',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: inventoryItems.length,
        itemBuilder: (context, index) {
          return InventoryCard(
            item: inventoryItems[index],
            addToCart: addToCart,
            removeFromCart: removeFromCart,
            isInCart: cartItems.contains(inventoryItems[index]),
          );
        },
      ),
      bottomNavigationBar: totalCartItems > 0
          ? AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 100,
        color: Colors.grey[200],
        child: Center(
          child: Text('Cart Model'),
        ),
      )
          : null,
    );
  }
}

class InventoryItem {
  final String name;
  final String imageUrl;
  final double price;
  final int stock;
  final double discount;

  InventoryItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.stock,
    this.discount = 0.0,
  });
}

final List<InventoryItem> inventoryItems = [
  InventoryItem(
    name: 'Item 1',
    imageUrl: 'https://via.placeholder.com/150',
    price: 50.0,
    stock: 10,
    discount: 10.0,
  ),
  InventoryItem(
    name: 'Item 2',
    imageUrl: 'https://via.placeholder.com/150',
    price: 75.0,
    stock: 5,
  ),
];

class InventoryCard extends StatefulWidget {
  final InventoryItem item;
  final Function(InventoryItem) addToCart;
  final Function(InventoryItem) removeFromCart;
  final bool isInCart;

  const InventoryCard({
    Key? key,
    required this.item,
    required this.addToCart,
    required this.removeFromCart,
    required this.isInCart,
  }) : super(key: key);

  @override
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        widget.item.price - (widget.item.price * (widget.item.discount / 100));

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            widget.item.imageUrl,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.item.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'In Stock: ${widget.item.stock}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (widget.item.discount > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Discount: ${widget.item.discount}% OFF',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          if (widget.item.discount > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Original Price: \$${widget.item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.isInCart
                ? ElevatedButton(
              onPressed: () {
                setState(() {
                  quantity--;
                  widget.removeFromCart(widget.item);
                });
              },
              child: Text('Remove From Cart'),
            )
                : ElevatedButton(
              onPressed: () {
                setState(() {
                  quantity++;
                  widget.addToCart(widget.item);
                });
              },
              child: Text('Add To Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
