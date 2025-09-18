enum CategoryType {
  makanan,
  minuman,
  kue,
}

// Konversi enum ke string
String categoryToString(CategoryType type) {
  switch (type) {
    case CategoryType.makanan:
      return 'Makanan';
    case CategoryType.minuman:
      return 'Minuman';
    case CategoryType.kue:
      return 'kue';
  }
}

// Konversi string ke enum (kalau nanti butuh)
CategoryType stringToCategory(String value) {
  switch (value.toLowerCase()) {
    case 'makanan':
      return CategoryType.makanan;
    case 'minuman':
      return CategoryType.minuman;
    case 'kue':
      return CategoryType.kue;
    default:
      return CategoryType.makanan;
  }
}
