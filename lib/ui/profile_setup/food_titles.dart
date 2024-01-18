List<String> allTitles(int category) {
  switch (category) {
    case 1:
      return ['Sushi', 'Teriyaki', 'Udon'];
    case 2:
      return ['Tandoori Chicken', 'Curry', 'Lamb'];
    case 3:
      return ['Spaghetti', 'Risotto', 'Pizza'];
    case 4:
      return ['Humus', 'Kabsa'];
    case 5:
      return ['Pretzel', 'Schnitzel', 'Bier'];
    case 6:
      return [
        'Chicken',
        'Beef',
        'Stew',
        'Pork',
        'Potato',
        'Vegan',
        'Vegetarian'
      ];
    case 7:
      return ['Greek Mousaka', 'Saganaki', 'Tzatziki', 'Gigantes'];
    case 8:
      return ['Tacos', 'Fajitas', 'Enchiladas', 'Flour Tortillas'];
    default:
      return [];
  }
}