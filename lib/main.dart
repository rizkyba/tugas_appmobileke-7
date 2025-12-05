import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

/* ============================================
   ===============  WARNA APLIKASI  ===========
   ============================================ */
class AppColors {
  static const Color primary = Color(0xFF4B7355);   // Hijau olive elegan
  static const Color secondary = Color(0xFFF0F1EC); // Abu kehijauan soft
  static const Color background = Color(0xFFFFFFFF); // Putih
}

/* ============================================
   ===============  PROVIDER LOGIN  ============
   ============================================ */
class UserProvider with ChangeNotifier {
  String? username;
  String? password;

  void login(String name, String pass) {
    username = name;
    password = pass;
    notifyListeners();
  }

  void logout() {
    username = null;
    password = null;
    notifyListeners();
  }
}

/* ============================================
   ===============  PROVIDER CART  =============
   ============================================ */

class CartProvider with ChangeNotifier {
  // Barang + harga
  Map<String, int> cart = {};
  Map<String, int> price = {
    "Baju": 50000,
    "Celana": 70000,
    "Topi": 30000,
    "Jaket": 120000,
    "Sepatu": 150000
  };

  void addItem(String item) {
    cart[item] = (cart[item] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String item) {
    if (!cart.containsKey(item)) return;

    if (cart[item] == 1) {
      cart.remove(item);
    } else {
      cart[item] = cart[item]! - 1;
    }
    notifyListeners();
  }

  void deleteItem(String item) {
    cart.remove(item);
    notifyListeners();
  }

  int totalItems() {
    int total = 0;
    cart.forEach((key, value) => total += value);
    return total;
  }

  int totalHarga() {
    int total = 0;
    cart.forEach((item, qty) {
      total += price[item]! * qty;
    });
    return total;
  }
}

/* ============================================
   ===================== APP ===================
   ============================================ */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tugas APP 7',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            labelStyle: const TextStyle(color: Colors.grey),
          ),
          cardTheme: CardThemeData(
            color: AppColors.background,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
        ),
        home: MenuPage(),
      ),
    );
  }
}

/* ============================================
   ================== MENU PAGE ================
   ============================================ */
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Utama"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih fitur",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            MenuButton(
              icon: Icons.calculate_outlined,
              label: "Hitung",
              subtitle: "Operasi matematika sederhana",
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HitungPage()),
              ),
            ),
            MenuButton(
              icon: Icons.person_outline,
              label: "Login",
              subtitle: "Simulasi login dengan Provider",
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              ),
            ),
            MenuButton(
              icon: Icons.shopping_bag_outlined,
              label: "Keranjang",
              subtitle: "Tambah barang dan hitung total",
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const MenuButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/* ============================================
   ===============  HITUNG PAGE  ===============
   ============================================ */

class HitungPage extends StatefulWidget {
  @override
  State<HitungPage> createState() => _HitungPageState();
}

class _HitungPageState extends State<HitungPage> {
  final a = TextEditingController();
  final b = TextEditingController();
  double result = 0;

  void hitung(String type) {
    final num1 = double.tryParse(a.text) ?? 0;
    final num2 = double.tryParse(b.text) ?? 0;

    setState(() {
      switch (type) {
        case 'tambah':
          result = num1 + num2;
          break;
        case 'kurang':
          result = num1 - num2;
          break;
        case 'kali':
          result = num1 * num2;
          break;
        case 'bagi':
          result = num2 != 0 ? num1 / num2 : 0;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hitung (setState)"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Masukkan angka",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: a,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Angka pertama"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: b,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Angka kedua"),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconCalcButton(
                      icon: Icons.add,
                      label: "Tambah",
                      onTap: () => hitung('tambah'),
                    ),
                    IconCalcButton(
                      icon: Icons.remove,
                      label: "Kurang",
                      onTap: () => hitung('kurang'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconCalcButton(
                      icon: Icons.clear,
                      label: "Kali",
                      onTap: () => hitung('kali'),
                    ),
                    IconCalcButton(
                      icon: Icons.horizontal_rule,
                      label: "Bagi",
                      onTap: () => hitung('bagi'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hasil",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        result.toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconCalcButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconCalcButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

/* ============================================
   ================== LOGIN PAGE ===============
   ============================================ */

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login (Provider)"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Masuk ke akun",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Masukkan nama",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      user.login(
                          usernameController.text, passwordController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomeLoginPage()),
                      );
                    },
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================
   ============== HOME LOGIN PAGE ==============
   ============================================ */

class HomeLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined,
                    size: 72, color: AppColors.primary),
                const SizedBox(height: 16),
                const Text(
                  "Selamat datang,",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  user.username ?? "",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Password: ${user.password}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      user.logout();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================
   ================ CART PAGE ==================
   ============================================ */

class CartPage extends StatelessWidget {
  final List<String> items = ["Baju", "Celana", "Topi", "Jaket", "Sepatu"];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartDetailPage()),
                ),
              ),
              Positioned(
                right: 8,
                top: 10,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.red,
                  child: Text(
                    cart.totalItems().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final jumlah = cart.cart[item] ?? 0;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    "Harga: Rp ${cart.price[item]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (jumlah > 0)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => cart.removeItem(item),
                            ),
                          Text(jumlah.toString(),
                              style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cart.addItem(item),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => cart.addItem(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          "Tambah ke Cart",
                          style: TextStyle(color: Colors.white),
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
}

/* ============================================
   ============ CART DETAIL PAGE ===============
   ============================================ */

class CartDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Keranjang"),
      ),
      body: cart.cart.isEmpty
          ? const Center(child: Text("Keranjang masih kosong"))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: cart.cart.keys.map((item) {
                      final jumlah = cart.cart[item]!;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.shopping_cart_outlined),
                            title: Text(
                              item,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "Harga: Rp ${cart.price[item]}  •  Subtotal: Rp ${cart.price[item]! * jumlah}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.removeItem(item),
                                ),
                                Text(jumlah.toString(),
                                    style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.addItem(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => cart.deleteItem(item),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Rp ${cart.totalHarga()}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
