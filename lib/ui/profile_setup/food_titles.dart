List<String> allTitles(int category) {
  switch (category) {
    case 1:
      return ['Sushi', 'Teriyaki', 'Udon'];
    case 2:
      return ['Tandoori Chicken', 'Curry', 'Lamb'];
    case 3:
      return ['Spaghetti', 'Risotto'];
    case 4:
      return ['Tacos', 'Fajitas', 'Enchilada', 'Tortilla'];
    case 5:
      return ['Moussaka', 'Saganaki', 'Tzatziki', 'Gigantes'];
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
      return [];
    case 8:
      return [];
    default:
      return [];
  }
}
