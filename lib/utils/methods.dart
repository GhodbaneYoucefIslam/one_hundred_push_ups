String toPrismaCompatibleIsoStringForDate(DateTime date){
  return "${date.year}-${date.month.toString().padLeft(2,"0")}-${date.day.toString().padLeft(2,"0")}T00:00:00Z";
}