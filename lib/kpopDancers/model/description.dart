String buildDescription(Map<String, dynamic> kpopDancer) {
  String description = "Meet ";
  
  if (kpopDancer['stage_name'] != null && kpopDancer['stage_name'] != '') {
    description += "${kpopDancer['stage_name']}, ";
  }

  if (kpopDancer['age'] != null && kpopDancer['age'] != '') {
    description += "a ${kpopDancer['age']}-year-old ";
  }

  if (kpopDancer['sex'] != null  && kpopDancer['sex'] != '') {
    description += "${kpopDancer['sex']} ";
  }

  if (kpopDancer['kgroup'] != null && kpopDancer['kgroup'] != '') {
    description += "from the K-Pop group ${kpopDancer['kgroup']}. ";
  }

  if (kpopDancer['company'] != null && kpopDancer['company'] != '') {
    description += "They are associated with the company ${kpopDancer['company']} and ";
  }

  if (kpopDancer['debut_year'] != null && kpopDancer['debut_year'] != '') {
    description += "made their debut in ${kpopDancer['debut_year']}. ";
  }

  if (kpopDancer['nationality'] != null && kpopDancer['nationality'] != '') {
    description += "${kpopDancer['stage_name']} is of ${kpopDancer['nationality']} nationality.";
  }

  return description;
}
