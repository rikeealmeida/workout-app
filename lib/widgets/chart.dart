// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:workout_app/widgets/chart_bar.dart';

// import '../models/transaction.dart';

// class Chart extends StatelessWidget {
//   const Chart({Key? key, this.recentTransaction}) : super(key: key);

//   final List<Transaction>? recentTransaction;

//   List<Map<String, Object>> get groupedTransactions {
//     return List.generate(7, (index) {
//       final weekDay = DateTime.now().subtract(
//         Duration(
//           days: index,
//         ),
//       );
//       double totalSum = 0.0;
//       for (var i = 0; i < recentTransaction!.length; i++) {
//         bool sameDay = recentTransaction![i].date!.day == weekDay.day;
//         bool sameMonth = recentTransaction![i].date!.month == weekDay.month;
//         bool sameYear = recentTransaction![i].date!.year == weekDay.year;

//         if (sameDay && sameMonth && sameYear) {
//           totalSum += recentTransaction![i].value!;
//         }
//       }
//       return {
//         'day': DateFormat.E().format(weekDay) == 'Tue'
//             ? 'Ter'
//             : DateFormat.E().format(weekDay) == 'Mon'
//                 ? 'Seg'
//                 : DateFormat.E().format(weekDay) == 'Sun'
//                     ? 'Dom'
//                     : DateFormat.E().format(weekDay) == 'Sat'
//                         ? 'Sab'
//                         : DateFormat.E().format(weekDay) == 'Fri'
//                             ? 'Sex'
//                             : DateFormat.E().format(weekDay) == 'Thu'
//                                 ? 'Qui'
//                                 : 'Qua',
//         'value': totalSum,
//       };
//     }).reversed.toList();
//   }

//   double get _weekTotalValue {
//     return groupedTransactions.fold(0.0, (sum, tr) {
//       return sum + tr['value'];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     groupedTransactions;
//     return Card(
//       elevation: 6,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 5,
//         vertical: 3,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: groupedTransactions.map((tr) {
//             return Flexible(
//               fit: FlexFit.tight,
//               child: ChartBar(
//                 label: tr['day'],
//                 value: tr['value'],
//                 percentage: _weekTotalValue == 0
//                     ? 0
//                     : (tr['value'] as double) / _weekTotalValue,
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
