import 'package:flutter/material.dart';

void main() => runApp(const BankApp());

// ─── THEME ────────────────────────────────────────────────────────────────────
const kPrimary = Color(0xFF4A90D9);
const kLight = Color(0xFFE8F1FB);
const kBg = Color(0xFFF5F7FA);
const kBorder = Color(0xFFCDD5E0);
const kText = Color(0xFF2C3E50);
const kGray = Color(0xFF8A9BB0);

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBg,
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kText,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: kText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: kBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: kBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: kPrimary, width: 1.5),
          ),
          hintStyle: const TextStyle(color: kGray, fontSize: 13),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ─── HELPERS ──────────────────────────────────────────────────────────────────

Widget _banner(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: kLight,
      border: Border.all(color: kBorder),
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: Alignment.center,
    child: Text(
      title,
      style: const TextStyle(
          color: kText, fontWeight: FontWeight.w700, fontSize: 15),
    ),
  );
}

Widget _blueBtn(String label, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _outlineBtn(String label, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimary,
        side: const BorderSide(color: kPrimary),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _field(String hint,
    {bool obscure = false, TextEditingController? ctrl}) {
  return TextField(
    controller: ctrl,
    obscureText: obscure,
    decoration: InputDecoration(hintText: hint),
  );
}

// ─── SCREEN: LOGIN ────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  final bool isRetry;
  final int failCount;
  const LoginScreen({super.key, this.isRetry = false, this.failCount = 0});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  // Demo credentials
  static const _validUser = 'user';
  static const _validPass = 'pass';

  void _login() {
    final correct =
        _user.text == _validUser && _pass.text == _validPass;

    if (correct) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AccountsScreen()),
            (_) => false,
      );
    } else {
      final newFail = widget.failCount + 1;
      if (newFail >= 3) {
        // Locked – go to password reset
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PasswordResetScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LoginScreen(isRetry: true, failCount: newFail),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text('Logo',
                    style: TextStyle(color: kGray, fontSize: 18)),
              ),
              const SizedBox(height: 32),
              if (widget.isRetry)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    'Incorrect credentials. Attempt ${widget.failCount}/3',
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              _field('Username', ctrl: _user),
              const SizedBox(height: 12),
              _field('Password', obscure: true, ctrl: _pass),
              const SizedBox(height: 20),
              _blueBtn('Go', _login),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PasswordResetScreen()),
                ),
                child: const Text('Forgot password?',
                    style: TextStyle(color: kPrimary, fontSize: 13)),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegistrationScreen()),
                ),
                child: const Text('Register',
                    style: TextStyle(color: kGray, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SCREEN: ACCOUNTS ─────────────────────────────────────────────────────────
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Accounts'),
            const SizedBox(height: 20),
            _AccountTile(
              label: 'Checking Account',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AccountDetailScreen(
                        title: 'Checking Account')),
              ),
            ),
            const SizedBox(height: 10),
            _AccountTile(
              label: 'Savings Account',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AccountDetailScreen(
                        title: 'Savings Account')),
              ),
            ),
            const SizedBox(height: 10),
            _AccountTile(
              label: 'Credit Card Balance',
              highlighted: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreditCardScreen()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final String label;
  final bool highlighted;
  final VoidCallback onTap;
  const _AccountTile(
      {required this.label,
        this.highlighted = false,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: highlighted ? kPrimary : Colors.white,
          border: Border.all(color: highlighted ? kPrimary : kBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: highlighted ? Colors.white : kText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ─── SCREEN: ACCOUNT DETAIL ───────────────────────────────────────────────────
class AccountDetailScreen extends StatelessWidget {
  final String title;
  const AccountDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner(title),
            const SizedBox(height: 16),
            // Placeholder rows
            ...List.generate(
                4,
                    (i) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 18,
                  decoration: BoxDecoration(
                    color: kBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─── SCREEN: CREDIT CARD BALANCE ─────────────────────────────────────────────
class CreditCardScreen extends StatelessWidget {
  const CreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credit Card Balance')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Credit Card Balance'),
            const SizedBox(height: 16),
            ...List.generate(
                5,
                    (i) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 16,
                  decoration: BoxDecoration(
                    color: kBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 80,
                child: _blueBtn('Go', () => Navigator.pop(context)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─── SCREEN: PASSWORD RESET ───────────────────────────────────────────────────
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _email = TextEditingController();

  void _send() {
    // Demo: if email matches "user@bank.com" → success
    final matches = _email.text.trim() == 'user@bank.com';
    if (matches) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResetEmailSentScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReEnterEmailScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Password Reset'),
            const SizedBox(height: 16),
            ...List.generate(
                2,
                    (i) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 16,
                  decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(4)),
                )),
            const SizedBox(height: 12),
            _field('Email', ctrl: _email),
            const SizedBox(height: 16),
            _blueBtn('Send temporary password', _send),
          ],
        ),
      ),
    );
  }
}

// ─── SCREEN: RE-ENTER EMAIL ───────────────────────────────────────────────────
class ReEnterEmailScreen extends StatefulWidget {
  const ReEnterEmailScreen({super.key});

  @override
  State<ReEnterEmailScreen> createState() => _ReEnterEmailScreenState();
}

class _ReEnterEmailScreenState extends State<ReEnterEmailScreen> {
  final _email = TextEditingController();

  void _send() {
    final matches = _email.text.trim() == 'user@bank.com';
    if (matches) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResetEmailSentScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistrationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Re-enter Email')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Password Reset'),
            const SizedBox(height: 16),
            const Text(
              'Email not found. Please re-enter your email address.',
              style: TextStyle(color: Colors.red, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _field('Email', ctrl: _email),
            const SizedBox(height: 16),
            _blueBtn('Send temporary password', _send),
          ],
        ),
      ),
    );
  }
}

// ─── SCREEN: RESET EMAIL SENT ─────────────────────────────────────────────────
class ResetEmailSentScreen extends StatelessWidget {
  const ResetEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Password Reset'),
            const SizedBox(height: 32),
            const Icon(Icons.check_circle_outline,
                color: kPrimary, size: 64),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: kLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: kBorder),
              ),
              child: const Text(
                'Success',
                style: TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
                3,
                    (i) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 14,
                  decoration: BoxDecoration(
                      color: kBorder,
                      borderRadius: BorderRadius.circular(4)),
                )),
            const SizedBox(height: 16),
            _blueBtn('Login', () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── SCREEN: REGISTRATION ─────────────────────────────────────────────────────
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _f1 = TextEditingController();
  final _f2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _banner('Banner/logo'),
            const SizedBox(height: 16),
            _banner('Register with us'),
            const SizedBox(height: 16),
            _field('Username', ctrl: _user),
            const SizedBox(height: 10),
            _field('Password', obscure: true, ctrl: _pass),
            const SizedBox(height: 10),
            _field('', ctrl: _f1),
            const SizedBox(height: 10),
            _field('', ctrl: _f2),
            const SizedBox(height: 20),
            _blueBtn('Register', () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.phone_outlined, color: kGray, size: 24),
          Icon(Icons.menu, color: kGray, size: 24),
          Icon(Icons.location_on_outlined, color: kGray, size: 24),
        ],
      ),
    );
  }
}