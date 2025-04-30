class GSTCalculator {
  static double calculateCGST(double price, double gstRate) => (price * gstRate / 100) / 2;

  static double calculateSGST(double price, double gstRate) => (price * gstRate / 100) / 2;

  static double totalPrice(double price, double gstRate) =>
      price + calculateCGST(price, gstRate) + calculateSGST(price, gstRate);

  static double calculateItemTotal(double price, double gstRate, int quantity) =>
      totalPrice(price, gstRate) * quantity;
}