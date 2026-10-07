/Memory Mapped
(.z.d+2) mod 4 / How it calculate ? convert date in int (Days from 2000.01.01) and then perform the operation

// Weekday always start with Saturday BCZ 2000.01.01 is falls on Saturday
// So 0 and 1 are weekend and 2-6 are week days

// in cmd
// training>> mkdir seghdb
// training>> mkdir segs
// training>> cd segs
// training/segs>> mkdir seg1
// training/segs>> mkdir seg2
// training/segs>> mkdir seg3
// training/segs>> mkdir seg4



func:{[s;d;st;et] select from trades where date=d,sym=s,time.time within st et}
func;[`IBM;2026.09.29;09:00;09:01]
