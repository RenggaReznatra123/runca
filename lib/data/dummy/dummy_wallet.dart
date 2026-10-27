class DummyWallet {
  int _balance = 10000;

  int get balance => _balance;

  bool spend(int amount) {
    if (amount < 0 || _balance < amount) return false;

    _balance -= amount;
    return true;
  }
}
