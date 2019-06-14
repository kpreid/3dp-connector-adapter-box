wall_thickness = 0.9;
connection_space = 5;

epsilon = 0.01;


printable();


module printable() {
    rotate([90, 0, 0]) {
        design();
        translate([20, 0, 0]) design();
    }
}


module design() {
    connector_adapter_box(bnc_space, trs_space) {
        bnc_112420_neg();
        
        trs_neg();
    }
    
    %position_first_connector(bnc_space) bnc_112420_model();
    %position_second_connector(trs_space) trs_neg();
    
    %color("blue") resistor_model();
}


// Children are two hollows for connector
module connector_adapter_box(a_space, b_space) {
    difference() {
        minkowski() {
            cylinder(d=wall_thickness * 2, h=wall_thickness * 2, center=true, $fn=20);
            interior_volume() { children(0); children(1); }
        }
        
        cutout_volume() { children(0); children(1); }

        translate([-50, 0, -50])
        cube([100, 100, 100]);
    }
        
    module interior_volume() {
        hull() {
            position_first_connector(a_space)
            top_half()
            children(0);
            
            position_second_connector(b_space)
            top_half()
            children(1);
        }
    }
        
    module cutout_volume() {
        union() {
            position_first_connector(a_space)
            children(0);
            
            position_second_connector(b_space)
            children(1);
            
            // connection working space
            hull() {
                intersection() {
                    cube([100, 100, 20], center=true);  // TODO: magic number
                    union() {
                        interior_volume() { children(0); children(1); }
                    }
                }
            }
        }
    }
}

module position_first_connector(space) {
    translate([0, 0, -space]) children();
}
module position_second_connector(space) {
    rotate([180, 0, 0])
    translate([0, 0, -space]) 
    children();
}

module top_half() {
    intersection() {
        translate([-50, -50, 0])
        cube([100, 100, 100]);
        
        children();
    }
}

// Amphenol 112420 per https://www.amphenolrf.com/112420.html
bnc_shell_length = 8.8;
bnc_solder_cup_length = 4.3;
bnc_space = bnc_shell_length + bnc_solder_cup_length + connection_space / 2;
module bnc_112420_neg() {
    // thread clearance
    // TODO ensure tooth-biting fit
    translate([0, 0, -wall_thickness - epsilon])
    cylinder(d=3/8 * 25.4, h=bnc_shell_length + bnc_solder_cup_length, $fn=30);
}
module bnc_112420_model() {
    translate([0, 0, -wall_thickness - epsilon]) {
        cylinder(d=3/8 * 25.4, h=bnc_shell_length, $fn=30);
        cylinder(d=2.1, h=bnc_shell_length + bnc_solder_cup_length, $fn=30);
    }
}

// LJE0352-4R per http://www.fk-industrie.de/downloads/LJE0352s.pdf
trs_length = 13.5 + 4.0;  // from datasheet
trs_box_d1 = 11.2;  // asymmetric, max extent is 5.5 from center
trs_box_d2 = 9.2;  // 9.0 + tolerance added
trs_space = trs_length + connection_space / 2;
module trs_neg() {
    // thread area
    translate([0, 0, -3.5 + epsilon])
    cylinder(d=8.1, h=3.5, $fn=30);
    
    // box area
    translate([-trs_box_d1 / 2, -trs_box_d2 / 2, 0])
    cube([trs_box_d1, trs_box_d2, trs_length]);
}

// 1/8 W resistor
module resistor_model() {
    cylinder(d=2, h=4, center=true, $fn=12);
    cylinder(d=0.5, h=4 + 25.4 * 0.2, center=true, $fn=6);
}
