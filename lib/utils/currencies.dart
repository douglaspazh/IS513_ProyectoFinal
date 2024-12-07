const Map<String, String> currencies = {
  'HNL': 'Lempira hondureño',
  'USD': 'Dólar estadounidense',
  'EUR': 'Euro',
  'BTC': 'Bitcoin',
  'ETH': 'Ethereum',
};

const Map<String, String> currencySymbols = {
  'HNL': 'L',
  'USD': '\$',
  'EUR': '€',
  'BTC': '₿',
  'ETH': 'Ξ',
};

String getCurrencyName(String currency) {
  return currencies[currency] ?? 'Desconocido';
}

String getCurrencySymbol(String currency) {
  return currencySymbols[currency] ?? '';
}
