color ("Olive")
difference () {
	sphere (d=3, $fn=10, center = true);
   cylinder(h = 5, r1 = .1, r2 = .7, $fn=10, center = true);
}
rotate([30, 0, 0]){
cylinder (h = 4, r = .08, $fn=5, center=true);
translate ([0, 0, 2.5])
   cylinder(h = 1, r1 = .08, r2 = .01, $fn=5, center = true);
translate ([0, 0, -2.5])
   cylinder(h = 1, r1 = .01, r2 = .08, $fn=5, center = true);
 }    