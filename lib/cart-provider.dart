import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:shopping_card/cart-model.dart';
import 'package:shopping_card/db-helper.dart';

class CartProvider with ChangeNotifier{
  DBHelper db = DBHelper();
  late  Future<List<Cart>>_cart;
 
  int _counter = 0;
  int get counter => _counter;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void _setPrefItem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
   Future<List<Cart>> get cart=> _cart;
  Future<List<Cart>> getDate() async{
    _cart = db.getCartList();
    return _cart;
  }

  void _getPrefItem() async{
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
     _totalPrice = prefs.getDouble('total_price') ?? 0.0;    
    notifyListeners();
  }

  void addCounter (){
   
    _counter ++;
    _setPrefItem();
    notifyListeners();
  }
   void removeCounter (){
    _counter --;
    _setPrefItem();
    notifyListeners();
  }

   int getCounter (){
 
    _getPrefItem();
    return _counter;
  }
 // for total price 

   void addTotalPrice (double productPrice){
    
     _totalPrice = _totalPrice +productPrice;
    _setPrefItem();
    notifyListeners();
  }
   void removeTotalPrice ( double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItem();
    notifyListeners();
  }

   double getTotalPrice (){

    _getPrefItem();
    return _totalPrice;
  }
 

}