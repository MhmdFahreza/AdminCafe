import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    String id = idController.text;
    String password = passwordController.text;

    if (id == '1234' && password == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid ID or Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Kopi Kreasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Id Karyawan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    OrderNotesPage(),
    FinancialPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Catatan Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Keuangan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
}

class OrderNotesPage extends StatefulWidget {
  @override
  _OrderNotesPageState createState() => _OrderNotesPageState();
}

class _OrderNotesPageState extends State<OrderNotesPage> {
  List<Order> orders = [
    Order(name: 'Agus', order: 'Espresso', total: 'Rp.75.000', status: 'Online'),
    Order(name: 'Agus', order: 'Americano', total: 'Rp.75.000', status: 'Offline'),
  ];

  void _addOrder() {
    TextEditingController nameController = TextEditingController();
    TextEditingController orderController = TextEditingController();
    TextEditingController totalController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: orderController,
                decoration: InputDecoration(labelText: 'Pesanan'),
              ),
              TextField(
                controller: totalController,
                decoration: InputDecoration(labelText: 'Total'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  orders.add(Order(
                    name: nameController.text,
                    order: orderController.text,
                    total: totalController.text,
                    status: 'Offline',
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _completeOrder(int index) {
    setState(() {
      final completedOrder = orders.removeAt(index);
      FinancialPageState.addIncome(completedOrder.total);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan Pesanan'),
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onComplete: () => _completeOrder(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrder,
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Order {
  final String name;
  final String order;
  final String total;
  final String status;

  Order({required this.name, required this.order, required this.total, required this.status});
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onComplete;

  OrderCard({required this.order, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama : ${order.name}'),
                Text('Pesanan : ${order.order}'),
                Text('Total : ${order.total}'),
              ],
            ),
            Column(
              children: [
                Text(
                  order.status,
                  style: TextStyle(color: order.status == 'Online' ? Colors.green : Colors.red),
                ),
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: onComplete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialPage extends StatefulWidget {
  @override
  FinancialPageState createState() => FinancialPageState();
}

class FinancialPageState extends State<FinancialPage> {
  static double totalIncome = 0;

  static void addIncome(String total) {
    double income = double.tryParse(total.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
    totalIncome += income;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keuangan'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: FinancialSummary(),
      ),
    );
  }
}

class FinancialSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Hari ini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pemasukan'),
                  Text(
                    FinancialPageState.totalIncome.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              VerticalDivider(
                color: Colors.black,
                thickness: 1,
                width: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Pengeluaran'),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
