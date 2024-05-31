import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_card/cart-model.dart';
import 'package:shopping_card/cart-provider.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:shopping_card/db-helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? db = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 145, 138),
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getDate(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(snapshot
                                          .data![index].image
                                          .toString())),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  db!.delete(snapshot
                                                      .data![index].id!);
                                                  cart.removeCounter();
                                                  cart.removeTotalPrice(
                                                      double.parse(snapshot
                                                          .data![index]
                                                          .productPrice
                                                          .toString()));
                                                },
                                                child: Icon(Icons.delete))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].unitTag
                                                  .toString() +
                                              "  " +
                                              r"$" +
                                              snapshot.data![index].productPrice
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                         int quantity =
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity!;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialPrice!;
                                                          quantity--;
                                                          int newPrice =
                                                              price * quantity;
                                                          if(quantity > 0){
                                                            db!
                                                              .updateQuantity(
                                                                  Cart(
                                                            id: snapshot
                                                                .data![index]
                                                                .id!,
                                                            productId: snapshot
                                                                .data![index]
                                                                .productId
                                                                .toString(),
                                                            productPrice:
                                                                newPrice,
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName!,
                                                            initialPrice: snapshot
                                                                .data![index]
                                                                .initialPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot
                                                                .data![index]
                                                                .unitTag
                                                                .toString(),
                                                            image: snapshot
                                                                .data![index]
                                                                .image
                                                                .toString(),
                                                          ))
                                                              .then(
                                                                  (value) => {
                                                                        newPrice =
                                                                            0,
                                                                        quantity =
                                                                            0,
                                                                        cart.removeTotalPrice(double.parse(snapshot
                                                                            .data![index]
                                                                            .initialPrice
                                                                            .toString()))
                                                                      },
                                                                  onError: ((error,
                                                                      StackTrace) {
                                                            print(error
                                                                .toString());
                                                          }));
                                                          }
                                                        },
                                                        child: const Icon(
                                                            Icons.remove,
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                      snapshot
                                                          .data![index].quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          int quantity =
                                                              snapshot
                                                                  .data![index]
                                                                  .quantity!;
                                                          int price = snapshot
                                                              .data![index]
                                                              .initialPrice!;
                                                          quantity++;
                                                          int newPrice =
                                                              price * quantity;
                                                          db!
                                                              .updateQuantity(
                                                                  Cart(
                                                            id: snapshot
                                                                .data![index]
                                                                .id!,
                                                            productId: snapshot
                                                                .data![index]
                                                                .productId
                                                                .toString(),
                                                            productPrice:
                                                                newPrice,
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName!,
                                                            initialPrice: snapshot
                                                                .data![index]
                                                                .initialPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot
                                                                .data![index]
                                                                .unitTag
                                                                .toString(),
                                                            image: snapshot
                                                                .data![index]
                                                                .image
                                                                .toString(),
                                                          ))
                                                              .then(
                                                                  (value) => {
                                                                        newPrice =
                                                                            0,
                                                                        quantity =
                                                                            0,
                                                                        cart.addTotalPrice(double.parse(snapshot
                                                                            .data![index]
                                                                            .initialPrice
                                                                            .toString()))
                                                                      },
                                                                  onError: ((error,
                                                                      StackTrace) {
                                                            print(error
                                                                .toString());
                                                          }));
                                                        },
                                                        child: const Icon(
                                                            Icons.add,
                                                            color:
                                                                Colors.white))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return Text('data');
            },
          ),
          Consumer<CartProvider>(builder: (context, value, chlid) {
            return Visibility(
              visible: cart.getTotalPrice().toStringAsFixed(2) == '0.00'
                  ? false
                  : true,
              child: Column(
                children: [
                  ReuseableWidget(
                      title: 'Sub Total',
                      value: r'$' + cart.getTotalPrice().toStringAsFixed(2))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  final value, title;
  const ReuseableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(value.toString(), style: Theme.of(context).textTheme.titleSmall)
        ],
      ),
    );
  }
}
